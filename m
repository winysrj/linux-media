Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54275 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbaGVIjj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 04:39:39 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] msi2500: refactor USB stream copying
Date: Tue, 22 Jul 2014 11:39:26 +0300
Message-Id: <1406018366-25792-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a lot of duplicated functionality between different
stream format handling. Refactor functionality in order to get
rid of duplicated code.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 437 +++++++++---------------------------
 1 file changed, 103 insertions(+), 334 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 755f959..5bce38e 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -146,8 +146,6 @@ struct msi3101_state {
 	unsigned int vb_full; /* vb is full and packets dropped */
 
 	struct urb *urbs[MAX_ISO_BUFS];
-	int (*convert_stream)(struct msi3101_state *s, u8 *dst, u8 *src,
-			unsigned int src_len);
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
@@ -188,118 +186,8 @@ leave:
  * +---------------------------------------------------------------------------
  * signed 8-bit sample
  * 504 * 2 = 1008 samples
- */
-static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
-		u8 *src, unsigned int src_len)
-{
-	int i, i_max, dst_len = 0;
-	u32 sample_num[3];
-
-	/* There could be 1-3 1024 bytes URB frames */
-	i_max = src_len / 1024;
-
-	for (i = 0; i < i_max; i++) {
-		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->next_sample != sample_num[0]) {
-			dev_dbg_ratelimited(&s->udev->dev,
-					"%d samples lost, %d %08x:%08x\n",
-					sample_num[0] - s->next_sample,
-					src_len, s->next_sample, sample_num[0]);
-		}
-
-		/*
-		 * Dump all unknown 'garbage' data - maybe we will discover
-		 * someday if there is something rational...
-		 */
-		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
-
-		/* 504 x I+Q samples */
-		src += 16;
-		memcpy(dst, src, 1008);
-		src += 1008;
-		dst += 1008;
-		dst_len += 1008;
-	}
-
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
-		unsigned int samples = sample_num[i_max - 1] - s->sample;
-
-		s->jiffies_next = jiffies_now;
-		s->sample = sample_num[i_max - 1];
-		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
-	}
-
-	/* next sample (sample = sample + i * 504) */
-	s->next_sample = sample_num[i_max - 1] + 504;
-
-	return dst_len;
-}
-
-static int msi3101_convert_stream_504_u8(struct msi3101_state *s, u8 *dst,
-		u8 *src, unsigned int src_len)
-{
-	int i, j, i_max, dst_len = 0;
-	u32 sample_num[3];
-	s8 *s8src;
-	u8 *u8dst;
-
-	/* There could be 1-3 1024 bytes URB frames */
-	i_max = src_len / 1024;
-	u8dst = (u8 *) dst;
-
-	for (i = 0; i < i_max; i++) {
-		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->next_sample != sample_num[0]) {
-			dev_dbg_ratelimited(&s->udev->dev,
-					"%d samples lost, %d %08x:%08x\n",
-					sample_num[0] - s->next_sample,
-					src_len, s->next_sample, sample_num[0]);
-		}
-
-		/*
-		 * Dump all unknown 'garbage' data - maybe we will discover
-		 * someday if there is something rational...
-		 */
-		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
-
-		/* 504 x I+Q samples */
-		src += 16;
-
-		s8src = (s8 *) src;
-		for (j = 0; j < 1008; j++)
-			*u8dst++ = *s8src++ + 128;
-
-		src += 1008;
-		dst += 1008;
-		dst_len += 1008;
-	}
-
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
-#define MSECS 10000UL
-		unsigned int samples = sample_num[i_max - 1] - s->sample;
-
-		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
-		s->sample = sample_num[i_max - 1];
-		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, MSECS,
-				samples * 1000UL / MSECS);
-	}
-
-	/* next sample (sample = sample + i * 504) */
-	s->next_sample = sample_num[i_max - 1] + 504;
-
-	return dst_len;
-}
-
-/*
+ *
+ *
  * +===========================================================================
  * |   00-1023 | USB packet type '384'
  * +===========================================================================
@@ -342,62 +230,8 @@ static int msi3101_convert_stream_504_u8(struct msi3101_state *s, u8 *dst,
  * Number 2 (0b10) was never seen.
  *
  * 6 * 16 * 2 * 4 = 768 samples. 768 * 4 = 3072 bytes
- */
-static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
-		u8 *src, unsigned int src_len)
-{
-	int i, i_max, dst_len = 0;
-	u32 sample_num[3];
-
-	/* There could be 1-3 1024 bytes URB frames */
-	i_max = src_len / 1024;
-	for (i = 0; i < i_max; i++) {
-		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->next_sample != sample_num[0]) {
-			dev_dbg_ratelimited(&s->udev->dev,
-					"%d samples lost, %d %08x:%08x\n",
-					sample_num[0] - s->next_sample,
-					src_len, s->next_sample, sample_num[0]);
-		}
-
-		/*
-		 * Dump all unknown 'garbage' data - maybe we will discover
-		 * someday if there is something rational...
-		 */
-		dev_dbg_ratelimited(&s->udev->dev,
-				"%*ph  %*ph\n", 12, &src[4], 24, &src[1000]);
-
-		/* 384 x I+Q samples */
-		src += 16;
-		memcpy(dst, src, 984);
-		src += 984 + 24;
-		dst += 984;
-		dst_len += 984;
-	}
-
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
-		unsigned int samples = sample_num[i_max - 1] - s->sample;
-
-		s->jiffies_next = jiffies_now;
-		s->sample = sample_num[i_max - 1];
-		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu bits=%d.%d.%d.%d\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs,
-				s->sample_ctrl_bit[0], s->sample_ctrl_bit[1],
-				s->sample_ctrl_bit[2], s->sample_ctrl_bit[3]);
-	}
-
-	/* next sample (sample = sample + i * 384) */
-	s->next_sample = sample_num[i_max - 1] + 384;
-
-	return dst_len;
-}
-
-/*
+ *
+ *
  * +===========================================================================
  * |   00-1023 | USB packet type '336'
  * +===========================================================================
@@ -408,60 +242,8 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
  * |   16-1023 | samples
  * +---------------------------------------------------------------------------
  * signed 12-bit sample
- */
-static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
-		u8 *src, unsigned int src_len)
-{
-	int i, i_max, dst_len = 0;
-	u32 sample_num[3];
-
-	/* There could be 1-3 1024 bytes URB frames */
-	i_max = src_len / 1024;
-
-	for (i = 0; i < i_max; i++) {
-		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->next_sample != sample_num[0]) {
-			dev_dbg_ratelimited(&s->udev->dev,
-					"%d samples lost, %d %08x:%08x\n",
-					sample_num[0] - s->next_sample,
-					src_len, s->next_sample, sample_num[0]);
-		}
-
-		/*
-		 * Dump all unknown 'garbage' data - maybe we will discover
-		 * someday if there is something rational...
-		 */
-		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
-
-		/* 336 x I+Q samples */
-		src += 16;
-		memcpy(dst, src, 1008);
-		src += 1008;
-		dst += 1008;
-		dst_len += 1008;
-	}
-
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
-		unsigned int samples = sample_num[i_max - 1] - s->sample;
-
-		s->jiffies_next = jiffies_now;
-		s->sample = sample_num[i_max - 1];
-		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
-	}
-
-	/* next sample (sample = sample + i * 336) */
-	s->next_sample = sample_num[i_max - 1] + 336;
-
-	return dst_len;
-}
-
-/*
+ *
+ *
  * +===========================================================================
  * |   00-1023 | USB packet type '252'
  * +===========================================================================
@@ -473,76 +255,24 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
  * +---------------------------------------------------------------------------
  * signed 14-bit sample
  */
