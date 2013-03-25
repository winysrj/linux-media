Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1695 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3CYKRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 06:17:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH] media: move dvb-usb-v2/cypress_firmware.c to media/common.
Date: Mon, 25 Mar 2013 11:17:25 +0100
Message-Id: <64d364f6356c1b9c84ebfb15887f37ba822f3658.1364206645.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Loading the cypress firmware is not dvb specific and should be common
functionality. Move the source to media/common and make it a standalone
module.

As a result we can remove the dependency on dvb-usb in go7007, which has
nothing to do with dvb.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/Kconfig                    |    3 +
 drivers/media/common/Makefile                   |    2 +
 drivers/media/common/cypress_firmware.c         |  132 ++++++++++++++++++++++
 drivers/media/common/cypress_firmware.h         |   28 +++++
 drivers/media/usb/dvb-usb-v2/Kconfig            |    6 +-
 drivers/media/usb/dvb-usb-v2/Makefile           |    5 +-
 drivers/media/usb/dvb-usb-v2/az6007.c           |    2 +-
 drivers/media/usb/dvb-usb-v2/cypress_firmware.c |  133 -----------------------
 drivers/media/usb/dvb-usb-v2/cypress_firmware.h |   31 ------
 drivers/staging/media/go7007/Kconfig            |    3 +-
 drivers/staging/media/go7007/Makefile           |    6 +-
 drivers/staging/media/go7007/go7007-loader.c    |    4 +-
 12 files changed, 173 insertions(+), 182 deletions(-)
 create mode 100644 drivers/media/common/cypress_firmware.c
 create mode 100644 drivers/media/common/cypress_firmware.h
 delete mode 100644 drivers/media/usb/dvb-usb-v2/cypress_firmware.c
 delete mode 100644 drivers/media/usb/dvb-usb-v2/cypress_firmware.h

diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
index 56c25e6..ba666c7 100644
--- a/drivers/media/common/Kconfig
+++ b/drivers/media/common/Kconfig
@@ -16,6 +16,9 @@ config VIDEO_TVEEPROM
 	tristate
 	depends on I2C
 
+config CYPRESS_FIRMWARE
+	tristate "Cypress firmware helper routines"
+
 source "drivers/media/common/b2c2/Kconfig"
 source "drivers/media/common/saa7146/Kconfig"
 source "drivers/media/common/siano/Kconfig"
diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
index 8f8d187..2a52a22 100644
--- a/drivers/media/common/Makefile
+++ b/drivers/media/common/Makefile
@@ -2,3 +2,5 @@ obj-y += b2c2/ saa7146/ siano/
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
+obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
+
diff --git a/drivers/media/common/cypress_firmware.c b/drivers/media/common/cypress_firmware.c
new file mode 100644
index 0000000..577e820
--- /dev/null
+++ b/drivers/media/common/cypress_firmware.c
@@ -0,0 +1,132 @@
+/*  cypress_firmware.c is part of the DVB USB library.
+ *
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * see dvb-usb-init.c for copyright information.
+ *
+ * This file contains functions for downloading the firmware to Cypress FX 1
+ * and 2 based devices.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/firmware.h>
+#include "cypress_firmware.h"
+
+struct usb_cypress_controller {
+	u8 id;
+	const char *name;	/* name of the usb controller */
+	u16 cs_reg;		/* needs to be restarted,
+				 * when the firmware has been downloaded */
+};
+
+static const struct usb_cypress_controller cypress[] = {
+	{ .id = CYPRESS_AN2135, .name = "Cypress AN2135", .cs_reg = 0x7f92 },
+	{ .id = CYPRESS_AN2235, .name = "Cypress AN2235", .cs_reg = 0x7f92 },
+	{ .id = CYPRESS_FX2,    .name = "Cypress FX2",    .cs_reg = 0xe600 },
+};
+
+/*
+ * load a firmware packet to the device
+ */
+static int usb_cypress_writemem(struct usb_device *udev, u16 addr, u8 *data,
+		u8 len)
+{
+	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			0xa0, USB_TYPE_VENDOR, addr, 0x00, data, len, 5000);
+}
+
+static int cypress_get_hexline(const struct firmware *fw,
+				struct hexline *hx, int *pos)
+{
+	u8 *b = (u8 *) &fw->data[*pos];
+	int data_offs = 4;
+
+	if (*pos >= fw->size)
+		return 0;
+
+	memset(hx, 0, sizeof(struct hexline));
+	hx->len = b[0];
+
+	if ((*pos + hx->len + 4) >= fw->size)
+		return -EINVAL;
+
+	hx->addr = b[1] | (b[2] << 8);
+	hx->type = b[3];
+
+	if (hx->type == 0x04) {
+		/* b[4] and b[5] are the Extended linear address record data
+		 * field */
+		hx->addr |= (b[4] << 24) | (b[5] << 16);
+	}
+
+	memcpy(hx->data, &b[data_offs], hx->len);
+	hx->chk = b[hx->len + data_offs];
+	*pos += hx->len + 5;
+
+	return *pos;
+}
+
+int cypress_load_firmware(struct usb_device *udev,
+		const struct firmware *fw, int type)
+{
+	struct hexline *hx;
+	int ret, pos = 0;
+
+	hx = kmalloc(sizeof(struct hexline), GFP_KERNEL);
+	if (!hx) {
+		dev_err(&udev->dev, "%s: kmalloc() failed\n", KBUILD_MODNAME);
+		return -ENOMEM;
+	}
+
+	/* stop the CPU */
+	hx->data[0] = 1;
+	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, hx->data, 1);
+	if (ret != 1) {
+		dev_err(&udev->dev, "%s: CPU stop failed=%d\n",
+				KBUILD_MODNAME, ret);
+		ret = -EIO;
+		goto err_kfree;
+	}
+
+	/* write firmware to memory */
+	for (;;) {
+		ret = cypress_get_hexline(fw, hx, &pos);
+		if (ret < 0)
+			goto err_kfree;
+		else if (ret == 0)
+			break;
+
+		ret = usb_cypress_writemem(udev, hx->addr, hx->data, hx->len);
+		if (ret < 0) {
+			goto err_kfree;
+		} else if (ret != hx->len) {
+			dev_err(&udev->dev,
+					"%s: error while transferring firmware (transferred size=%d, block size=%d)\n",
+					KBUILD_MODNAME, ret, hx->len);
+			ret = -EIO;
+			goto err_kfree;
+		}
+	}
+
+	/* start the CPU */
+	hx->data[0] = 0;
+	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, hx->data, 1);
+	if (ret != 1) {
+		dev_err(&udev->dev, "%s: CPU start failed=%d\n",
+				KBUILD_MODNAME, ret);
+		ret = -EIO;
+		goto err_kfree;
+	}
+
+	ret = 0;
+err_kfree:
+	kfree(hx);
+	return ret;
+}
+EXPORT_SYMBOL(cypress_load_firmware);
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("Cypress firmware download");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/common/cypress_firmware.h b/drivers/media/common/cypress_firmware.h
new file mode 100644
index 0000000..e493cbc
--- /dev/null
+++ b/drivers/media/common/cypress_firmware.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * see dvb-usb-init.c for copyright information.
+ *
+ * This file contains functions for downloading the firmware to Cypress FX 1
+ * and 2 based devices.
+ *
+ */
+
+#ifndef CYPRESS_FIRMWARE_H
+#define CYPRESS_FIRMWARE_H
+
+#define CYPRESS_AN2135  0
+#define CYPRESS_AN2235  1
+#define CYPRESS_FX2     2
+
+/* commonly used firmware download types and function */
+struct hexline {
+	u8 len;
+	u32 addr;
+	u8 type;
+	u8 data[255];
+	u8 chk;
+};
+
+int cypress_load_firmware(struct usb_device *, const struct firmware *, int);
+
+#endif
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 2d4abfa..9aff035 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -13,10 +13,6 @@ config DVB_USB_V2
 
 	  Say Y if you own a USB DVB device.
 
-config DVB_USB_CYPRESS_FIRMWARE
-	tristate "Cypress firmware helper routines"
-	depends on DVB_USB_V2
-
 config DVB_USB_AF9015
 	tristate "Afatech AF9015 DVB-T USB2.0 support"
 	depends on DVB_USB_V2
@@ -73,7 +69,7 @@ config DVB_USB_AU6610
 config DVB_USB_AZ6007
 	tristate "AzureWave 6007 and clones DVB-T/C USB2.0 support"
 	depends on DVB_USB_V2
-	select DVB_USB_CYPRESS_FIRMWARE
+	select CYPRESS_FIRMWARE
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2063 if MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index b76f58e..2c06714 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -1,9 +1,6 @@
 dvb_usb_v2-objs := dvb_usb_core.o dvb_usb_urb.o usb_urb.o
 obj-$(CONFIG_DVB_USB_V2) += dvb_usb_v2.o
 
