Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaGUQ2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 12:28:23 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] xc4000: Fix get_frequency()
Date: Mon, 21 Jul 2014 13:28:15 -0300
Message-Id: <1405960095-29408-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
References: <1405960095-29408-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The programmed frequency on xc4000 is not the middle
frequency, but the initial frequency on the bandwidth range.
However, the DVB API works with the middle frequency.

This works fine on set_frontend, as the device calculates
the needed offset. However, at get_frequency(), the returned
value is the initial frequency. That's generally not a big
problem on most drivers, however, starting with changeset
6fe1099c7aec, the frequency drift is taken into account at
dib7000p driver.

This broke support for PCTV 340e, with uses dib7000p demod and
xc4000 tuner.

Cc: stable@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc4000.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 7d008b4d3595..a19ef1046f89 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -93,7 +93,7 @@ struct xc4000_priv {
 	struct firmware_description *firm;
 	int	firm_size;
 	u32	if_khz;
-	u32	freq_hz;
+	u32	freq_hz, freq_offset;
 	u32	bandwidth;
 	u8	video_standard;
 	u8	rf_mode;
@@ -1172,14 +1172,14 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 	case SYS_ATSC:
 		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
-		priv->freq_hz = c->frequency - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = XC4000_DTV6;
 		type = DTV6;
 		break;
 	case SYS_DVBC_ANNEX_B:
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
-		priv->freq_hz = c->frequency - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = XC4000_DTV6;
 		type = DTV6;
 		break;
@@ -1188,23 +1188,23 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() OFDM\n", __func__);
 		if (bw == 0) {
 			if (c->frequency < 400000000) {
-				priv->freq_hz = c->frequency - 2250000;
+				priv->freq_offset= 2250000;
 			} else {
-				priv->freq_hz = c->frequency - 2750000;
+				priv->freq_offset = 2750000;
 			}
 			priv->video_standard = XC4000_DTV7_8;
 			type = DTV78;
 		} else if (bw <= 6000000) {
 			priv->video_standard = XC4000_DTV6;
-			priv->freq_hz = c->frequency - 1750000;
+			priv->freq_offset = 1750000;
 			type = DTV6;
 		} else if (bw <= 7000000) {
 			priv->video_standard = XC4000_DTV7;
-			priv->freq_hz = c->frequency - 2250000;
+			priv->freq_offset = 2250000;
 			type = DTV7;
 		} else {
 			priv->video_standard = XC4000_DTV8;
-			priv->freq_hz = c->frequency - 2750000;
+			priv->freq_offset = 2750000;
 			type = DTV8;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
@@ -1215,6 +1215,8 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		goto fail;
 	}
 
+	priv->freq_hz = c->frequency - priv->freq_offset;
+
 	dprintk(1, "%s() frequency=%d (compensated)\n",
 		__func__, priv->freq_hz);
 
@@ -1535,7 +1537,7 @@ static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 
-	*freq = priv->freq_hz;
+	*freq = priv->freq_hz + priv->freq_offset;
 
 	if (debug) {
 		mutex_lock(&priv->lock);
-- 
1.9.3

