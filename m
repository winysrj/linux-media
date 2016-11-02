Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:45438 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754938AbcKBOHz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 10:07:55 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/3] doc-rst: generic way to build PDF of sub-folders
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87ins6jedc.fsf@intel.com>
Date: Wed, 2 Nov 2016 15:07:40 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <605152A9-0EC8-40DD-8671-437D6369CA94@darmarit.de>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de> <1472052976-22541-2-git-send-email-markus.heiser@darmarit.de> <87ins6jedc.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 02.11.2016 um 12:43 schrieb Jani Nikula <jani.nikula@intel.com>:

> On Wed, 24 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>> From: Markus Heiser <markus.heiser@darmarIT.de>
>> 
>> This extends the method to build only sub-folders to the targets
>> "latexdocs" and "pdfdocs". To do so, a conf.py in the sub-folder is
>> required, where the latex_documents of the sub-folder are
>> defined. E.g. to build only gpu's PDF add the following to the
>> Documentation/gpu/conf.py::
>> 
>>  +latex_documents = [
>>  +    ("index", "gpu.tex", "Linux GPU Driver Developer's Guide",
>>  +     "The kernel development community", "manual"),
>>  +]
>> 
>> and run:
>> 
>>  make SPHINXDIRS=gpu pdfdocs
> 
> Did you ever try this with more than one subfolder?

Seems not, there is a ";" missed in the 'foreach' loop, see patch
below.

To avoid conflicts, can you apply the ";" on your 
"Makefile.sphinx improvements" series? / Thanks

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 92deea3..b7fbd12 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -76,7 +76,7 @@ endif # HAVE_PDFLATEX
 
 pdfdocs: latexdocs
 ifneq ($(HAVE_PDFLATEX),0)
-       $(foreach var,$(SPHINXDIRS), $(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/$(var)/latex)
+       $(foreach var,$(SPHINXDIRS), $(MAKE) PDFLATEX=xelatex LATEXOPTS="-interaction=nonstopmode" -C $(BUILDDIR)/$(var)/latex;)
 endif # HAVE_PDFLATEX
 
 epubdocs:


--Markus --

