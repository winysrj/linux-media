Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58811 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab2IQU6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:58:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/7] rtl28xxu: remove fc0013 tuner fe callback
Date: Mon, 17 Sep 2012 23:58:10 +0300
Message-Id: <1347915492-24924-5-git-send-email-crope@iki.fi>
In-Reply-To: <1347915492-24924-1-git-send-email-crope@iki.fi>
References: <1347915492-24924-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is just stub implementation, remove it.
Also add debug for beginning of fe callback.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 6bd7a07..dd2a788 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -618,14 +618,6 @@ err:
 	return ret;
 }
 
-
-static int rtl2832u_fc0013_tuner_callback(struct dvb_usb_device *d,
-		int cmd, int arg)
-{
-	/* TODO implement*/
-	return 0;
-}
-
 static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -676,8 +668,6 @@ static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 	switch (priv->tuner) {
 	case TUNER_RTL2832_FC0012:
 		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
-	case TUNER_RTL2832_FC0013:
-		return rtl2832u_fc0013_tuner_callback(d, cmd, arg);
 	case TUNER_RTL2832_TUA9001:
 		return rtl2832u_tua9001_tuner_callback(d, cmd, arg);
 	default:
@@ -688,11 +678,14 @@ static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 }
 
 static int rtl2832u_frontend_callback(void *adapter_priv, int component,
-				    int cmd, int arg)
+		int cmd, int arg)
 {
 	struct i2c_adapter *adap = adapter_priv;
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 
+	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
+			__func__, component, cmd, arg);
+
 	switch (component) {
 	case DVB_FRONTEND_COMPONENT_TUNER:
 		return rtl2832u_tuner_callback(d, cmd, arg);
-- 
1.7.11.4

