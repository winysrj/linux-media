Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f214.google.com ([209.85.220.214]:59391 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZFTNiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 09:38:24 -0400
Received: by fxm10 with SMTP id 10so151994fxm.37
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 06:38:25 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: mo.ucina@gmail.com
Subject: Re: [linux-dvb] Support for Compro VideoMate S350
Date: Sat, 20 Jun 2009 16:33:58 +0300
Cc: linux-media@vger.kernel.org, "Jan D. Louw" <jd.louw@mweb.co.za>
References: <81c0b0550905250703o786a2a65ib757287da841dc11@mail.gmail.com> <4A3C3F4D.7050105@gmail.com>
In-Reply-To: <4A3C3F4D.7050105@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GVOPKFR/cLyraOS"
Message-Id: <200906201633.58431.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_GVOPKFR/cLyraOS
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 20 June 2009 04:45:49 O&M Ugarcina wrote:
> Hello Guys,
>
> I have one of these "paper weights" - that is a S350 , it has been
> sitting on the shelf for the past 2 years . And I would really like to
> use it . We have a driver for it here :
> http://article.gmane.org/gmane.linux.drivers.dvb/38163  . Please what
> needs to be done to get this driver merged into the tree ? C'mon guys
> lets get this one in .
>
> Best Regards
> Milorad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Patches (hg export) against recent linuxtv tree.
Feel free to test.
It includes TeVii S630 as well, which already tested by me.
As for Compro, I have report about successfully working one.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_GVOPKFR/cLyraOS
Content-Type: text/x-diff;
  charset="koi8-r";
  name="12094.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="12094.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1245502308 -10800
# Node ID 9da94d6ff07d13481c15c756c4802eb15d923d16
# Parent  2899ad868fc69dd57310f1833fb67155060b06f0
Add ce5039(zl10039) tuner support.

From: Igor M. Liplianin <liplianin@me.by>

The code from Jan D. Louw with some minor changes.
http://article.gmane.org/gmane.linux.drivers.dvb/38163
Tested with TeVii S630 DVB-S USB card by me (Igor)

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 2899ad868fc6 -r 9da94d6ff07d linux/drivers/media/dvb/frontends/Kconfig
--- a/linux/drivers/media/dvb/frontends/Kconfig	Thu Jun 18 19:31:36 2009 +0200
+++ b/linux/drivers/media/dvb/frontends/Kconfig	Sat Jun 20 15:51:48 2009 +0300
@@ -81,6 +81,13 @@
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
+config DVB_ZL10039
+	tristate "Zarlink ZL10039 silicon tuner"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DVB-S tuner module. Say Y when you want to support this frontend.
+
 config DVB_S5H1420
 	tristate "Samsung S5H1420 based"
 	depends on DVB_CORE && I2C
diff -r 2899ad868fc6 -r 9da94d6ff07d linux/drivers/media/dvb/frontends/Makefile
--- a/linux/drivers/media/dvb/frontends/Makefile	Thu Jun 18 19:31:36 2009 +0200
+++ b/linux/drivers/media/dvb/frontends/Makefile	Sat Jun 20 15:51:48 2009 +0300
@@ -31,6 +31,7 @@
 obj-$(CONFIG_DVB_NXT6000) += nxt6000.o
 obj-$(CONFIG_DVB_MT352) += mt352.o
 obj-$(CONFIG_DVB_ZL10036) += zl10036.o
+obj-$(CONFIG_DVB_ZL10039) += zl10039.o
 obj-$(CONFIG_DVB_ZL10353) += zl10353.o
 obj-$(CONFIG_DVB_CX22702) += cx22702.o
 obj-$(CONFIG_DVB_DRX397XD) += drx397xD.o
diff -r 2899ad868fc6 -r 9da94d6ff07d linux/drivers/media/dvb/frontends/zl10039.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/zl10039.c	Sat Jun 20 15:51:48 2009 +0300
@@ -0,0 +1,308 @@
+/*
+ *  Driver for Zarlink ZL10039 DVB-S tuner
+ *
+ *  Copyright 2007 Jan D. Louw <jd.louw@mweb.co.za>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/dvb/frontend.h>
+
+#include "dvb_frontend.h"
+#include "zl10039.h"
+
+static int debug;
+
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG args); \
+	} while (0)
+
+enum zl10039_model_id {
+	ID_ZL10039 = 1
+};
+
+struct zl10039_state {
+	struct i2c_adapter *i2c;
+	u8 i2c_addr;
+	u8 id;
+};
+
+enum zl10039_reg_addr {
+	PLL0 = 0,
+	PLL1,
+	PLL2,
+	PLL3,
+	RFFE,
+	BASE0,
+	BASE1,
+	BASE2,
+	LO0,
+	LO1,
+	LO2,
+	LO3,
+	LO4,
+	LO5,
+	LO6,
+	GENERAL
+};
+
+static int zl10039_read(const struct zl10039_state *state,
+			const enum zl10039_reg_addr reg, u8 *buf,
+			const size_t count)
+{
+	u8 regbuf[] = { reg };
+	struct i2c_msg msg[] = {
+		{/* Write register address */
+			.addr = state->i2c_addr,
+			.flags = 0,
+			.buf = regbuf,
+			.len = 1,
+		}, {/* Read count bytes */
+			.addr = state->i2c_addr,
+			.flags = I2C_M_RD,
+			.buf = buf,
+			.len = count,
+		},
+	};
+
+	dprintk("%s\n", __func__);
+
+	if (i2c_transfer(state->i2c, msg, 2) != 2) {
+		dprintk("%s: i2c read error\n", __func__);
+		return -EREMOTEIO;
+	}
+
+	return 0; /* Success */
+}
+
+static int zl10039_write(struct zl10039_state *state,
+			const enum zl10039_reg_addr reg, const u8 *src,
+			const size_t count)
+{
+	u8 buf[count + 1];
+	struct i2c_msg msg = {
+		.addr = state->i2c_addr,
+		.flags = 0,
+		.buf = buf,
+		.len = count + 1,
+	};
+
+	dprintk("%s\n", __func__);
+	/* Write register address and data in one go */
+	buf[0] = reg;
+	memcpy(&buf[1], src, count);
+	if (i2c_transfer(state->i2c, &msg, 1) != 1) {
+		dprintk("%s: i2c write error\n", __func__);
+		return -EREMOTEIO;
+	}
+
+	return 0; /* Success */
+}
+
+static inline int zl10039_readreg(struct zl10039_state *state,
+				const enum zl10039_reg_addr reg, u8 *val)
+{
+	return zl10039_read(state, reg, val, 1);
+}
+
+static inline int zl10039_writereg(struct zl10039_state *state,
+				const enum zl10039_reg_addr reg,
+				const u8 val)
+{
+	return zl10039_write(state, reg, &val, 1);
+}
+
+static int zl10039_init(struct dvb_frontend *fe)
+{
+	struct zl10039_state *state = fe->tuner_priv;
+	int ret;
+
+	dprintk("%s\n", __func__);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	/* Reset logic */
+	ret = zl10039_writereg(state, GENERAL, 0x40);
+	if (ret < 0) {
+		dprintk("Note: i2c write error normal when resetting the "
+			"tuner\n");
+	}
+	/* Wake up */
+	ret = zl10039_writereg(state, GENERAL, 0x01);
+	if (ret < 0) {
+		dprintk("Tuner power up failed\n");
+		return ret;
+	}
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+}
+
+static int zl10039_sleep(struct dvb_frontend *fe)
+{
+	struct zl10039_state *state = fe->tuner_priv;
+	int ret;
+
+	dprintk("%s\n", __func__);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	ret = zl10039_writereg(state, GENERAL, 0x80);
+	if (ret < 0) {
+		dprintk("Tuner sleep failed\n");
+		return ret;
+	}
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+}
+
+static int zl10039_set_params(struct dvb_frontend *fe,
+			struct dvb_frontend_parameters *params)
+{
+	struct zl10039_state *state = fe->tuner_priv;
+	u8 buf[6];
+	u8 bf;
+	u32 fbw;
+	u32 div;
+	int ret;
+
+	dprintk("%s\n", __func__);
+	dprintk("Set frequency = %d, symbol rate = %d\n",
+			params->frequency, params->u.qpsk.symbol_rate);
+
+	/* Assumed 10.111 MHz crystal oscillator */
+	/* Cancelled num/den 80 to prevent overflow */
+	div = (params->frequency * 1000) / 126387;
+	fbw = (params->u.qpsk.symbol_rate * 27) / 32000;
+	/* Cancelled num/den 10 to prevent overflow */
+	bf = ((fbw * 5088) / 1011100) - 1;
+
+	/*PLL divider*/
+	buf[0] = (div >> 8) & 0x7f;
+	buf[1] = (div >> 0) & 0xff;
+	/*Reference divider*/
+	/* Select reference ratio of 80 */
+	buf[2] = 0x1D;
+	/*PLL test modes*/
+	buf[3] = 0x40;
+	/*RF Control register*/
+	buf[4] = 0x6E; /* Bypass enable */
+	/*Baseband filter cutoff */
+	buf[5] = bf;
+
+	/* Open i2c gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	/* BR = 10, Enable filter adjustment */
+	ret = zl10039_writereg(state, BASE1, 0x0A);
+	if (ret < 0)
+		goto error;
+	/* Write new config values */
+	ret = zl10039_write(state, PLL0, buf, sizeof(buf));
+	if (ret < 0)
+		goto error;
+	/* BR = 10, Disable filter adjustment */
+	ret = zl10039_writereg(state, BASE1, 0x6A);
+	if (ret < 0)
+		goto error;
+
+	/* Close i2c gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+	return 0;
+error:
+	dprintk("Error setting tuner\n");
+	return ret;
+}
+
+static int zl10039_release(struct dvb_frontend *fe)
+{
+	struct zl10039_state *state = fe->tuner_priv;
+
+	dprintk("%s\n", __func__);
+	kfree(state);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static struct dvb_tuner_ops zl10039_ops = {
+	.release = zl10039_release,
+	.init = zl10039_init,
+	.sleep = zl10039_sleep,
+	.set_params = zl10039_set_params,
+};
+
+struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
+		u8 i2c_addr, struct i2c_adapter *i2c)
+{
+	struct zl10039_state *state = NULL;
+
+	dprintk("%s\n", __func__);
+	state = kmalloc(sizeof(struct zl10039_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	state->i2c = i2c;
+	state->i2c_addr = i2c_addr;
+
+	/* Open i2c gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	/* check if this is a valid tuner */
+	if (zl10039_readreg(state, GENERAL, &state->id) < 0) {
+		/* Close i2c gate */
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+		goto error;
+	}
+	/* Close i2c gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	state->id = state->id & 0x0f;
+	switch (state->id) {
+	case ID_ZL10039:
+		strcpy(fe->ops.tuner_ops.info.name,
+			"Zarlink ZL10039 DVB-S tuner");
+		break;
+	default:
+		dprintk("Chip ID=%x does not match a known type\n", state->id);
+		break;
+		goto error;
+	}
+
+	memcpy(&fe->ops.tuner_ops, &zl10039_ops, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = state;
+	dprintk("Tuner attached @ i2c address 0x%02x\n", i2c_addr);
+	return fe;
+error:
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL(zl10039_attach);
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+MODULE_DESCRIPTION("Zarlink ZL10039 DVB-S tuner driver");
+MODULE_AUTHOR("Jan D. Louw <jd.louw@mweb.co.za>");
+MODULE_LICENSE("GPL");
diff -r 2899ad868fc6 -r 9da94d6ff07d linux/drivers/media/dvb/frontends/zl10039.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/zl10039.h	Sat Jun 20 15:51:48 2009 +0300
@@ -0,0 +1,40 @@
+/*
+    Driver for Zarlink ZL10039 DVB-S tuner
+
+    Copyright (C) 2007 Jan D. Louw <jd.louw@mweb.co.za>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#ifndef ZL10039_H
+#define ZL10039_H
+
+#if defined(CONFIG_DVB_ZL10039) || (defined(CONFIG_DVB_ZL10039_MODULE) \
+	    && defined(MODULE))
+struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
+					u8 i2c_addr,
+					struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
+					u8 i2c_addr,
+					struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_ZL10039 */
+
+#endif /* ZL10039_H */

--Boundary-00=_GVOPKFR/cLyraOS
Content-Type: text/x-diff;
  charset="koi8-r";
  name="12095.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="12095.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1245502458 -10800
# Node ID 54a5eca28b5dd2607774d1bc883ffda9f69463e6
# Parent  9da94d6ff07d13481c15c756c4802eb15d923d16
Add TeVii S630 USB DVB-S card support.

From: Igor M. Liplianin <liplianin@me.by>

The card includes Intel ce5039(Zarlink zl10039) tuner
and Intel ce6313 (Zarlink zl10313) demod.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 9da94d6ff07d -r 54a5eca28b5d linux/drivers/media/dvb/dvb-usb/Kconfig
--- a/linux/drivers/media/dvb/dvb-usb/Kconfig	Sat Jun 20 15:51:48 2009 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/Kconfig	Sat Jun 20 15:54:18 2009 +0300
@@ -253,7 +253,7 @@
 	  Afatech AF9005 based receiver.
 
 config DVB_USB_DW2102
-	tristate "DvbWorld DVB-S/S2 USB2.0 support"
+	tristate "DvbWorld & TeVii DVB-S/S2 USB2.0 support"
 	depends on DVB_USB
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
@@ -262,9 +262,11 @@
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
+	select DVB_MT312 if !DVB_FE_CUSTOMISE
+	select DVB_ZL10039 if !DVB_FE_CUSTOMISE
 	help
 	  Say Y here to support the DvbWorld DVB-S/S2 USB2.0 receivers
-	  and the TeVii S650.
+	  and the TeVii S650, S630.
 
 config DVB_USB_CINERGY_T2
 	tristate "Terratec CinergyT2/qanu USB 2.0 DVB-T receiver"
diff -r 9da94d6ff07d -r 54a5eca28b5d linux/drivers/media/dvb/dvb-usb/dw2102.c
--- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	Sat Jun 20 15:51:48 2009 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	Sat Jun 20 15:54:18 2009 +0300
@@ -1,6 +1,6 @@
 /* DVB USB framework compliant Linux driver for the
 *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
-*	TeVii S600, S650 Cards
+*	TeVii S600, S630, S650 Cards
 * Copyright (C) 2008,2009 Igor M. Liplianin (liplianin@me.by)
 *
 *	This program is free software; you can redistribute it and/or modify it
@@ -18,6 +18,8 @@
 #include "eds1547.h"
 #include "cx24116.h"
 #include "tda1002x.h"
+#include "mt312.h"
+#include "zl10039.h"
 
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
@@ -39,6 +41,10 @@
 #define USB_PID_TEVII_S650 0xd650
 #endif
 
+#ifndef USB_PID_TEVII_S630
+#define USB_PID_TEVII_S630 0xd630
+#endif
+
 #define DW210X_READ_MSG 0
 #define DW210X_WRITE_MSG 1
 
@@ -436,6 +442,69 @@
 	return num;
 }
 
+static int s630_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+								int num)
+{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret = 0;
+
+	if (!d)
+		return -ENODEV;
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	switch (num) {
+	case 2: { /* read */
+		u8 ibuf[msg[1].len], obuf[3];
+		obuf[0] = msg[1].len;
+		obuf[1] = (msg[0].addr << 1);
+		obuf[2] = msg[0].buf[0];
+
+		ret = dw210x_op_rw(d->udev, 0x90, 0, 0,
+					obuf, 3, DW210X_WRITE_MSG);
+		msleep(5);
+		ret = dw210x_op_rw(d->udev, 0x91, 0, 0,
+					ibuf, msg[1].len, DW210X_READ_MSG);
+		memcpy(msg[1].buf, ibuf, msg[1].len);
+		break;
+	}
+	case 1:
+		switch (msg[0].addr) {
+		case 0x60:
+		case 0x0e: {
+			/* write to zl10313, zl10039 register, */
+			u8 obuf[msg[0].len + 2];
+			obuf[0] = msg[0].len + 1;
+			obuf[1] = (msg[0].addr << 1);
+			memcpy(obuf + 2, msg[0].buf, msg[0].len);
+			ret = dw210x_op_rw(d->udev, 0x80, 0, 0,
+					obuf, msg[0].len + 2, DW210X_WRITE_MSG);
+			break;
+		}
+		case (DW2102_RC_QUERY): {
+			u8 ibuf[4];
+			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+					ibuf, 4, DW210X_READ_MSG);
+			msg[0].buf[0] = ibuf[3];
+			break;
+		}
+		case (DW2102_VOLTAGE_CTRL): {
+			u8 obuf[2];
+			obuf[0] = 0x03;
+			obuf[1] = msg[0].buf[0];
+			ret = dw210x_op_rw(d->udev, 0x8a, 0, 0,
+					obuf, 2, DW210X_WRITE_MSG);
+			break;
+		}
+		}
+
+		break;
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	return num;
+}
+
 static u32 dw210x_i2c_func(struct i2c_adapter *adapter)
 {
 	return I2C_FUNC_I2C;
@@ -481,6 +550,14 @@
 #endif
 };
 
