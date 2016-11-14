Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32957
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932109AbcKNOQ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 09:16:28 -0500
Date: Mon, 14 Nov 2016 12:16:19 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
Subject: Re: Including images on Sphinx documents
Message-ID: <20161114121619.18ba98d8@vento.lan>
In-Reply-To: <20161113140027.2fbe0946@lwn.net>
References: <20161107075524.49d83697@vento.lan>
        <87wpgf8ssc.fsf@intel.com>
        <20161107094648.55677524@vento.lan>
        <20161113140027.2fbe0946@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Nov 2016 14:00:27 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Mon, 7 Nov 2016 09:46:48 -0200
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > When running LaTeX in interactive mode, building just the media
> > PDF file with:
> > 
> > 	$ cls;make cleandocs; make SPHINXOPTS="-j5" DOCBOOKS="" SPHINXDIRS=media latexdocs 
> > 	$ PDFLATEX=xelatex LATEXOPTS="-interaction=interactive" -C Documentation/output/media/latex
> > 
> > I get this:
> > 
> > 	LaTeX Warning: Hyper reference `uapi/v4l/subdev-formats:bayer-patterns' on page
> > 	 153 undefined on input line 21373.
> > 
> > 	<use  "bayer.png" > [153]
> > 	! Extra alignment tab has been changed to \cr.
> > 	<template> \endtemplate 
> >                         
> > 	l.21429 \unskip}\relax \unskip}
> > 	                               \relax \\
> > 	? 
> > 
> > This patch fixes the issue:
> > 	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=dirty-pdf&id=b709de415f34d77cc121cad95bece9c7ef4d12fd
> > 
> > That means that Sphinx is not generating the right LaTeX output even for
> > (some?) PNG images.  
> 
> So I'm seriously confused.
> 
> I can get that particular message - TeX is complaining about too many
> columns in the table.  But applying your patch (with a suitable bayer.pdf
> provided) does not fix the problem.  Indeed, I can remove the figure with
> the image entirely and still not fix the problem.  Are you sure that the
> patch linked here actually fixed it for you?

There are two patches on the series fixing the column issues for the Bayer
formats table on the /6 patch series.

I guess I got confused with that, because of this warning:

 	LaTeX Warning: Hyper reference `uapi/v4l/subdev-formats:bayer-patterns' on page
 	 153 undefined on input line 21373.

Anyway, you're right: PNG is indeed working fine[1], and the
cross-reference is OK. The issue is just with SVG.

I'll fold it with patch 6/6 and submit a new series.

Sorry for the mess.

[1] I tested now on sphinx 1.4.8 - I was using an older version
before (1.4.5, I guess).

Thanks,
Mauro

[PATCH] docs-rst: Let Sphinx do PNG image conversion

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index 0f08bd8b87ba..297b85c37ab9 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -12,17 +12,6 @@ TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
 
 IMAGES = \
 	typical_media_device.svg \
-	uapi/v4l/fieldseq_tb.png \
-	uapi/v4l/selection.png \
-	uapi/v4l/vbi_hsync.png \
-	uapi/v4l/fieldseq_bt.png \
-	uapi/v4l/crop.png \
-	uapi/v4l/nv12mt.png \
-	uapi/v4l/vbi_525.png \
-	uapi/v4l/nv12mt_example.png \
-	uapi/v4l/vbi_625.png \
-	uapi/v4l/pipeline.png \
-	uapi/v4l/bayer.png \
 	uapi/dvb/dvbstb.svg \
 	uapi/v4l/constraints.svg \
 	uapi/v4l/subdev-image-processing-full.svg \
@@ -37,8 +26,6 @@ cmd = $(echo-cmd) $(cmd_$(1))
 quiet_cmd_genpdf = GENPDF  $2
       cmd_genpdf = convert $2 $3
 
-%.pdf: %.png
-	@$(call cmd,genpdf,$<,$@)
 %.pdf: %.svg
 	@$(call cmd,genpdf,$<,$@)
 
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index 31c5ba5ebd04..578c6f3d20f3 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -53,8 +53,8 @@ Cropping Structures
 
 .. _crop-scale:
 
-.. figure::  crop.*
-    :alt:    crop.pdf / crop.png
+.. figure::  crop.png
+    :alt:    crop.png
     :align:  center
 
     Image Cropping, Insertion and Scaling
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index fb4d9c4098a0..f81d906137ee 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -221,8 +221,8 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbi-hsync:
 
