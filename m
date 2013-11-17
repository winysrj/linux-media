Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59945 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3KQURu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:17:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 3/6] libv4lconvert: SDR conversion from S8 to FLOAT
Date: Sun, 17 Nov 2013 22:17:29 +0200
Message-Id: <1384719452-21744-4-git-send-email-crope@iki.fi>
In-Reply-To: <1384719452-21744-1-git-send-email-crope@iki.fi>
References: <1384719452-21744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SDR I/Q data conversion from signed 8-bit to [-1 to +1] float.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 contrib/freebsd/include/linux/videodev2.h |  1 +
 include/linux/videodev2.h                 |  1 +
 lib/libv4lconvert/libv4lconvert.c         | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
index 05cc19b..d433a45 100644
--- a/contrib/freebsd/include/linux/videodev2.h
+++ b/contrib/freebsd/include/linux/videodev2.h
@@ -468,6 +468,7 @@ struct v4l2_pix_format {
 /* SDR */
 #define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ba2a173..35b5731 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -434,6 +434,7 @@ struct v4l2_pix_format {
 /* SDR */
 #define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index b7cc0e1..421a8f1 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -447,6 +447,7 @@ static int v4lconvert_do_try_format_sdr(struct v4lconvert_data *data,
 	static const unsigned int supported_src_pixfmts_sdr[] = {
 		V4L2_PIX_FMT_SDR_FLOAT,
 		V4L2_PIX_FMT_SDR_U8,
+		V4L2_PIX_FMT_SDR_S8,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts_sdr); i++) {
@@ -1334,6 +1335,7 @@ static int v4lconvert_convert_sdr(struct v4lconvert_data *data,
 	int i, dest_needed;
 	unsigned int src_pix_fmt = fmt->fmt.pix.pixelformat;
 	float *fptr = (float *) dest;
+	int8_t *s8ptr;
 
 	switch (src_pix_fmt) {
 	case V4L2_PIX_FMT_SDR_U8:
@@ -1345,6 +1347,16 @@ static int v4lconvert_convert_sdr(struct v4lconvert_data *data,
 		for (i = 0; i < src_size; i++)
 			*fptr++ = (*src++ - 127.5f) / 127.5f;
 		break;
+	case V4L2_PIX_FMT_SDR_S8:
+		s8ptr = (int8_t *) src;
+		/* 8-bit signed to 32-bit float */
+		dest_needed = src_size * sizeof(float);
+		if (dest_size < dest_needed)
+			goto err_buf_too_small;
+
+		for (i = 0; i < src_size; i++)
+			*fptr++ = (*s8ptr++ + 0.5f) / 127.5f;
+		break;
 	default:
 		V4LCONVERT_ERR("Unknown src format in conversion\n");
 		errno = EINVAL;
-- 
1.8.4.2

