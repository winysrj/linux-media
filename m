Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63347 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750944AbcKBLoD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 07:44:03 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] doc-rst: generic way to build PDF of sub-folders
In-Reply-To: <1472052976-22541-2-git-send-email-markus.heiser@darmarit.de>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de> <1472052976-22541-2-git-send-email-markus.heiser@darmarit.de>
Date: Wed, 02 Nov 2016 13:43:59 +0200
Message-ID: <87ins6jedc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 24 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> From: Markus Heiser <markus.heiser@darmarIT.de>
>
> This extends the method to build only sub-folders to the targets
> "latexdocs" and "pdfdocs". To do so, a conf.py in the sub-folder is
> required, where the latex_documents of the sub-folder are
> defined. E.g. to build only gpu's PDF add the following to the
> Documentation/gpu/conf.py::
>
>   +latex_documents = [
>   +    ("index", "gpu.tex", "Linux GPU Driver Developer's Guide",
>   +     "The kernel development community", "manual"),
>   +]
>
> and run:
>
>   make SPHINXDIRS=gpu pdfdocs

Did you ever try this with more than one subfolder?

BR,
Jani.

>
> Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
> ---
>  Documentation/Makefile.sphinx | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
> index 894cfaa..92deea3 100644
> --- a/Documentation/Makefile.sphinx
> +++ b/Documentation/Makefile.sphinx
> @@ -71,12 +71,12 @@ ifeq ($(HAVE_PDFLATEX),0)
>  	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
>  	@echo "  SKIP    Sphinx $@ target."
>  else # HAVE_PDFLATEX
> -	@$(call loop_cmd,sphinx,latex,.,latex,.)
> +	@$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,latex,$(var),latex,$(var)))
>  endif # HAVE_PDFLATEX
>  
>  pdfdocs: latexdocs
>  ifneq ($(HAVE_PDFLATEX),0)
> -	$(Q)$(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/latex
> +	$(foreach var,$(SPHINXDIRS), $(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/$(var)/latex)
>  endif # HAVE_PDFLATEX
>  
>  epubdocs:

-- 
Jani Nikula, Intel Open Source Technology Center
