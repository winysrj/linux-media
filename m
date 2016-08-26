Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54130 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754711AbcHZXoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 14/21] media device: Get the media device driver's device
Date: Sat, 27 Aug 2016 02:43:22 +0300
Message-Id: <1472255009-28719-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct device of the media device driver (i.e. not that of the media
devnode) is pointed to by the media device. The struct device pointer is
mostly used for debug prints.

Ensure it will stay around as long as the media device does.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d534011..8c08839 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -726,6 +726,7 @@ static void media_device_release(struct media_devnode *devnode)
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+	put_device(mdev->dev);
 
 	kfree(mdev);
 }
@@ -734,9 +735,15 @@ struct media_device *media_device_alloc(struct device *dev)
 {
 	struct media_device *mdev;
 
+	dev = get_device(dev);
+	if (!dev)
+		return NULL;
+
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-	if (!mdev)
+	if (!mdev) {
+		put_device(dev);
 		return NULL;
+	}
 
 	mdev->dev = dev;
 	media_device_init(mdev);
-- 
2.1.4

