Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:51949 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZJZMl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 08:41:27 -0400
Received: by pxi9 with SMTP id 9so1126546pxi.4
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 05:41:31 -0700 (PDT)
Message-ID: <4AE598F2.7010405@gmail.com>
Date: Mon, 26 Oct 2009 20:41:22 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: [PATCH] Add Mygica D689 DMB-TH USB support
Content-Type: multipart/mixed;
 boundary="------------080005050605010505020600"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080005050605010505020600
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   This patch add support for cxusb card Mygica D689 DBM-TH USB

Regards,
David

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>




--------------080005050605010505020600
Content-Type: text/x-patch;
 name="mygica_d689.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mygica_d689.patch"

changeset:   13169:ad3ae870a7a0
tag:         tip
user:        David T.L. Wong <davidtlwong@gmail.com>
date:        Mon Oct 26 20:33:49 2009 +0800
summary:     cxusb: add card Mygica D689 DMB-TH

diff --git a/linux/drivers/media/dvb/dvb-usb/cxusb.c b/linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c
@@ -36,9 +36,11 @@
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
 #include "mxl5005s.h"
+#include "max2165.h"
 #include "dib7000p.h"
 #include "dib0070.h"
 #include "lgs8gxx.h"
+#include "atbm8830.h"
 
 /* debug */
 static int dvb_usb_cxusb_debug;
@@ -709,6 +711,11 @@
 	.AgcMasterByte   = 0x00,
 };
 
+static struct max2165_config mygica_d689_max2165_cfg = {
+	.i2c_address = 0x60,
+	.osc_clk = 20
+};
+
 /* Callbacks for DVB USB */
 static int cxusb_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
 {
@@ -808,6 +815,14 @@
 	return (fe == NULL) ? -EIO : 0;
 }
 
+static int cxusb_mygica_d689_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_frontend *fe;
+	fe = dvb_attach(max2165_attach, adap->fe,
+			&adap->dev->i2c_adap, &mygica_d689_max2165_cfg);
+	return (fe == NULL) ? -EIO : 0;
+}
+
 static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	u8 b;
@@ -1155,6 +1170,64 @@
 	return 0;
 }
 
+static struct atbm8830_config mygica_d689_atbm8830_cfg = {
+	.prod = ATBM8830_PROD_8830,
+	.demod_address = 0x40,
+	.serial_ts = 0,
+	.ts_sampling_edge = 1,
+	.ts_clk_gated = 0,
+	.osc_clk_freq = 30400, /* in kHz */
+	.if_freq = 0, /* zero IF */
+	.zif_swap_iq = 1,
+};
+
+static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap->dev;
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
+#if 0
+	/* Drain USB pipes to avoid hang after reboot */
+	for (n = 0;  n < 5;  n++) {
+		cxusb_d680_dmb_drain_message(d);
+		cxusb_d680_dmb_drain_video(d);
+		msleep(200);
+	}
+#endif
+
+	/* Reset the tuner */
+	if (cxusb_d680_dmb_gpio_tuner(d, 0x07, 0) < 0) {
+		err("clear tuner gpio failed");
+		return -EIO;
+	}
+	msleep(100);
+	if (cxusb_d680_dmb_gpio_tuner(d, 0x07, 1) < 0) {
+		err("set tuner gpio failed");
+		return -EIO;
+	}
+	msleep(100);
+
+	/* Attach frontend */
+	adap->fe = dvb_attach(atbm8830_attach, &mygica_d689_atbm8830_cfg,
+		&d->i2c_adap);
+	if (adap->fe == NULL)
+		return -EIO;
+
+	return 0;
+}
+
 /*
  * DViCO has shipped two devices with the same USB ID, but only one of them
  * needs a firmware download.  Check the device class details to see if they
@@ -1235,6 +1308,7 @@
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_properties;
 static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
 static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
+static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
 
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -1263,6 +1337,8 @@
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_d680_dmb_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_mygica_d689_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
 	    0)
 		return 0;
 
@@ -1289,6 +1365,7 @@
 	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },
 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
+	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -1832,6 +1909,55 @@
 	}
 };
 
+static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
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
+			.frontend_attach  = cxusb_mygica_d689_frontend_attach,
+			.tuner_attach     = cxusb_mygica_d689_tuner_attach,
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
+		{
+			"Mygica D689 DMB-TH",
+			{ NULL },
+			{ &cxusb_table[19], NULL },
+		},
+	}
+};
+
 static struct usb_driver cxusb_driver = {
 	.name		= "dvb_usb_cxusb",
 	.probe		= cxusb_probe,
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -279,5 +279,6 @@
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 #define USB_PID_FRIIO_WHITE				0x0001
 #define USB_PID_TVWAY_PLUS				0x0002
+#define USB_PID_MYGICA_D689				0xd811
 
 #endif


--------------080005050605010505020600--
