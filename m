Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbcBVPck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 10:32:40 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 1/2] [media] media-device: move PCI/USB helper functions from v4l2-mc
Date: Mon, 22 Feb 2016 12:32:30 -0300
Message-Id: <e8f1f3b3a4cb69bffbbc1581b84e3c640cad9f33.1456155125.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those ancillary functions could be called even when compiled
without V4L2 support, as warned by ktest build robot:

All errors (new ones prefixed by >>):

>> ERROR: "__v4l2_mc_usb_media_device_init" [drivers/media/usb/dvb-usb/dvb-usb.ko] undefined!
>> ERROR: "__v4l2_mc_usb_media_device_init" [drivers/media/usb/dvb-usb-v2/dvb_usb_v2.ko] undefined!
>> ERROR: "__v4l2_mc_usb_media_device_init" [drivers/media/usb/au0828/au0828.ko] undefined!

Also, there's nothing there that are specific to V4L2. So, move
those ancillary functions to MC core.

No functional changes. Just function rename.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c                | 74 ++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-core.c    |  2 +-
 drivers/media/usb/au0828/au0828-core.c      |  4 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c   |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  4 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c     |  4 +-
 drivers/media/usb/em28xx/em28xx-cards.c     |  6 +--
 drivers/media/usb/siano/smsusb.c            |  4 +-
 drivers/media/v4l2-core/v4l2-mc.c           | 76 +----------------------------
 include/media/media-device.h                | 53 ++++++++++++++++++++
 include/media/v4l2-mc.h                     | 46 -----------------
 11 files changed, 141 insertions(+), 134 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5ebb3cd31345..fe376b6b5244 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -27,6 +27,8 @@
 #include <linux/media.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/usb.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
