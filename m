Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Thu, 18 Sep 2008 01:27:50 +0300
References: <48CA0355.6080903@linuxtv.org> <48CE9E22.9060405@hauppauge.com>
	<200809170037.59770.liplianin@tut.by>
In-Reply-To: <200809170037.59770.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mRY0IjzOPi6Sipl"
Message-Id: <200809180127.50686.liplianin@tut.by>
Cc: Steven Toth <stoth@hauppauge.com>
Subject: Re: [linux-dvb] [PATCH] S2API - Add support for USB card
	modification with si2109/2110 demodulator.
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

--Boundary-00=_mRY0IjzOPi6Sipl
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 17 September 2008 00:37:59 Igor M. L=
iplianin =CE=C1=D0=C9=D3=C1=CC(=C1):
> Hi Steve,
>
> Send you patch for Silicon Laboratories si2109/2110 demodulator support.
>
> https://www.silabs.com/products/audiovideo/satellitestb/Pages/default.aspx
>
> It is S2API compliant, as of september, 16-th
>
> Igor

Add support for USB card modification with si2109/2110 demodulator.
It is DvbWorld 2102 and TeVii s600 modification with Serit tuner.

Igor

--Boundary-00=_mRY0IjzOPi6Sipl
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8886.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8886.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1221689959 -10800
# Node ID c34ef754e8e02a557b444f3a891d0293e12c2cf3
# Parent  4784f1dc5ad010b2a4c3938e1f732f9b40cca626
Add support for USB card modification with SI2109/2110 demodulator.

From: Igor M. Liplianin <liplianin@me.by>

Add support for USB card modification with SI2109/2110 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 4784f1dc5ad0 -r c34ef754e8e0 linux/drivers/media/dvb/dvb-usb/dw2102.c
--- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	Tue Sep 16 23:02:20 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	Thu Sep 18 01:19:19 2008 +0300
@@ -11,6 +11,7 @@
 */
 #include <linux/version.h>
 #include "dw2102.h"
+#include "si21xx.h"
 #include "stv0299.h"
 #include "z0194a.h"
 #include "cx24116.h"
@@ -23,8 +24,8 @@
 #define USB_PID_DW2104 0x2104
 #endif
 
-#define DW2102_READ_MSG 0
-#define DW2102_WRITE_MSG 1
+#define DW210X_READ_MSG 0
+#define DW210X_WRITE_MSG 1
 
 #define REG_1F_SYMBOLRATE_BYTE0 0x1f
 #define REG_20_SYMBOLRATE_BYTE1 0x20
@@ -33,10 +34,10 @@
 #define DW2102_VOLTAGE_CTRL (0x1800)
 #define DW2102_RC_QUERY (0x1a00)
 
