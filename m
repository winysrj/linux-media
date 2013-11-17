Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57861 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3KQURu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:17:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 4/6] libv4lconvert: SDR conversion from MSi2500 format 384 to FLOAT
Date: Sun, 17 Nov 2013 22:17:30 +0200
Message-Id: <1384719452-21744-5-git-send-email-crope@iki.fi>
In-Reply-To: <1384719452-21744-1-git-send-email-crope@iki.fi>
References: <1384719452-21744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is one Mirics MSi2500 (MSi3101) USB ADC specific source format.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 contrib/freebsd/include/linux/videodev2.h |  1 +
 include/linux/videodev2.h                 |  1 +
 lib/libv4lconvert/libv4lconvert.c         | 49 +++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
index d433a45..7d87b01 100644
--- a/contrib/freebsd/include/linux/videodev2.h
+++ b/contrib/freebsd/include/linux/videodev2.h
@@ -469,6 +469,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
+#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 35b5731..ce1acea 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -435,6 +435,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
+#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 421a8f1..88e056f 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -448,6 +448,7 @@ static int v4lconvert_do_try_format_sdr(struct v4lconvert_data *data,
 		V4L2_PIX_FMT_SDR_FLOAT,
 		V4L2_PIX_FMT_SDR_U8,
 		V4L2_PIX_FMT_SDR_S8,
+		V4L2_PIX_FMT_SDR_MSI2500_384,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts_sdr); i++) {
@@ -1357,6 +1358,54 @@ static int v4lconvert_convert_sdr(struct v4lconvert_data *data,
 		for (i = 0; i < src_size; i++)
 			*fptr++ = (*s8ptr++ + 0.5f) / 127.5f;
 		break;
+	case V4L2_PIX_FMT_SDR_MSI2500_384:
+		/* Mirics MSi2500 format 384 */
+		dest_needed = src_size / 164 * 128 * sizeof(float);
+		if (dest_size < dest_needed)
+			goto err_buf_too_small;
+
+		for (i = 0; i < (src_size / 164); i++) {
+			uint32_t bits;
+			int j, k;
+			bits = src[160 + 3] << 24 | src[160 + 2] << 16 | src[160 + 1] << 8 | src[160 + 0] << 0;
+
+			for (j = 0; j < 16; j++) {
+				unsigned int shift;
+				shift = (bits >> (2 * j)) & 0x3;
+				if (shift == 3)
+					shift =	2;
+
+				for (k = 0; k < 10; k += 5) {
+					uint32_t usample[4];
+					int ssample[4];
+
+					usample[0] = (src[k + 0] & 0xff) >> 0 | (src[k + 1] & 0x03) << 8;
+					usample[1] = (src[k + 1] & 0xfc) >> 2 | (src[k + 2] & 0x0f) << 6;
+					usample[2] = (src[k + 2] & 0xf0) >> 4 | (src[k + 3] & 0x3f) << 4;
+					usample[3] = (src[k + 3] & 0xc0) >> 6 | (src[k + 4] & 0xff) << 2;
+
+					/* Sign extension from 10-bit */
+					struct {signed int x:10; } s;
+					ssample[0] = s.x = usample[0];
+					ssample[1] = s.x = usample[1];
+					ssample[2] = s.x = usample[2];
+					ssample[3] = s.x = usample[3];
+
+					ssample[0] <<= shift;
+					ssample[1] <<= shift;
+					ssample[2] <<= shift;
+					ssample[3] <<= shift;
+
+					*fptr++ = (ssample[0] + 0.5f) / 2047.5f;
+					*fptr++ = (ssample[1] + 0.5f) / 2047.5f;
+					*fptr++ = (ssample[2] + 0.5f) / 2047.5f;
+					*fptr++ = (ssample[3] + 0.5f) / 2047.5f;
+				}
+				src += 10; /* samples */
+			}
+			src += 4; /* control bits */
+		}
+		break;
 	default:
 		V4LCONVERT_ERR("Unknown src format in conversion\n");
 		errno = EINVAL;
-- 
1.8.4.2

