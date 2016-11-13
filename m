Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35196 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935056AbcKMVAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 16:00:51 -0500
Date: Sun, 13 Nov 2016 14:00:27 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
Subject: Re: Including images on Sphinx documents
Message-ID: <20161113140027.2fbe0946@lwn.net>
In-Reply-To: <20161107094648.55677524@vento.lan>
References: <20161107075524.49d83697@vento.lan>
        <87wpgf8ssc.fsf@intel.com>
        <20161107094648.55677524@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 7 Nov 2016 09:46:48 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> When running LaTeX in interactive mode, building just the media
> PDF file with:
> 
> 	$ cls;make cleandocs; make SPHINXOPTS="-j5" DOCBOOKS="" SPHINXDIRS=media latexdocs 
> 	$ PDFLATEX=xelatex LATEXOPTS="-interaction=interactive" -C Documentation/output/media/latex
> 
> I get this:
> 
> 	LaTeX Warning: Hyper reference `uapi/v4l/subdev-formats:bayer-patterns' on page
> 	 153 undefined on input line 21373.
> 
> 	<use  "bayer.png" > [153]
> 	! Extra alignment tab has been changed to \cr.
> 	<template> \endtemplate 
>                         
> 	l.21429 \unskip}\relax \unskip}
> 	                               \relax \\
> 	? 
> 
> This patch fixes the issue:
> 	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=dirty-pdf&id=b709de415f34d77cc121cad95bece9c7ef4d12fd
> 
> That means that Sphinx is not generating the right LaTeX output even for
> (some?) PNG images.

So I'm seriously confused.

I can get that particular message - TeX is complaining about too many
columns in the table.  But applying your patch (with a suitable bayer.pdf
provided) does not fix the problem.  Indeed, I can remove the figure with
the image entirely and still not fix the problem.  Are you sure that the
patch linked here actually fixed it for you?

jon
