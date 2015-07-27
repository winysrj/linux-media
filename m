Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51063 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbG0LWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:22:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/6] zd1301: ZyDAS ZD1301 DVB USB interface driver
Date: Mon, 27 Jul 2015 14:22:09 +0300
Message-Id: <1437996130-23735-6-git-send-email-crope@iki.fi>
In-Reply-To: <1437996130-23735-1-git-send-email-crope@iki.fi>
References: <1437996130-23735-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ZyDAS ZD1301 is chip having USB interface and DVB-T demodulator
integrated. This driver is for USB interface part.

Device has USB ID 0ace:13a1. Used tuner is MT2060.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h  |   1 +
 drivers/media/usb/dvb-usb-v2/Kconfig  |   8 +
 drivers/media/usb/dvb-usb-v2/Makefile |   3 +
 drivers/media/usb/dvb-usb-v2/zd1301.c | 276 ++++++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/zd1301.h |  36 +++++
 5 files changed, 324 insertions(+)
 create mode 100644 drivers/media/usb/dvb-usb-v2/zd1301.c
 create mode 100644 drivers/media/usb/dvb-usb-v2/zd1301.h

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index c117fb3..149c276 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -65,6 +65,7 @@
 #define USB_VID_GIGABYTE			0x1044
 #define USB_VID_YUAN				0x1164
 #define USB_VID_XTENSIONS			0x1ae7
+#define USB_VID_ZYDAS				0x0ace
 #define USB_VID_HUMAX_COEX			0x10b9
 #define USB_VID_774				0x7a69
 #define USB_VID_EVOLUTEPC			0x1e59
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 9facc92..c584826 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -151,3 +151,11 @@ config DVB_USB_DVBSKY
 	select DVB_SP2 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the USB receivers from DVBSky.
+
+config DVB_USB_ZD1301
+	tristate "ZyDAS ZD1301"
+	depends on DVB_USB_V2
+	select DVB_ZD1301_DEMOD if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y here to support the ZyDAS ZD1301 DVB USB receiver.
diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index f10d4df..969f68e 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -40,6 +40,9 @@ obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
 dvb-usb-dvbsky-objs := dvbsky.o
 obj-$(CONFIG_DVB_USB_DVBSKY) += dvb-usb-dvbsky.o
 
