Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37737 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaAYRLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:08 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 43/52] rtl2832_sdr: clamp ADC frequency to valid range always
Date: Sat, 25 Jan 2014 19:10:37 +0200
Message-Id: <1390669846-8131-44-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 tuner API says incorrect value should be round to nearest
legal value. Implement it for ADC frequency setting.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 2c9b703..ddacfd2 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -666,7 +666,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	u64 u64tmp;
 	u32 u32tmp;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "%s: f_adc=%u\n", __func__, s->f_adc);
 
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
@@ -1064,12 +1064,26 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
-	int ret;
+	int ret, band;
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
 			__func__, f->tuner, f->type, f->frequency);
 
-	if (f->tuner == 0) {
-		s->f_adc = f->frequency;
+	/* ADC band midpoints */
+	#define BAND_ADC_0 ((bands_adc[0].rangehigh + bands_adc[1].rangelow) / 2)
+	#define BAND_ADC_1 ((bands_adc[1].rangehigh + bands_adc[2].rangelow) / 2)
+
+	if (f->tuner == 0 && f->type == V4L2_TUNER_ADC) {
+		if (f->frequency < BAND_ADC_0)
+			band = 0;
+		else if (f->frequency < BAND_ADC_1)
+			band = 1;
+		else
+			band = 2;
+
+		s->f_adc = clamp_t(unsigned int, f->frequency,
+				bands_adc[band].rangelow,
+				bands_adc[band].rangehigh);
+
 		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
 				__func__, s->f_adc);
 		ret = rtl2832_sdr_set_adc(s);
@@ -1287,6 +1301,8 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->udev = d->udev;
 	s->i2c = i2c;
 	s->cfg = cfg;
+	s->f_adc = bands_adc[0].rangelow;
+	s->pixelformat = V4L2_PIX_FMT_SDR_U8;
 
 	mutex_init(&s->v4l2_lock);
 	mutex_init(&s->vb_queue_lock);
-- 
1.8.5.3

