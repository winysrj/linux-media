Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35035 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768357AbcHROfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 10:35:46 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 10/12] [media] videodev2.h Add HSV encoding
Date: Thu, 18 Aug 2016 16:33:36 +0200
Message-Id: <1471530818-7928-11-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some hardware maps the Hue between 0 and 255 instead of 0-179. Support
this format with a new field hsv_enc.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 include/uapi/linux/videodev2.h | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 58ed8aedc196..71a4c3c13ee0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -335,6 +335,19 @@ enum v4l2_ycbcr_encoding {
 };
 
 /*
+ * enum v4l2_hsv_encoding values should not collide with the ones from
+ * enum v4l2_ycbcr_encoding.
+ */
+enum v4l2_hsv_encoding {
+
+	/* Hue mapped to 0 - 179 */
+	V4L2_HSV_ENC_180		= 128,
+
+	/* Hue mapped to 0-255 */
+	V4L2_HSV_ENC_256		= 129,
+};
+
+/*
  * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
  * This depends on the colorspace.
  */
@@ -362,9 +375,10 @@ enum v4l2_quantization {
  * This depends on whether the image is RGB or not, the colorspace and the
  * Y'CbCr encoding.
  */
-#define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, colsp, ycbcr_enc) \
-	(((is_rgb) && (colsp) == V4L2_COLORSPACE_BT2020) ? V4L2_QUANTIZATION_LIM_RANGE : \
-	 (((is_rgb) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
+#define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb_or_yuv, colsp, ycbcr_enc) \
+	(((is_rgb_or_yuv) && (colsp) == V4L2_COLORSPACE_BT2020) ? \
+	 V4L2_QUANTIZATION_LIM_RANGE : \
+	 (((is_rgb_or_yuv) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
 	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) || \
 	  (colsp) == V4L2_COLORSPACE_ADOBERGB || (colsp) == V4L2_COLORSPACE_SRGB ? \
 	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))
@@ -460,7 +474,12 @@ struct v4l2_pix_format {
 	__u32			colorspace;	/* enum v4l2_colorspace */
 	__u32			priv;		/* private data, depends on pixelformat */
 	__u32			flags;		/* format flags (V4L2_PIX_FMT_FLAG_*) */
-	__u32			ycbcr_enc;	/* enum v4l2_ycbcr_encoding */
+	union {
+		/* enum v4l2_ycbcr_encoding */
+		__u32			ycbcr_enc;
+		/* enum v4l2_hsv_encoding */
+		__u32			hsv_enc;
+	};
 	__u32			quantization;	/* enum v4l2_quantization */
 	__u32			xfer_func;	/* enum v4l2_xfer_func */
 };
@@ -1993,7 +2012,10 @@ struct v4l2_pix_format_mplane {
 	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
 	__u8				num_planes;
 	__u8				flags;
-	__u8				ycbcr_enc;
+	 union {
+		__u8				ycbcr_enc;
+		__u8				hsv_enc;
+	};
 	__u8				quantization;
 	__u8				xfer_func;
 	__u8				reserved[7];
-- 
2.8.1

