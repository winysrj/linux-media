Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49051 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3KQURv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:17:51 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 5/6] libv4lconvert: SDR conversion from packed S12 to FLOAT
Date: Sun, 17 Nov 2013 22:17:31 +0200
Message-Id: <1384719452-21744-6-git-send-email-crope@iki.fi>
In-Reply-To: <1384719452-21744-1-git-send-email-crope@iki.fi>
References: <1384719452-21744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is 12-bit sample pairs packed to 3 bytes. fourcc "DS12".

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 contrib/freebsd/include/linux/videodev2.h |  1 +
 include/linux/videodev2.h                 |  1 +
 lib/libv4lconvert/libv4lconvert.c         | 23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
index 7d87b01..c2f6a71 100644
--- a/contrib/freebsd/include/linux/videodev2.h
+++ b/contrib/freebsd/include/linux/videodev2.h
@@ -470,6 +470,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
+#define V4L2_PIX_FMT_SDR_S12     v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ce1acea..80b17d9 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -436,6 +436,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
+#define V4L2_PIX_FMT_SDR_S12     v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 88e056f..ccb9c0f 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -449,6 +449,7 @@ static int v4lconvert_do_try_format_sdr(struct v4lconvert_data *data,
 		V4L2_PIX_FMT_SDR_U8,
 		V4L2_PIX_FMT_SDR_S8,
 		V4L2_PIX_FMT_SDR_MSI2500_384,
+		V4L2_PIX_FMT_SDR_S12,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts_sdr); i++) {
@@ -1406,6 +1407,28 @@ static int v4lconvert_convert_sdr(struct v4lconvert_data *data,
 			src += 4; /* control bits */
 		}
 		break;
+	case V4L2_PIX_FMT_SDR_S12:
+		/* 12-bit signed to 32-bit float */
+		dest_needed = src_size / 3 * 2 * sizeof(float);
+		if (dest_size < dest_needed)
+			goto err_buf_too_small;
+
+		for (i = 0; i < src_size; i += 3) {
+			uint32_t usample[2];
+			int sample[2];
+
+			usample[0] = (src[i + 0] & 0xff) >> 0 | (src[i + 1] & 0x0f) << 8;
+			usample[1] = (src[i + 1] & 0xf0) >> 4 | (src[i + 2] & 0xff) << 4;
+
+			/* Sign extension from 12-bit */
+			struct {signed int x:12; } s;
+			sample[0] = s.x = usample[0];
+			sample[1] = s.x = usample[1];
+
+			*fptr++ = (sample[0] + 0.5f) / 2047.5f;
+			*fptr++ = (sample[1] + 0.5f) / 2047.5f;
+		}
+		break;
 	default:
 		V4LCONVERT_ERR("Unknown src format in conversion\n");
 		errno = EINVAL;
-- 
1.8.4.2

