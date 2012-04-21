Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s11.blu0.hotmail.com ([65.55.111.86]:8924 "EHLO
	blu0-omc2-s11.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab2DUA7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 20:59:10 -0400
Message-ID: <BLU0-SMTP38731E0DE15078213E2E535D8230@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media for 3.5] Add support for TBS-Tech ISDB-T Full Seg DTB08
Date: Fri, 20 Apr 2012 21:58:58 -0300
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver for TBS-Tech ISDB-T USB2.0 Receiver (DTB08 Full Seg).

The device used as a reference is described in the link
http://linuxtv.org/wiki/index.php/JH_Full_HD_Digital_TV_Receiver


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig     |   11 +
 drivers/media/dvb/dvb-usb/Makefile    |    3 +
 drivers/media/dvb/dvb-usb/tbs-dtb08.c |  451 +++++++++++++++++++++++++++++++++
 3 files changed, 465 insertions(+)
 create mode 100644 drivers/media/dvb/dvb-usb/tbs-dtb08.c

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index be1db75..ec7bb2b 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -413,6 +413,17 @@ config DVB_USB_MXL111SF
 	help
 	  Say Y here to support the MxL111SF USB2.0 DTV receiver.
 
+config DVB_USB_TBSDTB08
+	tristate "TBS-Tech ISDB-T Full Seg DTB08 USB2.0 support"
+	depends on DVB_USB
+	select DVB_MB86A20S
+	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
+	help
+	  Say Y here to support the TBS-Tech Full Seg DTB08 ISDB-T USB2.0
+	  receiver.
+
+	  The receiver is also known as JH Full HD Digital TV Receiver.
+
 config DVB_USB_RTL28XXU
 	tristate "Realtek RTL28xxU DVB USB support"
 	depends on DVB_USB && EXPERIMENTAL
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index b667ac3..a53ae54 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -107,6 +107,9 @@ obj-$(CONFIG_DVB_USB_MXL111SF) += dvb-usb-mxl111sf.o
 obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-demod.o
 obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-tuner.o
 
+dvb-usb-tbsdtb08-objs = tbs-dtb08.o tbs-dtb08-fe.o
+obj-$(CONFIG_DVB_USB_TBSDTB08) += dvb-usb-tbsdtb08.o
+
 dvb-usb-rtl28xxu-objs = rtl28xxu.o
 obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
 