+static struct i2c_algorithm s630_i2c_algo = {
+	.master_xfer = s630_i2c_transfer,
+	.functionality = dw210x_i2c_func,
+#ifdef NEED_ALGO_CONTROL
+	.algo_control = dummy_algo_control,
+#endif
+};
+
 static int dw210x_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 {
 	int i;
@@ -505,6 +582,37 @@
 	return 0;
 };
 
+static int s630_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
+{
+	int i, ret;
+	u8 buf[3], eeprom[256], eepromline[16];
+
+	for (i = 0; i < 256; i++) {
+		buf[0] = 1;
+		buf[1] = 0xa0;
+		buf[2] = i;
+		ret = dw210x_op_rw(d->udev, 0x90, 0, 0,
+					buf, 3, DW210X_WRITE_MSG);
+		ret = dw210x_op_rw(d->udev, 0x91, 0, 0,
+					buf, 1, DW210X_READ_MSG);
+		if (ret < 0) {
+			err("read eeprom failed.");
+			return -1;
+		} else {
+			eepromline[i % 16] = buf[0];
+			eeprom[i] = buf[0];
+		}
+
+		if ((i % 16) == 15) {
+			deb_xfer("%02x: ", i - 15);
+			debug_dump(eepromline, 16, deb_xfer);
+		}
+	}
+
+	memcpy(mac, eeprom + 16, 6);
+	return 0;
+};
+
 static int dw210x_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	static u8 command_13v[1] = {0x00};
