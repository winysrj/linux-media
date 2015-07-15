Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:59398 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbbGOAkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 20:40:08 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	crope@iki.fi, sakari.ailus@linux.intel.com, arnd@arndb.de,
	stefanr@s5r6.in-berlin.de, ruchandani.tina@gmail.com,
	chehabrafael@gmail.com, dan.carpenter@oracle.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, daniel@zonque.org,
	vladcatoi@gmail.com, misterpib@gmail.com, damien@zamaudio.com,
	pmatilai@laiskiainen.org, takamichiho@gmail.com,
	normalperson@yhbt.net, bugzilla.frnkcg@spamgourmet.com,
	joe@oampo.co.uk, calcprogrammer1@gmail.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 6/7] media: au0828 change to use Managed Media Controller API
Date: Tue, 14 Jul 2015 18:34:05 -0600
Message-Id: <3643452be528b2e53cea592db22b4e0ada32456b.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828 to use Managed Media Controller API to coordinate
creating/deleting media device on parent usb device it shares
with the snd-usb-audio driver. With this change, au0828 uses
media_device_get_devres() to allocate a new media device devres
or return an existing one, if it finds one.

In addition, au0828 registers entity_notify hook to create media
graph for the device. It creates necessary links from video, vbi,
and ALSA entities to decoder and links tuner and decoder entities.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 132 ++++++++++++++++++++-------------
 drivers/media/usb/au0828/au0828.h      |   5 ++
 2 files changed, 85 insertions(+), 52 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 0378a2c..492e910 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -20,6 +20,7 @@
  */
 
 #include "au0828.h"
+#include "au8522.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -131,10 +132,12 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 {
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (dev->media_dev) {
-		media_device_unregister(dev->media_dev);
-		kfree(dev->media_dev);
-		dev->media_dev = NULL;
+	if (dev->media_dev &&
+		media_devnode_is_registered(&dev->media_dev->devnode)) {
+			media_device_unregister_entity_notify(dev->media_dev,
+							&dev->entity_notify);
+			media_device_unregister(dev->media_dev);
+			dev->media_dev = NULL;
 	}
 #endif
 }
@@ -196,53 +199,23 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
-static void au0828_media_device_register(struct au0828_dev *dev,
-					  struct usb_device *udev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev;
-	int ret;
-
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
-		return;
-
-	mdev->dev = &udev->dev;
-
-	if (!dev->board.name)
-		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	ret = media_device_register(mdev);
-	if (ret) {
-		pr_err(
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
-	}
-
-	dev->media_dev = mdev;
-#endif
-}
-
-
-static void au0828_create_media_graph(struct au0828_dev *dev)
+void au0828_create_media_graph(struct media_entity *new, void *notify_data)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
+	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *alsa_capture = NULL;
+	int ret = 0;
 
 	if (!mdev)
 		return;
 
+	if (dev->tuner_linked && dev->vdev_linked && dev->vbi_linked &&
+		dev->alsa_capture_linked)
+		return;
+
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->type) {
 		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
@@ -251,6 +224,9 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_T_DEVNODE_ALSA_CAPTURE:
+			alsa_capture = entity;
+			break;
 		}
 	}
 
@@ -259,15 +235,69 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 	if (!decoder)
 		return;
 
-	if (tuner)
-		media_entity_create_link(tuner, 0, decoder, 0,
+	if (tuner && !dev->tuner_linked) {
+		ret = media_entity_create_link(tuner, 0, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vdev.entity.links)
-		media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
-	if (dev->vbi_dev.entity.links)
-		media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->tuner_linked = 1;
+	}
+	if (dev->vdev.entity.links && !dev->vdev_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_VID_OUT,
+				&dev->vdev.entity, 0, MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->vdev_linked = 1;
+	}
+	if (dev->vbi_dev.entity.links && !dev->vbi_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_VBI_OUT,
+				&dev->vbi_dev.entity, 0, MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->vbi_linked = 1;
+	}
+	if (alsa_capture && !dev->alsa_capture_linked) {
+		ret = media_entity_create_link(decoder, AU8522_PAD_AUDIO_OUT,
+						alsa_capture, 0,
+						MEDIA_LNK_FL_ENABLED);
+		if (ret == 0)
+			dev->alsa_capture_linked = 1;
+	}
+#endif
+}
+
+static void au0828_media_device_register(struct au0828_dev *dev,
+					  struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+	int ret;
+
+	mdev = media_device_get_devres(&udev->dev);
+	if (!mdev)
+		return;
+
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		/* register media device */
+		mdev->dev = &udev->dev;
+		if (udev->product)
+			strlcpy(mdev->model, udev->product,
+				sizeof(mdev->model));
+		if (udev->serial)
+			strlcpy(mdev->serial, udev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, udev->devpath);
+		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&udev->dev,
+				"Couldn't create a media device. Error: %d\n",
+				ret);
+			return;
+		}
+		/* register entity_notify callback */
+		dev->entity_notify.notify_data = (void *) dev;
+		dev->entity_notify.notify = au0828_create_media_graph;
+		media_device_register_entity_notify(mdev, &dev->entity_notify);
+	}
+	dev->media_dev = mdev;
 #endif
 }
 
@@ -383,8 +413,6 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
-	au0828_create_media_graph(dev);
-
 	return retval;
 }
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index d3644b3..a59ba08 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -281,6 +281,11 @@ struct au0828_dev {
 	struct media_device *media_dev;
 	struct media_pad video_pad, vbi_pad;
 	struct media_entity *decoder;
+	struct media_entity_notify entity_notify;
+	bool tuner_linked;
+	bool vdev_linked;
+	bool vbi_linked;
+	bool alsa_capture_linked;
 #endif
 };
 
-- 
2.1.4

