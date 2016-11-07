Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36918 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752534AbcKGRFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 12:05:12 -0500
Date: Mon, 7 Nov 2016 09:05:05 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jani Nikula <jani.nikula@intel.com>, linux-media@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161107170504.25j4rwfohhqp67fw@x>
References: <20161107075524.49d83697@vento.lan>
 <87wpgf8ssc.fsf@intel.com>
 <20161107094648.55677524@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107094648.55677524@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 07, 2016 at 09:46:48AM -0200, Mauro Carvalho Chehab wrote:
> That's said, PNG also doesn't seem to work fine on Sphinx 1.4.x.
> 
> On my tests, I installed *all* texlive extensions on Fedora 24, to
> be sure that the issue is not the lack of some extension[1], with:
> 
> 	# dnf install $(sudo dnf search texlive |grep all|cut -d. -f 1|grep texlive-)
> 
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

\includegraphics normally works just fine for PNG images in PDF
documents.

[...]
> And it may even require "--shell-escape" to be passed at the xelatex
> call if inkscape is not in the path, with seems to be a strong
> indication that SVG support is not native to texlive, but, instead,
> just a way to make LaTeX to call inkscape to do the image conversion.

Please don't require --shell-escape as part of the TeX workflow.  If
LaTeX can't handle the desired image format natively, it needs
conversion in advance.

- Josh Triplett
