Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754388AbcHSUkq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:40:46 -0400
Date: Fri, 19 Aug 2016 17:40:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160819174038.0fb5901a@vento.lan>
In-Reply-To: <92FD7AE6-E093-439C-A2AC-5F39EC1F4BED@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
        <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
        <20160818163514.43539c11@lwn.net>
        <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
        <8737m0udod.fsf@intel.com>
        <92FD7AE6-E093-439C-A2AC-5F39EC1F4BED@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Aug 2016 17:52:07 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 19.08.2016 um 14:49 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > On Fri, 19 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:  
> >> Am 19.08.2016 um 00:35 schrieb Jonathan Corbet <corbet@lwn.net>:
> >> * the pdf goes to the "latex" folder .. since this is WIP
> >>  and there are different solutions conceivable ... I left
> >>  it open for the first.  
> > 
> > Mea culpa. As I said, I intended my patches as RFC only.  
> 
> I think this is OK for the first. I thought that we first
> let finish Mauro's task on making the media PDF and after
> this we decide how move from the latex folder to a pdf folder
> (one solution see below).

Most of the work is done: the uAPI book. The other books don't use much
tables. So, I guess it should be easier to fix them. I'll look on
the other media books next week.

> 
> >>> I'm not sure that we actually need the format-specific subfolders, but we
> >>> should be consistent across all the formats and in the documentation and,
> >>> as of this patch, we're not.  
> >> 
> >> IMHO a structure where only non-HTML formats are placed in subfolders
> >> (described above) is the better choice.
> >> 
> >> In the long run I like to get rid of all the intermediate formats
> >> (latex, .doctrees) and build a clear output-folder (with all formats
> >> in) which could be copied 1:1 to a static HTTP-server.  
> > 
> > When I added the Documentation/output subfolder, my main intention was
> > to separate the source documents from everything that is generated,
> > intermediate or final. I suggest you keep the generated files somewhere
> > under output. This'll be handly also when ensuring O= works.  
> 
> Yes, everything is under output / tested O=..
> 
> > I set up the format specific subfolders, because I thought people would
> > want to keep them separated and independent. For me, all the formats
> > were equal and at the same level in that regard. You're suggesting to
> > make html the root of everything?  
> 
> Yes this was my intention. With some additional work, we can build a 
> root index.html where the other formats are linked. Since other
> formats *below* index.html, everything is *reachable* from the root
> index.html.
> 
> Am 19.08.2016 um 15:32 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:
> > 
> > Agreed. it should either use subfolders or not.
> > 
> > IMHO, the best would be to just output everything at 
> > Documentation/output, if this is possible. That "fixes" the issue
> > of generating PDF files at the latex dir, with sounds weird, IMHO.  
> 
> Changing the latex/pdf issue should be  just a two-liner (not yet tested).
> 
> @@ -71,8 +71,8 @@ ifeq ($(HAVE_PDFLATEX),0)
>  	$(warning The 'xelatex' command was not found. Make sure you have it installed and in PATH to produce PDF output.)
>  	@echo "  SKIP    Sphinx $@ target."
>  else # HAVE_PDFLATEX
> -	@$(call loop_cmd,sphinx,latex,.,latex,.)
> -	$(Q)$(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/latex
> +	@$(call loop_cmd,sphinx,latex,.,pdf,.)
> +	$(Q)$(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/pdf
>  endif # HAVE_PDFLATEX

True, but I would still prefer to place everything at $(BUILDDIR), but this
is just my personal preference. Not really against per-format subdir.

> 
> 
> > I guess I mention on a previous e-mail, but SPHINXDIRS= is not working
> > for PDF files generation.  
> 
> Not yet, there is a concurrency question to answer, should sub-folder's 
> PDFs defined in the main conf.py-file or in the sub-folder conf.py?
> 
> I suggest the last one, or in other words: the PDF content of a target
> should have the same content as the HTML target even if it is a subfolder
> or the whole documentation. But this is only possible if we know, that
> all media content can be integrated in the big PDF file.

It can. However, in practice, experienced developers use only the
uAPI book most of the time. So, splitting the media documentation
on 4 books IMHO makes sense.

Yet, the all-in-one media book has only ~3MB. Not big.
	https://mchehab.fedorapeople.org/media.pdf
>
> After said this, what is your suggestion? For me its all equal, these 
> are only my 2cent to this discussion :-)
>  
> -- Markus --
> 
> > 
> > Thanks,
> > Mauro  



Thanks,
Mauro
