Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaGURV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 13:21:26 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] xc5000: Fix get_frequency()
Date: Mon, 21 Jul 2014 14:21:18 -0300
Message-Id: <1405963278-20613-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The programmed frequency on xc5000 is not the middle
frequency, but the initial frequency on the bandwidth range.
However, the DVB API works with the middle frequency.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 2b3d514be672..3091cf7be7a1 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -56,7 +56,7 @@ struct xc5000_priv {
 
 	u32 if_khz;
 	u16 xtal_khz;
-	u32 freq_hz;
+	u32 freq_hz, freq_offset;
 	u32 bandwidth;
 	u8  video_standard;
 	u8  rf_mode;
@@ -749,13 +749,13 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	case SYS_ATSC:
 		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
-		priv->freq_hz = freq - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = DTV6;
 		break;
 	case SYS_DVBC_ANNEX_B:
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
-		priv->freq_hz = freq - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = DTV6;
 		break;
 	case SYS_ISDBT:
@@ -770,15 +770,15 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		switch (bw) {
 		case 6000000:
 			priv->video_standard = DTV6;
-			priv->freq_hz = freq - 1750000;
+			priv->freq_offset = 1750000;
 			break;
 		case 7000000:
 			priv->video_standard = DTV7;
-			priv->freq_hz = freq - 2250000;
+			priv->freq_offset = 2250000;
 			break;
 		case 8000000:
 			priv->video_standard = DTV8;
-			priv->freq_hz = freq - 2750000;
+			priv->freq_offset = 2750000;
 			break;
 		default:
 			printk(KERN_ERR "xc5000 bandwidth not set!\n");
@@ -792,15 +792,15 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		if (bw <= 6000000) {
 			priv->video_standard = DTV6;
-			priv->freq_hz = freq - 1750000;
+			priv->freq_offset = 1750000;
 			b = 6;
 		} else if (bw <= 7000000) {
 			priv->video_standard = DTV7;
-			priv->freq_hz = freq - 2250000;
+			priv->freq_offset = 2250000;
 			b = 7;
 		} else {
 			priv->video_standard = DTV7_8;
-			priv->freq_hz = freq - 2750000;
+			priv->freq_offset = 2750000;
 			b = 8;
 		}
 		dprintk(1, "%s() Bandwidth %dMHz (%d)\n", __func__,
@@ -811,6 +811,8 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
+	priv->freq_hz = freq - priv->freq_offset;
+
 	dprintk(1, "%s() frequency=%d (compensated to %d)\n",
 		__func__, freq, priv->freq_hz);
 
@@ -1061,7 +1063,7 @@ static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	dprintk(1, "%s()\n", __func__);
-	*freq = priv->freq_hz;
+	*freq = priv->freq_hz + priv->freq_offset;
 	return 0;
 }
 
-- 
1.9.3

