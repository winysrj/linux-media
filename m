Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60127 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/16] msi3101: enhance sampling results
Date: Wed,  7 Aug 2013 21:51:36 +0300
Message-Id: <1375901507-26661-6-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It looks like there is some extra data carried to enhance sampling
results. When you tune to some some weak/empty channel those bits
are always zeroes. When you tune to some channel where is very
strong signals those bits are all zeroes.

Examining those 32-bits reveals shortly there is 16 pieces of 2-bit
numbers. Number seen are 0, 1 and 3 - for some reason 2 is not used.

I used that number to shift bits given amount to left, "increasing"
sampling resolution by 3-bits. It may be wrong, but after some testing
it still provides better signal.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 120 ++++++++++++++++------------
 1 file changed, 67 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index b6a8939..c73f1d9 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -409,6 +409,7 @@ struct msi3101_state {
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
 	unsigned long jiffies;
+	unsigned int sample_ctrl_bit[4];
 };
 
 /* Private functions */
@@ -430,6 +431,51 @@ leave:
 }
 
 /*
+ * +===========================================================================
+ * |   00-1024 | USB packet
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
+ * | 1000-1024 | garbage
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
+ */
+
+/*
  * Converts signed 10-bit integer into 32-bit IEEE floating point
  * representation.
  * Will be exact from 0 to 2^24.  Above that, we round towards zero
@@ -438,20 +484,24 @@ leave:
  */
 #define I2F_FRAC_BITS  23
 #define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
-static uint32_t msi3101_int2float(uint32_t x)
+static u32 msi3101_convert_sample(struct msi3101_state *s, u16 x, int shift)
 {
-	uint32_t msb, exponent, fraction, sign;
+	u32 msb, exponent, fraction, sign;
+	s->sample_ctrl_bit[shift]++;
 
 	/* Zero is special */
 	if (!x)
 		return 0;
 
-	/* Negative / positive value */
-	if (x & 0x200) {
+	/* Convert 10-bit two's complement to 13-bit */
+	if (x & (1 << 9)) {
+		x |= ~0U << 10; /* set all the rest bits to one */
+		x <<= shift;
 		x = -x;
-		x &= 0x3ff;
+		x &= 0xfff; /* result is 12 bit ... + sign */
 		sign = 1 << 31;
 	} else {
+		x <<= shift;
 		sign = 0 << 31;
 	}
 
@@ -476,6 +526,7 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 {
 	int i, j, k, l, i_max, dst_len = 0;
 	u16 sample[4];
+	u32 bits;
 #ifdef MSI3101_EXTENSIVE_DEBUG
 	u32 sample_num[3];
 #endif
@@ -493,6 +544,7 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 #endif
 		src += 16;
 		for (j = 0; j < 6; j++) {
+			bits = src[160 + 3] << 24 | src[160 + 2] << 16 | src[160 + 1] << 8 | src[160 + 0] << 0;
 			for (k = 0; k < 16; k++) {
 				for (l = 0; l < 10; l += 5) {
 					sample[0] = (src[l + 0] & 0xff) >> 0 | (src[l + 1] & 0x03) << 8;
@@ -500,10 +552,10 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 					sample[2] = (src[l + 2] & 0xf0) >> 4 | (src[l + 3] & 0x3f) << 4;
 					sample[3] = (src[l + 3] & 0xc0) >> 6 | (src[l + 4] & 0xff) << 2;
 
-					*dst++ = msi3101_int2float(sample[0]);
-					*dst++ = msi3101_int2float(sample[1]);
-					*dst++ = msi3101_int2float(sample[2]);
-					*dst++ = msi3101_int2float(sample[3]);
+					*dst++ = msi3101_convert_sample(s, sample[0], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample(s, sample[1], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample(s, sample[2], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample(s, sample[3], (bits >> (2 * k)) & 0x3);
 
 					/* 4 x 32bit float samples */
 					dst_len += 4 * 4;
@@ -511,9 +563,8 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 				src += 10;
 			}
 #ifdef MSI3101_EXTENSIVE_DEBUG
-			if (memcmp(src, "\xff\xff\xff\xff", 4) && memcmp(src, "\x00\x00\x00\x00", 4))
-				dev_dbg_ratelimited(&s->udev->dev,
-						"padding %*ph\n", 4, src);
+			dev_dbg_ratelimited(&s->udev->dev,
+					"sample control bits %08x\n", bits);
 #endif
 			src += 4;
 		}
@@ -529,9 +580,11 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 		s->jiffies = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
+				"slen=%d samples=%u msecs=%lu sampling rate=%lu bits=%d.%d.%d.%d\n",
 				src_len, samples, msecs,
-				samples * 1000UL / msecs);
+				samples * 1000UL / msecs,
+				s->sample_ctrl_bit[0], s->sample_ctrl_bit[1],
+				s->sample_ctrl_bit[2], s->sample_ctrl_bit[3]);
 	}
 
 	/* next sample (sample = sample + i * 384) */
@@ -833,45 +886,6 @@ static int msi3101_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-/*
- * +===========================================================================
- * |   00-1024 | USB packet
- * +===========================================================================
- * |   00-  03 | packet address
- * +---------------------------------------------------------------------------
- * |   04-  15 | garbage
- * +---------------------------------------------------------------------------
- * |   16- 175 | samples
- * +---------------------------------------------------------------------------
- * |  176- 179 | padding
- * +---------------------------------------------------------------------------
- * |  180- 339 | samples
- * +---------------------------------------------------------------------------
- * |  340- 343 | padding
- * +---------------------------------------------------------------------------
- * |  344- 503 | samples
- * +---------------------------------------------------------------------------
- * |  504- 507 | padding
- * +---------------------------------------------------------------------------
- * |  508- 667 | samples
- * +---------------------------------------------------------------------------
- * |  668- 671 | padding
- * +---------------------------------------------------------------------------
- * |  672- 831 | samples
- * +---------------------------------------------------------------------------
- * |  832- 835 | padding
- * +---------------------------------------------------------------------------
- * |  836- 995 | samples
- * +---------------------------------------------------------------------------
- * |  996- 999 | padding
- * +---------------------------------------------------------------------------
- * | 1000-1024 | garbage
- * +---------------------------------------------------------------------------
- *
- * bytes 4 - 7 could have some meaning?
- * padding is "00 00 00 00" or "ff ff ff ff"
- * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
- */
 #ifdef MSI3101_CONVERT_IN_URB_HANDLER
 static int msi3101_buf_finish(struct vb2_buffer *vb)
 {
-- 
1.7.11.7