-struct dw2102_state {
+struct dw210x_state {
 	u32 last_key_pressed;
 };
-struct dw2102_rc_keys {
+struct dw210x_rc_keys {
 	u32 keycode;
 	u32 event;
 };
@@ -48,28 +49,27 @@
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-static int dw2102_op_rw(struct usb_device *dev, u8 request, u16 value,
+static int dw210x_op_rw(struct usb_device *dev, u8 request, u16 value,
 			u16 index, u8 * data, u16 len, int flags)
 {
 	int ret;
 	u8 u8buf[len];
 
-	unsigned int pipe = (flags == DW2102_READ_MSG) ?
+	unsigned int pipe = (flags == DW210X_READ_MSG) ?
 				usb_rcvctrlpipe(dev, 0) : usb_sndctrlpipe(dev, 0);
-	u8 request_type = (flags == DW2102_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
+	u8 request_type = (flags == DW210X_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
 
-	if (flags == DW2102_WRITE_MSG)
+	if (flags == DW210X_WRITE_MSG)
 		memcpy(u8buf, data, len);
 	ret = usb_control_msg(dev, pipe, request, request_type | USB_TYPE_VENDOR,
 				value, index , u8buf, len, 2000);
 
-	if (flags == DW2102_READ_MSG)
+	if (flags == DW210X_READ_MSG)
 		memcpy(data, u8buf, len);
 	return ret;
 }
 
 /* I2C */
-
 static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		int num)
 {
@@ -89,10 +89,9 @@
 		value = msg[0].buf[0];/* register */
 		for (i = 0; i < msg[1].len; i++) {
 			value = value + i;
-			ret = dw2102_op_rw(d->udev, 0xb5, value, 0,
-					buf6, 2, DW2102_READ_MSG);
+			ret = dw210x_op_rw(d->udev, 0xb5, value, 0,
+					buf6, 2, DW210X_READ_MSG);
 			msg[1].buf[i] = buf6[0];
-
 		}
 		break;
 	case 1:
@@ -102,8 +101,8 @@
 			buf6[0] = 0x2a;
 			buf6[1] = msg[0].buf[0];
 			buf6[2] = msg[0].buf[1];
-			ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
-					buf6, 3, DW2102_WRITE_MSG);
+			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+					buf6, 3, DW210X_WRITE_MSG);
 			break;
 		case 0x60:
 			if (msg[0].flags == 0) {
@@ -115,29 +114,85 @@
 				buf6[4] = msg[0].buf[1];
 				buf6[5] = msg[0].buf[2];
 				buf6[6] = msg[0].buf[3];
-				ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
-						buf6, 7, DW2102_WRITE_MSG);
+				ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+						buf6, 7, DW210X_WRITE_MSG);
 			} else {
 			/* read from tuner */
-				ret = dw2102_op_rw(d->udev, 0xb5, 0,0,
-						buf6, 1, DW2102_READ_MSG);
+				ret = dw210x_op_rw(d->udev, 0xb5, 0, 0,
+						buf6, 1, DW210X_READ_MSG);
 				msg[0].buf[0] = buf6[0];
 			}
 			break;
 		case (DW2102_RC_QUERY):
-			ret  = dw2102_op_rw(d->udev, 0xb8, 0, 0,
-					buf6, 2, DW2102_READ_MSG);
+			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+					buf6, 2, DW210X_READ_MSG);
 			msg[0].buf[0] = buf6[0];
 			msg[0].buf[1] = buf6[1];
 			break;
 		case (DW2102_VOLTAGE_CTRL):
 			buf6[0] = 0x30;
 			buf6[1] = msg[0].buf[0];
-			ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
-					buf6, 2, DW2102_WRITE_MSG);
+			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+					buf6, 2, DW210X_WRITE_MSG);
 			break;
 		}
 
+		break;
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	return num;
+}
+
+static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
+						struct i2c_msg msg[], int num)
+{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret = 0;
+	u8 buf6[] = {0, 0, 0, 0, 0, 0, 0};
+
+	if (!d)
+		return -ENODEV;
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	switch (num) {
+	case 2:
+		/* read si2109 register by number */
+		buf6[0] = 0xd0;
+		buf6[1] = msg[0].len;
+		buf6[2] = msg[0].buf[0];
+		ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+				buf6, msg[0].len + 2, DW210X_WRITE_MSG);
+		/* read si2109 register */
+		ret = dw210x_op_rw(d->udev, 0xc3, 0xd0, 0,
+				buf6, msg[1].len + 2, DW210X_READ_MSG);
+		memcpy(msg[1].buf, buf6 + 2, msg[1].len);
+
+		break;
+	case 1:
+		switch (msg[0].addr) {
+		case 0x68:
+			/* write to si2109 register */
+			buf6[0] = 0xd0;
+			buf6[1] = msg[0].len;
+			memcpy(buf6 + 2, msg[0].buf, msg[0].len);
+			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0, buf6,
+					msg[0].len + 2, DW210X_WRITE_MSG);
+			break;
+		case(DW2102_RC_QUERY):
+			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+					buf6, 2, DW210X_READ_MSG);
+			msg[0].buf[0] = buf6[0];
+			msg[0].buf[1] = buf6[1];
+			break;
+		case(DW2102_VOLTAGE_CTRL):
+			buf6[0] = 0x30;
+			buf6[1] = msg[0].buf[0];
+			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+					buf6, 2, DW210X_WRITE_MSG);
+			break;
+		}
 		break;
 	}
 
@@ -164,11 +219,11 @@
 		obuf[0] = 0xaa;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
-		ret = dw2102_op_rw(d->udev, 0xc2, 0, 0,
-				obuf, msg[0].len + 2, DW2102_WRITE_MSG);
+		ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+				obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 		/* second read registers */
-		ret = dw2102_op_rw(d->udev, 0xc3, 0xab , 0,
-				ibuf, msg[1].len + 2, DW2102_READ_MSG);
+		ret = dw210x_op_rw(d->udev, 0xc3, 0xab , 0,
+				ibuf, msg[1].len + 2, DW210X_READ_MSG);
 		memcpy(msg[1].buf, ibuf + 2, msg[1].len);
 
 		break;
