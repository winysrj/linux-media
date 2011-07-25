Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37755 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1GYSfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 14:35:12 -0400
Received: by mail-wy0-f174.google.com with SMTP id 8so2946422wyg.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 11:35:11 -0700 (PDT)
Subject: [PATCH 2/3] it913x Series Driver for Kworld UB499-2T (id
 1b80:e409) v1.05
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 19:35:03 +0100
Message-ID: <1311618903.7655.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver for Kworld UB499-2T (id 1b80:e409)

The device driver has been named it913x, so that support for other family members
can be added later.

TODOs
Firmware support for other it913x devices.
Remote control support, there are two known types.
 

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/Kconfig       |    7 +
 drivers/media/dvb/dvb-usb/Makefile      |    3 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it913x.c      |  613 +++++++++++++++++++++++++++++++
 4 files changed, 624 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/it913x.c

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 5d73dec..6e97bb3 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -374,3 +374,10 @@ config DVB_USB_TECHNISAT_USB2
 	select DVB_STV6110x if !DVB_FE_CUSTOMISE
 	help
 	  Say Y here to support the Technisat USB2 DVB-S/S2 device
+
+config DVB_USB_IT913X
+	tristate "it913x driver"
+	depends on DVB_USB
+	select DVB_IT913X_FE
+	help
+	  Say Y here to support the it913x device
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 4bac13d..3494d41 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -94,6 +94,9 @@ obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
 dvb-usb-technisat-usb2-objs = technisat-usb2.o
 obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
 
+dvb-usb-it913x-objs := it913x.o
+obj-$(CONFIG_DVB_USB_IT913X) += dvb-usb-it913x.o
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
 # due to tuner-xc3028
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 2a79b8f..7433261 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -136,6 +136,7 @@
 #define USB_PID_KWORLD_PC160_2T				0xc160
 #define USB_PID_KWORLD_PC160_T				0xc161
 #define USB_PID_KWORLD_UB383_T				0xe383
