Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:52967 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaLMASz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 19:18:55 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave demodulators
Date: Sat, 13 Dec 2014 01:18:43 +0100
Message-Id: <1418429925-16342-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ab48b5f..cdc342a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -863,6 +863,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 		/* attach slave demodulator */
 		if (priv->slave_demod == SLAVE_DEMOD_MN88472) {
+			struct dvb_frontend *tmp_fe;
 			struct mn88472_config mn88472_config = {};
 
 			mn88472_config.fe = &adap->fe[1];
@@ -887,6 +888,12 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			priv->i2c_client_slave_demod = client;
+
+			/* Swap frontend order */
+			tmp_fe = adap->fe[0];
+			adap->fe[0] = adap->fe[1];
+			adap->fe[1] = tmp_fe;
+
 		} else {
 			struct mn88473_config mn88473_config = {};
 
@@ -1373,7 +1380,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 
 	/* bypass slave demod TS through master demod */
 	if (fe->id == 1 && onoff) {
-		ret = rtl2832_enable_external_ts_if(adap->fe[0]);
+		ret = rtl2832_enable_external_ts_if(adap->fe[1]);
 		if (ret)
 			goto err;
 	}
-- 
1.9.1

