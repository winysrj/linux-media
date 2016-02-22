Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbcBVPck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 10:32:40 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Olli Salonen <olli.salonen@iki.fi>,
	Luis de Bethencourt <luis@debethencourt.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 2/2] [media] media_device: move allocation out of media_device_*_init
Date: Mon, 22 Feb 2016 12:32:31 -0300
Message-Id: <f2d3024f672ffe5705a7be2a69205c321692fecf.1456155125.git.mchehab@osg.samsung.com>
In-Reply-To: <e8f1f3b3a4cb69bffbbc1581b84e3c640cad9f33.1456155125.git.mchehab@osg.samsung.com>
References: <e8f1f3b3a4cb69bffbbc1581b84e3c640cad9f33.1456155125.git.mchehab@osg.samsung.com>
In-Reply-To: <e8f1f3b3a4cb69bffbbc1581b84e3c640cad9f33.1456155125.git.mchehab@osg.samsung.com>
References: <e8f1f3b3a4cb69bffbbc1581b84e3c640cad9f33.1456155125.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, media_device_pci_init and media_device_usb_init does
media_device allocation internaly. That preents its usage when
the media_device struct is embedded on some other structure.

Move memory allocation outside it, to make it more generic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c                | 32 +++++++----------------------
 drivers/media/pci/saa7134/saa7134-core.c    |  3 ++-
 drivers/media/usb/au0828/au0828-core.c      | 10 +++++----
 drivers/media/usb/cx231xx/cx231xx-cards.c   |  4 +++-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  4 +++-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c     |  6 +++++-
 drivers/media/usb/em28xx/em28xx-cards.c     | 16 +++++++--------
 drivers/media/usb/siano/smsusb.c            |  4 +++-
 include/media/media-device.h                | 32 ++++++++++++++++-------------
 9 files changed, 55 insertions(+), 56 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index fe376b6b5244..6613723f5eb8 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -755,16 +755,11 @@ struct media_device *media_device_find_devres(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(media_device_find_devres);
 
-struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
-					   const char *name)
+void media_device_pci_init(struct media_device *mdev,
+			   struct pci_dev *pci_dev,
+			   const char *name)
 {
 #ifdef CONFIG_PCI
-	struct media_device *mdev;
-
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return NULL;
-
 	mdev->dev = &pci_dev->dev;
 
 	if (name)
@@ -780,25 +775,16 @@ struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
 	mdev->driver_version = LINUX_VERSION_CODE;
 
 	media_device_init(mdev);
-
-	return mdev;
-#else
-	return NULL;
 #endif
 }
 EXPORT_SYMBOL_GPL(media_device_pci_init);
 
