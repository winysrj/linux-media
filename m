Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36561 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933160AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] videodev2.h: fix sYCC/AdobeYCC default quantization range
Date: Thu,  4 Aug 2016 11:28:15 +0200
Message-Id: <1470302901-29281-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The default quantization range of the Y'CbCr encodings of sRGB
and AdobeRGB are full range instead of limited range according to
the corresponding standards.

Fix this in the V4L2_MAP_QUANTIZATION_DEFAULT macro.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-007.rst | 4 ++--
 include/uapi/linux/videodev2.h              | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 8c946b0..017f166 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -339,7 +339,7 @@ The :ref:`adobergb` standard defines the colorspace used by computer
 graphics that use the AdobeRGB colorspace. This is also known as the
 :ref:`oprgb` standard. The default transfer function is
 ``V4L2_XFER_FUNC_ADOBERGB``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is limited
+``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is full
 range. The chromaticities of the primary colors and the white reference
 are:
 
@@ -412,7 +412,7 @@ the following ``V4L2_YCBCR_ENC_601`` encoding:
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. This transform is identical to one defined in SMPTE
-170M/BT.601. The Y'CbCr quantization is limited range.
+170M/BT.601. The Y'CbCr quantization is full range.
 
 
 .. _col-bt2020:
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 724f43e..12773f2 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -345,8 +345,8 @@ enum v4l2_quantization {
 	/*
 	 * The default for R'G'B' quantization is always full range, except
 	 * for the BT2020 colorspace. For Y'CbCr the quantization is always
-	 * limited range, except for COLORSPACE_JPEG, SYCC, XV601 or XV709:
-	 * those are full range.
+	 * limited range, except for COLORSPACE_JPEG, SRGB, ADOBERGB,
+	 * XV601 or XV709: those are full range.
 	 */
 	V4L2_QUANTIZATION_DEFAULT     = 0,
 	V4L2_QUANTIZATION_FULL_RANGE  = 1,
@@ -361,7 +361,8 @@ enum v4l2_quantization {
 #define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, colsp, ycbcr_enc) \
 	(((is_rgb) && (colsp) == V4L2_COLORSPACE_BT2020) ? V4L2_QUANTIZATION_LIM_RANGE : \
 	 (((is_rgb) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
-	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) ? \
+	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) || \
+	  (colsp) == V4L2_COLORSPACE_ADOBERGB || (colsp) == V4L2_COLORSPACE_SRGB ? \
 	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))
 
 enum v4l2_priority {
-- 
2.8.1

