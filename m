Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59094
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753006AbcKGLrA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 06:47:00 -0500
Date: Mon, 7 Nov 2016 09:46:48 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
Subject: Re: Including images on Sphinx documents
Message-ID: <20161107094648.55677524@vento.lan>
In-Reply-To: <87wpgf8ssc.fsf@intel.com>
References: <20161107075524.49d83697@vento.lan>
        <87wpgf8ssc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 07 Nov 2016 12:53:55 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Mon, 07 Nov 2016, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > Hi Jon,
> >
> > I'm trying to sort out the next steps to do after KS, with regards to
> > images included on RST files.
> >
> > The issue is that Sphinx image support highly depends on the output
> > format. Also, despite TexLive support for svg and png images[1], Sphinx
> > doesn't produce the right LaTeX commands to use svg[2]. On my tests
> > with PNG on my notebook, it also didn't seem to do the right thing for
> > PNG either. So, it seems that the only safe way to support images is
> > to convert all of them to PDF for latex/pdf build.
> >
> > [1] On Fedora, via texlive-dvipng and texlive-svg
> > [2] https://github.com/sphinx-doc/sphinx/issues/1907
> >
> > As far as I understand from KS, two decisions was taken:
> >
> > - We're not adding a sphinx extension to run generic commands;
> > - The PDF images should be build in runtime from their source files
> >   (either svg or bitmap), and not ship anymore the corresponding
> >   PDF files generated from its source.
> >
> > As you know, we use several images at the media documentation:
> > 	https://www.kernel.org/doc/html/latest/_images/
> >
> > Those images are tightly coupled with the explanation texts. So,
> > maintaining them away from the documentation is not an option.
> >
> > I was originally thinking that adding a graphviz extension would solve the
> > issue, but, in fact, most of the images aren't diagrams. Instead, there are 
> > several ones with images showing the result of passing certain parameters to
> > the ioctls, explaining things like scale and cropping and how bytes are
> > packed on some image formats.
> >
> > Linus proposed to call some image conversion tool like ImageMagick or
> > inkscape to convert them to PDF when building the pdfdocs or latexdocs
> > target at Makefile, but there's an issue with that: Sphinx doesn't read
> > files from Documentation/output, and writing them directly at the
> > source dir would be against what it is expected when the "O=" argument
> > is passed to make. 
> >
> > So, we have a few alternatives:
> >
> > 1) copy (or symlink) all rst files to Documentation/output (or to the
> >    build dir specified via O= directive) and generate the *.pdf there,
> >    and produce those converted images via Makefile.;
> >
> > 2) add an Sphinx extension that would internally call ImageMagick and/or
> >    inkscape to convert the bitmap;
> >
> > 3) if possible, add an extension to trick Sphinx for it to consider the 
> >    output dir as a source dir too.  
> 
> Looking at the available extensions, and the images to be displayed,
> seems to me making svg work, somehow, is the right approach. (As opposed
> to trying to represent the images in graphviz or whatnot.)
> 
> IIUC texlive supports displaying svg directly, but the problem is that
> Sphinx produces bad latex for that. Can we make it work by manually
> writing the latex?

It might be possible, if we write something at the LaTeX preamble
that would replace \includegraphics by something that would, instead,
use \includesvg, if the image is in SVG format. However, I don't know
enough about LaTeX to write such macro.

> If yes, we wouldn't need to use an external tool to
> convert the svg to something else, but rather fix the latex. Thus:
> 
> 4a) See if this works:
> 
> .. only:: html
> 
>    .. image:: foo.svg
> 
> .. raw:: latex
> 
>    <the correct latex commands required to display foo.svg>

This may work, although it would prevent forever the usage of some
extension to auto-numerate images and to cross-reference them.

That's said, PNG also doesn't seem to work fine on Sphinx 1.4.x.

On my tests, I installed *all* texlive extensions on Fedora 24, to
be sure that the issue is not the lack of some extension[1], with:

	# dnf install $(sudo dnf search texlive |grep all|cut -d. -f 1|grep texlive-)

When running LaTeX in interactive mode, building just the media
PDF file with:

	$ cls;make cleandocs; make SPHINXOPTS="-j5" DOCBOOKS="" SPHINXDIRS=media latexdocs 
	$ PDFLATEX=xelatex LATEXOPTS="-interaction=interactive" -C Documentation/output/media/latex

I get this:

	LaTeX Warning: Hyper reference `uapi/v4l/subdev-formats:bayer-patterns' on page
	 153 undefined on input line 21373.

	<use  "bayer.png" > [153]
	! Extra alignment tab has been changed to \cr.
	<template> \endtemplate 
                        
	l.21429 \unskip}\relax \unskip}
	                               \relax \\
	? 

This patch fixes the issue:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=dirty-pdf&id=b709de415f34d77cc121cad95bece9c7ef4d12fd

That means that Sphinx is not generating the right LaTeX output even for
(some?) PNG images.

[1] On a side note, installing texlive-texliveonfly didn't made much
difference... I still had to manually install a lot of texlive extensions
for LaTeX build to work on Fedora. It seems that texliveonfly only solved
automatically font dependencies.

> 4b) Add a directive extension to make the above happen automatically.
> 
> Of course, the correct fix is to have this fixed in upstream Sphinx, but
> as a workaround an extension doing the above seems plausible, and not
> too much effort - provided that we can make the raw latex work.

If we're adding an extension, IMHO, it is better to do the format
conversion inside the extension. From what I understood, texlive
will still require inkscape to be installed in order for the SVG
support to work:
	https://tex.stackexchange.com/questions/122871/include-svg-images-with-the-svg-package

And it may even require "--shell-escape" to be passed at the xelatex
call if inkscape is not in the path, with seems to be a strong
indication that SVG support is not native to texlive, but, instead,
just a way to make LaTeX to call inkscape to do the image conversion.

Regards,
Mauro
