Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:61512 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbbABOCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 09:02:55 -0500
Received: by mail-we0-f176.google.com with SMTP id w61so4509856wes.7
        for <linux-media@vger.kernel.org>; Fri, 02 Jan 2015 06:02:54 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/5] lmedm04: Create frontend call back for read status.
Date: Fri,  2 Jan 2015 13:56:30 +0000
Message-Id: <1420206991-3939-4-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
References: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create dm04_read_status to check lock through either interrupt values
or directly by the call back.

When the device is not streaming the frontends original call back is
used. When streaming has started it turns off I2C messaging by
setting st->i2c_talk_onoff to zero. I2C can only be turn on again
by one of the other allowed frontend calls.

All old code is removed from lme2510_msg and this function only needs
to set st->i2c_talk_onoff to 1.

The lock status is saved and when the frondend is locked is maintained
by lme2510_int_response who will now just kill the lock.

The call back for rs2000 tuner is nologer required.

All frontend types have been tested.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 205 ++++++++++-----------------------
 1 file changed, 60 insertions(+), 145 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 55d7690..a9c7fd0 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -126,9 +126,9 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct lme2510_state {
 	unsigned long int_urb_due;
+	fe_status_t lock_status;
 	u8 id;
 	u8 tuner_config;
-	u8 signal_lock;
 	u8 signal_level;
 	u8 signal_sn;
 	u8 time_key;
@@ -143,6 +143,8 @@ struct lme2510_state {
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
+	/* Frontend original calls */
+	int (*fe_read_status)(struct dvb_frontend *, fe_status_t *);
 	int (*fe_set_voltage)(struct dvb_frontend *, fe_sec_voltage_t);
 	u8 dvb_usb_lme2510_firmware;
 };
@@ -258,6 +260,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 	static u8 *ibuf, *rbuf;
 	int i = 0, offset;
 	u32 key;
+	u8 signal_lock = 0;
 
 	switch (lme_urb->status) {
 	case 0:
@@ -298,8 +301,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 		case 0xbb:
 			switch (st->tuner_config) {
 			case TUNER_LG:
-				if (ibuf[2] > 0)
-					st->signal_lock = ibuf[2];
+				signal_lock = ibuf[2] & BIT(5);
 				st->signal_level = ibuf[4];
 				st->signal_sn = ibuf[3];
 				st->time_key = ibuf[7];
@@ -308,29 +310,29 @@ static void lme2510_int_response(struct urb *lme_urb)
 			case TUNER_S0194:
 				/* Tweak for earlier firmware*/
 				if (ibuf[1] == 0x03) {
-					if (ibuf[2] > 1)
-						st->signal_lock = ibuf[2];
+					signal_lock = ibuf[2] & BIT(4);
 					st->signal_level = ibuf[3];
 					st->signal_sn = ibuf[4];
 				} else {
 					st->signal_level = ibuf[4];
 					st->signal_sn = ibuf[5];
-					st->signal_lock =
-						(st->signal_lock & 0xf7) +
-						((ibuf[2] & 0x01) << 0x03);
 				}
 				break;
 			case TUNER_RS2000:
-				if (ibuf[2] & 0x1)
-					st->signal_lock = 0xff;
-				else
-					st->signal_lock = 0x00;
+				signal_lock = ibuf[2] & 0xee;
 				st->signal_level = ibuf[5];
 				st->signal_sn = ibuf[4];
 				st->time_key = ibuf[7];
 			default:
 				break;
 			}
+
+			/* Interrupt will also throw just BIT 0 as lock */
+			signal_lock |= ibuf[2] & BIT(0);
+
+			if (!signal_lock)
+				st->lock_status &= ~FE_HAS_LOCK;
+
 			debug_data_snipet(5, "INT Remote data snipet in", ibuf);
 		break;
 		case 0xcc:
@@ -457,124 +459,13 @@ static int lme2510_return_status(struct dvb_usb_device *d)
 static int lme2510_msg(struct dvb_usb_device *d,
 		u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
-	int ret = 0;
 	struct lme2510_state *st = d->priv;
 
-	if (st->i2c_talk_onoff == 1) {
-
-		ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
-
-		switch (st->tuner_config) {
-		case TUNER_LG:
-			if (wbuf[2] == 0x1c) {
-				if (wbuf[3] == 0x0e) {
-					st->signal_lock = rbuf[1];
-					if ((st->stream_on & 1) &&
-						(st->signal_lock & 0x10)) {
-						lme2510_stream_restart(d);
-						st->i2c_talk_onoff = 0;
-					}
-					msleep(80);
-				}
-			}
-			break;
-		case TUNER_S7395:
-			if (wbuf[2] == 0xd0) {
-				if (wbuf[3] == 0x24) {
-					st->signal_lock = rbuf[1];
-					if ((st->stream_on & 1) &&
-						(st->signal_lock & 0x8)) {
-						lme2510_stream_restart(d);
-						st->i2c_talk_onoff = 0;
-					}
-				}
-			}
-			break;
-		case TUNER_S0194:
-			if (wbuf[2] == 0xd0) {
-				if (wbuf[3] == 0x1b) {
-					st->signal_lock = rbuf[1];
-					if ((st->stream_on & 1) &&
-						(st->signal_lock & 0x8)) {
-						lme2510_stream_restart(d);
-						st->i2c_talk_onoff = 0;
-					}
-				}
-			}
-			break;
-		case TUNER_RS2000:
-		default:
-			break;
-		}
-	} else {
-		/* TODO rewrite this section */
-		switch (st->tuner_config) {
-		case TUNER_LG:
-			switch (wbuf[3]) {
-			case 0x0e:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_lock;
-				break;
-			default:
-				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
-				st->i2c_talk_onoff = 1;
-				break;
-			}
-			break;
-		case TUNER_S7395:
-			switch (wbuf[3]) {
-			case 0x24:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_lock;
-				break;
-			default:
-				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
-				st->i2c_talk_onoff = 1;
-				break;
-			}
-			break;
-		case TUNER_S0194:
-			switch (wbuf[3]) {
-			case 0x1b:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_lock;
-				break;
-			default:
-				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
-				st->i2c_talk_onoff = 1;
-				break;
-			}
-			break;
-		case TUNER_RS2000:
-			switch (wbuf[3]) {
-			case 0x8c:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_lock;
-
-				/* If int_urb_due overdue
-				 *  set rbuf[1] to 0 to clear lock */
-				if (time_after(jiffies,	st->int_urb_due))
-					rbuf[1] = 0;
-
-				break;
-			default:
-				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
-				st->i2c_talk_onoff = 1;
-				break;
-			}
-		default:
-			break;
-		}
-
-		deb_info(4, "I2C From Interrupt Message out(%02x) in(%02x)",
-				wbuf[3], rbuf[1]);
-
-	}
+	st->i2c_talk_onoff = 1;
 
-	return ret;
+	return lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
 }
 
-
 static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				 int num)
 {
@@ -897,26 +788,8 @@ static struct stv0299_config sharp_z0194_config = {
 	.set_symbol_rate = sharp_z0194a_set_symbol_rate,
 };
 
-static int dm04_rs2000_set_ts_param(struct dvb_frontend *fe,
-	int caller)
-{
-	struct dvb_usb_adapter *adap = fe_to_adap(fe);
-	struct dvb_usb_device *d = adap_to_d(adap);
-	struct lme2510_state *st = d->priv;
-
-	mutex_lock(&d->i2c_mutex);
-	if ((st->i2c_talk_onoff == 1) && (st->stream_on & 1)) {
-		st->i2c_talk_onoff = 0;
-		lme2510_stream_restart(d);
-	}
-	mutex_unlock(&d->i2c_mutex);
-
-	return 0;
-}
-
 static struct m88rs2000_config m88rs2000_config = {
-	.demod_addr = 0x68,
-	.set_ts_params = dm04_rs2000_set_ts_param,
+	.demod_addr = 0x68
 };
 
 static struct ts2020_config ts2020_config = {
@@ -960,6 +833,46 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
+static int dm04_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	struct lme2510_state *st = d->priv;
+	int ret = 0;
+
+	if (st->i2c_talk_onoff) {
+		if (st->fe_read_status) {
+			ret = st->fe_read_status(fe, status);
+			if (ret < 0)
+				return ret;
+		}
+
+		st->lock_status = *status;
+
+		if (*status & FE_HAS_LOCK && st->stream_on) {
+			mutex_lock(&d->i2c_mutex);
+
+			st->i2c_talk_onoff = 0;
+			ret = lme2510_stream_restart(d);
+
+			mutex_unlock(&d->i2c_mutex);
+		}
+
+		return ret;
+	}
+
+	/* Timeout of interrupt reached on RS2000 */
+	if (st->tuner_config == TUNER_RS2000 &&
+	    time_after(jiffies, st->int_urb_due))
+		st->lock_status &= ~FE_HAS_LOCK;
+
+	*status = st->lock_status;
+
+	if (!(*status & FE_HAS_LOCK))
+		st->i2c_talk_onoff = 1;
+
+	return ret;
+}
+
 static int dm04_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct lme2510_state *st = fe_to_priv(fe);
@@ -1122,6 +1035,9 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
+	st->fe_read_status = adap->fe[0]->ops.read_status;
+
+	adap->fe[0]->ops.read_status = dm04_read_status;
 	adap->fe[0]->ops.read_signal_strength = dm04_read_signal_strength;
 	adap->fe[0]->ops.read_snr = dm04_read_snr;
 	adap->fe[0]->ops.read_ber = dm04_read_ber;
@@ -1269,7 +1185,6 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 
 	if (st->usb_buffer != NULL) {
 		st->i2c_talk_onoff = 1;
-		st->signal_lock = 0;
 		st->signal_level = 0;
 		st->signal_sn = 0;
 		buffer = st->usb_buffer;
-- 
2.1.0

