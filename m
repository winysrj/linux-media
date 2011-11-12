Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36978 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1KLPzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:55:51 -0500
Received: by wwe5 with SMTP id 5so2611804wwe.1
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:55:50 -0800 (PST)
Message-ID: <4ebe9705.0d3ae30a.18dc.7d6f@mx.google.com>
Subject: [PATCH 4/7] af9013 frontend tuner bus lock and gate changes v2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 15:55:45 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes from version 1
Remove the bus lock from read status. Causing a lagging
effect on some kernels < [2.6.38]

This does mean that noisy I2C traffic could be heard on
the first frontend when its tuner gate is open.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9015.c   |    7 ++++++-
 drivers/media/dvb/frontends/af9013.c |    9 ++++++++-
 drivers/media/dvb/frontends/af9013.h |    5 +++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index c9da2aa..9077ac4 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -46,6 +46,7 @@ module_param_named(no_pid, no_pid_filter, int, 0644);
 MODULE_PARM_DESC(no_pid, "set default 0=on 1=off");
 
 static DEFINE_MUTEX(af9015_usb_mutex);
+static DEFINE_MUTEX(af9015_fe_mutex);
 
 static struct af9015_config af9015_config;
 static struct dvb_usb_device_properties af9015_properties[3];
@@ -1147,7 +1148,7 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 
 	/* attach demodulator */
 	adap->fe_adap[0].fe = dvb_attach(af9013_attach, &af9015_af9013_config[adap->id],
-		&adap->dev->i2c_adap);
+		&adap->dev->i2c_adap, &af9015_fe_mutex);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
@@ -1220,6 +1221,9 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	deb_info("%s:\n", __func__);
 
+	if (mutex_lock_interruptible(&af9015_fe_mutex) < 0)
+		return -EAGAIN;
+
 	switch (af9015_af9013_config[adap->id].tuner) {
 	case AF9013_TUNER_MT2060:
 	case AF9013_TUNER_MT2060_2:
@@ -1275,6 +1279,7 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 		err("Unknown tuner id:%d",
 			af9015_af9013_config[adap->id].tuner);
 	}
+	mutex_unlock(&af9015_fe_mutex);
 	return ret;
 }
 
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 345311c..38a6ea2 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -50,6 +50,7 @@ struct af9013_state {
 	u16 snr;
 	u32 frequency;
 	unsigned long next_statistics_check;
+	struct mutex *fe_mutex;
 };
 
 static u8 regmask[8] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff };
@@ -630,9 +631,14 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
 	state->frequency = params->frequency;
 
 	/* program tuner */
+	if (mutex_lock_interruptible(state->fe_mutex) < 0)
+		return -EAGAIN;
+
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe, params);
 
+	mutex_unlock(state->fe_mutex);
+
 	/* program CFOE coefficients */
 	ret = af9013_set_coeff(state, params->u.ofdm.bandwidth);
 	if (ret)
@@ -1446,7 +1452,7 @@ static void af9013_release(struct dvb_frontend *fe)
 static struct dvb_frontend_ops af9013_ops;
 
 struct dvb_frontend *af9013_attach(const struct af9013_config *config,
-	struct i2c_adapter *i2c)
+	struct i2c_adapter *i2c, struct mutex *fe_mutex)
 {
 	int ret;
 	struct af9013_state *state = NULL;
@@ -1459,6 +1465,7 @@ struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 
 	/* setup the state */
 	state->i2c = i2c;
+	state->fe_mutex = fe_mutex;
 	memcpy(&state->config, config, sizeof(struct af9013_config));
 
 	/* download firmware */
diff --git a/drivers/media/dvb/frontends/af9013.h b/drivers/media/dvb/frontends/af9013.h
index e53d873..95c966a 100644
--- a/drivers/media/dvb/frontends/af9013.h
+++ b/drivers/media/dvb/frontends/af9013.h
@@ -96,10 +96,11 @@ struct af9013_config {
 #if defined(CONFIG_DVB_AF9013) || \
 	(defined(CONFIG_DVB_AF9013_MODULE) && defined(MODULE))
 extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
-	struct i2c_adapter *i2c);
+	struct i2c_adapter *i2c, struct mutex *fe_mutex);
 #else
 static inline struct dvb_frontend *af9013_attach(
-const struct af9013_config *config, struct i2c_adapter *i2c)
+	const struct af9013_config *config, struct i2c_adapter *i2,
+		struct mutex *fe_mutex)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
1.7.5.4




