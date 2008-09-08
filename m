Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: Steven Toth <stoth@linuxtv.org>
Date: Mon, 8 Sep 2008 23:34:04 +0300
References: <48BF6A09.3020205@linuxtv.org>
	<200809061457.59955.liplianin@tut.by>
	<48C539D9.4080900@linuxtv.org>
In-Reply-To: <48C539D9.4080900@linuxtv.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8wYxInvRFRA2T9G"
Message-Id: <200809082334.04511.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] S2 - DVBWorld 2104, TeVii S650
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

--Boundary-00=_8wYxInvRFRA2T9G
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Patch for DVBWorld 2104, TeVii S650 cx24116 based cards.

--Boundary-00=_8wYxInvRFRA2T9G
Content-Type: text/plain;
  name="s650.patch"
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1220905000 -10800
# Node ID f2def1a82981126faf2cc67d30a2994daeb95e69
# Parent ffa9a0c644b388d58682eeacec6e958e9088ea96
Added support for DVBWorld 2104 and TeVii S650 USB DVB-S2 cards

From: Igor M. Liplianin <liplianin@me.by>

Added support for DVBWorld 2104 and TeVii S650 USB DVB-S2 cards
This cards based on cx24116 demodulator.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

--- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	Mon Sep 08 23:16:40 2008 +0300
@@ -1,4 +1,5 @@
-/* DVB USB framework compliant Linux driver for the DVBWorld DVB-S 2102 Card
+/* DVB USB framework compliant Linux driver for the 
+*	DVBWorld DVB-S 2101, 2102, DVB-S2 2104 Card
 *
 * Copyright (C) 2008 Igor M. Liplianin (liplianin@me.by)
 *
@@ -12,9 +13,14 @@
 #include "dw2102.h"
 #include "stv0299.h"
 #include "z0194a.h"
+#include "cx24116.h"
 
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
+#endif
+
+#ifndef USB_PID_DW2104
+#define USB_PID_DW2104 0x2104
 #endif
 
 #define DW2102_READ_MSG 0
@@ -23,7 +29,7 @@
 #define REG_1F_SYMBOLRATE_BYTE0 0x1f
 #define REG_20_SYMBOLRATE_BYTE1 0x20
 #define REG_21_SYMBOLRATE_BYTE2 0x21
-
+/* on my own*/
 #define DW2102_VOLTAGE_CTRL (0x1800)
 #define DW2102_RC_QUERY (0x1a00)
 
@@ -35,22 +41,27 @@
 	u32 event;
 };
 