@@ -550,6 +658,10 @@
 	.invert = 1,
 };
 
+static struct mt312_config zl313_config = {
+	.demod_address = 0x0e,
+};
+
 static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 {
 	if ((d->fe = dvb_attach(cx24116_attach, &dw2104_config,
@@ -611,6 +723,18 @@
 	return -EIO;
 }
 
+static int s630_frontend_attach(struct dvb_usb_adapter *d)
+{
+	d->fe = dvb_attach(mt312_attach, &zl313_config,
+				&d->dev->i2c_adap);
+	if (d->fe != NULL) {
+		d->fe->ops.set_voltage = dw210x_set_voltage;
+		info("Attached zl10313!\n");
+		return 0;
+	}
+	return -EIO;
+}
+
 static int dw2102_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	dvb_attach(dvb_pll_attach, adap->fe, 0x60,
@@ -634,6 +758,14 @@
 	return 0;
 }
 
+static int s630_zl10039_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	dvb_attach(zl10039_attach, adap->fe, 0x60,
+		&adap->dev->i2c_adap);
+
+	return 0;
+}
+
 static struct dvb_usb_rc_key dw210x_rc_keys[] = {
 	{ 0xf8,	0x0a, KEY_Q },		/*power*/
 	{ 0xf8,	0x0c, KEY_M },		/*mute*/
@@ -778,7 +910,7 @@
 	}
 
 	*state = REMOTE_NO_KEY_PRESSED;
-	if (dw2102_i2c_transfer(&d->i2c_adap, &msg, 1) == 1) {
+	if (d->props.i2c_algo->master_xfer(&d->i2c_adap, &msg, 1) == 1) {
 		for (i = 0; i < keymap_size ; i++) {
 			if (keymap[i].data == msg.buf[0]) {
 				*state = REMOTE_KEY_PRESSED;
@@ -807,6 +939,7 @@
 	{USB_DEVICE(0x9022, USB_PID_TEVII_S650)},
 	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_CINERGY_S)},
 	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW3101)},
+	{USB_DEVICE(0x9022, USB_PID_TEVII_S630)},
 	{ }
 };
 
@@ -821,6 +954,7 @@
 	u8 reset16[] = {0, 0, 0, 0, 0, 0, 0};
 	const struct firmware *fw;
 	const char *filename = "dvb-usb-dw2101.fw";
+
 	switch (dev->descriptor.idProduct) {
 	case 0x2101:
 		ret = request_firmware(&fw, filename, &dev->dev);
@@ -1068,6 +1202,48 @@
 	}
 };
 
