Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58651
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751012AbcKGJzb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 04:55:31 -0500
Date: Mon, 7 Nov 2016 07:55:24 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>, linux-doc@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
Subject: Including images on Sphinx documents
Message-ID: <20161107075524.49d83697@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

I'm trying to sort out the next steps to do after KS, with regards to
images included on RST files.

The issue is that Sphinx image support highly depends on the output
format. Also, despite TexLive support for svg and png images[1], Sphinx
doesn't produce the right LaTeX commands to use svg[2]. On my tests
with PNG on my notebook, it also didn't seem to do the right thing for
PNG either. So, it seems that the only safe way to support images is
to convert all of them to PDF for latex/pdf build.

[1] On Fedora, via texlive-dvipng and texlive-svg
[2] https://github.com/sphinx-doc/sphinx/issues/1907

As far as I understand from KS, two decisions was taken:

- We're not adding a sphinx extension to run generic commands;
- The PDF images should be build in runtime from their source files
  (either svg or bitmap), and not ship anymore the corresponding
  PDF files generated from its source.

As you know, we use several images at the media documentation:
	https://www.kernel.org/doc/html/latest/_images/

Those images are tightly coupled with the explanation texts. So,
maintaining them away from the documentation is not an option.

I was originally thinking that adding a graphviz extension would solve the
issue, but, in fact, most of the images aren't diagrams. Instead, there are 
several ones with images showing the result of passing certain parameters to
the ioctls, explaining things like scale and cropping and how bytes are
packed on some image formats.

Linus proposed to call some image conversion tool like ImageMagick or
inkscape to convert them to PDF when building the pdfdocs or latexdocs
target at Makefile, but there's an issue with that: Sphinx doesn't read
files from Documentation/output, and writing them directly at the
source dir would be against what it is expected when the "O=" argument
is passed to make. 

So, we have a few alternatives:

1) copy (or symlink) all rst files to Documentation/output (or to the
   build dir specified via O= directive) and generate the *.pdf there,
   and produce those converted images via Makefile.;

2) add an Sphinx extension that would internally call ImageMagick and/or
   inkscape to convert the bitmap;

3) if possible, add an extension to trick Sphinx for it to consider the 
   output dir as a source dir too.

Comments?

Regards,
Mauro
