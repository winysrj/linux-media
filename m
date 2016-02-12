Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbcBLJqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Luis de Bethencourt <luis@debethencourt.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 05/11] [media] use v4l2_mc_usb_media_device_init() on most USB devices
Date: Fri, 12 Feb 2016 07:45:00 -0200
Message-Id: <de8b672755676b9531028c1dd9717dc6f319aa94.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Except for the usbuvc driver (with has an embedded media_device
struct on it), the other drivers have a pointer to media_device.

On those drivers, replace their own implementation for the core
one. That warrants that those subdev drivers will fill the
media_device info the same way.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c      | 19 ++++---------------
 drivers/media/usb/cx231xx/cx231xx-cards.c   | 12 +-----------
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 13 ++-----------
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c     | 15 ++-------------
 drivers/media/usb/em28xx/em28xx-cards.c     | 23 ++++++++---------------
 drivers/media/usb/siano/smsusb.c            |  1 +
 6 files changed, 18 insertions(+), 65 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index f23da7e7984b..7cafe4dd5fd1 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -191,23 +191,12 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return -ENOMEM;
-
-	mdev->dev = &udev->dev;
-
 	if (!dev->board.name)
-		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
+		mdev = v4l2_mc_usb_media_device_init(udev, "unknown au0828");
 	else
-		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
+		mdev = v4l2_mc_usb_media_device_init(udev, dev->board.name);
+	if (!mdev)
+		return -ENOMEM;
 
 	dev->media_dev = mdev;
 #endif
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 54e43fe13e6d..a8d0655f7250 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1212,20 +1212,10 @@ static int cx231xx_media_device_init(struct cx231xx *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = v4l2_mc_usb_media_device_init(udev, dev->board.name);
 	if (!mdev)
 		return -ENOMEM;
 
-	mdev->dev = dev->dev;
-	strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
-
 	dev->media_dev = mdev;
 #endif
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 5ec159f22399..4a8769781cea 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -20,6 +20,7 @@
  */
 
 #include "dvb_usb_common.h"
+#include <media/v4l2-mc.h>
 
 static int dvb_usbv2_disable_rc_polling;
 module_param_named(disable_rc_polling, dvb_usbv2_disable_rc_polling, int, 0644);
@@ -407,20 +408,10 @@ static int dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct usb_device *udev = d->udev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = v4l2_mc_usb_media_device_init(udev, d->name);
 	if (!mdev)
 		return -ENOMEM;
 
-	mdev->dev = &udev->dev;
-	strlcpy(mdev->model, d->name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
-
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 71de19ba0e01..513b0c14e4f0 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -7,6 +7,7 @@
  * linux-dvb API.
  */
 #include "dvb-usb-common.h"
+#include <media/v4l2-mc.h>
 
 /* does the complete input transfer handling */
 static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
@@ -102,19 +103,7 @@ static int dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap->dev;
 	struct usb_device *udev = d->udev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return -ENOMEM;
-
-	mdev->dev = &udev->dev;
-	strlcpy(mdev->model, d->desc->name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
+	mdev = v4l2_mc_usb_media_device_init(udev, d->desc->name);
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 06a09b4e4a83..389e95fb0211 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3019,24 +3019,17 @@ static int em28xx_media_device_init(struct em28xx *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (udev->product) {
+		mdev = v4l2_mc_usb_media_device_init(udev, udev->product);
+	} else if (udev->manufacturer) {
+		mdev = v4l2_mc_usb_media_device_init(udev, udev->manufacturer);
+	} else {
+		mdev = v4l2_mc_usb_media_device_init(udev, dev->name);
+	}
+
 	if (!mdev)
 		return -ENOMEM;
 
-	mdev->dev = &udev->dev;
-
-	if (!dev->name)
-		strlcpy(mdev->model, "unknown em28xx", sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, dev->name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	media_device_init(mdev);
-
 	dev->media_dev = mdev;
 #endif
 	return 0;
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 8abbd3cc8eba..6cb4be6dddbb 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -27,6 +27,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/firmware.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <media/v4l2-mc.h>
 
 #include "sms-cards.h"
 #include "smsendian.h"
-- 
2.5.0


