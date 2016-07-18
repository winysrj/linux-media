Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33649 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcGRMmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:36 -0400
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
Subject: [PATCH v4 10/12] [media] videodev2.h Add HSV encoding
Date: Mon, 18 Jul 2016 14:42:14 +0200
Message-Id: <1468845736-19651-11-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some hardware maps the Hue between 0 and 255 instead of 0-179. Support
this format with a new field hsv_enc.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 include/uapi/linux/videodev2.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c7fb760386cf..49edc462ca8e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -330,6 +330,15 @@ enum v4l2_ycbcr_encoding {
 	V4L2_YCBCR_ENC_SMPTE240M      = 8,
 };
 
+enum v4l2_hsv_encoding {
+
+	/* Hue mapped to 0 - 179 */
+	V4L2_HSV_ENC_180		= 16,
+
+	/* Hue mapped to 0-255 */
+	V4L2_HSV_ENC_256		= 17,
+};
+
 /*
  * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
  * This depends on the colorspace.
@@ -455,7 +464,12 @@ struct v4l2_pix_format {
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
@@ -1988,7 +2002,10 @@ struct v4l2_pix_format_mplane {
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