@@ -753,4 +755,76 @@ struct media_device *media_device_find_devres(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
 
+struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
+					   const char *name)
+{
+#ifdef CONFIG_PCI
+	struct media_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return NULL;
+
+	mdev->dev = &pci_dev->dev;
+
+	if (name)
+		strlcpy(mdev->model, name, sizeof(mdev->model));
+	else
+		strlcpy(mdev->model, pci_name(pci_dev), sizeof(mdev->model));
+
+	sprintf(mdev->bus_info, "PCI:%s", pci_name(pci_dev));
+
+	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
+			    | pci_dev->subsystem_device;
+
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	media_device_init(mdev);
+
+	return mdev;
+#else
+	return NULL;
+#endif
+}
+EXPORT_SYMBOL_GPL(media_device_pci_init);
+
+struct media_device *__media_device_usb_init(struct usb_device *udev,
+					     const char *board_name,
+					     const char *driver_name)
+{
+#ifdef CONFIG_USB
+	struct media_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return NULL;
+
+	mdev->dev = &udev->dev;
+
+	if (driver_name)
+		strlcpy(mdev->driver_name, driver_name,
+			sizeof(mdev->driver_name));
+
+	if (board_name)
+		strlcpy(mdev->model, board_name, sizeof(mdev->model));
+	else if (udev->product)
+		strlcpy(mdev->model, udev->product, sizeof(mdev->model));
+	else
+		strlcpy(mdev->model, "unknown model", sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	media_device_init(mdev);
+
+	return mdev;
+#else
+	return NULL;
+#endif
+}
+EXPORT_SYMBOL_GPL(__media_device_usb_init);
+
+
 #endif /* CONFIG_MEDIA_CONTROLLER */
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8f3ba4077130..8ae65bb320a3 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1043,7 +1043,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	sprintf(dev->name, "saa%x[%d]", pci_dev->device, dev->nr);
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	dev->media_dev = v4l2_mc_pci_media_device_init(pci_dev, dev->name);
+	dev->media_dev = media_device_pci_init(pci_dev, dev->name);
 	if (!dev->media_dev) {
 		err = -ENOMEM;
 		goto fail0;
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7cafe4dd5fd1..cfcd08ec388f 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -192,9 +192,9 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 	struct media_device *mdev;
 
 	if (!dev->board.name)
-		mdev = v4l2_mc_usb_media_device_init(udev, "unknown au0828");
+		mdev = media_device_usb_init(udev, "unknown au0828");
 	else
-		mdev = v4l2_mc_usb_media_device_init(udev, dev->board.name);
+		mdev = media_device_usb_init(udev, dev->board.name);
 	if (!mdev)
 		return -ENOMEM;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 9e3a5d2038c2..29bd7536feed 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1212,7 +1212,7 @@ static int cx231xx_media_device_init(struct cx231xx *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = v4l2_mc_usb_media_device_init(udev, dev->board.name);
+	mdev = media_device_usb_init(udev, dev->board.name);
 	if (!mdev)
 		return -ENOMEM;
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 4a8769781cea..58250250a443 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -20,7 +20,7 @@
  */
 
 #include "dvb_usb_common.h"
-#include <media/v4l2-mc.h>
+#include <media/media-device.h>
 
 static int dvb_usbv2_disable_rc_polling;
 module_param_named(disable_rc_polling, dvb_usbv2_disable_rc_polling, int, 0644);
@@ -408,7 +408,7 @@ static int dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct usb_device *udev = d->udev;
 
-	mdev = v4l2_mc_usb_media_device_init(udev, d->name);
+	mdev = media_device_usb_init(udev, d->name);
 	if (!mdev)
 		return -ENOMEM;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 513b0c14e4f0..7509408b0b8e 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -7,7 +7,7 @@
  * linux-dvb API.
  */
 #include "dvb-usb-common.h"
-#include <media/v4l2-mc.h>
+#include <media/media-device.h>
 
 /* does the complete input transfer handling */
 static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
@@ -103,7 +103,7 @@ static int dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap->dev;
 	struct usb_device *udev = d->udev;
 
-	mdev = v4l2_mc_usb_media_device_init(udev, d->desc->name);
+	mdev = media_device_usb_init(udev, d->desc->name);
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 389e95fb0211..0bae26325253 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3020,11 +3020,11 @@ static int em28xx_media_device_init(struct em28xx *dev,
 	struct media_device *mdev;
 
 	if (udev->product) {
-		mdev = v4l2_mc_usb_media_device_init(udev, udev->product);
+		mdev = media_device_usb_init(udev, udev->product);
 	} else if (udev->manufacturer) {
-		mdev = v4l2_mc_usb_media_device_init(udev, udev->manufacturer);
+		mdev = media_device_usb_init(udev, udev->manufacturer);
 	} else {
-		mdev = v4l2_mc_usb_media_device_init(udev, dev->name);
+		mdev = media_device_usb_init(udev, dev->name);
 	}
 
 	if (!mdev)
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 4dac499ed28e..4a0def1e1528 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -27,7 +27,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/firmware.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <media/v4l2-mc.h>
+#include <media/media-device.h>
 
 #include "sms-cards.h"
 #include "smsendian.h"
@@ -367,7 +367,7 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 	struct sms_board *board = sms_get_board(board_id);
 	int ret;
 
-	mdev = v4l2_mc_usb_media_device_init(udev, board->name);
+	mdev = media_device_usb_init(udev, board->name);
 	if (!mdev)
 		return NULL;
 
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 64eefb9ffb7e..4a1efa827fe2 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -1,7 +1,7 @@
 /*
  * Media Controller ancillary functions
  *
- * (c) 2016 Mauro Carvalho Chehab <mchehab@osg.samsung.com>
+ * Copyright (c) 2016 Mauro Carvalho Chehab <mchehab@osg.samsung.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -15,83 +15,9 @@
  */
 
 #include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/usb.h>
 #include <media/media-entity.h>
 #include <media/v4l2-mc.h>
 
-
-struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
-						   const char *name)
-{
-#ifdef CONFIG_PCI
-	struct media_device *mdev;
-
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return NULL;
-
-	mdev->dev = &pci_dev->dev;
-
-	if (name)
-		strlcpy(mdev->model, name, sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, pci_name(pci_dev), sizeof(mdev->model));
-
-	sprintf(mdev->bus_info, "PCI:%s", pci_name(pci_dev));
-
-	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
-			    | pci_dev->subsystem_device;
-
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
-
-	return mdev;
-#else
-	return NULL;
-#endif
-}
-EXPORT_SYMBOL_GPL(v4l2_mc_pci_media_device_init);
-
-struct media_device *__v4l2_mc_usb_media_device_init(struct usb_device *udev,
-						     const char *board_name,
-						     const char *driver_name)
-{
-#ifdef CONFIG_USB
-	struct media_device *mdev;
-
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return NULL;
-
-	mdev->dev = &udev->dev;
-
-	if (driver_name)
-		strlcpy(mdev->driver_name, driver_name,
-			sizeof(mdev->driver_name));
-
-	if (board_name)
-		strlcpy(mdev->model, board_name, sizeof(mdev->model));
-	else if (udev->product)
-		strlcpy(mdev->model, udev->product, sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, "unknown model", sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
-
-	return mdev;
-#else
-	return NULL;
-#endif
-}
-EXPORT_SYMBOL_GPL(__v4l2_mc_usb_media_device_init);
-
 int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 {
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 165451bc3985..2d144fed936e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -333,6 +333,10 @@ struct media_device {
 			   unsigned int notification);
 };
 
+/* We don't need to include pci.h or usb.h here */
+struct pci_dev;
+struct usb_device;
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 
 /* Supported link_notify @notification values. */
@@ -541,6 +545,35 @@ struct media_device *media_device_find_devres(struct device *dev);
 /* Iterate over all links. */
 #define media_device_for_each_link(link, mdev)			\
 	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
+
+/**
+ * media_device_pci_init() - create and initialize a
+ *	struct &media_device from a PCI device.
+ *
+ * @pci_dev:	pointer to struct pci_dev
+ * @name:	media device name. If %NULL, the routine will use the default
+ *		name for the pci device, given by pci_name() macro.
+ */
+struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
+					   const char *name);
+/**
+ * __media_device_usb_init() - create and initialize a
+ *	struct &media_device from a PCI device.
+ *
+ * @udev:	pointer to struct usb_device
+ * @board_name:	media device name. If %NULL, the routine will use the usb
+ *		product name, if available.
+ * @driver_name: name of the driver. if %NULL, the routine will use the name
+ *		given by udev->dev->driver->name, with is usually the wrong
+ *		thing to do.
+ *
+ * NOTE: It is better to call media_device_usb_init() instead, as
+ * such macro fills driver_name with %KBUILD_MODNAME.
+ */
+struct media_device *__media_device_usb_init(struct usb_device *udev,
+					     const char *board_name,
+					     const char *driver_name);
+
 #else
 static inline int media_device_register(struct media_device *mdev)
 {
@@ -565,5 +598,25 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
 {
 	return NULL;
 }
+
+static inline
+struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
+					   char *name)
+{
+	return NULL;
+}
+
+static inline
+struct media_device *__media_device_usb_init(struct usb_device *udev,
+					     char *board_name,
+					     char *driver_name)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_MEDIA_CONTROLLER */
+
+#define media_device_usb_init(udev, name) \
+	__media_device_usb_init(udev, name, KBUILD_MODNAME)
+
 #endif
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 79d84bb3573c..431380eb408b 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -116,57 +116,11 @@ struct usb_device;
  */
 int v4l2_mc_create_media_graph(struct media_device *mdev);
 
-/**
- * v4l2_mc_pci_media_device_init() - create and initialize a
- *	struct &media_device from a PCI device.
- *
- * @pci_dev:	pointer to struct pci_dev
- * @name:	media device name. If %NULL, the routine will use the default
- *		name for the pci device, given by pci_name() macro.
- */
-struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
-						   const char *name);
-/**
- * __v4l2_mc_usb_media_device_init() - create and initialize a
- *	struct &media_device from a PCI device.
- *
- * @udev:	pointer to struct usb_device
- * @board_name:	media device name. If %NULL, the routine will use the usb
- *		product name, if available.
- * @driver_name: name of the driver. if %NULL, the routine will use the name
- *		given by udev->dev->driver->name, with is usually the wrong
- *		thing to do.
- *
- * NOTE: It is better to call v4l2_mc_usb_media_device_init() instead, as
- * such macro fills driver_name with %KBUILD_MODNAME.
- */
-struct media_device *__v4l2_mc_usb_media_device_init(struct usb_device *udev,
-						     const char *board_name,
-						     const char *driver_name);
-
 #else
 static inline int v4l2_mc_create_media_graph(struct media_device *mdev)
 {
 	return 0;
 }
 
-static inline
-struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
-						   char *name)
-{
-	return NULL;
-}
-
-static inline
-struct media_device *__v4l2_mc_usb_media_device_init(struct usb_device *udev,
-						     char *board_name,
-						     char *driver_name)
-{
-	return NULL;
-}
 #endif
-
-#define v4l2_mc_usb_media_device_init(udev, name) \
-	__v4l2_mc_usb_media_device_init(udev, name, KBUILD_MODNAME)
-
 #endif
-- 
2.5.0

