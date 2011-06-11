Return-path: <mchehab@pedra>
Received: from blu0-omc2-s13.blu0.hotmail.com ([65.55.111.88]:41767 "EHLO
	blu0-omc2-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1FKI4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 04:56:21 -0400
Message-ID: <BLU0-SMTP648D1A975AB53C669ADA20D8670@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] [media] Add support for TBS-Tech ISDB-T Full Seg DTB08
Date: Sat, 11 Jun 2011 05:56:04 -0300
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Need patches:
[PATCH 1/5] [media] mb86a20s: add i2c_gate_ctrl
[PATCH 2/5] [media] mb86a20s: Add support for TBS-Tech ISDB-T Full Seg DTB08
[PATCH 3/5] [media] Add Keytable for tbs_dtb08 remote controller
[PATCH 4/5] [media] Add support for TBS-Tech ISDB-T Full Seg DTB08


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/dvb-usb/tbs-dtb08.c |  576 +++++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/tbs-dtb08.h |   30 ++
 2 files changed, 606 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/tbs-dtb08.c
 create mode 100644 drivers/media/dvb/dvb-usb/tbs-dtb08.h

diff --git a/drivers/media/dvb/dvb-usb/tbs-dtb08.c b/drivers/media/dvb/dvb-usb/tbs-dtb08.c
new file mode 100644
index 0000000..b654efd
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/tbs-dtb08.c
@@ -0,0 +1,576 @@
+/*
+ *  TBS-Tech ISDB-T Full Seg DTB08 device driver
+ *
+ *  Copyright (C) 2010-2011 Manoel Pinheiro <pinusdtv@pdtv.cjb.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/dvb/version.h>
+
+#include "tbs-dtb08.h"
+#include "tda18271.h"
+#include "mb86a20s.h"
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
+#define TBS_DTB08_WRITE_MSG	0
+#define TBS_DTB08_READ_MSG	1
+
+#define TBS_DTB08_RC_QUERY 	0xb8
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
+
+static int fx2_renum = 0;
+static unsigned char demod_ok = 0;
+
+static int tbs_dtb08_op_rw(struct usb_device *udev, u8 request, u16 value,
+			u16 index, u8 *data, u16 len, int flags)
+{
+	int ret;
+	uint pipe;
+	u8 request_type;
+	u8 buf[64];
+
+	if ((ret = mutex_lock_interruptible(&tbs_dtb08_usb_mutex)))
+		return -EAGAIN;
+
+	if (len > 64)
+		len = 64;
+
+	pipe = (flags == TBS_DTB08_READ_MSG) ? usb_rcvctrlpipe(udev, 0)
+		: usb_sndctrlpipe(udev, 0);
+	request_type = (flags == TBS_DTB08_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
+
+	if (flags == TBS_DTB08_WRITE_MSG)
+		memcpy(buf, data, len);
+
+	ret = usb_control_msg(udev, pipe, request, request_type | USB_TYPE_VENDOR,
+				value, index , buf, len, 2000);
+
+	if (flags == TBS_DTB08_READ_MSG)
+		memcpy(data, buf, len);
+
+	if (ret < 0)
+		printk(KERN_ERR "tbs_dtb08.c: %s ret=%d\n", __func__, ret);
+
+	mutex_unlock(&tbs_dtb08_usb_mutex);
+
+	return ret;
+}
+
+static int tbs_dtb08_i2c_reg_read(struct usb_device *udev, u8 addr,
+				  u8 reg, u8 *data, u8 len)
+{
+	int i, ret;
+	u8 val, buf[64];
+
+	if (len > 64)
+		len = 64;
+	if (len < 1)
+		return -EINVAL;
+
+	for (i = 0; i < 5; i++) {
+		ret = tbs_dtb08_op_rw(udev, 0x81, 0, 0, &val, 1, TBS_DTB08_READ_MSG);
+		if (ret == 0 && val == 0) break;
+		msleep(1);
+	}
+
+	buf[0] = len;
+	buf[1] = addr;
+	buf[2] = reg;
+
+	ret = tbs_dtb08_op_rw(udev, 0x90, 0, 0, buf, 3, TBS_DTB08_WRITE_MSG);
+
+	for (i = 0; i < 5; i++) {
+		ret = tbs_dtb08_op_rw(udev, 0x81, 0, 0, &val, 1, TBS_DTB08_READ_MSG);
+		if (ret == 0 && val == 0) break;
+		msleep(1);
+	}
+
+	memset(&buf, 0, sizeof(buf));
+
+	ret = tbs_dtb08_op_rw(udev, 0x91, 0, 0, buf, len, TBS_DTB08_READ_MSG);
+	memcpy(data, buf, len);
+
+	return ret;
+}
+
+static int tbs_dtb08_i2c_reg_write(struct usb_device *udev, u8 addr, u8 reg,
+				   u8 *data, u8 len)
+{
+	int i, ret;
+	u8 buf[64];
+
+	if (len > 62)
+		len = 62;
+	if (len < 1)
+		return -EINVAL;
+
+	buf[0] = len + 2;
+	buf[1] = addr;
+	buf[2] = reg;
+
+	memcpy(&buf[3], data, len);
+
+	for (i = 0; i < 5; i++) {
+		ret = tbs_dtb08_op_rw(udev, 0x81, 0, 0, &reg, 1, TBS_DTB08_READ_MSG);
+		if (ret == 0 && reg == 0) break;
+		msleep(1);
+	}
+
+	ret = tbs_dtb08_op_rw(udev, 0x80, 0, 0, buf, len + 3, TBS_DTB08_WRITE_MSG);
+
+	return ret;
+}
+
+static int tbs_dtb08_cmd_8a_write(struct usb_device *udev, u8 val1, u8 val2)
+{
+	u8 buf[2] = { val1, val2 };
+	int ret;
+
+	ret = tbs_dtb08_op_rw(udev, 0x8a, 0, 0, buf, 2, TBS_DTB08_WRITE_MSG);
+
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
+}
+
+static int tbs_dtb08_led_control(struct i2c_adapter *adap, int onoff)
+{
+	struct dvb_usb_device *dev = i2c_get_adapdata(adap);
+
+	return tbs_dtb08_cmd_8a_write(dev->udev, TBS_DTB08_LED_CONTROL, onoff ? 1: 0);
+}
+
+static int tbs_dtb08_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+		int num)
+{
+	struct dvb_usb_device *dev = i2c_get_adapdata(adap);
+	int ii, ret = 0;
+
+	if (!dev || !dev->udev)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	switch (num) {
+	case 2:
+		if ((msg[0].addr == DEMOD_I2C_ADDR || msg[0].addr == TUNER_I2C_ADDR) &&
+			msg[0].addr == msg[1].addr &&  msg[0].flags == 0 &&
+			msg[1].flags == I2C_M_RD && msg[0].len == 1 && msg[1].len > 0) {
+			ret = tbs_dtb08_i2c_reg_read(dev->udev, msg[0].addr,
+					msg[0].buf[0],msg[1].buf, msg[1].len);
+		}
+		else {
+			printk(KERN_ERR "tbs_dtb08.c: %s num==2, "
+				"msg[0].addr==%02x, msg[0].flags==%d, msg[0].len==%d "
+				"msg[1].addr==%02x, msg[1].flags==%d, not suported!\n",
+				__func__, msg[0].addr, msg[0].flags, msg[0].len,
+				msg[1].addr, msg[1].flags);
+			ret = -EINVAL;
+		}
+		break;
+	case 1:
+		switch (msg[0].addr) {
+		case DEMOD_I2C_ADDR:
+		case TUNER_I2C_ADDR:
+			ii = msg[0].len - 1;
+			if (ii < 0) {
+				ret = -EINVAL;
+				break;
+			}
+			else if (ii > 63) {
+				ii = 63;
+			}
+
+			if (msg[0].flags == 0) {
+				ret = tbs_dtb08_i2c_reg_write(
+					dev->udev, msg[0].addr,
+					msg[0].buf[0],
+					&msg[0].buf[1], ii);
+			} else {
+				ret = tbs_dtb08_i2c_reg_read(
+					dev->udev, msg[0].addr,
+					msg[0].buf[0],
+					msg[0].buf, msg[0].len);
+			}
+			break;
+		default:
+			printk(KERN_ERR "tbs_dtb08.c: %s num==1, "
+				"addr==%02x, not suported!\n",
+				__func__, msg[0].addr);
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		printk(KERN_ERR "tbs_dtb08.c: %s num == %d, "
+			"not suported!\n", __func__, num);
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&dev->i2c_mutex);
+
+	if (ret < 0)
+		return ret;
+	else
+		return num;
+}
+
+static int tbs_dtb08_rc_query(struct dvb_usb_device *d)
+{
+	u8 buf[6];
+
+	memset (buf, 0, sizeof (buf));
+
+	tbs_dtb08_op_rw(d->udev, TBS_DTB08_RC_QUERY, 0, 0, buf,
+			5, TBS_DTB08_READ_MSG);
+
+	if (buf[1] != (u8)~buf[2] || buf[3] != (u8)~buf[4])
+		return 0;
+
+	rc_keydown(d->rc_dev, (u16)buf[1] << 8 | buf[3], 0);
+		   
+	return 0;
+}
+
+static struct tda18271_std_map mb86a20s_tda18271_config = {
+	.dvbt_6   = { .if_freq = 3300, .agc_mode = 3, .std = 4,
+		      .if_lvl = 7, .rfagc_top = 0x37, },
+};
+
+static struct tda18271_config tbs_dtb08_tda18271_config = {
+	.std_map = &mb86a20s_tda18271_config,
+	.gate = TDA18271_GATE_DIGITAL,
+};
+
+static int tbs_dtb08_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	int ret;
+
+	if (adap == NULL || adap->fe == NULL)
+		return -ENODEV;
+
+	if (adap->fe->ops.tuner_ops.init != NULL)
+		return 0;
+
+	ret = dvb_attach(tda18271_attach, adap->fe, TUNER_I2C_ADDR,
+			 &adap->dev->i2c_adap,
+			&tbs_dtb08_tda18271_config) == NULL ? -ENODEV : 0;
+
+	return ret;
+}
+
+static struct mb86a20s_config_regs_val mb86a20s_config_regs[] = {
+	{ REG3C_IDCFG, 0x38 },
+	{ REG0400_IDCFG, 0x001e },
+	{ REG040E_IDCFG, 0x0032 },
+	{ REG0415_IDCFG, 0x55 },
+	{ REG0416_IDCFG, 0x00 },
+	{ REG2820_IDCFG, 0x33dd00 },
+	{ REG286A_IDCFG, 0x0002f0 },
+	{ REG2874_IDCFG, 0x0001f4 },
+	{ REG50D5_IDCFG, 0x00 },
+	{ REG50D6_IDCFG, 0x17 },
+	{ REG50B2_IDCFG, 0x3fff },
+	{ REG50B4_IDCFG, 0x3fff },
+	{ REG50B6_IDCFG, 0x3fff },
+	{ REG50DC_IDCFG, 0x3fff },
+	{ REG50DE_IDCFG, 0x3fff },
+	{ REG50E0_IDCFG, 0x3fff },
+};
+
+static struct mb86a20s_config mb86a20s_cfg = {
+	.demod_address = DEMOD_I2C_ADDR,
+	.config_regs_size = ARRAY_SIZE(mb86a20s_config_regs),
+	.config_regs = mb86a20s_config_regs,
+};
+
+static int tbs_dtb08_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct usb_device *udev = adap->dev->udev;
+
+	printk(KERN_INFO"tbs_dtb08.c: tbs_dtb08_frontend_attach(), "
+		"demod_ok=%d, fx2_renum=%d\n", demod_ok, fx2_renum);
+
+	if (adap->dev->props.adapter->tuner_attach == &tbs_dtb08_tuner_attach) {
+		if (demod_ok) {
+			tbs_dtb08_cmd_8a_write(udev, FX2_IE_EX0, FX2_EX0_DISABLE);
+			tbs_dtb08_cmd_8a_write(udev, FX2_I2CTL, I2CTL_400Khz);
+			adap->fe = dvb_attach(mb86a20s_attach, &mb86a20s_cfg,
+					      &adap->dev->i2c_adap);
+			if (adap->fe) {
+				if (tbs_dtb08_tuner_attach(adap) == 0) {
+					tbs_dtb08_cmd_8a_write(udev, FX2_IE_EX0,
+							       FX2_EX0_ENABLE);
+					return 0;
+				}
+				dvb_frontend_detach(adap->fe);
+				adap->fe = NULL;
+			}
+			demod_ok = 0;
+		}
+	}
+
+	return -EIO;
+}
+
+static int tbs_dtb08_download_firmware(struct usb_device *dev,
+				       const struct firmware *fw)
+{
+	int i, n, count;
+	u8 buf[64];
+	u8 val;
+
+	demod_ok = 0;
+
+ 	if (dev == NULL || fw == NULL || fw->size <= 0) {
+		printk(KERN_ERR"tbs_dtb08.c: tbs_dtb08_download_firmware(), "
+			"invalid parameters\n");
+		return -EINVAL;
+	}
+
+	/* stop the CPU */
+	val = 1;
+	tbs_dtb08_op_rw(dev, 0xa0, 0xe600, 0, &val, 1, TBS_DTB08_WRITE_MSG);
+
+	fx2_renum = 1;
+	for (n = 0; n < fw->size; n += 0x40) {
+		count = fw->size - n;
+		if (count > 0x40)
+			count = 0x40;
+
+		if (fx2_renum) {
+			tbs_dtb08_op_rw(dev, 0xa0, n, 0, buf, count,
+					TBS_DTB08_READ_MSG);
+			for (i = 0; i < count; i++) {
+				if (buf[i] != fw->data[n+i]) {
+					fx2_renum = 0;
+					break;
+				}
+			}
+			if (fx2_renum) continue;
+		}
+		memcpy(buf, fw->data + n, count);
+		if (tbs_dtb08_op_rw(dev, 0xa0, n, 0, buf, count,
+				TBS_DTB08_WRITE_MSG) != count) {
+			printk(KERN_ERR "tbs_dtb08.c: %s addr=%04x: "
+					"error while transferring firmware\n",
+					__func__, n);
+			return -EINVAL;
+		}
+	}
+
+	/* restart the CPU */
+	val = 0;
+	if (tbs_dtb08_op_rw(dev, 0xa0, 0xe600, 0, &val, 1,
+			    TBS_DTB08_WRITE_MSG) != 1) {
+		printk(KERN_ERR "tbs_dtb08.c: %s could not restart the "
+				"USB controller CPU.\n", __func__);
+		return -EINVAL;
+	}
+
+	if ( !fx2_renum ) { /* ReEnumeration */
+		return -EINVAL;
+	}
+
+	msleep(200);
+
+	if (tbs_dtb08_i2c_reg_read(dev, DEMOD_I2C_ADDR, 0, &demod_ok, 1) < 0)
+		goto ret_err;
+	val = 0x87;
+	if (tbs_dtb08_i2c_reg_write(dev, DEMOD_I2C_ADDR, 0x28, &val, 1) < 0)
+		goto ret_err;
+	val = 0;
+	if (tbs_dtb08_i2c_reg_read(dev, DEMOD_I2C_ADDR, 0x28, &val, 1) < 0)
+		goto ret_err;
+	if (tbs_dtb08_cmd_8a_write(dev, FX2_IE_EX0, FX2_EX0_ENABLE) < 0)
+		goto ret_err;
+	if (tbs_dtb08_op_rw(dev, TBS_DTB08_RC_QUERY, 0, 0, buf, 0x05,
+			    TBS_DTB08_READ_MSG) < 0)
+		goto ret_err;
+
+	return 0;
+
+ret_err:
+	printk(KERN_ERR "tbs_dtb08.c: %s failed!\n", __func__);
+	return -EINVAL;
+}
+
+static int tbs_dtb08_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	return tbs_dtb08_led_control(&adap->dev->i2c_adap, onoff);
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
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.download_firmware = tbs_dtb08_download_firmware,
+	.firmware = "tbs-dtb08.fw",
+	.no_reconnect = 1,
+	.size_of_priv = 0,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.caps = 0,
+			.streaming_ctrl = tbs_dtb08_streaming_ctrl,
+			.frontend_attach = tbs_dtb08_frontend_attach,
+			.tuner_attach = tbs_dtb08_tuner_attach,
+			.stream = {
+				.type = USB_BULK,
+				.count = 10,
+				.endpoint = 0x82,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			},
+		}
+	},
+
+	.rc.core = {
+		.rc_codes         = RC_MAP_TBS_DTB08,
+		.protocol         = RC_TYPE_OTHER,
+		.module_name      = "tbs_dtb08",
+		.rc_query         = tbs_dtb08_rc_query,
+		.rc_interval      = 200,
+	},
+
+	.i2c_algo = &tbs_dtb08_i2c_algo,
+	.generic_bulk_ctrl_endpoint = 0x81,
+
+	.num_device_descs = 1,
+	.devices = {
+		{
+			.name = "TBS-Tech ISDB-T Full Seg USB 2.0 (DTB08)",
+			.cold_ids = { &tbs_dtb08_table[0], NULL },
+			.warm_ids = { NULL },
+		},
+		{ NULL },
+	}
+};
+
+static int tbs_dtb08_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	struct dvb_usb_device *d = NULL;
+	int ret;
+
+	printk(KERN_INFO"tbs_dtb08.c: probe interface:%d, num_altsetting=%d\n",
+	       intf->cur_altsetting->desc.bInterfaceNumber, intf->num_altsetting);
+
+	ret = dvb_usb_device_init(intf, &tbs_dtb08_properties,
+			THIS_MODULE, &d, adapter_nr);
+
+	if (ret != 0) {
+		printk(KERN_ERR"tbs_dtb08.c: %s failed err=%d\n", __func__, ret);
+		return ret;
+	}
+
+	if (d) {
+		int n;
+		for (n = 0; n < d->props.num_adapters; n++) {
+			struct dvb_usb_adapter *adap = &d->adapter[n];
+			if (adap && adap->fe) {
+			  ret++;
+			}
+		}
+	}
+
+	if (ret == 0) {
+		dvb_usb_device_exit(intf);
+		return -1;
+	}
+	else
+		return 0;
+}
+
+static void tbs_dtb08_usb_device_exit(struct usb_interface *intf)
+{
+	demod_ok = 0;
+	msleep(500);
+	dvb_usb_device_exit(intf);
+}
+
+static struct usb_driver tbs_dtb08_driver = {
+	.name = "dvb-usb-tbsdtb08",
+	.probe = tbs_dtb08_probe,
+	.disconnect = tbs_dtb08_usb_device_exit,
+	.id_table = tbs_dtb08_table,
+};
+
+static int __init tbs_dtb08_module_init(void)
+{
+	int ret =  usb_register(&tbs_dtb08_driver);
+
+	if (ret)
+		printk(KERN_ERR "usb_register failed. Error number %d\n", ret);
+
+	return ret;
+}
+
+static void __exit tbs_dtb08_module_exit(void)
+{
+	/* deregister this driver from the USB subsystem */
+	usb_deregister(&tbs_dtb08_driver);
+}
+
+module_init(tbs_dtb08_module_init);
+module_exit(tbs_dtb08_module_exit);
+
+MODULE_AUTHOR("Manoel Pinheiro <pinusdtv@pdtv.cjb.net>");
+MODULE_DESCRIPTION("Driver for TBS-Tech ISDB-T Full Seg DTB08 Receiver");
+MODULE_VERSION("0.5.2");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/tbs-dtb08.h b/drivers/media/dvb/dvb-usb/tbs-dtb08.h
new file mode 100644
index 0000000..2e25485
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/tbs-dtb08.h
@@ -0,0 +1,30 @@
+/*
+ *  TBS-Tech ISDB-T Full Seg DTB08 device driver
+ *
+ *  Copyright (C) 2010-2011 Manoel Pinheiro <pinusdtv@pdtv.cjb.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#ifndef _TBS_DTB08_H_
+#define _TBS_DTB08_H_
+
+#define DVB_USB_LOG_PREFIX "tbs_dtb08"
+
+#include "dvb-usb.h"
+
+#define deb_xfer(args...) dprintk(dvb_usb_tbsqbox_debug, 0x02, args)
+
+#endif /* _TBS_DTB08_H_ */
-- 
1.7.3.4

