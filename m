Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4607 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3CKLrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 39/42] go7007-loader: renamed from s2250-loader
Date: Mon, 11 Mar 2013 12:46:17 +0100
Message-Id: <773770f57d517b2704af95d136ac9a83b1ae16fc.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All s2250 names are renamed to go7007. This will be the generic go7007
firmware loader for any go7007 device, not just for the s2250/1.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/Kconfig         |   24 ++--
 drivers/staging/media/go7007/Makefile        |    7 +-
 drivers/staging/media/go7007/go7007-loader.c |  169 +++++++++++++++++++++++++
 drivers/staging/media/go7007/s2250-loader.c  |  170 --------------------------
 drivers/staging/media/go7007/s2250-loader.h  |   24 ----
 5 files changed, 189 insertions(+), 205 deletions(-)
 create mode 100644 drivers/staging/media/go7007/go7007-loader.c
 delete mode 100644 drivers/staging/media/go7007/s2250-loader.c
 delete mode 100644 drivers/staging/media/go7007/s2250-loader.h

diff --git a/drivers/staging/media/go7007/Kconfig b/drivers/staging/media/go7007/Kconfig
index 46cb7bf..957277c 100644
--- a/drivers/staging/media/go7007/Kconfig
+++ b/drivers/staging/media/go7007/Kconfig
@@ -1,13 +1,10 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
-	depends on VIDEO_DEV && PCI && I2C
+	depends on VIDEO_DEV && I2C
 	depends on SND
 	select VIDEOBUF2_VMALLOC
-	depends on RC_CORE
 	select VIDEO_TUNER
-	select VIDEO_TVEEPROM
 	select SND_PCM
-	select CRC32
 	select VIDEO_SONY_BTF_MPX if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TW2804 if MEDIA_SUBDRV_AUTOSELECT
@@ -20,7 +17,7 @@ config VIDEO_GO7007
 	  encoder chip.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called go7007
+	  module will be called go7007.
 
 config VIDEO_GO7007_USB
 	tristate "WIS GO7007 USB support"
@@ -31,14 +28,25 @@ config VIDEO_GO7007_USB
 	  encoder chip over USB.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called go7007-usb
+	  module will be called go7007-usb.
+
+config VIDEO_GO7007_LOADER
+	tristate "WIS GO7007 Loader support"
+	depends on VIDEO_GO7007 && DVB_USB
+	default y
+	---help---
+	  This is a go7007 firmware loader driver for the WIS GO7007
+	  MPEG encoder chip over USB.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called go7007-loader.
 
 config VIDEO_GO7007_USB_S2250_BOARD
 	tristate "Sensoray 2250/2251 support"
-	depends on VIDEO_GO7007_USB && DVB_USB
+	depends on VIDEO_GO7007_USB && USB
 	default N
 	---help---
 	  This is a video4linux driver for the Sensoray 2250/2251 device.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called s2250
+	  module will be called s2250.
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index 7885c21..e94ab0d 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_VIDEO_GO7007) += go7007.o
 obj-$(CONFIG_VIDEO_GO7007_USB) += go7007-usb.o
-obj-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) += s2250.o s2250-loader.o
+obj-$(CONFIG_VIDEO_GO7007_LOADER) += go7007-loader.o
+obj-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) += s2250.o
 
 go7007-y := go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
 		snd-go7007.o
@@ -11,8 +12,8 @@ s2250-y := s2250-board.o
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
 ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/pci/saa7134
 
-# S2250 needs cypress ezusb loader from dvb-usb-v2
-ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb-v2
+# go7007-loader needs cypress ezusb loader from dvb-usb-v2
+ccflags-$(CONFIG_VIDEO_GO7007_LOADER:m=y) += -Idrivers/media/usb/dvb-usb-v2
 
 ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/staging/media/go7007/go7007-loader.c