+/* debug */
+static int dvb_usb_dw2102_debug;
+module_param_named(debug, dvb_usb_dw2102_debug, int, 0644);
+MODULE_PARM_DESC(debug, "set debugging level (1=info 2=xfer (or-able))." DVB_USB_DEBUG_STATUS);
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int dw2102_op_rw(struct usb_device *dev, u8 request, u16 value,
-		u8 *data, u16 len, int flags)
+			u16 index, u8 * data, u16 len, int flags)
 {
 	int ret;
 	u8 u8buf[len];
 
 	unsigned int pipe = (flags == DW2102_READ_MSG) ?
-		usb_rcvctrlpipe(dev, 0) : usb_sndctrlpipe(dev, 0);
+				usb_rcvctrlpipe(dev, 0) : usb_sndctrlpipe(dev, 0);
 	u8 request_type = (flags == DW2102_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
 
 	if (flags == DW2102_WRITE_MSG)
 		memcpy(u8buf, data, len);
-	ret = usb_control_msg(dev, pipe, request,
-		request_type | USB_TYPE_VENDOR, value, 0 , u8buf, len, 2000);
+	ret = usb_control_msg(dev, pipe, request, request_type | USB_TYPE_VENDOR,
+				value, index , u8buf, len, 2000);
 
 	if (flags == DW2102_READ_MSG)
 		memcpy(data, u8buf, len);
@@ -65,7 +76,6 @@
 struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i = 0, ret = 0;
 	u8 buf6[] = {0x2c, 0x05, 0xc0, 0, 0, 0, 0};
-	u8 request;
 	u16 value;
 
 	if (!d)
@@ -76,12 +86,11 @@
 	switch (num) {
 	case 2:
 		/* read stv0299 register */
-		request = 0xb5;
 		value = msg[0].buf[0];/* register */
 		for (i = 0; i < msg[1].len; i++) {
 			value = value + i;
-			ret = dw2102_op_rw(d->udev, 0xb5,
-				value, buf6, 2, DW2102_READ_MSG);
+			ret = dw2102_op_rw(d->udev, 0xb5, value, 0,
+					buf6, 2, DW2102_READ_MSG);
 			msg[1].buf[i] = buf6[0];
 
 		}
@@ -93,8 +102,8 @@
 			buf6[0] = 0x2a;
 			buf6[1] = msg[0].buf[0];
 			buf6[2] = msg[0].buf[1];
-			ret = dw2102_op_rw(d->udev, 0xb2,
-				0, buf6, 3, DW2102_WRITE_MSG);
+			ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
+					buf6, 3, DW2102_WRITE_MSG);
 			break;
 		case 0x60:
 			if (msg[0].flags == 0) {
@@ -106,27 +115,109 @@
 				buf6[4] = msg[0].buf[1];
 				buf6[5] = msg[0].buf[2];
 				buf6[6] = msg[0].buf[3];
-				ret = dw2102_op_rw(d->udev, 0xb2,
-				0, buf6, 7, DW2102_WRITE_MSG);
+				ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
+						buf6, 7, DW2102_WRITE_MSG);
 			} else {
-			/* write to tuner pll */
-				ret = dw2102_op_rw(d->udev, 0xb5,
-				0, buf6, 1, DW2102_READ_MSG);
+			/* read from tuner */
+				ret = dw2102_op_rw(d->udev, 0xb5, 0,0,
+						buf6, 1, DW2102_READ_MSG);
 				msg[0].buf[0] = buf6[0];
 			}
 			break;
 		case (DW2102_RC_QUERY):
-			ret  = dw2102_op_rw(d->udev, 0xb8,
-				0, buf6, 2, DW2102_READ_MSG);
+			ret  = dw2102_op_rw(d->udev, 0xb8, 0, 0,
+					buf6, 2, DW2102_READ_MSG);
 			msg[0].buf[0] = buf6[0];
 			msg[0].buf[1] = buf6[1];
 			break;
 		case (DW2102_VOLTAGE_CTRL):
 			buf6[0] = 0x30;
 			buf6[1] = msg[0].buf[0];
-			ret = dw2102_op_rw(d->udev, 0xb2,
-				0, buf6, 2, DW2102_WRITE_MSG);
+			ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
+					buf6, 2, DW2102_WRITE_MSG);
 			break;
+		}
+
+		break;
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	return num;
+}
+
+static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
+{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret = 0;
+	int len, i;
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
+		obuf[0] = 0xaa;
+		obuf[1] = msg[0].len;
+		obuf[2] = msg[0].buf[0];
+		ret = dw2102_op_rw(d->udev, 0xc2, 0, 0,
+				obuf, msg[0].len + 2, DW2102_WRITE_MSG);
+		/* second read registers */
+		ret = dw2102_op_rw(d->udev, 0xc3, 0xab , 0,
+				ibuf, msg[1].len + 2, DW2102_READ_MSG);
+		memcpy(msg[1].buf, ibuf + 2, msg[1].len);
+
+		break;
+	}
+	case 1:
+		switch (msg[0].addr) {
+		case 0x55: {
+			if (msg[0].buf[0] == 0xf7) {
+				/* firmware */
+				/* Write in small blocks */
+				u8 obuf[19];
+				obuf[0] = 0xaa;
+				obuf[1] = 0x11;
+				obuf[2] = 0xf7;
+				len = msg[0].len - 1;
+				i = 1;
+				do {
+					memcpy(obuf + 3, msg[0].buf + i, (len > 16 ? 16 : len));
+					ret = dw2102_op_rw(d->udev, 0xc2, 0, 0,
+						obuf, (len > 16 ? 16 : len) + 3, DW2102_WRITE_MSG);
+					i += 16;
+					len -= 16;
+				} while (len > 0);
+			} else {
+				/* write to register */
+				u8 obuf[msg[0].len + 2];
+				obuf[0] = 0xaa;
+				obuf[1] = msg[0].len;
+				memcpy(obuf + 2, msg[0].buf, msg[0].len);
+				ret = dw2102_op_rw(d->udev, 0xc2, 0, 0,
+						obuf, msg[0].len + 2, DW2102_WRITE_MSG);
+			}
+			break;
+		}
+		case(DW2102_RC_QUERY): {
+			u8 ibuf[2];
+			ret  = dw2102_op_rw(d->udev, 0xb8, 0, 0,
+					ibuf, 2, DW2102_READ_MSG);
+			memcpy(msg[0].buf, ibuf , 2);
+			break;
+		}
+		case(DW2102_VOLTAGE_CTRL): {
+			u8 obuf[2];
+			obuf[0] = 0x30;
+			obuf[1] = msg[0].buf[0];
+			ret = dw2102_op_rw(d->udev, 0xb2, 0, 0,
+					obuf, 2, DW2102_WRITE_MSG);
+			break;
+		}
 		}
 
 		break;
