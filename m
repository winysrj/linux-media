Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44737 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbaIDVnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 17:43:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] af9035: remove I2C client differently
Date: Fri,  5 Sep 2014 00:43:43 +0300
Message-Id: <1409867023-8362-3-git-send-email-crope@iki.fi>
In-Reply-To: <1409867023-8362-1-git-send-email-crope@iki.fi>
References: <1409867023-8362-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It crash kernel when device was removed while it was streaming.
That is because we removed driver and frontend thread was still
running. Use new callback which allows I2C driver removal just
after frontend is unregistered.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 90 +++++++++++++++++++++++++----------
 1 file changed, 64 insertions(+), 26 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 94563b2..aadabea 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1074,15 +1074,13 @@ static int af9035_get_adapter_count(struct dvb_usb_device *d)
 	return state->dual_mode + 1;
 }
 
-static void af9035_exit(struct dvb_usb_device *d);
-
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
 
 	if (!state->af9033_config[adap->id].tuner) {
 		/* unsupported tuner */
@@ -1109,12 +1107,46 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	af9035_exit(d); /* remove I2C clients */
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
+static int af9035_frontend_detach(struct dvb_usb_adapter *adap)
+{
+	struct state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int demod2;
+
+	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+
+	/*
+	 * For dual tuner devices we have to resolve 2nd demod client, as there
+	 * is two different kind of tuner drivers; one is using I2C binding
+	 * and the other is using DVB attach/detach binding.
+	 */
+	switch (state->af9033_config[adap->id].tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		demod2 = 2;
+	default:
+		demod2 = 1;
+	}
+
+	if (adap->id == 1)
+		if (state->i2c_client[demod2])
+			af9035_del_i2c_dev(d);
+	if (adap->id == 0)
+		if (state->i2c_client[0])
+			af9035_del_i2c_dev(d);
+
+	return 0;
+}
+
 static struct tua9001_config af9035_tua9001_config = {
 	.i2c_addr = 0x60,
 };
@@ -1174,7 +1206,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_msg msg[1];
 	u8 tuner_addr;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
 
 	/*
 	 * XXX: Hack used in that function: we abuse unused I2C address bit [7]
@@ -1392,12 +1424,36 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	af9035_exit(d); /* remove I2C clients */
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
+static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
+{
+	struct state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+
+	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+
+	switch (state->af9033_config[adap->id].tuner) {
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+		if (adap->id == 1)
+			if (state->i2c_client[3])
+				af9035_del_i2c_dev(d);
+		if (adap->id == 0)
+			if (state->i2c_client[1])
+				af9035_del_i2c_dev(d);
+	}
+
+	return 0;
+}
+
 static int af9035_init(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
@@ -1445,25 +1501,6 @@ err:
 	return ret;
 }
 
-static void af9035_exit(struct dvb_usb_device *d)
-{
-	struct state *state = d_to_priv(d);
-
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
-
-	if (state->i2c_client[3])
-		af9035_del_i2c_dev(d);
-
-	if (state->i2c_client[2])
-		af9035_del_i2c_dev(d);
-
-	if (state->i2c_client[1])
-		af9035_del_i2c_dev(d);
-
-	if (state->i2c_client[0])
-		af9035_del_i2c_dev(d);
-}
-
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int af9035_rc_query(struct dvb_usb_device *d)
 {
@@ -1636,11 +1673,12 @@ static const struct dvb_usb_device_properties af9035_props = {
 	.i2c_algo = &af9035_i2c_algo,
 	.read_config = af9035_read_config,
 	.frontend_attach = af9035_frontend_attach,
+	.frontend_detach = af9035_frontend_detach,
 	.tuner_attach = af9035_tuner_attach,
+	.tuner_detach = af9035_tuner_detach,
 	.init = af9035_init,
 	.get_rc_config = af9035_get_rc_config,
 	.get_stream_config = af9035_get_stream_config,
-	.exit = af9035_exit,
 
 	.get_adapter_count = af9035_get_adapter_count,
 	.adapter = {
-- 
http://palosaari.fi/

