Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:41967 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934678AbcCQWqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 18:46:40 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, tiwai@suse.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix media_device_unregister() to destroy media device device resource
Date: Thu, 17 Mar 2016 16:46:36 -0600
Message-Id: <1458254796-7727-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When all drivers except usb-core driver is unbound, destroy the media device
resource. Other wise, media device resource will persist in a defunct state.
This leads to use-after-free and bad access errors during a subsequent bind.
Fix it to destroy the media device resource when last reference is released
in media_device_unregister().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 070421e..7312612 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -822,22 +822,38 @@ printk("%s: mdev=%p\n", __func__, mdev);
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
 
+static void media_device_release_devres(struct device *dev, void *res)
+{
+}
+
+static void media_device_destroy_devres(struct device *dev)
+{
+	int ret;
+
+	ret = devres_destroy(dev, media_device_release_devres, NULL, NULL);
+	pr_debug("%s: devres_destroy() returned %d\n", __func__, ret);
+}
+
 void media_device_unregister(struct media_device *mdev)
 {
+	int ret;
+	struct device *dev;
 printk("%s: mdev=%p\n", __func__, mdev);
 	if (mdev == NULL)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
-	kref_put(&mdev->kref, do_media_device_unregister);
-	mutex_unlock(&mdev->graph_mutex);
+	ret = kref_put_mutex(&mdev->kref, do_media_device_unregister,
+			     &mdev->graph_mutex);
+	if (ret) {
+		/* do_media_device_unregister() has run */
+		dev = mdev->dev;
+		mutex_unlock(&mdev->graph_mutex);
+		media_device_destroy_devres(dev);
+	}
 
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
-static void media_device_release_devres(struct device *dev, void *res)
-{
-}
 
 struct media_device *media_device_get_devres(struct device *dev)
 {
-- 
2.5.0