@@ -187,8 +242,8 @@
 				i = 1;
 				do {
 					memcpy(obuf + 3, msg[0].buf + i, (len > 16 ? 16 : len));
-					ret = dw2102_op_rw(d->udev, 0xc2, 0, 0,
-						obuf, (len > 16 ? 16 : len) + 3, DW2102_WRITE_MSG);
+					ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+						obuf, (len > 16 ? 16 : len) + 3, DW210X_WRITE_MSG);
 					i += 16;
 					len -= 16;
 				} while (len > 0);
@@ -198,15 +253,15 @@
 				obuf[0] = 0xaa;
 				obuf[1] = msg[0].len;
 				memcpy(obuf + 2, msg[0].buf, msg[0].len);
-				ret = dw2102_op_rw(d->udev, 0xc2, 0, 0,
-						obuf, msg[0].len + 2, DW2102_WRITE_MSG);
+				ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+						obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 			}
 			break;
 		}
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
-			ret  = dw2102_op_rw(d->udev, 0xb8, 0, 0,
-					ibuf, 2, DW2102_READ_MSG);
+			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+					ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[0].buf, ibuf , 2);
 			break;
 		}
@@ -214,8 +269,8 @@
 			u8 obuf[2];
 			obuf[0] = 0x30;
 			obuf[1] = msg[0].buf[0];
-			ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
-					obuf, 2, DW2102_WRITE_MSG);
+			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+					obuf, 2, DW210X_WRITE_MSG);
 			break;
 		}
 		}
@@ -227,29 +282,34 @@
 	return num;
 }
 
-static u32 dw2102_i2c_func(struct i2c_adapter *adapter)
+static u32 dw210x_i2c_func(struct i2c_adapter *adapter)
 {
 	return I2C_FUNC_I2C;
 }
 
 static struct i2c_algorithm dw2102_i2c_algo = {
 	.master_xfer = dw2102_i2c_transfer,
-	.functionality = dw2102_i2c_func,
+	.functionality = dw210x_i2c_func,
+};
+
+static struct i2c_algorithm dw2102_serit_i2c_algo = {
+	.master_xfer = dw2102_serit_i2c_transfer,
+	.functionality = dw210x_i2c_func,
 };
 
 static struct i2c_algorithm dw2104_i2c_algo = {
 	.master_xfer = dw2104_i2c_transfer,
-	.functionality = dw2102_i2c_func,
+	.functionality = dw210x_i2c_func,
 };
 
