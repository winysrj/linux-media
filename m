Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:45907 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbACAIu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 19:08:50 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/1] rtl28xxu: swap frontend order for devices with slave demodulators
Date: Sat,  3 Jan 2015 01:08:43 +0100
Message-Id: <1420243723-5685-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ab48b5f..37f8825 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -863,6 +863,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 		/* attach slave demodulator */
 		if (priv->slave_demod == SLAVE_DEMOD_MN88472) {
+			struct dvb_frontend *tmp_fe;
 			struct mn88472_config mn88472_config = {};
 
 			mn88472_config.fe = &adap->fe[1];
@@ -887,7 +888,13 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			priv->i2c_client_slave_demod = client;
+
+			/* Swap frontend order */
+			tmp_fe = adap->fe[0];
+			adap->fe[0] = adap->fe[1];
+			adap->fe[1] = tmp_fe;
 		} else {
+			struct dvb_frontend *tmp_fe;
 			struct mn88473_config mn88473_config = {};
 
 			mn88473_config.fe = &adap->fe[1];
@@ -909,6 +916,11 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			priv->i2c_client_slave_demod = client;
+
+			/* Swap frontend order */
+			tmp_fe = adap->fe[0];
+			adap->fe[0] = adap->fe[1];
+			adap->fe[1] = tmp_fe;
 		}
 	}
 
@@ -1144,12 +1156,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	case TUNER_RTL2832_R828D:
-		fe = dvb_attach(r820t_attach, adap->fe[0],
-				priv->demod_i2c_adapter,
-				&rtl2832u_r828d_config);
-		adap->fe[0]->ops.read_signal_strength =
-				adap->fe[0]->ops.tuner_ops.get_rf_strength;
-
 		if (adap->fe[1]) {
 			fe = dvb_attach(r820t_attach, adap->fe[1],
 					priv->demod_i2c_adapter,
@@ -1158,6 +1164,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 					adap->fe[1]->ops.tuner_ops.get_rf_strength;
 		}
 
+		fe = dvb_attach(r820t_attach, adap->fe[0],
+				priv->demod_i2c_adapter,
+				&rtl2832u_r828d_config);
+		adap->fe[0]->ops.read_signal_strength =
+				adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
 		/* attach SDR */
 		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_r820t_config, NULL);
@@ -1373,7 +1385,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 
 	/* bypass slave demod TS through master demod */
 	if (fe->id == 1 && onoff) {
-		ret = rtl2832_enable_external_ts_if(adap->fe[0]);
+		ret = rtl2832_enable_external_ts_if(adap->fe[1]);
 		if (ret)
 			goto err;
 	}
-- 
1.9.1

