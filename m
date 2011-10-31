Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1JaQZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:50 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444413eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:49 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 10/17] staging: as102: Properly handle multiple product names
Date: Mon, 31 Oct 2011 17:24:48 +0100
Message-Id: <1320078295-3379-11-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Properly handle the case where the driver can be associated with
multiple different products (as opposed to always saying the device
is named after the value in a #define).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c     |    2 +-
 drivers/staging/media/as102/as102_drv.h     |    1 +
 drivers/staging/media/as102/as102_fe.c      |    4 +++-
 drivers/staging/media/as102/as102_usb_drv.c |   27 +++++++++++++++++++++++++++
 drivers/staging/media/as102/as102_usb_drv.h |    5 +++--
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 9e5d81b..e1e32be 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -209,7 +209,7 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 
 #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 	ret = dvb_register_adapter(&as102_dev->dvb_adap,
-				   DEVICE_FULL_NAME,
+				   as102_dev->name,
 				   THIS_MODULE,
 #if defined(CONFIG_AS102_USB)
 				   &as102_dev->bus_adap.usb_dev->dev
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index f50bb9f..cd11b16 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -106,6 +106,7 @@ struct as102_bus_adapter_t {
 };
 
 struct as102_dev_t {
+	const char *name;
 	struct as102_bus_adapter_t bus_adap;
 	struct list_head device_entry;
 	struct kref kref;
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index e9f7188..0495486 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -346,7 +346,7 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 
 static struct dvb_frontend_ops as102_fe_ops = {
 	.info = {
-		.name			= DEVICE_FULL_NAME,
+		.name			= "Unknown AS102 device",
 		.type			= FE_OFDM,
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
@@ -408,6 +408,8 @@ int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
 
 	/* init frontend callback ops */
 	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
+	strncpy(dvb_fe->ops.info.name, as102_dev->name,
+		sizeof(dvb_fe->ops.info.name));
 
 	/* register dbvb frontend */
 	errno = dvb_register_frontend(dvb_adap, dvb_fe);
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index d749e06..3a3dd77 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -44,6 +44,15 @@ static struct usb_device_id as102_usb_id_table[] = {
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
@@ -344,6 +353,7 @@ static int as102_usb_probe(struct usb_interface *intf,
 {
 	int ret;
 	struct as102_dev_t *as102_dev;
+	int i;
 
 	ENTER();
 
@@ -353,6 +363,23 @@ static int as102_usb_probe(struct usb_interface *intf,
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
 
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index a81a895..a741462 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
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
 
-- 
1.7.4.1

