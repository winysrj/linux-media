Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46655 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLWWBR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 17:01:17 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 54/66] rtl28xxu: fix DVB FE callback
Date: Tue, 23 Dec 2014 22:49:47 +0200
Message-Id: <1419367799-14263-54-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB FE callback functionality went broken after I moved tuners to
demod muxed I2C adapter. That happens because driver state was
carried by I2C adapter and when mux is used there is one adapter
more in a chain.
USB adapter <-> I2C adapter <-> muxed I2C adapter

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0d37d0c..1f29307 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -740,8 +740,23 @@ static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
 static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 		int cmd, int arg)
 {
-	struct i2c_adapter *adap = adapter_priv;
-	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct i2c_adapter *adapter = adapter_priv;
+	struct device *parent = adapter->dev.parent;
+	struct i2c_adapter *parent_adapter;
+	struct dvb_usb_device *d;
+
+	/*
+	 * All tuners are connected to demod muxed I2C adapter. We have to
+	 * resolve its parent adapter in order to get handle for this driver
+	 * private data. That is a bit hackish solution, GPIO or direct driver
+	 * callback would be better...
+	 */
+	if (parent != NULL && parent->type == &i2c_adapter_type)
+		parent_adapter = to_i2c_adapter(parent);
+	else
+		return -EINVAL;
+
+	d = i2c_get_adapdata(parent_adapter);
 
 	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
 			__func__, component, cmd, arg);
-- 
http://palosaari.fi/

