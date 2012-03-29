Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s10.blu0.hotmail.com ([65.55.111.85]:20665 "EHLO
	blu0-omc2-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760318Ab2C2XYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 19:24:32 -0400
Message-ID: <BLU0-SMTP2569B8FEAF608970C7A44B1D8480@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: mchehab@redhat.com, linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: [media next v3.4] Add support for TBS-Tech ISDB-T Full Seg DTB08
Date: Thu, 29 Mar 2012 20:24:20 -0300
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver for TBS-Tech ISDB-T USB2.0 Receiver (DTB08 Full Seg).

The device used as a reference is described in the link
http://linuxtv.org/wiki/index.php/JH_Full_HD_Digital_TV_Receiver


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig     |    8 +
 drivers/media/dvb/dvb-usb/Makefile    |    3 +
 drivers/media/dvb/dvb-usb/tbs-dtb08.c | 1167 +++++++++++++++++++++++++++++++++
 3 files changed, 1178 insertions(+)
 create mode 100644 drivers/media/dvb/dvb-usb/tbs-dtb08.c

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 63bf456..63a794d 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -422,3 +422,11 @@ config DVB_USB_RTL28XXU
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
+
+config DVB_USB_TBSDTB08
+	tristate "TBS-Tech ISDB-T Full Seg DTB08 USB2.0 support"
+	depends on DVB_USB
+	select DVB_MB86A20S
+	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
+	help
+	  Say Y here to support the TBS-Tech Full Seg DTB08 ISDB-T USB2.0 receivers
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index b76acb5..051756c 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -110,6 +110,9 @@ obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-tuner.o
 dvb-usb-rtl28xxu-objs = rtl28xxu.o
 obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
 
+dvb-usb-tbsdtb08-objs = tbs-dtb08.o
+obj-$(CONFIG_DVB_USB_TBSDTB08) += dvb-usb-tbsdtb08.o
+
 ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends/
 # due to tuner-xc3028
diff --git a/drivers/media/dvb/dvb-usb/tbs-dtb08.c b/drivers/media/dvb/dvb-usb/tbs-dtb08.c
new file mode 100644
index 0000000..f909312
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/tbs-dtb08.c
@@ -0,0 +1,1167 @@
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
+#include "mb86a20s.h"
+
+static int debug = 0;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off module debugging (default:0).");
+
+#define dbg_info(format, args...)	do {	\
+	if (debug)				\
+		info(format, ## args);		\
+} while(0)
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
+#define TBS_DTB08_GET_IR_CODE	0xb8
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
+static int fw_ok = 0;
+
+struct mb86a20s_reg_subreg_config {
+	u8 reg;
+	u8 subreg;
+	u32 val;
+};
+
+struct mb86a20s_state {
+	struct usb_device *udev;
+	int demod_addr;
+	u32 current_frequency;
+	fe_status_t status;
+	u16 snr;
+	u16 strength;
+	unsigned long next_snr_check;
+	unsigned long next_strength_check;
+	unsigned long next_set_frontend_check;
+	unsigned long next_status_check;
+	int config_size;
+	struct mb86a20s_reg_subreg_config *config_regs;
+	bool need_init;
+	bool tuner_ctrl;
+};
+
+struct mb86a20s_reg_subreg_val {
+	u8 reg;
+	u8 subreg;
+	u8 type;	/* 0=8 bits wo/sub, 1=8 bits w/sub
+			 * 2=16 bits wo/sub, 3=16 bits w/sub, 4=24 bits */
+	u32 val;
+};
+
+static struct mb86a20s_reg_subreg_val mb86a20s_regs_val[] = {
+	{ 0x70, 0x00, 0x00, 0x0f },
+	{ 0x70, 0x00, 0x00, 0xff },
+	{ 0x08, 0x00, 0x00, 0x01 },
+	{ 0x09, 0x00, 0x00, 0x3e },
+	{ 0x50, 0xd1, 0x01, 0x22 },
+	{ 0x39, 0x00, 0x00, 0x01 },
+	{ 0x71, 0x00, 0x00, 0x00 },
+	{ 0x28, 0x2a, 0x04, 0xff80 },
+	{ 0x28, 0x20, 0x04, 0x33dfa9 },
+	{ 0x28, 0x22, 0x04, 0x1ff0 },
+	{ 0x3b, 0x00, 0x00, 0x21 },
+	{ 0x3c, 0x00, 0x00, 0x3a },
+	{ 0x01, 0x00, 0x00, 0x0d },
+	{ 0x04, 0x08, 0x01, 0x05 },
+	{ 0x04, 0x0e, 0x03, 0x0014 },
+	{ 0x04, 0x0b, 0x01, 0x8c },
+	{ 0x04, 0x00, 0x03, 0x0007 },
+	{ 0x04, 0x02, 0x03, 0x0fa0 },
+	{ 0x04, 0x09, 0x01, 0x00 },
+	{ 0x04, 0x0a, 0x01, 0xff },
+	{ 0x04, 0x27, 0x01, 0x64 },
+	{ 0x04, 0x28, 0x01, 0x00 },
+	{ 0x04, 0x1e, 0x01, 0xff },
+	{ 0x04, 0x29, 0x01, 0x0a },
+	{ 0x04, 0x32, 0x01, 0x0a },
+	{ 0x04, 0x14, 0x01, 0x02 },
+	{ 0x04, 0x04, 0x03, 0x0022 },
+	{ 0x04, 0x06, 0x03, 0x0ed8 },
+	{ 0x04, 0x12, 0x01, 0x00 },
+	{ 0x04, 0x13, 0x01, 0xff },
+	{ 0x04, 0x15, 0x01, 0x4e },
+	{ 0x04, 0x16, 0x01, 0x20 },
+	{ 0x52, 0x00, 0x00, 0x01 },
+	{ 0x50, 0xa7, 0x04, 0xffff },
+	{ 0x50, 0xaa, 0x04, 0xffff },
+	{ 0x50, 0xad, 0x04, 0xffff },
+	{ 0x5e, 0x00, 0x00, 0x07 },
+	{ 0x50, 0xdc, 0x03, 0x01f4 },
+	{ 0x50, 0xde, 0x03, 0x01f4 },
+	{ 0x50, 0xe0, 0x03, 0x01f4 },
+	{ 0x50, 0xb0, 0x01, 0x07 },
+	{ 0x50, 0xb2, 0x03, 0xffff },
+	{ 0x50, 0xb4, 0x03, 0xffff },
+	{ 0x50, 0xb6, 0x03, 0xffff },
+	{ 0x50, 0x50, 0x01, 0x02 },
+	{ 0x50, 0x51, 0x01, 0x04 },
+	{ 0x45, 0x00, 0x00, 0x04 },
+	{ 0x48, 0x00, 0x00, 0x04 },
+	{ 0x50, 0xd5, 0x01, 0x01 },
+	{ 0x50, 0xd6, 0x01, 0x1f },
+	{ 0x50, 0xd2, 0x01, 0x03 },
+	{ 0x50, 0xd7, 0x01, 0x3f },
+	{ 0x28, 0x74, 0x04, 0x0040 },
+	{ 0x28, 0x46, 0x04, 0x2c0c },
+	{ 0x04, 0x40, 0x01, 0x01 },
+	{ 0x28, 0x00, 0x01, 0x10 },
+	{ 0x28, 0x05, 0x01, 0x02 },
+	{ 0x1c, 0x00, 0x00, 0x01 },
+	{ 0x28, 0x06, 0x04, 0x0003 },
+	{ 0x28, 0x07, 0x04, 0x000d },
+	{ 0x28, 0x08, 0x04, 0x0002 },
+	{ 0x28, 0x09, 0x04, 0x0001 },
+	{ 0x28, 0x0a, 0x04, 0x0021 },
+	{ 0x28, 0x0b, 0x04, 0x0029 },
+	{ 0x28, 0x0c, 0x04, 0x0016 },
+	{ 0x28, 0x0d, 0x04, 0x0031 },
+	{ 0x28, 0x0e, 0x04, 0x000e },
+	{ 0x28, 0x0f, 0x04, 0x004e },
+	{ 0x28, 0x10, 0x04, 0x0046 },
+	{ 0x28, 0x11, 0x04, 0x000f },
+	{ 0x28, 0x12, 0x04, 0x0056 },
+	{ 0x28, 0x13, 0x04, 0x0035 },
+	{ 0x28, 0x14, 0x04, 0x01be },
+	{ 0x28, 0x15, 0x04, 0x0184 },
+	{ 0x28, 0x16, 0x04, 0x03ee },
+	{ 0x28, 0x17, 0x04, 0x0098 },
+	{ 0x28, 0x18, 0x04, 0x009f },
+	{ 0x28, 0x19, 0x04, 0x07b2 },
+	{ 0x28, 0x1a, 0x04, 0x06c2 },
+	{ 0x28, 0x1b, 0x04, 0x074a },
+	{ 0x28, 0x1c, 0x04, 0x01bc },
+	{ 0x28, 0x1d, 0x04, 0x04ba },
+	{ 0x28, 0x1e, 0x04, 0x0614 },
+	{ 0x50, 0x1e, 0x01, 0x5d },
+	{ 0x50, 0x22, 0x01, 0x00 },
+	{ 0x50, 0x23, 0x01, 0xc8 },
+	{ 0x50, 0x24, 0x01, 0x00 },
+	{ 0x50, 0x25, 0x01, 0xf0 },
+	{ 0x50, 0x26, 0x01, 0x00 },
+	{ 0x50, 0x27, 0x01, 0xc3 },
+	{ 0x50, 0x39, 0x01, 0x02 },
+	{ 0x28, 0x6a, 0x04, 0x0000 }
+};
+
+static u8 mb86a20s_soft_reset[] = {
+	0x70, 0xf0, 0x70, 0xff, 0x08, 0x01, 0x08, 0x00
+};
+
+static int tbs_dtb08_generic_read_addr(struct usb_device *udev, u8 req,
+				       u16 addr, u8 *data, u16 len)
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
+inline int tbs_dtb08_generic_read(struct usb_device *udev,
+				  u8 req, u8 *data, u16 len)
+{
+	return tbs_dtb08_generic_read_addr(udev, req, 0, data, len);
+}
+
+static int tbs_dtb08_generic_write_addr(struct usb_device *udev, u8 req,
+					u16 addr, u8 *data, u16 len)
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
+inline int tbs_dtb08_generic_write(struct usb_device *udev,
+				   u8 req, u8 *data, u16 len)
+{
+	return tbs_dtb08_generic_write_addr(udev, req, 0, data, len);
+}
+
+inline int tbs_dtb08_ir_code_read(struct usb_device *udev, u8 *data, u16 len)
+{
+	return tbs_dtb08_generic_read_addr(udev, TBS_DTB08_GET_IR_CODE, 0, data, len);
+}
+
+static int tbs_dtb08_i2c_busy(struct usb_device *udev)
+{
+	u8 val;
+	int i, ret;
+
+	for (i = 0; i < 10; i++) {
+		ret = tbs_dtb08_generic_read(udev, 0x81, &val, 1);
+		if (ret >= 0 && val == 0) return 0;
+		msleep(1);
+	}
+
+	return -1;
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
+		return -EINVAL;
+	}
+
+	mutex_lock(&tbs_dtb08_usb_mutex);
+	ret = tbs_dtb08_i2c_busy(udev);
+	if (ret == 0)
+	{
+		obuf[0] = len;
+		obuf[1] = addr;
+		obuf[2] = reg;
+
+		ret = tbs_dtb08_generic_write(udev, 0x90, &obuf[0], 3);
+		if (ret >= 0) {
+			ret = tbs_dtb08_i2c_busy(udev);
+			if (ret == 0)
+				ret = tbs_dtb08_generic_read(udev, 0x91, data, len);
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
+		return -EINVAL;
+	}
+	if (len > 61) {
+		err("%s: len more than 61 bytes. Not supported.", __func__);
+		return -EINVAL;
+	}
+
+	buf = kmalloc(64 , GFP_KERNEL);
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
+inline int tbs_dtb08_fx2_ie_ex0(struct usb_device *udev, u8 enable)
+{
+	return tbs_dtb08_send_cmd_8a(udev, FX2_IE_EX0, enable ? 1 : 0);
+}
+
+inline int tbs_dtb08_led_control(struct usb_device *udev, int onoff)
+{
+	return tbs_dtb08_send_cmd_8a(udev, TBS_DTB08_LED_CONTROL,
+				     onoff ? 1 : 0);
+}
+
+inline int tbs_dtb08_fx2_i2ctl(struct usb_device *udev, u8 i2cfreq)
+{
+	return tbs_dtb08_send_cmd_8a(udev, FX2_I2CTL, i2cfreq);
+}
+
+static int tbs_dtb08_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+		int num)
+{
+	struct dvb_usb_device *dev = i2c_get_adapdata(adap);
+	int ii, ret = 0;
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
+		if ((msg[0].addr == DEMOD_I2C_ADDR || msg[0].addr == TUNER_I2C_ADDR) &&
+			msg[0].addr == msg[1].addr &&  msg[0].flags == 0 &&
+			msg[1].flags == I2C_M_RD && msg[0].len == 1 && msg[1].len > 0) {
+			ret = tbs_dtb08_i2c_read(dev->udev, msg[0].addr,
+					msg[0].buf[0],msg[1].buf, msg[1].len);
+		}
+		else {
+			err("%s: num==2, msg[0].addr==%02x, msg[0].flags==%d, "
+			    "msg[0].len==%d, msg[1].addr==%02x, msg[1].flags==%d, "
+			    "not suported!", __func__, msg[0].addr, msg[0].flags,
+				msg[0].len, msg[1].addr, msg[1].flags);
+			ret = -EINVAL;
+		}
+		break;
+	case 1:
+		switch (msg[0].addr) {
+		case DEMOD_I2C_ADDR:
+		case TUNER_I2C_ADDR:
+			ii = msg[0].len - 1;
+			if (ii < 0 || ii > 63) {
+				ret = -EINVAL;
+				break;
+			}
+
+			if (msg[0].flags == 0) {
+				ret = tbs_dtb08_i2c_write(
+					dev->udev, msg[0].addr,
+					msg[0].buf[0],
+					&msg[0].buf[1], ii);
+			} else {
+				ret = tbs_dtb08_i2c_read(
+					dev->udev, msg[0].addr,
+					msg[0].buf[0],
+					msg[0].buf, msg[0].len);
+			}
+			break;
+		default:
+			err("%s: num==1, addr==%02x, not suported!",
+			    __func__, msg[0].addr);
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		err("%s:num == %d, not suported!", __func__, num);
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&dev->i2c_mutex);
+
+	return (ret < 0) ? ret : num;
+}
+
+static struct rc_map_table tbs_dtb08_rc_map_table[] = {
+	{ 0x0010, KEY_POWER },		/* power */
+	{ 0x0006, KEY_MUTE },		/* mute */
+	{ 0x004c, KEY_1 },
+	{ 0x0004, KEY_2 },
+	{ 0x0000, KEY_3 },
+	{ 0x001e, KEY_4 },
+	{ 0x000e, KEY_5 },
+	{ 0x001a, KEY_6 },
+	{ 0x0014, KEY_7 },
+	{ 0x000f, KEY_8 },
+	{ 0x000c, KEY_9 },
+	{ 0x001c, KEY_0 },
+	{ 0x0040, KEY_CHANNELUP },	/* ch+ */
+	{ 0x000a, KEY_CHANNELDOWN },	/* ch- */
+	{ 0x0019, KEY_VOLUMEUP },	/* vol+ */
+	{ 0x0017, KEY_VOLUMEDOWN },	/* vol- */
+	{ 0x0011, KEY_OK },		/* ok */
+	{ 0x0009, KEY_SAVE },		/* scrn shot */
+	{ 0x001f, KEY_UP },
+	{ 0x001b, KEY_LEFT },
+	{ 0x0015, KEY_RIGHT },
+	{ 0x0016, KEY_DOWN },
+	{ 0x004d, KEY_FAVORITES },	/* fav */
+	{ 0x0001, KEY_ZOOM },
+	{ 0x0003, KEY_EPG },
+	{ 0x001d, KEY_PLAY },
+	{ 0x000d, KEY_STOP },
+	{ 0x0012, KEY_LAST  },		/* recall */
+};
+
+static int tbs_dtb08_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
+{
+	u8 *buf;
+	int i;
+	struct rc_map_table *rc_map = d->props.rc.legacy.rc_map_table;
+
+	*state = REMOTE_NO_KEY_PRESSED;
+	*event = 0;
+
+	if (!fw_ok) {
+		dbg_info("%s: fw_ok == 0", __func__);
+		return 0;
+	}
+
+	buf = kzalloc(5, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&tbs_dtb08_usb_mutex))
+		goto free_buf_leave;
+
+	tbs_dtb08_ir_code_read(d->udev, buf, 5);
+	mutex_unlock(&tbs_dtb08_usb_mutex);
+
+	dbg_info("%s: %02x %02x %02x %02x %02x",
+		 __func__, buf[0], buf[1], buf[2], buf[3], buf[4]);
+
+	if (buf[1] != (u8)~buf[2] || buf[3] != (u8)~buf[4])
+		goto free_buf_leave;
+
+	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
+		u16 scan = (u16)buf[1] << 8 | buf[3];
+		if (rc_map[i].scancode == scan) {
+			*event = rc_map[i].keycode;
+			*state = REMOTE_KEY_PRESSED;
+			break;
+		}
+	}
+
+free_buf_leave:
+	kfree(buf);
+	return 0;
+}
+
+inline int mb86a20s_read_reg(struct mb86a20s_state *state, u8 reg, u8 *val)
+{
+	*val = 0;
+	return tbs_dtb08_i2c_read(state->udev, state->demod_addr, reg, val, 1);
+}
+
+inline int mb86a20s_write_reg(struct mb86a20s_state *state, u8 reg, u8 val)
+{
+	return tbs_dtb08_i2c_write(state->udev, state->demod_addr, reg, &val, 1);
+}
+
+inline int mb86a20s_read_subreg(struct mb86a20s_state *state, u8 reg, u8 subreg, u8 *val)
+{
+	int ret;
+
+	*val = 0;
+	if ((ret = tbs_dtb08_i2c_write(state->udev, state->demod_addr, reg, &subreg, 1)) < 0)
+		return ret;
+	return tbs_dtb08_i2c_read(state->udev, state->demod_addr, reg+1, val, 1);
+}
+
+static u32 get_config_reg_val(struct mb86a20s_state *state,
+			      struct mb86a20s_reg_subreg_val *reg_val)
+{
+	struct mb86a20s_reg_subreg_config *config_regs;
+	int i;
+
+	if (!reg_val)
+		return 0;
+	if (!state || !(config_regs = state->config_regs))
+		return reg_val->val;
+	for (i = 0; i < state->config_size; i++) {
+		if (config_regs->reg == reg_val->reg &&
+		    config_regs->subreg == reg_val->subreg)
+			return config_regs->val;
+		config_regs++;
+	}
+	return reg_val->val;
+}
+
+static int mb86a20s_init_regs(struct mb86a20s_state *state)
+{
+	u8 *buf;
+	u32 val;
+	int i, i2, count, ret = 0;
+
+	buf = kmalloc(12 , GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(mb86a20s_regs_val); i++) {
+		struct mb86a20s_reg_subreg_val *reg_val = &mb86a20s_regs_val[i];
+		val = get_config_reg_val(state, reg_val);
+		buf[0] = reg_val->reg;
+		count = 1;
+		switch (reg_val->type) {
+		case 1:
+			buf[count++] = reg_val->subreg;
+			if (buf[0] == 0x28)
+				buf[count++] = 0x2b;
+			else
+				buf[count++] = buf[0] + 1;
+			break;
+		case 2:
+			buf[count++] = (u8)(val >> 0x08);
+			buf[count++] = buf[0] + 1;
+			buf[count++] = (u8)val;
+			break;
+		case 3:
+			buf[count++] = reg_val->subreg;
+			buf[count++] = buf[0] + 1;
+			buf[count++] = (u8)(val >> 0x08);
+			buf[count++] = buf[0];
+			buf[count++] = reg_val->subreg + 1;
+			buf[count++] = buf[0] + 1;
+			break;
+		case 4:
+			if (buf[0] == 0x28) {
+				buf[count++] = reg_val->subreg;
+				buf[count++] = 0x29;
+				buf[count++] = (u8)(val >> 0x10);
+				buf[count++] = 0x2a;
+				buf[count++] = (u8)(val >> 0x08);
+				buf[count++] = 0x2b;
+			}
+			else if (buf[0] == 0x50) {
+				buf[count++] = reg_val->subreg;
+				buf[count++] = 0x51;
+				buf[count++] = (u8)(val >> 0x10);
+				buf[count++] = 0x50;
+				buf[count++] = reg_val->subreg + 1;
+				buf[count++] = 0x51;
+				buf[count++] = (u8)(val >> 0x08);
+				buf[count++] = 0x50;
+				buf[count++] = reg_val->subreg + 2;
+				buf[count++] = 0x51;
+			}
+			else {
+				ret = -1;
+				goto ret_err;
+			}
+			break;
+		}
+		buf[count++] = (u8)val;
+		i2 = 0;
+		while (i2 < count) {
+			ret = mb86a20s_write_reg(state, buf[i2], buf[i2 + 1]);
+			if (ret < 0)
+				goto ret_err;
+			i2 += 2;
+		}
+	}
+	state->need_init = false;
+	kfree(buf);
+	return 0;
+
+ret_err:
+	state->need_init = true;
+	err("%s: mb86a20s init failed.", __func__);
+	kfree(buf);
+	return ret;
+}
+
+static int mb86a20s_init_fe(struct dvb_frontend *fe)
+{
+	int n;
+	struct mb86a20s_state *state = fe->sec_priv;
+
+	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
+
+	n = mb86a20s_init_regs(state);
+	if (n < 0)
+		return n;
+	else
+		return 0;
+}
+
+static int mb86a20s_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct mb86a20s_state *state = fe->sec_priv;
+	char val = 1;
+
+	/*
+	 * In the document "OFDM-LSI for Digital Terrestrial Broadcasting
+	 * Reception MB86A20S" says:
+	 * I2C bus and I2C bus for tuner control
+	 * This product realizes I2C bus for register setup in the main
+	 * unit and I2C bus for tuner control to shut off the bus noise from
+	 * the tuner by connecting the tuner to the I2C bus line only when
+	 * it is controlled.
+	 */
+	if (!state->tuner_ctrl)
+		return 0;
+
+	if (enable)
+		val = 0;
+
+	/* Enable/Disable I2C bus for tuner control */
+	return mb86a20s_write_reg(state, 0xfe, val);
+}
+
+static int mb86a20s_sleep(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->sec_priv;
+
+	tbs_dtb08_led_control(state->udev, 0);
+	state->current_frequency = 0;
+	state->need_init = 1;
+	return 0;
+}
+
+static int mb86a20s_set_frontend(struct dvb_frontend *fe)
+{
+	int i, ret;
+	u8 val;
+	struct mb86a20s_state *state = fe->sec_priv;
+	struct dtv_frontend_properties *dpc = &fe->dtv_property_cache;
+
+	if (time_before(jiffies, state->next_set_frontend_check) &&
+		state->current_frequency == dpc->frequency)
+			return 0;
+
+	state->current_frequency = dpc->frequency;
+	state->next_set_frontend_check = jiffies + msecs_to_jiffies(200);
+
+	/* turn off the led */
+	tbs_dtb08_led_control(state->udev, 0);
+
+	if (state->need_init) {
+		ret = mb86a20s_init_regs(state);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* program tuner */
+	if (fe->ops.tuner_ops.set_params) {
+		state->tuner_ctrl = true;
+		fe->ops.tuner_ops.set_params(fe);
+		/* disable I2C bus tuner control */
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+		state->tuner_ctrl = false;
+		msleep(100);
+	}
+
+	for (i = 0; i < sizeof(mb86a20s_soft_reset); i += 2)
+	{
+		ret = mb86a20s_write_reg(state, mb86a20s_soft_reset[i],
+					mb86a20s_soft_reset[i+1]);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < 10; i++) {
+		ret = mb86a20s_read_reg(state, 0x0a, &val);
+		if (ret == 0 && val >= 2) break;
+		msleep(100);
+	}
+
+	/* turn on the led */
+	tbs_dtb08_led_control(state->udev, 1);
+
+	return 0;
+}
+
+static int mb86a20s_get_tune_settings(struct dvb_frontend *fe,
+				struct dvb_frontend_tune_settings *feset)
+{
+	feset->min_delay_ms = 600;
+	feset->step_size = 0;
+	feset->max_drift = 0;
+
+	return 0;
+}
+
+static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	int i;
+	u8 val = 0;
+	struct mb86a20s_state *state = fe->sec_priv;
+
+	if (time_before(jiffies, state->next_status_check)) {
+		*status = state->status;
+		return 0;
+	}
+
+	state->next_status_check = jiffies + msecs_to_jiffies(100);
+	for (i = 0; i < 10; i++) {
+		mb86a20s_read_reg(state, 0x0a, &val);
+		if (val >= 2) break;
+		msleep(10);
+	}
+
+	*status = 0;
+
+	if (val >= 2)
+		*status |= FE_HAS_SIGNAL;
+	if (val >= 4)
+		*status |= FE_HAS_CARRIER;
+	if (val >= 5)
+		*status |= FE_HAS_VITERBI;
+	if (val >= 7)
+		*status |= FE_HAS_SYNC;
+	if (val >= 8)
+		*status |= FE_HAS_LOCK;
+
+	state->status = *status;
+	return 0;
+}
+
+static int mb86a20s_get_property(struct dvb_frontend *fe,
+				 struct dtv_property *tvp)
+{
+	struct dtv_frontend_properties *dpc = &fe->dtv_property_cache;
+
+	switch(tvp->cmd) {
+	case DTV_DELIVERY_SYSTEM:
+		tvp->u.data = dpc->delivery_system = SYS_ISDBT;
+		break;
+	}
+	return 0;
+}
+
+static int mb86a20s_read_signal_strength(struct dvb_frontend *fe,
+					   u16 *strength)
+{
+	struct mb86a20s_state *state = fe->sec_priv;
+	int i, n;
+
+	if (time_before(jiffies, state->next_strength_check)) {
+		*strength = state->strength;
+		return 0;
+	}
+	state->next_strength_check = jiffies + msecs_to_jiffies(100);
+	*strength = state->strength = 0;
+	for (i = 0; i < 10; i++)
+	{
+		u8 val = 0;
+		mb86a20s_read_reg(state, 0x0a, &val);
+		if (val < 2) goto next;
+#if 0
+		if (mb86a20s_read_subreg(state, 0x04, 0x3a, &val) < 0)
+			goto next;
+		n = ((255 - val) * 10000) / 255;
+		state->strength = *strength = (u16)((65535 * n) / 10000);
+
+		dbg_info("%s: val=%d, n=%d, strength=%d %d%%",
+			__func__, val, n, *strength, (255-val) * 100 / 255);
+		return 0;
+#else
+		if (mb86a20s_read_subreg(state, 0x04, 0x25, &val) < 0)
+			goto next;
+		n = val;
+		if (mb86a20s_read_subreg(state, 0x04, 0x26, &val) < 0)
+			goto next;
+		n = (((n << 8) | val) * 0x100100) >> 16;
+		*strength = state->strength = n ;
+		return 0;
+#endif
+next:
+		msleep(10);
+	}
+
+	return 0;
+}
+
+static int mb86a20s_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct mb86a20s_state *state = fe->sec_priv;
+	int i, n, cnr;
+
+	if (time_before(jiffies, state->next_snr_check)) {
+		*snr = state->snr;
+ 		return 0;
+	}
+
+	state->next_snr_check = jiffies + msecs_to_jiffies(100);
+	*snr = state->snr = 0;
+	for (i = 0; i < 10; i++) {
+		u8 val = 0;
+		n = mb86a20s_read_reg(state, 0x0a, &val);
+		if (n < 0 || val < 2) goto next;
+		if (mb86a20s_read_reg(state, 0x45, &val) < 0) goto next;
+		/* read cnr_flag */
+		if (((val >> 6) & 1) != 0) {
+			if (mb86a20s_read_reg(state, 0x46, &val) < 0) goto next;
+			n = val;
+			if (mb86a20s_read_reg(state, 0x47, &val) < 0) goto next;
+			cnr = (n << 0x08) | val;
+			/* reset cnr_counter */
+			mb86a20s_read_reg(state, 0x45, &val);
+			val |= 0x10;
+			mb86a20s_write_reg(state, 0x45, val);
+			msleep(5);
+			val &= 0x6f; /* FIXME: or 0xef ? */
+			mb86a20s_write_reg(state, 0x45, val);
+			if (cnr > 0x4cc0) cnr = 0x4cc0;
+			n = ((0x4cc0 - cnr) * 10000) / 0x4cc0;
+			n = (65535 * n) / 10000;
+			*snr = state->snr = n;
+			return 0;
+		}
+next:
+		msleep(10);
+	}
+
+	return 0;
+}
+
+static struct tda18271_std_map mb86a20s_tda18271_config = {
+	.dvbt_6 = { .if_freq = 3300, .agc_mode = 3, .std = 4,
+		    .if_lvl = 7, .rfagc_top = 0x37, },
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
+	struct mb86a20s_state *state = adap->fe_adap[0].priv;
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
+static struct mb86a20s_reg_subreg_config mb86a20s_config_regs[] = {
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
+	struct dvb_frontend *fe;
+	struct dvb_usb_device *dev = adap->dev;
+	struct mb86a20s_state *state = adap->fe_adap[0].priv;
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
+	state->config_size = ARRAY_SIZE(mb86a20s_config_regs);
+	state->config_regs = mb86a20s_config_regs;
+
+	if (mb86a20s_init_regs(state) != 0) {
+		err("%s: demodulator not found!", __func__);
+		return -ENODEV;
+	}
+
+	fe = dvb_attach(mb86a20s_attach, &mb86a20s_cfg,
+			&adap->dev->i2c_adap);
+	if (!fe) return -ENODEV;
+
+	adap->fe_adap[0].fe = fe;
+
+	fe->sec_priv = state;
+	fe->ops.init = mb86a20s_init_fe;
+	fe->ops.sleep = mb86a20s_sleep;
+	fe->ops.set_frontend = mb86a20s_set_frontend;
+	fe->ops.read_status = mb86a20s_read_status;
+	fe->ops.read_signal_strength = mb86a20s_read_signal_strength;
+	fe->ops.read_snr = mb86a20s_read_snr;
+	fe->ops.get_tune_settings = mb86a20s_get_tune_settings;
+	fe->ops.get_property = mb86a20s_get_property;
+	fe->ops.i2c_gate_ctrl = mb86a20s_i2c_gate_ctrl;
+
+	if (tbs_dtb08_tuner_attach(adap) == 0) {
+		tbs_dtb08_fx2_ie_ex0(dev->udev, FX2_EX0_ENABLE);
+		return 0;
+	}
+
+	dvb_frontend_detach(fe);
+	adap->fe_adap[0].fe = NULL;
+
+	return -ENODEV;
+}
+
+static int tbs_dtb08_download_firmware(struct usb_device *dev, const struct firmware *fw)
+{
+	int i, n, count, fx2_renum;
+	u8 val, *buf;
+
+	fw_ok = 0;
+ 	if (dev == NULL || fw == NULL || fw->size <= 0) {
+		err("%s: invalid parameters.", __func__);
+		return -EINVAL;
+	}
+
+	/* stop the CPU */
+	val = 1;
+	if (tbs_dtb08_generic_write_addr(dev, 0xa0, 0xe600, &val, 1) != 1)
+		return -EINVAL;
+
+	buf = kmalloc(64 , GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	fx2_renum = 1;
+	for (n = 0; n < fw->size; n += 64) {
+		count = fw->size - n;
+		if (count > 64)
+			count = 64;
+
+		if (fx2_renum) {
+			tbs_dtb08_generic_read_addr(dev, 0xa0, n, buf, count);
+			for (i = 0; i < count; i++) {
+				if (buf[i] != fw->data[n+i]) {
+					fx2_renum = 0;
+					break;
+				}
+			}
+			if (fx2_renum) continue;
+		}
+		memcpy(buf, fw->data + n, count);
+		if (tbs_dtb08_generic_write_addr(dev, 0xa0, n, buf, count) != count) {
+			err("%s: addr=%04x: error while "
+				"transferring firmware", __func__, n);
+			goto ret_err2;
+		}
+	}
+
+	/* restart the CPU */
+	val = 0;
+	if (tbs_dtb08_generic_write_addr(dev, 0xa0, 0xe600, &val, 1) != 1) {
+		err("%s: could not restart the USB controller CPU.", __func__);
+		goto ret_err2;
+	}
+
+	msleep(200);
+
+	if (!fx2_renum) { /* ReEnumeration */
+		err("%s: ReEnumeration!", __func__);
+		goto ret_err2;
+	}
+
+	if (tbs_dtb08_i2c_read(dev, DEMOD_I2C_ADDR, 0, &val, 1) < 0)
+		goto ret_err;
+
+	if (tbs_dtb08_fx2_ie_ex0(dev, FX2_EX0_ENABLE) < 0)
+		goto ret_err;
+
+	if (tbs_dtb08_ir_code_read(dev, buf, 5) < 0)
+		goto ret_err;
+
+	kfree(buf);
+	fw_ok = 1;
+	return 0;
+
+ret_err:
+	err("%s: failed!", __func__);
+
+ret_err2:
+	kfree(buf);
+	return -EINVAL;
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
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.download_firmware = tbs_dtb08_download_firmware,
+	.firmware = "tbs-dtb08-fw.bin",
+	.no_reconnect = 1,
+
+	.num_adapters = 1,
+	.adapter = {{
+		.num_frontends = 1,
+		.fe = {{
+			.size_of_priv = sizeof(struct mb86a20s_state),
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
+		}}}
+	},
+
+	.rc.legacy = {
+		.rc_interval      = 250,
+		.rc_map_table     = tbs_dtb08_rc_map_table,
+		.rc_map_size      = ARRAY_SIZE(tbs_dtb08_rc_map_table),
+		.rc_query         = tbs_dtb08_rc_query,
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
+	struct dvb_usb_device *d = NULL;
+	int n, ret;
+
+	dbg_info("%s: %d, num_altsetting=%d", __func__,
+		 intf->cur_altsetting->desc.bInterfaceNumber,
+		 intf->num_altsetting);
+
+	ret = dvb_usb_device_init(intf, &tbs_dtb08_properties,
+			THIS_MODULE, &d, adapter_nr);
+
+	if (ret != 0) {
+		err("%s: failed err=%d", __func__, ret);
+		return ret;
+	}
+
+	if (d) {
+		for (n = 0; n < d->props.num_adapters; n++) {
+			struct dvb_usb_adapter *adap = &d->adapter[n];
+			if (adap && adap->fe_adap[0].fe) {
+			  ret++;
+			}
+		}
+	}
+
+	if (ret == 0) {
+		fw_ok = 0;
+		dvb_usb_device_exit(intf);
+		return -1;
+	}
+	else
+		return 0;
+}
+
+static void tbs_dtb08_usb_disconnect(struct usb_interface *intf)
+{
+	fw_ok = 0;
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
1.7.9.3