-.. figure::  vbi_hsync.*
-    :alt:    vbi_hsync.pdf / vbi_hsync.png
+.. figure::  vbi_hsync.png
+    :alt:    vbi_hsync.png
     :align:  center
 
     **Figure 4.1. Line synchronization**
@@ -230,8 +230,8 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbi-525:
 
-.. figure::  vbi_525.*
-    :alt:    vbi_525.pdf / vbi_525.png
+.. figure::  vbi_525.png
+    :alt:    vbi_525.png
     :align:  center
 
     **Figure 4.2. ITU-R 525 line numbering (M/NTSC and M/PAL)**
@@ -240,8 +240,8 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbi-625:
 
-.. figure::  vbi_625.*
-    :alt:    vbi_625.pdf / vbi_625.png
+.. figure::  vbi_625.png
+    :alt:    vbi_625.png
     :align:  center
 
     **Figure 4.3. ITU-R 625 line numbering**
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index b515424b3949..c18e9c5427ee 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -99,8 +99,8 @@ the video sensor and the host image processing hardware.
 
 .. _pipeline-scaling:
 
-.. figure::  pipeline.*
-    :alt:    pipeline.pdf / pipeline.png
+.. figure::  pipeline.png
+    :alt:    pipeline.png
     :align:  center
 
     Image Format Negotiation on Pipelines
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index 26c9a6541493..a7e1b4dae343 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -141,8 +141,8 @@ enum v4l2_field
 Field Order, Top Field First Transmitted
 ========================================
 
-.. figure::  fieldseq_tb.*
-    :alt:    fieldseq_tb.pdf / fieldseq_tb.png
+.. figure::  fieldseq_tb.png
+    :alt:    fieldseq_tb.png
     :align:  center
 
 
@@ -151,7 +151,7 @@ Field Order, Top Field First Transmitted
 Field Order, Bottom Field First Transmitted
 ===========================================
 
-.. figure::  fieldseq_bt.*
-    :alt:    fieldseq_bt.pdf / fieldseq_bt.png
+.. figure::  fieldseq_bt.png
+    :alt:    fieldseq_bt.png
     :align:  center
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
index d088c469f880..c8a77bc79f2f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
@@ -33,8 +33,8 @@ Layout of macroblocks in memory is presented in the following figure.
 
 .. _nv12mt:
 
-.. figure::  nv12mt.*
-    :alt:    nv12mt.pdf / nv12mt.png
+.. figure::  nv12mt.png
+    :alt:    nv12mt.png
     :align:  center
 
     V4L2_PIX_FMT_NV12MT macroblock Z shape memory layout
@@ -50,8 +50,8 @@ interleaved. Height of the buffer is aligned to 32.
 
 .. _nv12mt_ex:
 
-.. figure::  nv12mt_example.*
-    :alt:    nv12mt_example.pdf / nv12mt_example.png
+.. figure::  nv12mt_example.png
+    :alt:    nv12mt_example.png
     :align:  center
 
     Example V4L2_PIX_FMT_NV12MT memory layout of macroblocks
diff --git a/Documentation/media/uapi/v4l/selection-api-003.rst b/Documentation/media/uapi/v4l/selection-api-003.rst
index c76e2332116b..207349c17ead 100644
--- a/Documentation/media/uapi/v4l/selection-api-003.rst
+++ b/Documentation/media/uapi/v4l/selection-api-003.rst
@@ -7,8 +7,8 @@ Selection targets
 
 .. _sel-targets-capture:
 
-.. figure::  selection.*
-    :alt:    selection.pdf / selection.png
+.. figure::  selection.png
+    :alt:    selection.png
     :align:  center
 
     Cropping and composing targets
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 5053e284265d..2f9c135dfadd 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1514,8 +1514,8 @@ be named ``MEDIA_BUS_FMT_SRGGB10_2X8_PADHI_LE``.
 
 .. _bayer-patterns:
 
-.. figure::  bayer.*
-    :alt:    bayer.pdf / bayer.png
+.. figure::  bayer.png
+    :alt:    bayer.png
     :align:  center
 
     **Figure 4.8 Bayer Patterns**

