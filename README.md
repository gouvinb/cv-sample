# Cv-sample

## Alternative curriculum vitae/résumé class with github.com/liantze/AltaCV and a fork of gitlab.com/Titan-C/org-cv

TODO

## Installation

This project is not on MELPA so you have to do a manual installation. First clone this git
repository.

```bash
$ git clone --recurse-submodules https://github.com/gouvinb/cv-sample.git
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

TODO

## License

See [LICENSE.md](LICENSE.md)
