Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38894 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaBIIt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 35/86] msi3101: clamp ADC and RF to valid range
Date: Sun,  9 Feb 2014 10:48:40 +0200
Message-Id: <1391935771-18670-36-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clamp both sampling frequency and RF frequency to valid range to
meet V4L2 API spec. It is caller responsibility to check valid ranges
using VIDIOC_ENUM_FREQ_BANDS IOCTL.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index ba37fce..2b812fe 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1779,17 +1779,26 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	int ret;
+	int ret, band;
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
 			__func__, f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
-		s->f_adc = f->frequency;
+		s->f_adc = clamp_t(unsigned int, f->frequency,
+				bands_adc[0].rangelow,
+				bands_adc[0].rangehigh);
 		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
 				__func__, s->f_adc);
 		ret = msi3101_set_usb_adc(s);
 	} else if (f->tuner == 1) {
-		s->f_tuner = f->frequency;
+		#define BAND_RF_0 ((bands_rf[0].rangehigh + bands_rf[1].rangelow) / 2)
+		if (f->frequency < BAND_RF_0)
+			band = 0;
+		else
+			band = 1;
+		s->f_tuner = clamp_t(unsigned int, f->frequency,
+				bands_rf[band].rangelow,
+				bands_rf[band].rangehigh);
 		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
 				__func__, f->frequency);
 		ret = msi3101_set_tuner(s);
-- 
1.8.5.3

