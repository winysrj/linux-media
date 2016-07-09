Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbcGIMuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 08:50:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/3] [media] doc-rst: Add new types to media-types.rst
Date: Sat,  9 Jul 2016 09:50:02 -0300
Message-Id: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changesets:
	eaa0b96bbb65 ("[media] media: Add video statistics computation functions")
and
	1179aab13db3 ("[media] media: Add video processing entity functions")

added some new elements to the "media entity types" table at the
DocBook. We need to do the same at the reST version, in order to
keep it in sync with the DocBook version.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 69 +++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index a35fc15a3137..a2932bfef20f 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -166,6 +166,75 @@ Types and flags used to represent the media graph elements
 
        -  Audio Mixer Function Entity.
 
+    -  .. row 23
+
+       -  ``MEDIA_ENT_F_PROC_VIDEO_COMPOSER``
+
+       -  Video composer (blender). An entity capable of video
+	  composing must have at least two sink pads and one source
+	  pad, and composes input video frames onto output video
+	  frames. Composition can be performed using alpha blending,
+	  color keying, raster operations (ROP), stitching or any other
+	  means.
+
+    -  ..  row 24
+
+       -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER``
+
+       -  Video pixel formatter. An entity capable of pixel formatting
+	  must have at least one sink pad and one source pad. Read
+	  pixel formatters read pixels from memory and perform a subset
+	  of unpacking, cropping, color keying, alpha multiplication
+	  and pixel encoding conversion. Write pixel formatters perform
+	  a subset of dithering, pixel encoding conversion and packing
+	  and write pixels to memory.
+
+    -  ..  row 25
+
+       -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV``
+
+       -  Video pixel encoding converter. An entity capable of pixel
+	  enconding conversion must have at least one sink pad and one
+	  source pad, and convert the encoding of pixels received on
+	  its sink pad(s) to a different encoding output on its source
+	  pad(s). Pixel encoding conversion includes but isn't limited
+	  to RGB to/from HSV, RGB to/from YUV and CFA (Bayer) to RGB
+	  conversions.
+
+    -  ..  row 26
+
+       -  ``MEDIA_ENT_F_PROC_VIDEO_LUT``
+
+       -  Video look-up table. An entity capable of video lookup table
+	  processing must have one sink pad and one source pad. It uses
+	  the values of the pixels received on its sink pad to look up
+	  entries in internal tables and output them on its source pad.
+	  The lookup processing can be performed on all components
+	  separately or combine them for multi-dimensional table
+	  lookups.
+
+    -  ..  row 27
+
+       -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
+
+       -  Video scaler. An entity capable of video scaling must have
+	  at least one sink pad and one source pad, and scale the
+	  video frame(s) received on its sink pad(s) to a different
+	  resolution output on its source pad(s). The range of
+	  supported scaling ratios is entity-specific and can differ
+	  between the horizontal and vertical directions (in particular
+	  scaling can be supported in one direction only). Binning and
+	  skipping are considered as scaling.
+
+    -  ..  row 28
+
+       -  ``MEDIA_ENT_F_PROC_VIDEO_STATISTICS``
+
+       -  Video statistics computation (histogram, 3A, ...). An entity
+	  capable of statistics computation must have one sink pad and
+	  one source pad. It computes statistics over the frames
+	  received on its sink pad and outputs the statistics data on
+	  its source pad.
 
 
 .. _media-entity-flag:
-- 
2.7.4

