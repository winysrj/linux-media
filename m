Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 31/51] Documentation: pixfmt-007.rst: Fix formula parsing
Date: Mon,  4 Jul 2016 08:46:52 -0300
Message-Id: <a3be60d68c3bb8ba090386a5f8c3d86e325fcd24.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of warnings there:

/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:74: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:89: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:168: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:183: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:206: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:216: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:292: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:308: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:393: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:478: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:657: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:735: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:746: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:822: ERROR: Unexpected indentation.
/devel/v4l/patchwork/Documentation/linux_tv/media/v4l/pixfmt-007.rst:833: ERROR: Unexpected indentation.

Also, sometimes the :sup: tag was ignored. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-007.rst | 81 +++++++++++++++++--------
 1 file changed, 57 insertions(+), 24 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-007.rst b/Documentation/linux_tv/media/v4l/pixfmt-007.rst
index 636506cefec1..7caceea855a0 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-007.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-007.rst
@@ -71,21 +71,24 @@ SMPTE C set, so this colorspace is sometimes called SMPTE C as well.
 
 The transfer function defined for SMPTE 170M is the same as the one
 defined in Rec. 709.
-    L' = -1.099(-L):sup:`0.45` + 0.099 for L ≤ -0.018
+
+    L' = -1.099(-L) :sup:`0.45` + 0.099 for L ≤ -0.018
 
     L' = 4.5L for -0.018 < L < 0.018
 
-    L' = 1.099L\ :sup:`0.45` - 0.099 for L ≥ 0.018
+    L' = 1.099L :sup:`0.45` - 0.099 for L ≥ 0.018
 
 Inverse Transfer function:
-    L = -((L' - 0.099) / -1.099):sup:`1/0.45` for L' ≤ -0.081
+
+    L = -((L' - 0.099) / -1.099) :sup:`1/0.45` for L' ≤ -0.081
 
     L = L' / 4.5 for -0.081 < L' < 0.081
 
-    L = ((L' + 0.099) / 1.099)\ :sup:`1/0.45` for L' ≥ 0.081
+    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
@@ -165,21 +168,24 @@ The full name of this standard is Rec. ITU-R BT.709-5.
 
 Transfer function. Normally L is in the range [0…1], but for the
 extended gamut xvYCC encoding values outside that range are allowed.
-    L' = -1.099(-L):sup:`0.45` + 0.099 for L ≤ -0.018
+
+    L' = -1.099(-L) :sup:`0.45` + 0.099 for L ≤ -0.018
 
     L' = 4.5L for -0.018 < L < 0.018
 
-    L' = 1.099L\ :sup:`0.45` - 0.099 for L ≥ 0.018
+    L' = 1.099L :sup:`0.45` - 0.099 for L ≥ 0.018
 
 Inverse Transfer function:
-    L = -((L' - 0.099) / -1.099):sup:`1/0.45` for L' ≤ -0.081
+
+    L = -((L' - 0.099) / -1.099) :sup:`1/0.45` for L' ≤ -0.081
 
     L = L' / 4.5 for -0.081 < L' < 0.081
 
-    L = ((L' + 0.099) / 1.099)\ :sup:`1/0.45` for L' ≥ 0.081
+    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_709`` encoding:
+
     Y' = 0.2126R' + 0.7152G' + 0.0722B'
 
     Cb = -0.1146R' - 0.3854G' + 0.5B'
@@ -203,6 +209,7 @@ The xvYCC 709 encoding (``V4L2_YCBCR_ENC_XV709``, :ref:`xvycc`) is
 similar to the Rec. 709 encoding, but it allows for R', G' and B' values
 that are outside the range [0…1]. The resulting Y', Cb and Cr values are
 scaled and offset:
+
     Y' = (219 / 256) * (0.2126R' + 0.7152G' + 0.0722B') + (16 / 256)
 
     Cb = (224 / 256) * (-0.1146R' - 0.3854G' + 0.5B')
@@ -213,6 +220,7 @@ The xvYCC 601 encoding (``V4L2_YCBCR_ENC_XV601``, :ref:`xvycc`) is
 similar to the BT.601 encoding, but it allows for R', G' and B' values
 that are outside the range [0…1]. The resulting Y', Cb and Cr values are
 scaled and offset:
+
     Y' = (219 / 256) * (0.299R' + 0.587G' + 0.114B') + (16 / 256)
 
     Cb = (224 / 256) * (-0.169R' - 0.331G' + 0.5B')
@@ -289,22 +297,25 @@ These chromaticities are identical to the Rec. 709 colorspace.
 
 Transfer function. Note that negative values for L are only used by the
 Y'CbCr conversion.
-    L' = -1.055(-L):sup:`1/2.4` + 0.055 for L < -0.0031308
+
+    L' = -1.055(-L) :sup:`1/2.4` + 0.055 for L < -0.0031308
 
     L' = 12.92L for -0.0031308 ≤ L ≤ 0.0031308
 
-    L' = 1.055L\ :sup:`1/2.4` - 0.055 for 0.0031308 < L ≤ 1
+    L' = 1.055L :sup:`1/2.4` - 0.055 for 0.0031308 < L ≤ 1
 
 Inverse Transfer function:
-    L = -((-L' + 0.055) / 1.055)\ :sup:`2.4` for L' < -0.04045
+
+    L = -((-L' + 0.055) / 1.055) :sup:`2.4` for L' < -0.04045
 
     L = L' / 12.92 for -0.04045 ≤ L' ≤ 0.04045
 
-    L = ((L' + 0.055) / 1.055)\ :sup:`2.4` for L' > 0.04045
+    L = ((L' + 0.055) / 1.055) :sup:`2.4` for L' > 0.04045
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_SYCC`` encoding as defined by
 :ref:`sycc`:
+
     Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
     Cb = -0.1687R' - 0.3313G' + 0.5B'
@@ -383,13 +394,16 @@ are:
 
 
 Transfer function:
-    L' = L\ :sup:`1/2.19921875`
+
+    L' = L :sup:`1/2.19921875`
 
 Inverse Transfer function:
-    L = L'\ :sup:`2.19921875`
+
+    L = L' :sup:`2.19921875`
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
@@ -464,17 +478,20 @@ of the primary colors and the white reference are:
 
 
 Transfer function (same as Rec. 709):
+
     L' = 4.5L for 0 ≤ L < 0.018
 
-    L' = 1.099L\ :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
+    L' = 1.099L :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
 
 Inverse Transfer function:
+
     L = L' / 4.5 for L' < 0.081
 
-    L = ((L' + 0.099) / 1.099)\ :sup:`1/0.45` for L' ≥ 0.081
+    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_BT2020`` encoding:
+
     Y' = 0.2627R' + 0.6780G' + 0.0593B'
 
     Cb = -0.1396R' - 0.3604G' + 0.5B'
@@ -488,18 +505,23 @@ There is also an alternate constant luminance R'G'B' to Yc'CbcCrc
 (``V4L2_YCBCR_ENC_BT2020_CONST_LUM``) encoding:
 
 Luma:
+
     Yc' = (0.2627R + 0.6780G + 0.0593B)'
 
 B' - Yc' ≤ 0:
+
     Cbc = (B' - Yc') / 1.9404
 
 B' - Yc' > 0:
+
     Cbc = (B' - Yc') / 1.5816
 
 R' - Yc' ≤ 0:
+
     Crc = (R' - Y') / 1.7184
 
 R' - Yc' > 0:
+
     Crc = (R' - Y') / 0.9936
 
 Yc' is clamped to the range [0…1] and Cbc and Crc are clamped to the
@@ -571,10 +593,12 @@ primary colors and the white reference are:
 
 
 Transfer function:
-    L' = L\ :sup:`1/2.6`
+
+    L' = L :sup:`1/2.6`
 
 Inverse Transfer function:
-    L = L'\ :sup:`2.6`
+
+    L = L' :sup:`2.6`
 
 Y'CbCr encoding is not specified. V4L2 defaults to Rec. 709.
 
@@ -643,17 +667,20 @@ and the white reference are:
 These chromaticities are identical to the SMPTE 170M colorspace.
 
 Transfer function:
+
     L' = 4L for 0 ≤ L < 0.0228
 
-    L' = 1.1115L\ :sup:`0.45` - 0.1115 for 0.0228 ≤ L ≤ 1
+    L' = 1.1115L :sup:`0.45` - 0.1115 for 0.0228 ≤ L ≤ 1
 
 Inverse Transfer function:
+
     L = L' / 4 for 0 ≤ L' < 0.0913
 
-    L = ((L' + 0.1115) / 1.1115)\ :sup:`1/0.45` for L' ≥ 0.0913
+    L = ((L' + 0.1115) / 1.1115) :sup:`1/0.45` for L' ≥ 0.0913
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_SMPTE240M`` encoding:
+
     Y' = 0.2122R' + 0.7013G' + 0.0865B'
 
     Cb = -0.1161R' - 0.3839G' + 0.5B'
@@ -732,17 +759,20 @@ the Bradford method.
 
 The transfer function was never properly defined for NTSC 1953. The Rec.
 709 transfer function is recommended in the literature:
+
     L' = 4.5L for 0 ≤ L < 0.018
 
-    L' = 1.099L\ :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
+    L' = 1.099L :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
 
 Inverse Transfer function:
+
     L = L' / 4.5 for L' < 0.081
 
-    L = ((L' + 0.099) / 1.099)\ :sup:`1/0.45` for L' ≥ 0.081
+    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
@@ -819,17 +849,20 @@ are:
 
 The transfer function was never properly defined for this colorspace.
 The Rec. 709 transfer function is recommended in the literature:
+
     L' = 4.5L for 0 ≤ L < 0.018
 
-    L' = 1.099L\ :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
+    L' = 1.099L :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
 
 Inverse Transfer function:
+
     L = L' / 4.5 for L' < 0.081
 
-    L = ((L' + 0.099) / 1.099)\ :sup:`1/0.45` for L' ≥ 0.081
+    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
-- 
2.7.4