-static int dw2102_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
+static int dw210x_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 {
 	int i;
 	u8 ibuf[] = {0, 0};
 	u8 eeprom[256], eepromline[16];
 
 	for (i = 0; i < 256; i++) {
-		if (dw2102_op_rw(d->udev, 0xb6, 0xa0 , i, ibuf, 2, DW2102_READ_MSG) < 0) {
+		if (dw210x_op_rw(d->udev, 0xb6, 0xa0 , i, ibuf, 2, DW210X_READ_MSG) < 0) {
 			err("read eeprom failed.");
 			return -1;
 		} else {
@@ -265,7 +325,7 @@
 	return 0;
 };
 
-static int dw2102_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+static int dw210x_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	static u8 command_13v[1] = {0x00};
 	static u8 command_18v[1] = {0x01};
@@ -287,25 +347,46 @@
 	.mpg_clk_pos_pol = 0x01,
 };
 
+static struct si21xx_config serit_sp1511lhb_config = {
+	.demod_address = 0x68,
+	.min_delay_ms = 100,
+
+};
+
 static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
 {
 	if ((d->fe = dvb_attach(cx24116_attach, &dw2104_config,
 			&d->dev->i2c_adap)) != NULL) {
-		d->fe->ops.set_voltage = dw2102_set_voltage;
+		d->fe->ops.set_voltage = dw210x_set_voltage;
 		info("Attached cx24116!\n");
 		return 0;
 	}
 	return -EIO;
 }
 
+static struct dvb_usb_device_properties dw2102_properties;
+
 static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
 {
-	d->fe = dvb_attach(stv0299_attach, &sharp_z0194a_config,
-		&d->dev->i2c_adap);
-	if (d->fe != NULL) {
-		d->fe->ops.set_voltage = dw2102_set_voltage;
-		info("Attached stv0299!\n");
-		return 0;
+	if (dw2102_properties.i2c_algo == &dw2102_serit_i2c_algo) {
+		/*dw2102_properties.adapter->tuner_attach = NULL;*/
+		d->fe = dvb_attach(si21xx_attach, &serit_sp1511lhb_config,
+					&d->dev->i2c_adap);
+		if (d->fe != NULL) {
+			d->fe->ops.set_voltage = dw210x_set_voltage;
+			info("Attached si21xx!\n");
+			return 0;
+		}
+	}
+	if (dw2102_properties.i2c_algo == &dw2102_i2c_algo) {
+		/*dw2102_properties.adapter->tuner_attach = dw2102_tuner_attach;*/
+		d->fe = dvb_attach(stv0299_attach, &sharp_z0194a_config,
+					&d->dev->i2c_adap);
+		if (d->fe != NULL) {
+			d->fe->ops.set_voltage = dw210x_set_voltage;
+			info("Attached stv0299!\n");
+			return 0;
+		}
 	}
 	return -EIO;
 }
@@ -317,7 +398,7 @@
 	return 0;
 }
 
-static struct dvb_usb_rc_key dw2102_rc_keys[] = {
+static struct dvb_usb_rc_key dw210x_rc_keys[] = {
 	{ 0xf8,	0x0a, KEY_Q },		/*power*/
 	{ 0xf8,	0x0c, KEY_M },		/*mute*/
 	{ 0xf8,	0x11, KEY_1 },
@@ -356,7 +437,7 @@
 
 static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	struct dw2102_state *st = d->priv;
+	struct dw210x_state *st = d->priv;
 	u8 key[2];
 	struct i2c_msg msg[] = {
 		{.addr = DW2102_RC_QUERY, .flags = I2C_M_RD, .buf = key,
@@ -366,12 +447,12 @@
 
 	*state = REMOTE_NO_KEY_PRESSED;
 	if (dw2102_i2c_transfer(&d->i2c_adap, msg, 1) == 1) {
-		for (i = 0; i < ARRAY_SIZE(dw2102_rc_keys); i++) {
-			if (dw2102_rc_keys[i].data == msg[0].buf[0]) {
+		for (i = 0; i < ARRAY_SIZE(dw210x_rc_keys); i++) {
+			if (dw210x_rc_keys[i].data == msg[0].buf[0]) {
 				*state = REMOTE_KEY_PRESSED;
-				*event = dw2102_rc_keys[i].event;
+				*event = dw210x_rc_keys[i].event;
 				st->last_key_pressed =
-					dw2102_rc_keys[i].event;
+					dw210x_rc_keys[i].event;
 				break;
 			}
 		st->last_key_pressed = 0;
@@ -418,15 +499,15 @@
 	p = kmalloc(fw->size, GFP_KERNEL);
 	reset = 1;
 	/*stop the CPU*/
-	dw2102_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1, DW2102_WRITE_MSG);
-	dw2102_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1, DW2102_WRITE_MSG);
+	dw210x_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1, DW210X_WRITE_MSG);
+	dw210x_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1, DW210X_WRITE_MSG);
 
 	if (p != NULL) {
 		memcpy(p, fw->data, fw->size);
 		for (i = 0; i < fw->size; i += 0x40) {
 			b = (u8 *) p + i;
-			if (dw2102_op_rw(dev, 0xa0, i, 0, b , 0x40,
-					DW2102_WRITE_MSG) != 0x40) {
+			if (dw210x_op_rw(dev, 0xa0, i, 0, b , 0x40,
+					DW210X_WRITE_MSG) != 0x40) {
 				err("error while transferring firmware");
 				ret = -EINVAL;
 				break;
@@ -434,13 +515,13 @@
 		}
 		/* restart the CPU */
 		reset = 0;
-		if (ret || dw2102_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1,
-					DW2102_WRITE_MSG) != 1) {
+		if (ret || dw210x_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1,
+					DW210X_WRITE_MSG) != 1) {
 			err("could not restart the USB controller CPU.");
 			ret = -EINVAL;
 		}
-		if (ret || dw2102_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1,
-					DW2102_WRITE_MSG) != 1) {
+		if (ret || dw210x_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1,
+					DW210X_WRITE_MSG) != 1) {
 			err("could not restart the USB controller CPU.");
 			ret = -EINVAL;
 		}
@@ -449,27 +530,32 @@
 		case USB_PID_DW2104:
 		case 0xd650:
 			reset = 1;
-			dw2102_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
-					DW2102_WRITE_MSG);
+			dw210x_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
+					DW210X_WRITE_MSG);
 			reset = 0;
-			dw2102_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
-					DW2102_WRITE_MSG);
+			dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
+					DW210X_WRITE_MSG);
 			break;
 		case USB_PID_DW2102:
-			dw2102_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
-					DW2102_WRITE_MSG);
-			dw2102_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
-					DW2102_READ_MSG);
+			dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
+					DW210X_WRITE_MSG);
+			dw210x_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
+					DW210X_READ_MSG);
+			/* check STV0299 frontend  */
+			dw210x_op_rw(dev, 0xb5, 0, 0, &reset16[0], 2,
+					DW210X_READ_MSG);
+			if (reset16[0] == 0xa1)
+				dw2102_properties.i2c_algo = &dw2102_i2c_algo;
 			break;
 		case 0x2101:
