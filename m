Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35160 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbcGRMmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:24 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 02/12] [media] Documentation: Add HSV format
Date: Mon, 18 Jul 2016 14:42:06 +0200
Message-Id: <1468845736-19651-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe the HSV formats

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 Documentation/media/uapi/v4l/hsv-formats.rst       |  19 +++
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 158 +++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/v4l2.rst              |   5 +
 4 files changed, 183 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst

diff --git a/Documentation/media/uapi/v4l/hsv-formats.rst b/Documentation/media/uapi/v4l/hsv-formats.rst
new file mode 100644
index 000000000000..f0f2615eaa95
--- /dev/null
+++ b/Documentation/media/uapi/v4l/hsv-formats.rst
@@ -0,0 +1,19 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _hsv-formats:
+
+***********
+HSV Formats
+***********
+
+These formats store the color information of the image
+in a geometrical representation. The colors are mapped into a
+cylinder, where the angle is the HUE, the height is the VALUE
+and the distance to the center is the SATURATION. This is a very
+useful format for image segmentation algorithms.
+
+
+.. toctree::
+    :maxdepth: 1
+
+    pixfmt-packed-hsv
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
new file mode 100644
index 000000000000..60ac821e309d
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
@@ -0,0 +1,158 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _packed-hsv:
+
+******************
+Packed HSV formats
+******************
+
+*man Packed HSV formats(2)*
+
+Packed HSV formats
+
+
+Description
+===========
+
+The *hue* (h) is measured in degrees, one LSB represents two degrees.
+The *saturation* (s) and the *value* (v) are measured in percentage of the
+cylinder: 0 being the smallest value and 255 the maximum.
+
+
+The values are packed in 24 or 32 bit formats.
+
+
+.. flat-table:: Packed HSV Image Formats
+    :header-rows:  2
+    :stub-columns: 0
+
+    -  .. row 1
+
+       -  Identifier
+       -  Code
+       -
+       -  :cspan:`7` Byte 0 in memory
+       -
+       -  :cspan:`7` Byte 1
+       -
+       -  :cspan:`7` Byte 2
+       -
+       -  :cspan:`7` Byte 3
+
+    -  .. row 2
+
+       -
+       -
+       -  Bit
+       -  7
+       -  6
+       -  5
+       -  4
+       -  3
+       -  2
+       -  1
+       -  0
+       -
+       -  7
+       -  6
+       -  5
+       -  4
+       -  3
+       -  2
+       -  1
+       -  0
+       -
+       -  7
+       -  6
+       -  5
+       -  4
+       -  3
+       -  2
+       -  1
+       -  0
+       -
+       -  7
+       -  6
+       -  5
+       -  4
+       -  3
+       -  2
+       -  1
+       -  0
+
+    -  .. _V4L2-PIX-FMT-HSV32:
+
+       -  ``V4L2_PIX_FMT_HSV32``
+       -  'HSV4'
+       -
+       -  -
+       -  -
+       -  -
+       -  -
+       -  -
+       -  -
+       -  -
+       -  -
+       -
+       -  h\ :sub:`7`
+       -  h\ :sub:`6`
+       -  h\ :sub:`5`
+       -  h\ :sub:`4`
+       -  h\ :sub:`3`
+       -  h\ :sub:`2`
+       -  h\ :sub:`1`
+       -  h\ :sub:`0`
+       -
+       -  s\ :sub:`7`
+       -  s\ :sub:`6`
+       -  s\ :sub:`5`
+       -  s\ :sub:`4`
+       -  s\ :sub:`3`
+       -  s\ :sub:`2`
+       -  s\ :sub:`1`
+       -  s\ :sub:`0`
+       -
+       -  v\ :sub:`7`
+       -  v\ :sub:`6`
+       -  v\ :sub:`5`
+       -  v\ :sub:`4`
+       -  v\ :sub:`3`
+       -  v\ :sub:`2`
+       -  v\ :sub:`1`
+       -  v\ :sub:`0`
+
+    -  .. _V4L2-PIX-FMT-HSV24:
+
+       -  ``V4L2_PIX_FMT_HSV24``
+       -  'HSV3'
+       -
+       -  h\ :sub:`7`
+       -  h\ :sub:`6`
+       -  h\ :sub:`5`
+       -  h\ :sub:`4`
+       -  h\ :sub:`3`
+       -  h\ :sub:`2`
+       -  h\ :sub:`1`
+       -  h\ :sub:`0`
+       -
+       -  s\ :sub:`7`
+       -  s\ :sub:`6`
+       -  s\ :sub:`5`
+       -  s\ :sub:`4`
+       -  s\ :sub:`3`
+       -  s\ :sub:`2`
+       -  s\ :sub:`1`
+       -  s\ :sub:`0`
+       -
+       -  v\ :sub:`7`
+       -  v\ :sub:`6`
+       -  v\ :sub:`5`
+       -  v\ :sub:`4`
+       -  v\ :sub:`3`
+       -  v\ :sub:`2`
+       -  v\ :sub:`1`
+       -  v\ :sub:`0`
+       -
+       -
+
+Bit 7 is the most significant bit.
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
index 81222a99f7ce..1d2270422345 100644
--- a/Documentation/media/uapi/v4l/pixfmt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt.rst
@@ -29,6 +29,7 @@ see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
     pixfmt-indexed
     pixfmt-rgb
     yuv-formats
+    hsv-formats
     depth-formats
     pixfmt-013
     sdr-formats
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index c0859ebc88ee..6d23bc987f51 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -85,6 +85,11 @@ part can be used and distributed without restrictions.
 Revision History
 ****************
 
+:revision: 4.8 / 2016-07-15 (*rr*)
+
+Introduce HSV formats.
+
+
 :revision: 4.5 / 2015-10-29 (*rr*)
 
 Extend VIDIOC_G_EXT_CTRLS;. Replace ctrl_class with a new union with
-- 
2.8.1

