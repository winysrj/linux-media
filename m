Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
To: linux-dvb@linuxtv.org, Steven Toth <stoth@linuxtv.org>,
	Steven Toth <stoth@hauppauge.com>
From: "Igor M. Liplianin" <liplianin@tut.by>
Date: Sun, 5 Oct 2008 15:35:46 +0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jSL6I+UEKLvsqsX"
Message-Id: <200810051535.47206.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2API Add support for DvbWorld USB cards with
	STV0288 demodulator.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_jSL6I+UEKLvsqsX
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Steve,
And, finally
Add support for DvbWorld USB cards with STV0288 demodulator.
Those cards use Earda EDS-1547 tuner.

Igor

--Boundary-00=_jSL6I+UEKLvsqsX
Content-Type: text/x-diff;
  charset="koi8-r";
  name="9077.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="9077.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1223208681 -10800
# Node ID 6841019c67b0886c8d6b17b8e5c2e436a0444d13
# Parent  4b968f970a42a266179113bb3280250e42ccd2f3
Add support for DvbWorld USB cards with STV0288 demodulator.

From: Igor M. Liplianin <liplianin@me.by>

Add support for DvbWorld USB cards with STV0288 demodulator.
Those cards use Earda EDS-1547 tuner.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 4b968f970a42 -r 6841019c67b0 linux/drivers/media/dvb/dvb-usb/Kconfig
--- a/linux/drivers/media/dvb/dvb-usb/Kconfig	Sun Oct 05 14:57:11 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/Kconfig	Sun Oct 05 15:11:21 2008 +0300
@@ -253,6 +253,8 @@
 	depends on DVB_USB
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_STV0288 if !DVB_FE_CUSTOMISE
+	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	help
diff -r 4b968f970a42 -r 6841019c67b0 linux/drivers/media/dvb/dvb-usb/dw2102.c
--- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	Sun Oct 05 14:57:11 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	Sun Oct 05 15:11:21 2008 +0300
@@ -14,6 +14,9 @@
 #include "si21xx.h"
 #include "stv0299.h"
 #include "z0194a.h"
+#include "stv0288.h"
+#include "stb6000.h"
+#include "eds1547.h"
 #include "cx24116.h"
 
 #ifndef USB_PID_DW2102
@@ -199,6 +202,78 @@
 	mutex_unlock(&d->i2c_mutex);
 	return num;
 }
+static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
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
+	case 2: {
+		/* read */
+		/* first write first register number */
+		u8 ibuf [msg[1].len + 2], obuf[3];
+		obuf[0] = 0xd0;
+		obuf[1] = msg[0].len;
+		obuf[2] = msg[0].buf[0];
+		ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+				obuf, msg[0].len + 2, DW210X_WRITE_MSG);
+		/* second read registers */
+		ret = dw210x_op_rw(d->udev, 0xc3, 0xd1 , 0,
+				ibuf, msg[1].len + 2, DW210X_READ_MSG);
+		memcpy(msg[1].buf, ibuf + 2, msg[1].len);
+
+		break;
+	}
+	case 1:
+		switch (msg[0].addr) {
+		case 0x68: {
+			/* write to register */
+			u8 obuf[msg[0].len + 2];
+			obuf[0] = 0xd0;
+			obuf[1] = msg[0].len;
+			memcpy(obuf + 2, msg[0].buf, msg[0].len);
+			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+					obuf, msg[0].len + 2, DW210X_WRITE_MSG);
+			break;
+		}
+		case 0x61: {
+			/* write to tuner */
+			u8 obuf[msg[0].len + 2];
+			obuf[0] = 0xc2;
+			obuf[1] = msg[0].len;
+			memcpy(obuf + 2, msg[0].buf, msg[0].len);
+			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+					obuf, msg[0].len + 2, DW210X_WRITE_MSG);
+			break;
+		}
+		case(DW2102_RC_QUERY): {
+			u8 ibuf[2];
+			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+					ibuf, 2, DW210X_READ_MSG);
+			memcpy(msg[0].buf, ibuf , 2);
+			break;
+		}
+		case(DW2102_VOLTAGE_CTRL): {
+			u8 obuf[2];
+			obuf[0] = 0x30;
+			obuf[1] = msg[0].buf[0];
+			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
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
 
 static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
@@ -294,6 +369,11 @@
 
 static struct i2c_algorithm dw2102_serit_i2c_algo = {
 	.master_xfer = dw2102_serit_i2c_transfer,
+	.functionality = dw210x_i2c_func,
+};
+
+static struct i2c_algorithm dw2102_earda_i2c_algo = {
+	.master_xfer = dw2102_earda_i2c_transfer,
 	.functionality = dw210x_i2c_func,
 };
 
@@ -378,6 +458,17 @@
 			return 0;
 		}
 	}
