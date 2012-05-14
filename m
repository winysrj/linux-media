Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37139 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab2ENUYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 16:24:47 -0400
Received: by wgbdr13 with SMTP id dr13so5067977wgb.1
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 13:24:45 -0700 (PDT)
Message-ID: <1337027082.2697.31.camel@router7789>
Subject: [PATCH]  lmedm04 ver 2.00 - changes for [TEST] Regarding m88rc2000
 i2c gate operation, SNR, BER and others
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: "Igor M. Liplianin" <liplianin@me.by>
Date: Mon, 14 May 2012 21:24:42 +0100
In-Reply-To: <1336597364.16044.15.camel@router7789>
References: <1682436.JdK20qceHM@useri>
	 <1336597364.16044.15.camel@router7789>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re: [PATCH] [TEST] Regarding m88rc2000 i2c gate operation, SNR, BER and others

This patch restores more less as before, except;

Corrected snr/signal strength are swapped.

m88rs2000_set_voltage is now called inside dm04_lme2510_set_voltage this seems 
to stop intermittent loss of device during channel change/scan.

Unfortunately, lmedm04 cannot support ucblocks or ber, neither are returned in
the interrupt callback. I am working on a patch to map them back in when
streaming is off.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   46 ++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 5dde06d..424dab6 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -136,7 +136,7 @@ struct lme2510_state {
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
-
+	int (*fe_set_voltage)(struct dvb_frontend *, fe_sec_voltage_t);
 };
 
 static int lme2510_bulk_write(struct usb_device *dev,
@@ -313,12 +313,12 @@ static void lme2510_int_response(struct urb *lme_urb)
 				}
 				break;
 			case TUNER_RS2000:
-				if (ibuf[2] > 0)
+				if (ibuf[1] == 0x3 &&  ibuf[6] == 0xff)
 					st->signal_lock = 0xff;
 				else
-					st->signal_lock = 0xf0;
-				st->signal_level = ibuf[4];
-				st->signal_sn = ibuf[5];
+					st->signal_lock = 0x00;
+				st->signal_level = ibuf[5];
+				st->signal_sn = ibuf[4];
 				st->time_key = ibuf[7];
 			default:
 				break;
@@ -973,6 +973,7 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct lme2510_state *st = adap->dev->priv;
 	static u8 voltage_low[]	= LME_VOLTAGE_L;
 	static u8 voltage_high[] = LME_VOLTAGE_H;
 	static u8 rbuf[1];
@@ -993,9 +994,13 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 				voltage_low, len, rbuf, rlen);
 		break;
 	}
-
 	mutex_unlock(&adap->dev->i2c_mutex);
 
+	if (st->tuner_config == TUNER_RS2000)
+		if (st->fe_set_voltage)
+			st->fe_set_voltage(fe, voltage);
+
+
 	return (ret < 0) ? -ENODEV : 0;
 }
 
@@ -1005,7 +1010,8 @@ static int dm04_rs2000_read_signal_strength(struct dvb_frontend *fe,
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct lme2510_state *st = adap->dev->priv;
 
-	*strength = (u16)((u32)st->signal_level * 0xffff / 0x7f);
+	*strength = (u16)((u32)st->signal_level * 0xffff / 0xff);
+
 	return 0;
 }
 
@@ -1014,7 +1020,22 @@ static int dm04_rs2000_read_snr(struct dvb_frontend *fe, u16 *snr)
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct lme2510_state *st = adap->dev->priv;
 
-	*snr = (u16)((u32)st->signal_sn * 0xffff / 0xff);
+	*snr = (u16)((u32)st->signal_sn * 0xffff / 0x7f);
+
+	return 0;
+}
+
+static int dm04_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	*ber = 0;
+
+	return 0;
+}
+
+static int dm04_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	*ucblocks = 0;
+
 	return 0;
 }
 
@@ -1101,10 +1122,17 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			st->i2c_tuner_gate_r = 5;
 			st->i2c_tuner_addr = 0xc0;
 			st->tuner_config = TUNER_RS2000;
+			st->fe_set_voltage =
+				adap->fe_adap[0].fe->ops.set_voltage;
+
 			adap->fe_adap[0].fe->ops.read_signal_strength =
 				dm04_rs2000_read_signal_strength;
 			adap->fe_adap[0].fe->ops.read_snr =
 				dm04_rs2000_read_snr;
+			adap->fe_adap[0].fe->ops.read_ber =
+				dm04_read_ber;
+			adap->fe_adap[0].fe->ops.read_ucblocks =
+				dm04_read_ucblocks;
 		}
 		break;
 	}
@@ -1404,5 +1432,5 @@ module_usb_driver(lme2510_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.99");
+MODULE_VERSION("2.00");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5



