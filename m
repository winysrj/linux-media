Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51887 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaBIIt5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:57 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 17/86] msi3101: move format 336 conversion to libv4lconvert
Date: Sun,  9 Feb 2014 10:48:22 +0200
Message-Id: <1391935771-18670-18-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move format 384 conversion to libv4lconvert as a fourcc "DS12".
It is 12-bit sample pairs packed to 3 bytes.

msi3101: move format 336 conversion 336 to libv4l

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 66 +++++++++++------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 37fea45..7c1dc43 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -386,6 +386,7 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
+#define V4L2_PIX_FMT_SDR_S12     v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
 /* stream formats */
@@ -399,10 +400,12 @@ static struct msi3101_format formats[] = {
 	{
 		.name		= "I/Q 8-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
-	},
-	{
+	}, {
 		.name		= "I/Q 10+2-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_MSI2500_384,
+	}, {
+		.name		= "I/Q 12-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_S12,
 	},
 };
 
@@ -643,40 +646,21 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 }
 
 /*
- * Converts signed 12-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '336'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16-1023 | samples
+ * +---------------------------------------------------------------------------
+ * signed 12-bit sample
  */
-static u32 msi3101_convert_sample_336(struct msi3101_state *s, u16 x)
-{
-	u32 msb, exponent, fraction, sign;
-
-	/* Zero is special */
-	if (!x)
-		return 0;
-
-	/* Negative / positive value */
-	if (x & (1 << 11)) {
-		x = -x;
-		x &= 0x7ff; /* result is 11 bit ... + sign */
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
-static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
-	int i, j, i_max, dst_len = 0;
-	u16 sample[2];
+	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
 
 	/* There could be 1-3 1024 bytes URB frames */
@@ -697,17 +681,12 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
+		/* 336 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 1008; j += 3) {
-			sample[0] = (src[j + 0] & 0xff) >> 0 | (src[j + 1] & 0x0f) << 8;
-			sample[1] = (src[j + 1] & 0xf0) >> 4 | (src[j + 2] & 0xff) << 4;
-
-			*dst++ = msi3101_convert_sample_336(s, sample[0]);
-			*dst++ = msi3101_convert_sample_336(s, sample[1]);
-		}
-		/* 336 x I+Q 32bit float samples */
-		dst_len += 336 * 2 * 4;
+		memcpy(dst, src, 1008);
 		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
@@ -1187,6 +1166,9 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_MSI2500_384) {
 		s->convert_stream = msi3101_convert_stream_384;
 		reg7 = 0x0000a507;
+	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S12) {
+		s->convert_stream = msi3101_convert_stream_336;
+		reg7 = 0x00008507;
 	}
 
 	/*
-- 
1.8.5.3