+static struct dvb_usb_device_properties s630_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.firmware = "dvb-usb-s630.fw",
+	.no_reconnect = 1,
+
+	.i2c_algo = &s630_i2c_algo,
+	.rc_key_map = tevii_rc_keys,
+	.rc_key_map_size = ARRAY_SIZE(tevii_rc_keys),
+	.rc_interval = 150,
+	.rc_query = dw2102_rc_query,
+
+	.generic_bulk_ctrl_endpoint = 0x81,
+	.num_adapters = 1,
+	.download_firmware = dw2102_load_firmware,
+	.read_mac_address = s630_read_mac_address,
+	.adapter = {
+		{
+			.frontend_attach = s630_frontend_attach,
+			.streaming_ctrl = NULL,
+			.tuner_attach = s630_zl10039_tuner_attach,
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
+		}
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{"TeVii S630 USB",
+			{&dw2102_table[6], NULL},
+			{NULL},
+		},
+	}
+};
+
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
@@ -1076,6 +1252,8 @@
 	    0 == dvb_usb_device_init(intf, &dw2104_properties,
 			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &dw3101_properties,
+			THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &s630_properties,
 			THIS_MODULE, NULL, adapter_nr)) {
 		return 0;
 	}
@@ -1109,6 +1287,6 @@
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
 MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
 				" DVB-C 3101 USB2.0,"
