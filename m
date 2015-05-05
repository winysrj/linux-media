Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:32909 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965444AbbEEQeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:34:19 -0400
Received: by lbbzk7 with SMTP id zk7so133166089lbb.0
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 09:34:17 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 4/4] dw2102: resync fifo when demod locks
Date: Tue,  5 May 2015 19:33:55 +0300
Message-Id: <1430843635-24002-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430843635-24002-1-git-send-email-olli.salonen@iki.fi>
References: <1430843635-24002-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the streaming_ctrl is called to enable TS before demod has locked
the TS will be empty. Copied the solution from the dvbsky driver for the
TechnoTrend S2-4600 device: when the state changes from unlock to
lock, call su3000_streaming_ctrl again.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 7552521..f9ad57f 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -117,8 +117,13 @@
 
 struct dw2102_state {
 	u8 initialized;
+	u8 last_lock;
 	struct i2c_client *i2c_client_tuner;
+
+	/* fe hook functions*/
 	int (*old_set_voltage)(struct dvb_frontend *f, fe_sec_voltage_t v);
+	int (*fe_read_status)(struct dvb_frontend *fe,
+		fe_status_t *status);
 };
 
 /* debug */
@@ -1001,6 +1006,23 @@ static void dw210x_led_ctrl(struct dvb_frontend *fe, int offon)
 	i2c_transfer(&udev_adap->dev->i2c_adap, &msg, 1);
 }
 
+static int tt_s2_4600_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct dvb_usb_adapter *d =
+		(struct dvb_usb_adapter *)(fe->dvb->priv);
+	struct dw2102_state *st = (struct dw2102_state *)d->dev->priv;
+	int ret;
+
+	ret = st->fe_read_status(fe, status);
+
+	/* resync slave fifo when signal change from unlock to lock */
+	if ((*status & FE_HAS_LOCK) && (!st->last_lock))
+		su3000_streaming_ctrl(d, 1);
+
+	st->last_lock = (*status & FE_HAS_LOCK) ? 1 : 0;
+	return ret;
+}
+
 static struct stv0299_config sharp_z0194a_config = {
 	.demod_address = 0x68,
 	.inittab = sharp_z0194a_inittab,
@@ -1553,6 +1575,12 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 
 	state->i2c_client_tuner = client;
 
+	/* hook fe: need to resync the slave fifo when signal locks */
+	state->fe_read_status = adap->fe_adap[0].fe->ops.read_status;
+	adap->fe_adap[0].fe->ops.read_status = tt_s2_4600_read_status;
+
+	state->last_lock = 0;
+
 	return 0;
 }
 
-- 
1.9.1

