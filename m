Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60640 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab3JNALD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 20:11:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: cannot ret error from probe - switch tuner to I2C driver model
Date: Mon, 14 Oct 2013 03:10:50 +0300
Message-Id: <1381709450-14345-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kernel: usb 1-2: rtl2832u_tuner_attach:
kernel: e4000 5-0064: e4000_probe:
kernel: usb 1-2: rtl2832u_tuner_attach: client ptr ffff88030a849000

See attached patch.

Is there any way to return error to caller?

Abuse platform data ptr from struct i2c_board_info and call i2c_unregister_device() ?

regards
Antti

---
 drivers/media/tuners/e4000.c            | 31 +++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 18 ++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 54e2d8a..f4e0567 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -442,6 +442,37 @@ err:
 }
 EXPORT_SYMBOL(e4000_attach);
 
+static int e4000_probe(struct i2c_client *client, const struct i2c_device_id *did)
+{
+	dev_info(&client->dev, "%s:\n", __func__);
+	return -ENODEV;
+}
+
+static int e4000_remove(struct i2c_client *client)
+{
+	dev_info(&client->dev, "%s:\n", __func__);
+	return 0;
+}
+
+static const struct i2c_device_id e4000_id[] = {
+	{"e4000", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, e4000_id);
+
+static struct i2c_driver e4000_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "e4000",
+	},
+	.probe		= e4000_probe,
+	.remove		= e4000_remove,
+	.id_table	= e4000_id,
+};
+
+module_i2c_driver(e4000_driver);
+
 MODULE_DESCRIPTION("Elonics E4000 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index defc491..fbbe867 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -898,8 +898,22 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		return 0;
 	case TUNER_RTL2832_E4000:
-		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
-				&rtl2832u_e4000_config);
+//		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
+//				&rtl2832u_e4000_config);
+		{
+			static const struct i2c_board_info info = {
+				.type = "e4000",
+				.addr = 0x64,
+			};
+			struct i2c_client *client;
+
+			fe = NULL;
+			client = i2c_new_device(&d->i2c_adap, &info);
+			if (IS_ERR_OR_NULL(client))
+				dev_err(&d->udev->dev, "e4000 probe failed\n");
+
+			dev_dbg(&d->udev->dev, "%s: client ptr %p\n", __func__, client);
+		}
 		break;
 	case TUNER_RTL2832_FC2580:
 		fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
-- 
1.8.3.1