-				" TeVii S600, S650 USB2.0 devices");
+				" TeVii S600, S630, S650 USB2.0 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");

--Boundary-00=_GVOPKFR/cLyraOS
Content-Type: text/x-diff;
  charset="koi8-r";
  name="12096.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="12096.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1245503232 -10800
# Node ID 160a27343cbadd8db4dcb6e9f6cd095635c402fb
# Parent  54a5eca28b5dd2607774d1bc883ffda9f69463e6
Add support for Compro VideoMate S350 DVB-S PCI card.

From: Igor M. Liplianin <liplianin@me.by>

Add Compro VideoMate S350 DVB-S driver.
The card uses zl10313, zl10039, saa7130 integrated circuits.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 54a5eca28b5d -r 160a27343cba linux/drivers/media/common/ir-keymaps.c
--- a/linux/drivers/media/common/ir-keymaps.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/common/ir-keymaps.c	Sat Jun 20 16:07:12 2009 +0300
@@ -2800,3 +2800,51 @@
 	[0x1b] = KEY_B,		/*recall*/
 };
 EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec);
+
+IR_KEYTAB_TYPE ir_codes_videomate_s350[IR_KEYTAB_SIZE] = {
+	[0x00] = KEY_TV,
+	[0x01] = KEY_DVD,
+	[0x04] = KEY_RECORD,
+	[0x05] = KEY_VIDEO, /* TV/Video */
+	[0x07] = KEY_STOP,
+	[0x08] = KEY_PLAYPAUSE,
+	[0x0a] = KEY_REWIND,
+	[0x0f] = KEY_FASTFORWARD,
+	[0x10] = KEY_CHANNELUP,
+	[0x12] = KEY_VOLUMEUP,
+	[0x13] = KEY_CHANNELDOWN,
+	[0x14] = KEY_MUTE,
+	[0x15] = KEY_VOLUMEDOWN,
+	[0x16] = KEY_1,
+	[0x17] = KEY_2,
+	[0x18] = KEY_3,
+	[0x19] = KEY_4,
+	[0x1a] = KEY_5,
+	[0x1b] = KEY_6,
+	[0x1c] = KEY_7,
+	[0x1d] = KEY_8,
+	[0x1e] = KEY_9,
+	[0x1f] = KEY_0,
+	[0x21] = KEY_SLEEP,
+	[0x24] = KEY_ZOOM,
+	[0x25] = KEY_LAST,    /* Recall */
+	[0x26] = KEY_SUBTITLE, /* CC */
+	[0x27] = KEY_LANGUAGE, /* MTS */
+	[0x29] = KEY_CHANNEL, /* SURF */
+	[0x2b] = KEY_A,
+	[0x2c] = KEY_B,
+	[0x2f] = KEY_SHUFFLE, /* Snapshot */
+	[0x23] = KEY_RADIO,
+	[0x02] = KEY_PREVIOUSSONG,
+	[0x06] = KEY_NEXTSONG,
+	[0x03] = KEY_EPG,
+	[0x09] = KEY_SETUP,
+	[0x22] = KEY_BACKSPACE,
+	[0x0c] = KEY_UP,
+	[0x0e] = KEY_DOWN,
+	[0x0b] = KEY_LEFT,
+	[0x0d] = KEY_RIGHT,
+	[0x11] = KEY_ENTER,
+	[0x20] = KEY_TEXT,
+};
+EXPORT_SYMBOL_GPL(ir_codes_videomate_s350);
diff -r 54a5eca28b5d -r 160a27343cba linux/drivers/media/video/saa7134/Kconfig
--- a/linux/drivers/media/video/saa7134/Kconfig	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/Kconfig	Sat Jun 20 16:07:12 2009 +0300
@@ -47,6 +47,7 @@
 	select DVB_TDA10048 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
