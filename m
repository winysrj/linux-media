Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34262 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbbCPROl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 13:14:41 -0400
Received: by lbbsy1 with SMTP id sy1so35732571lbb.1
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 10:14:40 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/3] dw2102: store i2c client for tuner into dw2102_state
Date: Mon, 16 Mar 2015 19:14:05 +0200
Message-Id: <1426526046-2063-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
References: <1426526046-2063-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare the dw2102 driver for tuner drivers that are implemented as I2C drivers (such as 
m88ts2022). The I2C client is stored in to the state and released at disconnect.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index c68a610..f7dd973 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -114,6 +114,7 @@
 
 struct dw2102_state {
 	u8 initialized;
+	struct i2c_client *i2c_client_tuner;
 	int (*old_set_voltage)(struct dvb_frontend *f, fe_sec_voltage_t v);
 };
 
@@ -2138,10 +2139,26 @@ static int dw2102_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
+static void dw2102_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	struct dw2102_state *st = (struct dw2102_state *)d->priv;
+	struct i2c_client *client;
+
+	/* remove I2C client for tuner */
+	client = st->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	dvb_usb_device_exit(intf);
+}
+
 static struct usb_driver dw2102_driver = {
 	.name = "dw2102",
 	.probe = dw2102_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect = dw2102_disconnect,
 	.id_table = dw2102_table,
 };
 
-- 
1.9.1

