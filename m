Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50079 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCCFOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 00:14:38 -0500
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
Subject: [PATCH RFC v2] docs-rst: Don't use explicit Makefile rules to build SVG and DOT files
Date: Thu,  2 Mar 2017 18:40:04 -0300
Message-Id: <123ba241cbc9b168298f29def96ae12ebe8e9ef4.1488490586.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have an extension to handle images, use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

This patch is based on Daniel Vetter & Markus Heiser's work to support
PNG and SVG via kpicture Sphinx extension:

     [PATCH] docs-rst: automatically convert Graphviz and SVG images

v2: Don't use :caption:, as it doesn't exist on kernel-figure.

Unfortunately, this patch showed severl issues at the original patch.
I'm still sending it, as it could help testing the issues there.

 Documentation/media/Makefile                       | 47 +---------------------
 Documentation/media/intro.rst                      |  6 +--
 Documentation/media/uapi/dvb/intro.rst             |  6 +--
 Documentation/media/uapi/v4l/crop.rst              |  4 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       | 20 +++++----
 Documentation/media/uapi/v4l/dev-subdev.rst        | 22 +++++-----
 Documentation/media/uapi/v4l/field-order.rst       | 12 ++++--
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |  8 ++--
 Documentation/media/uapi/v4l/selection-api-003.rst |  6 +--
 Documentation/media/uapi/v4l/subdev-formats.rst    |  4 +-
 10 files changed, 46 insertions(+), 89 deletions(-)

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
index 8f7490c9a8ef..9ce2e23a0236 100644
--- a/Documentation/media/intro.rst
+++ b/Documentation/media/intro.rst
@@ -13,9 +13,9 @@ A typical media device hardware is shown at :ref:`typical_media_device`.
 
 .. _typical_media_device:
 
-.. figure::  typical_media_device.*
-    :alt:    typical_media_device.pdf / typical_media_device.svg
-    :align:  center
+.. kernel-figure:: typical_media_device.svg
+    :alt:   typical_media_device.svg
+    :align: center
 
     Typical Media Device
 
diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index 2ed5c23102b4..652c4aacd2c6 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -55,9 +55,9 @@ Overview
 
 .. _stb_components:
 
-.. figure::  dvbstb.*
-    :alt:    dvbstb.pdf / dvbstb.svg
-    :align:  center
+.. kernel-figure:: dvbstb.svg
+    :alt:   dvbstb.svg
+    :align: center
 
     Components of a DVB card/STB
 
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index be58894c9c89..182565b9ace4 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -53,8 +53,8 @@ Cropping Structures
 
 .. _crop-scale:
 
-.. figure::  crop.*
-    :alt:    crop.pdf / crop.svg
+.. kernel-figure:: crop.svg
+    :alt:    crop.svg
     :align:  center
 
     Image Cropping, Insertion and Scaling
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index baf5f2483927..9fcc18dfe3d1 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -221,33 +221,31 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. _vbi-hsync:
 
-.. figure::  vbi_hsync.*
-    :alt:    vbi_hsync.pdf / vbi_hsync.svg
-    :align:  center
+.. kernel-figure:: vbi_hsync.svg
+    :alt:   vbi_hsync.svg
+    :align: center
 
     **Figure 4.1. Line synchronization**
 
 
 .. _vbi-525:
 
-.. figure::  vbi_525.*
-    :alt:    vbi_525.pdf / vbi_525.svg
-    :align:  center
+.. kernel-figure:: vbi_525.svg
+    :alt:   vbi_525.svg
+    :align: center
 
     **Figure 4.2. ITU-R 525 line numbering (M/NTSC and M/PAL)**
 
 
-
 .. _vbi-625:
 
-.. figure::  vbi_625.*
-    :alt:    vbi_625.pdf / vbi_625.svg
-    :align:  center
+.. kernel-figure:: vbi_625.svg
+    :alt:   vbi_625.svg
+    :align: center
 
     **Figure 4.3. ITU-R 625 line numbering**
 
 
-
 Remember the VBI image format depends on the selected video standard,
 therefore the application must choose a new standard or query the
 current standard first. Attempts to read or write data ahead of format
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index cd2870180208..f0e762167730 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -99,9 +99,9 @@ the video sensor and the host image processing hardware.
 
 .. _pipeline-scaling:
 
-.. figure::  pipeline.*
-    :alt:    pipeline.pdf / pipeline.svg
-    :align:  center
+.. kernel-figure:: pipeline.dot
+    :alt:   pipeline.dot
+    :align: center
 
     Image Format Negotiation on Pipelines
 