new file mode 100644
index 0000000..730a4f8
--- /dev/null
+++ b/drivers/staging/media/go7007/go7007-loader.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (C) 2008 Sensoray Company Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/firmware.h>
+#include <cypress_firmware.h>
+
+#define S2250_LOADER_FIRMWARE	"s2250_loader.fw"
+#define S2250_FIRMWARE		"2250.fw"
+
+typedef struct device_extension_s {
+    struct kref     kref;
+    int minor;
+    struct usb_device *usbdev;
+} device_extension_t, *pdevice_extension_t;
+
+#define USB_go7007_loader_MAJOR 240
+#define USB_go7007_loader_MINOR_BASE 0
+#define MAX_DEVICES 256
+
+static pdevice_extension_t go7007_dev_table[MAX_DEVICES];
+static DEFINE_MUTEX(go7007_dev_table_mutex);
+
+#define to_go7007_loader_dev_common(d) container_of(d, device_extension_t, kref)
+static void go7007_loader_delete(struct kref *kref)
+{
+	pdevice_extension_t s = to_go7007_loader_dev_common(kref);
+	go7007_dev_table[s->minor] = NULL;
+	kfree(s);
+}
+
+static int go7007_loader_probe(struct usb_interface *interface,
+				const struct usb_device_id *id)
+{
+	struct usb_device *usbdev;
+	int minor, ret;
+	pdevice_extension_t s = NULL;
+	const struct firmware *fw;
+
+	usbdev = usb_get_dev(interface_to_usbdev(interface));
+	if (!usbdev) {
+		dev_err(&interface->dev, "Enter go7007_loader_probe failed\n");
+		return -1;
+	}
+	dev_info(&interface->dev, "vendor id 0x%x, device id 0x%x devnum:%d\n",
+		 usbdev->descriptor.idVendor, usbdev->descriptor.idProduct,
+		 usbdev->devnum);
+
+	if (usbdev->descriptor.bNumConfigurations != 1) {
+		dev_err(&interface->dev, "can't handle multiple config\n");
+		return -1;
+	}
+	mutex_lock(&go7007_dev_table_mutex);
+
+	for (minor = 0; minor < MAX_DEVICES; minor++) {
+		if (go7007_dev_table[minor] == NULL)
+			break;
+	}
+
+	if (minor < 0 || minor >= MAX_DEVICES) {
+		dev_err(&interface->dev, "Invalid minor: %d\n", minor);
+		goto failed;
+	}
+
+	/* Allocate dev data structure */
+	s = kmalloc(sizeof(device_extension_t), GFP_KERNEL);
+	if (s == NULL)
+		goto failed;
+
+	go7007_dev_table[minor] = s;
+
+	dev_info(&interface->dev,
+		 "Device %d on Bus %d Minor %d\n",
+		 usbdev->devnum, usbdev->bus->busnum, minor);
+
+	memset(s, 0, sizeof(device_extension_t));
+	s->usbdev = usbdev;
+	dev_info(&interface->dev, "loading go7007-loader\n");
+
+	kref_init(&(s->kref));
+
+	mutex_unlock(&go7007_dev_table_mutex);
+
+	if (request_firmware(&fw, S2250_LOADER_FIRMWARE, &usbdev->dev)) {
+		dev_err(&interface->dev,
+			"unable to load firmware from file \"%s\"\n",
+			S2250_LOADER_FIRMWARE);
+		goto failed2;
+	}
+	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
+	release_firmware(fw);
+	if (0 != ret) {
+		dev_err(&interface->dev, "loader download failed\n");
+		goto failed2;
+	}
+
+	if (request_firmware(&fw, S2250_FIRMWARE, &usbdev->dev)) {
+		dev_err(&interface->dev,
+			"unable to load firmware from file \"%s\"\n",
+			S2250_FIRMWARE);
+		goto failed2;
+	}
+	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
+	release_firmware(fw);
+	if (0 != ret) {
+		dev_err(&interface->dev, "firmware download failed\n");
+		goto failed2;
+	}
+
+	usb_set_intfdata(interface, s);
+	return 0;
+
+failed:
+	mutex_unlock(&go7007_dev_table_mutex);
+failed2:
+	if (s)
+		kref_put(&(s->kref), go7007_loader_delete);
+
+	dev_err(&interface->dev, "probe failed\n");
+	return -1;
+}
+
+static void go7007_loader_disconnect(struct usb_interface *interface)
+{
+	pdevice_extension_t s;
+	dev_info(&interface->dev, "disconnect\n");
+	s = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
+	kref_put(&(s->kref), go7007_loader_delete);
+}
+
+static const struct usb_device_id go7007_loader_ids[] = {
+	{USB_DEVICE(0x1943, 0xa250)},
+	{}                          /* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, go7007_loader_ids);
+
+static struct usb_driver go7007_loader_driver = {
+	.name		= "go7007-loader",
+	.probe		= go7007_loader_probe,
+	.disconnect	= go7007_loader_disconnect,
+	.id_table	= go7007_loader_ids,
+};
+
+module_usb_driver(go7007_loader_driver);
+
+MODULE_AUTHOR("");
+MODULE_DESCRIPTION("firmware loader for go7007 USB devices");
+MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE(S2250_LOADER_FIRMWARE);
+MODULE_FIRMWARE(S2250_FIRMWARE);
diff --git a/drivers/staging/media/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
deleted file mode 100644
index 6453ec0..0000000
--- a/drivers/staging/media/go7007/s2250-loader.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * Copyright (C) 2008 Sensoray Company Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License (Version 2) as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/usb.h>
-#include <linux/firmware.h>
-#include <cypress_firmware.h>
-
-#define S2250_LOADER_FIRMWARE	"s2250_loader.fw"
-#define S2250_FIRMWARE		"s2250.fw"
-
-typedef struct device_extension_s {
-    struct kref     kref;
-    int minor;
-    struct usb_device *usbdev;
-} device_extension_t, *pdevice_extension_t;
-
-#define USB_s2250loader_MAJOR 240
-#define USB_s2250loader_MINOR_BASE 0
-#define MAX_DEVICES 256
-
-static pdevice_extension_t s2250_dev_table[MAX_DEVICES];
-static DEFINE_MUTEX(s2250_dev_table_mutex);
-
-#define to_s2250loader_dev_common(d) container_of(d, device_extension_t, kref)
-static void s2250loader_delete(struct kref *kref)
-{
-	pdevice_extension_t s = to_s2250loader_dev_common(kref);
-	s2250_dev_table[s->minor] = NULL;
-	kfree(s);
-}
-
-static int s2250loader_probe(struct usb_interface *interface,
-				const struct usb_device_id *id)
-{
-	struct usb_device *usbdev;
-	int minor, ret;
-	pdevice_extension_t s = NULL;
-	const struct firmware *fw;
-
-	usbdev = usb_get_dev(interface_to_usbdev(interface));
-	if (!usbdev) {
-		dev_err(&interface->dev, "Enter s2250loader_probe failed\n");
-		return -1;
-	}
-	dev_info(&interface->dev, "Enter s2250loader_probe 2.6 kernel\n");
-	dev_info(&interface->dev, "vendor id 0x%x, device id 0x%x devnum:%d\n",
-		 usbdev->descriptor.idVendor, usbdev->descriptor.idProduct,
-		 usbdev->devnum);
-
-	if (usbdev->descriptor.bNumConfigurations != 1) {
-		dev_err(&interface->dev, "can't handle multiple config\n");
-		return -1;
-	}
-	mutex_lock(&s2250_dev_table_mutex);
-
-	for (minor = 0; minor < MAX_DEVICES; minor++) {
-		if (s2250_dev_table[minor] == NULL)
-			break;
-	}
-
-	if (minor < 0 || minor >= MAX_DEVICES) {
-		dev_err(&interface->dev, "Invalid minor: %d\n", minor);
-		goto failed;
-	}
-
-	/* Allocate dev data structure */
-	s = kmalloc(sizeof(device_extension_t), GFP_KERNEL);
-	if (s == NULL)
-		goto failed;
-
-	s2250_dev_table[minor] = s;
-
-	dev_info(&interface->dev,
-		 "s2250loader_probe: Device %d on Bus %d Minor %d\n",
-		 usbdev->devnum, usbdev->bus->busnum, minor);
-
-	memset(s, 0, sizeof(device_extension_t));
-	s->usbdev = usbdev;
-	dev_info(&interface->dev, "loading 2250 loader\n");
-
-	kref_init(&(s->kref));
-
-	mutex_unlock(&s2250_dev_table_mutex);
-
-	if (request_firmware(&fw, S2250_LOADER_FIRMWARE, &usbdev->dev)) {
-		dev_err(&interface->dev,
-			"s2250: unable to load firmware from file \"%s\"\n",
-			S2250_LOADER_FIRMWARE);
-		goto failed2;
-	}
-	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
-	release_firmware(fw);
-	if (0 != ret) {
-		dev_err(&interface->dev, "loader download failed\n");
-		goto failed2;
-	}
-
-	if (request_firmware(&fw, S2250_FIRMWARE, &usbdev->dev)) {
-		dev_err(&interface->dev,
-			"s2250: unable to load firmware from file \"%s\"\n",
-			S2250_FIRMWARE);
-		goto failed2;
-	}
-	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
-	release_firmware(fw);
-	if (0 != ret) {
-		dev_err(&interface->dev, "firmware_s2250 download failed\n");
-		goto failed2;
-	}
-
-	usb_set_intfdata(interface, s);
-	return 0;
-
-failed:
-	mutex_unlock(&s2250_dev_table_mutex);
-failed2:
-	if (s)
-		kref_put(&(s->kref), s2250loader_delete);
-
-	dev_err(&interface->dev, "probe failed\n");
-	return -1;
-}
-
-static void s2250loader_disconnect(struct usb_interface *interface)
-{
-	pdevice_extension_t s;
-	dev_info(&interface->dev, "s2250: disconnect\n");
-	s = usb_get_intfdata(interface);
-	usb_set_intfdata(interface, NULL);
-	kref_put(&(s->kref), s2250loader_delete);
-}
-
-static const struct usb_device_id s2250loader_ids[] = {
-	{USB_DEVICE(0x1943, 0xa250)},
-	{}                          /* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE(usb, s2250loader_ids);
-
-static struct usb_driver s2250loader_driver = {
-	.name		= "s2250-loader",
-	.probe		= s2250loader_probe,
-	.disconnect	= s2250loader_disconnect,
-	.id_table	= s2250loader_ids,
-};
-
-module_usb_driver(s2250loader_driver);
-
-MODULE_AUTHOR("");
-MODULE_DESCRIPTION("firmware loader for Sensoray 2250/2251");
-MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE(S2250_LOADER_FIRMWARE);
-MODULE_FIRMWARE(S2250_FIRMWARE);
diff --git a/drivers/staging/media/go7007/s2250-loader.h b/drivers/staging/media/go7007/s2250-loader.h
deleted file mode 100644
index b7c301a..0000000
--- a/drivers/staging/media/go7007/s2250-loader.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Copyright (C) 2005-2006 Micronas USA Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License (Version 2) as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- */
-
-#ifndef _S2250_LOADER_H_
-#define _S2250_LOADER_H_
-
-extern int s2250loader_init(void);
-extern void s2250loader_cleanup(void);
-
-#endif
-- 
1.7.10.4

