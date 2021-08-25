# Cv-sample

## Alternative curriculum vitae/résumé class with AltaCV and a fork of org-cv

Cv-sample is an org file for generating a resume when saving. It is based on
[AltaCV](https://github.com/liantze/AltaCV) and inspired by
[org-cv](https://gitlab.com/Titan-C/org-cv).

The main goal of this project is to write a resume with the org syntax.

## Demo

![Demo (duplicate frames dropped)](assets/demo.gif "Demo (duplicate frames dropped)")

## Requirements

- Emacs 27+
  - org-mode
  - ox-extra

## Installation and start-up project

```bash
$ git clone --recurse-submodules https://github.com/gouvinb/cv-sample.git
$ cd cv-sample
$ emacs resume.org 
```

## Basic Org file

The basic structure of an org file containing your CV is shown next.

### Personal contact information

```org
#+AUTHOR:   Your name Here
#+TITLE:    Your Position or Tagline Here

#+PHOTO:    assets/photo.png

#+email:    your_name@email.com
#+MOBILE:   000-00-0000
#+ADDRESS:  Address Street
#+ADDRESS:  00000 Country
#+HOMEPAGE: www.homepage.com
#+GITHUB:   your_id
#+GITLAB:   your_id
#+LINKEDIN: your_id
```

You can use org-modes hierarchical structure to describe your CV. To make a specific subtree an item
describing an experience point (Job you have, degree you pursued, etc.) you use the org properties
drawer and with the `:CV_ENV: cventry` property. You should also include the `FROM` and `TO`
properties defining the span of the event, as `LOCATION` and `EMPLOYER`.

```org
* Employement

** One job
:PROPERTIES:
:CV_ENV: cventry
:FROM:     <2014-09-01>
:TO:     <2017-12-07>
:LOCATION: a city, a country
:EMPLOYER: The employer
:END:

I write about awesome stuff I do.

** Other job
:PROPERTIES:
:CV_ENV: cventry
:FROM:     <2013-09-01>
:TO:     <2014-08-07>
:LOCATION: my city, your country
:EMPLOYER: The other employer
:END:

I write about awesome stuff I do.

* Other stuff I do

- I work a lot
- I sleep a lot
- I eat a lot
```

## Latex Exporter

The style of this CV is more involved and you need some configuration in `headers.org` file to get
it to work.

First define the margins, the large margin to the right is to allow for a second column.

```org
#+LATEX_HEADER: \geometry{
#+LATEX_HEADER:   left=1cm,
#+LATEX_HEADER:   right=8.5cm,
#+LATEX_HEADER:   marginparwidth=6.5cm,
#+LATEX_HEADER:   marginparsep=1cm,
#+LATEX_HEADER:   top=1cm,
#+LATEX_HEADER:   bottom=1cm
#+LATEX_HEADER:  }
```

Then define the fonts and their colors.

```org
#+LATEX_HEADER: % Change the font if you want to, depending on whether
#+LATEX_HEADER: % you're using pdflatex or xelatex/lualatex
#+LATEX_HEADER: \ifxetexorluatex
#+LATEX_HEADER:   % If using xelatex or lualatex:
#+LATEX_HEADER:   \setmainfont{Roboto Slab}
#+LATEX_HEADER:   \setsansfont{Lato}
#+LATEX_HEADER:   \renewcommand{\familydefault}{\sfdefault}
#+LATEX_HEADER: \else
#+LATEX_HEADER:   % If using pdflatex:
#+LATEX_HEADER:   \usepackage[rm]{roboto}
#+LATEX_HEADER:   \usepackage[defaultsans]{lato}
#+LATEX_HEADER:   % \usepackage{sourcesanspro}
#+LATEX_HEADER:   \renewcommand{\familydefault}{\sfdefault}
#+LATEX_HEADER: \fi

#+LATEX_HEADER: \definecolor{colorPrimary}{HTML}{3ddb84}
#+LATEX_HEADER: \definecolor{colorPrimaryVariant}{HTML}{052409}
#+LATEX_HEADER: \definecolor{colorOnPrimary}{HTML}{FFFFFF}
#+LATEX_HEADER: \definecolor{colorSecondary}{HTML}{4387f4}
#+LATEX_HEADER: \definecolor{colorSecondaryVariant}{HTML}{072f41}
#+LATEX_HEADER: \definecolor{colorOnSecondary}{HTML}{000000}
#+LATEX_HEADER: \definecolor{colorBackground}{HTML}{FFFFFF}
#+LATEX_HEADER: \definecolor{colorOnBackground}{HTML}{000000}
#+LATEX_HEADER: \definecolor{colorSurface}{HTML}{FFFFFF}
#+LATEX_HEADER: \definecolor{colorOnSurface}{HTML}{000000}
#+LATEX_HEADER: \definecolor{colorError}{HTML}{B00020}
#+LATEX_HEADER: \definecolor{colorOnError}{HTML}{FFFFFF}

#+LATEX_HEADER: \colorlet{accent}{colorSecondary}
#+LATEX_HEADER: \colorlet{emphasis}{colorPrimaryVariant}
#+LATEX_HEADER: \colorlet{heading}{colorPrimary}
#+LATEX_HEADER: \colorlet{headingrule}{colorPrimary}
#+LATEX_HEADER: \colorlet{subheading}{colorPrimaryVariant}
#+LATEX_HEADER: \colorlet{body}{colorOnSurface}
#+LATEX_HEADER: \colorlet{name}{colorOnSurface}
#+LATEX_HEADER: \colorlet{tagline}{colorSecondary}
#+LATEX_HEADER: \hypersetup{
#+LATEX_HEADER:   colorlinks=true,
#+LATEX_HEADER:   linkcolor={colorSecondaryVariant},
#+LATEX_HEADER:   anchorcolor={colorSecondaryVariant},
#+LATEX_HEADER:   citecolor={colorSecondaryVariant},
#+LATEX_HEADER:   filecolor={colorSecondaryVariant},
#+LATEX_HEADER:   menucolor={colorSecondaryVariant},
#+LATEX_HEADER:   runcolor={colorSecondaryVariant},
#+LATEX_HEADER:   urlcolor={colorSecondaryVariant},
#+LATEX_HEADER: }

#+LATEX_HEADER: % Change some fonts, if necessary
#+LATEX_HEADER: \renewcommand{\namefont}{\Huge\rmfamily\bfseries}
#+LATEX_HEADER: \renewcommand{\personalinfofont}{\footnotesize}
#+LATEX_HEADER: \renewcommand{\cvsectionfont}{\LARGE\rmfamily\bfseries}
#+LATEX_HEADER: \renewcommand{\cvsubsectionfont}{\large\bfseries}
```

You can change the bullets for the itemize and rating marker.

```org
#+LATEX_HEADER: % Change the bullets for itemize and rating marker
#+LATEX_HEADER: % for \cvskill if you want to
#+LATEX_HEADER: \renewcommand{\itemmarker}{{\small\textbullet}}
#+LATEX_HEADER: \renewcommand{\ratingmarker}{\faCircle}
```

## License

See [LICENSE.md](LICENSE.md)
