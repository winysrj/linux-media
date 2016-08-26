Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54114 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754703AbcHZXop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 06/21] media device: Drop nop release callback
Date: Sat, 27 Aug 2016 02:43:14 +0300
Message-Id: <1472255009-28719-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The release callback is only used to print a debug message. Drop it. (It
will be re-introduced later in a different form.)

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a431775..d90d8c6 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -542,11 +542,6 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
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
@@ -708,7 +703,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
-	mdev->devnode.release = media_device_release;
 
 	/* Set version 0 to indicate user-space that the graph is static */
 	mdev->topology_version = 0;
-- 
2.1.4