+	if (dw2102_properties.i2c_algo == &dw2102_earda_i2c_algo) {
+		/*dw2102_properties.adapter->tuner_attach = dw2102_tuner_attach;*/
+		d->fe = dvb_attach(stv0288_attach, &earda_config,
+					&d->dev->i2c_adap);
+		if (d->fe != NULL) {
+			d->fe->ops.set_voltage = dw210x_set_voltage;
+			info("Attached stv0288!\n");
+			return 0;
+		}
+	}
+
 	if (dw2102_properties.i2c_algo == &dw2102_i2c_algo) {
 		/*dw2102_properties.adapter->tuner_attach = dw2102_tuner_attach;*/
 		d->fe = dvb_attach(stv0299_attach, &sharp_z0194a_config,
@@ -395,6 +486,14 @@
 {
 	dvb_attach(dvb_pll_attach, adap->fe, 0x60,
 		&adap->dev->i2c_adap, DVB_PLL_OPERA1);
+	return 0;
+}
+
+static int dw2102_earda_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	dvb_attach(stb6000_attach, adap->fe, 0x61,
+		&adap->dev->i2c_adap);
+
 	return 0;
 }
 
@@ -478,7 +577,7 @@
 	u8 *b, *p;
 	int ret = 0, i;
 	u8 reset;
-	u8 reset16 [] = {0, 0, 0, 0, 0, 0, 0};
+	u8 reset16[] = {0, 0, 0, 0, 0, 0, 0};
 	const struct firmware *fw;
 	const char *filename = "dvb-usb-dw2101.fw";
 	switch (dev->descriptor.idProduct) {
@@ -544,9 +643,25 @@
 			/* check STV0299 frontend  */
 			dw210x_op_rw(dev, 0xb5, 0, 0, &reset16[0], 2,
 					DW210X_READ_MSG);
-			if (reset16[0] == 0xa1)
+			if (reset16[0] == 0xa1) {
 				dw2102_properties.i2c_algo = &dw2102_i2c_algo;
-			break;
+				dw2102_properties.adapter->tuner_attach = &dw2102_tuner_attach;
+				break;
+			} else {
+				/* check STV0288 frontend  */
+				reset16[0] = 0xd0;
+				reset16[1] = 1;
+				reset16[2] = 0;
+				dw210x_op_rw(dev, 0xc2, 0, 0, &reset16[0], 3,
+						DW210X_WRITE_MSG);
+				dw210x_op_rw(dev, 0xc3, 0xd1, 0, &reset16[0], 3,
+						DW210X_READ_MSG);
+				if (reset16[2] == 0x11) {
+					dw2102_properties.i2c_algo = &dw2102_earda_i2c_algo;
+					dw2102_properties.adapter->tuner_attach = &dw2102_earda_tuner_attach;
+					break;
+				}
+			}
 		case 0x2101:
 			dw210x_op_rw(dev, 0xbc, 0x0030, 0, &reset16[0], 2,
 					DW210X_READ_MSG);
@@ -586,7 +701,7 @@
 		{
 			.frontend_attach = dw2102_frontend_attach,
 			.streaming_ctrl = NULL,
-			.tuner_attach = dw2102_tuner_attach,
+			.tuner_attach = NULL,
 			.stream = {
 				.type = USB_BULK,
 				.count = 8,
diff -r 4b968f970a42 -r 6841019c67b0 linux/drivers/media/dvb/frontends/eds1547.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/eds1547.h	Sun Oct 05 15:11:21 2008 +0300
@@ -0,0 +1,133 @@
+/* eds1547.h Earda EDS-1547 tuner support
+*
+* Copyright (C) 2008 Igor M. Liplianin (liplianin@me.by)
+*
+*	This program is free software; you can redistribute it and/or modify it
+*	under the terms of the GNU General Public License as published by the
+*	Free Software Foundation, version 2.
+*
+* see Documentation/dvb/README.dvb-usb for more information
+*/
+
+#ifndef EDS1547
+#define EDS1547
+
+static u8 stv0288_earda_inittab[] = {
+	0x01, 0x57,
+	0x02, 0x20,
+	0x03, 0x8e,
+	0x04, 0x8e,
+	0x05, 0x12,
+	0x06, 0x00,
+	0x07, 0x00,
+	0x09, 0x00,
+	0x0a, 0x04,
+	0x0b, 0x00,
+	0x0c, 0x00,
+	0x0d, 0x00,
+	0x0e, 0xd4,
+	0x0f, 0x30,
+	0x11, 0x44,
+	0x12, 0x03,
+	0x13, 0x48,
+	0x14, 0x84,
+	0x15, 0x45,
+	0x16, 0xb7,
+	0x17, 0x9c,
+	0x18, 0x00,
+	0x19, 0xa6,
+	0x1a, 0x88,
+	0x1b, 0x8f,
+	0x1c, 0xf0,
+	0x20, 0x0b,
+	0x21, 0x54,
+	0x22, 0x00,
+	0x23, 0x00,
+	0x2b, 0xff,
+	0x2c, 0xf7,
+	0x30, 0x00,
+	0x31, 0x1e,
+	0x32, 0x14,
+	0x33, 0x0f,
+	0x34, 0x09,
+	0x35, 0x0c,
+	0x36, 0x05,
+	0x37, 0x2f,
+	0x38, 0x16,
+	0x39, 0xbd,
+	0x3a, 0x00,
+	0x3b, 0x13,
+	0x3c, 0x11,
+	0x3d, 0x30,
+	0x40, 0x63,
+	0x41, 0x04,
+	0x42, 0x60,
+	0x43, 0x00,
+	0x44, 0x00,
+	0x45, 0x00,
+	0x46, 0x00,
+	0x47, 0x00,
+	0x4a, 0x00,
+	0x50, 0x10,
+	0x51, 0x36,
+	0x52, 0x09,
+	0x53, 0x94,
+	0x54, 0x62,
+	0x55, 0x29,
+	0x56, 0x64,
+	0x57, 0x2b,
+	0x58, 0x54,
+	0x59, 0x86,
+	0x5a, 0x00,
+	0x5b, 0x9b,
+	0x5c, 0x08,
+	0x5d, 0x7f,
+	0x5e, 0x00,
+	0x5f, 0xff,
+	0x70, 0x00,
+	0x71, 0x00,
+	0x72, 0x00,
+	0x74, 0x00,
+	0x75, 0x00,
+	0x76, 0x00,
+	0x81, 0x00,
+	0x82, 0x3f,
+	0x83, 0x3f,
+	0x84, 0x00,
+	0x85, 0x00,
+	0x88, 0x00,
+	0x89, 0x00,
+	0x8a, 0x00,
+	0x8b, 0x00,
+	0x8c, 0x00,
+	0x90, 0x00,
+	0x91, 0x00,
+	0x92, 0x00,
+	0x93, 0x00,
+	0x94, 0x1c,
+	0x97, 0x00,
+	0xa0, 0x48,
+	0xa1, 0x00,
+	0xb0, 0xb8,
+	0xb1, 0x3a,
+	0xb2, 0x10,
+	0xb3, 0x82,
+	0xb4, 0x80,
+	0xb5, 0x82,
+	0xb6, 0x82,
+	0xb7, 0x82,
+	0xb8, 0x20,
+	0xb9, 0x00,
+	0xf0, 0x00,
+	0xf1, 0x00,
+	0xf2, 0xc0,
+	0xff,0xff,
+};
+
+static struct stv0288_config earda_config = {
+	.demod_address = 0x68,
+	.min_delay_ms = 100,
+	.inittab = stv0288_earda_inittab,
+};
+
+#endif

--Boundary-00=_jSL6I+UEKLvsqsX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_jSL6I+UEKLvsqsX--