@@ -146,6 +237,34 @@
 	.functionality = dw2102_i2c_func,
 };
 
+static struct i2c_algorithm dw2104_i2c_algo = {
+	.master_xfer = dw2104_i2c_transfer,
+	.functionality = dw2102_i2c_func,
+};
+
+static int dw2102_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
+{
+	int i;
+	u8 ibuf[] = {0, 0};
+	u8 eeprom[256], eepromline[16];
+
+	for (i = 0; i < 256; i++) {
+		if (dw2102_op_rw(d->udev, 0xb6, 0xa0 , i, ibuf, 2, DW2102_READ_MSG) < 0) {
+			err("read eeprom failed.");
+			return -1;
+		} else {
+			eepromline[i%16] = ibuf[0];
+			eeprom[i] = ibuf[0];
+		}
+		if ((i % 16) == 15) {
+			deb_xfer("%02x: ", i - 15);
+			debug_dump(eepromline, 16, deb_xfer);
+		}
+	}
+	memcpy(mac, eeprom + 8, 6);
+	return 0;
+};
+
 static int dw2102_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	static u8 command_13v[1] = {0x00};
@@ -161,6 +280,22 @@
 		msg[0].buf = command_18v;
 	i2c_transfer(&udev_adap->dev->i2c_adap, msg, 1);
 	return 0;
+}
+
+static struct cx24116_config dw2104_config = {
+	.demod_address = 0x55,
+	/*.mpg_clk_pos_pol = 0x01,*/
+};
+
+static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
+{
+	if ((d->fe = dvb_attach(cx24116_attach, &dw2104_config,
+			&d->dev->i2c_adap)) != NULL) {
+		d->fe->ops.set_voltage = dw2102_set_voltage;
+		info("Attached cx24116!\n");
+		return 0;
+	}
+	return -EIO;
 }
 
 static int dw2102_frontend_attach(struct dvb_usb_adapter *d)
@@ -249,6 +384,8 @@
 static struct usb_device_id dw2102_table[] = {
 	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
 	{USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
+	{USB_DEVICE(USB_VID_CYPRESS, 0x2104)},
+	{USB_DEVICE(0x9022, 0xd650)},
 	{ }
 };
 
@@ -273,25 +410,23 @@
 			return ret;
 		}
 		break;
-	case USB_PID_DW2102:
+	default:
 		fw = frmwr;
 		break;
 	}
-	info("start downloading DW2102 firmware");
+	info("start downloading DW210X firmware");
 	p = kmalloc(fw->size, GFP_KERNEL);
 	reset = 1;
 	/*stop the CPU*/
-	dw2102_op_rw(dev, 0xa0, 0x7f92, &reset, 1, DW2102_WRITE_MSG);
-	dw2102_op_rw(dev, 0xa0, 0xe600, &reset, 1, DW2102_WRITE_MSG);
+	dw2102_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1, DW2102_WRITE_MSG);
+	dw2102_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1, DW2102_WRITE_MSG);
 
 	if (p != NULL) {
 		memcpy(p, fw->data, fw->size);
 		for (i = 0; i < fw->size; i += 0x40) {
 			b = (u8 *) p + i;
-			if (dw2102_op_rw
-				(dev, 0xa0, i, b , 0x40,
-					DW2102_WRITE_MSG) != 0x40
-				) {
+			if (dw2102_op_rw(dev, 0xa0, i, 0, b , 0x40,
+					DW2102_WRITE_MSG) != 0x40) {
 				err("error while transferring firmware");
 				ret = -EINVAL;
 				break;
@@ -299,43 +434,45 @@
 		}
 		/* restart the CPU */
 		reset = 0;
-		if (ret || dw2102_op_rw
-			(dev, 0xa0, 0x7f92, &reset, 1,
-			DW2102_WRITE_MSG) != 1) {
+		if (ret || dw2102_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1,
+					DW2102_WRITE_MSG) != 1) {
 			err("could not restart the USB controller CPU.");
 			ret = -EINVAL;
 		}
-		if (ret || dw2102_op_rw
-			(dev, 0xa0, 0xe600, &reset, 1,
-			DW2102_WRITE_MSG) != 1) {
+		if (ret || dw2102_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1,
+					DW2102_WRITE_MSG) != 1) {
 			err("could not restart the USB controller CPU.");
 			ret = -EINVAL;
 		}
 		/* init registers */
 		switch (dev->descriptor.idProduct) {
+		case USB_PID_DW2104:
+		case 0xd650:
+			reset = 1;
+			dw2102_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
+					DW2102_WRITE_MSG);
+			reset = 0;
+			dw2102_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
+					DW2102_WRITE_MSG);
+			break;
 		case USB_PID_DW2102:
-			dw2102_op_rw
-				(dev, 0xbf, 0x0040, &reset, 0,
-				DW2102_WRITE_MSG);
-			dw2102_op_rw
-				(dev, 0xb9, 0x0000, &reset16[0], 2,
-				DW2102_READ_MSG);
+			dw2102_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
+					DW2102_WRITE_MSG);
+			dw2102_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
+					DW2102_READ_MSG);
 			break;
 		case 0x2101:
