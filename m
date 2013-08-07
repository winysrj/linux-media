Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42025 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/16] msi3101: sample is correct term for sample
Date: Wed,  7 Aug 2013 21:51:33 +0300
Message-Id: <1375901507-26661-3-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 32 ++++++++++++++---------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 46fdb6c..87896ee 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -405,8 +405,8 @@ struct msi3101_state {
 	struct v4l2_ctrl *ctrl_tuner_if;
 	struct v4l2_ctrl *ctrl_tuner_gain;
 
-	u32 symbol_received; /* for track lost packets */
-	u32 symbol; /* for symbol rate calc */
+	u32 next_sample; /* for track lost packets */
+	u32 sample; /* for sample rate calc */
 	unsigned long jiffies;
 };
 
@@ -476,18 +476,18 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 	int i, j, k, l, i_max, dst_len = 0;
 	u16 sample[4];
 #ifdef MSI3101_EXTENSIVE_DEBUG
-	u32 symbol[3];
+	u32 sample_num[3];
 #endif
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
 	for (i = 0; i < i_max; i++) {
 #ifdef MSI3101_EXTENSIVE_DEBUG
-		symbol[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
-		if (i == 0 && s->symbol_received != symbol[0]) {
+		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
+		if (i == 0 && s->next_sample != sample_num[0]) {
 			dev_dbg(&s->udev->dev,
-					"%d symbols lost, %d %08x:%08x\n",
-					symbol[0] - s->symbol_received,
-					src_len, s->symbol_received, symbol[0]);
+					"%d samples lost, %d %08x:%08x\n",
+					sample_num[0] - s->next_sample,
+					src_len, s->next_sample, sample_num[0]);
 		}
 #endif
 		src += 16;
@@ -520,21 +520,21 @@ static int msi3101_convert_stream(struct msi3101_state *s, u32 *dst,
 	}
 
 #ifdef MSI3101_EXTENSIVE_DEBUG
-	/* calculate symbol rate and output it in 10 seconds intervals */
+	/* calculate samping rate and output it in 10 seconds intervals */
 	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
-		unsigned int symbols = symbol[i_max - 1] - s->symbol;
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
 		s->jiffies = jiffies_now;
-		s->symbol = symbol[i_max - 1];
+		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
-				"slen=%d symbols=%u msecs=%lu symbolrate=%lu\n",
-				src_len, symbols, msecs,
-				symbols * 1000UL / msecs);
+				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
+				src_len, samples, msecs,
+				samples * 1000UL / msecs);
 	}
 
-	/* last received symbol (symbol = symbol + i * 384) */
-	s->symbol_received = symbol[i_max - 1] + 384;
+	/* next sample (sample = sample + i * 384) */
+	s->next_sample = sample_num[i_max - 1] + 384;
 #endif
 	return dst_len;
 }
-- 
1.7.11.7

