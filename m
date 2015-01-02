Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56681 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbABN46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 08:56:58 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so27733862wiw.1
        for <linux-media@vger.kernel.org>; Fri, 02 Jan 2015 05:56:57 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/5] lmedm04: create frontend callbacks for signal/snr/ber/ucblocks
Date: Fri,  2 Jan 2015 13:56:29 +0000
Message-Id: <1420206991-3939-3-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
References: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create call backs dm04_read_signal_strength, dm04_read_snr and
move dm04_read_ber and dm04_read_ucblocks for all frontends

Removing the I2C filtering from lme2510_msg and the old rs2000 callbacks.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 93 ++++++++++++----------------------
 1 file changed, 33 insertions(+), 60 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 15db9f6..55d7690 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -515,21 +515,6 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				rbuf[0] = 0x55;
 				rbuf[1] = st->signal_lock;
 				break;
-			case 0x43:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_level;
-				break;
-			case 0x1c:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_sn;
-				break;
-			case 0x15:
-			case 0x16:
-			case 0x17:
-			case 0x18:
-				rbuf[0] = 0x55;
-				rbuf[1] = 0x00;
-				break;
 			default:
 				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
 				st->i2c_talk_onoff = 1;
@@ -538,25 +523,10 @@ static int lme2510_msg(struct dvb_usb_device *d,
 			break;
 		case TUNER_S7395:
 			switch (wbuf[3]) {
-			case 0x10:
-				rbuf[0] = 0x55;
-				rbuf[1] = (st->signal_level & 0x80)
-						? 0 : (st->signal_level * 2);
-				break;
-			case 0x2d:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_sn;
-				break;
 			case 0x24:
 				rbuf[0] = 0x55;
 				rbuf[1] = st->signal_lock;
 				break;
-			case 0x2e:
-			case 0x26:
-			case 0x27:
-				rbuf[0] = 0x55;
-				rbuf[1] = 0x00;
-				break;
 			default:
 				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
 				st->i2c_talk_onoff = 1;
@@ -565,26 +535,10 @@ static int lme2510_msg(struct dvb_usb_device *d,
 			break;
 		case TUNER_S0194:
 			switch (wbuf[3]) {
-			case 0x18:
-				rbuf[0] = 0x55;
-				rbuf[1] = (st->signal_level & 0x80)
-						? 0 : (st->signal_level * 2);
-				break;
-			case 0x24:
-				rbuf[0] = 0x55;
-				rbuf[1] = st->signal_sn;
-				break;
 			case 0x1b:
 				rbuf[0] = 0x55;
 				rbuf[1] = st->signal_lock;
 				break;
-			case 0x19:
-			case 0x25:
-			case 0x1e:
-			case 0x1d:
-				rbuf[0] = 0x55;
-				rbuf[1] = 0x00;
-				break;
 			default:
 				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
 				st->i2c_talk_onoff = 1;
@@ -1006,21 +960,44 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-static int dm04_rs2000_read_signal_strength(struct dvb_frontend *fe,
-	u16 *strength)
+static int dm04_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct lme2510_state *st = fe_to_priv(fe);
 
-	*strength = (u16)((u32)st->signal_level * 0xffff / 0xff);
+	switch (st->tuner_config) {
+	case TUNER_LG:
+		*strength = 0xff - st->signal_level;
+		*strength |= *strength << 8;
+		break;
+	/* fall through */
+	case TUNER_S7395:
+	case TUNER_S0194:
+		*strength = 0xffff - (((st->signal_level * 2) << 8) * 5 / 4);
+		break;
+	case TUNER_RS2000:
+		*strength = (u16)((u32)st->signal_level * 0xffff / 0xff);
+	}
 
 	return 0;
 }
 
-static int dm04_rs2000_read_snr(struct dvb_frontend *fe, u16 *snr)
+static int dm04_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct lme2510_state *st = fe_to_priv(fe);
 
-	*snr = (u16)((u32)st->signal_sn * 0xffff / 0x7f);
+	switch (st->tuner_config) {
+	case TUNER_LG:
+		*snr = 0xff - st->signal_sn;
+		*snr |= *snr << 8;
+		break;
+	/* fall through */
+	case TUNER_S7395:
+	case TUNER_S0194:
+		*snr = (u16)((0xff - st->signal_sn - 0xa1) * 3) << 8;
+		break;
+	case TUNER_RS2000:
+		*snr = (u16)((u32)st->signal_sn * 0xffff / 0x7f);
+	}
 
 	return 0;
 }
@@ -1127,15 +1104,6 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			st->tuner_config = TUNER_RS2000;
 			st->fe_set_voltage =
 				adap->fe[0]->ops.set_voltage;
-
-			adap->fe[0]->ops.read_signal_strength =
-				dm04_rs2000_read_signal_strength;
-			adap->fe[0]->ops.read_snr =
-				dm04_rs2000_read_snr;
-			adap->fe[0]->ops.read_ber =
-				dm04_read_ber;
-			adap->fe[0]->ops.read_ucblocks =
-				dm04_read_ucblocks;
 		}
 		break;
 	}
@@ -1154,7 +1122,12 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
+	adap->fe[0]->ops.read_signal_strength = dm04_read_signal_strength;
+	adap->fe[0]->ops.read_snr = dm04_read_snr;
+	adap->fe[0]->ops.read_ber = dm04_read_ber;
+	adap->fe[0]->ops.read_ucblocks = dm04_read_ucblocks;
 	adap->fe[0]->ops.set_voltage = dm04_lme2510_set_voltage;
+
 	ret = lme_name(adap);
 	return ret;
 }
-- 
2.1.0

