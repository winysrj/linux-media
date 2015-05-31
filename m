Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38310 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757681AbbEaNLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:11:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/9] videodev2.h: add support for transfer functions
Date: Sun, 31 May 2015 15:11:31 +0200
Message-Id: <1433077899-18516-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In the past the transfer function was implied by the colorspace. However,
it is an independent entity in its own right. Add support for explicitly
choosing the transfer function.

This change will allow us to represent linear RGB (as is used by openGL), and
it will make it easier to work with decoded video material since most codecs
store the transfer function as a separate property as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |  9 ++++----
 include/media/v4l2-mediabus.h        |  2 ++
 include/uapi/linux/v4l2-mediabus.h   |  4 +++-
 include/uapi/linux/videodev2.h       | 41 +++++++++++++++++++++++++++++++++++-
 4 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 368bc3a..6912959 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -257,7 +257,8 @@ static void v4l_print_format(const void *arg, bool write_only)
 		pr_cont(", width=%u, height=%u, "
 			"pixelformat=%c%c%c%c, field=%s, "
 			"bytesperline=%u, sizeimage=%u, colorspace=%d, "
-			"flags=0x%x, ycbcr_enc=%u, quantization=%u\n",
+			"flags=0x%x, ycbcr_enc=%u, quantization=%u, "
+			"xfer_func=%u\n",
 			pix->width, pix->height,
 			(pix->pixelformat & 0xff),
 			(pix->pixelformat >>  8) & 0xff,
@@ -266,7 +267,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 			prt_names(pix->field, v4l2_field_names),
 			pix->bytesperline, pix->sizeimage,
 			pix->colorspace, pix->flags, pix->ycbcr_enc,
-			pix->quantization);
+			pix->quantization, pix->xfer_func);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
@@ -274,7 +275,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 		pr_cont(", width=%u, height=%u, "
 			"format=%c%c%c%c, field=%s, "
 			"colorspace=%d, num_planes=%u, flags=0x%x, "
-			"ycbcr_enc=%u, quantization=%u\n",
+			"ycbcr_enc=%u, quantization=%u, xfer_func=%u\n",
 			mp->width, mp->height,
 			(mp->pixelformat & 0xff),
 			(mp->pixelformat >>  8) & 0xff,
@@ -282,7 +283,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 			(mp->pixelformat >> 24) & 0xff,
 			prt_names(mp->field, v4l2_field_names),
 			mp->colorspace, mp->num_planes, mp->flags,
-			mp->ycbcr_enc, mp->quantization);
+			mp->ycbcr_enc, mp->quantization, mp->xfer_func);
 		for (i = 0; i < mp->num_planes; i++)
 			printk(KERN_DEBUG "plane %u: bytesperline=%u sizeimage=%u\n", i,
 					mp->plane_fmt[i].bytesperline,
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 38d960d..73069e4 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -96,6 +96,7 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
 	pix_fmt->colorspace = mbus_fmt->colorspace;
 	pix_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
 	pix_fmt->quantization = mbus_fmt->quantization;
+	pix_fmt->xfer_func = mbus_fmt->xfer_func;
 }
 
 static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
@@ -108,6 +109,7 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
 	mbus_fmt->colorspace = pix_fmt->colorspace;
 	mbus_fmt->ycbcr_enc = pix_fmt->ycbcr_enc;
 	mbus_fmt->quantization = pix_fmt->quantization;
+	mbus_fmt->xfer_func = pix_fmt->xfer_func;
 	mbus_fmt->code = code;
 }
 
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 26db206..9cac632 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -24,6 +24,7 @@
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
  * @ycbcr_enc:	YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
  * @quantization: quantization of the data (from enum v4l2_quantization)
