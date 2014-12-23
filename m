Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54009 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLWVdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:33:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 55/66] rtl28xxu: simplify FE callback handling
Date: Tue, 23 Dec 2014 22:49:48 +0200
Message-Id: <1419367799-14263-55-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Logic is so simple that there is no idea to separate tuner selection to
own function, instead do it in a callback and get rid of one function.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 1f29307..f475018 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -721,22 +721,6 @@ err:
 	return ret;
 }
 
-static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
-{
-	struct rtl28xxu_priv *priv = d->priv;
-
-	switch (priv->tuner) {
-	case TUNER_RTL2832_FC0012:
-		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
-	case TUNER_RTL2832_TUA9001:
-		return rtl2832u_tua9001_tuner_callback(d, cmd, arg);
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 		int cmd, int arg)
 {
@@ -744,6 +728,7 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 	struct device *parent = adapter->dev.parent;
 	struct i2c_adapter *parent_adapter;
 	struct dvb_usb_device *d;
+	struct rtl28xxu_priv *priv;
 
 	/*
 	 * All tuners are connected to demod muxed I2C adapter. We have to
@@ -757,15 +742,21 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 		return -EINVAL;
 
 	d = i2c_get_adapdata(parent_adapter);
+	priv = d->priv;
 
 	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
 			__func__, component, cmd, arg);
 
 	switch (component) {
 	case DVB_FRONTEND_COMPONENT_TUNER:
-		return rtl2832u_tuner_callback(d, cmd, arg);
+		switch (priv->tuner) {
+		case TUNER_RTL2832_FC0012:
+			return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
+		case TUNER_RTL2832_TUA9001:
+			return rtl2832u_tua9001_tuner_callback(d, cmd, arg);
+		}
 	default:
-		break;
+		return -EINVAL;
 	}
 
 	return 0;
-- 
http://palosaari.fi/

