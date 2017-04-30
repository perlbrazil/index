% BibTeX standard bibliography style `unsrt'
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1985, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
	% This restriction helps ensure that all standard styles are identical.
	% The file btxbst.doc has the documentation for this style.

ENTRY
  { address
    author
    booktitle
    chapter
    conference
    caddress
    cnumber
    csubtitle
    ctitle
    cyear
    day
    edition
    editor
    howpublished
    institution
    internetaddress
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    subtitle
    title
    type
    volume
    year
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {check}
{ 't :=
  empty$
    { "empty " t * " in " * cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {vol.field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    { "v. " swap$ *}
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  { namesleft #0 > }
      { s nameptr "{vv~}{ll}{, jj}{, f.}" format.name$ 't :=
      t "u" change.case$ 't :=
         nameptr #1 >
	    { namesleft #1 >
	        { "; " * t * }
	        { t "OTHERS" =
		   { " et~al." * }
		   { "; " * t * }
	          if$
	        }
	       if$
	     }
            't
          if$
    nameptr #1 + 'nameptr :=
    namesleft #1 - 'namesleft :=
  }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
	{ " (Eds.)" * }
	{ " (Ed.)" * }
      if$
    }
  if$
}

FUNCTION {format.ceditors}
{ editor empty$
    { "there is no editor in " cite$ * warning$
      "" }
    { editor format.names 't :=
      editor num.names$ #1 >
	{ "Editors " t * }
	{ "Editor " t * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}

FUNCTION {format.cnumber}
{ cnumber empty$
    { "there is no cnumber in " cite$ * warning$
      "" }
    { cnumber "." * }
  if$
}

INTEGERS { a b ab }

FUNCTION {int.mult}
{ #0 'ab :=
  'b :=
  'a :=
  { a }
  { b ab + 'ab :=
    a #1 - 'a := }
  while$
  ab
}
  
INTEGERS { year_numb }

% converts the year field to an integer
FUNCTION {convert}
{ year text.length$ #4 =
    { year #1 #1 substring$ "1" =
	{ #1000 'year_numb := }
	{ #2000 'year_numb := }
      if$
      year #2 #1 substring$ chr.to.int$ #48 -
      #100
      int.mult year_numb + 'year_numb :=
      year #3 #1 substring$ chr.to.int$ #48 -
      #10
      int.mult year_numb + 'year_numb :=
      year #4 #1 substring$ chr.to.int$ #48 -
      #1
      int.mult year_numb + 'year_numb :=
      year_numb
     }
    { "the year in " cite$ * " doesn't have 4 digits" * warning$ }
  if$
}

FUNCTION {format.address_a}
{     journal "Acta Crystallographica A" =
        { pop$ "Kobenhavn" }
        { skip$ }
      if$
      journal "Acta Microscopica" =
        { pop$ "Rio de Janeiro" }
        { skip$ }
      if$
      journal "Acta Physica Polonica A" =
        { pop$ "Krakow" }
        { skip$ }
      if$
      journal "Acta Psychologica" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Advances in Chromatography" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Advances in Physics" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Advances in Space Research" =
        { pop$ "Oxford" }
        { skip$ }
      if$
      journal "Advances in Theoretical and Mathematical Physics" =
        { pop$ "Cambridge" }
        { skip$ }
      if$
      journal "American Biology Teacher" =
        { pop$ "Reston" }
        { skip$ }
      if$
      journal "American Journal of Clinical Nutrition" =
        { pop$ "Bethesda" }
        { skip$ }
      if$
      journal "American Journal of Physics" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "American Psychologist" =
        { pop$ "Washington" }
        { skip$ }
      if$
}

FUNCTION {format.address_b}
{     journal "Annals of Physics" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Applied Optics" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Applied Physics A" =
        { pop$ "Berlin" }
        { skip$ }
      if$
      journal "Applied Physics B" =
        { pop$ "Berlin" }
        { skip$ }
      if$
      journal "Applied Physics Letters" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Ark Mat. Astron. Fys." =
        { pop$ "Stockholm" }
        { skip$ }
      if$
      journal "Artificial Intelligence" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Astronomical Journal" =
        { pop$ "Chicago" }
        { skip$ }
      if$
      journal "Astronomy and Astrophysics" =
        { pop$ "Berlin" }
        { skip$ }
      if$
      journal "Astronomy and Astrophysics Supplement Series" =
        { pop$ "Orsay" }
        { skip$ }
      if$
      journal "Astrophysical and Space Science" =
        { pop$ "Dordrecht" }
        { skip$ }
      if$
      journal "Astrophysical Journal" =
        { pop$ "Chicago" }
        { skip$ }
      if$
}

FUNCTION {format.address_c}
{     journal "Astrophysical Journal Supplement Series" =
        { pop$ "Chicago" }
        { skip$ }
      if$
      journal "Baltic Astronomy" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Behavioral Neuroscience" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Biochimica et Biophysica Acta" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Biopolymers" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Boletim da Sociedade Astronomica Brasileira" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Boletim da Sociedade Brasileira de Matemática" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Boletin de la Academia Nacional de Ciencias" =
        { pop$ "Córdoba" }
        { skip$ }
      if$
      journal "Brazilian Journal of Medical and Biological Research" =
        { pop$ "Ribeirão Preto" }
        { skip$ }
      if$
      journal "Brazilian Journal of Physics" =
        { pop$ "São Paulo" }
        { skip$ }
      if$
      journal "British Journal of Educational Psychology" =
        { pop$ "Leicester" }
        { skip$ }
      if$
      journal "Bulletin of Chemical Society of Japan" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
}

FUNCTION {format.address_d}
{     journal "Caderno Catarinense de Ensino de Física" =
        { pop$ "Florianópolis" }
        { skip$ }
      if$
      journal "Chaos Solitons Fractals" =
        { pop$ "Oxford" }
        { skip$ }
      if$
      journal "Chemical Physics Letters" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Ciência Hoje" =
        { pop$ "Rio de Janeiro" }
        { skip$ }
      if$
      journal "Cognition" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Cognition and Instruction" =
        { pop$ "Mahwah" }
        { skip$ }
      if$
      journal "Cognitive Psychology" =
        { pop$ "San Diego" }
        { skip$ }
      if$
      journal "Developmental Psychology" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Diamond and Related Materials" =
        { pop$ "Lausanne" }
        { skip$ }
      if$
      journal "Educational and Psychological Measurement" =
        { pop$ "Thousand Oaks" }
        { skip$ }
      if$
      journal "Educational Psychologist" =
        { pop$ "Mahwah" }
        { skip$ }
      if$
}

FUNCTION {format.address_e}
{     journal "Educational Psychology" =
        { pop$ "Abingdon" }
        { skip$ }
      if$
      journal "Electrophoresis" =
        { pop$ "Weinheim" }
        { skip$ }
      if$
      journal "Engineering Education" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Ensaio: pesquisa em educação em ciências" =
        { pop$ "Belo Horizonte" }
        { skip$ }
      if$
      journal "Enseñanza de las Ciencias" =
        { pop$ "Barcelona" }
        { skip$ }
      if$
      journal "Epistéme	Epistéme" =
        { pop$ "Porto Alegre" }
        { skip$ }
      if$
      journal "European Journal of Physics" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "European Journal of Science Education" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Europhysics Letters" =
        { pop$ "Les Ulis" }
        { skip$ }
      if$
      journal "Fluid Phase Equilibria" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Forensic Science International" =
        { pop$ "Limerick" }
        { skip$ }
      if$
      journal "Fullerene Science and Technology" =
        { pop$ "New York" }
        { skip$ }
      if$
}

FUNCTION {format.address_f}
{      journal "Helvetica Physica Acta" =
        { pop$ "Basel" }
        { skip$ }
      if$
      journal "High Pressure Research" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Hyperfine Interactions" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "IEEE Transactions on Electron Devices" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "IEEE Transactions on Magnetics" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Instructional Science" =
        { pop$ "Dordrecht" }
        { skip$ }
      if$
      journal "International Journal of Bifurcation Chaos" =
        { pop$ "Singapore" }
        { skip$ }
      if$
      journal "International Journal of Modern Physics A" =
        { pop$ "Singapore" }
        { skip$ }
      if$
      journal "International Journal of Neural Systems" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "International Journal of Science Education" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Investigación en la Escuela" =
        { pop$ "Seville" }
        { skip$ }
      if$
}

FUNCTION {format.address_g}
{     journal "Investigações em Ensino de Ciências" =		
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal de Physique I" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of Alloys and Compounds" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of American Ceramical Society" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of Applied Physics" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Journal of Applied Polymer Science" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Journal of Chemical Physics" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Journal of Chromatographic Science" =
        { pop$ "Niles" }
        { skip$ }
      if$
      journal "Journal of Chromatography" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
}

FUNCTION {format.address_h}
{     journal "Journal of Chromatography A" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Journal of Colloid and Interface Science" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Journal of Forensic Sciences" =
        { pop$ "Philadelphia" }
        { skip$ }
      if$
      journal "Journal of Geophysical Research" =
        { pop$ "Washinton" }
        { skip$ }
      if$
      journal "Journal of Magnetism and Magnetic Materials" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Journal of Materials Research" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of Mathematical Physics" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Journal of Non-Crystalline Solids" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Journal of Nonlinear Optical Physics and Materials" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
}

FUNCTION {format.address_i}
{     journal "Journal of Optics B: Quantum and Semiclassical Optics" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Journal of Physical Chemistry" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Journal of Physics A" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Journal of Physics and Chemistry of Solids" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of Physics B" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Journal of Physics D" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Journal of Physics G" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Journal of Physics: Condensed Matter" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Journal of Plasma Physics" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Journal of Polymer Science" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Journal of Research in Science Teaching" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Journal of Research of the National Institute of Standards and Technology" =
        { pop$ "Washington" }
        { skip$ }
      if$
}

FUNCTION {format.address_j}
{     journal "Journal of Sol-Gel Science Technology" =
        { pop$ "Dordrecht" }
        { skip$ }
      if$
      journal "Journal of Solid State Chemistry" =
        { pop$ "Orlando" }
        { skip$ }
      if$
      journal "Journal of Solid-State Device Circuits" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of Statistical Physics" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Journal of Synchrotron Radiation" =
        { pop$ "Copenhagen" }
        { skip$ }
      if$
      journal "Journal of the American Chemical Society" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Journal of the Chemical Society" =
        { pop$ "Cambridge" }
        { skip$ }
      if$
      journal "Journal of the Electrochemical Society" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of the Optical Society of America A" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of the Optical Society of America B" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Journal of the Vacuum Science and Technology A" =
        { pop$ "Woodbury" }
        { skip$ }
      if$
}

FUNCTION {format.address_l}
{     journal "Langmuir" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Learning Instruction" =		
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Linear Chain Physical Review" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Linguistic Inquiry" =
        { pop$ "Cambridge" }
        { skip$ }
      if$
      journal "Macromolecules" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Materials Science and Engineering A" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Materials Science and Engineering R: Reports" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Messenger" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Modelling and Simulation in Materials Science and Engineering" =
        { pop$ "Bristol" }
        { skip$ }
      if$
      journal "Modern Physics Letters A" =
        { pop$ "Singapore" }
        { skip$ }
      if$
      journal "Molecular Membrane Biology" =
        { pop$ "Basingstoke" }
        { skip$ }
      if$
}

FUNCTION {format.address_m}
{     journal "Monthly Notices of the Royal Astronomical Society" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Nature" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Neural Computation" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Nuclear Instruments and Methods in Physics Research B" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
     journal "Nuclear Physics A" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Nuclear Physics B" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Nuclear Physics B: Proceedings Supplement" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
}

FUNCTION {format.address_n}
{     journal "Nuovo Cimento D" =
        { pop$ "Bologna" }
        { skip$ }
      if$
      journal "Optics Communications" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Philosophical Magazine A" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "Physica A" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physica B" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physica C" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physica D" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physica E" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physica Scripta" =
        { pop$ "Stockholm" }
        { skip$ }
      if$
      journal "Physica Status Solidi A" =
        { pop$ "Berlin" }
        { skip$ }
      if$
}

FUNCTION {format.address_o}
{     journal "Physica Status Solidi B" =
        { pop$ "Berlin" }
        { skip$ }
      if$
      journal "Physical Review" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Physical Review A" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Physical Review Letters" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Physics Letters A" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physics Letters B" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Physics of Plasmas" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
}

FUNCTION {format.address_p}
{     journal "Plasma Physics and Controlled Fusion" =
        { pop$ "" }
        { skip$ }
      if$
      journal "Polymer" =
        { pop$ "Oxford" }
        { skip$ }
      if$
      journal "Proceedings of SPIE" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Proceedings of the National Academy of Sciences of the United States of America" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Progress of Theoretical Physics" =
        { pop$ "Kyoto" }
        { skip$ }
      if$
      journal "Psychological Bulletin" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Psychological Review" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Psychological Science" =
        { pop$ "Cambridge" }
        { skip$ }
      if$
      journal "Publications of the Astronomical Society of the Pacific" =
        { pop$ "Chicago" }
        { skip$ }
      if$
}

FUNCTION {format.address_q}
{     journal "Pure and Applied Chemistry" =
        { pop$ "Boca Raton" }
        { skip$ }
      if$
      journal "Quarterly Review of Biology" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Química Nova" =
        { pop$ "São Paulo" }
        { skip$ }
      if$
      journal "Radiation Effects and Defects Solids" =
        { pop$ "Yverdon" }
        { skip$ }
      if$
      journal "Review of Educational Research" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Review of Scientific Instruments" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Reviews of Modern Physics" =
        { convert #1984 <
	   { pop$ "New York" }
	   { pop$ "Woodbury" }
	  if$
	}
        { skip$ }
      if$
      journal "Revista Brasileira de Aplicações em Vácuo" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Revista Brasileira de Ensino de Física" =
        { pop$ "São Paulo" }
        { skip$ }
      if$
      journal "Revista de Administração Pública" =
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
}

FUNCTION {format.address_r}
{     journal "Revista de Enseñanza de la Física" =
        { pop$ "Rosario" }
        { skip$ }
      if$
      journal "Revista de Ensino de Física" =
        { pop$ "São Paulo" }
        { skip$ }
      if$
      journal "Revista Mexicana de Astronomía y Astrofísica" =
        { pop$ "Mexico" }
        { skip$ }
      if$
      journal "Revista Perfil" =
        { pop$ "Porto Alegre" }
        { skip$ }
      if$
      journal "Russian Mathematical Surveys" =
        { pop$ "London" }
        { skip$ }
      if$
      journal "School Science and Mathematics" =
        { pop$ "Blacksburg" }
        { skip$ }
      if$
      journal "Science" =
        { pop$ "Washington" }
        { skip$ }
      if$
      journal "Science Education" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Scripta Materials" =
        { pop$ "Oxford" }
        { skip$ }
      if$
      journal "Sensors and Actuators B" =
        { pop$ "Lausanne" }
        { skip$ }
      if$
}

FUNCTION {format.address_s}
{     journal "Solid State Communications" =
        { pop$ "Oxford" }
        { skip$ }
      if$
      journal "Solid State Ionics" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Soviet Journal of Nuclear Physics" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Studies in Science Education" =	
        { pop$ "" "there is no city corresponding to " journal * warning$ }
        { skip$ }
      if$
      journal "Surface and Coatings Technology" =
        { pop$ "Lausanne" }
        { skip$ }
      if$
      journal "Surveys High Energy Physics" =
        { pop$ "Chur" }
        { skip$ }
      if$
      journal "The European Physical Journal A" =
        { pop$ "Les Ulis" }
        { skip$ }
      if$
      journal "The European Physical Journal B" =
        { pop$ "Les Ulis" }
        { skip$ }
      if$
      journal "The European Physical Journal C" =
        { pop$ "Les Ulis" }
        { skip$ }
      if$
      journal "The Journal of Gemmology" =
        { pop$ "London" }
        { skip$ }
      if$
}

FUNCTION {format.address_t}
{     journal "The Physics Teacher" =
        { pop$ "Stony Brook" }
        { skip$ }
      if$
      journal "Theoretical Mathematical Physics" =
        { pop$ "New York" }
        { skip$ }
      if$
      journal "Thin Solid Films" =
        { pop$ "Amsterdam" }
        { skip$ }
      if$
      journal "Vacuum" =
        { pop$ "Zhenkog" }
        { skip$ }
      if$
%      journal "Zeitschrift f{\"u}r Physik A" =
%        { pop$ "Berlin" }
%        { skip$ }
%      if$
%      journal "Zeitschrift f{\"u}r Physik B" =
%        { pop$ "Berlin" }
%        { skip$ }
%      if$
%      journal "Zeitschrift f{\"u}r Physik C" =
%        { pop$ "Berlin" }
%        { skip$ }
%      if$
}

FUNCTION {format.address}
{ address empty$
    { ""
      format.address_a
      format.address_b
      format.address_c
      format.address_d
      format.address_e
      format.address_f
      format.address_g
      format.address_h
      format.address_i
      format.address_j
      format.address_l
      format.address_m
      format.address_n
      format.address_o
      format.address_p
      format.address_q
      format.address_r
      format.address_s
      format.address_t
    }
    { address }
  if$
}

FUNCTION {format.address.publisher}
{ address empty$
    { "there is no address in " cite$ * warning$
      "" }
    { address ": " * }
  if$
  publisher empty$
    { "there is no publisher in " cite$ * warning$
      "" * }
    { publisher * }
  if$
}

FUNCTION {format.address.school}
{ address empty$
    { "" }
    { address ", " * }
  if$
  school empty$
    { "" * }
    { school * }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
	'year
	{ month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.cdate}
{ year empty$
    { "there is no year in " cite$ * warning$
      "" }
    { "c" year * }
  if$
}

FUNCTION {format.html.date}
{ ""
  day empty$
    { "there's no day in " cite$ * warning$
      month empty$
        { "there's no month in " cite$ * warning$
          year empty$
            { "there's no year in " cite$ * warning$ }
            { pop$ year }
          if$
        }
        { pop$ month
          year empty$
            { "there's no year in " cite$ * warning$ }
            { " " * year * }
          if$
        }
      if$
    }
    { pop$ day
      month empty$
        { "there's no month in " cite$ * warning$
          year empty$
            { "there's no year in " cite$ * warning$ }
            { " " * year * }
          if$
        }
        { " " * month *
          year empty$
            { "there's no year in " cite$ * warning$ }
            { " " * year * }
          if$
        }
      if$
    }
  if$ %stack$
}

FUNCTION {format.btitle}
{ title empty$
    { "" }
    { title "t" change.case$ emphasize }
  if$
  subtitle empty$
    { "" * }
    { ": " * subtitle "l" change.case$ * }
  if$
}

FUNCTION {format.ctitle}
{ ctitle empty$
    { "there is no ctitle in " cite$ * warning$
      "" }
    { ctitle "t" change.case$ emphasize }
  if$
  csubtitle empty$
    { "" * }
    { ": " * csubtitle "l" change.case$ * }
  if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "v. " volume tie.or.space.connect
      series empty$
	'skip$
	{ " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ ". ed." * }
	{ edition "t" change.case$ ". ed." * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "p." pages n.dashify tie.or.space.connect }
	{ "p." pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume vol.field.or.null
  number empty$
    'skip$
    { ", n. " number * "" * *
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ ", \newblock p. " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "Cap. " }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "In: " booktitle emphasize *
          subtitle empty$
            { "" * }
            { ": " * subtitle "t" change.case$ * }
          if$
        }
	{ "In: " format.editors * " " * booktitle emphasize *
          subtitle empty$
            { "" * }
            { ": " * subtitle "t" change.case$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type_original}
{ type empty$
    { school empty$
        { skip$ }
        { " -- " * school * }
      if$
    }
    { pop$
      type "t" change.case$ " -- " *
      school empty$
        { skip$ }
        { " -- " * school * }
      if$
    }
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    { school empty$
        { skip$ }
        { " -- " * school * }
      if$
    }
    { pop$
      type "t" change.case$ " -- " *
      school empty$
        { skip$ }
        { " -- " * school * }
      if$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}


FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  journal emphasize "journal" output.check
  format.address "address" output.check
  format.vol.num.pages output
  format.date "month and year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      "author and editor" editor either.or.check
    }
  if$
  new.block
  format.btitle "title" output.check
  new.block
  format.edition output
  format.number.series output
  new.sentence
  format.address.publisher "address and publisher" output.check
  format.date "year" output.check
  new.block
  format.bvolume output
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {internet}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  internetaddress "internetaddress" output.check
  new.block
  format.html.date output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      "author and editor" editor either.or.check
    }
  if$
  new.block
  format.btitle "title" output.check
  new.block
  format.edition output
  format.number.series output
  new.sentence
  format.address.publisher "address and publisher" output.check
  format.date "year" output.check
  new.block
  format.bvolume output
  format.chapter.pages "chapter and pages" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.in.ed.booktitle "booktitle" output.check
  format.number.series output
  new.sentence
  address ": " * publisher * output
  format.edition output
  format.date "year" output.check
  new.sentence
  format.bvolume output
  format.chapter.pages output
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  conference empty$
    { "In: " output.nonnull
      conference "conference" output.check
    }
    { "In: " conference * output.nonnull}
  if$
  format.cnumber output
  cyear "cyear" output.check
  caddress "caddress" output.check
  new.block
  format.ctitle output
  new.block
  format.ceditors output
  new.block
  format.edition output
  format.number.series output
  new.sentence
  format.address.publisher "address and publisher" output.check
  format.cdate output
  new.block
  format.bvolume output
  new.block
  format.pages output
  note output
  fin.entry
}

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  format.date "year" output.check
  new.block
  format.pages "pages" output.check
  new.block
  "Disserta\c{c}\~ao (Mestrado em F\'{\i}sica) - " "type" output.check
  before.all 'output.state :=
  school "school" output.check
  address "address" output.check
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  format.date "year" output.check
  new.block
  format.pages "pages" output.check
  new.block
  "Tese (Doutorado em F\'{\i}sica) - " "type" output.check
  before.all 'output.state :=
  school "school" output.check
  address "address" output.check
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  conference "conference" output.check
  format.cnumber output
  cyear "cyear" output.check
  caddress "caddress" output.check
  new.block
  format.ctitle output
  new.block
  format.ceditors output
  new.block
  format.edition output
  format.number.series output
  new.sentence
  format.address.publisher "address and publisher" output.check
  format.cdate output
  new.block
  format.bvolume output
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"Jan."}

MACRO {feb} {"Feb."}

MACRO {mar} {"Mar."}

MACRO {apr} {"Apr."}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"Aug."}

MACRO {sep} {"Sept."}

MACRO {oct} {"Oct."}

MACRO {nov} {"Nov."}

MACRO {dec} {"Dec."}

MACRO {actapola} {"Acta Physica Polonica A"}

MACRO {actapolb} {"Acta Physica Polonica B"}

MACRO {advnuclp} {"Advances in Nuclear Physics"}

MACRO {amjp} {"American Journal of Physics"}

MACRO {annphys} {"Annals of Physics"}

MACRO {arnps} {"Annual Review of Nuclear and Particle Science"}

MACRO {canjphys} {"Canadian Journal of Physics"}

MACRO {commnuclp} {"Comments on Nuclear and Particle Physics"}

MACRO {npa} {"Nuclear Physics A"}

MACRO {npb} {"Nuclear Physics B"}

MACRO {npc} {"Nuclear Physics C"}

MACRO {npd} {"Nuclear Physics D"}

MACRO {pla} {"Physics Letters A"}

MACRO {plb} {"Physics Letters B"}

MACRO {physrep} {"Physics Reports"}

MACRO {physrepc} {"Physics Reports C"}

MACRO {pr} {"Physical Review"}

MACRO {pra} {"Physical Review A"}

MACRO {prb} {"Physical Review B"}

MACRO {prc} {"Physical Review C"}

MACRO {prd} {"Physical Review D"}

MACRO {pre} {"Physical Review E"}

MACRO {progtheophys} {"Progress of Theoretical Physics"}

%MACRO {zfpa} {"Zeitschrift f{\"{u}}r Physik A"}

%MACRO {zfpb} {"Zeitschrift f{\"u}r Physik B"}

%MACRO {zfpc} {"Zeitschrift f{\"u}r Physik C"}


READ

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}






