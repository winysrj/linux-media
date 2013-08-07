Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41923 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/16] msi3101: add stream format 336 I+Q pairs per frame
Date: Wed,  7 Aug 2013 21:51:45 +0300
Message-Id: <1375901507-26661-15-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That one seem to have 12-bit resolution. Use it for streams that
has sampling rate 6 <= rate (Msps) < 8, between 6 and 8Msps.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 95 +++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 56f9757..c4bd963 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -605,6 +605,98 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 }
 
 /*
+ * Converts signed 12-bit integer into 32-bit IEEE floating point
+ * representation.
+ */
+static u32 msi3101_convert_sample_336(struct msi3101_state *s, u16 x)
+{
+	u32 msb, exponent, fraction, sign;
+
+	/* Zero is special */
+	if (!x)
+		return 0;
+
+	/* Negative / positive value */
+	if (x & (1 << 11)) {
+		x = -x;
+		x &= 0x7ff; /* result is 11 bit ... + sign */
+		sign = 1 << 31;
+	} else {
+		sign = 0 << 31;
+	}
+
+	/* Get location of the most significant bit */
+	msb = __fls(x);
+
+	/*
+	 * Use a rotate instead of a shift because that works both leftwards
+	 * and rightwards due to the mod(32) behaviour.  This means we don't
+	 * need to check to see if we are above 2^24 or not.
+	 */
+	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
+	exponent = (127 + msb) << I2F_FRAC_BITS;
+
+	return (fraction + exponent) | sign;
+}
+
+static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
+		u8 *src, unsigned int src_len)
+{
+	int i, j, i_max, dst_len = 0;
+	u16 sample[2];
+	u32 sample_num[3];
+
+	/* There could be 1-3 1024 bytes URB frames */
+	i_max = src_len / 1024;
+
+	for (i = 0; i < i_max; i++) {
+		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
+		if (i == 0 && s->next_sample != sample_num[0]) {
+			dev_dbg_ratelimited(&s->udev->dev,
+					"%d samples lost, %d %08x:%08x\n",
+					sample_num[0] - s->next_sample,
+					src_len, s->next_sample, sample_num[0]);
+		}
+
+		/*
+		 * Dump all unknown 'garbage' data - maybe we will discover
+		 * someday if there is something rational...
+		 */
+		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
+
+		src += 16;
+		for (j = 0; j < 1008; j += 3) {
+			sample[0] = (src[j + 0] & 0xff) >> 0 | (src[j + 1] & 0x0f) << 8;
+			sample[1] = (src[j + 1] & 0xf0) >> 4 | (src[j + 2] & 0xff) << 4;
+
+			*dst++ = msi3101_convert_sample_336(s, sample[0]);
+			*dst++ = msi3101_convert_sample_336(s, sample[1]);
+		}
+		/* 336 x I+Q 32bit float samples */
+		dst_len += 336 * 2 * 4;
+		src += 1008;
+	}
+
+	/* calculate samping rate and output it in 10 seconds intervals */
+	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+		unsigned long jiffies_now = jiffies;
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		s->jiffies = jiffies_now;
+		s->sample = sample_num[i_max - 1];
+		dev_dbg(&s->udev->dev,
+				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
+				src_len, samples, msecs,
+				samples * 1000UL / msecs);
+	}
+
+	/* next sample (sample = sample + i * 336) */
+	s->next_sample = sample_num[i_max - 1] + 336;
+
+	return dst_len;
+}
+
+/*
  * Converts signed 14-bit integer into 32-bit IEEE floating point
  * representation.
  * Will be exact from 0 to 2^24.  Above that, we round towards zero
@@ -1097,6 +1189,9 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	if (f_sr < 6000000) {
 		s->convert_stream = msi3101_convert_stream_252;
 		reg7 = 0x00009407;
+	} else if (f_sr < 8000000) {
+		s->convert_stream = msi3101_convert_stream_336;
+		reg7 = 0x00008507;
 	} else {
 		s->convert_stream = msi3101_convert_stream_384;
 		reg7 = 0x0000a507;
-- 
1.7.11.7

