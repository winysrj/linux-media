Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56326 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/16] msi3101: add support for stream format "252" I+Q per frame
Date: Wed,  7 Aug 2013 21:51:42 +0300
Message-Id: <1375901507-26661-12-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That one seems to have 14-bit ADC resolution, wow!
It is now used when sampling rate is below 6 Msps.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 139 +++++++++++++++++++++++++---
 1 file changed, 125 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 4ff6030..a937d00 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -397,6 +397,8 @@ struct msi3101_state {
 	unsigned int vb_full; /* vb is full and packets dropped */
 
 	struct urb *urbs[MAX_ISO_BUFS];
+	int (*convert_stream) (struct msi3101_state *s, u32 *dst, u8 *src,
+			unsigned int src_len);
 
 	/* Controls */
 	struct v4l2_ctrl_handler ctrl_handler;
@@ -484,7 +486,7 @@ leave:
  */
 #define I2F_FRAC_BITS  23
 #define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
-static u32 msi3101_convert_sample(struct msi3101_state *s, u16 x, int shift)
+static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
 {
 	u32 msb, exponent, fraction, sign;
 	s->sample_ctrl_bit[shift]++;
@@ -521,7 +523,7 @@ static u32 msi3101_convert_sample(struct msi3101_state *s, u16 x, int shift)
 
 #define MSI3101_CONVERT_IN_URB_HANDLER
 #define MSI3101_EXTENSIVE_DEBUG
-static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 		u8 *src, unsigned int src_len)
 {
 	int i, j, k, l, i_max, dst_len = 0;
@@ -561,10 +563,10 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 					sample[2] = (src[l + 2] & 0xf0) >> 4 | (src[l + 3] & 0x3f) << 4;
 					sample[3] = (src[l + 3] & 0xc0) >> 6 | (src[l + 4] & 0xff) << 2;
 
-					*dst++ = msi3101_convert_sample(s, sample[0], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample(s, sample[1], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample(s, sample[2], (bits >> (2 * k)) & 0x3);
-					*dst++ = msi3101_convert_sample(s, sample[3], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample_384(s, sample[0], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample_384(s, sample[1], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample_384(s, sample[2], (bits >> (2 * k)) & 0x3);
+					*dst++ = msi3101_convert_sample_384(s, sample[3], (bits >> (2 * k)) & 0x3);
 
 					/* 4 x 32bit float samples */
 					dst_len += 4 * 4;
@@ -603,6 +605,103 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 }
 
 /*
+ * Converts signed 14-bit integer into 32-bit IEEE floating point
+ * representation.
+ * Will be exact from 0 to 2^24.  Above that, we round towards zero
+ * as the fractional bits will not fit in a float.  (It would be better to
+ * round towards even as the fpu does, but that is slower.)
+ */
+#define I2F_FRAC_BITS  23
+#define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
+static u32 msi3101_convert_sample_252(struct msi3101_state *s, u16 x)
+{
+	u32 msb, exponent, fraction, sign;
+
+	/* Zero is special */
+	if (!x)
+		return 0;
+
+	/* Negative / positive value */
+	if (x & (1 << 13)) {
+		x = -x;
+		x &= 0x1fff; /* result is 13 bit ... + sign */
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
+static int msi3101_convert_stream_252(struct msi3101_state *s, u32 *dst,
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
+		for (j = 0; j < 1008; j += 4) {
+			sample[0] = src[j + 0] >> 0 | src[j + 1] << 8;
+			sample[1] = src[j + 2] >> 0 | src[j + 3] << 8;
+
+			*dst++ = msi3101_convert_sample_252(s, sample[0]);
+			*dst++ = msi3101_convert_sample_252(s, sample[1]);
+		}
+		/* 252 x I+Q 32bit float samples */
+		dst_len += 252 * 2 * 4;
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
+	/* next sample (sample = sample + i * 252) */
+	s->next_sample = sample_num[i_max - 1] + 252;
+
+	return dst_len;
+}
+
+/*
  * This gets called for the Isochronous pipe (stream). This is done in interrupt
  * time, so it has to be fast, not crash, and not stall. Neat.
  */
@@ -636,6 +735,8 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 	/* Compact data */
 	for (i = 0; i < urb->number_of_packets; i++) {
+		void *ptr;
+
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
 		if (fstatus) {
@@ -664,9 +765,9 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 		/* fill framebuffer */
 #ifdef MSI3101_CONVERT_IN_URB_HANDLER
-		vb2_set_plane_payload(&fbuf->vb, 0,
-				msi3101_convert_stream(s,
-				vb2_plane_vaddr(&fbuf->vb, 0), iso_buf, flen));
+		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		flen = s->convert_stream(s, ptr, iso_buf, flen);
+		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 #else
 		memcpy(fbuf->data, iso_buf, flen);
 		fbuf->filled = flen;
@@ -908,7 +1009,7 @@ static int msi3101_buf_finish(struct vb2_buffer *vb)
 			container_of(vb, struct msi3101_frame_buf, vb);
 	int ret;
 	u32 *dst = vb2_plane_vaddr(&fbuf->vb, 0);
-	ret = msi3101_convert_stream(s, dst, fbuf->data, fbuf->filled);
+	ret = msi3101_convert_stream_384(s, dst, fbuf->data, fbuf->filled);
 	vb2_set_plane_payload(&fbuf->vb, 0, ret);
 	return 0;
 }
@@ -988,7 +1089,19 @@ static int msi3101_tuner_write(struct msi3101_state *s, u32 data)
 static int msi3101_set_usb_adc(struct msi3101_state *s)
 {
 	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
-	u32 reg4, reg3;
+	u32 reg3, reg4, reg7;
+
+	f_sr = s->ctrl_sampling_rate->val64;
+
+	/* select stream format */
+	if (f_sr < 6000000) {
+		s->convert_stream = msi3101_convert_stream_252;
+		reg7 = 0x00009407;
+	} else {
+		s->convert_stream = msi3101_convert_stream_384;
+		reg7 = 0x0000a507;
+	}
+
 	/*
 	 * Synthesizer config is just a educated guess...
 	 *
@@ -1016,8 +1129,6 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	 *
 	 * VCO 202000000 - 720000000++
 	 */
-
-	f_sr = s->ctrl_sampling_rate->val64;
 	reg3 = 0x01c00303;
 	reg4 = 0x00000004;
 
@@ -1062,7 +1173,7 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x0000a507);
+	ret = msi3101_ctrl_msg(s, CMD_WREG, reg7);
 	if (ret)
 		goto err;
 
-- 
1.7.11.7

