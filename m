Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53795 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJ0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:26:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 85/86] rtl2832_sdr: do not init tuner when only freq is changed
Date: Sun,  9 Feb 2014 10:49:30 +0200
Message-Id: <1391935771-18670-86-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initializing whole tuner every time when frequency is changed is wrong
and unnecessary. Init tuner only when streaming is started. Change
other parameters runtime.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 25 +++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 0d96aea..cc554f7 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -912,7 +912,7 @@ err:
 	return;
 };
 
-static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
+static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -946,15 +946,24 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
 
-	if (fe->ops.tuner_ops.init)
-		fe->ops.tuner_ops.init(fe);
-
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
 	return 0;
 };
 
+static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
+{
+	struct dvb_frontend *fe = s->fe;
+
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (fe->ops.tuner_ops.init)
+		fe->ops.tuner_ops.init(fe);
+
+	return 0;
+};
+
 static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
@@ -988,6 +997,10 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret)
 		goto err;
 
+	ret = rtl2832_sdr_set_tuner_freq(s);
+	if (ret)
+		goto err;
+
 	ret = rtl2832_sdr_set_adc(s);
 	if (ret)
 		goto err;
@@ -1127,6 +1140,7 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	int ret, band;
+
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
 			__func__, f->tuner, f->type, f->frequency);
 
@@ -1153,7 +1167,8 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 		s->f_tuner = f->frequency;
 		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
 				__func__, f->frequency);
-		ret = rtl2832_sdr_set_tuner(s);
+
+		ret = rtl2832_sdr_set_tuner_freq(s);
 	} else {
 		ret = -EINVAL;
 	}
-- 
1.8.5.3