+	select DVB_ZL10039 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB cards based on the
 	  Philips saa7134 chip.
diff -r 54a5eca28b5d -r 160a27343cba linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Jun 20 16:07:12 2009 +0300
@@ -5155,6 +5155,25 @@
 			.gpio = 0x00,
 		},
 	},
+	[SAA7134_BOARD_VIDEOMATE_S350] = {
+		/* Jan D. Louw <jd.louw@mweb.co.za */
+		.name		= "Compro VideoMate S350/S300",
+		.audio_clock	= 0x00187de7,
+		.tuner_type	= TUNER_ABSENT,
+		.radio_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.mpeg		= SAA7134_MPEG_DVB,
+		.inputs = { {
+			.name	= name_comp1,
+			.vmux	= 0,
+			.amux	= LINE1,
+		}, {
+			.name	= name_svideo,
+			.vmux	= 8, /* Not tested */
+			.amux	= LINE1
+		} },
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6262,7 +6281,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf31d,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
-
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x185b,
+		.subdevice    = 0xc900,
+		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6776,6 +6800,11 @@
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		break;
+	case SAA7134_BOARD_VIDEOMATE_S350:
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;
 	}
 	return 0;
 }
diff -r 54a5eca28b5d -r 160a27343cba linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Jun 20 16:07:12 2009 +0300
@@ -56,6 +56,7 @@
 #include "zl10353.h"
 
 #include "zl10036.h"