-dvb_usb_cypress_firmware-objs := cypress_firmware.o
-obj-$(CONFIG_DVB_USB_CYPRESS_FIRMWARE) += dvb_usb_cypress_firmware.o
-
 dvb-usb-af9015-objs := af9015.o
 obj-$(CONFIG_DVB_USB_AF9015) += dvb-usb-af9015.o
 
@@ -46,4 +43,4 @@ obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
-
+ccflags-y += -I$(srctree)/drivers/media/common
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 70ec80d..44c64ef3 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -842,7 +842,7 @@ static int az6007_download_firmware(struct dvb_usb_device *d,
 {
 	pr_debug("Loading az6007 firmware\n");
 
-	return usbv2_cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
+	return cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
 }
 
 /* DVB USB Driver stuff */
diff --git a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
deleted file mode 100644
index cfb1733..0000000
--- a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*  cypress_firmware.c is part of the DVB USB library.
- *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
- * see dvb-usb-init.c for copyright information.
- *
- * This file contains functions for downloading the firmware to Cypress FX 1
- * and 2 based devices.
- *
- */
-
-#include "dvb_usb.h"
-#include "cypress_firmware.h"
-
-struct usb_cypress_controller {
-	u8 id;
-	const char *name;	/* name of the usb controller */
-	u16 cs_reg;		/* needs to be restarted,
-				 * when the firmware has been downloaded */
-};
-
-static const struct usb_cypress_controller cypress[] = {
-	{ .id = CYPRESS_AN2135, .name = "Cypress AN2135", .cs_reg = 0x7f92 },
-	{ .id = CYPRESS_AN2235, .name = "Cypress AN2235", .cs_reg = 0x7f92 },
-	{ .id = CYPRESS_FX2,    .name = "Cypress FX2",    .cs_reg = 0xe600 },
-};
-
-/*
- * load a firmware packet to the device
- */
-static int usb_cypress_writemem(struct usb_device *udev, u16 addr, u8 *data,
-		u8 len)
-{
-	dvb_usb_dbg_usb_control_msg(udev,
-			0xa0, USB_TYPE_VENDOR, addr, 0x00, data, len);
-
-	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			0xa0, USB_TYPE_VENDOR, addr, 0x00, data, len, 5000);
-}
-
-int usbv2_cypress_load_firmware(struct usb_device *udev,
-		const struct firmware *fw, int type)
-{
-	struct hexline *hx;
-	int ret, pos = 0;
-
-	hx = kmalloc(sizeof(struct hexline), GFP_KERNEL);
-	if (!hx) {
-		dev_err(&udev->dev, "%s: kmalloc() failed\n", KBUILD_MODNAME);
-		return -ENOMEM;
-	}
-
-	/* stop the CPU */
-	hx->data[0] = 1;
-	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, hx->data, 1);
-	if (ret != 1) {
-		dev_err(&udev->dev, "%s: CPU stop failed=%d\n",
-				KBUILD_MODNAME, ret);
-		ret = -EIO;
-		goto err_kfree;
-	}
-
-	/* write firmware to memory */
-	for (;;) {
-		ret = dvb_usbv2_get_hexline(fw, hx, &pos);
-		if (ret < 0)
-			goto err_kfree;
-		else if (ret == 0)
-			break;
-
-		ret = usb_cypress_writemem(udev, hx->addr, hx->data, hx->len);
-		if (ret < 0) {
-			goto err_kfree;
-		} else if (ret != hx->len) {
-			dev_err(&udev->dev,
-					"%s: error while transferring firmware (transferred size=%d, block size=%d)\n",
-					KBUILD_MODNAME, ret, hx->len);
-			ret = -EIO;
-			goto err_kfree;
-		}
-	}
-
-	/* start the CPU */
-	hx->data[0] = 0;
-	ret = usb_cypress_writemem(udev, cypress[type].cs_reg, hx->data, 1);
-	if (ret != 1) {
-		dev_err(&udev->dev, "%s: CPU start failed=%d\n",
-				KBUILD_MODNAME, ret);
-		ret = -EIO;
-		goto err_kfree;
-	}
-
-	ret = 0;
-err_kfree:
-	kfree(hx);
-	return ret;
-}
-EXPORT_SYMBOL(usbv2_cypress_load_firmware);
-
-int dvb_usbv2_get_hexline(const struct firmware *fw, struct hexline *hx,
-		int *pos)
-{
-	u8 *b = (u8 *) &fw->data[*pos];
-	int data_offs = 4;
-
-	if (*pos >= fw->size)
-		return 0;
-
-	memset(hx, 0, sizeof(struct hexline));
-	hx->len = b[0];
-
-	if ((*pos + hx->len + 4) >= fw->size)
-		return -EINVAL;
-
-	hx->addr = b[1] | (b[2] << 8);
-	hx->type = b[3];
-
-	if (hx->type == 0x04) {
-		/* b[4] and b[5] are the Extended linear address record data
-		 * field */
-		hx->addr |= (b[4] << 24) | (b[5] << 16);
-	}
-
-	memcpy(hx->data, &b[data_offs], hx->len);
-	hx->chk = b[hx->len + data_offs];
-	*pos += hx->len + 5;
-
-	return *pos;
-}
-EXPORT_SYMBOL(dvb_usbv2_get_hexline);
-
-MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
-MODULE_DESCRIPTION("Cypress firmware download");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb-v2/cypress_firmware.h b/drivers/media/usb/dvb-usb-v2/cypress_firmware.h
deleted file mode 100644
index 80085fd..0000000
--- a/drivers/media/usb/dvb-usb-v2/cypress_firmware.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* cypress_firmware.h is part of the DVB USB library.
- *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
- * see dvb-usb-init.c for copyright information.
- *
- * This file contains functions for downloading the firmware to Cypress FX 1
- * and 2 based devices.
- *
- */
-
-#ifndef CYPRESS_FIRMWARE_H
-#define CYPRESS_FIRMWARE_H
-
-#define CYPRESS_AN2135  0
-#define CYPRESS_AN2235  1
-#define CYPRESS_FX2     2
-
-/* commonly used firmware download types and function */
-struct hexline {
-	u8 len;
-	u32 addr;
-	u8 type;
-	u8 data[255];
-	u8 chk;
-};
-extern int usbv2_cypress_load_firmware(struct usb_device *,
-		const struct firmware *, int);
-extern int dvb_usbv2_get_hexline(const struct firmware *,
-		struct hexline *, int *);
-
-#endif
diff --git a/drivers/staging/media/go7007/Kconfig b/drivers/staging/media/go7007/Kconfig
index b10f996..6cdc6ba 100644
--- a/drivers/staging/media/go7007/Kconfig
+++ b/drivers/staging/media/go7007/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_GO7007
 	depends on SND
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_TUNER
+	select CYPRESS_FIRMWARE
 	select SND_PCM
 	select VIDEO_SONY_BTF_MPX if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
