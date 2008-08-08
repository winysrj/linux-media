Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imsantv77.netvigator.com ([210.87.250.210])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothy.lee@siriushk.com>) id 1KROcW-0003HG-P1
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 11:50:56 +0200
Received: from imsantv13.netvigator.com (imsantv77 [127.0.0.1])
	by imsantv77.netvigator.com (8.14.2/8.14.2) with ESMTP id
	m789ofKU006355
	for <linux-dvb@linuxtv.org>; Fri, 8 Aug 2008 17:50:41 +0800
Received: from mtil1.siriushk.com (n219076193081.netvigator.com
	[219.76.193.81])
	by imsantv13.netvigator.com (8.14.3/8.14.3) with ESMTP id
	m789odnS026259
	for <linux-dvb@linuxtv.org>; Fri, 8 Aug 2008 17:50:40 +0800
Received: from ez1.siriushk.com (unknown [192.168.0.33])
	by mtil1.siriushk.com (Postfix) with ESMTP id B21BB11EADC
	for <linux-dvb@linuxtv.org>; Fri,  8 Aug 2008 17:50:39 +0800 (CST)
Message-ID: <489C16EF.5030004@siriushk.com>
Date: Fri, 08 Aug 2008 17:50:39 +0800
From: Timothy Lee <timothy.lee@siriushk.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------020202010701060101070204"
Subject: [linux-dvb] [PATCH] Support for Magic-Pro DMB-TH usb stick
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

This is a multi-part message in MIME format.
--------------020202010701060101070204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear all,

Attached is a patch against v4l-dvb repository to add support for 
Magic-Pro DMB-TH usb stick.  DMB-TH is the HDTV broadcast standard used 
in Hong Kong and China.

Regards,
Timothy Lee

--------------020202010701060101070204
Content-Type: text/x-patch;
 name="v4l-dvb-prohdtv-20080808.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l-dvb-prohdtv-20080808.patch"

diff -r fcf263987edf linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c	Tue Aug 05 10:14:13 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c	Fri Aug 08 16:17:41 2008 +0800
@@ -36,6 +36,7 @@
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
 #include "mxl5005s.h"
+#include "lgs8gl5.h"
 
 /* debug */
 static int dvb_usb_cxusb_debug;
@@ -107,6 +108,24 @@ static void cxusb_nano2_led(struct dvb_u
 static void cxusb_nano2_led(struct dvb_usb_device *d, int onoff)
 {
 	cxusb_bluebird_gpio_rw(d, 0x40, onoff ? 0 : 0x40);
+}
+
+static int cxusb_d680_dmb_gpio_tuner(struct dvb_usb_device *d,
+				     u8 addr, int onoff)
+{
+	u8  o[2] = {addr, onoff};
+	u8  i;
+	int rc;
+
+	rc = cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
+
+	if (rc < 0)  return rc;
+	if (i == 0x01)  return 0;
+	else
+	{
+		deb_info("gpio_write failed.\n");
+		return -EIO;
+	}
 }
 
 /* I2C */
@@ -262,6 +281,19 @@ static int cxusb_nano2_power_ctrl(struct
 	return rc;
 }
 
+static int cxusb_d680_dmb_power_ctrl(struct dvb_usb_device *d, int onoff)
+{
+	int ret;
+	u8  b;
+	ret = cxusb_power_ctrl(d, onoff);
+	if (!onoff)  return ret;
+
+	msleep(128);
+	cxusb_ctrl_msg(d, CMD_DIGITAL, NULL, 0, &b, 1);
+	msleep(100);
+	return ret;
+}
+
 static int cxusb_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	u8 buf[2] = { 0x03, 0x00 };
@@ -283,6 +315,65 @@ static int cxusb_aver_streaming_ctrl(str
 	return 0;
 }
 
+static void cxusb_d680_dmb_drain_message(struct dvb_usb_device *d)
+{
+	int       ep = d->props.generic_bulk_ctrl_endpoint;
+	const int timeout = 100;
+	const int junk_len = 32;
+	u8*       junk;
+	int       rd_count;
+
+	// Discard remaining data in video pipe
+	junk = kmalloc(junk_len, GFP_KERNEL);
+	if (!junk)  return;
+	while (1)
+	{
+		if (usb_bulk_msg(d->udev,
+			usb_rcvbulkpipe(d->udev, ep),
+			junk, junk_len, &rd_count, timeout) < 0)
+			break;
+		if (!rd_count)  break;
+	}
+	kfree(junk);
+}
+
+static void cxusb_d680_dmb_drain_video(struct dvb_usb_device *d)
+{
+	struct usb_data_stream_properties* p = &d->props.adapter[0].stream;
+	const int timeout = 100;
+	const int junk_len = p->u.bulk.buffersize;
+	u8*       junk;
+	int       rd_count;
+
+	// Discard remaining data in video pipe
+	junk = kmalloc(junk_len, GFP_KERNEL);
+	if (!junk)  return;
+	while (1)
+	{
+		if (usb_bulk_msg(d->udev,
+			usb_rcvbulkpipe(d->udev, p->endpoint),
+			junk, junk_len, &rd_count, timeout) < 0)
+			break;
+		if (!rd_count)  break;
+	}
+	kfree(junk);
+}
+
+static int cxusb_d680_dmb_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	if (onoff) {
+		u8 buf[2] = { 0x03, 0x00 };
+		cxusb_d680_dmb_drain_video(adap->dev);
+		return cxusb_ctrl_msg(adap->dev, CMD_STREAMING_ON,
+			buf, sizeof(buf), NULL, 0);
+	}
+	else {
+		int ret = cxusb_ctrl_msg(adap->dev,
+			CMD_STREAMING_OFF, NULL, 0, NULL, 0);
+		return ret;
+	}
+}
+
 static int cxusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
