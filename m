Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47178 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaCNAOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/17] rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
Date: Fri, 14 Mar 2014 02:14:24 +0200
Message-Id: <1394756071-22410-11-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2832 driver provides muxed I2C adapters for tuner bus I2C gate
control. Pass those adapters to rtl2832_sdr and e4000 modules in order
to get rid of proprietary DVB .i2c_gate_ctrl() callback use.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 10 ++++++++--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index f51949e..c83c16c 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -774,6 +774,9 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		goto err;
 	}
 
+	/* RTL2832 I2C repeater */
+	priv->demod_i2c_adapter = rtl2832_get_i2c_adapter(adap->fe[0]);
+
 	/* set fe callback */
 	adap->fe[0]->callback = rtl2832u_frontend_callback;
 
@@ -922,6 +925,8 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case TUNER_RTL2832_E4000: {
 			struct v4l2_subdev *sd;
+			struct i2c_adapter *i2c_adap_internal =
+					rtl2832_get_private_i2c_adapter(adap->fe[0]);
 			struct e4000_config e4000_config = {
 				.fe = adap->fe[0],
 				.clock = 28800000,
@@ -932,7 +937,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			info.platform_data = &e4000_config;
 
 			request_module(info.type);
-			client = i2c_new_device(&d->i2c_adap, &info);
+			client = i2c_new_device(priv->demod_i2c_adapter, &info);
 			if (client == NULL || client->dev.driver == NULL)
 				break;
 
@@ -943,10 +948,11 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 
 			priv->client = client;
 			sd = i2c_get_clientdata(client);
+			i2c_set_adapdata(i2c_adap_internal, d);
 
 			/* attach SDR */
 			dvb_attach(rtl2832_sdr_attach, adap->fe[0],
-					&d->i2c_adap,
+					i2c_adap_internal,
 					&rtl28xxu_rtl2832_e4000_config, sd);
 		}
 		break;
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 367aca1..a26cab1 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -55,6 +55,7 @@ struct rtl28xxu_priv {
 	u8 tuner;
 	char *tuner_name;
 	u8 page; /* integrated demod active register page */
+	struct i2c_adapter *demod_i2c_adapter;
 	bool rc_active;
 	struct i2c_client *client;
 };
-- 
1.8.5.3

