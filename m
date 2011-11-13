Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48372 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1KMTFN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 14:05:13 -0500
Message-ID: <4EC014E5.5090303@iki.fi>
Date: Sun, 13 Nov 2011 21:05:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH FOR 3.2 FIX] af9015: limit I2C access to keep FW happy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AF9015 firmware does not like if it gets interrupted by I2C adapter
request on some critical phases. During normal operation I2C adapter
is used only 2nd demodulator and tuner on dual tuner devices.

Override demodulator callbacks and use mutex for limit access to
those "critical" paths to keep AF9015 happy.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/af9015.c |   97 ++++++++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/af9015.h |    7 +++
 2 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index c6c275b..033aa8a 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1093,9 +1093,80 @@ error:
 	return ret;
 }
 
+/* override demod callbacks for resource locking */
+static int af9015_af9013_set_frontend(struct dvb_frontend *fe,
+	struct dvb_frontend_parameters *params)
+{
+	int ret;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct af9015_state *priv = adap->dev->priv;
+
+	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
+		return -EAGAIN;
+
+	ret = priv->set_frontend[adap->id](fe, params);
+
+	mutex_unlock(&adap->dev->usb_mutex);
+
+	return ret;
+}
+
+/* override demod callbacks for resource locking */
+static int af9015_af9013_read_status(struct dvb_frontend *fe,
+	fe_status_t *status)
+{
+	int ret;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct af9015_state *priv = adap->dev->priv;
+
+	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
+		return -EAGAIN;
+
+	ret = priv->read_status[adap->id](fe, status);
+
+	mutex_unlock(&adap->dev->usb_mutex);
+
+	return ret;
+}
+
+/* override demod callbacks for resource locking */
+static int af9015_af9013_init(struct dvb_frontend *fe)
+{
+	int ret;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct af9015_state *priv = adap->dev->priv;
+
+	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
+		return -EAGAIN;
+
+	ret = priv->init[adap->id](fe);
+
+	mutex_unlock(&adap->dev->usb_mutex);
+
+	return ret;
+}
+
+/* override demod callbacks for resource locking */
+static int af9015_af9013_sleep(struct dvb_frontend *fe)
+{
+	int ret;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct af9015_state *priv = adap->dev->priv;
+
+	if (mutex_lock_interruptible(&adap->dev->usb_mutex))
+		return -EAGAIN;
+
+	ret = priv->init[adap->id](fe);
+
+	mutex_unlock(&adap->dev->usb_mutex);
+
+	return ret;
+}
+
 static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
+	struct af9015_state *state = adap->dev->priv;
 
 	if (adap->id == 1) {
 		/* copy firmware to 2nd demodulator */
@@ -1116,6 +1187,32 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 	adap->fe_adap[0].fe = dvb_attach(af9013_attach, &af9015_af9013_config[adap->id],
 		&adap->dev->i2c_adap);
 
+	/*
+	 * AF9015 firmware does not like if it gets interrupted by I2C adapter
+	 * request on some critical phases. During normal operation I2C adapter
+	 * is used only 2nd demodulator and tuner on dual tuner devices.
+	 * Override demodulator callbacks and use mutex for limit access to
+	 * those "critical" paths to keep AF9015 happy.
+	 * Note: we abuse unused usb_mutex here.
+	 */
+	if (adap->fe_adap[0].fe) {
+		state->set_frontend[adap->id] =
+			adap->fe_adap[0].fe->ops.set_frontend;
+		adap->fe_adap[0].fe->ops.set_frontend =
+			af9015_af9013_set_frontend;
+
+		state->read_status[adap->id] =
+			adap->fe_adap[0].fe->ops.read_status;
+		adap->fe_adap[0].fe->ops.read_status =
+			af9015_af9013_read_status;
+
+		state->init[adap->id] = adap->fe_adap[0].fe->ops.init;
+		adap->fe_adap[0].fe->ops.init = af9015_af9013_init;
+
+		state->sleep[adap->id] = adap->fe_adap[0].fe->ops.sleep;
+		adap->fe_adap[0].fe->ops.sleep = af9015_af9013_sleep;
+	}
+
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/dvb/dvb-usb/af9015.h
index 6252ea6..4a12617 100644
--- a/drivers/media/dvb/dvb-usb/af9015.h
+++ b/drivers/media/dvb/dvb-usb/af9015.h
@@ -102,6 +102,13 @@ struct af9015_state {
 	u8 rc_repeat;
 	u32 rc_keycode;
 	u8 rc_last[4];
+
+	/* for demod callback override */
+	int (*set_frontend[2]) (struct dvb_frontend *fe,
+		struct dvb_frontend_parameters *params);
+	int (*read_status[2]) (struct dvb_frontend *fe, fe_status_t *status);
+	int (*init[2]) (struct dvb_frontend *fe);
+	int (*sleep[2]) (struct dvb_frontend *fe);
 };
 
 struct af9015_config {
-- 
1.7.4.4
