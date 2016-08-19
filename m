Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44335 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755060AbcHSNc1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:32:27 -0400
Date: Fri, 19 Aug 2016 10:32:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160819103220.705274b0@vento.lan>
In-Reply-To: <20160818163514.43539c11@lwn.net>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
        <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
        <20160818163514.43539c11@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Aug 2016 16:35:14 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Sat, 13 Aug 2016 16:12:42 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
> > Add a generic way to build only a reST sub-folder with or
> > without a individual *build-theme*.
> > 
> > * control *sub-folders* by environment SPHINXDIRS
> > * control *build-theme* by environment SPHINX_CONF
> > 
> > Folders with a conf.py file, matching $(srctree)/Documentation/*/conf.py
> > can be build and distributed *stand-alone*. E.g. to compile only the
> > html of 'media' and 'gpu' folder use::
> > 
> >   make SPHINXDIRS="media gpu" htmldocs
> > 
> > To use an additional sphinx-build configuration (*build-theme*) set the
> > name of the configuration file to SPHINX_CONF. E.g. to compile only the
> > html of 'media' with the *nit-picking* build use::
> > 
> >   make SPHINXDIRS=media SPHINX_CONF=conf_nitpick.py htmldocs
> > 
> > With this, the Documentation/conf.py is read first and updated with the
> > configuration values from the Documentation/media/conf_nitpick.py.  
> 
> So this patch appears to have had the undocumented effect of moving HTML
> output from Documentation/output/html to Documentation/output.  I am
> assuming that was not the intended result?
> 
> I'm not sure that we actually need the format-specific subfolders, but we
> should be consistent across all the formats and in the documentation and,
> as of this patch, we're not.

Agreed. it should either use subfolders or not.

IMHO, the best would be to just output everything at 
Documentation/output, if this is possible. That "fixes" the issue
of generating PDF files at the latex dir, with sounds weird, IMHO.

I guess I mention on a previous e-mail, but SPHINXDIRS= is not working
for PDF files generation.

Thanks,
Mauro
