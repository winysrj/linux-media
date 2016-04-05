Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50278 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbcDEDgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 23:36:11 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com, ricard.wanderlof@axis.com,
	julian@jusst.de, pierre-louis.bossart@linux.intel.com,
	clemens@ladisch.de, dominic.sacre@gmx.de, takamichiho@gmail.com,
	johan@oljud.se, geliangtang@163.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH v2 4/5] media: au0828 change to use Media Device Allocator API
Date: Mon,  4 Apr 2016 21:35:59 -0600
Message-Id: <655763f7980edc899f73a6760fe1763a8212d188.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828 to use Media Device Allocator API and new Media Controller
media_device_unregister_put() interface. Fix to unregister entity_notify
hook.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 40 ++++++++++++++++++++++++----------
 drivers/media/usb/au0828/au0828.h      |  1 +
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index cc22b32..c34af36 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -131,22 +131,36 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
 	return status;
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static void au0828_media_graph_notify(struct media_entity *new,
+				      void *notify_data);
+#endif
+
 static void au0828_unregister_media_device(struct au0828_dev *dev)
 {
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (dev->media_dev &&
-		media_devnode_is_registered(&dev->media_dev->devnode)) {
-		/* clear enable_source, disable_source */
-		dev->media_dev->source_priv = NULL;
-		dev->media_dev->enable_source = NULL;
-		dev->media_dev->disable_source = NULL;
-
-		media_device_unregister(dev->media_dev);
-		media_device_cleanup(dev->media_dev);
-		kfree(dev->media_dev);
-		dev->media_dev = NULL;
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity_notify *notify, *nextp;
+
+	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
+		return;
+
+	/* Remove au0828 entity_notify callbacks */
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list) {
+		if (notify->notify != au0828_media_graph_notify)
+			continue;
+			media_device_unregister_entity_notify(mdev, notify);
 	}
+
+	/* clear enable_source, disable_source */
+	dev->media_dev->source_priv = NULL;
+	dev->media_dev->enable_source = NULL;
+	dev->media_dev->disable_source = NULL;
+
+	media_device_unregister_put(dev->media_dev);
+	media_device_put(dev->media_dev->dev);
+	dev->media_dev = NULL;
 #endif
 }
 
@@ -198,7 +212,7 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = media_device_get(&udev->dev);
 	if (!mdev)
 		return -ENOMEM;
 
@@ -473,11 +487,13 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
 		if (ret) {
+			media_device_put(dev->media_dev->dev);
 			dev_err(&udev->dev,
 				"Media Device Register Error: %d\n", ret);
 			return ret;
 		}
 	} else {
+		media_device_register_ref(dev->media_dev);
 		/*
 		 * Call au0828_media_graph_notify() to connect
 		 * audio graph to our graph. In this case, audio
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 87f3284..3edd50f 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -35,6 +35,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/media-device.h>
+#include <media/media-dev-allocator.h>
 
 /* DVB */
 #include "demux.h"
-- 
2.5.0

