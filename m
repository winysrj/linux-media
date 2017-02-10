Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43688 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751590AbdBJJSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 04:18:41 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        Eric Anholt <eric@anholt.net>,
        Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videodev2.h: go back to limited range Y'CbCr for SRGB and,
 ADOBERGB
Message-ID: <429f7c4e-a63e-eeea-4c3c-8cc74a816ffc@xs4all.nl>
Date: Fri, 10 Feb 2017 10:18:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 7e0739cd9c40752fc9d31cac86e3a31d5537be18
('videodev2.h: fix sYCC/AdobeYCC default quantization range').

The problem is that many drivers can convert R'G'B' content (often
from sensors) to Y'CbCr, but they all produce limited range Y'CbCr.

To stay backwards compatible the default quantization range for
sRGB and AdobeRGB Y'CbCr encoding should be limited range, not full
range, even though the corresponding standards specify full range.

Update the V4L2_MAP_QUANTIZATION_DEFAULT define accordingly and
also update the documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.9 and up
---
 Documentation/media/uapi/v4l/pixfmt-007.rst | 23 +++++++++++++++++------
 include/uapi/linux/videodev2.h              |  7 +++----
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 44bb5a7059b3..95a23a28c595 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -211,7 +211,13 @@ Colorspace sRGB (V4L2_COLORSPACE_SRGB)
 The :ref:`srgb` standard defines the colorspace used by most webcams
 and computer graphics. The default transfer function is
 ``V4L2_XFER_FUNC_SRGB``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is full range.
+``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is limited range.
+
+Note that the :ref:`sycc` standard specifies full range quantization,
+however all current capture hardware supported by the kernel convert
+R'G'B' to limited range Y'CbCr. So choosing full range as the default
+would break how applications interpret the quantization range.
+
 The chromaticities of the primary colors and the white reference are:


@@ -276,7 +282,7 @@ the following ``V4L2_YCBCR_ENC_601`` encoding as defined by :ref:`sycc`:

 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. This transform is identical to one defined in SMPTE
-170M/BT.601. The Y'CbCr quantization is full range.
+170M/BT.601. The Y'CbCr quantization is limited range.


 .. _col-adobergb:
@@ -288,10 +294,15 @@ The :ref:`adobergb` standard defines the colorspace used by computer
 graphics that use the AdobeRGB colorspace. This is also known as the
 :ref:`oprgb` standard. The default transfer function is
 ``V4L2_XFER_FUNC_ADOBERGB``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is full
-range. The chromaticities of the primary colors and the white reference
-are:
+``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is limited
+range.
+
+Note that the :ref:`oprgb` standard specifies full range quantization,
+however all current capture hardware supported by the kernel convert
+R'G'B' to limited range Y'CbCr. So choosing full range as the default
+would break how applications interpret the quantization range.

+The chromaticities of the primary colors and the white reference are:


 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
@@ -344,7 +355,7 @@ the following ``V4L2_YCBCR_ENC_601`` encoding:

 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. This transform is identical to one defined in SMPTE
-170M/BT.601. The Y'CbCr quantization is full range.
+170M/BT.601. The Y'CbCr quantization is limited range.


 .. _col-bt2020:
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 46e8a2e369f9..45184a2ef66c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -362,8 +362,8 @@ enum v4l2_quantization {
 	/*
 	 * The default for R'G'B' quantization is always full range, except
 	 * for the BT2020 colorspace. For Y'CbCr the quantization is always
-	 * limited range, except for COLORSPACE_JPEG, SRGB, ADOBERGB,
-	 * XV601 or XV709: those are full range.
+	 * limited range, except for COLORSPACE_JPEG, XV601 or XV709: those
+	 * are full range.
 	 */
 	V4L2_QUANTIZATION_DEFAULT     = 0,
 	V4L2_QUANTIZATION_FULL_RANGE  = 1,
@@ -379,8 +379,7 @@ enum v4l2_quantization {
 	(((is_rgb_or_hsv) && (colsp) == V4L2_COLORSPACE_BT2020) ? \
 	 V4L2_QUANTIZATION_LIM_RANGE : \
 	 (((is_rgb_or_hsv) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
-	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) || \
-	  (colsp) == V4L2_COLORSPACE_ADOBERGB || (colsp) == V4L2_COLORSPACE_SRGB ? \
+	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) ? \
 	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))

 enum v4l2_priority {
-- 
2.11.0