-static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
-		u8 *src, unsigned int src_len)
-{
-	int i, i_max, dst_len = 0;
-	u32 sample_num[3];
-
-	/* There could be 1-3 1024 bytes URB frames */
-	i_max = src_len / 1024;
 
-	for (i = 0; i < i_max; i++) {
-		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->next_sample != sample_num[0]) {
-			dev_dbg_ratelimited(&s->udev->dev,
-					"%d samples lost, %d %08x:%08x\n",
-					sample_num[0] - s->next_sample,
-					src_len, s->next_sample, sample_num[0]);
-		}
-
-		/*
-		 * Dump all unknown 'garbage' data - maybe we will discover
-		 * someday if there is something rational...
-		 */
-		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
-
-		/* 252 x I+Q samples */
-		src += 16;
-		memcpy(dst, src, 1008);
-		src += 1008;
-		dst += 1008;
-		dst_len += 1008;
-	}
-
-	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
-		unsigned int samples = sample_num[i_max - 1] - s->sample;
-
-		s->jiffies_next = jiffies_now;
-		s->sample = sample_num[i_max - 1];
-		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
-	}
-
-	/* next sample (sample = sample + i * 252) */
-	s->next_sample = sample_num[i_max - 1] + 252;
-
-	return dst_len;
-}
-
-static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
-		u8 *src, unsigned int src_len)
+static int msi3101_convert_stream(struct msi3101_state *s, u8 *dst, u8 *src,
+		unsigned int src_len)
 {
-	int i, j, i_max, dst_len = 0;
-	u32 sample_num[3];
-	u16 *u16dst = (u16 *) dst;
-	struct {signed int x:14; } se;
+	unsigned int i, j, transactions, dst_len = 0;
+	u32 sample[3];
 
-	/* There could be 1-3 1024 bytes URB frames */
-	i_max = src_len / 1024;
+	/* There could be 1-3 1024 byte transactions per packet */
+	transactions = src_len / 1024;
 
-	for (i = 0; i < i_max; i++) {
-		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->next_sample != sample_num[0]) {
+	for (i = 0; i < transactions; i++) {
+		sample[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 |
+				src[0] << 0;
+		if (i == 0 && s->next_sample != sample[0]) {
 			dev_dbg_ratelimited(&s->udev->dev,
 					"%d samples lost, %d %08x:%08x\n",
-					sample_num[0] - s->next_sample,
-					src_len, s->next_sample, sample_num[0]);
+					sample[0] - s->next_sample,
+					src_len, s->next_sample, sample[0]);
 		}
 
 		/*
@@ -551,50 +281,96 @@ static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
-		/* 252 x I+Q samples */
-		src += 16;
-
-		for (j = 0; j < 1008; j += 4) {
-			unsigned int usample[2];
-			int ssample[2];
+		src += 16; /* skip header */
 
-			usample[0] = src[j + 0] >> 0 | src[j + 1] << 8;
-			usample[1] = src[j + 2] >> 0 | src[j + 3] << 8;
+		switch (s->pixelformat) {
+		case V4L2_SDR_FMT_CU8: /* 504 x IQ samples */
+		{
+			s8 *s8src = (s8 *) src;
+			u8 *u8dst = (u8 *) dst;
 
-			/* sign extension from 14-bit to signed int */
-			ssample[0] = se.x = usample[0];
-			ssample[1] = se.x = usample[1];
+			for (j = 0; j < 1008; j++)
+				*u8dst++ = *s8src++ + 128;
 
-			/* from signed to unsigned */
-			usample[0] = ssample[0] + 8192;
-			usample[1] = ssample[1] + 8192;
-
-			/* from 14-bit to 16-bit */
-			*u16dst++ = (usample[0] << 2) | (usample[0] >> 12);
-			*u16dst++ = (usample[1] << 2) | (usample[1] >> 12);
+			src += 1008;
+			dst += 1008;
+			dst_len += 1008;
+			s->next_sample = sample[i] + 504;
+			break;
 		}
+		case  V4L2_SDR_FMT_CU16LE: /* 252 x IQ samples */
+		{
+			s16 *s16src = (s16 *) src;
+			u16 *u16dst = (u16 *) dst;
+			struct {signed int x:14; } se; /* sign extension */
+			unsigned int utmp;
+
+			for (j = 0; j < 1008; j += 2) {
+				/* sign extension from 14-bit to signed int */
+				se.x = *s16src++;
+				/* from signed int to unsigned int */
+				utmp = se.x + 8192;
+				/* from 14-bit to 16-bit */
+				*u16dst++ = utmp << 2 | utmp >> 12;
+			}
 
-		src += 1008;
-		dst += 1008;
-		dst_len += 1008;
+			src += 1008;
+			dst += 1008;
+			dst_len += 1008;
+			s->next_sample = sample[i] + 252;
+			break;
+		}
+		case MSI2500_PIX_FMT_SDR_MSI2500_384: /* 384 x IQ samples */
+			/* Dump unknown 'garbage' data */
+			dev_dbg_ratelimited(&s->udev->dev,
+					"%*ph\n", 24, &src[1000]);
+			memcpy(dst, src, 984);
+			src += 984 + 24;
+			dst += 984;
+			dst_len += 984;
+			s->next_sample = sample[i] + 384;
+			break;
+		case V4L2_SDR_FMT_CS8:         /* 504 x IQ samples */
+			memcpy(dst, src, 1008);
+			src += 1008;
+			dst += 1008;
+			dst_len += 1008;
+			s->next_sample = sample[i] + 504;
+			break;
+		case MSI2500_PIX_FMT_SDR_S12:  /* 336 x IQ samples */
+			memcpy(dst, src, 1008);
+			src += 1008;
+			dst += 1008;
+			dst_len += 1008;
+			s->next_sample = sample[i] + 336;
+			break;
+		case V4L2_SDR_FMT_CS14LE:      /* 252 x IQ samples */
+			memcpy(dst, src, 1008);
+			src += 1008;
+			dst += 1008;
+			dst_len += 1008;
+			s->next_sample = sample[i] + 252;
+			break;
+		default:
+			break;
+		}
 	}
 
-	/* calculate samping rate and output it in 10 seconds intervals */
+	/* calculate sample rate and output it in 10 seconds intervals */
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
-#define MSECS 10000UL
-		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		#define MSECS 10000UL
+		unsigned int msecs = jiffies_to_msecs(jiffies -
+				s->jiffies_next + msecs_to_jiffies(MSECS));
+		unsigned int samples = s->next_sample - s->sample;
 
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
-		s->sample = sample_num[i_max - 1];
+		s->sample = s->next_sample;
 		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, MSECS,
-				samples * 1000UL / MSECS);
+				"size=%u samples=%u msecs=%u sample rate=%lu\n",
+				src_len, samples, msecs,
+				samples * 1000UL / msecs);
 	}
 