@@ -404,9 +404,9 @@ selection will refer to the sink pad format dimensions instead.
 
 .. _subdev-image-processing-crop:
 
-.. figure::  subdev-image-processing-crop.*
-    :alt:    subdev-image-processing-crop.pdf / subdev-image-processing-crop.svg
-    :align:  center
+.. kernel-figure:: subdev-image-processing-crop.svg
+    :alt:   subdev-image-processing-crop.svg
+    :align: center
 
     **Figure 4.5. Image processing in subdevs: simple crop example**
 
@@ -421,9 +421,9 @@ pad.
 
 .. _subdev-image-processing-scaling-multi-source:
 
-.. figure::  subdev-image-processing-scaling-multi-source.*
-    :alt:    subdev-image-processing-scaling-multi-source.pdf / subdev-image-processing-scaling-multi-source.svg
-    :align:  center
+.. kernel-figure:: subdev-image-processing-scaling-multi-source.svg
+    :alt:   subdev-image-processing-scaling-multi-source.svg
+    :align: center
 
     **Figure 4.6. Image processing in subdevs: scaling with multiple sources**
 
@@ -437,8 +437,8 @@ an area at location specified by the source crop rectangle from it.
 
 .. _subdev-image-processing-full:
 
-.. figure::  subdev-image-processing-full.*
-    :alt:    subdev-image-processing-full.pdf / subdev-image-processing-full.svg
+.. kernel-figure:: subdev-image-processing-full.svg
+    :alt:    subdev-image-processing-full.svg
     :align:  center
 
     **Figure 4.7. Image processing in subdevs: scaling and composition with multiple sinks and sources**
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index e05fb1041363..f924776ef9ee 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -141,17 +141,21 @@ enum v4l2_field
 Field Order, Top Field First Transmitted
 ========================================
 
-.. figure::  fieldseq_tb.*
-    :alt:    fieldseq_tb.pdf / fieldseq_tb.svg
+.. kernel-figure:: fieldseq_tb.svg
+    :alt:    fieldseq_tb.svg
     :align:  center
 
+    Field Order, Top Field First Transmitted
+
 
 .. _fieldseq-bt:
 
 Field Order, Bottom Field First Transmitted
 ===========================================
 
-.. figure::  fieldseq_bt.*
-    :alt:    fieldseq_bt.pdf / fieldseq_bt.svg
+.. kernel-figure:: fieldseq_bt.svg
+    :alt:    fieldseq_bt.svg
     :align:  center
 
+    Field Order, Bottom Field First Transmitted
+
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
index 32d0c8743460..172a3825604e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
@@ -33,8 +33,8 @@ Layout of macroblocks in memory is presented in the following figure.
 
 .. _nv12mt:
 
-.. figure::  nv12mt.*
-    :alt:    nv12mt.pdf / nv12mt.svg
+.. kernel-figure:: nv12mt.svg
+    :alt:    nv12mt.svg
     :align:  center
 
     V4L2_PIX_FMT_NV12MT macroblock Z shape memory layout
@@ -50,8 +50,8 @@ interleaved. Height of the buffer is aligned to 32.
 
 .. _nv12mt_ex:
 
-.. figure::  nv12mt_example.*
-    :alt:    nv12mt_example.pdf / nv12mt_example.svg
+.. kernel-figure:: nv12mt_example.svg
+    :alt:    nv12mt_example.svg
     :align:  center
 
     Example V4L2_PIX_FMT_NV12MT memory layout of macroblocks
diff --git a/Documentation/media/uapi/v4l/selection-api-003.rst b/Documentation/media/uapi/v4l/selection-api-003.rst
index 21686f93c38f..bf7e76dfbdf9 100644
--- a/Documentation/media/uapi/v4l/selection-api-003.rst
+++ b/Documentation/media/uapi/v4l/selection-api-003.rst
@@ -7,9 +7,9 @@ Selection targets
 
 .. _sel-targets-capture:
 
-.. figure::  selection.*
-    :alt:    selection.pdf / selection.svg
-    :align:  center
+.. kernel-figure:: selection.svg
+    :alt:   selection.svg
+    :align: center
 
     Cropping and composing targets
 
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index d6152c907b8b..89a1fb959314 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1514,8 +1514,8 @@ be named ``MEDIA_BUS_FMT_SRGGB10_2X8_PADHI_LE``.
 
 .. _bayer-patterns:
 
-.. figure::  bayer.*
-    :alt:    bayer.pdf / bayer.svg
+.. kernel-figure:: bayer.svg
+    :alt:    bayer.svg
     :align:  center
 
     **Figure 4.8 Bayer Patterns**
-- 
2.9.3
