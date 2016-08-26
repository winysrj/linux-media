Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54118 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754594AbcHZXop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 07/21] media-device: Make devnode.dev->kobj parent of devnode.cdev
Date: Sat, 27 Aug 2016 02:43:15 +0300
Message-Id: <1472255009-28719-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct cdev embedded in struct media_devnode contains its own kobj.
Instead of trying to manage its lifetime separately from struct
media_devnode, make the cdev kobj a parent of the struct media_device.dev
kobj.

The cdev will thus be released during unregistering the media_devnode, not
in media_devnode.dev kobj's release callback.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-devnode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7481c96..a8302fc 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -63,9 +63,6 @@ static void media_devnode_release(struct device *cd)
 
 	mutex_lock(&media_devnode_lock);
 
-	/* Delete the cdev on this minor as well */
-	cdev_del(&devnode->cdev);
-
 	/* Mark device node number as free */
 	clear_bit(devnode->minor, media_devnode_nums);
 
@@ -241,6 +238,7 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
 
 	/* Part 2: Initialize and register the character device */
 	cdev_init(&devnode->cdev, &media_devnode_fops);
+	devnode->cdev.kobj.parent = &devnode->dev.kobj;
 	devnode->cdev.owner = owner;
 
 	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
@@ -285,6 +283,7 @@ void media_devnode_unregister(struct media_devnode *devnode)
 	mutex_lock(&media_devnode_lock);
 	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
 	mutex_unlock(&media_devnode_lock);
+	cdev_del(&devnode->cdev);
 	device_unregister(&devnode->dev);
 }
 
-- 
2.1.4