+dvb-usb-zd1301-objs := zd1301.o
+obj-$(CONFIG_DVB_USB_ZD1301) += zd1301.o
+
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
diff --git a/drivers/media/usb/dvb-usb-v2/zd1301.c b/drivers/media/usb/dvb-usb-v2/zd1301.c
new file mode 100644
index 0000000..b9c1f82
--- /dev/null
+++ b/drivers/media/usb/dvb-usb-v2/zd1301.c
@@ -0,0 +1,276 @@
+/*
+ * ZyDAS ZD1301 driver (USB interface)
+ *
+ * Copyright (C) 2015 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ */
+
+#include "zd1301.h"
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static int zd1301_ctrl_msg(struct dvb_usb_device *d, const u8 *wbuf,
+			   unsigned int wlen, u8 *rbuf, unsigned int rlen)
+{
+	struct zd1301_dev *dev = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
+	int ret, actual_length;
+
+	mutex_lock(&d->usb_mutex);
+
+	memcpy(&dev->buf, wbuf, wlen);
+
+	dev_dbg(&intf->dev, ">>> %*ph\n", wlen, dev->buf);
+
+	ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev, 0x04), dev->buf,
+			   wlen, &actual_length, 1000);
+	if (ret) {
+		dev_err(&intf->dev, "1st usb_bulk_msg() failed %d\n", ret);
+		goto err_mutex_unlock;
+	}
+
+	if (rlen) {
+		ret = usb_bulk_msg(d->udev, usb_rcvbulkpipe(d->udev, 0x83),
+				   dev->buf, rlen, &actual_length, 1000);
+		if (ret) {
+			dev_err(&intf->dev,
+				"2nd usb_bulk_msg() failed %d\n", ret);
+			goto err_mutex_unlock;
+		}
+
+		dev_dbg(&intf->dev, "<<< %*ph\n", actual_length, dev->buf);
+
+		if (actual_length != rlen) {
+			/*
+			 * Chip replies often with 3 byte len stub. On that case
+			 * we have to query new reply.
+			 */
+			dev_dbg(&intf->dev, "repeating reply message\n");
+
+			ret = usb_bulk_msg(d->udev,
+					   usb_rcvbulkpipe(d->udev, 0x83),
+					   dev->buf, rlen, &actual_length,
+					   1000);
+			if (ret) {
+				dev_err(&intf->dev,
+					"3rd usb_bulk_msg() failed %d\n", ret);
+				goto err_mutex_unlock;
+			}
+
+			dev_dbg(&intf->dev,
+				"<<< %*ph\n", actual_length, dev->buf);
+		}
+
+		memcpy(rbuf, dev->buf, rlen);
+	}
+
+err_mutex_unlock:
+	mutex_unlock(&d->usb_mutex);
+	return ret;
+}
+
+static int zd1301_demod_wreg(void *reg_priv, u16 reg, u8 val)
+{
+	struct dvb_usb_device *d = reg_priv;
+	struct usb_interface *intf = d->intf;
+	int ret;
+	u8 buf[7] = {0x07, 0x00, 0x03, 0x01,
+		     (reg >> 0) & 0xff, (reg >> 8) & 0xff, val};
+
+	ret = zd1301_ctrl_msg(d, buf, 7, NULL, 0);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_demod_rreg(void *reg_priv, u16 reg, u8 *val)
+{
+	struct dvb_usb_device *d = reg_priv;
+	struct usb_interface *intf = d->intf;
+	int ret;
+	u8 buf[7] = {0x07, 0x00, 0x04, 0x01,
+		     (reg >> 0) & 0xff, (reg >> 8) & 0xff, 0};
+
+	ret = zd1301_ctrl_msg(d, buf, 7, buf, 7);
+	if (ret)
+		goto err;
+
+	*val = buf[6];
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct zd1301_dev *dev = adap_to_priv(adap);
+	struct usb_interface *intf = d->intf;
+	struct platform_device *pdev;
+	struct i2c_client *client;
+	struct i2c_board_info board_info;
+	struct i2c_adapter *adapter;
+	int ret;
+
+	dev_dbg(&intf->dev, "\n");
+
+	/* Add platform demod */
+	dev->demod_pdata.reg_priv = d;
+	dev->demod_pdata.reg_read = zd1301_demod_rreg;
+	dev->demod_pdata.reg_write = zd1301_demod_wreg;
+	request_module("%s", "zd1301_demod");
+	pdev = platform_device_register_data(&intf->dev,
+					     "zd1301_demod",
+					     PLATFORM_DEVID_AUTO,
+					     &dev->demod_pdata,
+					     sizeof(dev->demod_pdata));
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
+		goto err;
+	}
+	if (!pdev->dev.driver) {
+		ret = -ENODEV;
+		goto err;
+	}
+	if (!try_module_get(pdev->dev.driver->owner)) {
+		platform_device_unregister(pdev);
+		ret = -ENODEV;
+		goto err;
+	}
+	adap->fe[0] = zd1301_demod_get_dvb_frontend(pdev);
+	adapter = zd1301_demod_get_i2c_adapter(pdev);
+	dev->platform_device_demod = pdev;
+
+	/* Add I2C tuner */
+	dev->mt2060_pdata.i2c_wr_max = 9;
+	dev->mt2060_pdata.dvb_frontend = adap->fe[0];
+	memset(&board_info, 0, sizeof(board_info));
+	strlcpy(board_info.type, "mt2060", I2C_NAME_SIZE);
+	board_info.addr = 0x60;
+	board_info.platform_data = &dev->mt2060_pdata;
+	request_module("%s", "mt2060");
+	client = i2c_new_device(adapter, &board_info);
+	if (!client || !client->dev.driver) {
+		ret = -ENODEV;
+		goto err_platform_device_unregister;
+	}
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		ret = -ENODEV;
+		goto err_platform_device_unregister;
+	}
+	dev->i2c_client_tuner = client;
+
+	return 0;
+err_platform_device_unregister:
+	platform_device_unregister(pdev);
+	dev->platform_device_demod = NULL;
+	adap->fe[0] = NULL;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_frontend_detach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct zd1301_dev *dev = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
+	struct platform_device *pdev;
+	struct i2c_client *client;
+
+	dev_dbg(&intf->dev, "\n");
+
+	/* Remove I2C tuner */
+	client = dev->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	/* Remove platform demod */
+	pdev = dev->platform_device_demod;
+	if (pdev) {
+		module_put(pdev->dev.driver->owner);
+		platform_device_unregister(pdev);
+	}
+
+	return 0;
+}
+
+static int zd1301_streaming_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	struct usb_interface *intf = d->intf;
+	int ret;
+	u8 buf[3] = {0x03, 0x00, onoff ? 0x07 : 0x08};
+
+	dev_dbg(&intf->dev, "onoff=%d\n", onoff);
+
+	ret = zd1301_ctrl_msg(d, buf, 3, NULL, 0);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static const struct dvb_usb_device_properties zd1301_props = {
+	.driver_name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.adapter_nr = adapter_nr,
+	.size_of_priv = sizeof(struct zd1301_dev),
+
+	.frontend_attach = zd1301_frontend_attach,
+	.frontend_detach = zd1301_frontend_detach,
+	.streaming_ctrl  = zd1301_streaming_ctrl,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.stream = DVB_USB_STREAM_BULK(0x81, 6, 21 * 188),
+		},
+	},
+};
+
+static const struct usb_device_id zd1301_id_table[] = {
+	{DVB_USB_DEVICE(USB_VID_ZYDAS, 0x13a1, &zd1301_props,
+			"ZyDAS ZD1301 reference design", NULL)},
+	{}
+};
+MODULE_DEVICE_TABLE(usb, zd1301_id_table);
+
+/* Usb specific object needed to register this driver with the usb subsystem */
+static struct usb_driver zd1301_usb_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = zd1301_id_table,
+	.probe = dvb_usbv2_probe,
+	.disconnect = dvb_usbv2_disconnect,
+	.suspend = dvb_usbv2_suspend,
+	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
+	.no_dynamic_id = 1,
+	.soft_unbind = 1,
+};
+module_usb_driver(zd1301_usb_driver);
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("ZyDAS ZD1301 driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb-v2/zd1301.h b/drivers/media/usb/dvb-usb-v2/zd1301.h
new file mode 100644
index 0000000..b0c5075
--- /dev/null
+++ b/drivers/media/usb/dvb-usb-v2/zd1301.h
@@ -0,0 +1,36 @@
+/*
+ * ZyDAS ZD1301 driver (USB interface)
+ *
+ * Copyright (C) 2015 Antti Palosaari <crope@iki.fi>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ */
+
+#ifndef ZD1301_H
+#define ZD1301_H
+
+#include "dvb_usb.h"
+#include "zd1301_demod.h"
+#include "mt2060.h"
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+
+struct zd1301_dev {
+	#define BUF_LEN 8
+	u8 buf[BUF_LEN]; /* bulk USB control message */
+	struct dvb_usb_device *d;
+	struct zd1301_demod_platform_data demod_pdata;
+	struct mt2060_platform_data mt2060_pdata;
+	struct platform_device *platform_device_demod;
+	struct i2c_client *i2c_client_tuner;
+};
+
+#endif
-- 
http://palosaari.fi/