-			dw2102_op_rw
-				(dev, 0xbc, 0x0030, &reset16[0], 2,
-				DW2102_READ_MSG);
-			dw2102_op_rw
-				(dev, 0xba, 0x0000, &reset16[0], 7,
-				DW2102_READ_MSG);
-			dw2102_op_rw
-				(dev, 0xba, 0x0000, &reset16[0], 7,
-				DW2102_READ_MSG);
-			dw2102_op_rw
-				(dev, 0xb9, 0x0000, &reset16[0], 2,
-				DW2102_READ_MSG);
+			dw2102_op_rw(dev, 0xbc, 0x0030, 0, &reset16[0], 2,
+					DW2102_READ_MSG);
+			dw2102_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
+					DW2102_READ_MSG);
+			dw2102_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
+					DW2102_READ_MSG);
+			dw2102_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
+					DW2102_READ_MSG);
 			break;
 		}
+		msleep(100);
 		kfree(p);
 	}
 	return ret;
@@ -358,7 +495,8 @@
 	/* parameter for the MPEG2-data transfer */
 	.num_adapters = 1,
 	.download_firmware = dw2102_load_firmware,
-	.adapter = {
+	.read_mac_address = dw2102_read_mac_address,
+		.adapter = {
 		{
 			.frontend_attach = dw2102_frontend_attach,
 			.streaming_ctrl = NULL,
@@ -388,11 +526,64 @@
 	}
 };
 
+static struct dvb_usb_device_properties dw2104_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.firmware = "dvb-usb-dw2104.fw",
+	.size_of_priv = sizeof(struct dw2102_state),
+	.no_reconnect = 1,
+
+	.i2c_algo = &dw2104_i2c_algo,
+	.rc_key_map = dw2102_rc_keys,
+	.rc_key_map_size = ARRAY_SIZE(dw2102_rc_keys),
+	.rc_interval = 150,
+	.rc_query = dw2102_rc_query,
+
+	.generic_bulk_ctrl_endpoint = 0x81,
+	/* parameter for the MPEG2-data transfer */
+	.num_adapters = 1,
+	.download_firmware = dw2102_load_firmware,
+	.read_mac_address = dw2102_read_mac_address,
+	.adapter = {
+		{
+			.frontend_attach = dw2104_frontend_attach,
+			.streaming_ctrl = NULL,
+			/*.tuner_attach = dw2104_tuner_attach,*/
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
+	.num_device_descs = 2,
+	.devices = {
+		{ "DVBWorld DW2104 USB2.0",
+			{&dw2102_table[2], NULL},
+			{NULL},
+		},
+		{ "TeVii S650 USB2.0",
+			{&dw2102_table[3], NULL},
+			{NULL},
+		},
+	}
+};
+
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf, &dw2102_properties,
-		THIS_MODULE, NULL, adapter_nr);
+	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
+			THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &dw2104_properties,
+			THIS_MODULE, NULL, adapter_nr)) {
+		return 0;
+	}
+	return -ENODEV;
 }
 
 static struct usb_driver dw2102_driver = {
@@ -420,6 +611,6 @@
 module_exit(dw2102_module_exit);
 
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
-MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101 2102 USB2.0 device");
+MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104 USB2.0 device");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
--- a/linux/drivers/media/dvb/dvb-usb/dw2102.h	Mon Sep 08 11:07:06 2008 -0400
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.h	Mon Sep 08 23:16:40 2008 +0300
@@ -4,6 +4,5 @@
 #define DVB_USB_LOG_PREFIX "dw2102"
 #include "dvb-usb.h"
 
-extern int dvb_usb_dw2102_debug;
 #define deb_xfer(args...) dprintk(dvb_usb_dw2102_debug, 0x02, args)
 #endif

--Boundary-00=_8wYxInvRFRA2T9G
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_8wYxInvRFRA2T9G--
