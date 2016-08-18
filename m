Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34716 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755150AbcHSBV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 21:21:59 -0400
Date: Thu, 18 Aug 2016 16:35:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160818163514.43539c11@lwn.net>
In-Reply-To: <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
        <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 13 Aug 2016 16:12:42 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> Add a generic way to build only a reST sub-folder with or
> without a individual *build-theme*.
> 
> * control *sub-folders* by environment SPHINXDIRS
> * control *build-theme* by environment SPHINX_CONF
> 
> Folders with a conf.py file, matching $(srctree)/Documentation/*/conf.py
> can be build and distributed *stand-alone*. E.g. to compile only the
> html of 'media' and 'gpu' folder use::
> 
>   make SPHINXDIRS="media gpu" htmldocs
> 
> To use an additional sphinx-build configuration (*build-theme*) set the
> name of the configuration file to SPHINX_CONF. E.g. to compile only the
> html of 'media' with the *nit-picking* build use::
> 
>   make SPHINXDIRS=media SPHINX_CONF=conf_nitpick.py htmldocs
> 
> With this, the Documentation/conf.py is read first and updated with the
> configuration values from the Documentation/media/conf_nitpick.py.

So this patch appears to have had the undocumented effect of moving HTML
output from Documentation/output/html to Documentation/output.  I am
assuming that was not the intended result?

I'm not sure that we actually need the format-specific subfolders, but we
should be consistent across all the formats and in the documentation and,
as of this patch, we're not.

jon