+ * @xfer_func:  transfer function of the data (from enum v4l2_xfer_func)
  */
 struct v4l2_mbus_framefmt {
 	__u32			width;
@@ -33,7 +34,8 @@ struct v4l2_mbus_framefmt {
 	__u32			colorspace;
 	__u16			ycbcr_enc;
 	__u16			quantization;
-	__u32			reserved[6];
+	__u16			xfer_func;
+	__u16			reserved[11];
 };
 
 #ifndef __KERNEL__
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 003a912..3d5fc72 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -240,6 +240,42 @@ enum v4l2_colorspace {
 	((is_sdtv) ? V4L2_COLORSPACE_SMPTE170M : \
 	 ((is_hdtv) ? V4L2_COLORSPACE_REC709 : V4L2_COLORSPACE_SRGB))
 
+enum v4l2_xfer_func {
+	/*
+	 * Mapping of V4L2_XFER_FUNC_DEFAULT to actual transfer functions
+	 * for the various colorspaces:
+	 *
+	 * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
+	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_REC709 and
+	 * V4L2_COLORSPACE_BT2020: V4L2_XFER_FUNC_709
+	 *
+	 * V4L2_COLORSPACE_SRGB, V4L2_COLORSPACE_JPEG: V4L2_XFER_FUNC_SRGB
+	 *
+	 * V4L2_COLORSPACE_ADOBERGB: V4L2_XFER_FUNC_ADOBERGB
+	 *
+	 * V4L2_COLORSPACE_SMPTE240M: V4L2_XFER_FUNC_SMPTE240M
+	 *
+	 * V4L2_COLORSPACE_RAW: V4L2_XFER_FUNC_NONE
+	 */
+	V4L2_XFER_FUNC_DEFAULT     = 0,
+	V4L2_XFER_FUNC_709         = 1,
+	V4L2_XFER_FUNC_SRGB        = 2,
+	V4L2_XFER_FUNC_ADOBERGB    = 3,
+	V4L2_XFER_FUNC_SMPTE240M   = 4,
+	V4L2_XFER_FUNC_NONE        = 5,
+};
+
+/*
+ * Determine how XFER_FUNC_DEFAULT should map to a proper transfer function.
+ * This depends on the colorspace.
+ */
+#define V4L2_MAP_XFER_FUNC_DEFAULT(colsp) \
+	((colsp) == V4L2_XFER_FUNC_ADOBERGB ? V4L2_XFER_FUNC_ADOBERGB : \
+	 ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_XFER_FUNC_SMPTE240M : \
+	  ((colsp) == V4L2_COLORSPACE_RAW ? V4L2_XFER_FUNC_NONE : \
+	   ((colsp) == V4L2_COLORSPACE_SRGB || (colsp) == V4L2_COLORSPACE_JPEG ? \
+	    V4L2_XFER_FUNC_SRGB : V4L2_XFER_FUNC_709))))
+
 enum v4l2_ycbcr_encoding {
 	/*
 	 * Mapping of V4L2_YCBCR_ENC_DEFAULT to actual encodings for the
@@ -409,6 +445,7 @@ struct v4l2_pix_format {
 	__u32			flags;		/* format flags (V4L2_PIX_FMT_FLAG_*) */
 	__u32			ycbcr_enc;	/* enum v4l2_ycbcr_encoding */
 	__u32			quantization;	/* enum v4l2_quantization */
+	__u32			xfer_func;	/* enum v4l2_xfer_func */
 };
 
 /*      Pixel format         FOURCC                          depth  Description  */
@@ -1907,6 +1944,7 @@ struct v4l2_plane_pix_format {
  * @flags:		format flags (V4L2_PIX_FMT_FLAG_*)
  * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
  * @quantization:	enum v4l2_quantization, colorspace quantization
+ * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1920,7 +1958,8 @@ struct v4l2_pix_format_mplane {
 	__u8				flags;
 	__u8				ycbcr_enc;
 	__u8				quantization;
-	__u8				reserved[8];
+	__u8				xfer_func;
+	__u8				reserved[7];
 } __attribute__ ((packed));
 
 /**
-- 
2.1.4

