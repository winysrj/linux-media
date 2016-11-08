Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752346AbcKHNzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:37 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 16/21] media: Add release callback for media device
Date: Tue,  8 Nov 2016 15:55:25 +0200
Message-Id: <1478613330-24691-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 7d9f76d..e9dfc87 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -724,6 +724,10 @@ static void media_device_release(struct media_devnode *devnode)
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
+
+	if (mdev->ops && mdev->ops->release)
+		mdev->ops->release(mdev);
+
 	put_device(mdev->dev);
 
 	kfree(mdev);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 94e96ef..81f09ed 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -56,6 +56,7 @@ struct media_entity_notify {
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+	void (*release)(struct media_device *mdev);
 };
 
 /**
-- 
2.1.4

