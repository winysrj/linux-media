Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward3h.cmail.yandex.net ([87.250.230.18]:37890 "EHLO
        forward3h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934695AbcJUTo2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 15:44:28 -0400
Received: from smtp3m.mail.yandex.net (smtp3m.mail.yandex.net [IPv6:2a02:6b8:0:2519::125])
        by forward3h.cmail.yandex.net (Yandex) with ESMTP id C43F32101F
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 22:36:53 +0300 (MSK)
Received: from smtp3m.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp3m.mail.yandex.net (Yandex) with ESMTP id 9DBC2284048E
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 22:36:53 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-usb-cxusb: Geniatech T230 - resync TS FIFO after lock
Date: Fri, 21 Oct 2016 22:35:40 +0300
Message-ID: <1819823.msPEjJElp3@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix streaming issue for Geniatech T230/PT360.

Signed-off-by: CrazyCat <crazycat69@narod.ru>
---
 drivers/media/usb/dvb-usb/cxusb.c | 26 ++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb/cxusb.h |  5 +++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 3701f59..46b59c3 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -368,6 +368,26 @@ static int cxusb_aver_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return 0;
 }
 
+static int cxusb_read_status(struct dvb_frontend *fe,
+				  enum fe_status *status)
+{
+	struct dvb_usb_adapter *adap = (struct dvb_usb_adapter *)fe->dvb->priv;
+	struct cxusb_state *state = (struct cxusb_state *)adap->dev->priv;
+	int ret;
+
+	ret = state->fe_read_status(fe, status);
+
+	/* it need resync slave fifo when signal change from unlock to lock.*/
+	if ((*status & FE_HAS_LOCK) && (!state->last_lock)) {
+		mutex_lock(&state->stream_mutex);
+		cxusb_streaming_ctrl(adap, 1);
+		mutex_unlock(&state->stream_mutex);
+	}
+
+	state->last_lock = (*status & FE_HAS_LOCK) ? 1 : 0;
+	return ret;
+}
+
 static void cxusb_d680_dmb_drain_message(struct dvb_usb_device *d)
 {
 	int       ep = d->props.generic_bulk_ctrl_endpoint;
@@ -1370,6 +1390,12 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	st->i2c_client_demod = client_demod;
 	st->i2c_client_tuner = client_tuner;
 
+	/* hook fe: need to resync the slave fifo when signal locks. */
+	mutex_init(&st->stream_mutex);
+	st->last_lock = 0;
+	st->fe_read_status = adap->fe_adap[0].fe->ops.read_status;
+	adap->fe_adap[0].fe->ops.read_status = cxusb_read_status;
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
index 527ff79..22b3253 100644
--- a/drivers/media/usb/dvb-usb/cxusb.h
+++ b/drivers/media/usb/dvb-usb/cxusb.h
@@ -32,6 +32,11 @@ struct cxusb_state {
 	u8 gpio_write_state[3];
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
+
+	struct mutex stream_mutex;
+	u8 last_lock;
+	int (*fe_read_status)(struct dvb_frontend *fe,
+		enum fe_status *status);
 };
 
 #endif
-- 
1.9.1


