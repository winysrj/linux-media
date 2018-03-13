Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:46715 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932840AbeCMXkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/18] dvb-usb-v2: add probe/disconnect callbacks
Date: Wed, 14 Mar 2018 01:39:42 +0200
Message-Id: <20180313233944.7234-16-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add probe and disconnect callbacks that behaves similarly than ones
used commonly on Linux driver model. We need those to get early / late
access to driver in order to use normal probe time stuff, like regmap,
extra bus adapters and so.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  4 ++++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index d2e80537b2f7..3fd6cc0d6340 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -203,6 +203,8 @@ struct dvb_usb_adapter_properties {
  * @generic_bulk_ctrl_endpoint_response: bulk control endpoint number for
  *  receive
  * @generic_bulk_ctrl_delay: delay between bulk control sent and receive message
+ * @probe: like probe on driver model
+ * @disconnect: like disconnect on driver model
  * @identify_state: called to determine the firmware state (cold or warm) and
  *  return possible firmware file name to be loaded
  * @firmware: name of the firmware file to be loaded
@@ -239,6 +241,8 @@ struct dvb_usb_device_properties {
 	u8 generic_bulk_ctrl_endpoint_response;
 	unsigned int generic_bulk_ctrl_delay;
 
+	int (*probe)(struct dvb_usb_device *);
+	void (*disconnect)(struct dvb_usb_device *);
 #define WARM                  0
 #define COLD                  1
 	int (*identify_state) (struct dvb_usb_device *, const char **);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 2bf3bd81280a..afdcdbf005e9 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -854,8 +854,6 @@ static int dvb_usbv2_exit(struct dvb_usb_device *d)
 	dvb_usbv2_remote_exit(d);
 	dvb_usbv2_adapter_exit(d);
 	dvb_usbv2_i2c_exit(d);
-	kfree(d->priv);
-	kfree(d);
 
 	return 0;
 }
@@ -934,7 +932,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 	if (intf->cur_altsetting->desc.bInterfaceNumber !=
 			d->props->bInterfaceNumber) {
 		ret = -ENODEV;
-		goto err_free_all;
+		goto err_kfree_d;
 	}
 
 	mutex_init(&d->usb_mutex);
@@ -946,10 +944,16 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 			dev_err(&d->udev->dev, "%s: kzalloc() failed\n",
 					KBUILD_MODNAME);
 			ret = -ENOMEM;
-			goto err_free_all;
+			goto err_kfree_d;
 		}
 	}
 
+	if (d->props->probe) {
+		ret = d->props->probe(d);
+		if (ret)
+			goto err_kfree_priv;
+	}
+
 	if (d->props->identify_state) {
 		const char *name = NULL;
 		ret = d->props->identify_state(d, &name);
@@ -1001,6 +1005,12 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 	return 0;
 err_free_all:
 	dvb_usbv2_exit(d);
+	if (d->props->disconnect)
+		d->props->disconnect(d);
+err_kfree_priv:
+	kfree(d->priv);
+err_kfree_d:
+	kfree(d);
 err:
 	dev_dbg(&udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -1021,6 +1031,12 @@ void dvb_usbv2_disconnect(struct usb_interface *intf)
 
 	dvb_usbv2_exit(d);
 
+	if (d->props->disconnect)
+		d->props->disconnect(d);
+
+	kfree(d->priv);
+	kfree(d);
+
 	pr_info("%s: '%s:%s' successfully deinitialized and disconnected\n",
 		KBUILD_MODNAME, drvname, devname);
 	kfree(devname);
-- 
2.14.3
