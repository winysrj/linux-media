Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33441 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030697Ab2CNO2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 10:28:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Gordon Hecker <ghecker@gmx.de>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2 FOR 3.4] af9015: fix i2c failures for dual-tuner devices
Date: Wed, 14 Mar 2012 16:27:30 +0200
Message-Id: <1331735251-15393-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gordon Hecker <ghecker@gmx.de>

The i2c failures were caused by enabling both i2c gates
at the same time while putting the tuners asleep.

This patch removes the init() and sleep() callbacks from the tuner,
to prevent frontend.c from calling
  i2c_gate_ctrl
  tuner init / sleep
  i2c_gate_ctrl
without holding the lock.
tuner init() and sleep() are instead called in frontend init() and
sleep().

Signed-off-by: Gordon Hecker <ghecker@gmx.de>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/af9015.c |   31 +++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/af9015.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 282a43d..9307b4ca 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1141,7 +1141,18 @@ static int af9015_af9013_init(struct dvb_frontend *fe)
 		return -EAGAIN;
 
 	ret = priv->init[adap->id](fe);
+	if (ret)
+		goto err_unlock;
+
+	if (priv->tuner_ops_init[adap->id]) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		ret = priv->tuner_ops_init[adap->id](fe);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
 
+err_unlock:
 	mutex_unlock(&adap->dev->usb_mutex);
 
 	return ret;
@@ -1157,8 +1168,19 @@ static int af9015_af9013_sleep(struct dvb_frontend *fe)
 	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
 		return -EAGAIN;
 
+	if (priv->tuner_ops_sleep[adap->id]) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		ret = priv->tuner_ops_sleep[adap->id](fe);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+		if (ret)
+			goto err_unlock;
+	}
+
 	ret = priv->sleep[adap->id](fe);
 
+err_unlock:
 	mutex_unlock(&adap->dev->usb_mutex);
 
 	return ret;
@@ -1283,6 +1305,7 @@ static struct mxl5007t_config af9015_mxl5007t_config = {
 static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
+	struct af9015_state *state = adap->dev->priv;
 	deb_info("%s:\n", __func__);
 
 	switch (af9015_af9013_config[adap->id].tuner) {
@@ -1340,6 +1363,14 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 		err("Unknown tuner id:%d",
 			af9015_af9013_config[adap->id].tuner);
 	}
+
+	state->tuner_ops_sleep[adap->id] =
+				adap->fe_adap[0].fe->ops.tuner_ops.sleep;
+	adap->fe_adap[0].fe->ops.tuner_ops.sleep = 0;
+
+	state->tuner_ops_init[adap->id] =
+				adap->fe_adap[0].fe->ops.tuner_ops.init;
+	adap->fe_adap[0].fe->ops.tuner_ops.init = 0;
 	return ret;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
index f619063..ee2ec5b 100644
--- a/drivers/media/dvb/dvb-usb/af9015.h
+++ b/drivers/media/dvb/dvb-usb/af9015.h
@@ -108,6 +108,8 @@ struct af9015_state {
 	int (*read_status[2]) (struct dvb_frontend *fe, fe_status_t *status);
 	int (*init[2]) (struct dvb_frontend *fe);
 	int (*sleep[2]) (struct dvb_frontend *fe);
+	int (*tuner_ops_init[2]) (struct dvb_frontend *fe);
+	int (*tuner_ops_sleep[2]) (struct dvb_frontend *fe);
 };
 
 struct af9015_config {
-- 
1.7.7.6

