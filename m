Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55729 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3HQXKn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 19:10:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH STAGING 1/3] msi3101: implement stream format 504
Date: Sun, 18 Aug 2013 02:09:30 +0300
Message-Id: <1376780972-8977-2-git-send-email-crope@iki.fi>
In-Reply-To: <1376780972-8977-1-git-send-email-crope@iki.fi>
References: <1376780972-8977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That stream format carries 504 x I+Q samples per 1024 USB frame.
Sample resolution is 8-bit signed. Default it when sampling rate
is 9Msps or over.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 94 ++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index a3cc4c6..bf735f9 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -448,7 +448,7 @@ leave:
 
 /*
  * +===========================================================================
- * |   00-1023 | USB packet
+ * |   00-1023 | USB packet type '384'
  * +===========================================================================
  * |   00-  03 | sequence number of first sample in that USB packet
  * +---------------------------------------------------------------------------
@@ -502,6 +502,93 @@ leave:
 #define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
 
 /*
+ * Converts signed 8-bit integer into 32-bit IEEE floating point
+ * representation.
+ */
+static u32 msi3101_convert_sample_504(struct msi3101_state *s, u16 x)
+{
+	u32 msb, exponent, fraction, sign;
+
+	/* Zero is special */
+	if (!x)
+		return 0;
+
+	/* Negative / positive value */
+	if (x & (1 << 7)) {
+		x = -x;
+		x &= 0x7f; /* result is 7 bit ... + sign */
+		sign = 1 << 31;
+	} else {
+		sign = 0 << 31;
+	}
+
+	/* Get location of the most significant bit */
+	msb = __fls(x);
+
+	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
+	exponent = (127 + msb) << I2F_FRAC_BITS;
+
+	return (fraction + exponent) | sign;
+}
+
+static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
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
+		for (j = 0; j < 1008; j += 2) {
+			sample[0] = src[j + 0];
+			sample[1] = src[j + 1];
+
+			*dst++ = msi3101_convert_sample_504(s, sample[0]);
+			*dst++ = msi3101_convert_sample_504(s, sample[1]);
+		}
+		/* 504 x I+Q 32bit float samples */
+		dst_len += 504 * 2 * 4;
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
+	/* next sample (sample = sample + i * 504) */
+	s->next_sample = sample_num[i_max - 1] + 504;
+
+	return dst_len;
+}
+
+/*
  * Converts signed ~10+3-bit integer into 32-bit IEEE floating point
  * representation.
  */
@@ -1134,9 +1221,12 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	} else if (f_sr < 8000000) {
 		s->convert_stream = msi3101_convert_stream_336;
 		reg7 = 0x00008507;
-	} else {
+	} else if (f_sr < 9000000) {
 		s->convert_stream = msi3101_convert_stream_384;
 		reg7 = 0x0000a507;
+	} else {
+		s->convert_stream = msi3101_convert_stream_504;
+		reg7 = 0x000c9407;
 	}
 
 	/*
-- 
1.7.11.7