-	/* next sample (sample = sample + i * 252) */
-	s->next_sample = sample_num[i_max - 1] + 252;
-
 	return dst_len;
 }
 
@@ -662,7 +438,7 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 		/* fill framebuffer */
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		flen = s->convert_stream(s, ptr, iso_buf, flen);
+		flen = msi3101_convert_stream(s, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 	}
@@ -945,32 +721,25 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	/* select stream format */
 	switch (s->pixelformat) {
 	case V4L2_SDR_FMT_CU8:
-		s->convert_stream = msi3101_convert_stream_504_u8;
-		reg7 = 0x000c9407;
+		reg7 = 0x000c9407; /* 504 */
 		break;
 	case  V4L2_SDR_FMT_CU16LE:
-		s->convert_stream = msi3101_convert_stream_252_u16;
-		reg7 = 0x00009407;
+		reg7 = 0x00009407; /* 252 */
 		break;
 	case V4L2_SDR_FMT_CS8:
-		s->convert_stream = msi3101_convert_stream_504;
-		reg7 = 0x000c9407;
+		reg7 = 0x000c9407; /* 504 */
 		break;
 	case MSI2500_PIX_FMT_SDR_MSI2500_384:
-		s->convert_stream = msi3101_convert_stream_384;
-		reg7 = 0x0000a507;
+		reg7 = 0x0000a507; /* 384 */
 		break;
 	case MSI2500_PIX_FMT_SDR_S12:
-		s->convert_stream = msi3101_convert_stream_336;
-		reg7 = 0x00008507;
+		reg7 = 0x00008507; /* 336 */
 		break;
 	case V4L2_SDR_FMT_CS14LE:
-		s->convert_stream = msi3101_convert_stream_252;
-		reg7 = 0x00009407;
+		reg7 = 0x00009407; /* 252 */
 		break;
 	default:
-		s->convert_stream = msi3101_convert_stream_504_u8;
-		reg7 = 0x000c9407;
+		reg7 = 0x000c9407; /* 504 */
 		break;
 	}
 
-- 
http://palosaari.fi/

