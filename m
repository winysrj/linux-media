Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:51484 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbcHPIiB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 04:38:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH RFC v2 3/9] docs-rst: Don't mangle with UTF-8 chars on LaTeX/PDF output
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
Date: Tue, 16 Aug 2016 10:27:34 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4483E8C4-BBAC-4866-881D-3FBA5B85E834@darmarit.de>
References: <cover.1471294965.git.mchehab@s-opensource.com> <5ceebc273ff089c275c753c78f6e6c6e732b4077.1471294965.git.mchehab@s-opensource.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.08.2016 um 23:21 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> pdflatex doesn't accept using some UTF-8 chars, like
> "equal or less than" or "equal or greater than" chars. However,
> the media documents use them. So, we need to use XeLaTeX for
> conversion, and a font that accepts such characters.

Right, we should use the XeLaTeX engine. But ...

Sphinx LaTeX output was/is developed for LaTeX, not for XeLaTeX.
E.g. in its defaults it uses "inputenc" and other stuff which
is not a part of XeLaTeX.

* https://github.com/sphinx-doc/sphinx/issues/894#issuecomment-220786426

This patch removes the "inputenc", thats right, but I think over
short/long term we will see more errors related to LaTeX/XeLaTeX
distinction. And we will see that some conversion will break, depending
on the sphinx version we use (There might be some non XeLateX friendly 
changes in the sphinx-versions, since it is not tested with XeLaTeX).

   Nevertheless, XeLaTeX is the right choice!

My Suggestion is, that you merge this patch on top of Jon's doc-next. 
There, we have the sub-folders feature, with we can test book by book
and improve our toolchain.

-- Markus --


> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> Documentation/Makefile.sphinx |  6 +++---
> Documentation/conf.py         | 11 +++++++++++
> 2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
> index fc29e08085aa..aa7ff32be589 100644
> --- a/Documentation/Makefile.sphinx
> +++ b/Documentation/Makefile.sphinx
> @@ -26,7 +26,7 @@ else ifneq ($(DOCBOOKS),)
> else # HAVE_SPHINX
> 
> # User-friendly check for pdflatex
> -HAVE_PDFLATEX := $(shell if which pdflatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
> +HAVE_PDFLATEX := $(shell if which xelatex >/dev/null 2>&1; then echo 1; else echo 0; fi)
> 
> # Internal variables.
> PAPEROPT_a4     = -D latex_paper_size=a4
> @@ -45,11 +45,11 @@ htmldocs:
> 
> pdfdocs:
> ifeq ($(HAVE_PDFLATEX),0)
> -	$(warning The 'pdflatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
> +	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
> 	@echo "  SKIP    Sphinx $@ target."
> else # HAVE_PDFLATEX
> 	$(call cmd,sphinx,latex)
> -	$(Q)$(MAKE) -C $(BUILDDIR)/latex
> +	$(Q)$(MAKE) PDFLATEX=xelatex -C $(BUILDDIR)/latex
> endif # HAVE_PDFLATEX
> 
> epubdocs:
> diff --git a/Documentation/conf.py b/Documentation/conf.py
> index bbf2878d9945..f4469cd0340d 100644
> --- a/Documentation/conf.py
> +++ b/Documentation/conf.py
> @@ -260,6 +260,10 @@ latex_elements = {
> # Latex figure (float) alignment
> #'figure_align': 'htbp',
> 
> +# Don't mangle with UTF-8 chars
> +'inputenc': '',
> +'utf8extra': '',
> +
> # Additional stuff for the LaTeX preamble.
>     'preamble': '''
>         % Allow generate some pages in landscape
> @@ -287,6 +291,13 @@ latex_elements = {
>           \\end{graybox}
>         }
> 	\\makeatother
> +
> +	% Use some font with UTF-8 support with XeLaTeX
> +        \\usepackage{fontspec}
> +        \\setsansfont{DejaVu Serif}
> +        \\setromanfont{DejaVu Sans}
> +        \\setmonofont{DejaVu Sans Mono}
> +
>      '''
> }
> 
> -- 
> 2.7.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