-			dw2102_op_rw(dev, 0xbc, 0x0030, 0, &reset16[0], 2,
-					DW2102_READ_MSG);
-			dw2102_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
-					DW2102_READ_MSG);
-			dw2102_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
-					DW2102_READ_MSG);
-			dw2102_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
-					DW2102_READ_MSG);
+			dw210x_op_rw(dev, 0xbc, 0x0030, 0, &reset16[0], 2,
+					DW210X_READ_MSG);
+			dw210x_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
+					DW210X_READ_MSG);
+			dw210x_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
+					DW210X_READ_MSG);
+			dw210x_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
+					DW210X_READ_MSG);
 			break;
 		}
 		msleep(100);
@@ -482,12 +568,12 @@
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
 	.firmware = "dvb-usb-dw2102.fw",
-	.size_of_priv = sizeof(struct dw2102_state),
+	.size_of_priv = sizeof(struct dw210x_state),
 	.no_reconnect = 1,
 
-	.i2c_algo = &dw2102_i2c_algo,
-	.rc_key_map = dw2102_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dw2102_rc_keys),
+	.i2c_algo = &dw2102_serit_i2c_algo,
+	.rc_key_map = dw210x_rc_keys,
+	.rc_key_map_size = ARRAY_SIZE(dw210x_rc_keys),
 	.rc_interval = 150,
 	.rc_query = dw2102_rc_query,
 
@@ -495,7 +581,7 @@
 	/* parameter for the MPEG2-data transfer */
 	.num_adapters = 1,
 	.download_firmware = dw2102_load_firmware,
-	.read_mac_address = dw2102_read_mac_address,
+	.read_mac_address = dw210x_read_mac_address,
 		.adapter = {
 		{
 			.frontend_attach = dw2102_frontend_attach,
@@ -530,12 +616,12 @@
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
 	.firmware = "dvb-usb-dw2104.fw",
-	.size_of_priv = sizeof(struct dw2102_state),
+	.size_of_priv = sizeof(struct dw210x_state),
 	.no_reconnect = 1,
 
 	.i2c_algo = &dw2104_i2c_algo,
-	.rc_key_map = dw2102_rc_keys,
-	.rc_key_map_size = ARRAY_SIZE(dw2102_rc_keys),
+	.rc_key_map = dw210x_rc_keys,
+	.rc_key_map_size = ARRAY_SIZE(dw210x_rc_keys),
 	.rc_interval = 150,
 	.rc_query = dw2102_rc_query,
 
@@ -543,7 +629,7 @@
 	/* parameter for the MPEG2-data transfer */
 	.num_adapters = 1,
 	.download_firmware = dw2102_load_firmware,
-	.read_mac_address = dw2102_read_mac_address,
+	.read_mac_address = dw210x_read_mac_address,
 	.adapter = {
 		{
 			.frontend_attach = dw2104_frontend_attach,

--Boundary-00=_mRY0IjzOPi6Sipl
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_mRY0IjzOPi6Sipl--
