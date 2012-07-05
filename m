Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2GEOQg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 10:16:36 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q65EGa8x015738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jul 2012 10:16:36 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] [media] tuner, xc2028: add support for get_afc()
Date: Thu,  5 Jul 2012 11:16:32 -0300
Message-Id: <1341497792-6066-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement API support to return AFC frequency shift, as this device
supports it. The only other driver that implements it is tda9887,
and the frequency there is reported in Hz. So, use Hz also for this
tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   46 +++++++++++++++++++++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.h  |    1 +
 drivers/media/video/tuner-core.c           |   11 +++++++
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 42fdf5c..4857e86 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -924,7 +924,7 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 		msleep(6);
 	}
 
-	/* Frequency was not locked */
+	/* Frequency didn't lock */
 	if (frq_lock == 2)
 		goto ret;
 
@@ -947,6 +947,49 @@ ret:
 	return rc;
 }
 
+static int xc2028_get_afc(struct dvb_frontend *fe, s32 *afc)
+{
+	struct xc2028_data *priv = fe->tuner_priv;
+	int i, rc;
+	u16 frq_lock = 0;
+	s16 afc_reg = 0;
+
+	rc = check_device_status(priv);
+	if (rc < 0)
+		return rc;
+
+	mutex_lock(&priv->lock);
+
+	/* Sync Lock Indicator */
+	for (i = 0; i < 3; i++) {
+		rc = xc2028_get_reg(priv, XREG_LOCK, &frq_lock);
+		if (rc < 0)
+			goto ret;
+
+		if (frq_lock)
+			break;
+		msleep(6);
+	}
+
+	/* Frequency didn't lock */
+	if (frq_lock == 2)
+		goto ret;
+
+	/* Get AFC */
+	rc = xc2028_get_reg(priv, XREG_FREQ_ERROR, &afc_reg);
+	if (rc < 0)
+		return rc;
+
+	*afc = afc_reg * 15625; /* Hz */
+
+	tuner_dbg("AFC is %d Hz\n", *afc);
+
+ret:
+	mutex_unlock(&priv->lock);
+
+	return rc;
+}
+
 #define DIV 15625
 
 static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
@@ -1392,6 +1435,7 @@ static const struct dvb_tuner_ops xc2028_dvb_tuner_ops = {
 	.release           = xc2028_dvb_release,
 	.get_frequency     = xc2028_get_frequency,
 	.get_rf_strength   = xc2028_signal,
+	.get_afc           = xc2028_get_afc,
 	.set_params        = xc2028_set_params,
 	.sleep             = xc2028_sleep,
 };
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index e929d56..7c64c09 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -220,6 +220,7 @@ struct dvb_tuner_ops {
 #define TUNER_STATUS_STEREO 2
 	int (*get_status)(struct dvb_frontend *fe, u32 *status);
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
+	int (*get_afc)(struct dvb_frontend *fe, s32 *afc);
 
 	/** These are provided separately from set_params in order to facilitate silicon
 	 * tuners which require sophisticated tuning loops, controlling each parameter separately. */
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 98adeee..b5a819a 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -228,6 +228,16 @@ static int fe_has_signal(struct dvb_frontend *fe)
 	return strength;
 }
 
+static int fe_get_afc(struct dvb_frontend *fe)
+{
+	s32 afc = 0;
+
+	if (fe->ops.tuner_ops.get_afc)
+		fe->ops.tuner_ops.get_afc(fe, &afc);
+
+	return 0;
+}
+
 static int fe_set_config(struct dvb_frontend *fe, void *priv_cfg)
 {
 	struct dvb_tuner_ops *fe_tuner_ops = &fe->ops.tuner_ops;
@@ -247,6 +257,7 @@ static struct analog_demod_ops tuner_analog_ops = {
 	.set_params     = fe_set_params,
 	.standby        = fe_standby,
 	.has_signal     = fe_has_signal,
+	.get_afc        = fe_get_afc,
 	.set_config     = fe_set_config,
 	.tuner_status   = tuner_status
 };
-- 
1.7.10.4

