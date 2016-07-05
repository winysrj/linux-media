Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 39/41] Documentation: dev-subdev.rst: fix some format issues
Date: Mon,  4 Jul 2016 22:31:14 -0300
Message-Id: <d81622f07c89b59c5ef1a1b1347fa01dbaa2e677.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from DocBook made somethings look ugly.
Improve them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-subdev.rst | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-subdev.rst b/Documentation/linux_tv/media/v4l/dev-subdev.rst
index 832b114f7066..39d3d860dda4 100644
--- a/Documentation/linux_tv/media/v4l/dev-subdev.rst
+++ b/Documentation/linux_tv/media/v4l/dev-subdev.rst
@@ -118,14 +118,14 @@ every point in the pipeline explicitly.
 Drivers that implement the :ref:`media API <media-controller-intro>`
 can expose pad-level image format configuration to applications. When
 they do, applications can use the
-:ref:`VIDIOC_SUBDEV_G_FMT` and
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
 :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls. to
 negotiate formats on a per-pad basis.
 
 Applications are responsible for configuring coherent parameters on the
 whole pipeline and making sure that connected pads have compatible
 formats. The pipeline is checked for formats mismatch at
-:ref:`VIDIOC_STREAMON` time, and an ``EPIPE`` error
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` time, and an ``EPIPE`` error
 code is then returned if the configuration is invalid.
 
 Pad-level image format configuration support can be tested by calling
@@ -145,8 +145,8 @@ formats enumeration only. A format negotiation mechanism is required.
 
 Central to the format negotiation mechanism are the get/set format
 operations. When called with the ``which`` argument set to
-``V4L2_SUBDEV_FORMAT_TRY``, the
-:ref:`VIDIOC_SUBDEV_G_FMT` and
+:ref:`V4L2_SUBDEV_FORMAT_TRY <VIDIOC_SUBDEV_G_FMT>`, the
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
 :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls operate on
 a set of formats parameters that are not connected to the hardware
 configuration. Modifying those 'try' formats leaves the device state
@@ -155,7 +155,7 @@ and the hardware state stored in the device itself).
 
 While not kept as part of the device state, try formats are stored in
 the sub-device file handles. A
-:ref:`VIDIOC_SUBDEV_G_FMT` call will return
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` call will return
 the last try format set *on the same sub-device file handle*. Several
 applications querying the same sub-device at the same time will thus not
 interact with each other.
@@ -443,7 +443,7 @@ selection will refer to the sink pad format dimensions instead.
     :alt:    subdev-image-processing-crop.svg
     :align:  center
 
-    Image processing in subdevs: simple crop example
+    **Figure 4.5. Image processing in subdevs: simple crop example**
 
 In the above example, the subdev supports cropping on its sink pad. To
 configure it, the user sets the media bus format on the subdev's sink
@@ -460,7 +460,7 @@ pad.
     :alt:    subdev-image-processing-scaling-multi-source.svg
     :align:  center
 
-    Image processing in subdevs: scaling with multiple sources
+    **Figure 4.6. Image processing in subdevs: scaling with multiple sources**
 
 In this example, the subdev is capable of first cropping, then scaling
 and finally cropping for two source pads individually from the resulting
@@ -476,7 +476,7 @@ an area at location specified by the source crop rectangle from it.
     :alt:    subdev-image-processing-full.svg
     :align:  center
 
-    Image processing in subdevs: scaling and composition with multiple sinks and sources
+    **Figure 4.7. Image processing in subdevs: scaling and composition with multiple sinks and sources**
 
 The subdev driver supports two sink pads and two source pads. The images
 from both of the sink pads are individually cropped, then scaled and
-- 
2.7.4

