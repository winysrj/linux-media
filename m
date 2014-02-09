Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34953 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaBIIt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:58 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 24/86] msi3101: add u16 LE sample format
Date: Sun,  9 Feb 2014 10:48:29 +0200
Message-Id: <1391935771-18670-25-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add unsigned 16-bit little endian sample format. That stream
format is scaled from hardware 14-bit signed value. That is best
known sampling resolution that MSi2500 ADC provides.

It is not guaranteed to be little endian, but host endian which is
usually little endian - room for improvement.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 79 +++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index c50402d..7a64f18 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -386,6 +386,7 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+#define V4L2_PIX_FMT_SDR_U16LE  v4l2_fourcc('D', 'U', '1', '6') /* unsigned 16-bit LE */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 #define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
 #define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
@@ -432,6 +433,9 @@ static struct msi3101_format formats[] = {
 		.name		= "I/Q 8-bit unsigned",
 		.pixelformat	= V4L2_PIX_FMT_SDR_U8,
 	}, {
+		.name		= "I/Q 16-bit unsigned little endian",
+		.pixelformat	= V4L2_PIX_FMT_SDR_U16LE,
+	}, {
 		.name		= "I/Q 8-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
 	}, {
@@ -857,6 +861,78 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 	return dst_len;
 }
 
+static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
+		u8 *src, unsigned int src_len)
+{
+	int i, j, i_max, dst_len = 0;
+	u32 sample_num[3];
+	u16 *u16dst = (u16 *) dst;
+	struct {signed int x:14;} se;
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
+		/* 252 x I+Q samples */
+		src += 16;
+
+		for (j = 0; j < 1008; j += 4) {
+			unsigned int usample[2];
+			int ssample[2];
+
+			usample[0] = src[j + 0] >> 0 | src[j + 1] << 8;
+			usample[1] = src[j + 2] >> 0 | src[j + 3] << 8;
+
+			/* sign extension from 14-bit to signed int */
+			ssample[0] = se.x = usample[0];
+			ssample[1] = se.x = usample[1];
+
+			/* from signed to unsigned */
+			usample[0] = ssample[0] + 8192;
+			usample[1] = ssample[1] + 8192;
+
+			/* from 14-bit to 16-bit */
+			*u16dst++ = (usample[0] << 2) | (usample[0] >> 12);
+			*u16dst++ = (usample[1] << 2) | (usample[1] >> 12);
+		}
+
+		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
+	}
+
+	/* calculate samping rate and output it in 10 seconds intervals */
+	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
+#define MSECS 10000UL
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
+		s->sample = sample_num[i_max - 1];
+		dev_dbg(&s->udev->dev,
+				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
+				src_len, samples, MSECS,
+				samples * 1000UL / MSECS);
+	}
+
+	/* next sample (sample = sample + i * 252) */
+	s->next_sample = sample_num[i_max - 1] + 252;
+
+	return dst_len;
+}
+
 /*
  * This gets called for the Isochronous pipe (stream). This is done in interrupt
  * time, so it has to be fast, not crash, and not stall. Neat.
@@ -1224,6 +1300,9 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	if (s->pixelformat == V4L2_PIX_FMT_SDR_U8) {
 		s->convert_stream = msi3101_convert_stream_504_u8;
 		reg7 = 0x000c9407;
+	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_U16LE) {
+		s->convert_stream = msi3101_convert_stream_252_u16;
+		reg7 = 0x00009407;
 	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S8) {
 		s->convert_stream = msi3101_convert_stream_504;
 		reg7 = 0x000c9407;
-- 
1.8.5.3

