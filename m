Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36969 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcHLVUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 17:20:22 -0400
Date: Fri, 12 Aug 2016 15:20:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160812152020.21754cf8@lwn.net>
In-Reply-To: <1470662100-6927-2-git-send-email-markus.heiser@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
	<1470662100-6927-2-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon,  8 Aug 2016 15:14:58 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> Remove the 'DOC_NITPIC_TARGETS' from main $(srctree)/Makefile and add a
> more generic way to build only a reST sub-folder.
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

So I went to apply these, but this one, at least, doesn't apply.  Could I
get you to respin the series against current mainline (or docs-next)?

Thanks,

jon
