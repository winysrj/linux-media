Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44091 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3KQUW1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:22:27 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 7/7] msi3101: move format 252 conversion to libv4lconvert
Date: Sun, 17 Nov 2013 22:22:11 +0200
Message-Id: <1384719731-21887-7-git-send-email-crope@iki.fi>
In-Reply-To: <1384719731-21887-1-git-send-email-crope@iki.fi>
References: <1384719731-21887-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move format 252 conversion to libv4lconvert as a fourcc "DS14".
It is 14-bit sample pairs packed to 4 bytes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 64 +++++++++++------------------
 include/uapi/linux/videodev2.h              |  1 +
 2 files changed, 24 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index cc96fdd..c278fa6 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -402,6 +402,9 @@ static struct msi3101_format formats[] = {
 	}, {
 		.name		= "I/Q 12-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S12,
+	}, {
+		.name		= "I/Q 14-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_S14,
 	},
 };
 
@@ -435,7 +438,7 @@ struct msi3101_state {
 	unsigned int vb_full; /* vb is full and packets dropped */
 
 	struct urb *urbs[MAX_ISO_BUFS];
-	int (*convert_stream) (struct msi3101_state *s, u32 *dst, u8 *src,
+	int (*convert_stream) (struct msi3101_state *s, u8 *dst, u8 *src,
 			unsigned int src_len);
 
 	/* Controls */
@@ -705,40 +708,21 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 }
 
 /*
- * Converts signed 14-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '252'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16-1023 | samples
+ * +---------------------------------------------------------------------------
+ * signed 14-bit sample
  */
-static u32 msi3101_convert_sample_252(struct msi3101_state *s, u16 x)
-{
-	u32 msb, exponent, fraction, sign;
-
-	/* Zero is special */
-	if (!x)
-		return 0;
-
-	/* Negative / positive value */
-	if (x & (1 << 13)) {
-		x = -x;
-		x &= 0x1fff; /* result is 13 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		sign = 0 << 31;
-	}
-
-	/* Get location of the most significant bit */
-	msb = __fls(x);
-
-	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
-	exponent = (127 + msb) << I2F_FRAC_BITS;
-
-	return (fraction + exponent) | sign;
-}
-
-static int msi3101_convert_stream_252(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
-	int i, j, i_max, dst_len = 0;
-	u16 sample[2];
+	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
 
 	/* There could be 1-3 1024 bytes URB frames */
@@ -759,17 +743,12 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
+		/* 252 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 1008; j += 4) {
-			sample[0] = src[j + 0] >> 0 | src[j + 1] << 8;
-			sample[1] = src[j + 2] >> 0 | src[j + 3] << 8;
-
-			*dst++ = msi3101_convert_sample_252(s, sample[0]);
-			*dst++ = msi3101_convert_sample_252(s, sample[1]);
-		}
-		/* 252 x I+Q 32bit float samples */
-		dst_len += 252 * 2 * 4;
+		memcpy(dst, src, 1008);
 		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
@@ -1159,6 +1138,9 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S12) {
 		s->convert_stream = msi3101_convert_stream_336;
 		reg7 = 0x00008507;
+	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S14) {
+		s->convert_stream = msi3101_convert_stream_252;
+		reg7 = 0x00009407;
 	}
 
 	/*
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 80b17d9..b8ee9048 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -437,6 +437,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 #define V4L2_PIX_FMT_SDR_S12     v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
+#define V4L2_PIX_FMT_SDR_S14     v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.8.4.2

