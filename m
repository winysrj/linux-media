Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49453 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1IEV15 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 17:27:57 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1R0ghu-0002Vn-Nj
	for linux-media@vger.kernel.org; Mon, 05 Sep 2011 23:27:54 +0200
Received: from p54af3826.dip.t-dialin.net ([84.175.56.38])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 23:27:54 +0200
Received: from o.freyermuth by p54af3826.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 23:27:54 +0200
To: linux-media@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: Re: [PATCH] Add support for PCTV452E.
Date: Mon, 05 Sep 2011 23:27:27 +0200
Message-ID: <j43erv$8ft$1@dough.gmane.org>
References: <201105242151.22826.hselasky@c2i.net> <20110723132437.7b8add2c@grobi>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000307070007080806060206"
In-Reply-To: <20110723132437.7b8add2c@grobi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000307070007080806060206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Got it working with kernel 3.0!

For me, some more changes on the current patchset appeared to be necessary.
In short, I had to change all a->fe to a->fe[0] (because of 3.0-kernel)
and I had to add lnbp22 to Kconfig (it would otherwise have been
disabled and not been built, although other modules depended on it...).

I also had to add the additional
"EXPORT_SYMBOL(ttpci_eeprom_decode_mac);" as mentioned by Doychin Dokov.

Attached is the 'new' version of the patch with the mentioned changes.


--------------000307070007080806060206
Content-Type: text/x-patch;
 name="pctv452e.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pctv452e.patch"

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index c545039..6d725ad 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -250,6 +250,18 @@ config DVB_USB_AF9005
 	  Say Y here to support the Afatech AF9005 based DVB-T USB1.1 receiver
 	  and the TerraTec Cinergy T USB XE (Rev.1)
 
+config DVB_USB_PCTV452E
+	tristate "Pinnacle PCTV HDTV Pro USB device/TT Connect S2-3600"
+	depends on DVB_USB
+	select TTPCI_EEPROM
+	select DVB_LNBP22 if !DVB_FE_CUSTOMISE
+	select DVB_STB0899 if !DVB_FE_CUSTOMISE
+	select DVB_STB6100 if !DVB_FE_CUSTOMISE
+	help
+	  Support for external USB adapter designed by Pinnacle,
+	  shipped under the brand name 'PCTV HDTV Pro USB'.
+	  Say Y if you own such a device and want to use it.
+
 config DVB_USB_AF9005_REMOTE
 	tristate "Afatech AF9005 default remote control support"
 	depends on DVB_USB_AF9005
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 4bac13d..2497694 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -73,6 +73,9 @@ obj-$(CONFIG_DVB_USB_DTV5100) += dvb-usb-dtv5100.o
 dvb-usb-af9015-objs = af9015.o
 obj-$(CONFIG_DVB_USB_AF9015) += dvb-usb-af9015.o
 
+dvb-usb-pctv452e-objs = pctv452e.o
+obj-$(CONFIG_DVB_USB_PCTV452E) += dvb-usb-pctv452e.o
+
 dvb-usb-cinergyT2-objs = cinergyT2-core.o cinergyT2-fe.o
 obj-$(CONFIG_DVB_USB_CINERGY_T2) += dvb-usb-cinergyT2.o
 
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 3a8b744..1c8a241 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -237,6 +237,9 @@
 #define USB_PID_PCTV_200E				0x020e
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222
+#define USB_PID_PCTV_452E				0x021f
+#define USB_PID_TECHNOTREND_CONNECT_S2_3600		0x3007
+#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI		0x300a
 #define USB_PID_NEBULA_DIGITV				0x0201
 #define USB_PID_DVICO_BLUEBIRD_LGDT			0xd820
 #define USB_PID_DVICO_BLUEBIRD_LG064F_COLD		0xd500
diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-usb/pctv452e.c
new file mode 100644
index 0000000..1be24e5
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -0,0 +1,1454 @@
+/*
+ * PCTV 452e DVB driver
+ *
+ * Copyright (c) 2006-2008 Dominik Kuhlen <dkuhlen@gmx.net>
+ *
+ * TT connect S2-3650-CI Common Interface support, MAC readout
+ * Copyright (C) 2008 Michael H. Schimek <mschimek@gmx.at>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+
+/* dvb usb framework */
+#define DVB_USB_LOG_PREFIX "pctv452e"
+#include "dvb-usb.h"
+
+/* Demodulator */
+#include "stb0899_drv.h"
+#include "stb0899_reg.h"
+/* Tuner */
+#include "stb6100.h"
+#include "stb6100_cfg.h"
+/* FE Power */
+#include "lnbp22.h"
+
+#include "dvb_ca_en50221.h"
+#include "ttpci-eeprom.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+#define ISO_BUF_COUNT      4
+#define FRAMES_PER_ISO_BUF 4
+#define ISO_FRAME_SIZE     940
+#define ISOC_INTERFACE_ALTERNATIVE 3
+
+#define SYNC_BYTE_OUT 0xaa
+#define SYNC_BYTE_IN  0x55
+
+/* guessed: (copied from ttusb-budget) */
+#define PCTV_CMD_RESET 0x15
+/* command to poll IR receiver */
+#define PCTV_CMD_IR    0x1b
+/* command to send I2C  */
+#define PCTV_CMD_I2C   0x31
+
+#define I2C_ADDR_STB0899 (0xd0 >> 1)
+#define I2C_ADDR_STB6100 (0xc0 >> 1)
+#define I2C_ADDR_LNBP22  (0x10 >> 1)
+#define I2C_ADDR_24C16   (0xa0 >> 1)
+#define I2C_ADDR_24C64   (0xa2 >> 1)
+
+
+/* pctv452e sends us this amount of data for each issued usb-command */
+#define PCTV_ANSWER_LEN 64
+/* Wait up to 1000ms for device  */
+#define PCTV_TIMEOUT 1000
+
+
+#define PCTV_LED_GPIO   STB0899_GPIO01
+#define PCTV_LED_GREEN  0x82
+#define PCTV_LED_ORANGE 0x02
+
+#define ci_dbg(format, arg...)				\
+do {							\
+	if (0)						\
+		printk (KERN_DEBUG DVB_USB_LOG_PREFIX	\
+			": " format "\n" , ## arg);	\
+} while (0)
+
+enum {
+	TT3650_CMD_CI_TEST = 0x40,
+	TT3650_CMD_CI_RD_CTRL,
+	TT3650_CMD_CI_WR_CTRL,
+	TT3650_CMD_CI_RD_ATTR,
+	TT3650_CMD_CI_WR_ATTR,
+	TT3650_CMD_CI_RESET,
+	TT3650_CMD_CI_SET_VIDEO_PORT
+};
+
+
+static struct stb0899_postproc pctv45e_postproc[] = {
+	{ PCTV_LED_GPIO, STB0899_GPIOPULLUP },
+	{ 0, 0 }
+};
+
+/*
+ * stores all private variables for communication with the PCTV452e DVB-S2
+ */
+struct pctv452e_state {
+	struct dvb_ca_en50221 ca;
+	struct mutex ca_mutex;
+
+	u8 c;	   /* transaction counter, wraps around...  */
+	u8 initialized; /* set to 1 if 0x15 has been sent */
+};
+
+static int
+tt3650_ci_msg			(struct dvb_usb_device *d,
+				 u8			cmd,
+				 u8 *			data,
+				 unsigned int		write_len,
+				 unsigned int		read_len)
+{
+	struct pctv452e_state *state = (struct pctv452e_state *) d->priv;
+	u8 buf[64];
+	u8 id;
+	unsigned int rlen;
+	int ret;
+
+	BUG_ON (NULL == data && 0 != (write_len | read_len));
+	BUG_ON (write_len > 64 - 4);
+	BUG_ON (read_len > 64 - 4);
+
+	id = state->c++;
+
+	buf[0] = SYNC_BYTE_OUT;
+	buf[1] = id;
+	buf[2] = cmd;
+	buf[3] = write_len;
+
+	memcpy (buf + 4, data, write_len);
+
+	rlen = (read_len > 0) ? 64 : 0;
+	ret = dvb_usb_generic_rw (d, buf, 4 + write_len,
+				  buf, rlen, /* delay_ms */ 0);
+	if (0 != ret)
+		goto failed;
+
+	ret = -EIO;
+	if (SYNC_BYTE_IN != buf[0] || id != buf[1])
+		goto failed;
+
+	memcpy (data, buf + 4, read_len);
+
+	return 0;
+
+ failed:
+	err ("CI error %d; %02X %02X %02X -> %02X %02X %02X.",
+	     ret, SYNC_BYTE_OUT, id, cmd, buf[0], buf[1], buf[2]);
+
+	return ret;
+}
+
+static int tt3650_ci_msg_locked(struct dvb_ca_en50221 *ca,
+				 u8			cmd,
+				 u8 *			data,
+				 unsigned int		write_len,
+				 unsigned int		read_len)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
+	int ret;
+
+	mutex_lock(&state->ca_mutex);
+	ret = tt3650_ci_msg(d, cmd, data, write_len, read_len);
+	mutex_unlock(&state->ca_mutex);
+
+	return ret;
+}
+
+static int tt3650_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 int			address)
+{
+	u8 buf[3];
+	int ret;
+
+	if (0 != slot)
+		return -EINVAL;
+
+	buf[0] = (address >> 8) & 0x0F;
+	buf[1] = address;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_ATTR, buf, 2, 3);
+
+	ci_dbg ("%s %04x -> %d 0x%02x",
+		__func__, address, ret, buf[2]);
+
+	if (ret < 0)
+		return ret;
+
+	return buf[2];
+}
+
+static int tt3650_ci_write_attribute_mem(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 int			address,
+				 u8			value)
+{
+	u8 buf[3];
+
+	ci_dbg("%s %d 0x%04x 0x%02x",
+		__func__, slot, address, value);
+
+	if (0 != slot)
+		return -EINVAL;
+
+	buf[0] = (address >> 8) & 0x0F;
+	buf[1] = address;
+	buf[2] = value;
+
+	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_ATTR, buf, 3, 3);
+}
+
+static int tt3650_ci_read_cam_control(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 u8			address)
+{
+	u8 buf[2];
+	int ret;
+
+	if (0 != slot)
+		return -EINVAL;
+
+	buf[0] = address & 3;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_CTRL, buf, 1, 2);
+
+	ci_dbg("%s 0x%02x -> %d 0x%02x",
+		__func__, address, ret, buf[1]);
+
+	if (ret < 0)
+		return ret;
+
+	return buf[1];
+}
+
+static int tt3650_ci_write_cam_control(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 u8			address,
+				 u8			value)
+{
+	u8 buf[2];
+
+	ci_dbg("%s %d 0x%02x 0x%02x",
+		__func__, slot, address, value);
+
+	if (0 != slot)
+		return -EINVAL;
+
+	buf[0] = address;
+	buf[1] = value;
+
+	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_CTRL, buf, 2, 2);
+}
+
+static int tt3650_ci_set_video_port(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 int			enable)
+{
+	u8 buf[1];
+	int ret;
+
+	ci_dbg("%s %d %d", __func__, slot, enable);
+
+	if (0 != slot)
+		return -EINVAL;
+
+	enable = !!enable;
+	buf[0] = enable;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
+	if (ret < 0)
+		return ret;
+
+	if (enable != buf[0]) {
+		err("CI not %sabled.", enable ? "en" : "dis");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int tt3650_ci_slot_shutdown(struct dvb_ca_en50221 *ca,
+				 int			slot)
+{
+	return tt3650_ci_set_video_port(ca, slot, /* enable */ 0);
+}
+
+static int tt3650_ci_slot_ts_enable(struct dvb_ca_en50221 *ca,
+				 int			slot)
+{
+	return tt3650_ci_set_video_port(ca, slot, /* enable */ 1);
+}
+
+static int tt3650_ci_slot_reset(struct dvb_ca_en50221 *ca,
+				 int			slot)
+{
+	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
+	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
+	u8 buf[1];
+	int ret;
+
+	ci_dbg ("%s %d", __func__, slot);
+
+	if (0 != slot)
+		return -EINVAL;
+
+	buf[0] = 0;
+
+	mutex_lock (&state->ca_mutex);
+
+	ret = tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
+	if (0 != ret)
+		goto failed;
+
+	msleep (500);
+
+	buf[0] = 1;
+
+	ret = tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
+	if (0 != ret)
+		goto failed;
+
+	msleep (500);
+
+	buf[0] = 0; /* FTA */
+
+	ret = tt3650_ci_msg(d, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
+
+ failed:
+	mutex_unlock (&state->ca_mutex);
+
+	return ret;
+}
+
+static int tt3650_ci_poll_slot_status(struct dvb_ca_en50221 *ca,
+				 int			slot,
+				 int			open)
+{
+	u8 buf[1];
+	int ret;
+
+	if (0 != slot)
+		return -EINVAL;
+
+	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_TEST, buf, 0, 1);
+	if (0 != ret)
+		return ret;
+
+	if (1 == buf[0]) {
+		return (DVB_CA_EN50221_POLL_CAM_PRESENT |
+			DVB_CA_EN50221_POLL_CAM_READY);
+	} else {
+		return 0;
+	}
+}
+
+static void tt3650_ci_uninit(struct dvb_usb_device *d)
+{
+	struct pctv452e_state *state;
+
+	ci_dbg("%s", __func__);
+
+	if (NULL == d)
+		return;
+
+	state = (struct pctv452e_state *)d->priv;
+	if (NULL == state)
+		return;
+
+	if (NULL == state->ca.data)
+		return;
+
+	/* Error ignored. */
+	tt3650_ci_set_video_port(&state->ca, /* slot */ 0, /* enable */ 0);
+
+	dvb_ca_en50221_release(&state->ca);
+
+	memset(&state->ca, 0, sizeof(state->ca));
+}
+
+static int tt3650_ci_init(struct dvb_usb_adapter *a)
+{
+	struct dvb_usb_device *d = a->dev;
+	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
+	int ret;
+
+	ci_dbg ("%s", __func__);
+
+	mutex_init(&state->ca_mutex);
+
+	state->ca.owner = THIS_MODULE;
+	state->ca.read_attribute_mem = tt3650_ci_read_attribute_mem;
+	state->ca.write_attribute_mem = tt3650_ci_write_attribute_mem;
+	state->ca.read_cam_control = tt3650_ci_read_cam_control;
+	state->ca.write_cam_control = tt3650_ci_write_cam_control;
+	state->ca.slot_reset = tt3650_ci_slot_reset;
+	state->ca.slot_shutdown = tt3650_ci_slot_shutdown;
+	state->ca.slot_ts_enable = tt3650_ci_slot_ts_enable;
+	state->ca.poll_slot_status = tt3650_ci_poll_slot_status;
+	state->ca.data = d;
+
+	ret = dvb_ca_en50221_init (&a->dvb_adap,
+				   &state->ca,
+				   /* flags */ 0,
+				   /* n_slots */ 1);
+	if (0 != ret) {
+		err ("Cannot initialize CI: Error %d.", ret);
+		memset (&state->ca, 0, sizeof (state->ca));
+		return ret;
+	}
+
+	info ("CI initialized.");
+
+	return 0;
+}
+
+  #define CMD_BUFFER_SIZE 0x28
+static int pctv452e_i2c_msg(struct dvb_usb_device *d, u8 addr, const u8 * snd_buf,
+				u8 snd_len, u8 * rcv_buf, u8 rcv_len) {
+	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
+	u8 buf[64];
+	u8 id;
+	int ret;
+
+	id = state->c++;
+
+	ret = -EINVAL;
+	if (snd_len > 64 - 7 || rcv_len > 64 - 7)
+		goto failed;
+
+	buf[0] = SYNC_BYTE_OUT;
+	buf[1] = id;
+	buf[2] = PCTV_CMD_I2C;
+	buf[3] = snd_len + 3;
+	buf[4] = addr << 1;
+	buf[5] = snd_len;
+	buf[6] = rcv_len;
+
+	memcpy (buf + 7, snd_buf, snd_len);
+
+	ret = dvb_usb_generic_rw (d, buf, 7 + snd_len,
+				  buf, /* rcv_len */ 64,
+				  /* delay_ms */ 0);
+	if (ret < 0)
+		goto failed;
+
+	/* TT USB protocol error. */
+	ret = -EIO;
+	if (SYNC_BYTE_IN != buf[0] || id != buf[1])
+		goto failed;
+
+	/* I2C device didn't respond as expected. */
+	ret = -EREMOTEIO;
+	if (buf[5] < snd_len || buf[6] < rcv_len)
+		goto failed;
+
+	memcpy (rcv_buf, buf + 7, rcv_len);
+
+	return rcv_len;
+
+ failed:
+	err ("I2C error %d; %02X %02X  %02X %02X %02X -> "
+	     "%02X %02X  %02X %02X %02X.",
+	     ret, SYNC_BYTE_OUT, id, addr << 1, snd_len, rcv_len,
+	     buf[0], buf[1], buf[4], buf[5], buf[6]);
+
+	return ret;
+}
+
+static int pctv452e_i2c_xfer(struct i2c_adapter* adapter, struct i2c_msg *msg, int num) {
+	struct dvb_usb_device *d= i2c_get_adapdata(adapter);
+	int i;
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	for (i = 0; i < num; i++) {
+		u8 addr, snd_len, rcv_len, *snd_buf, *rcv_buf;
+		int err;
+
+		if (msg[i].flags & I2C_M_RD) {
+			addr = msg[i].addr;
+			snd_buf = NULL;
+			snd_len = 0;
+			rcv_buf = msg[i].buf;
+			rcv_len = msg[i].len;
+		} else {
+			addr = msg[i].addr;
+			snd_buf = msg[i].buf;
+			snd_len = msg[i].len;
+			rcv_buf = NULL;
+			rcv_len = 0;
+		}
+
+		err = pctv452e_i2c_msg(d, addr, snd_buf, snd_len, rcv_buf, rcv_len);
+		if (err < rcv_len)
+			break;
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	return i;
+}
+
+static u32 pctv452e_i2c_func(struct i2c_adapter *adapter) {
+	return I2C_FUNC_I2C;
+}
+
+int pctv452e_power_ctrl(struct dvb_usb_device *d, int i) {
+	struct pctv452e_state *state = (struct pctv452e_state*)d->priv;
+	u8 b0[] = { 0xaa, 0, PCTV_CMD_RESET, 1, 0 };
+	u8 rx[PCTV_ANSWER_LEN];
+	int ret;
+		printk("%s: %d\n", __func__, i);
+	if (i) {
+		if (!state->initialized) {
+			// hmm where shoud this should go?
+			ret = usb_set_interface(d->udev, 0, ISOC_INTERFACE_ALTERNATIVE);
+			if (ret != 0) {
+				printk("%s: Warning set interface returned: %d\n", __func__, ret);
+			}
+
+			// this is a one-time initialization, dont know where to put
+			b0[1] = state->c++;
+			// reset board
+			if ((ret = dvb_usb_generic_rw(d, b0, sizeof(b0), rx, PCTV_ANSWER_LEN, 0))) return ret;
+
+			b0[1] = state->c++;
+			b0[4] = 1;
+			// reset board (again?)
+			if ((ret = dvb_usb_generic_rw(d, b0, sizeof(b0), rx, PCTV_ANSWER_LEN, 0))) return ret;
+
+			state->initialized = 1;
+		}
+	} else {
+		// power down ?
+	}
+	return 0;
+}
+
+/* Remote control stuff */
+static struct rc_map_table pctv452e_rc_keys[] = {
+	{0x0700, KEY_MUTE},
+	{0x0701, KEY_VENDOR},  // pinnacle logo (top middle)
+	{0x0739, KEY_POWER},
+	{0x0703, KEY_VOLUMEUP},
+	{0x0709, KEY_VOLUMEDOWN},
+	{0x0706, KEY_CHANNELUP},
+	{0x070c, KEY_CHANNELDOWN},
+	{0x070f, KEY_1},
+	{0x0715, KEY_2},
+	{0x0710, KEY_3},
+	{0x0718, KEY_4},
+	{0x071b, KEY_5},
+	{0x071e, KEY_6},
+	{0x0711, KEY_7},
+	{0x0721, KEY_8},
+	{0x0712, KEY_9},
+	{0x0727, KEY_0},
+	{0x0724, KEY_TV}, // left of '0'
+	{0x072a, KEY_T}, // right of '0'
+	{0x072d, KEY_REWIND},
+	{0x0733, KEY_FORWARD},
+	{0x0730, KEY_PLAY},
+	{0x0736, KEY_RECORD},
+	{0x073c, KEY_STOP},
+	{0x073f, KEY_HELP}
+};
+
+/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
+static struct rc_map_table tt_connect_s2_3600_rc_key[] = {
+	{0x1501, KEY_POWER},
+	{0x1502, KEY_SHUFFLE}, /* ? double-arrow key */
+	{0x1503, KEY_1},
+	{0x1504, KEY_2},
+	{0x1505, KEY_3},
+	{0x1506, KEY_4},
+	{0x1507, KEY_5},
+	{0x1508, KEY_6},
+	{0x1509, KEY_7},
+	{0x150a, KEY_8},
+	{0x150b, KEY_9},
+	{0x150c, KEY_0},
+	{0x150d, KEY_UP},
+	{0x150e, KEY_LEFT},
+	{0x150f, KEY_OK},
+	{0x1510, KEY_RIGHT},
+	{0x1511, KEY_DOWN},
+	{0x1512, KEY_INFO},
+	{0x1513, KEY_EXIT},
+	{0x1514, KEY_RED},
+	{0x1515, KEY_GREEN},
+	{0x1516, KEY_YELLOW},
+	{0x1517, KEY_BLUE},
+	{0x1518, KEY_MUTE},
+	{0x1519, KEY_TEXT},
+	{0x151a, KEY_MODE},  /* ? TV/Radio */
+	{0x1521, KEY_OPTION},
+	{0x1522, KEY_EPG},
+	{0x1523, KEY_CHANNELUP},
+	{0x1524, KEY_CHANNELDOWN},
+	{0x1525, KEY_VOLUMEUP},
+	{0x1526, KEY_VOLUMEDOWN},
+	{0x1527, KEY_SETUP},
+	{0x153a, KEY_RECORD},/* these keys are only in the black remote */
+	{0x153b, KEY_PLAY},
+	{0x153c, KEY_STOP},
+	{0x153d, KEY_REWIND},
+	{0x153e, KEY_PAUSE},
+	{0x153f, KEY_FORWARD}
+};
+
+static int pctv452e_rc_query(struct dvb_usb_device *d, u32 *keyevent, int *keystate) {
+	struct pctv452e_state *state = (struct pctv452e_state *)d->priv;
+	u8 b[CMD_BUFFER_SIZE];
+	u8 rx[PCTV_ANSWER_LEN];
+	u8 keybuf[5];
+	int ret, i;
+	u8 id = state->c++;
+
+	/* prepare command header  */
+	b[0] = SYNC_BYTE_OUT;
+	b[1] = id;
+	b[2] = PCTV_CMD_IR;
+	b[3] = 0;
+
+	*keystate = REMOTE_NO_KEY_PRESSED;
+
+	/* send ir request */
+	ret = dvb_usb_generic_rw(d, b, 4, rx, PCTV_ANSWER_LEN, 0);
+	if (ret != 0) return ret;
+
+	if (debug > 3) {
+		printk("%s: read: %2d: %02x %02x %02x: ", __func__, ret, rx[0], rx[1], rx[2]);
+		for (i = 0; (i < rx[3]) && ((i+3) < PCTV_ANSWER_LEN); i++) {
+			printk(" %02x", rx[i+3]);
+		}
+		printk("\n");
+	}
+
+	if ((rx[3] == 9) &&  (rx[12] & 0x01)) {
+		/* got a "press" event */
+		if (debug > 2) {
+	 		printk("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[6], rx[7]);
+		}
+		keybuf[0] = 0x01;// DVB_USB_RC_NEC_KEY_PRESSED; why is this #define'd privately?
+		keybuf[1] = rx[7];
+		keybuf[2] = ~keybuf[1]; // fake checksum
+		keybuf[3] = rx[6];
+		keybuf[4] = ~keybuf[3]; // fake checksum
+		dvb_usb_nec_rc_key_to_event(d, keybuf, keyevent, keystate);
+
+	}
+
+	return 0;
+}
+
+static int
+pctv452e_read_mac_address	(struct dvb_usb_device *d,
+				 u8			mac[6])
+{
+	const u8 mem_addr[] = { 0x1F, 0xCC };
+	u8 encoded_mac[20];
+	int ret;
+
+	ret = -EAGAIN;
+	if (mutex_lock_interruptible (&d->i2c_mutex) < 0)
+		goto failed;
+
+	ret = pctv452e_i2c_msg (d, I2C_ADDR_24C16,
+				mem_addr + 1, /* snd_len */ 1,
+				encoded_mac, /* rcv_len */ 20);
+	if (-EREMOTEIO == ret) {
+		/* Caution! A 24C16 interprets 0xA2 0x1F 0xCC as a
+		   byte write if /WC is low. */
+		ret = pctv452e_i2c_msg (d, I2C_ADDR_24C64,
+					mem_addr, 2,
+					encoded_mac, 20);
+	}
+
+	mutex_unlock (&d->i2c_mutex);
+
+	if (20 != ret)
+		goto failed;
+
+	ret = ttpci_eeprom_decode_mac (mac, encoded_mac);
+	if (0 != ret)
+		goto failed;
+
+	return 0;
+
+ failed:
+	memset (mac, 0, 6);
+
+	return ret;
+}
+
+
+static struct stb0899_config stb0899_config;
+static struct stb6100_config stb6100_config;
+static struct dvb_usb_device_properties pctv452e_properties;
+static struct dvb_usb_device_properties tt_connect_s2_3600_properties;
+
+int pctv452e_frontend_attach(struct dvb_usb_adapter *a) {
+	struct usb_device_id *id;
+
+		printk("%s Enter\n", __func__);
+
+	a->fe[0] = dvb_attach(stb0899_attach, &stb0899_config, &a->dev->i2c_adap);
+	if (!a->fe[0]) return -ENODEV;
+	if ((dvb_attach(lnbp22_attach, a->fe[0], &a->dev->i2c_adap)) == 0) {
+		printk("Warning: cannot attach lnbp22\n");
+	}
+
+	id = a->dev->desc->warm_ids[0];
+	if (USB_VID_TECHNOTREND == id->idVendor
+	    && USB_PID_TECHNOTREND_CONNECT_S2_3650_CI == id->idProduct) {
+		/* Error ignored. */
+		tt3650_ci_init (a);
+	}
+
+		printk("%s Leave Ok\n", __func__);
+	return 0;
+}
+
+int pctv452e_tuner_attach(struct dvb_usb_adapter *a) {
+		printk("%s Enter\n", __func__);
+	if (!a->fe[0]) return -ENODEV;
+	if (dvb_attach(stb6100_attach, a->fe[0], &stb6100_config, &a->dev->i2c_adap) == 0) {
+		printk("%s failed\n", __func__);
+		return -ENODEV;
+	}
+		printk("%s Leave\n", __func__);
+	return 0;
+}
+
+static void
+pctv452e_usb_disconnect		(struct usb_interface *	intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata (intf);
+
+	tt3650_ci_uninit (d);
+	dvb_usb_device_exit (intf);
+}
+
+static int pctv452e_usb_probe(struct usb_interface *intf,const struct usb_device_id *id) {
+	int ret=-ENOMEM;
+	if ((ret=dvb_usb_device_init(intf, &pctv452e_properties, THIS_MODULE, NULL, adapter_nr))==0){
+		return ret;
+	}
+	return dvb_usb_device_init(intf, &tt_connect_s2_3600_properties, THIS_MODULE, NULL, adapter_nr);
+}
+
+
+
+static const struct stb0899_s1_reg pctv452e_init_dev [] = {
+	{ STB0899_DISCNTRL1	, 0x26 },
+	{ STB0899_DISCNTRL2	, 0x80 },
+	{ STB0899_DISRX_ST0	, 0x04 },
+	{ STB0899_DISRX_ST1	, 0x20 },
+	{ STB0899_DISPARITY	, 0x00 },
+	{ STB0899_DISFIFO	, 0x00 },
+	{ STB0899_DISF22	, 0x99 },
+	{ STB0899_DISF22RX	, 0x85 }, // 0xa8
+	{ STB0899_ACRPRESC	, 0x11 },
+	{ STB0899_ACRDIV1	, 0x0a },
+	{ STB0899_ACRDIV2	, 0x05 },
+	{ STB0899_DACR1		, 0x00 },
+	{ STB0899_DACR2		, 0x00 },
+	{ STB0899_OUTCFG	, 0x00 },
+	{ STB0899_MODECFG	, 0x00 }, // Inversion
+ 	{ STB0899_IRQMSK_3	, 0xf3 },
+ 	{ STB0899_IRQMSK_2	, 0xfc },
+ 	{ STB0899_IRQMSK_1	, 0xff },
+ 	{ STB0899_IRQMSK_0	, 0xff },
+	{ STB0899_I2CCFG	, 0x88 },
+	{ STB0899_I2CRPT	, 0x58 },
+	{ STB0899_GPIO00CFG	, 0x82 },
+	{ STB0899_GPIO01CFG	, 0x82 }, /* 0x02 -> LED green 0x82 -> LED orange */
+	{ STB0899_GPIO02CFG	, 0x82 },
+	{ STB0899_GPIO03CFG	, 0x82 },
+	{ STB0899_GPIO04CFG	, 0x82 },
+	{ STB0899_GPIO05CFG	, 0x82 },
+	{ STB0899_GPIO06CFG	, 0x82 },
+	{ STB0899_GPIO07CFG	, 0x82 },
+	{ STB0899_GPIO08CFG	, 0x82 },
+	{ STB0899_GPIO09CFG	, 0x82 },
+	{ STB0899_GPIO10CFG	, 0x82 },
+	{ STB0899_GPIO11CFG	, 0x82 },
+	{ STB0899_GPIO12CFG	, 0x82 },
+	{ STB0899_GPIO13CFG	, 0x82 },
+	{ STB0899_GPIO14CFG	, 0x82 },
+	{ STB0899_GPIO15CFG	, 0x82 },
+	{ STB0899_GPIO16CFG	, 0x82 },
+	{ STB0899_GPIO17CFG	, 0x82 },
+	{ STB0899_GPIO18CFG	, 0x82 },
+	{ STB0899_GPIO19CFG	, 0x82 },
+	{ STB0899_GPIO20CFG	, 0x82 },
+	{ STB0899_SDATCFG	, 0xb8 },
+	{ STB0899_SCLTCFG	, 0xba },
+	{ STB0899_AGCRFCFG	, 0x1c }, // 0x11 DVB-S; 0x1c DVB-S2 (1c, rjkm)
+	{ STB0899_GPIO22	, 0x82 },
+	{ STB0899_GPIO21	, 0x91 },
+	{ STB0899_DIRCLKCFG	, 0x82 },
+	{ STB0899_CLKOUT27CFG	, 0x7e },
+	{ STB0899_STDBYCFG	, 0x82 },
+	{ STB0899_CS0CFG	, 0x82 },
+	{ STB0899_CS1CFG	, 0x82 },
+	{ STB0899_DISEQCOCFG	, 0x20 },
+	{ STB0899_NCOARSE	, 0x15 }, // 0x15 = 27 Mhz Clock, F/3 = 198MHz, F/6 = 108MHz
+	{ STB0899_SYNTCTRL	, 0x00 }, // 0x00 = CLK from CLKI, 0x02 = CLK from XTALI
+	{ STB0899_FILTCTRL	, 0x00 },
+	{ STB0899_SYSCTRL	, 0x00 },
+	{ STB0899_STOPCLK1	, 0x20 }, // orig: 0x00 budget-ci: 0x20
+	{ STB0899_STOPCLK2	, 0x00 },
+	{ STB0899_INTBUFCTRL	, 0x0a },
+	{ STB0899_AGC2I1	, 0x00 },
+	{ STB0899_AGC2I2	, 0x00 },
+	{ STB0899_AGCIQIN       , 0x00 },
+	{ STB0899_TSTRES	, 0x40 }, //rjkm
+	{0xffff, 0xff},
+};
+
+static const struct stb0899_s2_reg pctv452e_init_s2_demod[]  = {
+	{ STB0899_OFF0_DMD_STATUS	, STB0899_BASE_DMD_STATUS	, 0x00000103 },	/* DMDSTATUS	*/
+	{ STB0899_OFF0_CRL_FREQ		, STB0899_BASE_CRL_FREQ		, 0x3ed1da56 },	/* CRLFREQ	*/
+	{ STB0899_OFF0_BTR_FREQ		, STB0899_BASE_BTR_FREQ		, 0x00004000 },	/* BTRFREQ	*/
+	{ STB0899_OFF0_IF_AGC_GAIN	, STB0899_BASE_IF_AGC_GAIN	, 0x00002ade },	/* IFAGCGAIN	*/
+	{ STB0899_OFF0_BB_AGC_GAIN	, STB0899_BASE_BB_AGC_GAIN	, 0x000001bc },	/* BBAGCGAIN	*/
+	{ STB0899_OFF0_DC_OFFSET	, STB0899_BASE_DC_OFFSET	, 0x00000200 },	/* DCOFFSET	*/
+	{ STB0899_OFF0_DMD_CNTRL	, STB0899_BASE_DMD_CNTRL	, 0x0000000f },	/* DMDCNTRL	*/
+
+	{ STB0899_OFF0_IF_AGC_CNTRL	, STB0899_BASE_IF_AGC_CNTRL	, 0x03fb4a20 },	/* IFAGCCNTRL	*/
+	{ STB0899_OFF0_BB_AGC_CNTRL	, STB0899_BASE_BB_AGC_CNTRL	, 0x00200c97 },	/* BBAGCCNTRL	*/
+
+	{ STB0899_OFF0_CRL_CNTRL	, STB0899_BASE_CRL_CNTRL	, 0x00000016 },	/* CRLCNTRL	*/
+	{ STB0899_OFF0_CRL_PHS_INIT	, STB0899_BASE_CRL_PHS_INIT	, 0x00000000 },	/* CRLPHSINIT	*/
+	{ STB0899_OFF0_CRL_FREQ_INIT	, STB0899_BASE_CRL_FREQ_INIT	, 0x00000000 },	/* CRLFREQINIT	*/
+	{ STB0899_OFF0_CRL_LOOP_GAIN	, STB0899_BASE_CRL_LOOP_GAIN	, 0x00000000 },	/* CRLLOOPGAIN	*/
+	{ STB0899_OFF0_CRL_NOM_FREQ	, STB0899_BASE_CRL_NOM_FREQ	, 0x3ed097b6 },	/* CRLNOMFREQ	*/
+	{ STB0899_OFF0_CRL_SWP_RATE	, STB0899_BASE_CRL_SWP_RATE	, 0x00000000 },	/* CRLSWPRATE	*/
+	{ STB0899_OFF0_CRL_MAX_SWP	, STB0899_BASE_CRL_MAX_SWP	, 0x00000000 },	/* CRLMAXSWP	*/
+	{ STB0899_OFF0_CRL_LK_CNTRL	, STB0899_BASE_CRL_LK_CNTRL	, 0x0f6cdc01 },	/* CRLLKCNTRL	*/
+	{ STB0899_OFF0_DECIM_CNTRL	, STB0899_BASE_DECIM_CNTRL	, 0x00000000 },	/* DECIMCNTRL	*/
+	{ STB0899_OFF0_BTR_CNTRL	, STB0899_BASE_BTR_CNTRL	, 0x00003993 },	/* BTRCNTRL	*/
+	{ STB0899_OFF0_BTR_LOOP_GAIN	, STB0899_BASE_BTR_LOOP_GAIN	, 0x000d3c6f },	/* BTRLOOPGAIN	*/
+	{ STB0899_OFF0_BTR_PHS_INIT	, STB0899_BASE_BTR_PHS_INIT	, 0x00000000 },	/* BTRPHSINIT	*/
+	{ STB0899_OFF0_BTR_FREQ_INIT	, STB0899_BASE_BTR_FREQ_INIT	, 0x00000000 },	/* BTRFREQINIT	*/
+	{ STB0899_OFF0_BTR_NOM_FREQ	, STB0899_BASE_BTR_NOM_FREQ	, 0x0238e38e },	/* BTRNOMFREQ	*/
+	{ STB0899_OFF0_BTR_LK_CNTRL	, STB0899_BASE_BTR_LK_CNTRL	, 0x00000000 },	/* BTRLKCNTRL	*/
+	{ STB0899_OFF0_DECN_CNTRL	, STB0899_BASE_DECN_CNTRL	, 0x00000000 },	/* DECNCNTRL	*/
+	{ STB0899_OFF0_TP_CNTRL		, STB0899_BASE_TP_CNTRL		, 0x00000000 },	/* TPCNTRL	*/
+	{ STB0899_OFF0_TP_BUF_STATUS	, STB0899_BASE_TP_BUF_STATUS	, 0x00000000 },	/* TPBUFSTATUS	*/
+	{ STB0899_OFF0_DC_ESTIM		, STB0899_BASE_DC_ESTIM		, 0x00000000 },	/* DCESTIM	*/
+	{ STB0899_OFF0_FLL_CNTRL	, STB0899_BASE_FLL_CNTRL	, 0x00000000 },	/* FLLCNTRL	*/
+	{ STB0899_OFF0_FLL_FREQ_WD	, STB0899_BASE_FLL_FREQ_WD	, 0x40070000 },	/* FLLFREQWD	*/
+	{ STB0899_OFF0_ANTI_ALIAS_SEL	, STB0899_BASE_ANTI_ALIAS_SEL	, 0x00000001 },	/* ANTIALIASSEL */
+	{ STB0899_OFF0_RRC_ALPHA	, STB0899_BASE_RRC_ALPHA	, 0x00000002 },	/* RRCALPHA	*/
+	{ STB0899_OFF0_DC_ADAPT_LSHFT	, STB0899_BASE_DC_ADAPT_LSHFT	, 0x00000000 },	/* DCADAPTISHFT */
+	{ STB0899_OFF0_IMB_OFFSET	, STB0899_BASE_IMB_OFFSET	, 0x0000fe01 },	/* IMBOFFSET	*/
+	{ STB0899_OFF0_IMB_ESTIMATE	, STB0899_BASE_IMB_ESTIMATE	, 0x00000000 },	/* IMBESTIMATE	*/
+	{ STB0899_OFF0_IMB_CNTRL	, STB0899_BASE_IMB_CNTRL	, 0x00000001 },	/* IMBCNTRL	*/
+	{ STB0899_OFF0_IF_AGC_CNTRL2	, STB0899_BASE_IF_AGC_CNTRL2	, 0x00005007 },	/* IFAGCCNTRL2	*/
+	{ STB0899_OFF0_DMD_CNTRL2	, STB0899_BASE_DMD_CNTRL2	, 0x00000002 },	/* DMDCNTRL2	*/
+	{ STB0899_OFF0_TP_BUFFER	, STB0899_BASE_TP_BUFFER	, 0x00000000 },	/* TPBUFFER	*/
+	{ STB0899_OFF0_TP_BUFFER1	, STB0899_BASE_TP_BUFFER1	, 0x00000000 },	/* TPBUFFER1	*/
+	{ STB0899_OFF0_TP_BUFFER2	, STB0899_BASE_TP_BUFFER2	, 0x00000000 },	/* TPBUFFER2	*/
+	{ STB0899_OFF0_TP_BUFFER3	, STB0899_BASE_TP_BUFFER3	, 0x00000000 },	/* TPBUFFER3	*/
+	{ STB0899_OFF0_TP_BUFFER4	, STB0899_BASE_TP_BUFFER4	, 0x00000000 },	/* TPBUFFER4	*/
+	{ STB0899_OFF0_TP_BUFFER5	, STB0899_BASE_TP_BUFFER5	, 0x00000000 },	/* TPBUFFER5	*/
+	{ STB0899_OFF0_TP_BUFFER6	, STB0899_BASE_TP_BUFFER6	, 0x00000000 },	/* TPBUFFER6	*/
+	{ STB0899_OFF0_TP_BUFFER7	, STB0899_BASE_TP_BUFFER7	, 0x00000000 },	/* TPBUFFER7	*/
+	{ STB0899_OFF0_TP_BUFFER8	, STB0899_BASE_TP_BUFFER8	, 0x00000000 },	/* TPBUFFER8	*/
+	{ STB0899_OFF0_TP_BUFFER9	, STB0899_BASE_TP_BUFFER9	, 0x00000000 },	/* TPBUFFER9	*/
+	{ STB0899_OFF0_TP_BUFFER10	, STB0899_BASE_TP_BUFFER10	, 0x00000000 },	/* TPBUFFER10	*/
+	{ STB0899_OFF0_TP_BUFFER11	, STB0899_BASE_TP_BUFFER11	, 0x00000000 },	/* TPBUFFER11	*/
+	{ STB0899_OFF0_TP_BUFFER12	, STB0899_BASE_TP_BUFFER12	, 0x00000000 },	/* TPBUFFER12	*/
+	{ STB0899_OFF0_TP_BUFFER13	, STB0899_BASE_TP_BUFFER13	, 0x00000000 },	/* TPBUFFER13	*/
+	{ STB0899_OFF0_TP_BUFFER14	, STB0899_BASE_TP_BUFFER14	, 0x00000000 },	/* TPBUFFER14	*/
+	{ STB0899_OFF0_TP_BUFFER15	, STB0899_BASE_TP_BUFFER15	, 0x00000000 },	/* TPBUFFER15	*/
+	{ STB0899_OFF0_TP_BUFFER16	, STB0899_BASE_TP_BUFFER16	, 0x0000ff00 },	/* TPBUFFER16	*/
+	{ STB0899_OFF0_TP_BUFFER17	, STB0899_BASE_TP_BUFFER17	, 0x00000100 },	/* TPBUFFER17	*/
+	{ STB0899_OFF0_TP_BUFFER18	, STB0899_BASE_TP_BUFFER18	, 0x0000fe01 },	/* TPBUFFER18	*/
+	{ STB0899_OFF0_TP_BUFFER19	, STB0899_BASE_TP_BUFFER19	, 0x000004fe },	/* TPBUFFER19	*/
+	{ STB0899_OFF0_TP_BUFFER20	, STB0899_BASE_TP_BUFFER20	, 0x0000cfe7 },	/* TPBUFFER20	*/
+	{ STB0899_OFF0_TP_BUFFER21	, STB0899_BASE_TP_BUFFER21	, 0x0000bec6 },	/* TPBUFFER21	*/
+	{ STB0899_OFF0_TP_BUFFER22	, STB0899_BASE_TP_BUFFER22	, 0x0000c2bf },	/* TPBUFFER22	*/
+	{ STB0899_OFF0_TP_BUFFER23	, STB0899_BASE_TP_BUFFER23	, 0x0000c1c1 },	/* TPBUFFER23	*/
+	{ STB0899_OFF0_TP_BUFFER24	, STB0899_BASE_TP_BUFFER24	, 0x0000c1c1 },	/* TPBUFFER24	*/
+	{ STB0899_OFF0_TP_BUFFER25	, STB0899_BASE_TP_BUFFER25	, 0x0000c1c1 },	/* TPBUFFER25	*/
+	{ STB0899_OFF0_TP_BUFFER26	, STB0899_BASE_TP_BUFFER26	, 0x0000c1c1 },	/* TPBUFFER26	*/
+	{ STB0899_OFF0_TP_BUFFER27	, STB0899_BASE_TP_BUFFER27	, 0x0000c1c0 },	/* TPBUFFER27	*/
+	{ STB0899_OFF0_TP_BUFFER28	, STB0899_BASE_TP_BUFFER28	, 0x0000c0c0 },	/* TPBUFFER28	*/
+	{ STB0899_OFF0_TP_BUFFER29	, STB0899_BASE_TP_BUFFER29	, 0x0000c1c1 },	/* TPBUFFER29	*/
+	{ STB0899_OFF0_TP_BUFFER30	, STB0899_BASE_TP_BUFFER30	, 0x0000c1c1 },	/* TPBUFFER30	*/
+	{ STB0899_OFF0_TP_BUFFER31	, STB0899_BASE_TP_BUFFER31	, 0x0000c0c1 },	/* TPBUFFER31	*/
+	{ STB0899_OFF0_TP_BUFFER32	, STB0899_BASE_TP_BUFFER32	, 0x0000c0c1 },	/* TPBUFFER32	*/
+	{ STB0899_OFF0_TP_BUFFER33	, STB0899_BASE_TP_BUFFER33	, 0x0000c1c1 },	/* TPBUFFER33	*/
+	{ STB0899_OFF0_TP_BUFFER34	, STB0899_BASE_TP_BUFFER34	, 0x0000c1c1 },	/* TPBUFFER34	*/
+	{ STB0899_OFF0_TP_BUFFER35	, STB0899_BASE_TP_BUFFER35	, 0x0000c0c1 },	/* TPBUFFER35	*/
+	{ STB0899_OFF0_TP_BUFFER36	, STB0899_BASE_TP_BUFFER36	, 0x0000c1c1 },	/* TPBUFFER36	*/
+	{ STB0899_OFF0_TP_BUFFER37	, STB0899_BASE_TP_BUFFER37	, 0x0000c0c1 },	/* TPBUFFER37	*/
+	{ STB0899_OFF0_TP_BUFFER38	, STB0899_BASE_TP_BUFFER38	, 0x0000c1c1 },	/* TPBUFFER38	*/
+	{ STB0899_OFF0_TP_BUFFER39	, STB0899_BASE_TP_BUFFER39	, 0x0000c0c0 },	/* TPBUFFER39	*/
+	{ STB0899_OFF0_TP_BUFFER40	, STB0899_BASE_TP_BUFFER40	, 0x0000c1c0 },	/* TPBUFFER40	*/
+	{ STB0899_OFF0_TP_BUFFER41	, STB0899_BASE_TP_BUFFER41	, 0x0000c1c1 },	/* TPBUFFER41	*/
+	{ STB0899_OFF0_TP_BUFFER42	, STB0899_BASE_TP_BUFFER42	, 0x0000c0c0 },	/* TPBUFFER42	*/
+	{ STB0899_OFF0_TP_BUFFER43	, STB0899_BASE_TP_BUFFER43	, 0x0000c1c0 },	/* TPBUFFER43	*/
+	{ STB0899_OFF0_TP_BUFFER44	, STB0899_BASE_TP_BUFFER44	, 0x0000c0c1 },	/* TPBUFFER44	*/
+	{ STB0899_OFF0_TP_BUFFER45	, STB0899_BASE_TP_BUFFER45	, 0x0000c1be },	/* TPBUFFER45	*/
+	{ STB0899_OFF0_TP_BUFFER46	, STB0899_BASE_TP_BUFFER46	, 0x0000c1c9 },	/* TPBUFFER46	*/
+	{ STB0899_OFF0_TP_BUFFER47	, STB0899_BASE_TP_BUFFER47	, 0x0000c0da },	/* TPBUFFER47	*/
+	{ STB0899_OFF0_TP_BUFFER48	, STB0899_BASE_TP_BUFFER48	, 0x0000c0ba },	/* TPBUFFER48	*/
+	{ STB0899_OFF0_TP_BUFFER49	, STB0899_BASE_TP_BUFFER49	, 0x0000c1c4 },	/* TPBUFFER49	*/
+	{ STB0899_OFF0_TP_BUFFER50	, STB0899_BASE_TP_BUFFER50	, 0x0000c1bf },	/* TPBUFFER50	*/
+	{ STB0899_OFF0_TP_BUFFER51	, STB0899_BASE_TP_BUFFER51	, 0x0000c0c1 },	/* TPBUFFER51	*/
+	{ STB0899_OFF0_TP_BUFFER52	, STB0899_BASE_TP_BUFFER52	, 0x0000c1c0 },	/* TPBUFFER52	*/
+	{ STB0899_OFF0_TP_BUFFER53	, STB0899_BASE_TP_BUFFER53	, 0x0000c0c1 },	/* TPBUFFER53	*/
+	{ STB0899_OFF0_TP_BUFFER54	, STB0899_BASE_TP_BUFFER54	, 0x0000c1c1 },	/* TPBUFFER54	*/
+	{ STB0899_OFF0_TP_BUFFER55	, STB0899_BASE_TP_BUFFER55	, 0x0000c1c1 },	/* TPBUFFER55	*/
+	{ STB0899_OFF0_TP_BUFFER56	, STB0899_BASE_TP_BUFFER56	, 0x0000c1c1 },	/* TPBUFFER56	*/
+	{ STB0899_OFF0_TP_BUFFER57	, STB0899_BASE_TP_BUFFER57	, 0x0000c1c1 },	/* TPBUFFER57	*/
+	{ STB0899_OFF0_TP_BUFFER58	, STB0899_BASE_TP_BUFFER58	, 0x0000c1c1 },	/* TPBUFFER58	*/
+	{ STB0899_OFF0_TP_BUFFER59	, STB0899_BASE_TP_BUFFER59	, 0x0000c1c1 },	/* TPBUFFER59	*/
+	{ STB0899_OFF0_TP_BUFFER60	, STB0899_BASE_TP_BUFFER60	, 0x0000c1c1 },	/* TPBUFFER60	*/
+	{ STB0899_OFF0_TP_BUFFER61	, STB0899_BASE_TP_BUFFER61	, 0x0000c1c1 },	/* TPBUFFER61	*/
+	{ STB0899_OFF0_TP_BUFFER62	, STB0899_BASE_TP_BUFFER62	, 0x0000c1c1 },	/* TPBUFFER62	*/
+	{ STB0899_OFF0_TP_BUFFER63	, STB0899_BASE_TP_BUFFER63	, 0x0000c1c0 },	/* TPBUFFER63	*/
+	{ STB0899_OFF0_RESET_CNTRL	, STB0899_BASE_RESET_CNTRL	, 0x00000001 },	/* RESETCNTRL	*/
+	{ STB0899_OFF0_ACM_ENABLE	, STB0899_BASE_ACM_ENABLE	, 0x00005654 },	/* ACMENABLE	*/
+	{ STB0899_OFF0_DESCR_CNTRL	, STB0899_BASE_DESCR_CNTRL	, 0x00000000 },	/* DESCRCNTRL	*/
+	{ STB0899_OFF0_CSM_CNTRL1	, STB0899_BASE_CSM_CNTRL1	, 0x00020019 },	/* CSMCNTRL1	*/
+	{ STB0899_OFF0_CSM_CNTRL2	, STB0899_BASE_CSM_CNTRL2	, 0x004b3237 },	/* CSMCNTRL2	*/
+	{ STB0899_OFF0_CSM_CNTRL3	, STB0899_BASE_CSM_CNTRL3	, 0x0003dd17 },	/* CSMCNTRL3	*/
+	{ STB0899_OFF0_CSM_CNTRL4	, STB0899_BASE_CSM_CNTRL4	, 0x00008008 },	/* CSMCNTRL4	*/
+	{ STB0899_OFF0_UWP_CNTRL1	, STB0899_BASE_UWP_CNTRL1	, 0x002a3106 },	/* UWPCNTRL1	*/
+	{ STB0899_OFF0_UWP_CNTRL2	, STB0899_BASE_UWP_CNTRL2	, 0x0006140a },	/* UWPCNTRL2	*/
+	{ STB0899_OFF0_UWP_STAT1	, STB0899_BASE_UWP_STAT1	, 0x00008000 },	/* UWPSTAT1	*/
+	{ STB0899_OFF0_UWP_STAT2	, STB0899_BASE_UWP_STAT2	, 0x00000000 },	/* UWPSTAT2	*/
+	{ STB0899_OFF0_DMD_STAT2	, STB0899_BASE_DMD_STAT2	, 0x00000000 },	/* DMDSTAT2	*/
+	{ STB0899_OFF0_FREQ_ADJ_SCALE	, STB0899_BASE_FREQ_ADJ_SCALE	, 0x00000471 },	/* FREQADJSCALE */
+	{ STB0899_OFF0_UWP_CNTRL3	, STB0899_BASE_UWP_CNTRL3	, 0x017b0465 },	/* UWPCNTRL3	*/
+	{ STB0899_OFF0_SYM_CLK_SEL	, STB0899_BASE_SYM_CLK_SEL	, 0x00000002 },	/* SYMCLKSEL	*/
+	{ STB0899_OFF0_SOF_SRCH_TO	, STB0899_BASE_SOF_SRCH_TO	, 0x00196464 },	/* SOFSRCHTO	*/
+	{ STB0899_OFF0_ACQ_CNTRL1	, STB0899_BASE_ACQ_CNTRL1	, 0x00000603 },	/* ACQCNTRL1	*/
+	{ STB0899_OFF0_ACQ_CNTRL2	, STB0899_BASE_ACQ_CNTRL2	, 0x02046666 },	/* ACQCNTRL2	*/
+	{ STB0899_OFF0_ACQ_CNTRL3	, STB0899_BASE_ACQ_CNTRL3	, 0x10046583 },	/* ACQCNTRL3	*/
+	{ STB0899_OFF0_FE_SETTLE	, STB0899_BASE_FE_SETTLE	, 0x00010404 },	/* FESETTLE	*/
+	{ STB0899_OFF0_AC_DWELL		, STB0899_BASE_AC_DWELL		, 0x0002aa8a },	/* ACDWELL	*/
+	{ STB0899_OFF0_ACQUIRE_TRIG	, STB0899_BASE_ACQUIRE_TRIG	, 0x00000000 },	/* ACQUIRETRIG	*/
+	{ STB0899_OFF0_LOCK_LOST	, STB0899_BASE_LOCK_LOST	, 0x00000001 },	/* LOCKLOST	*/
+	{ STB0899_OFF0_ACQ_STAT1	, STB0899_BASE_ACQ_STAT1	, 0x00000500 },	/* ACQSTAT1	*/
+	{ STB0899_OFF0_ACQ_TIMEOUT	, STB0899_BASE_ACQ_TIMEOUT	, 0x0028a0a0 },	/* ACQTIMEOUT	*/
+	{ STB0899_OFF0_ACQ_TIME		, STB0899_BASE_ACQ_TIME		, 0x00000000 },	/* ACQTIME	*/
+	{ STB0899_OFF0_FINAL_AGC_CNTRL	, STB0899_BASE_FINAL_AGC_CNTRL	, 0x00800c17 },	/* FINALAGCCNTRL*/
+	{ STB0899_OFF0_FINAL_AGC_GAIN	, STB0899_BASE_FINAL_AGC_GAIN	, 0x00000000 },	/* FINALAGCCGAIN*/
+	{ STB0899_OFF0_EQUALIZER_INIT	, STB0899_BASE_EQUALIZER_INIT	, 0x00000000 },	/* EQUILIZERINIT*/
+	{ STB0899_OFF0_EQ_CNTRL		, STB0899_BASE_EQ_CNTRL		, 0x00054802 },	/* EQCNTL	*/
+	{ STB0899_OFF0_EQ_I_INIT_COEFF_0, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF0 */
+	{ STB0899_OFF1_EQ_I_INIT_COEFF_1, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF1 */
+	{ STB0899_OFF2_EQ_I_INIT_COEFF_2, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF2 */
+	{ STB0899_OFF3_EQ_I_INIT_COEFF_3, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF3 */
+	{ STB0899_OFF4_EQ_I_INIT_COEFF_4, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF4 */
+	{ STB0899_OFF5_EQ_I_INIT_COEFF_5, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000400 },	/* EQIINITCOEFF5 */
+	{ STB0899_OFF6_EQ_I_INIT_COEFF_6, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF6 */
+	{ STB0899_OFF7_EQ_I_INIT_COEFF_7, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF7 */
+	{ STB0899_OFF8_EQ_I_INIT_COEFF_8, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF8 */
+	{ STB0899_OFF9_EQ_I_INIT_COEFF_9, STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF9 */
+	{ STB0899_OFFa_EQ_I_INIT_COEFF_10,STB0899_BASE_EQ_I_INIT_COEFF_N, 0x00000000 },	/* EQIINITCOEFF10*/
+	{ STB0899_OFF0_EQ_Q_INIT_COEFF_0, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF0 */
+	{ STB0899_OFF1_EQ_Q_INIT_COEFF_1, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF1 */
+	{ STB0899_OFF2_EQ_Q_INIT_COEFF_2, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF2 */
+	{ STB0899_OFF3_EQ_Q_INIT_COEFF_3, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF3 */
+	{ STB0899_OFF4_EQ_Q_INIT_COEFF_4, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF4 */
+	{ STB0899_OFF5_EQ_Q_INIT_COEFF_5, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF5 */
+	{ STB0899_OFF6_EQ_Q_INIT_COEFF_6, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF6 */
+	{ STB0899_OFF7_EQ_Q_INIT_COEFF_7, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF7 */
+	{ STB0899_OFF8_EQ_Q_INIT_COEFF_8, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF8 */
+	{ STB0899_OFF9_EQ_Q_INIT_COEFF_9, STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF9 */
+	{ STB0899_OFFa_EQ_Q_INIT_COEFF_10,STB0899_BASE_EQ_Q_INIT_COEFF_N, 0x00000000 },	/* EQQINITCOEFF10*/
+	{ STB0899_OFF0_EQ_I_OUT_COEFF_0	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT0 */
+	{ STB0899_OFF1_EQ_I_OUT_COEFF_1	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT1 */
+	{ STB0899_OFF2_EQ_I_OUT_COEFF_2	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT2 */
+	{ STB0899_OFF3_EQ_I_OUT_COEFF_3	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT3 */
+	{ STB0899_OFF4_EQ_I_OUT_COEFF_4	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT4 */
+	{ STB0899_OFF5_EQ_I_OUT_COEFF_5	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT5 */
+	{ STB0899_OFF6_EQ_I_OUT_COEFF_6	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT6 */
+	{ STB0899_OFF7_EQ_I_OUT_COEFF_7	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT7 */
+	{ STB0899_OFF8_EQ_I_OUT_COEFF_8	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT8 */
+	{ STB0899_OFF9_EQ_I_OUT_COEFF_9	, STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT9 */
+	{ STB0899_OFFa_EQ_I_OUT_COEFF_10,STB0899_BASE_EQ_I_OUT_COEFF_N	, 0x00000000 }, /* EQICOEFFSOUT10*/
+	{ STB0899_OFF0_EQ_Q_OUT_COEFF_0	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT0 */
+	{ STB0899_OFF1_EQ_Q_OUT_COEFF_1	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT1 */
+	{ STB0899_OFF2_EQ_Q_OUT_COEFF_2	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT2 */
+	{ STB0899_OFF3_EQ_Q_OUT_COEFF_3	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT3 */
+	{ STB0899_OFF4_EQ_Q_OUT_COEFF_4	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT4 */
+	{ STB0899_OFF5_EQ_Q_OUT_COEFF_5	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT5 */
+	{ STB0899_OFF6_EQ_Q_OUT_COEFF_6 , STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT6 */
+	{ STB0899_OFF7_EQ_Q_OUT_COEFF_7	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT7 */
+	{ STB0899_OFF8_EQ_Q_OUT_COEFF_8	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT8 */
+	{ STB0899_OFF9_EQ_Q_OUT_COEFF_9	, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT9 */
+	{ STB0899_OFFa_EQ_Q_OUT_COEFF_10, STB0899_BASE_EQ_Q_OUT_COEFF_N	, 0x00000000 },	/* EQQCOEFFSOUT10*/
+	{ 0xffff			, 0xffffffff		    , 0xffffffff },
+};
+
+static const struct stb0899_s1_reg pctv452e_init_s1_demod[] = {
+	{ STB0899_DEMOD			, 0x00 },
+	{ STB0899_RCOMPC		, 0xc9 },
+	{ STB0899_AGC1CN		, 0x01 },
+	{ STB0899_AGC1REF		, 0x10 },
+	{ STB0899_RTC			, 0x23 },
+	{ STB0899_TMGCFG		, 0x4e },
+	{ STB0899_AGC2REF		, 0x34 },
+	{ STB0899_TLSR			, 0x84 },
+	{ STB0899_CFD			, 0xf7 },
+	{ STB0899_ACLC			, 0x87 },
+	{ STB0899_BCLC			, 0x94 },
+	{ STB0899_EQON			, 0x41 },
+	{ STB0899_LDT			, 0xf1 },
+	{ STB0899_LDT2			, 0xe3 },
+	{ STB0899_EQUALREF		, 0xb4 },
+	{ STB0899_TMGRAMP		, 0x10 },
+	{ STB0899_TMGTHD		, 0x30 },
+	{ STB0899_IDCCOMP		, 0xfd },
+	{ STB0899_QDCCOMP		, 0xff },
+	{ STB0899_POWERI		, 0x0c },
+	{ STB0899_POWERQ		, 0x0f },
+	{ STB0899_RCOMP			, 0x6c },
+	{ STB0899_AGCIQIN		, 0x80 },
+	{ STB0899_AGC2I1		, 0x06 },
+	{ STB0899_AGC2I2		, 0x00 },
+	{ STB0899_TLIR			, 0x30 },
+	{ STB0899_RTF			, 0x7f },
+	{ STB0899_DSTATUS		, 0x00 },
+	{ STB0899_LDI			, 0xbc },
+	{ STB0899_CFRM			, 0xea },
+	{ STB0899_CFRL			, 0x31 },
+	{ STB0899_NIRM			, 0x2b },
+	{ STB0899_NIRL			, 0x80 },
+	{ STB0899_ISYMB			, 0x1d },
+	{ STB0899_QSYMB			, 0xa6 },
+	{ STB0899_SFRH			, 0x2f },
+	{ STB0899_SFRM			, 0x68 },
+	{ STB0899_SFRL			, 0x40 },
+	{ STB0899_SFRUPH		, 0x2f },
+	{ STB0899_SFRUPM		, 0x68 },
+	{ STB0899_SFRUPL		, 0x40 },
+	{ STB0899_EQUAI1		, 0x02 },
+	{ STB0899_EQUAQ1		, 0xff },
+	{ STB0899_EQUAI2		, 0x04 },
+	{ STB0899_EQUAQ2		, 0x05 },
+	{ STB0899_EQUAI3		, 0x02 },
+	{ STB0899_EQUAQ3		, 0xfd },
+	{ STB0899_EQUAI4		, 0x03 },
+	{ STB0899_EQUAQ4		, 0x07 },
+	{ STB0899_EQUAI5		, 0x08 },
+	{ STB0899_EQUAQ5		, 0xf5 },
+	{ STB0899_DSTATUS2		, 0x00 },
+	{ STB0899_VSTATUS		, 0x00 },
+	{ STB0899_VERROR		, 0x86 },
+	{ STB0899_IQSWAP		, 0x2a },
+	{ STB0899_ECNT1M		, 0x00 },
+	{ STB0899_ECNT1L		, 0x00 },
+	{ STB0899_ECNT2M		, 0x00 },
+	{ STB0899_ECNT2L		, 0x00 },
+	{ STB0899_ECNT3M		, 0x0a },
+	{ STB0899_ECNT3L		, 0xad },
+	{ STB0899_FECAUTO1		, 0x06 },
+	{ STB0899_FECM			, 0x01 },
+	{ STB0899_VTH12			, 0xb0 },
+	{ STB0899_VTH23			, 0x7a },
+	{ STB0899_VTH34			, 0x58 },
+	{ STB0899_VTH56			, 0x38 },
+	{ STB0899_VTH67			, 0x34 },
+	{ STB0899_VTH78			, 0x24 },
+	{ STB0899_PRVIT			, 0xff },
+	{ STB0899_VITSYNC		, 0x19 },
+	{ STB0899_RSULC			, 0xb1 }, /* DVB = 0xb1, DSS = 0xa1 */
+	{ STB0899_TSULC			, 0x42 },
+	{ STB0899_RSLLC			, 0x41 },
+	{ STB0899_TSLPL			, 0x12 },
+	{ STB0899_TSCFGH		, 0x0c },
+	{ STB0899_TSCFGM		, 0x00 },
+	{ STB0899_TSCFGL		, 0x00 },
+	{ STB0899_TSOUT			, 0x69 }, /* 0x0d for CAM */
+	{ STB0899_RSSYNCDEL		, 0x00 },
+	{ STB0899_TSINHDELH		, 0x02 },
+	{ STB0899_TSINHDELM		, 0x00 },
+	{ STB0899_TSINHDELL		, 0x00 },
+	{ STB0899_TSLLSTKM		, 0x1b },
+	{ STB0899_TSLLSTKL		, 0xb3 },
+	{ STB0899_TSULSTKM		, 0x00 },
+	{ STB0899_TSULSTKL		, 0x00 },
+	{ STB0899_PCKLENUL		, 0xbc },
+	{ STB0899_PCKLENLL		, 0xcc },
+	{ STB0899_RSPCKLEN		, 0xbd },
+	{ STB0899_TSSTATUS		, 0x90 },
+	{ STB0899_ERRCTRL1		, 0xb6 },
+	{ STB0899_ERRCTRL2      	, 0x95 },
+	{ STB0899_ERRCTRL3      	, 0x8d },
+	{ STB0899_DMONMSK1		, 0x27 },
+	{ STB0899_DMONMSK0		, 0x03 },
+	{ STB0899_DEMAPVIT		, 0x5c },
+	{ STB0899_PLPARM		, 0x19 },
+	{ STB0899_PDELCTRL		, 0x48 },
+	{ STB0899_PDELCTRL2		, 0x00 },
+	{ STB0899_BBHCTRL1		, 0x00 },
+	{ STB0899_BBHCTRL2		, 0x00 },
+	{ STB0899_HYSTTHRESH		, 0x77 },
+	{ STB0899_MATCSTM		, 0x00 },
+	{ STB0899_MATCSTL		, 0x00 },
+	{ STB0899_UPLCSTM		, 0x00 },
+	{ STB0899_UPLCSTL		, 0x00 },
+	{ STB0899_DFLCSTM		, 0x00 },
+	{ STB0899_DFLCSTL		, 0x00 },
+	{ STB0899_SYNCCST		, 0x00 },
+	{ STB0899_SYNCDCSTM		, 0x00 },
+	{ STB0899_SYNCDCSTL		, 0x00 },
+	{ STB0899_ISI_ENTRY		, 0x00 },
+	{ STB0899_ISI_BIT_EN		, 0x00 },
+	{ STB0899_MATSTRM		, 0xf0 },
+	{ STB0899_MATSTRL		, 0x02 },
+	{ STB0899_UPLSTRM		, 0x45 },
+	{ STB0899_UPLSTRL		, 0x60 },
+	{ STB0899_DFLSTRM		, 0xe3 },
+	{ STB0899_DFLSTRL		, 0x00 },
+	{ STB0899_SYNCSTR		, 0x47 },
+	{ STB0899_SYNCDSTRM		, 0x05 },
+	{ STB0899_SYNCDSTRL		, 0x18 },
+	{ STB0899_CFGPDELSTATUS1	, 0x19 },
+	{ STB0899_CFGPDELSTATUS2	, 0x2b },
+	{ STB0899_BBFERRORM		, 0x00 },
+	{ STB0899_BBFERRORL		, 0x01 },
+	{ STB0899_UPKTERRORM		, 0x00 },
+	{ STB0899_UPKTERRORL		, 0x00 },
+	{ 0xffff			, 0xff },
+};
+
+
+static const struct stb0899_s2_reg pctv452e_init_s2_fec[] = {
+	{ STB0899_OFF0_BLOCK_LNGTH	, STB0899_BASE_BLOCK_LNGTH	, 0x00000008 },	/* BLOCKLNGTH	*/
+	{ STB0899_OFF0_ROW_STR		, STB0899_BASE_ROW_STR		, 0x000000b4 },	/* ROWSTR	*/
+	{ STB0899_OFF0_BN_END_ADDR	, STB0899_BASE_BN_END_ADDR	, 0x000004b5 },	/* BNANDADDR	*/
+	{ STB0899_OFF0_CN_END_ADDR	, STB0899_BASE_CN_END_ADDR	, 0x00000b4b },	/* CNANDADDR	*/
+	{ STB0899_OFF0_INFO_LENGTH	, STB0899_BASE_INFO_LENGTH	, 0x00000078 },	/* INFOLENGTH	*/
+	{ STB0899_OFF0_BOT_ADDR		, STB0899_BASE_BOT_ADDR		, 0x000001e0 },	/* BOT_ADDR	*/
+	{ STB0899_OFF0_BCH_BLK_LN	, STB0899_BASE_BCH_BLK_LN	, 0x0000a8c0 },	/* BCHBLKLN	*/
+	{ STB0899_OFF0_BCH_T		, STB0899_BASE_BCH_T		, 0x0000000c },	/* BCHT		*/
+	{ STB0899_OFF0_CNFG_MODE	, STB0899_BASE_CNFG_MODE	, 0x00000001 },	/* CNFGMODE	*/
+	{ STB0899_OFF0_LDPC_STAT	, STB0899_BASE_LDPC_STAT	, 0x0000000d },	/* LDPCSTAT	*/
+	{ STB0899_OFF0_ITER_SCALE	, STB0899_BASE_ITER_SCALE	, 0x00000040 },	/* ITERSCALE	*/
+	{ STB0899_OFF0_INPUT_MODE	, STB0899_BASE_INPUT_MODE	, 0x00000000 },	/* INPUTMODE	*/
+	{ STB0899_OFF0_LDPCDECRST	, STB0899_BASE_LDPCDECRST	, 0x00000000 },	/* LDPCDECRST	*/
+	{ STB0899_OFF0_CLK_PER_BYTE_RW	, STB0899_BASE_CLK_PER_BYTE_RW	, 0x00000008 },	/* CLKPERBYTE	*/
+	{ STB0899_OFF0_BCH_ERRORS	, STB0899_BASE_BCH_ERRORS	, 0x00000000 },	/* BCHERRORS	*/
+	{ STB0899_OFF0_LDPC_ERRORS	, STB0899_BASE_LDPC_ERRORS	, 0x00000000 },	/* LDPCERRORS	*/
+	{ STB0899_OFF0_BCH_MODE		, STB0899_BASE_BCH_MODE		, 0x00000000 },	/* BCHMODE	*/
+	{ STB0899_OFF0_ERR_ACC_PER	, STB0899_BASE_ERR_ACC_PER	, 0x00000008 },	/* ERRACCPER	*/
+	{ STB0899_OFF0_BCH_ERR_ACC	, STB0899_BASE_BCH_ERR_ACC	, 0x00000000 },	/* BCHERRACC	*/
+	{ STB0899_OFF0_FEC_TP_SEL	, STB0899_BASE_FEC_TP_SEL	, 0x00000000 },	/* FECTPSEL	*/
+	{ 0xffff			, 0xffffffff			, 0xffffffff },
+};
+
+static const struct stb0899_s1_reg pctv452e_init_tst[] = {
+	{ STB0899_TSTCK		, 0x00 },
+	{ STB0899_TSTRES	, 0x00 },
+	{ STB0899_TSTOUT	, 0x00 },
+	{ STB0899_TSTIN		, 0x00 },
+	{ STB0899_TSTSYS	, 0x00 },
+	{ STB0899_TSTCHIP	, 0x00 },
+	{ STB0899_TSTFREE	, 0x00 },
+	{ STB0899_TSTI2C	, 0x00 },
+	{ STB0899_BITSPEEDM	, 0x00 },
+	{ STB0899_BITSPEEDL	, 0x00 },
+	{ STB0899_TBUSBIT	, 0x00 },
+	{ STB0899_TSTDIS	, 0x00 },
+	{ STB0899_TSTDISRX	, 0x00 },
+	{ STB0899_TSTJETON	, 0x00 },
+	{ STB0899_TSTDCADJ	, 0x00 },
+	{ STB0899_TSTAGC1	, 0x00 },
+	{ STB0899_TSTAGC1N	, 0x00 },
+	{ STB0899_TSTPOLYPH	, 0x00 },
+	{ STB0899_TSTR		, 0x00 },
+	{ STB0899_TSTAGC2	, 0x00 },
+	{ STB0899_TSTCTL1	, 0x00 },
+	{ STB0899_TSTCTL2	, 0x00 },
+	{ STB0899_TSTCTL3	, 0x00 },
+	{ STB0899_TSTDEMAP	, 0x00 },
+	{ STB0899_TSTDEMAP2	, 0x00 },
+	{ STB0899_TSTDEMMON	, 0x00 },
+	{ STB0899_TSTRATE	, 0x00 },
+	{ STB0899_TSTSELOUT	, 0x00 },
+	{ STB0899_TSYNC		, 0x00 },
+	{ STB0899_TSTERR	, 0x00 },
+	{ STB0899_TSTRAM1	, 0x00 },
+	{ STB0899_TSTVSELOUT	, 0x00 },
+	{ STB0899_TSTFORCEIN	, 0x00 },
+	{ STB0899_TSTRS1	, 0x00 },
+	{ STB0899_TSTRS2	, 0x00 },
+	{ STB0899_TSTRS3	, 0x00 },
+	{ STB0899_GHOSTREG	, 0x81 },
+	{ 0xffff		, 0xff },
+};
+
+
+#define PCTV452E_DVBS2_ESNO_AVE			3
+#define PCTV452E_DVBS2_ESNO_QUANT		32
+#define PCTV452E_DVBS2_AVFRAMES_COARSE		10
+#define PCTV452E_DVBS2_AVFRAMES_FINE		20
+#define PCTV452E_DVBS2_MISS_THRESHOLD		6
+#define PCTV452E_DVBS2_UWP_THRESHOLD_ACQ	1125
+#define PCTV452E_DVBS2_UWP_THRESHOLD_TRACK	758
+#define PCTV452E_DVBS2_UWP_THRESHOLD_SOF	1350
+#define PCTV452E_DVBS2_SOF_SEARCH_TIMEOUT	1664100
+
+#define PCTV452E_DVBS2_BTR_NCO_BITS		28
+#define PCTV452E_DVBS2_BTR_GAIN_SHIFT_OFFSET	15
+#define PCTV452E_DVBS2_CRL_NCO_BITS		30
+#define PCTV452E_DVBS2_LDPC_MAX_ITER		70
+
+
+static struct stb0899_config stb0899_config = {
+	.init_dev	= pctv452e_init_dev,
+	.init_s2_demod   = pctv452e_init_s2_demod,
+	.init_s1_demod   = pctv452e_init_s1_demod,
+	.init_s2_fec     = pctv452e_init_s2_fec,
+	.init_tst	= pctv452e_init_tst,
+
+	.demod_address   = I2C_ADDR_STB0899, /* I2C Address */
+	.block_sync_mode = STB0899_SYNC_FORCED, /* ? */
+
+	.xtal_freq       = 27000000,	 /* Assume Hz ? */
+	.inversion       = IQ_SWAP_ON,       /* ? */
+
+	.lo_clk	  = 76500000,
+	.hi_clk	  = 99000000,
+
+	.ts_output_mode  = 0,		/* Use parallel mode */
+	.clock_polarity  = 0,		/*  */
+	.data_clk_parity = 0,		/*  */
+	.fec_mode	= 0,		/*  */
+
+	.esno_ave	    = PCTV452E_DVBS2_ESNO_AVE,
+	.esno_quant	  = PCTV452E_DVBS2_ESNO_QUANT,
+	.avframes_coarse     = PCTV452E_DVBS2_AVFRAMES_COARSE,
+	.avframes_fine       = PCTV452E_DVBS2_AVFRAMES_FINE,
+	.miss_threshold      = PCTV452E_DVBS2_MISS_THRESHOLD,
+	.uwp_threshold_acq   = PCTV452E_DVBS2_UWP_THRESHOLD_ACQ,
+	.uwp_threshold_track = PCTV452E_DVBS2_UWP_THRESHOLD_TRACK,
+	.uwp_threshold_sof   = PCTV452E_DVBS2_UWP_THRESHOLD_SOF,
+	.sof_search_timeout  = PCTV452E_DVBS2_SOF_SEARCH_TIMEOUT,
+
+	.btr_nco_bits	  = PCTV452E_DVBS2_BTR_NCO_BITS,
+	.btr_gain_shift_offset = PCTV452E_DVBS2_BTR_GAIN_SHIFT_OFFSET,
+	.crl_nco_bits	  = PCTV452E_DVBS2_CRL_NCO_BITS,
+	.ldpc_max_iter	 = PCTV452E_DVBS2_LDPC_MAX_ITER,
+
+	.tuner_get_frequency	= stb6100_get_frequency,
+	.tuner_set_frequency	= stb6100_set_frequency,
+	.tuner_set_bandwidth	= stb6100_set_bandwidth,
+	.tuner_get_bandwidth	= stb6100_get_bandwidth,
+	.tuner_set_rfsiggain	= NULL,
+
+	/* helper for switching LED green/orange */
+	.postproc = pctv45e_postproc
+};
+
+static struct stb6100_config stb6100_config = {
+	.tuner_address = I2C_ADDR_STB6100,
+	.refclock      = 27000000
+};
+
+
+static struct i2c_algorithm pctv452e_i2c_algo = {
+	.master_xfer   = pctv452e_i2c_xfer,
+	.functionality = pctv452e_i2c_func
+};
+
+
+static struct usb_device_id pctv452e_usb_table[] = {
+	{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_452E)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3600)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3650_CI)},
+	{}
+};
+MODULE_DEVICE_TABLE(usb, pctv452e_usb_table);
+
+static struct dvb_usb_device_properties pctv452e_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER, /* more ? */
+	.usb_ctrl = DEVICE_SPECIFIC,
+
+	.size_of_priv     = sizeof(struct pctv452e_state),
+
+	.identify_state   = 0, // this is a warm only device
+
+	.power_ctrl       = pctv452e_power_ctrl,
+	/* Untested. */
+	/* .read_mac_address = pctv452e_read_mac_address, */
+
+	.rc.legacy = {
+		.rc_map_table     = pctv452e_rc_keys,
+		.rc_map_size      = ARRAY_SIZE(pctv452e_rc_keys),
+		.rc_query         = pctv452e_rc_query,
+		.rc_interval      = 100,
+	},
+
+	.num_adapters     = 1,
+	.adapter = {{
+		.caps	     = 0,
+		.pid_filter_count = 0,
+
+		.streaming_ctrl   = NULL,
+
+		.frontend_attach  = pctv452e_frontend_attach,
+		.tuner_attach     = pctv452e_tuner_attach,
+
+		/* parameter for the MPEG2-data transfer */
+		.stream = {
+			.type     = USB_ISOC,
+			.count    = ISO_BUF_COUNT,
+			.endpoint = 0x02,
+			.u = {
+				.isoc = {
+					.framesperurb = FRAMES_PER_ISO_BUF,
+					.framesize    = ISO_FRAME_SIZE,
+					.interval     = 1
+				}
+			}
+		},
+		.size_of_priv     = 0
+	}},
+
+	.i2c_algo = &pctv452e_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 1, /* allow generice rw function*/
+
+	.num_device_descs = 1,
+	.devices = {
+		{ .name = "PCTV HDTV USB",
+		  .cold_ids = { NULL, NULL }, // this is a warm only device
+		  .warm_ids = { &pctv452e_usb_table[0], NULL }
+		},
+		{ 0 },
+	}
+};
+
+static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER, /* more ? */
+	.usb_ctrl = DEVICE_SPECIFIC,
+
+	.size_of_priv		= sizeof(struct pctv452e_state),
+
+	.identify_state		= 0, // this is a warm only device
+
+	.power_ctrl		= pctv452e_power_ctrl,
+	.read_mac_address	= pctv452e_read_mac_address,
+
+	.rc.legacy = {
+		.rc_map_table   = tt_connect_s2_3600_rc_key,
+		.rc_map_size    = ARRAY_SIZE(tt_connect_s2_3600_rc_key),
+		.rc_query       = pctv452e_rc_query,
+		.rc_interval    = 500,
+	},
+
+	.num_adapters		= 1,
+	.adapter = {{
+		.caps = 0,
+		.pid_filter_count = 0,
+
+		.streaming_ctrl = NULL,
+
+		.frontend_attach = pctv452e_frontend_attach,
+		.tuner_attach = pctv452e_tuner_attach,
+
+		/* parameter for the MPEG2-data transfer */
+		.stream = {
+			.type = USB_ISOC,
+			.count = 7,
+			.endpoint = 0x02,
+			.u = {
+				.isoc = {
+					.framesperurb = 4,
+					.framesize = 940,
+					.interval = 1
+				}
+			}
+		},
+		.size_of_priv = 0
+	}},
+
+	.i2c_algo = &pctv452e_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 1, /* allow generice rw function*/
+
+	.num_device_descs = 2,
+	.devices = {
+		{ .name = "Technotrend TT Connect S2-3600",
+		  .cold_ids = { NULL, NULL }, /* this is a warm only device */
+		  .warm_ids = { &pctv452e_usb_table[1], NULL }
+		},
+		{ .name = "Technotrend TT Connect S2-3650-CI",
+		  .cold_ids = { NULL, NULL },
+		  .warm_ids = { &pctv452e_usb_table[2], NULL }
+		},
+		{ 0 },
+	}
+};
+
+
+
+static struct usb_driver pctv452e_usb_driver = {
+#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2,6,15)
+	.owner      = THIS_MODULE,
+#endif
+	.name       = "pctv452e",
+	.probe      = pctv452e_usb_probe,
+	.disconnect = pctv452e_usb_disconnect,
+	.id_table   = pctv452e_usb_table,
+};
+
+static struct usb_driver tt_connects2_3600_usb_driver = {
+#if LINUX_VERSION_CODE <=  KERNEL_VERSION(2,6,15)
+	.owner      = THIS_MODULE,
+#endif
+	.name       = "dvb-usb-tt-connect-s2-3600-01.fw",
+	.probe      = pctv452e_usb_probe,
+	.disconnect = pctv452e_usb_disconnect,
+	.id_table   = pctv452e_usb_table,
+};
+
+static int __init pctv452e_usb_init(void) {
+	int err=0;
+
+	if ((err = usb_register(&pctv452e_usb_driver))) {
+		printk("%s: usb_register failed! Error number %d", __FILE__, err);
+		return err;
+	}
+	if ((err = usb_register(&tt_connects2_3600_usb_driver))) {
+		printk("%s: usb_register failed! Error number %d", __FILE__, err);
+	}
+
+	return err;
+}
+
+static void __exit pctv452e_usb_exit(void)  {
+	usb_deregister(&pctv452e_usb_driver);
+	usb_deregister(&tt_connects2_3600_usb_driver);
+}
+
+module_init(pctv452e_usb_init);
+module_exit(pctv452e_usb_exit);
+
+MODULE_AUTHOR("Dominik Kuhlen <dkuhlen@gmx.net>");
+MODULE_AUTHOR("Andre Weidemann <Andre.Weidemann@web.de>");
+MODULE_AUTHOR("Michael H. Schimek <mschimek@gmx.at>");
+MODULE_DESCRIPTION("Pinnacle PCTV HDTV USB DVB / TT connect S2-3600 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 3b0c4bd..8e6f588 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_DVB_LGDT330X) += lgdt330x.o
 obj-$(CONFIG_DVB_LGDT3305) += lgdt3305.o
 obj-$(CONFIG_DVB_CX24123) += cx24123.o
 obj-$(CONFIG_DVB_LNBP21) += lnbp21.o
+obj-$(CONFIG_DVB_LNBP22) += lnbp22.o
 obj-$(CONFIG_DVB_ISL6405) += isl6405.o
 obj-$(CONFIG_DVB_ISL6421) += isl6421.o
 obj-$(CONFIG_DVB_TDA10086) += tda10086.o
diff --git a/drivers/media/dvb/frontends/lnbp22.c b/drivers/media/dvb/frontends/lnbp22.c
new file mode 100644
index 0000000..48377b2
--- /dev/null
+++ b/drivers/media/dvb/frontends/lnbp22.c
@@ -0,0 +1,140 @@
+/*
+ * lnbp22.h - driver for lnb supply and control ic lnbp22
+ *
+ * Copyright (C) 2006 Dominik Kuhlen
+ * Based on lnbp21 driver
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *
+ *
+ * the project's page is at http://www.linuxtv.org
+ */
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include "dvb_frontend.h"
+#include "lnbp22.h"
+
+static int debug = 0;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+
+#define dprintk(lvl, arg...) if (debug >= (lvl)) printk(arg)
+
+struct lnbp22 {
+	u8                 config[4];
+	struct i2c_adapter *i2c;
+};
+
+static int lnbp22_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage) {
+	struct lnbp22 *lnbp22 = (struct lnbp22 *) fe->sec_priv;
+	struct i2c_msg msg = {	.addr = 0x08, .flags = 0,
+				.buf = (char*)&lnbp22->config,
+				.len = sizeof(lnbp22->config) };
+
+	dprintk(1, "%s: %d (18V=%d 13V=%d)\n", __FUNCTION__, voltage,
+	       SEC_VOLTAGE_18, SEC_VOLTAGE_13);
+
+	lnbp22->config[3] = 0x60; // Power down
+	switch(voltage) {
+	case SEC_VOLTAGE_OFF:
+		break;
+	case SEC_VOLTAGE_13:
+		lnbp22->config[3] |= LNBP22_EN;
+		break;
+	case SEC_VOLTAGE_18:
+		lnbp22->config[3] |= (LNBP22_EN | LNBP22_VSEL);
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	dprintk(1, "%s: 0x%02x)\n", __FUNCTION__, lnbp22->config[3]);
+	return (i2c_transfer(lnbp22->i2c, &msg, 1) == 1) ? 0 : -EIO;
+}
+
+static int lnbp22_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg) {
+	struct lnbp22 *lnbp22 = (struct lnbp22 *) fe->sec_priv;
+	struct i2c_msg msg = {	.addr = 0x08, .flags = 0,
+				.buf = (char*)&lnbp22->config,
+				.len = sizeof(lnbp22->config) };
+
+	dprintk(1, "%s: %d\n", __FUNCTION__, (int)arg);
+	if (arg)
+		lnbp22->config[3] |= LNBP22_LLC;
+	else
+		lnbp22->config[3] &= ~LNBP22_LLC;
+
+	return (i2c_transfer(lnbp22->i2c, &msg, 1) == 1) ? 0 : -EIO;
+}
+
+static void lnbp22_release(struct dvb_frontend *fe)
+{
+
+	dprintk(1, "%s\n", __FUNCTION__);
+	/* LNBP power off */
+	lnbp22_set_voltage(fe, SEC_VOLTAGE_OFF);
+
+	/* free data */
+	kfree(fe->sec_priv);
+	fe->sec_priv = NULL;
+}
+
+struct dvb_frontend *lnbp22_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c)
+{
+	struct lnbp22 *lnbp22 = kmalloc(sizeof(struct lnbp22), GFP_KERNEL);
+	if (!lnbp22)
+		return NULL;
+
+	/* default configuration */
+	lnbp22->config[0] = 0x00; /* ? */
+	lnbp22->config[1] = 0x28; /* ? */
+	lnbp22->config[2] = 0x48; /* ? */
+	lnbp22->config[3] = 0x60; /* Power down */
+	lnbp22->i2c = i2c;
+	fe->sec_priv = lnbp22;
+
+	/* detect if it is present or not */
+	if (lnbp22_set_voltage(fe, SEC_VOLTAGE_OFF)) {
+		dprintk(0, "%s LNBP22 not found\n", __FUNCTION__);
+		kfree(lnbp22);
+		fe->sec_priv = NULL;
+		return NULL;
+	}
+
+	/* install release callback */
+	fe->ops.release_sec = lnbp22_release;
+
+	/* override frontend ops */
+	fe->ops.set_voltage = lnbp22_set_voltage;
+	fe->ops.enable_high_lnb_voltage = lnbp22_enable_high_lnb_voltage;
+
+	return fe;
+}
+EXPORT_SYMBOL(lnbp22_attach);
+
+MODULE_DESCRIPTION("Driver for lnb supply and control ic lnbp22");
+MODULE_AUTHOR("Dominik Kuhlen");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/lnbp22.h b/drivers/media/dvb/frontends/lnbp22.h
new file mode 100644
index 0000000..4149c62
--- /dev/null
+++ b/drivers/media/dvb/frontends/lnbp22.h
@@ -0,0 +1,51 @@
+/*
+ * lnbp22.h - driver for lnb supply and control ic lnbp22
+ *
+ * Copyright (C) 2006 Dominik Kuhlen
+ * Based on lnbp21.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
+ *
+ *
+ * the project's page is at http://www.linuxtv.org
+ */
+
+#ifndef _LNBP22_H
+#define _LNBP22_H
+
+// Enable
+#define LNBP22_EN	  0x10
+// Voltage selection
+#define LNBP22_VSEL	0x02
+// Plus 1 Volt Bit
+#define LNBP22_LLC	0x01
+
+#include <linux/dvb/frontend.h>
+
+#if defined(CONFIG_DVB_LNBP22) || (defined(CONFIG_DVB_LNBP22_MODULE) && defined(MODULE))
+/* override_set and override_clear control which system register bits (above) to always set & clear */
+extern struct dvb_frontend *lnbp22_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *lnbp22_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif // CONFIG_DVB_LNBP22
+
+#endif // _LNBP22_H
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.c b/drivers/media/dvb/ttpci/ttpci-eeprom.c
index 7dd54b3..0f54d4f 100644
--- a/drivers/media/dvb/ttpci/ttpci-eeprom.c
+++ b/drivers/media/dvb/ttpci/ttpci-eeprom.c
@@ -85,6 +85,31 @@ static int getmac_tt(u8 * decodedMAC, u8 * encodedMAC)
 	return 0;
 }
 
+int ttpci_eeprom_decode_mac(u8 * decodedMAC, u8 * encodedMAC)
+{
+	u8 xor[20] = { 0x72, 0x23, 0x68, 0x19, 0x5c, 0xa8, 0x71, 0x2c,
+		       0x54, 0xd3, 0x7b, 0xf1, 0x9E, 0x23, 0x16, 0xf6,
+		       0x1d, 0x36, 0x64, 0x78};
+	u8 data[20];
+	int i;
+
+	/* In case there is a sig check failure have the orig contents available */
+	memcpy(data, encodedMAC, 20);
+
+	for (i = 0; i < 20; i++)
+		data[i] ^= xor[i];
+	for (i = 0; i < 10; i++)
+		data[i] = ((data[2 * i + 1] << 8) | data[2 * i])
+			>> ((data[2 * i + 1] >> 6) & 3);
+
+	if (check_mac_tt(data))
+		return -ENODEV;
+
+	decodedMAC[0] = data[2]; decodedMAC[1] = data[1]; decodedMAC[2] = data[0];
+	decodedMAC[3] = data[6]; decodedMAC[4] = data[5]; decodedMAC[5] = data[4];
+	return 0;
+}
+
 static int ttpci_eeprom_read_encodedMAC(struct i2c_adapter *adapter, u8 * encodedMAC)
 {
 	int ret;
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.h b/drivers/media/dvb/ttpci/ttpci-eeprom.h
index e2dc6cf..fea8bfc 100644
--- a/drivers/media/dvb/ttpci/ttpci-eeprom.h
+++ b/drivers/media/dvb/ttpci/ttpci-eeprom.h
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 
+extern int ttpci_eeprom_decode_mac(u8 * decodedMAC, u8 * encodedMAC);
 extern int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *propsed_mac);
 
 #endif
--- a/drivers/media/dvb/ttpci/ttpci-eeprom.c      2011-07-23 11:00:49.000000000 +0000
+++ b/drivers/media/dvb/ttpci/ttpci-eeprom.c      2011-07-23 11:04:00.000000000 +0000
@@ -165,6 +165,7 @@ int ttpci_eeprom_parse_mac(struct i2c_ad
 }
 
 EXPORT_SYMBOL(ttpci_eeprom_parse_mac);
+EXPORT_SYMBOL(ttpci_eeprom_decode_mac);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, others");
diff -Naur original-new-stb0899/linux/drivers/media/dvb/frontends/Kconfig 1/linux/drivers/media/dvb/frontends/Kconfig
--- a/drivers/media/dvb/frontends/Kconfig	2007-10-22 01:40:25.000000000 +0100
+++ b/drivers/media/dvb/frontends/Kconfig	2007-10-23 19:47:41.000000000 +0100
@@ -358,6 +358,12 @@
 	help
 	  An SEC control chip.
 
+config DVB_LNBP22
+	tristate "LNBP22 SEC controller"
+	depends on DVB_CORE && I2C
+	help
+	  An SEC control chip.
+
 config DVB_ISL6421
 	tristate "ISL6421 SEC controller"
 	depends on DVB_CORE && I2C
-- 
1.7.1.1

--------------000307070007080806060206--

