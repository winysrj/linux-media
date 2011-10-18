Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:34781 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1JRUCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 16:02:33 -0400
Date: Tue, 18 Oct 2011 22:02:30 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 10/14] staging/media/as102: properly handle multiple
 product names
Message-ID: <20111018220230.13c8436e@darkstar>
In-Reply-To: <20111018111251.d7978be8.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111251.d7978be8.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267319051 18000
# Node ID 22ef1bdca69a2781abf397c53a0f7f6125f5359a
# Parent  4a82558f6df8b957bc623d854a118a5da32dead2
as102: properly handle multiple product names

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Properly handle the case where the driver can be associated with multiple
different products (as opposed to always saying the device is named after the
value in a #define

Priority: normal

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as102_drv.c linuxb/drivers/staging/media/as102/as102_drv.c
--- linux/drivers/staging/media/as102/as102_drv.c
+++ linuxb/drivers/staging/media/as102/as102_drv.c
@@ -209,7 +209,7 @@
 
 #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 	ret = dvb_register_adapter(&as102_dev->dvb_adap,
-				   DEVICE_FULL_NAME,
+				   as102_dev->name,
 				   THIS_MODULE,
 #if defined(CONFIG_AS102_USB)
 				   &as102_dev->bus_adap.usb_dev->dev
diff --git linux/drivers/staging/media/as102/as102_drv.h linuxb/drivers/staging/media/as102/as102_drv.h
--- linux/drivers/staging/media/as102/as102_drv.h
+++ linuxb/drivers/staging/media/as102/as102_drv.h
@@ -106,6 +106,7 @@
 };
 
 struct as102_dev_t {
+	const char *name;
 	struct as102_bus_adapter_t bus_adap;
 	struct list_head device_entry;
 	struct kref kref;
diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/staging/media/as102/as102_fe.c
--- linux/drivers/staging/media/as102/as102_fe.c
+++ linuxb/drivers/staging/media/as102/as102_fe.c
@@ -346,7 +346,7 @@
 
 static struct dvb_frontend_ops as102_fe_ops = {
 	.info = {
-		.name			= DEVICE_FULL_NAME,
+		.name			= "Unknown AS102 device",
 		.type			= FE_OFDM,
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
@@ -408,6 +408,8 @@
 
 	/* init frontend callback ops */
 	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
+	strncpy(dvb_fe->ops.info.name, as102_dev->name,
+		sizeof(dvb_fe->ops.info.name));
 
 	/* register dbvb frontend */
 	errno = dvb_register_frontend(dvb_adap, dvb_fe);
diff --git linux/drivers/staging/media/as102/as102_usb_drv.c linuxb/drivers/staging/media/as102/as102_usb_drv.c
--- linux/drivers/staging/media/as102/as102_usb_drv.c
+++ linuxb/drivers/staging/media/as102/as102_usb_drv.c
@@ -44,6 +44,15 @@
 	{ } /* Terminating entry */
 };
 
+/* Note that this table must always have the same number of entries as the
+   as102_usb_id_table struct */
+static const char *as102_device_names[] = {
+	AS102_REFERENCE_DESIGN,
+	AS102_PCTV_74E,
+	AS102_ELGATO_EYETV_DTT_NAME,
+	NULL /* Terminating entry */
+};
+
 struct usb_driver as102_usb_driver = {
 	.name       =  DRIVER_FULL_NAME,
 	.probe      =  as102_usb_probe,
@@ -344,6 +353,7 @@
 {
 	int ret;
 	struct as102_dev_t *as102_dev;
+	int i;
 
 	ENTER();
 
@@ -353,6 +363,23 @@
 		return -ENOMEM;
 	}
 
+	/* This should never actually happen */
+	if ((sizeof(as102_usb_id_table) / sizeof(struct usb_device_id)) !=
+	    (sizeof(as102_device_names) / sizeof(const char *))) {
+		printk(KERN_ERR "Device names table invalid size");
+		return -EINVAL;
+	}
+
+	/* Assign the user-friendly device name */
+	for (i = 0; i < (sizeof(as102_usb_id_table) /
+			 sizeof(struct usb_device_id)); i++) {
+		if (id == &as102_usb_id_table[i])
+			as102_dev->name = as102_device_names[i];
+	}
+
+	if (as102_dev->name == NULL)
+		as102_dev->name = "Unknown AS102 device";
+
 	/* set private callback functions */
 	as102_dev->bus_adap.ops = &as102_priv_ops;
 
diff --git linux/drivers/staging/media/as102/as102_usb_drv.h linuxb/drivers/staging/media/as102/as102_usb_drv.h
--- linux/drivers/staging/media/as102/as102_usb_drv.h
+++ linuxb/drivers/staging/media/as102/as102_usb_drv.h
@@ -28,16 +28,17 @@
 /* define these values to match the supported devices */
 
 /* Abilis system: "TITAN" */
+#define AS102_REFERENCE_DESIGN		"Abilis Systems DVB-Titan"
 #define AS102_USB_DEVICE_VENDOR_ID	0x1BA6
 #define AS102_USB_DEVICE_PID_0001	0x0001
 
 /* PCTV Systems: PCTV picoStick (74e) */
-#define DEVICE_FULL_NAME		"PCTV Systems : PCTV picoStick (74e)"
+#define AS102_PCTV_74E			"PCTV Systems picoStick (74e)"
 #define PCTV_74E_USB_VID		0x2013
 #define PCTV_74E_USB_PID		0x0246
 
 /* Elgato: EyeTV DTT Deluxe */
-#define ELGATO_EYETV_DTT_NAME		"Elgato EyeTV DTT Deluxe"
+#define AS102_ELGATO_EYETV_DTT_NAME	"Elgato EyeTV DTT Deluxe"
 #define ELGATO_EYETV_DTT_USB_VID	0x0fd9
 #define ELGATO_EYETV_DTT_USB_PID	0x002c
 
