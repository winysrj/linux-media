Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34440 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbbEOM3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/6] videodev2.h: add macros to map colorspace defaults
Date: Fri, 15 May 2015 14:29:09 +0200
Message-Id: <1431692950-17453-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
References: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The mapping of COLORSPACE_DEFAULT, YCBCR_ENC_DEFAULT or QUANTIZATION_DEFAULT
to proper non-default values is fairly complex, and it is something that
needs to be done both in the kernel and in userspace.

So add macros that can do this conversion, making this available to both
kernel and userspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3837030..0f68d84 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -231,6 +231,15 @@ enum v4l2_colorspace {
 	V4L2_COLORSPACE_RAW           = 11,
 };
 
+/*
+ * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
+ * This depends on whether this is a SDTV image (use SMPTE 170M), an
+ * HDTV image (use Rec. 709), or something else (use sRGB).
+ */
+#define V4L2_MAP_COLORSPACE_DEFAULT(is_sdtv, is_hdtv) \
+	((is_sdtv) ? V4L2_COLORSPACE_SMPTE170M : \
+	 ((is_hdtv) ? V4L2_COLORSPACE_REC709 : V4L2_COLORSPACE_SRGB))
+
 enum v4l2_ycbcr_encoding {
 	/*
 	 * Mapping of V4L2_YCBCR_ENC_DEFAULT to actual encodings for the
@@ -275,6 +284,16 @@ enum v4l2_ycbcr_encoding {
 	V4L2_YCBCR_ENC_SMPTE240M      = 8,
 };
 
+/*
+ * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
+ * This depends on the colorspace.
+ */
+#define V4L2_MAP_YCBCR_ENC_DEFAULT(colsp) \
+	((colsp) == V4L2_COLORSPACE_REC709 ? V4L2_YCBCR_ENC_709 : \
+	 ((colsp) == V4L2_COLORSPACE_BT2020 ? V4L2_YCBCR_ENC_BT2020 : \
+	  ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_YCBCR_ENC_SMPTE240M : \
+	   V4L2_YCBCR_ENC_601)))
+
 enum v4l2_quantization {
 	/*
 	 * The default for R'G'B' quantization is always full range, except
@@ -287,6 +306,17 @@ enum v4l2_quantization {
 	V4L2_QUANTIZATION_LIM_RANGE   = 2,
 };
 
+/*
+ * Determine how QUANTIZATION_DEFAULT should map to a proper quantization.
+ * This depends on whether the image is RGB or not, the colorspace and the
+ * Y'CbCr encoding.
+ */
+#define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, colsp, ycbcr_enc) \
+	(((is_rgb) && (colsp) == V4L2_COLORSPACE_BT2020) ? V4L2_QUANTIZATION_LIM_RANGE : \
+	 (((is_rgb) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
+	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) ? \
+	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))
+
 enum v4l2_priority {
 	V4L2_PRIORITY_UNSET       = 0,  /* not initialized */
 	V4L2_PRIORITY_BACKGROUND  = 1,
-- 
2.1.4

