Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:60644 "EHLO
        resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752206AbcKPO3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 09:29:19 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v4 2/3] media: change au0828 to use Media Device Allocator API
Date: Wed, 16 Nov 2016 07:29:10 -0700
Message-Id: <fdd68ce1fc71dae7504e9e9acd2877dbf970e8c6.1479271294.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1479271294.git.shuahkh@osg.samsung.com>
References: <cover.1479271294.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1479271294.git.shuahkh@osg.samsung.com>
References: <cover.1479271294.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828 to use Media Device Allocator API to allocate media device
with the parent usb struct device as the key, so it can be shared with the
snd_usb_audio driver.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
Changes since v2:
- Updated media_device_delete() to pass in module name.

 drivers/media/usb/au0828/au0828-core.c | 12 ++++--------
 drivers/media/usb/au0828/au0828.h      |  1 +
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bf53553..582f31f 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -157,9 +157,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
 
-	media_device_unregister(dev->media_dev);
-	media_device_cleanup(dev->media_dev);
-	kfree(dev->media_dev);
+	media_device_delete(dev->media_dev, KBUILD_MODNAME);
 	dev->media_dev = NULL;
 #endif
 }
@@ -212,14 +210,10 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = media_device_usb_allocate(udev, KBUILD_MODNAME);
 	if (!mdev)
 		return -ENOMEM;
 
-	/* check if media device is already initialized */
-	if (!mdev->dev)
-		media_device_usb_init(mdev, udev, udev->product);
-
 	dev->media_dev = mdev;
 #endif
 	return 0;
@@ -487,6 +481,8 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
 		if (ret) {
+			media_device_delete(dev->media_dev, KBUILD_MODNAME);
+			dev->media_dev = NULL;
 			dev_err(&udev->dev,
 				"Media Device Register Error: %d\n", ret);
 			return ret;
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index dd7b378..4bf1b0c 100644
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
2.7.4