@@ -33,7 +34,7 @@ config VIDEO_GO7007_USB
 
 config VIDEO_GO7007_LOADER
 	tristate "WIS GO7007 Loader support"
-	depends on VIDEO_GO7007 && DVB_USB
+	depends on VIDEO_GO7007
 	default y
 	---help---
 	  This is a go7007 firmware loader driver for the WIS GO7007
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index bbc8a32..9c6ad4a 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -12,8 +12,4 @@ s2250-y := s2250-board.o
 #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
 #ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/pci/saa7134
 
-# go7007-loader needs cypress ezusb loader from dvb-usb-v2
-ccflags-$(CONFIG_VIDEO_GO7007_LOADER:m=y) += -Idrivers/media/usb/dvb-usb-v2
-
-ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/dvb-core
+ccflags-$(CONFIG_VIDEO_GO7007_LOADER:m=y) += -Idrivers/media/common
diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/staging/media/go7007/go7007-loader.c
index 4ce53d6..f846ad5 100644
--- a/drivers/staging/media/go7007/go7007-loader.c
+++ b/drivers/staging/media/go7007/go7007-loader.c
@@ -85,7 +85,7 @@ static int go7007_loader_probe(struct usb_interface *interface,
 			"unable to load firmware from file \"%s\"\n", fw1);
 		goto failed2;
 	}
-	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
+	ret = cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
 	release_firmware(fw);
 	if (0 != ret) {
 		dev_err(&interface->dev, "loader download failed\n");
@@ -100,7 +100,7 @@ static int go7007_loader_probe(struct usb_interface *interface,
 			"unable to load firmware from file \"%s\"\n", fw2);
 		goto failed2;
 	}
-	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
+	ret = cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
 	release_firmware(fw);
 	if (0 != ret) {
 		dev_err(&interface->dev, "firmware download failed\n");
-- 
1.7.10.4

