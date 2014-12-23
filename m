Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38932 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbaLWUud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:33 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 36/66] rtl28xxu: use demod mux I2C adapter for every tuner
Date: Tue, 23 Dec 2014 22:49:29 +0200
Message-Id: <1419367799-14263-36-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuners are connected to demod I2C adapter. Use that muxed adapter
for each tuner. That allows us to get rid of hackish FE gate control
solution.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 25c885f..ef27ad0 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1074,7 +1074,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	switch (priv->tuner) {
 	case TUNER_RTL2832_FC0012:
 		fe = dvb_attach(fc0012_attach, adap->fe[0],
-			&d->i2c_adap, &rtl2832u_fc0012_config);
+			priv->demod_i2c_adapter, &rtl2832u_fc0012_config);
 
 		/* since fc0012 includs reading the signal strength delegate
 		 * that to the tuner driver */
@@ -1087,7 +1087,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case TUNER_RTL2832_FC0013:
 		fe = dvb_attach(fc0013_attach, adap->fe[0],
-			&d->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
+			priv->demod_i2c_adapter, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
 
 		/* fc0013 also supports signal strength reading */
 		adap->fe[0]->ops.read_signal_strength =
@@ -1132,7 +1132,8 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 		break;
 	case TUNER_RTL2832_FC2580:
-		fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
+		fe = dvb_attach(fc2580_attach, adap->fe[0],
+				priv->demod_i2c_adapter,
 				&rtl2832u_fc2580_config);
 		break;
 	case TUNER_RTL2832_TUA9001:
@@ -1145,11 +1146,13 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		if (ret)
 			goto err;
 
-		fe = dvb_attach(tua9001_attach, adap->fe[0], &d->i2c_adap,
+		fe = dvb_attach(tua9001_attach, adap->fe[0],
+				priv->demod_i2c_adapter,
 				&rtl2832u_tua9001_config);
 		break;
 	case TUNER_RTL2832_R820T:
-		fe = dvb_attach(r820t_attach, adap->fe[0], &d->i2c_adap,
+		fe = dvb_attach(r820t_attach, adap->fe[0],
+				priv->demod_i2c_adapter,
 				&rtl2832u_r820t_config);
 
 		/* Use tuner to get the signal strength */
-- 
http://palosaari.fi/