@@ -325,6 +416,32 @@ static int cxusb_bluebird2_rc_query(stru
 	for (i = 0; i < d->props.rc_key_map_size; i++) {
 		if (keymap[i].custom == ircode[1] &&
 		    keymap[i].data == ircode[2]) {
+			*event = keymap[i].event;
+			*state = REMOTE_KEY_PRESSED;
+
+			return 0;
+		}
+	}
+
+	return 0;
+}
+
+static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
+				   int *state)
+{
+	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	u8 ircode[2];
+	int i;
+
+	*event = 0;
+	*state = REMOTE_NO_KEY_PRESSED;
+
+	if (cxusb_ctrl_msg(d, 0x10, NULL, 0, ircode, 2) < 0)
+		return 0;
+
+	for (i = 0; i < d->props.rc_key_map_size; i++) {
+		if (keymap[i].custom == ircode[0] &&
+		    keymap[i].data == ircode[1]) {
 			*event = keymap[i].event;
 			*state = REMOTE_KEY_PRESSED;
 
@@ -422,6 +539,44 @@ static struct dvb_usb_rc_key dvico_porta
 	{ 0xfc, 0x00, KEY_UNKNOWN },    /* HD */
 };
 
+static struct dvb_usb_rc_key d680_dmb_rc_keys[] = {
+	{ 0x00, 0x38, KEY_UNKNOWN },	/* TV/AV */
+	{ 0x08, 0x0c, KEY_ZOOM },
+	{ 0x08, 0x00, KEY_0 },
+	{ 0x00, 0x01, KEY_1 },
+	{ 0x08, 0x02, KEY_2 },
+	{ 0x00, 0x03, KEY_3 },
+	{ 0x08, 0x04, KEY_4 },
+	{ 0x00, 0x05, KEY_5 },
+	{ 0x08, 0x06, KEY_6 },
+	{ 0x00, 0x07, KEY_7 },
+	{ 0x08, 0x08, KEY_8 },
+	{ 0x00, 0x09, KEY_9 },
+	{ 0x00, 0x0a, KEY_MUTE },
+	{ 0x08, 0x29, KEY_BACK },
+	{ 0x00, 0x12, KEY_CHANNELUP },
+	{ 0x08, 0x13, KEY_CHANNELDOWN },
+	{ 0x00, 0x2b, KEY_VOLUMEUP },
+	{ 0x08, 0x2c, KEY_VOLUMEDOWN },
+	{ 0x00, 0x20, KEY_UP },
+	{ 0x08, 0x21, KEY_DOWN },
+	{ 0x00, 0x11, KEY_LEFT },
+	{ 0x08, 0x10, KEY_RIGHT },
+	{ 0x00, 0x0d, KEY_OK },
+	{ 0x08, 0x1f, KEY_RECORD },
+	{ 0x00, 0x17, KEY_PLAYPAUSE },
+	{ 0x08, 0x16, KEY_PLAYPAUSE },
+	{ 0x00, 0x0b, KEY_STOP },
+	{ 0x08, 0x27, KEY_FASTFORWARD },
+	{ 0x00, 0x26, KEY_REWIND },
+	{ 0x08, 0x1e, KEY_UNKNOWN },    /* Time Shift */
+	{ 0x00, 0x0e, KEY_UNKNOWN },    /* Snapshot */
+	{ 0x08, 0x2d, KEY_UNKNOWN },    /* Mouse Cursor */
+	{ 0x00, 0x0f, KEY_UNKNOWN },    /* Minimize/Maximize */
+	{ 0x08, 0x14, KEY_UNKNOWN },    /* Shuffle */
+	{ 0x00, 0x25, KEY_POWER },
+};
+
 static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
 {
 	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x28 };
@@ -527,6 +682,24 @@ static struct mxl5005s_config aver_a868r
 	.AgcMasterByte   = 0x00,
 };
 
+/* FIXME: needs tweaking */
+static struct mxl5005s_config d680_dmb_tuner = {
+	.i2c_address     = 0x63,
+	.if_freq         = 36125000UL,
+	.xtal_freq       = CRYSTAL_FREQ_16000000HZ,
+	.agc_mode        = MXL_SINGLE_AGC,
+	.tracking_filter = MXL_TF_C,
+	.rssi_enable     = MXL_RSSI_ENABLE,
+	.cap_select      = MXL_CAP_SEL_ENABLE,
+	.div_out         = MXL_DIV_OUT_4,
+	.clock_out       = MXL_CLOCK_OUT_DISABLE,
+	.output_load     = MXL5005S_IF_OUTPUT_LOAD_200_OHM,
+	.top		 = MXL5005S_TOP_25P2,
+	.mod_mode        = MXL_DIGITAL_MODE,
+	.if_mode         = MXL_ZERO_IF,
+	.AgcMasterByte   = 0x00,
+};
+
 /* Callbacks for DVB USB */
 static int cxusb_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
 {
@@ -613,6 +786,14 @@ static int cxusb_mxl5003s_tuner_attach(s
 	dvb_attach(mxl5005s_attach, adap->fe,
 		   &adap->dev->i2c_adap, &aver_a868r_tuner);
 	return 0;
+}
+
+static int cxusb_d680_dmb_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_frontend* fe;
+	fe = dvb_attach(mxl5005s_attach, adap->fe,
+			&adap->dev->i2c_adap, &d680_dmb_tuner);
+	return (fe == NULL) ? -EIO : 0;
 }
 
 static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
@@ -751,6 +932,57 @@ static int cxusb_nano2_frontend_attach(s
 	return -EIO;
 }
 
+static struct lgs8gl5_config lgs8gl5_cfg = {
+	.demod_address = 0x19,
+};
+
+static int cxusb_d680_dmb_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device* d = adap->dev;
+	int n;
+
+	/* Select required USB configuration */
+	if (usb_set_interface(d->udev, 0, 0) < 0)
+		err("set interface failed");
+
+	/* Unblock all USB pipes */
+	usb_clear_halt(d->udev,
+		usb_sndbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
+	usb_clear_halt(d->udev,
+		usb_rcvbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
+	usb_clear_halt(d->udev,
+		usb_rcvbulkpipe(d->udev, d->props.adapter[0].stream.endpoint));
+
+	/* Drain USB pipes to avoid hang after reboot */
+	for (n = 0;  n < 5;  n++)
+	{
+		cxusb_d680_dmb_drain_message(d);
+		cxusb_d680_dmb_drain_video(d);
+		msleep(200);
+	}
+
+	/* Reset the tuner */
+	if (cxusb_d680_dmb_gpio_tuner(d, 0x07, 0) < 0)
+	{
+		err("clear tuner gpio failed");
+		return -EIO;
+	}
+	msleep(100);
+	if (cxusb_d680_dmb_gpio_tuner(d, 0x07, 1) < 0)
+	{
+		err("set tuner gpio failed");
+		return -EIO;
+	}
+	msleep(100);
+
+	/* Attach frontend */
+	if ((adap->fe = dvb_attach(lgs8gl5_attach, &lgs8gl5_cfg,
+				   &d->i2c_adap)) != NULL)
+		return 0;
+
+	return -EIO;
+}
+
 /*
  * DViCO has shipped two devices with the same USB ID, but only one of them
  * needs a firmware download.  Check the device class details to see if they
@@ -829,6 +1061,7 @@ static struct dvb_usb_device_properties 
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_properties;
 static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
+static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
 
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -852,6 +1085,8 @@ static int cxusb_probe(struct usb_interf
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_aver_a868r_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_d680_dmb_properties,
+	    			     THIS_MODULE, NULL, adapter_nr) ||
 	    0)
 		return 0;
 
@@ -876,6 +1111,7 @@ static struct usb_device_id cxusb_table 
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },
 	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R) },
+	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -1321,6 +1557,54 @@ static struct dvb_usb_device_properties 
 	}
 };
 
+static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl         = CYPRESS_FX2,
+
+	.size_of_priv     = sizeof(struct cxusb_state),
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.streaming_ctrl   = cxusb_d680_dmb_streaming_ctrl,
+			.frontend_attach  = cxusb_d680_dmb_frontend_attach,
+			.tuner_attach     = cxusb_d680_dmb_tuner_attach,
+
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 5,
+				.endpoint = 0x02,
+				.u = {
+					.bulk = {
+						.buffersize = 8192,
+					}
+				}
+			},
+		},
+	},
+
+	.power_ctrl       = cxusb_d680_dmb_power_ctrl,
+
+	.i2c_algo         = &cxusb_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.rc_interval      = 100,
+	.rc_key_map       = d680_dmb_rc_keys,
+	.rc_key_map_size  = ARRAY_SIZE(d680_dmb_rc_keys),
+	.rc_query         = cxusb_d680_dmb_rc_query,
+
+	.num_device_descs = 1,
+	.devices = {
+		{   "Conexant DMB-TH Stick",
+			{ NULL },
+			{ &cxusb_table[17], NULL },
+		},
+	}
+};
+
 static struct usb_driver cxusb_driver = {
 	.name		= "dvb_usb_cxusb",
 	.probe		= cxusb_probe,
diff -r fcf263987edf linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Aug 05 10:14:13 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri Aug 08 16:17:41 2008 +0800
@@ -22,6 +22,7 @@
 #define USB_VID_AVERMEDIA			0x07ca
 #define USB_VID_COMPRO				0x185b
 #define USB_VID_COMPRO_UNK			0x145f
+#define USB_VID_CONEXANT			0x0572
 #define USB_VID_CYPRESS				0x04b4
 #define USB_VID_DIBCOM				0x10b8
 #define USB_VID_DPOSH				0x1498
@@ -69,6 +70,7 @@
 #define USB_PID_COMPRO_DVBU2000_UNK_WARM		0x010d
 #define USB_PID_COMPRO_VIDEOMATE_U500			0x1e78
 #define USB_PID_COMPRO_VIDEOMATE_U500_PC		0x1e80
+#define USB_PID_CONEXANT_D680_DMB			0x86d6
 #define USB_PID_DIBCOM_HOOK_DEFAULT			0x0064
 #define USB_PID_DIBCOM_HOOK_DEFAULT_REENUM		0x0065
 #define USB_PID_DIBCOM_MOD3000_COLD			0x0bb8
diff -r fcf263987edf linux/drivers/media/dvb/frontends/Kconfig
--- a/linux/drivers/media/dvb/frontends/Kconfig	Tue Aug 05 10:14:13 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/Kconfig	Fri Aug 08 16:17:41 2008 +0800
@@ -385,4 +385,11 @@ config DVB_ISL6421
 	help
 	  An SEC control chip.
 
+config DVB_LGS8GL5
+	tristate "Silicon Legend LGS-8GL5 demodulator (OFDM)"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DMB-TH tuner module. Say Y when you want to support this frontend.
+
 endmenu
diff -r fcf263987edf linux/drivers/media/dvb/frontends/Makefile
--- a/linux/drivers/media/dvb/frontends/Makefile	Tue Aug 05 10:14:13 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/Makefile	Fri Aug 08 16:17:41 2008 +0800
@@ -48,3 +48,4 @@ obj-$(CONFIG_DVB_AU8522) += au8522.o
 obj-$(CONFIG_DVB_AU8522) += au8522.o
 obj-$(CONFIG_DVB_TDA10048) += tda10048.o
 obj-$(CONFIG_DVB_S5H1411) += s5h1411.o
+obj-$(CONFIG_DVB_LGS8GL5) += lgs8gl5.o
diff -r fcf263987edf linux/drivers/media/dvb/frontends/lgs8gl5.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/lgs8gl5.c	Fri Aug 08 16:17:41 2008 +0800
@@ -0,0 +1,472 @@
+/*
+    Legend Silicon LGS-8GL5 DMB-TH OFDM demodulator driver
+
+    Copyright (C) 2008 Sirius International (Hong Kong) Limited
+	Timothy Lee <timothy.lee@siriushk.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include "dvb_frontend.h"
+#include "lgs8gl5.h"
+
+
+#define REG_RESET		0x02
+#define REG_RESET_OFF			0x01
+#define REG_03			0x03
+#define REG_04			0x04
+#define REG_07			0x07
+#define REG_09			0x09
+#define REG_0A			0x0a
+#define REG_0B			0x0b
+#define REG_0C			0x0c
+#define REG_37			0x37
+#define REG_STRENGTH		0x4b
+#define REG_STRENGTH_MASK		0x7f
+#define REG_STRENGTH_CARRIER		0x80
+#define REG_INVERSION		0x7c
+#define REG_INVERSION_ON		0x80
+#define REG_7D			0x7d
+#define REG_7E			0x7e
+#define REG_A2			0xa2
+#define REG_STATUS		0xa4
+#define REG_STATUS_SYNC		0x04
+#define REG_STATUS_LOCK		0x01
+
+
+struct lgs8gl5_state
+{
+	struct i2c_adapter* i2c;
+	const struct lgs8gl5_config* config;
+	struct dvb_frontend frontend;
+};
+
+
+static int debug;
+#define dprintk(args...) \
+	do { \
+		if (debug)  printk(KERN_DEBUG "lgs8gl5: " args); \
+	} while (0)
+
+
+/* Writes into demod's register */
+static int
+lgs8gl5_write_reg(struct lgs8gl5_state* state, u8 reg, u8 data)
+{
+	int ret;
+	u8 buf[] = {reg, data};
+	struct i2c_msg msg =
+	{
+		.addr  = state->config->demod_address,
+		.flags = 0,
+		.buf   = buf,
+		.len   = 2
+	};
+
+	ret = i2c_transfer(state->i2c, &msg, 1);
+	if (ret != 1)
+		dprintk("%s: write_reg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
+			__FUNCTION__, reg, data, ret);
+	return (ret != 1) ? -1 : 0;
+}
+
+
+/* Reads from demod's register */
+static int
+lgs8gl5_read_reg(struct lgs8gl5_state* state, u8 reg)
+{
+	int ret, j;
+	u8 b0[] = {reg};
+	u8 b1[] = {0};
+	struct i2c_msg msg[2] =
+	{
+		{
+			.addr  = state->config->demod_address,
+			.flags = 0,
+			.buf   = b0,
+			.len   = 1
+		},
+		{
+			.addr  = state->config->demod_address,
+			.flags = I2C_M_RD,
+			.buf   = b1,
+			.len   = 1
+		}
+	};
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+        if (ret != 2) return -EIO;
+
+	return b1[0];
+}
+
+
+static int
+lgs8gl5_update_reg(struct lgs8gl5_state* state, u8 reg, u8 data)
+{
+	lgs8gl5_read_reg(state, reg);
+	lgs8gl5_write_reg(state, reg, data);
+	return 0;
+}
+
+
+/* Writes into alternate device's register */
+/* TODO:  Find out what that device is for! */
+static int
+lgs8gl5_update_alt_reg(struct lgs8gl5_state* state, u8 reg, u8 data)
+{
+	int ret, j;
+	u8 b0[] = {reg};
+	u8 b1[] = {0};
+	u8 b2[] = {reg, data};
+	struct i2c_msg msg[3] =
+	{
+		{
+			.addr  = state->config->demod_address + 2,
+			.flags = 0,
+			.buf   = b0,
+			.len   = 1
+		},
+		{
+			.addr  = state->config->demod_address + 2,
+			.flags = I2C_M_RD,
+			.buf   = b1,
+			.len   = 1
+		},
+		{
+			.addr  = state->config->demod_address + 2,
+			.flags = 0,
+			.buf   = b2,
+			.len   = 2
+		},
+	};
+
+	ret = i2c_transfer(state->i2c, msg, 3);
+	return (ret != 3) ? -1 : 0;
+}
+
+
+static void
+lgs8gl5_soft_reset(struct lgs8gl5_state* state)
+{
+	u8 val;
+
+	dprintk ("%s\n", __FUNCTION__);
+
+	val =lgs8gl5_read_reg(state, REG_RESET);
+	lgs8gl5_write_reg(state, REG_RESET, val & ~REG_RESET_OFF);
+	lgs8gl5_write_reg(state, REG_RESET, val | REG_RESET_OFF);
+	msleep(5);
+}
+
+
+static int
+lgs8gl5_set_inversion(struct lgs8gl5_state* state, int inversion)
+{
+	u8 val;
+
+	dprintk ("%s\n", __FUNCTION__);
+
+	switch (inversion) {
+		case INVERSION_AUTO:
+			return -EOPNOTSUPP;
+		case INVERSION_ON:
+			val = lgs8gl5_read_reg(state, REG_INVERSION);
+			return lgs8gl5_write_reg(state, REG_INVERSION,
+				val | REG_INVERSION_ON);
+		case INVERSION_OFF:
+			val = lgs8gl5_read_reg(state, REG_INVERSION);
+			return lgs8gl5_write_reg(state, REG_INVERSION,
+				val & ~REG_INVERSION_ON);
+		default:
+			return -EINVAL;
+	}
+}
+
+
+/* Starts demodulation */
+static void
+lgs8gl5_start_demod(struct lgs8gl5_state* state)
+{
+	u8  val;
+	int n;
+
+	//dprintk ("%s\n", __FUNCTION__);
+
+	lgs8gl5_update_alt_reg(state, 0xc2, 0x28);
+        lgs8gl5_soft_reset(state);
+        lgs8gl5_update_reg(state, REG_07, 0x10);
+        lgs8gl5_update_reg(state, REG_07, 0x10);
+        lgs8gl5_write_reg(state, REG_09, 0x0e);
+        lgs8gl5_write_reg(state, REG_0A, 0xe5);
+        lgs8gl5_write_reg(state, REG_0B, 0x35);
+        lgs8gl5_write_reg(state, REG_0C, 0x30);
+
+	lgs8gl5_update_reg(state, REG_03, 0x00);
+	lgs8gl5_update_reg(state, REG_7E, 0x01);
+	lgs8gl5_update_alt_reg(state, 0xc5, 0x00);
+	lgs8gl5_update_reg(state, REG_04, 0x02);
+	lgs8gl5_update_reg(state, REG_37, 0x01);
+	lgs8gl5_soft_reset(state);
+
+	/* Wait for carrier */
+	for (n = 0;  n < 10;  n++)
+	{
+		val = lgs8gl5_read_reg(state, REG_STRENGTH);
+		dprintk("Wait for carrier[%d] 0x%02X\n", n, val);
+		if (val & REG_STRENGTH_CARRIER)  break;
+		msleep(4);
+	}
+	if (!(val & REG_STRENGTH_CARRIER))  return;
+
+	/* Wait for lock */
+	for (n = 0;  n < 20;  n++)
+	{
+		val = lgs8gl5_read_reg(state, REG_STATUS);
+		dprintk("Wait for lock[%d] 0x%02X\n", n, val);
+		if (val & REG_STATUS_LOCK)  break;
+		msleep(12);
+	}
+	if (!(val & REG_STATUS_LOCK))  return;
+
+	lgs8gl5_write_reg(state, REG_7D, lgs8gl5_read_reg(state, REG_A2));
+	lgs8gl5_soft_reset(state);
+}
+
+
+static int
+lgs8gl5_init(struct dvb_frontend* fe)
+{	struct lgs8gl5_state* state = fe->demodulator_priv;
+
+	//dprintk ("%s\n", __FUNCTION__);
+
+	lgs8gl5_update_alt_reg(state, 0xc2, 0x28);
+	lgs8gl5_soft_reset(state);
+	lgs8gl5_update_reg(state, REG_07, 0x10);
+	lgs8gl5_update_reg(state, REG_07, 0x10);
+	lgs8gl5_write_reg(state, REG_09, 0x0e);
+	lgs8gl5_write_reg(state, REG_0A, 0xe5);
+	lgs8gl5_write_reg(state, REG_0B, 0x35);
+	lgs8gl5_write_reg(state, REG_0C, 0x30);
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_read_status(struct dvb_frontend* fe, fe_status_t* status)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	u8 level = lgs8gl5_read_reg(state, REG_STRENGTH);
+	u8 flags = lgs8gl5_read_reg(state, REG_STATUS);
+
+	*status = 0;
+
+	if ((level & REG_STRENGTH_MASK) > 0)  *status |= FE_HAS_SIGNAL;
+	if (level & REG_STRENGTH_CARRIER)  *status |= FE_HAS_CARRIER;
+	if (flags & REG_STATUS_SYNC)  *status |= FE_HAS_SYNC;
+	if (flags & REG_STATUS_LOCK)  *status |= FE_HAS_LOCK;
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_read_ber(struct dvb_frontend* fe, u32* ber)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	*ber = 0;
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_read_signal_strength(struct dvb_frontend* fe, u16* signal_strength)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	u8 level = lgs8gl5_read_reg(state, REG_STRENGTH);
+	*signal_strength = (level & REG_STRENGTH_MASK) << 8;
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_read_snr(struct dvb_frontend* fe, u16* snr)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	u8 level = lgs8gl5_read_reg(state, REG_STRENGTH);
+	*snr = (level & REG_STRENGTH_MASK) << 8;
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	*ucblocks = 0;
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+
+	dprintk ("%s\n", __FUNCTION__);
+
+	if (p->u.ofdm.bandwidth != BANDWIDTH_8_MHZ)  return -EINVAL;
+
+	if (fe->ops.tuner_ops.set_params)
+	{
+		fe->ops.tuner_ops.set_params(fe, p);
+		if (fe->ops.i2c_gate_ctrl)  fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	/* lgs8gl5_set_inversion(state, p->inversion); */
+
+	lgs8gl5_start_demod(state);
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	u8 inv = lgs8gl5_read_reg(state, REG_INVERSION);
+	struct dvb_ofdm_parameters *o = &p->u.ofdm;	
+
+	p->inversion = (inv & REG_INVERSION_ON) ? INVERSION_ON : INVERSION_OFF;
+
+	o->code_rate_HP = FEC_1_2;
+	o->code_rate_LP = FEC_7_8;
+	o->guard_interval = GUARD_INTERVAL_1_32;
+	o->transmission_mode = TRANSMISSION_MODE_2K;
+	o->constellation = QAM_64;
+	o->hierarchy_information = HIERARCHY_NONE;
+	o->bandwidth = BANDWIDTH_8_MHZ;
+
+	return 0;
+}
+
+
+static int
+lgs8gl5_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* fesettings)
+{
+	fesettings->min_delay_ms = 240;
+	fesettings->step_size    = 0;
+	fesettings->max_drift    = 0;
+	return 0;
+}
+
+
+static void
+lgs8gl5_release(struct dvb_frontend* fe)
+{
+	struct lgs8gl5_state* state = fe->demodulator_priv;
+	kfree(state);
+}
+
+
+static struct dvb_frontend_ops lgs8gl5_ops;
+
+
+struct dvb_frontend*
+lgs8gl5_attach(const struct lgs8gl5_config* config, struct i2c_adapter* i2c)
+{
+	struct lgs8gl5_state* state = NULL;
+
+	dprintk ("%s\n", __FUNCTION__);
+
+	/* Allocate memory for the internal state */
+	state = kmalloc(sizeof(struct lgs8gl5_state), GFP_KERNEL);
+	if (state == NULL)  goto error;
+
+	/* Setup the state */
+	state->config = config;
+	state->i2c    = i2c;
+
+	/* Check if the demod is there */
+	if (lgs8gl5_read_reg(state, REG_RESET) < 0)  goto error;
+
+	/* Create dvb_frontend */
+	memcpy(&state->frontend.ops, &lgs8gl5_ops,
+		sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+	return &state->frontend;
+
+error:
+	kfree(state);
+	return NULL;
+}
+
+
+static struct dvb_frontend_ops lgs8gl5_ops =
+{
+	.info =
+	{
+		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
+		.type			= FE_OFDM,
+		.frequency_min		= 474000000,
+		.frequency_max		= 858000000,
+		.frequency_stepsize	= 10000,
+		.frequency_tolerance	= 0,
+		.caps = FE_CAN_FEC_AUTO |
+		        FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_32 |
+			FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_BANDWIDTH_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO |
+			FE_CAN_HIERARCHY_AUTO |
+		        FE_CAN_RECOVER
+	},
+
+	.release = lgs8gl5_release,
+
+	.init = lgs8gl5_init,
+
+	.set_frontend = lgs8gl5_set_frontend,
+	.get_frontend = lgs8gl5_get_frontend,
+	.get_tune_settings = lgs8gl5_get_tune_settings,
+
+	.read_status = lgs8gl5_read_status,
+	.read_ber = lgs8gl5_read_ber,
+	.read_signal_strength = lgs8gl5_read_signal_strength,
+	.read_snr = lgs8gl5_read_snr,
+	.read_ucblocks = lgs8gl5_read_ucblocks,
+};
+
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+
+MODULE_DESCRIPTION("Legend Silicon LGS-8GL5 DMB-TH Demodulator driver");
+MODULE_AUTHOR("Timothy Lee");
+MODULE_LICENSE("GPL");
+
+EXPORT_SYMBOL(lgs8gl5_attach);
diff -r fcf263987edf linux/drivers/media/dvb/frontends/lgs8gl5.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/lgs8gl5.h	Fri Aug 08 16:17:41 2008 +0800
@@ -0,0 +1,46 @@
+/*
+    Legend Silicon LGS-8GL5 DMB-TH OFDM demodulator driver
+
+    Copyright (C) 2008 Sirius International (Hong Kong) Limited
+	Timothy Lee <timothy.lee@siriushk.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#ifndef LGS8GL5_H
+#define LGS8GL5_H
+
+#include <linux/dvb/frontend.h>
+
+struct lgs8gl5_config
+{
+	/* the demodulator's i2c address */
+	u8 demod_address;
+};
+
+#if defined(CONFIG_DVB_LGS8GL5) || (defined(CONFIG_DVB_LGS8GL5_MODULE) && defined(MODULE))
+extern struct dvb_frontend* lgs8gl5_attach(const struct lgs8gl5_config* config,
+					   struct i2c_adapter* i2c);
+#else
+static inline struct dvb_frontend* lgs8gl5_attach(const struct lgs8gl5_config* config,
+					   struct i2c_adapter* i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	return NULL;
+}
+#endif // CONFIG_DVB_LGS8GL5
+
+#endif // LGS8GL5_H

--------------020202010701060101070204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020202010701060101070204--
