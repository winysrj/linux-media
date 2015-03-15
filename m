Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56462 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbCOW6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 18:58:04 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi, mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/10] rtl28xxu: swap frontend order for slave demods
Date: Sun, 15 Mar 2015 23:57:49 +0100
Message-Id: <1426460275-3766-4-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices have 2 demodulators, when this is the case
make the slave demod be listed first. Enumerating the slave
first will help legacy applications to use the hardware.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ea75b3a..bb5003d 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -853,6 +853,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	if (dev->slave_demod) {
 		struct i2c_board_info info = {};
+		struct dvb_frontend *tmp_fe;
 
 		/*
 		 * We continue on reduced mode, without DVB-T2/C, using master
@@ -907,6 +908,11 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 			dev->i2c_client_slave_demod = client;
 		}
+
+		/* Swap frontend order */
+		tmp_fe = adap->fe[0];
+		adap->fe[0] = adap->fe[1];
+		adap->fe[1] = tmp_fe;
 	}
 
 	return 0;
@@ -1134,12 +1140,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		break;
 	case TUNER_RTL2832_R828D:
-		fe = dvb_attach(r820t_attach, adap->fe[0],
-				dev->demod_i2c_adapter,
-				&rtl2832u_r828d_config);
-		adap->fe[0]->ops.read_signal_strength =
-				adap->fe[0]->ops.tuner_ops.get_rf_strength;
-
 		if (adap->fe[1]) {
 			fe = dvb_attach(r820t_attach, adap->fe[1],
 					dev->demod_i2c_adapter,
@@ -1147,6 +1147,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			adap->fe[1]->ops.read_signal_strength =
 					adap->fe[1]->ops.tuner_ops.get_rf_strength;
 		}
+
+		fe = dvb_attach(r820t_attach, adap->fe[0],
+			dev->demod_i2c_adapter,
+			&rtl2832u_r828d_config);
+		adap->fe[0]->ops.read_signal_strength =
+			adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		break;
 	default:
 		dev_err(&d->intf->dev, "unknown tuner %d\n", dev->tuner);
-- 
2.1.0

