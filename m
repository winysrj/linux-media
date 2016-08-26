Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54118 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754714AbcHZXor (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 16/21] media: Add release callback for media device
Date: Sat, 27 Aug 2016 02:43:24 +0300
Message-Id: <1472255009-28719-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The release callback may be used by the driver to signal the release of
the media device. This way the lifetime of the driver's own memory
allocations may be made dependent on that of the media device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 4 ++++
 include/media/media-device.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5698823..82ae07a 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -726,6 +726,10 @@ static void media_device_release(struct media_devnode *devnode)
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+
+	if (mdev->release)
+		mdev->release(mdev);
+
 	put_device(mdev->dev);
 
 	kfree(mdev);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 9728d8a..310640a 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -152,6 +152,7 @@ struct media_device {
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	void (*release)(struct media_device *mdev);
 };
 
 /* We don't need to include pci.h or usb.h here */
-- 
2.1.4

