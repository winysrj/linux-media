Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35426 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab3KQURu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:17:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 1/6] libv4lconvert: SDR conversion from U8 to FLOAT
Date: Sun, 17 Nov 2013 22:17:27 +0200
Message-Id: <1384719452-21744-2-git-send-email-crope@iki.fi>
In-Reply-To: <1384719452-21744-1-git-send-email-crope@iki.fi>
References: <1384719452-21744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert unsigned 8 to float 32 [-1 to +1], which is commonly
used format for baseband signals by SDR applications.

Some implementation changes done as suggested by Hans Verkuil,
Hans de Goede and Andy Walls.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 contrib/freebsd/include/linux/videodev2.h |  4 ++
 include/linux/videodev2.h                 |  4 ++
 lib/libv4lconvert/libv4lconvert.c         | 77 +++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
index 1fcfaeb..05cc19b 100644
--- a/contrib/freebsd/include/linux/videodev2.h
+++ b/contrib/freebsd/include/linux/videodev2.h
@@ -465,6 +465,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
 #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
 
+/* SDR */
+#define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
+#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+
 /*
  *	F O R M A T   E N U M E R A T I O N
  */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 437f1b0..ba2a173 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -431,6 +431,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
 #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
 
+/* SDR */
+#define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
+#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+
 /*
  *	F O R M A T   E N U M E R A T I O N
  */
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index e2afc27..b7cc0e1 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -266,6 +266,10 @@ int v4lconvert_supported_dst_format(unsigned int pixelformat)
 {
 	int i;
 
+	/* only supported SDR destination format */
+	if (pixelformat == V4L2_PIX_FMT_SDR_FLOAT)
+		return 1;
+
 	for (i = 0; i < ARRAY_SIZE(supported_dst_pixfmts); i++)
 		if (supported_dst_pixfmts[i].fmt == pixelformat)
 			break;
@@ -435,6 +439,32 @@ static int v4lconvert_do_try_format_uvc(struct v4lconvert_data *data,
 	return 0;
 }
 
+static int v4lconvert_do_try_format_sdr(struct v4lconvert_data *data,
+		struct v4l2_format *dest_fmt, struct v4l2_format *src_fmt)
+{
+	int i;
+	struct v4l2_format try_fmt;
+	static const unsigned int supported_src_pixfmts_sdr[] = {
+		V4L2_PIX_FMT_SDR_FLOAT,
+		V4L2_PIX_FMT_SDR_U8,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts_sdr); i++) {
+		try_fmt = *dest_fmt;
+		try_fmt.fmt.pix.pixelformat = supported_src_pixfmts_sdr[i];
+		if (data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
+				VIDIOC_TRY_FMT, &try_fmt))
+			continue;
+
+		if (try_fmt.fmt.pix.pixelformat != supported_src_pixfmts_sdr[i])
+			continue;
+	}
+
+	*src_fmt = try_fmt;
+
+	return 0;
+}
+
 static int v4lconvert_do_try_format(struct v4lconvert_data *data,
 		struct v4l2_format *dest_fmt, struct v4l2_format *src_fmt)
 {
@@ -445,6 +475,8 @@ static int v4lconvert_do_try_format(struct v4lconvert_data *data,
 
 	if (data->flags & V4LCONVERT_IS_UVC)
 		return v4lconvert_do_try_format_uvc(data, dest_fmt, src_fmt);
+	else if (dest_fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_SDR_FLOAT)
+		return v4lconvert_do_try_format_sdr(data, dest_fmt, src_fmt);
 
 	for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts); i++) {
 		/* is this format supported? */
@@ -1293,6 +1325,43 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 	return result;
 }
 
+/* SDR format conversions */
+static int v4lconvert_convert_sdr(struct v4lconvert_data *data,
+		unsigned char *src, int src_size,
+		unsigned char *dest, int dest_size,
+		struct v4l2_format *fmt, unsigned int dest_pix_fmt)
+{
+	int i, dest_needed;
+	unsigned int src_pix_fmt = fmt->fmt.pix.pixelformat;
+	float *fptr = (float *) dest;
+
+	switch (src_pix_fmt) {
+	case V4L2_PIX_FMT_SDR_U8:
+		/* 8-bit unsigned to 32-bit float */
+		dest_needed = src_size * sizeof(float);
+		if (dest_size < dest_needed)
+			goto err_buf_too_small;
+
+		for (i = 0; i < src_size; i++)
+			*fptr++ = (*src++ - 127.5f) / 127.5f;
+		break;
+	default:
+		V4LCONVERT_ERR("Unknown src format in conversion\n");
+		errno = EINVAL;
+		return -1;
+	}
+
+	fmt->fmt.pix.pixelformat = dest_pix_fmt;
+
+	return dest_needed;
+
+err_buf_too_small:
+	V4LCONVERT_ERR("destination buffer too small (%d < %d)\n",
+			dest_size, dest_needed);
+	errno = EFAULT;
+	return -1;
+}
+
 int v4lconvert_convert(struct v4lconvert_data *data,
 		const struct v4l2_format *src_fmt,  /* in */
 		const struct v4l2_format *dest_fmt, /* in */
@@ -1310,6 +1379,14 @@ int v4lconvert_convert(struct v4lconvert_data *data,
 	struct v4l2_format my_src_fmt = *src_fmt;
 	struct v4l2_format my_dest_fmt = *dest_fmt;
 
+	/* SDR */
+	switch (my_dest_fmt.fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_SDR_FLOAT:
+		return v4lconvert_convert_sdr(data, src, src_size,
+				convert2_dest, convert2_dest_size,
+				&my_src_fmt, my_dest_fmt.fmt.pix.pixelformat);
+	}
+
 	processing = v4lprocessing_pre_processing(data->processing);
 	rotate90 = data->control_flags & V4LCONTROL_ROTATED_90_JPEG;
 	hflip = v4lcontrol_get_ctrl(data->control, V4LCONTROL_HFLIP);
-- 
1.8.4.2

