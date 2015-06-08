Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34487 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbbFHWGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 18:06:22 -0400
Received: by wibut5 with SMTP id ut5so879346wib.1
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 15:06:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2][media] lmedm04: implement dvb v5 statistics
Date: Mon,  8 Jun 2015 23:05:20 +0100
Message-Id: <1433801120-1917-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Indroduce function lme2510_update_stats to update
statistics directly from usb interrupt.

Provide signal and snr wrap rounds for dvb v3 functions.

Block and post bit are not available.

When i2c_talk_onoff is on no statistics are available,
with possible future hand over to the relevant frontend/tuner.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
v2 Correct variable size casts
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 104 ++++++++++++++++++++++++---------
 1 file changed, 77 insertions(+), 27 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index f1983f2..726c59e 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -257,6 +257,65 @@ static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
 	return ret;
 }
 
+static void lme2510_update_stats(struct dvb_usb_adapter *adap)
+{
+	struct lme2510_state *st = adap_to_priv(adap);
+	struct dvb_frontend *fe = adap->fe[0];
+	struct dtv_frontend_properties *c;
+	u64 s_tmp = 0, c_tmp = 0;
+
+	if (!fe)
+		return;
+
+	c = &fe->dtv_property_cache;
+
+	c->block_count.len = 1;
+	c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.len = 1;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+	if (st->i2c_talk_onoff) {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
+
+	switch (st->tuner_config) {
+	case TUNER_LG:
+		s_tmp = 0xff - st->signal_level;
+		s_tmp |= s_tmp << 8;
+
+		c_tmp = 0xff - st->signal_sn;
+		c_tmp |= c_tmp << 8;
+		break;
+	/* fall through */
+	case TUNER_S7395:
+	case TUNER_S0194:
+		s_tmp = 0xffff - (((st->signal_level * 2) << 8) * 5 / 4);
+
+		c_tmp = ((0xff - st->signal_sn - 0xa1) * 3) << 8;
+		break;
+	case TUNER_RS2000:
+		s_tmp = st->signal_level * 0xffff / 0xff;
+
+		c_tmp = st->signal_sn * 0xffff / 0x7f;
+	}
+
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = s_tmp;
+
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_RELATIVE;
+	c->cnr.stat[0].uvalue = c_tmp;
+}
+
 static void lme2510_int_response(struct urb *lme_urb)
 {
 	struct dvb_usb_adapter *adap = lme_urb->context;
@@ -337,6 +396,8 @@ static void lme2510_int_response(struct urb *lme_urb)
 			if (!signal_lock)
 				st->lock_status &= ~FE_HAS_LOCK;
 
+			lme2510_update_stats(adap);
+
 			debug_data_snipet(5, "INT Remote data snipet in", ibuf);
 		break;
 		case 0xcc:
@@ -872,56 +933,45 @@ static int dm04_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	*status = st->lock_status;
 
-	if (!(*status & FE_HAS_LOCK))
+	if (!(*status & FE_HAS_LOCK)) {
+		struct dvb_usb_adapter *adap = fe_to_adap(fe);
+
 		st->i2c_talk_onoff = 1;
 
+		lme2510_update_stats(adap);
+	}
+
 	return ret;
 }
 
 static int dm04_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct lme2510_state *st = fe_to_priv(fe);
 
 	if (st->fe_read_signal_strength && !st->stream_on)
 		return st->fe_read_signal_strength(fe, strength);
 
-	switch (st->tuner_config) {
-	case TUNER_LG:
-		*strength = 0xff - st->signal_level;
-		*strength |= *strength << 8;
-		break;
-	/* fall through */
-	case TUNER_S7395:
-	case TUNER_S0194:
-		*strength = 0xffff - (((st->signal_level * 2) << 8) * 5 / 4);
-		break;
-	case TUNER_RS2000:
-		*strength = (u16)((u32)st->signal_level * 0xffff / 0xff);
-	}
+	if (c->strength.stat[0].scale == FE_SCALE_RELATIVE)
+		*strength = (u16)c->strength.stat[0].uvalue;
+	else
+		*strength = 0;
 
 	return 0;
 }
 
 static int dm04_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct lme2510_state *st = fe_to_priv(fe);
 
 	if (st->fe_read_snr && !st->stream_on)
 		return st->fe_read_snr(fe, snr);
 
-	switch (st->tuner_config) {
-	case TUNER_LG:
-		*snr = 0xff - st->signal_sn;
-		*snr |= *snr << 8;
-		break;
-	/* fall through */
-	case TUNER_S7395:
-	case TUNER_S0194:
-		*snr = (u16)((0xff - st->signal_sn - 0xa1) * 3) << 8;
-		break;
-	case TUNER_RS2000:
-		*snr = (u16)((u32)st->signal_sn * 0xffff / 0x7f);
-	}
+	if (c->cnr.stat[0].scale == FE_SCALE_RELATIVE)
+		*snr = (u16)c->cnr.stat[0].uvalue;
+	else
+		*snr = 0;
 
 	return 0;
 }
-- 
2.1.4