+#define USB_PID_KWORLD_UB499_2T_T09			0xe409
 #define USB_PID_KWORLD_VSTREAM_COLD			0x17de
 #define USB_PID_KWORLD_VSTREAM_WARM			0x17df
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE		0x0055
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
new file mode 100644
index 0000000..94a611b
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -0,0 +1,613 @@
+/* DVB USB compliant linux driver for IT9137
+ *
+ * Copyright (C) 2011 Malcolm Priestley (tvboxspy@gmail.com)
+ * IT9137 (C) ITE Tech Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/dvb/it9137.txt for firmware information
+ *
+ */
+#define DVB_USB_LOG_PREFIX "it913x"
+
+#include <linux/usb.h>
+#include <linux/usb/input.h>
+#include <media/rc-core.h>
+
+#include "dvb-usb.h"
+#include "it913x-fe.h"
+
+/* debug */
+static int dvb_usb_it913x_debug;
+#define l_dprintk(var, level, args...) do { \
+	if ((var >= level)) \
+		printk(KERN_DEBUG DVB_USB_LOG_PREFIX ": " args); \
+} while (0)
+
+#define deb_info(level, args...) l_dprintk(dvb_usb_it913x_debug, level, args)
+#define debug_data_snipet(level, name, p) \
+	 deb_info(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
+		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
+			*(p+5), *(p+6), *(p+7));
+
+
+module_param_named(debug, dvb_usb_it913x_debug, int, 0644);
+MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))."
+			DVB_USB_DEBUG_STATUS);
+
+static int pid_filter;
+module_param_named(pid, pid_filter, int, 0644);
+MODULE_PARM_DESC(pid, "set default 0=on 1=off");
+
+int cmd_counter;
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+struct it913x_state {
+	u8 id;
+};
+
+static int it913x_bulk_write(struct usb_device *dev,
+				u8 *snd, int len, u8 pipe)
+{
+	int ret, actual_l;
+
+	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
+				snd, len , &actual_l, 100);
+	return ret;
+}
+
+static int it913x_bulk_read(struct usb_device *dev,
+				u8 *rev, int len, u8 pipe)
+{
+	int ret, actual_l;
+
+	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
+				 rev, len , &actual_l, 200);
+	return ret;
+}
+
+static u16 check_sum(u8 *p, u8 len)
+{
+	u16 sum = 0;
+	u8 i = 1;
+	while (i < len)
+		sum += (i++ & 1) ? (*p++) << 8 : *p++;
+	return ~sum;
+}
+
+static int it913x_io(struct usb_device *udev, u8 mode, u8 pro,
+			u8 cmd, u32 reg, u8 addr, u8 *data, u8 len)
+{
+	int ret = 0, i, buf_size = 1;
+	u8 *buff;
+	u8 rlen;
+	u16 chk_sum;
+
+	buff = kzalloc(256, GFP_KERNEL);
+	if (!buff) {
+		info("USB Buffer Failed");
+		return -ENOMEM;
+	}
+
+	buff[buf_size++] = pro;
+	buff[buf_size++] = cmd;
+	buff[buf_size++] = cmd_counter;
+
+	switch (mode) {
+	case READ_LONG:
+	case WRITE_LONG:
+		buff[buf_size++] = len;
+		buff[buf_size++] = 2;
+		buff[buf_size++] = (reg >> 24);
+		buff[buf_size++] = (reg >> 16) & 0xff;
+		buff[buf_size++] = (reg >> 8) & 0xff;
+		buff[buf_size++] = reg & 0xff;
+	break;
+	case READ_SHORT:
+		buff[buf_size++] = addr;
+		break;
+	case WRITE_SHORT:
+		buff[buf_size++] = len;
+		buff[buf_size++] = addr;
+		buff[buf_size++] = (reg >> 8) & 0xff;
+		buff[buf_size++] = reg & 0xff;
+	break;
+	case READ_DATA:
+	case WRITE_DATA:
+		break;
+	case WRITE_CMD:
+		mode = 7;
+		break;
+	default:
+		kfree(buff);
+		return -EINVAL;
+	}
+
+	if (mode & 1) {
+		for (i = 0; i < len ; i++)
+			buff[buf_size++] = data[i];
+	}
+	chk_sum = check_sum(&buff[1], buf_size);
+
+	buff[buf_size++] = chk_sum >> 8;
+	buff[0] = buf_size;
+	buff[buf_size++] = (chk_sum & 0xff);
+
+	ret = it913x_bulk_write(udev, buff, buf_size , 0x02);
+
+	ret |= it913x_bulk_read(udev, buff, (mode & 1) ?
+			5 : len + 5 , 0x01);
+
+	rlen = (mode & 0x1) ? 0x1 : len;
+
+	if (mode & 1)
+		ret |= buff[2];
+	else
+		memcpy(data, &buff[3], rlen);
+
+	cmd_counter++;
+
+	kfree(buff);
+
+	return (ret < 0) ? -ENODEV : 0;
+}
+
+static int it913x_wr_reg(struct usb_device *udev, u8 pro, u32 reg , u8 data)
+{
+	int ret;
+	u8 b[1];
+	b[0] = data;
+	ret = it913x_io(udev, WRITE_LONG, pro,
+			CMD_DEMOD_WRITE, reg, 0, b, sizeof(b));
+
+	return ret;
+}
+
+static int it913x_read_reg(struct usb_device *udev, u32 reg)
+{
+	int ret;
+	u8 data[1];
+
+	ret = it913x_io(udev, READ_LONG, DEV_0,
+			CMD_DEMOD_READ, reg, 0, &data[0], 1);
+
+	return (ret < 0) ? ret : data[0];
+}
+
+static u32 it913x_query(struct usb_device *udev, u8 pro)
+{
+	int ret;
+	u32 res = 0;
+	u8 data[4];
+	ret = it913x_io(udev, READ_LONG, pro, CMD_DEMOD_READ,
+		0x1222, 0, &data[0], 1);
+	if (data[0] == 0x1) {
+		ret = it913x_io(udev, READ_SHORT, pro,
+			CMD_QUERYINFO, 0, 0x1, &data[0], 4);
+		res = (data[0] << 24) + (data[1] << 16) +
+			(data[2] << 8) + data[3];
+	}
+
+	return (ret < 0) ? 0 : res;
+}
+
+static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	int ret = 0;
+	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
+
+	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
+			return -EAGAIN;
+	deb_info(1, "PID_C  (%02x)", onoff);
+
+	if (!onoff)
+		ret = it913x_wr_reg(adap->dev->udev, pro, PID_RST, 0x1);
+
+	mutex_unlock(&adap->dev->i2c_mutex);
+	return ret;
+}
+
+static int it913x_pid_filter(struct dvb_usb_adapter *adap,
+		int index, u16 pid, int onoff)
+{
+	struct usb_device *udev = adap->dev->udev;
+	int ret = 0;
+	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
+
+	if (pid_filter > 0)
+		return 0;
+
+	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
+			return -EAGAIN;
+	deb_info(1, "PID_F  (%02x)", onoff);
+	if (onoff) {
+		ret = it913x_wr_reg(udev, pro, PID_EN, 0x1);
+
+		ret |= it913x_wr_reg(udev, pro, PID_LSB, (u8)(pid & 0xff));
+
+		ret |= it913x_wr_reg(udev, pro, PID_MSB, (u8)(pid >> 8));
+
+		ret |= it913x_wr_reg(udev, pro, PID_INX_EN, (u8)onoff);
+
+		ret |= it913x_wr_reg(udev, pro, PID_INX, (u8)(index & 0x1f));
+
+	}
+
+	mutex_unlock(&adap->dev->i2c_mutex);
+	return 0;
+}
+
+
+static int it913x_return_status(struct usb_device *udev)
+{
+	u32 firm = 0;
+
+	firm = it913x_query(udev, DEV_0);
+	if (firm > 0)
+		info("Firmware Version %d", firm);
+
+	return (firm > 0) ? firm : 0;
+}
+
+static int it913x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+				 int num)
+{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	static u8 data[256];
+	int ret;
+	u32 reg;
+	u8 pro;
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+			return -EAGAIN;
+
+	debug_data_snipet(1, "Message out", msg[0].buf);
+	deb_info(2, "num of messages %d address %02x", num, msg[0].addr);
+
+	pro = (msg[0].addr & 0x2) ?  DEV_0_DMOD : 0x0;
+	pro |= (msg[0].addr & 0x20) ? DEV_1 : DEV_0;
+	memcpy(data, msg[0].buf, msg[0].len);
+	reg = (data[0] << 24) + (data[1] << 16) +
+			(data[2] << 8) + data[3];
+	if (num == 2) {
+		ret = it913x_io(d->udev, READ_LONG, pro,
+			CMD_DEMOD_READ, reg, 0, data, msg[1].len);
+		memcpy(msg[1].buf, data, msg[1].len);
+	} else
+		ret = it913x_io(d->udev, WRITE_LONG, pro, CMD_DEMOD_WRITE,
+			reg, 0, &data[4], msg[0].len - 4);
+
+	mutex_unlock(&d->i2c_mutex);
+
+	return ret;
+}
+
+static u32 it913x_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm it913x_i2c_algo = {
+	.master_xfer   = it913x_i2c_xfer,
+	.functionality = it913x_i2c_func,
+};
+
+/* Callbacks for DVB USB */
+static int it913x_identify_state(struct usb_device *udev,
+		struct dvb_usb_device_properties *props,
+		struct dvb_usb_device_description **desc,
+		int *cold)
+{
+	int ret = 0, firm_no;
+	u8 reg, adap, ep, tun0, tun1;
+
+	firm_no = it913x_return_status(udev);
+
+	ep = it913x_read_reg(udev, 0x49ac);
+	adap = it913x_read_reg(udev, 0x49c5);
+	tun0 = it913x_read_reg(udev, 0x49d0);
+	info("No. Adapters=%x Endpoints=%x Tuner Type=%x", adap, ep, tun0);
+
+	if (firm_no > 0) {
+		*cold = 0;
+		return 0;
+	}
+
+	if (adap > 2) {
+		tun1 = it913x_read_reg(udev, 0x49e0);
+		ret = it913x_wr_reg(udev, DEV_0, GPIOH1_EN, 0x1);
+		ret |= it913x_wr_reg(udev, DEV_0, GPIOH1_ON, 0x1);
+		ret |= it913x_wr_reg(udev, DEV_0, GPIOH1_O, 0x1);
+		msleep(50); /* Delay noticed reset cycle ? */
+		ret |= it913x_wr_reg(udev, DEV_0, GPIOH1_O, 0x0);
+		msleep(50);
+		reg = it913x_read_reg(udev, GPIOH1_O);
+		if (reg == 0) {
+			ret |= it913x_wr_reg(udev, DEV_0,  GPIOH1_O, 0x1);
+			ret |= it913x_return_status(udev);
+			if (ret != 0)
+				ret = it913x_wr_reg(udev, DEV_0,
+					GPIOH1_O, 0x0);
+		}
+	} else
+		props->num_adapters = 1;
+
+	reg = it913x_read_reg(udev, IO_MUX_POWER_CLK);
+
+	ret |= it913x_wr_reg(udev, DEV_0, 0x4bfb, CHIP2_I2C_ADDR);
+
+	ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x1);
+
+	*cold = 1;
+
+	return (ret < 0) ? -ENODEV : 0;
+}
+
+static int it913x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	int ret = 0;
+	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
+
+	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
+			return -EAGAIN;
+	deb_info(1, "STM  (%02x)", onoff);
+
+	if (!onoff)
+		ret = it913x_wr_reg(adap->dev->udev, pro, PID_RST, 0x1);
+
+
+	mutex_unlock(&adap->dev->i2c_mutex);
+
+	return ret;
+}
+
+
+static int it913x_download_firmware(struct usb_device *udev,
+					const struct firmware *fw)
+{
+	int ret = 0, i;
+	u8 packet_size, dlen, tun1;
+	u8 *fw_data;
+
+	packet_size = 0x29;
+
+	tun1 = it913x_read_reg(udev, 0x49e0);
+
+	ret = it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_100);
+
+	info("FRM Starting Firmware Download");
+	/* This uses scatter write firmware headers follow */
+	/* 03 XX 00     XX = chip number? */ 
+
+	for (i = 0; i < fw->size; i += packet_size) {
+			if (i > 0)
+				packet_size = 0x39;
+			fw_data = (u8 *)(fw->data + i);
+			dlen = ((i + packet_size) > fw->size)
+				? (fw->size - i) : packet_size;
+			ret |= it913x_io(udev, WRITE_DATA, DEV_0,
+				CMD_SCATTER_WRITE, 0, 0, fw_data, dlen);
+			udelay(1000);
+	}
+
+	ret |= it913x_io(udev, WRITE_CMD, DEV_0,
+			CMD_BOOT, 0, 0, NULL, 0);
+
+	msleep(100);
+
+	if (ret < 0)
+		info("FRM Firmware Download Failed (%04x)" , ret);
+	else
+		info("FRM Firmware Download Completed - Resetting Device");
+
+	ret |= it913x_return_status(udev);
+
+	msleep(30);
+
+	ret |= it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_400);
+
+	/* Tuner function */
+	ret |= it913x_wr_reg(udev, DEV_0_DMOD , 0xec4c, 0xa0);
+
+	ret |= it913x_wr_reg(udev, DEV_0,  PADODPU, 0x0);
+	ret |= it913x_wr_reg(udev, DEV_0,  AGC_O_D, 0x0);
+	if (tun1 > 0) {
+		ret |= it913x_wr_reg(udev, DEV_1,  PADODPU, 0x0);
+		ret |= it913x_wr_reg(udev, DEV_1,  AGC_O_D, 0x0);
+	}
+
+	return (ret < 0) ? -ENODEV : 0;
+}
+
+static int it913x_name(struct dvb_usb_adapter *adap)
+{
+	const char *desc = adap->dev->desc->name;
+	char *fe_name[] = {"_1", "_2", "_3", "_4"};
+	char *name = adap->fe->ops.info.name;
+
+	strlcpy(name, desc, 128);
+	strlcat(name, fe_name[adap->id], 128);
+
+	return 0;
+}
+
+static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct usb_device *udev = adap->dev->udev;
+	int ret = 0;
+	u8 adf = it913x_read_reg(udev, IO_MUX_POWER_CLK);
+	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
+	u16 ep_size = adap->props.stream.u.bulk.buffersize;
+
+	adap->fe = dvb_attach(it913x_fe_attach,
+		&adap->dev->i2c_adap, adap_addr, adf, IT9137);
+
+	if (adap->id == 0 && adap->fe) {
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2_SW_RST, 0x1);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2IF2_SW_RST, 0x1);
+		ret = it913x_wr_reg(udev, DEV_0, EP0_TX_EN, 0x0f);
+		ret = it913x_wr_reg(udev, DEV_0, EP0_TX_NAK, 0x1b);
+		ret = it913x_wr_reg(udev, DEV_0, EP0_TX_EN, 0x2f);
+		ret = it913x_wr_reg(udev, DEV_0, EP4_TX_LEN_LSB,
+					ep_size & 0xff);
+		ret = it913x_wr_reg(udev, DEV_0, EP4_TX_LEN_MSB, ep_size >> 8);
+		ret = it913x_wr_reg(udev, DEV_0, EP4_MAX_PKT, 0x80);
+	} else if (adap->id == 1 && adap->fe) {
+		ret = it913x_wr_reg(udev, DEV_0, EP0_TX_EN, 0x6f);
+		ret = it913x_wr_reg(udev, DEV_0, EP5_TX_LEN_LSB,
+					ep_size & 0xff);
+		ret = it913x_wr_reg(udev, DEV_0, EP5_TX_LEN_MSB, ep_size >> 8);
+		ret = it913x_wr_reg(udev, DEV_0, EP5_MAX_PKT, 0x80);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2IF2_EN, 0x1);
+		ret = it913x_wr_reg(udev, DEV_1_DMOD, MP2IF_SERIAL, 0x1);
+		ret = it913x_wr_reg(udev, DEV_1, TOP_HOSTB_SER_MODE, 0x1);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, TSIS_ENABLE, 0x1);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2_SW_RST, 0x0);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2IF2_SW_RST, 0x0);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2IF2_HALF_PSB, 0x0);
+		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2IF_STOP_EN, 0x1);
+		ret = it913x_wr_reg(udev, DEV_1_DMOD, MPEG_FULL_SPEED, 0x0);
+		ret = it913x_wr_reg(udev, DEV_1_DMOD, MP2IF_STOP_EN, 0x0);
+	} else
+		return -ENODEV;
+
+	ret = it913x_name(adap);
+
+	return ret;
+}
+
+/* DVB USB Driver */
+static struct dvb_usb_device_properties it913x_properties;
+
+static int it913x_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	cmd_counter = 0;
+	if (0 == dvb_usb_device_init(intf, &it913x_properties,
+				     THIS_MODULE, NULL, adapter_nr)) {
+		info("DEV registering device driver");
+		return 0;
+	}
+
+	info("DEV it913x Error");
+	return -ENODEV;
+
+}
+
+static struct usb_device_id it913x_table[] = {
+	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09) },
+	{}		/* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, it913x_table);
+
+static struct dvb_usb_device_properties it913x_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.download_firmware = it913x_download_firmware,
+	.firmware = "dvb-usb-it9137-01.fw",
+	.no_reconnect = 1,
+	.size_of_priv = sizeof(struct it913x_state),
+	.num_adapters = 2,
+	.adapter = {
+		{
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER|
+				DVB_USB_ADAP_NEED_PID_FILTERING|
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+			.streaming_ctrl   = it913x_streaming_ctrl,
+			.pid_filter_count = 31,
+			.pid_filter = it913x_pid_filter,
+			.pid_filter_ctrl  = it913x_pid_filter_ctrl,
+			.frontend_attach  = it913x_frontend_attach,
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 10,
+				.endpoint = 0x04,
+				.u = {/* Keep Low if PID filter on */
+					.bulk = {
+						.buffersize = 3584,
+
+					}
+				}
+			}
+		},
+			{
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER|
+				DVB_USB_ADAP_NEED_PID_FILTERING|
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+			.streaming_ctrl   = it913x_streaming_ctrl,
+			.pid_filter_count = 31,
+			.pid_filter = it913x_pid_filter,
+			.pid_filter_ctrl  = it913x_pid_filter_ctrl,
+			.frontend_attach  = it913x_frontend_attach,
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 5,
+				.endpoint = 0x05,
+				.u = {
+					.bulk = {
+						.buffersize = 3584,
+
+					}
+				}
+			}
+		}
+	},
+	.identify_state   = it913x_identify_state,
+	.i2c_algo         = &it913x_i2c_algo,
+	.num_device_descs = 1,
+	.devices = {
+		{   "Kworld UB499-2T T09(IT9137)",
+			{ &it913x_table[0], NULL },
+			},
+
+	}
+};
+
+static struct usb_driver it913x_driver = {
+	.name		= "it913x",
+	.probe		= it913x_probe,
+	.disconnect	= dvb_usb_device_exit,
+	.id_table	= it913x_table,
+};
+
+/* module stuff */
+static int __init it913x_module_init(void)
+{
+	int result = usb_register(&it913x_driver);
+	if (result) {
+		err("usb_register failed. Error number %d", result);
+		return result;
+	}
+
+	return 0;
+}
+
+static void __exit it913x_module_exit(void)
+{
+	/* deregister this driver from the USB subsystem */
+	usb_deregister(&it913x_driver);
+}
+
+module_init(it913x_module_init);
+module_exit(it913x_module_exit);
+
+MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
+MODULE_DESCRIPTION("it913x USB 2 Driver");
+MODULE_VERSION("1.05");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1