-struct media_device *__media_device_usb_init(struct usb_device *udev,
-					     const char *board_name,
-					     const char *driver_name)
+void __media_device_usb_init(struct media_device *mdev,
+			     struct usb_device *udev,
+			     const char *board_name,
+			     const char *driver_name)
 {
 #ifdef CONFIG_USB
-	struct media_device *mdev;
-
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return NULL;
-
 	mdev->dev = &udev->dev;
 
 	if (driver_name)
@@ -818,10 +804,6 @@ struct media_device *__media_device_usb_init(struct usb_device *udev,
 	mdev->driver_version = LINUX_VERSION_CODE;
 
 	media_device_init(mdev);
-
-	return mdev;
-#else
-	return NULL;
 #endif
 }
 EXPORT_SYMBOL_GPL(__media_device_usb_init);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8ae65bb320a3..2e77a5a80119 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1043,11 +1043,12 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	sprintf(dev->name, "saa%x[%d]", pci_dev->device, dev->nr);
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	dev->media_dev = media_device_pci_init(pci_dev, dev->name);
+	dev->media_dev = kzalloc(sizeof(*dev->media_dev), GFP_KERNEL);
 	if (!dev->media_dev) {
 		err = -ENOMEM;
 		goto fail0;
 	}
+	media_device_pci_init(dev->media_dev, pci_dev, dev->name);
 	dev->v4l2_dev.mdev = dev->media_dev;
 #endif
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index cfcd08ec388f..5fea4adef90b 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -191,12 +191,14 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return -ENOMEM;
+
 	if (!dev->board.name)
-		mdev = media_device_usb_init(udev, "unknown au0828");
+		media_device_usb_init(mdev, udev, "unknown au0828");
 	else
-		mdev = media_device_usb_init(udev, dev->board.name);
-	if (!mdev)
-		return -ENOMEM;
+		media_device_usb_init(mdev, udev, dev->board.name);
 
 	dev->media_dev = mdev;
 #endif
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 29bd7536feed..c63248a18823 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1212,10 +1212,12 @@ static int cx231xx_media_device_init(struct cx231xx *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = media_device_usb_init(udev, dev->board.name);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return -ENOMEM;
 
+	media_device_usb_init(mdev, udev, dev->board.name);
+
 	dev->media_dev = mdev;
 #endif
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 58250250a443..3fbb2cd19f5e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -408,10 +408,12 @@ static int dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct usb_device *udev = d->udev;
 
-	mdev = media_device_usb_init(udev, d->name);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return -ENOMEM;
 
+	media_device_usb_init(mdev, udev, d->name);
+
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 7509408b0b8e..6477b04e95c7 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -103,7 +103,11 @@ static int dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap->dev;
 	struct usb_device *udev = d->udev;
 
-	mdev = media_device_usb_init(udev, d->desc->name);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return -ENOMEM;
+
+	media_device_usb_init(mdev, udev, d->desc->name);
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 0bae26325253..1f4047b3f3f7 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3019,17 +3019,17 @@ static int em28xx_media_device_init(struct em28xx *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	if (udev->product) {
-		mdev = media_device_usb_init(udev, udev->product);
-	} else if (udev->manufacturer) {
-		mdev = media_device_usb_init(udev, udev->manufacturer);
-	} else {
-		mdev = media_device_usb_init(udev, dev->name);
-	}
-
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return -ENOMEM;
 
+	if (udev->product)
+		media_device_usb_init(mdev, udev, udev->product);
+	else if (udev->manufacturer)
+		media_device_usb_init(mdev, udev, udev->manufacturer);
+	else
+		media_device_usb_init(mdev, udev, dev->name);
+
 	dev->media_dev = mdev;
 #endif
 	return 0;
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 4a0def1e1528..c2e25876e93b 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -367,10 +367,12 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 	struct sms_board *board = sms_get_board(board_id);
 	int ret;
 
-	mdev = media_device_usb_init(udev, board->name);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
 		return NULL;
 
+	media_device_usb_init(mdev, udev, board->name);
+
 	ret = media_device_register(mdev);
 	if (ret) {
 		media_device_cleanup(mdev);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 2d144fed936e..49dda6c7e664 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -550,16 +550,19 @@ struct media_device *media_device_find_devres(struct device *dev);
  * media_device_pci_init() - create and initialize a
  *	struct &media_device from a PCI device.
  *
+ * @mdev:	pointer to struct &media_device
  * @pci_dev:	pointer to struct pci_dev
  * @name:	media device name. If %NULL, the routine will use the default
  *		name for the pci device, given by pci_name() macro.
  */
-struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
-					   const char *name);
+void media_device_pci_init(struct media_device *mdev,
+			   struct pci_dev *pci_dev,
+			   const char *name);
 /**
  * __media_device_usb_init() - create and initialize a
  *	struct &media_device from a PCI device.
  *
+ * @mdev:	pointer to struct &media_device
  * @udev:	pointer to struct usb_device
  * @board_name:	media device name. If %NULL, the routine will use the usb
  *		product name, if available.
@@ -570,9 +573,10 @@ struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
  * NOTE: It is better to call media_device_usb_init() instead, as
  * such macro fills driver_name with %KBUILD_MODNAME.
  */
-struct media_device *__media_device_usb_init(struct usb_device *udev,
-					     const char *board_name,
-					     const char *driver_name);
+void __media_device_usb_init(struct media_device *mdev,
+			     struct usb_device *udev,
+			     const char *board_name,
+			     const char *driver_name);
 
 #else
 static inline int media_device_register(struct media_device *mdev)
@@ -599,24 +603,24 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
 	return NULL;
 }
 
-static inline
-struct media_device *media_device_pci_init(struct pci_dev *pci_dev,
-					   char *name)
+static inline void media_device_pci_init(struct media_device *mdev,
+					 struct pci_dev *pci_dev,
+					 char *name)
 {
 	return NULL;
 }
 
-static inline
-struct media_device *__media_device_usb_init(struct usb_device *udev,
-					     char *board_name,
-					     char *driver_name)
+static inline void __media_device_usb_init(struct media_device *mdev,
+					   struct usb_device *udev,
+					   char *board_name,
+					   char *driver_name)
 {
 	return NULL;
 }
 
 #endif /* CONFIG_MEDIA_CONTROLLER */
 
-#define media_device_usb_init(udev, name) \
-	__media_device_usb_init(udev, name, KBUILD_MODNAME)
+#define media_device_usb_init(mdev, udev, name) \
+	__media_device_usb_init(mdev, udev, name, KBUILD_MODNAME)
 
 #endif
-- 
2.5.0

