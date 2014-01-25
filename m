Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40193 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaAYRLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:03 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/52] msi3101: move format 384 conversion to libv4lconvert
Date: Sat, 25 Jan 2014 19:10:10 +0200
Message-Id: <1390669846-8131-17-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move format 384 conversion to libv4lconvert as a fourcc "M384".

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 163 ++++++++++------------------
 1 file changed, 57 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index ba68ea9..37fea45 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -386,6 +386,7 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
+#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
 /* stream formats */
 struct msi3101_format {
@@ -399,6 +400,10 @@ static struct msi3101_format formats[] = {
 		.name		= "I/Q 8-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
 	},
+	{
+		.name		= "I/Q 10+2-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_MSI2500_384,
+	},
 };
 
 static const int NUM_FORMATS = sizeof(formats) / sizeof(struct msi3101_format);
@@ -465,50 +470,6 @@ leave:
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 	return buf;
 }
-/*
- * +===========================================================================
- * |   00-1023 | USB packet type '384'
- * +===========================================================================
- * |   00-  03 | sequence number of first sample in that USB packet
- * +---------------------------------------------------------------------------
- * |   04-  15 | garbage
- * +---------------------------------------------------------------------------
- * |   16- 175 | samples
- * +---------------------------------------------------------------------------
- * |  176- 179 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  180- 339 | samples
- * +---------------------------------------------------------------------------
- * |  340- 343 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  344- 503 | samples
- * +---------------------------------------------------------------------------
- * |  504- 507 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  508- 667 | samples
- * +---------------------------------------------------------------------------
- * |  668- 671 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  672- 831 | samples
- * +---------------------------------------------------------------------------
- * |  832- 835 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * |  836- 995 | samples
- * +---------------------------------------------------------------------------
- * |  996- 999 | control bits for previous samples
- * +---------------------------------------------------------------------------
- * | 1000-1023 | garbage
- * +---------------------------------------------------------------------------
- *
- * Bytes 4 - 7 could have some meaning?
- *
- * Control bits for previous samples is 32-bit field, containing 16 x 2-bit
- * numbers. This results one 2-bit number for 8 samples. It is likely used for
- * for bit shifting sample by given bits, increasing actual sampling resolution.
- * Number 2 (0b10) was never seen.
- *
- * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
- */
 
 /*
  * Integer to 32-bit IEEE floating point representation routine is taken
@@ -585,48 +546,53 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 }
 
 /*
- * Converts signed ~10+2-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '384'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16- 175 | samples
+ * +---------------------------------------------------------------------------
+ * |  176- 179 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  180- 339 | samples
+ * +---------------------------------------------------------------------------
+ * |  340- 343 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  344- 503 | samples
+ * +---------------------------------------------------------------------------
+ * |  504- 507 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  508- 667 | samples
+ * +---------------------------------------------------------------------------
+ * |  668- 671 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  672- 831 | samples
+ * +---------------------------------------------------------------------------
+ * |  832- 835 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * |  836- 995 | samples
+ * +---------------------------------------------------------------------------
+ * |  996- 999 | control bits for previous samples
+ * +---------------------------------------------------------------------------
+ * | 1000-1023 | garbage
+ * +---------------------------------------------------------------------------
+ *
+ * Bytes 4 - 7 could have some meaning?
+ *
+ * Control bits for previous samples is 32-bit field, containing 16 x 2-bit
+ * numbers. This results one 2-bit number for 8 samples. It is likely used for
+ * for bit shifting sample by given bits, increasing actual sampling resolution.
+ * Number 2 (0b10) was never seen.
+ *
+ * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
  */
-static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
-{
-	u32 msb, exponent, fraction, sign;
-	s->sample_ctrl_bit[shift]++;
-
-	/* Zero is special */
-	if (!x)
-		return 0;
-
-	if (shift == 3)
-		shift =	2;
-
-	/* Convert 10-bit two's complement to 12-bit */
-	if (x & (1 << 9)) {
-		x |= ~0U << 10; /* set all the rest bits to one */
-		x <<= shift;
-		x = -x;
-		x &= 0x7ff; /* result is 11 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		x <<= shift;
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
-static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
-	int i, j, k, l, i_max, dst_len = 0;
-	u16 sample[4];
-	u32 bits;
+	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
 
 	/* There could be 1-3 1024 bytes URB frames */
@@ -647,30 +613,12 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 		dev_dbg_ratelimited(&s->udev->dev,
 				"%*ph  %*ph\n", 12, &src[4], 24, &src[1000]);
 
+		/* 384 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 6; j++) {
-			bits = src[160 + 3] << 24 | src[160 + 2] << 16 | src[160 + 1] << 8 | src[160 + 0] << 0;
-			for (k = 0; k < 16; k++) {
-				for (l = 0; l < 10; l += 5) {
-					sample[0] = (src[l + 0] & 0xff) >> 0 | (src[l + 1] & 0x03) << 8;
-					sample[1] = (src[l + 1] & 0xfc) >> 2 | (src[l + 2] & 0x0f) << 6;
-					sample[2] = (src[l + 2] & 0xf0) >> 4 | (src[l + 3] & 0x3f) << 4;
-					sample[3] = (src[l + 3] & 0xc0) >> 6 | (src[l + 4] & 0xff) << 2;
-
-					*dst++ = msi3101_convert_sample_384(s, sample[0], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample_384(s, sample[1], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample_384(s, sample[2], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample_384(s, sample[3], (bits >> (2 * k)) & 0x3);
-				}
-				src += 10;
-			}
-			dev_dbg_ratelimited(&s->udev->dev,
-					"sample control bits %08x\n", bits);
-			src += 4;
-		}
-		/* 384 x I+Q 32bit float samples */
-		dst_len += 384 * 2 * 4;
-		src += 24;
+		memcpy(dst, src, 984);
+		src += 984 + 24;
+		dst += 984;
+		dst_len += 984;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
@@ -1236,6 +1184,9 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	if (s->pixelformat == V4L2_PIX_FMT_SDR_S8) {
 		s->convert_stream = msi3101_convert_stream_504;
 		reg7 = 0x000c9407;
+	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_MSI2500_384) {
+		s->convert_stream = msi3101_convert_stream_384;
+		reg7 = 0x0000a507;
 	}
 
 	/*
-- 
1.8.5.3

