Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3547 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab2JBP5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 11:57:22 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/2] tda18271: delay IR & RF calibration until init() if delay_cal is set
Date: Tue,  2 Oct 2012 11:57:05 -0400
Message-Id: <1349193426-13313-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if the configuration option 'delay_cal' is set, delay both IR & RF
calibration until init() is called.

both module option 'cal' or configuration option 'rf_cal_on_startup'
will override this delay. it makes no sense to mix 'delay_cal' with
'rf_cal_on_startup' as these options conflict with each other.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/tda18271-fe.c |    5 +++++
 drivers/media/tuners/tda18271.h    |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index de21197..ca202da 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1278,6 +1278,11 @@ struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe, u8 addr,
 		if (tda_fail(ret))
 			goto fail;
 
+		/* if delay_cal is set, delay IR & RF calibration until init()
+		 * module option 'cal' overrides this delay */
+		if ((cfg->delay_cal) && (!tda18271_need_cal_on_startup(cfg)))
+			break;
+
 		mutex_lock(&priv->lock);
 		tda18271_init_regs(fe);
 
diff --git a/drivers/media/tuners/tda18271.h b/drivers/media/tuners/tda18271.h
index 640bae4..89b6c6d 100644
--- a/drivers/media/tuners/tda18271.h
+++ b/drivers/media/tuners/tda18271.h
@@ -105,6 +105,11 @@ struct tda18271_config {
 	/* force rf tracking filter calibration on startup */
 	unsigned int rf_cal_on_startup:1;
 
+	/* prevent any register access during attach(),
+	 * delaying both IR & RF calibration until init()
+	 * module option 'cal' overrides this delay */
+	unsigned int delay_cal:1;
+
 	/* interface to saa713x / tda829x */
 	unsigned int config;
 };
-- 
1.7.9.5

