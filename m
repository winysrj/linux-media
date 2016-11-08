Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751100AbcKHNzf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 06/21] media device: Drop nop release callback
Date: Tue,  8 Nov 2016 15:55:15 +0200
Message-Id: <1478613330-24691-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The release callback is only used to print a debug message. Drop it. (It
will be re-introduced later in a different form.)

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a9d543f..a31329d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -540,11 +540,6 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
  * Registration/unregistration
  */
 
-static void media_device_release(struct media_devnode *devnode)
-{
-	dev_dbg(devnode->parent, "Media device released\n");
-}
-
 /**
  * media_device_register_entity - Register an entity with a media device
  * @mdev:	The media device
@@ -706,7 +701,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
-	mdev->devnode.release = media_device_release;
 
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
-- 
2.1.4