diff --git a/drivers/media/dvb/dvb-usb/tbs-dtb08.c b/drivers/media/dvb/dvb-usb/tbs-dtb08.c
new file mode 100644
index 0000000..82c21de
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/tbs-dtb08.c
@@ -0,0 +1,451 @@
+/*
+ *   TBS-Tech ISDB-T Full Seg DTB08 device driver
+ *
+ *   Copyright (C) 2010-2012 Manoel Pinheiro <pinusdtv@hotmail.com>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+
+#define DVB_USB_LOG_PREFIX "tbs_dtb08"
+
+#include "dvb-usb.h"
+#include "tda18271.h"
+#include "tbs-dtb08-fe.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off module debugging (default:0).");
+
+#define dbg_info(format, args...)	do {	\
+	if (debug)				\
+		info(format, ## args);		\
+} while (0)
+
+#define	DEMOD_I2C_ADDR	0x20
+#define	TUNER_I2C_ADDR	0xc0
+
+#ifndef USB_PID_TBS_DTB08
+#define USB_PID_TBS_DTB08	0xdb08
+#endif
+
+#define USB_VID_TBS_734C	0x734c
+
+#define TBS_DTB08_LED_CONTROL	5
+
+#define FX2_IE_EX0	7
+#define FX2_EX0_ENABLE	1
+#define FX2_EX0_DISABLE	0
+#define FX2_I2CTL	6
+#define I2CTL_100Khz	0
+#define I2CTL_400Khz	1
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+static DEFINE_MUTEX(tbs_dtb08_usb_mutex);
+static int fx2_renum = -1;
+
+int tbs_dtb08_generic_read_addr(struct usb_device *udev, u8 req,
+				u16 addr, u8 *data, u16 len)
+{
+	int ret;
+
+	ret = usb_control_msg(udev,
+			      usb_rcvctrlpipe(udev, 0),
+			      req,
+			      USB_TYPE_VENDOR | USB_DIR_IN,
+			      addr, 0, data, len, 2000);
+	if (ret < 0)
+		err("%s: ret=%d", __func__, ret);
+
+	return ret;
+}
+
+int tbs_dtb08_generic_read(struct usb_device *udev,
+			   u8 req, u8 *data, u16 len)
+{
+	return tbs_dtb08_generic_read_addr(udev, req, 0, data, len);
+}
+
+int tbs_dtb08_generic_write_addr(struct usb_device *udev, u8 req,
+				 u16 addr, u8 *data, u16 len)
+{
+	int ret;
+
+	ret = usb_control_msg(udev,
+			      usb_sndctrlpipe(udev, 0),
+			      req,
+			      USB_TYPE_VENDOR | USB_DIR_OUT,
+			      addr, 0, data, len, 2000);
+	if (ret < 0)
+		err("%s: ret=%d", __func__, ret);
+
+	return ret;
+}
+
+int tbs_dtb08_generic_write(struct usb_device *udev,
+			    u8 req, u8 *data, u16 len)
+{
+	return tbs_dtb08_generic_write_addr(udev, req, 0, data, len);
+}
+
+static int tbs_dtb08_i2c_busy(struct usb_device *udev)
+{
+	u8 val;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		int ret = tbs_dtb08_generic_read(udev, 0x81, &val, 1);
+		if (ret >= 0 && val == 0)
+			return 0;
+		msleep(1);
+	}
+
+	return 1;
+}
+
+static int tbs_dtb08_i2c_read(struct usb_device *udev, u8 addr,
+			      u8 reg, u8 *data, u8 len)
+{
+	int ret;
+	u8 obuf[3];
+
+	if (len < 1) {
+		err("%s: len less than 1 bytes. Makes no sense.", __func__);
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&tbs_dtb08_usb_mutex);
+	ret = tbs_dtb08_i2c_busy(udev);
+	if (ret == 0) {
+		obuf[0] = len;
+		obuf[1] = addr;
+		obuf[2] = reg;
+
+		ret = tbs_dtb08_generic_write(udev, 0x90, &obuf[0], 3);
+		if (ret >= 0) {
+			ret = tbs_dtb08_i2c_busy(udev);
+			if (ret == 0)
+				ret = tbs_dtb08_generic_read(udev, 0x91,
+							     data, len);
+		}
+	}
+	mutex_unlock(&tbs_dtb08_usb_mutex);
+
+	return ret;
+}
+
+static int tbs_dtb08_i2c_write(struct usb_device *udev, u8 addr,
+			       u8 reg, u8 *data, u8 len)
+{
+	int i, ret;
+	u8 *buf;
+
+	if (len < 1) {
+		err("%s: len less than 1 bytes. Makes no sense.", __func__);
+		return -EOPNOTSUPP;
+	}
+	if (len > 61) {
+		err("%s: len more than 61 bytes. Not supported.", __func__);
+		return -EOPNOTSUPP;
+	}
+
+	buf = kmalloc(len + 3 , GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&tbs_dtb08_usb_mutex);
+
+	buf[0] = len + 2;
+	buf[1] = addr;
+	buf[2] = reg;
+
+	for (i = 0; i < len; i++)
+		buf[i+3] = data[i];
+
+	ret = tbs_dtb08_i2c_busy(udev);
+	if (ret < 0)
+		goto ret_err;
+
+	ret = tbs_dtb08_generic_write(udev, 0x80, buf, len + 3);
+
+ret_err:
+	kfree(buf);
+	mutex_unlock(&tbs_dtb08_usb_mutex);
+	return ret;
+}
+
+static int tbs_dtb08_send_cmd_8a(struct usb_device *udev, u8 val1, u8 val2)
+{
+	int ret;
+	u8 obuf[2] = { val1, val2 };
+
+	ret = tbs_dtb08_generic_write(udev, 0x8a, &obuf[0], 2);
+
+	return (ret < 0) ? ret : 0;
+}
+
+int tbs_dtb08_fx2_ie_ex0(struct usb_device *udev, u8 enable)
+{
+	return tbs_dtb08_send_cmd_8a(udev, FX2_IE_EX0, enable ? 1 : 0);
+}
+
+static int tbs_dtb08_led_control(struct usb_device *udev, int onoff)
+{
+	return tbs_dtb08_send_cmd_8a(udev, TBS_DTB08_LED_CONTROL,
+				     onoff ? 1 : 0);
+}
+
+int tbs_dtb08_fx2_i2ctl(struct usb_device *udev, u8 i2cfreq)
+{
+	return tbs_dtb08_send_cmd_8a(udev, FX2_I2CTL, i2cfreq);
+}
+
+static int tbs_dtb08_i2c_transfer(struct i2c_adapter *adap,
+				  struct i2c_msg msg[], int num)
+{
+	struct dvb_usb_device *dev = i2c_get_adapdata(adap);
+	int ret = 0;
+
+	dbg_info("%s: num=%02x, msg[0].addr=%02x, jiffies=%ld",
+		 __func__, num, msg[0].addr, jiffies);
+
+	if (!dev || !dev->udev)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	switch (num) {
+	case 2:
+		ret = tbs_dtb08_i2c_read(dev->udev, msg[0].addr, msg[0].buf[0],
+					 msg[1].buf, msg[1].len);
+		break;
+	case 1:
+		if (msg[0].flags == 0)
+			ret = tbs_dtb08_i2c_write(dev->udev, msg[0].addr,
+						  msg[0].buf[0],
+						  &msg[0].buf[1],
+						  msg[0].len - 1);
+		else
+			ret = tbs_dtb08_i2c_read(dev->udev, msg[0].addr,
+						 msg[0].buf[0],
+						 msg[0].buf, msg[0].len);
+		break;
+	default:
+		err("%s:num == %d, not supported!", __func__, num);
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	mutex_unlock(&dev->i2c_mutex);
+
+	return (ret < 0) ? ret : num;
+}
+
+static struct tda18271_std_map a20s_tda18271_config = {
+	.dvbt_6 = { .if_freq = 3300, .agc_mode = 3, .std = 4,
+		    .if_lvl = 7, .rfagc_top = 0x37, },
+};
+
+static struct tda18271_config tbs_dtb08_tda18271_config = {
+	.std_map = &a20s_tda18271_config,
+	.gate = TDA18271_GATE_DIGITAL,
+};
+
+static int tbs_dtb08_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	int ret;
+	struct dtb08_a20s_state *state = adap->fe_adap[0].priv;
+
+	if (fx2_renum < 0)
+		return -EINVAL;
+
+	if (adap == NULL || adap->fe_adap[0].fe == NULL)
+		return -ENODEV;
+
+	if (adap->fe_adap[0].fe->ops.tuner_ops.init != NULL)
+		return 0;
+
+	state->tuner_ctrl = true;
+	ret = dvb_attach(tda18271_attach, adap->fe_adap[0].fe,
+			 TUNER_I2C_ADDR, &adap->dev->i2c_adap,
+			 &tbs_dtb08_tda18271_config) == NULL ? -ENODEV : 0;
+	state->tuner_ctrl = false;
+	return ret;
+}
+
+static struct dtb08_a20s_reg_subreg_config dtb08_a20s_config_regs[] = {
+	{ 0x3C, 0x00, 0x38 },
+	{ 0x04, 0x00, 0x001e },
+	{ 0x04, 0x0E, 0x0032 },
+	{ 0x04, 0x15, 0x55 },
+	{ 0x04, 0x16, 0x00 },
+	{ 0x28, 0x20, 0x33dd00 },
+	{ 0x28, 0x6A, 0x0002f0 },
+	{ 0x28, 0x74, 0x0001f4 },
+	{ 0x50, 0xD5, 0x00 },
+	{ 0x50, 0xD6, 0x17 },
+	{ 0x50, 0xDC, 0x3fff },
+	{ 0x50, 0xDE, 0x3fff },
+	{ 0x50, 0xE0, 0x3fff }
+};
+
+static struct mb86a20s_config mb86a20s_cfg = {
+	.demod_address = DEMOD_I2C_ADDR,
+};
+
+static int tbs_dtb08_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	int ret;
+	struct dvb_usb_device *dev = adap->dev;
+	struct dtb08_a20s_state *state = adap->fe_adap[0].priv;
+
+	if (fx2_renum < 0)
+		return -EINVAL;
+
+	if (state == NULL) {
+		err("%s: adap->dev->priv == NULL!", __func__);
+		return -ENOMEM;
+	}
+
+	tbs_dtb08_fx2_ie_ex0(dev->udev, FX2_EX0_DISABLE);
+	tbs_dtb08_fx2_i2ctl(dev->udev, I2CTL_400Khz);
+
+	state->udev = dev->udev;
+	state->demod_addr = DEMOD_I2C_ADDR;
+	state->config_size = ARRAY_SIZE(dtb08_a20s_config_regs);
+	state->config_regs = dtb08_a20s_config_regs;
+	state->i2c_read = tbs_dtb08_i2c_read;
+	state->i2c_write = tbs_dtb08_i2c_write;
+	state->led_control = tbs_dtb08_led_control;
+
+	ret = dtb08_a20s_frontend_attach(state, adap, &mb86a20s_cfg);
+	if (ret != 0)
+		return ret;
+
+	if (tbs_dtb08_tuner_attach(adap) == 0) {
+		tbs_dtb08_fx2_ie_ex0(dev->udev, FX2_EX0_ENABLE);
+		return 0;
+	}
+
+	dvb_frontend_detach(adap->fe_adap[0].fe);
+	adap->fe_adap[0].fe = NULL;
+
+	return -ENODEV;
+}
+
+static int tbs_dtb08_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	return tbs_dtb08_led_control(adap->dev->udev, onoff);
+}
+
+static u32 tbs_dtb08_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm tbs_dtb08_i2c_algo = {
+	.master_xfer = tbs_dtb08_i2c_transfer,
+	.functionality = tbs_dtb08_i2c_func,
+};
+
+static struct usb_device_id tbs_dtb08_table[] = {
+	{ USB_DEVICE(USB_VID_TBS_734C, USB_PID_TBS_DTB08) },
+	{ }	/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, tbs_dtb08_table);
+
+static struct dvb_usb_device_properties tbs_dtb08_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = CYPRESS_FX2,
+	.firmware = "dvb-usb-tbs-dtb08.fw",
+	.no_reconnect = 1,
+	.num_adapters = 1,
+	.adapter = {{
+		.num_frontends = 1,
+		.fe = { {
+			.size_of_priv = sizeof(struct dtb08_a20s_state),
+			.streaming_ctrl = tbs_dtb08_streaming_ctrl,
+			.frontend_attach = tbs_dtb08_frontend_attach,
+			.tuner_attach = tbs_dtb08_tuner_attach,
+			.stream = {
+				.type = USB_BULK,
+				.count = 8,
+				.endpoint = 0x82,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			},
+		} } }
+	},
+
+	.i2c_algo = &tbs_dtb08_i2c_algo,
+
+	.num_device_descs = 1,
+	.devices = {
+		{
+			.name = "TBS-Tech ISDB-T USB 2.0 (DTB08)",
+			.cold_ids = { &tbs_dtb08_table[0], NULL },
+			.warm_ids = { NULL },
+		},
+	},
+};
+
+static int tbs_dtb08_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	int ret;
+	u8 val;
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	dbg_info("%s: %d, num_altsetting=%d", __func__,
+		 intf->cur_altsetting->desc.bInterfaceNumber,
+		 intf->num_altsetting);
+
+	fx2_renum = tbs_dtb08_generic_read(udev, 0x81, &val, 1);
+
+	ret = dvb_usb_device_init(intf, &tbs_dtb08_properties,
+				  THIS_MODULE, NULL, adapter_nr);
+
+	if (ret != 0) {
+		err("%s: failed err=%d", __func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void tbs_dtb08_usb_disconnect(struct usb_interface *intf)
+{
+	fx2_renum = -1;
+	dvb_usb_device_exit(intf);
+}
+
+static struct usb_driver tbs_dtb08_driver = {
+	.name = "dvb-usb-tbsdtb08",
+	.probe = tbs_dtb08_probe,
+	.disconnect = tbs_dtb08_usb_disconnect,
+	.id_table = tbs_dtb08_table,
+};
+
+module_usb_driver(tbs_dtb08_driver);
+
+MODULE_AUTHOR("Manoel Pinheiro <pinusdtv@hotmail.com>");
+MODULE_DESCRIPTION("Driver for TBS-Tech ISDB-T USB2.0 Receiver (DTB08 Full Seg)");
+MODULE_LICENSE("GPL");
-- 
1.7.10

