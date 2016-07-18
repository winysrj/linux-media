Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33962 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcGRMmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:43 -0400
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
Subject: [PATCH v4 11/12] [media] Documentation: Add HSV encodings
Date: Mon, 18 Jul 2016 14:42:15 +0200
Message-Id: <1468845736-19651-12-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe the hsv_enc field and its use.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 Documentation/media/uapi/v4l/pixfmt-002.rst        | 12 ++++++-
 Documentation/media/uapi/v4l/pixfmt-003.rst        | 14 ++++++--
 Documentation/media/uapi/v4l/pixfmt-006.rst        | 38 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst |  3 +-
 Documentation/media/videodev2.h.rst.exceptions     |  4 +++
 5 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index fae9b2d40a85..9a59e87b590f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -177,6 +177,16 @@ Single-planar format structure
 
     -  .. row 13
 
+       -  enum :ref:`v4l2_hsv_encoding <v4l2-hsv-encoding>`
+
+       -  ``hsv_enc``
+
+       -  This information supplements the ``colorspace`` and must be set by
+	  the driver for capture streams and by the application for output
+	  streams, see :ref:`colorspaces`.
+
+    -  .. row 14
+
        -  enum :ref:`v4l2_quantization <v4l2-quantization>`
 
        -  ``quantization``
@@ -185,7 +195,7 @@ Single-planar format structure
 	  the driver for capture streams and by the application for output
 	  streams, see :ref:`colorspaces`.
 
-    -  .. row 14
+    -  .. row 15
 
        -  enum :ref:`v4l2_xfer_func <v4l2-xfer-func>`
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index 25c54872fbe1..f212d1feaaa0 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -138,6 +138,16 @@ describing all planes of that format.
 
     -  .. row 10
 
+       -  enum :ref:`v4l2_hsv_encoding <v4l2-hsv-encoding>`
+
+       -  ``hsv_enc``
+
+       -  This information supplements the ``colorspace`` and must be set by
+	  the driver for capture streams and by the application for output
+	  streams, see :ref:`colorspaces`.
+
+    -  .. row 11
+
        -  enum :ref:`v4l2_quantization <v4l2-quantization>`
 
        -  ``quantization``
@@ -146,7 +156,7 @@ describing all planes of that format.
 	  the driver for capture streams and by the application for output
 	  streams, see :ref:`colorspaces`.
 
-    -  .. row 11
+    -  .. row 12
 
        -  enum :ref:`v4l2_xfer_func <v4l2-xfer-func>`
 
@@ -156,7 +166,7 @@ describing all planes of that format.
 	  the driver for capture streams and by the application for output
 	  streams, see :ref:`colorspaces`.
 
-    -  .. row 12
+    -  .. row 13
 
        -  __u8
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index 987b9a8a9eb4..ef7518077e8a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -19,6 +19,15 @@ colorspace field of struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 or struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>`
 needs to be filled in.
 
+.. _hsv-colorspace:
+
+On :ref:`HSV formats <hsv-formats>` the *Hue* is defined as the angle on
+the cylindrical color representation. Usually this angle is measured in
+degrees, i.e. 0-360. When we map this angle value into 8 bits, there are
+two basic ways to do it: Divide the angular value by 2 (0-179), or use the
+whole range, 0-255, dividing the angular value by 1.41. The
+`v4l2_hsv_encoding <v4l2-hsv-encoding>` field specify which encoding is used.
+
 .. note:: The default R'G'B' quantization is full range for all
    colorspaces except for BT.2020 which uses limited range R'G'B'
    quantization.
@@ -286,3 +295,32 @@ needs to be filled in.
        -  Use the limited range quantization encoding. I.e. the range [0…1]
 	  is mapped to [16…235]. Cb and Cr are mapped from [-0.5…0.5] to
 	  [16…240].
+
+
+
+.. _v4l2-hsv-encoding:
+
+.. flat-table:: V4L2 HSV Encodings
+    :header-rows:  1
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  Identifier
+
+       -  Details
+
+    -  .. row 2
+
+       -  ``V4L2_HSV_ENC_180``
+
+       -  For the Hue, each LSB is two degrees.
+
+    -  .. row 3
+
+       -  ``V4L2_HSV_ENC_256``
+
+       -  For the Hue, the 360 degrees are mapped into 8 bits, i.e. each
+          LSB is roughtly 1.41 degrees.
+
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
index 60ac821e309d..c0239fd2c216 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
@@ -14,7 +14,8 @@ Packed HSV formats
 Description
 ===========
 
-The *hue* (h) is measured in degrees, one LSB represents two degrees.
+The *hue* (h) is measured in degrees, the equivalence between degrees and LSBs
+depends on the hsv-encoding used, see :ref:`colorspaces`.
 The *saturation* (s) and the *value* (v) are measured in percentage of the
 cylinder: 0 being the smallest value and 255 the maximum.
 
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 9bb9a6cc39d8..b47fef566d5f 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -87,6 +87,10 @@ replace symbol V4L2_YCBCR_ENC_XV601 v4l2-ycbcr-encoding
 replace symbol V4L2_YCBCR_ENC_XV709 v4l2-ycbcr-encoding
 replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding
 
+# Documented enum v4l2_hsv_encoding
+replace symbol V4L2_HSV_ENC_180 v4l2-hsv-encoding
+replace symbol V4L2_HSV_ENC_256 v4l2-hsv-encoding
+
 # Documented enum v4l2_quantization
 replace symbol V4L2_QUANTIZATION_DEFAULT v4l2-quantization
 replace symbol V4L2_QUANTIZATION_FULL_RANGE v4l2-quantization
-- 
2.8.1

