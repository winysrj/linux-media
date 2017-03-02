Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdCBVTn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 16:19:43 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH RFC] docs-rst: Don't use explicit Makefile rules to build SVG and DOT files
Date: Thu,  2 Mar 2017 17:24:47 -0300
Message-Id: <c8a5ee7048d918d8d33e39d1ed8eeb965c94d4cf.1488486066.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have an extension to handle images, use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

This patch is based on Daniel Vetter & Markus Heiser's work to support
PNG and SVG via kpicture Sphinx extension.

PS.: With this RFC patch, I'm getting now some extra warnings:

/devel/v4l/patchwork/Documentation/media/intro.rst:12: WARNING: undefined label: typical_media_device (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/dvb/intro.rst:95: WARNING: undefined label: stb_components (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/crop.rst:65: WARNING: undefined label: vbi-hsync (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-raw-vbi.rst:118: WARNING: undefined label: vbi-hsync (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-raw-vbi.rst:138: WARNING: undefined label: vbi-525 (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-raw-vbi.rst:138: WARNING: undefined label: vbi-625 (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-raw-vbi.rst:298: WARNING: undefined label: vbi-525 (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-raw-vbi.rst:298: WARNING: undefined label: vbi-625 (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-subdev.rst:93: WARNING: undefined label: pipeline-scaling (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/dev-subdev.rst:199: WARNING: undefined label: pipeline-scaling (if the link has no caption the label must precede a section header)
/devel/v4l/patchwork/Documentation/media/uapi/v4l/subdev-formats.rst:1483: WARNING: undefined label: bayer-patterns (if the link has no caption the label must precede a section header)



 Documentation/media/Makefile                       | 47 +---------------------
 Documentation/media/intro.rst                      |  9 ++---
 Documentation/media/uapi/dvb/intro.rst             |  9 ++---
 Documentation/media/uapi/v4l/crop.rst              |  9 ++---
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       | 25 +++++-------
 Documentation/media/uapi/v4l/dev-subdev.rst        | 34 +++++++---------
 Documentation/media/uapi/v4l/field-order.rst       | 14 ++++---
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     | 18 ++++-----
 Documentation/media/uapi/v4l/selection-api-003.rst |  7 ++--
 Documentation/media/uapi/v4l/subdev-formats.rst    |  9 ++---
 10 files changed, 61 insertions(+), 120 deletions(-)

diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index 32663602ff25..5bd52ea1eff0 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -1,51 +1,6 @@
-# Rules to convert DOT and SVG to Sphinx images
-
-SRC_DIR=$(srctree)/Documentation/media
-
-DOTS = \
-	uapi/v4l/pipeline.dot \
-
-IMAGES = \
-	typical_media_device.svg \
-	uapi/dvb/dvbstb.svg \
-	uapi/v4l/bayer.svg \
-	uapi/v4l/constraints.svg \
-	uapi/v4l/crop.svg \
-	uapi/v4l/fieldseq_bt.svg \
-	uapi/v4l/fieldseq_tb.svg \
-	uapi/v4l/nv12mt.svg \
-	uapi/v4l/nv12mt_example.svg \
-	uapi/v4l/pipeline.svg \
-	uapi/v4l/selection.svg \
-	uapi/v4l/subdev-image-processing-full.svg \
-	uapi/v4l/subdev-image-processing-scaling-multi-source.svg \
-	uapi/v4l/subdev-image-processing-crop.svg \
-	uapi/v4l/vbi_525.svg \
-	uapi/v4l/vbi_625.svg \
-	uapi/v4l/vbi_hsync.svg \
-
-DOTTGT := $(patsubst %.dot,%.svg,$(DOTS))
-IMGDOT := $(patsubst %,$(SRC_DIR)/%,$(DOTTGT))
-
-IMGTGT := $(patsubst %.svg,%.pdf,$(IMAGES))
-IMGPDF := $(patsubst %,$(SRC_DIR)/%,$(IMGTGT))
-
-cmd = $(echo-cmd) $(cmd_$(1))
-
-quiet_cmd_genpdf = GENPDF  $2
-      cmd_genpdf = convert $2 $3
-
-quiet_cmd_gendot = DOT     $2
-      cmd_gendot = dot -Tsvg $2 > $3
-
-%.pdf: %.svg
-	@$(call cmd,genpdf,$<,$@)
-
-%.svg: %.dot
-	@$(call cmd,gendot,$<,$@)
-
 # Rules to convert a .h file to inline RST documentation
 
+SRC_DIR=$(srctree)/Documentation/media
 PARSER = $(srctree)/Documentation/sphinx/parse-headers.pl
 UAPI = $(srctree)/include/uapi/linux
 KAPI = $(srctree)/include/linux
diff --git a/Documentation/media/intro.rst b/Documentation/media/intro.rst
index 8f7490c9a8ef..3c0c218c6d08 100644
--- a/Documentation/media/intro.rst
+++ b/Documentation/media/intro.rst
@@ -13,11 +13,10 @@ A typical media device hardware is shown at :ref:`typical_media_device`.
 
 .. _typical_media_device:
 
-.. figure::  typical_media_device.*
-    :alt:    typical_media_device.pdf / typical_media_device.svg
-    :align:  center
-
-    Typical Media Device
+.. kernel-figure::  typical_media_device.svg
+    :alt:     typical_media_device.svg
+    :align:   center
+    :caption: Typical Media Device
 
 The media infrastructure API was designed to control such devices. It is
 divided into five parts.
diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 2ed5c23102b4..b08a1acb8e52 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -55,11 +55,10 @@ Overview
 
 .. _stb_components:
 
-.. figure::  dvbstb.*
-    :alt:    dvbstb.pdf / dvbstb.svg
-    :align:  center
-
-    Components of a DVB card/STB
+.. kernel-figure::  dvbstb.svg
+    :alt:     dvbstb.svg
+    :align:   center
+    :caption: Components of a DVB card/STB
 
 A DVB PCI card or DVB set-top-box (STB) usually consists of the
 following main hardware components:
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index be58894c9c89..6ee9f17e5a09 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -53,11 +53,10 @@ Cropping Structures
 
 .. _crop-scale:
 
-.. figure::  crop.*
-    :alt:    crop.pdf / crop.svg
-    :align:  center
-
-    Image Cropping, Insertion and Scaling
+.. kernel-figure::  crop.svg
+    :alt:     crop.svg
+    :align:   center
+    :caption: Image Cropping, Insertion and Scaling
 
     The cropping, insertion and scaling process
 
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index baf5f2483927..5f0043950f22 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -221,31 +221,26 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbi-hsync:
 
-.. figure::  vbi_hsync.*
-    :alt:    vbi_hsync.pdf / vbi_hsync.svg
-    :align:  center
-
-    **Figure 4.1. Line synchronization**
+.. kernel-figure::  vbi_hsync.svg
+    :alt:     vbi_hsync.svg
+    :align:   center
+    :caption: **Figure 4.1. Line synchronization**
 
 
 .. _vbi-525:
 
-.. figure::  vbi_525.*
-    :alt:    vbi_525.pdf / vbi_525.svg
+.. kernel-figure::  vbi_525.svg
+    :alt:    vbi_525.svg
     :align:  center
-
-    **Figure 4.2. ITU-R 525 line numbering (M/NTSC and M/PAL)**
-
+    :caption: **Figure 4.2. ITU-R 525 line numbering (M/NTSC and M/PAL)**
 
 
 .. _vbi-625:
 
-.. figure::  vbi_625.*
-    :alt:    vbi_625.pdf / vbi_625.svg
+.. kernel-figure::  vbi_625.svg
+    :alt:    vbi_625.svg
     :align:  center
-
-    **Figure 4.3. ITU-R 625 line numbering**
-
+    :caption: **Figure 4.3. ITU-R 625 line numbering**
 
 
 Remember the VBI image format depends on the selected video standard,
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index cd2870180208..e01cc0bf8d01 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -99,11 +99,10 @@ the video sensor and the host image processing hardware.
 
 .. _pipeline-scaling:
 
-.. figure::  pipeline.*
-    :alt:    pipeline.pdf / pipeline.svg
-    :align:  center
-
-    Image Format Negotiation on Pipelines
+.. kernel-figure::  pipeline.dot
+    :alt:     pipeline.dot
+    :align:   center
+    :caption: Image Format Negotiation on Pipelines
 
     High quality and high speed pipeline configuration
 
@@ -404,11 +403,10 @@ selection will refer to the sink pad format dimensions instead.
 
 .. _subdev-image-processing-crop:
 
-.. figure::  subdev-image-processing-crop.*
-    :alt:    subdev-image-processing-crop.pdf / subdev-image-processing-crop.svg
-    :align:  center
-
-    **Figure 4.5. Image processing in subdevs: simple crop example**
+.. kernel-figure::  subdev-image-processing-crop.svg
+    :alt:     subdev-image-processing-crop.svg
+    :align:   center
+    :caption: **Figure 4.5. Image processing in subdevs: simple crop example**
 
 In the above example, the subdev supports cropping on its sink pad. To
 configure it, the user sets the media bus format on the subdev's sink
@@ -421,11 +419,10 @@ pad.
 
 .. _subdev-image-processing-scaling-multi-source:
 
-.. figure::  subdev-image-processing-scaling-multi-source.*
-    :alt:    subdev-image-processing-scaling-multi-source.pdf / subdev-image-processing-scaling-multi-source.svg
-    :align:  center
-
-    **Figure 4.6. Image processing in subdevs: scaling with multiple sources**
+.. kernel-figure::  subdev-image-processing-scaling-multi-source.svg
+    :alt:     subdev-image-processing-scaling-multi-source.svg
+    :align:   center
+    :caption: **Figure 4.6. Image processing in subdevs: scaling with multiple sources**
 
 In this example, the subdev is capable of first cropping, then scaling
 and finally cropping for two source pads individually from the resulting
@@ -437,11 +434,10 @@ an area at location specified by the source crop rectangle from it.
 
 .. _subdev-image-processing-full:
 
-.. figure::  subdev-image-processing-full.*
-    :alt:    subdev-image-processing-full.pdf / subdev-image-processing-full.svg
+.. kernel-figure::  subdev-image-processing-full.svg
+    :alt:    subdev-image-processing-full.svg
     :align:  center
-
-    **Figure 4.7. Image processing in subdevs: scaling and composition with multiple sinks and sources**
+    :capton: **Figure 4.7. Image processing in subdevs: scaling and composition with multiple sinks and sources**
 
 The subdev driver supports two sink pads and two source pads. The images
 from both of the sink pads are individually cropped, then scaled and
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index e05fb1041363..613849cd1fbb 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -141,9 +141,10 @@ enum v4l2_field
 Field Order, Top Field First Transmitted
 ========================================
 
-.. figure::  fieldseq_tb.*
-    :alt:    fieldseq_tb.pdf / fieldseq_tb.svg
-    :align:  center
+.. kernel-figure::  fieldseq_tb.svg
+    :alt:     fieldseq_tb.svg
+    :align:   center
+    :caption: Field Order, Top Field First Transmitted
 
 
 .. _fieldseq-bt:
@@ -151,7 +152,8 @@ Field Order, Top Field First Transmitted
 Field Order, Bottom Field First Transmitted
 ===========================================
 
-.. figure::  fieldseq_bt.*
-    :alt:    fieldseq_bt.pdf / fieldseq_bt.svg
-    :align:  center
+.. kernel-figure::  fieldseq_bt.svg
+    :alt:     fieldseq_bt.svg
+    :align:   center
+    :caption: Field Order, Bottom Field First Transmitted
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
index 32d0c8743460..18dae530cecd 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
@@ -33,11 +33,10 @@ Layout of macroblocks in memory is presented in the following figure.
 
 .. _nv12mt:
 
-.. figure::  nv12mt.*
-    :alt:    nv12mt.pdf / nv12mt.svg
-    :align:  center
-
-    V4L2_PIX_FMT_NV12MT macroblock Z shape memory layout
+.. kernel-figure::  nv12mt.svg
+    :alt:     nv12mt.svg
+    :align:   center
+    :caption: V4L2_PIX_FMT_NV12MT macroblock Z shape memory layout
 
 The requirement that width is multiple of 128 is implemented because,
 the Z shape cannot be cut in half horizontally. In case the vertical
@@ -50,11 +49,10 @@ interleaved. Height of the buffer is aligned to 32.
 
 .. _nv12mt_ex:
 
-.. figure::  nv12mt_example.*
-    :alt:    nv12mt_example.pdf / nv12mt_example.svg
-    :align:  center
-
-    Example V4L2_PIX_FMT_NV12MT memory layout of macroblocks
+.. kernel-figure::  nv12mt_example.svg
+    :alt:     nv12mt_example.svg
+    :align:   center
+    :caption: Example V4L2_PIX_FMT_NV12MT memory layout of macroblocks
 
 Memory layout of macroblocks of ``V4L2_PIX_FMT_NV12MT`` format in most
 extreme case.
diff --git a/Documentation/media/uapi/v4l/selection-api-003.rst b/Documentation/media/uapi/v4l/selection-api-003.rst
index 21686f93c38f..7de994739b8f 100644
--- a/Documentation/media/uapi/v4l/selection-api-003.rst
+++ b/Documentation/media/uapi/v4l/selection-api-003.rst
@@ -7,11 +7,10 @@ Selection targets
 
 .. _sel-targets-capture:
 
-.. figure::  selection.*
-    :alt:    selection.pdf / selection.svg
+.. kernel-figure::  selection.svg
+    :alt:    selection.svg
     :align:  center
-
-    Cropping and composing targets
+    :caption: Cropping and composing targets
 
     Targets used by a cropping, composing and scaling process
 
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index d6152c907b8b..8a8cf81cd253 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1514,11 +1514,10 @@ be named ``MEDIA_BUS_FMT_SRGGB10_2X8_PADHI_LE``.
 
 .. _bayer-patterns:
 
-.. figure::  bayer.*
-    :alt:    bayer.pdf / bayer.svg
-    :align:  center
-
-    **Figure 4.8 Bayer Patterns**
+.. kernel-figure::  bayer.svg
+    :alt:     bayer.svg
+    :align:   center
+    :caption: **Figure 4.8 Bayer Patterns**
 
 The following table lists existing packed Bayer formats. The data
 organization is given as an example for the first pixel only.
-- 
2.9.3