+#include "zl10039.h"
 #include "mt312.h"
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
@@ -968,6 +969,10 @@
 	.tuner_address = 0x60,
 };
 
+static struct mt312_config zl10313_compro_s350_config = {
+	.demod_address = 0x0e,
+};
+
 static struct lgdt3305_config hcw_lgdt3305_config = {
 	.i2c_addr           = 0x0e,
 	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
@@ -1477,6 +1482,16 @@
 			}
 		}
 		break;
+	case SAA7134_BOARD_VIDEOMATE_S350:
+		fe0->dvb.frontend = dvb_attach(mt312_attach,
+				&zl10313_compro_s350_config, &dev->i2c_adap);
+		if (fe0->dvb.frontend)
+			if (dvb_attach(zl10039_attach, fe0->dvb.frontend,
+					0x60, &dev->i2c_adap) == NULL)
+				wprintk("%s: No zl10039 found!\n",
+					__func__);
+
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 54a5eca28b5d -r 160a27343cba linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Jun 20 16:07:12 2009 +0300
@@ -646,6 +646,11 @@
 		mask_keycode = 0x7f;
 		polling = 40; /* ms */
 		break;
+	case SAA7134_BOARD_VIDEOMATE_S350:
+		ir_codes     = ir_codes_videomate_s350;
+		mask_keycode = 0x003f00;
+		mask_keydown = 0x040000;
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
diff -r 54a5eca28b5d -r 160a27343cba linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Sat Jun 20 16:07:12 2009 +0300
@@ -293,6 +293,7 @@
 #define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
+#define SAA7134_BOARD_VIDEOMATE_S350        169
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -r 54a5eca28b5d -r 160a27343cba linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Sat Jun 20 15:54:18 2009 +0300
+++ b/linux/include/media/ir-common.h	Sat Jun 20 16:07:12 2009 +0300
@@ -162,6 +162,7 @@
 extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_videomate_s350[IR_KEYTAB_SIZE];
 #endif
 
 /*

--Boundary-00=_GVOPKFR/cLyraOS--
