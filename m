Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35302 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752104AbcKHNzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:36 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 12/21] media device: Initialise media devnode in media_device_init()
Date: Tue,  8 Nov 2016 15:55:21 +0200
Message-Id: <1478613330-24691-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call media_devnode_init() from media_device_init(). This has the effect of
creating a struct device for the media_devnode before it is registered,
making it possible to obtain a reference to it for e.g. video devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e9f6e76..2e52e44 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -708,6 +708,8 @@ void media_device_init(struct media_device *mdev)
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
+	media_devnode_init(&mdev->devnode);
+
 	dev_dbg(mdev->dev, "Media device initialized\n");
 }
 EXPORT_SYMBOL_GPL(media_device_init);
@@ -718,7 +720,10 @@ static void media_device_release(struct media_devnode *devnode)
 
 	dev_dbg(devnode->parent, "Media device released\n");
 
-	media_device_cleanup(mdev);
+	ida_destroy(&mdev->entity_internal_idx);
+	mdev->entity_internal_idx_max = 0;
+	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+	mutex_destroy(&mdev->graph_mutex);
 
 	kfree(mdev);
 }
@@ -746,6 +751,7 @@ void media_device_cleanup(struct media_device *mdev)
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+	media_device_put(mdev);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
 
@@ -761,26 +767,19 @@ int __must_check __media_device_register(struct media_device *mdev,
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
 
-	media_devnode_init(&mdev->devnode);
-
 	ret = media_devnode_register(&mdev->devnode, owner);
 	if (ret < 0)
-		goto out_put;
+		return ret;
 
 	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
-	if (ret < 0)
-		goto out_unregister;
+	if (ret < 0) {
+		media_devnode_unregister(&mdev->devnode);
+		return ret;
+	}
 
 	dev_dbg(mdev->dev, "Media device registered\n");
 
 	return 0;
-
-out_unregister:
-	media_devnode_unregister(&mdev->devnode);
-out_put:
-	put_device(&mdev->devnode.dev);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
@@ -823,7 +822,6 @@ void media_device_unregister(struct media_device *mdev)
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	dev_dbg(mdev->dev, "Media device unregistering\n");
 	media_devnode_unregister(&mdev->devnode);
-	put_device(&mdev->devnode.dev);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
-- 
2.1.4

