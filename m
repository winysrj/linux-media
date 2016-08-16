Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56830
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbcHPJgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 05:36:12 -0400
Date: Tue, 16 Aug 2016 06:36:05 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on
 LaTeX/PDF output
Message-ID: <20160816063605.6ef0ed27@vento.lan>
In-Reply-To: <4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
References: <cover.1471294965.git.mchehab@s-opensource.com>
	<5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
	<4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Aug 2016 10:27:34 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 15.08.2016 um 23:21 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > pdflatex doesn't accept using some UTF-8 chars, like
> > "equal or less than" or "equal or greater than" chars. However,
> > the media documents use them. So, we need to use XeLaTeX for
> > conversion, and a font that accepts such characters.  
> 
> Right, we should use the XeLaTeX engine. But ...
> 
> Sphinx LaTeX output was/is developed for LaTeX, not for XeLaTeX.

Yes, but official support for XeLaTeX was added for 1.5:
	https://github.com/agda/agda/commit/a6a437316c9b9d998e6d6d0a6a654a63422a4212

And the change there was really simple: it just adds it to the generated
Makefile.

> E.g. in its defaults it uses "inputenc" and other stuff which
> is not a part of XeLaTeX.
> 
> * https://github.com/sphinx-doc/sphinx/issues/894#issuecomment-220786426
> 
> This patch removes the "inputenc", thats right, but I think over
> short/long term we will see more errors related to LaTeX/XeLaTeX
> distinction. 

Actually, I don't expect troubles at long term, as it is now officially
supported.

> And we will see that some conversion will break, depending
> on the sphinx version we use (There might be some non XeLateX friendly 
> changes in the sphinx-versions, since it is not tested with XeLaTeX).

Yeah, we need to double-check backward compatibility, and eventually
disable it on older versions.

I can't easily test version 1.3.x anymore, as Fedora 24 upgraded to
Sphinx 1.4.4. The book builds fine on both 1.4.4 and 1.4.5.

I'll install a Debian Jessie LXC container and double-check if the build
is fine with Sphinx version 1.2.x and check the package requirements.

>    Nevertheless, XeLaTeX is the right choice!
> 
> My Suggestion is, that you merge this patch on top of Jon's doc-next. 
> There, we have the sub-folders feature, with we can test book by book
> and improve our toolchain.
> 
> -- Markus --
> 
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> > Documentation/Makefile.sphinx |  6 +++---
> > Documentation/conf.py         | 11 +++++++++++
> > 2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
> > index fc29e08085aa..aa7ff32be589 100644
> > --- a/Documentation/Makefile.sphinx
> > +++ b/Documentation/Makefile.sphinx
> > @@ -26,7 +26,7 @@ else ifneq ($(DOCBOOKS),)
> > else # HAVE_SPHINX
> > 
> > # User-friendly check for pdflatex
> > -HAVE_PDFLATEX := $(shell if which pdflatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
> > +HAVE_PDFLATEX := $(shell if which xelatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
> > 
> > # Internal variables.
> > PAPEROPT_a4     = -D latex_paper_size=a4
> > @@ -45,11 +45,11 @@ htmldocs:
> > 
> > pdfdocs:
> > ifeq ($(HAVE_PDFLATEX),0)
> > -	$(warning The 'pdflatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
> > +	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
> > 	@echo "  SKIP    Sphinx $@ target."
> > else # HAVE_PDFLATEX
> > 	$(call cmd,sphinx,latex)
> > -	$(Q)$(MAKE) -C $(BUILDDIR)/latex
> > +	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
> > endif # HAVE_PDFLATEX
> > 
> > epubdocs:
> > diff --git a/Documentation/conf.py b/Documentation/conf.py
> > index bbf2878d9945..f4469cd0340d 100644
> > --- a/Documentation/conf.py
> > +++ b/Documentation/conf.py
> > @@ -260,6 +260,10 @@ latex_elements = {
> > # Latex figure (float) alignment
> > #'figure_align': 'htbp',
> > 
> > +# Don't mangle with UTF-8 chars
> > +'inputenc': '',
> > +'utf8extra': '',
> > +
> > # Additional stuff for the LaTeX preamble.
> >     'preamble': '''
> >         % Allow generate some pages in landscape
> > @@ -287,6 +291,13 @@ latex_elements = {
> >           \\end{graybox}
> >         }
> > 	\\makeatother
> > +
> > +	% Use some font with UTF-8 support with XeLaTeX
> > +        \\usepackage{fontspec}
> > +        \\setsansfont{DejaVu Serif}
> > +        \\setromanfont{DejaVu Sans}
> > +        \\setmonofont{DejaVu Sans Mono}
> > +
> >      '''
> > }
> > 
> > -- 
> > 2.7.4
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 



Thanks,
Mauro
