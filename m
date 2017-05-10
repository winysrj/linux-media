Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753564AbdEJQqC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 12:46:02 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] v4l2-subdev: Remove of_node
Date: Wed, 10 May 2017 17:45:54 +0100
Message-Id: <1494434754-32144-1-git-send-email-kbingham@kernel.org>
In-Reply-To: <1491829376-14791-8-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-8-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

With the fwnode implementation, of_node is no longer used.

Remove it.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 include/media/v4l2-subdev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5f1669c45642..a40760174797 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -787,7 +787,6 @@ struct v4l2_subdev_platform_data {
  *	is attached.
  * @devnode: subdev device node
  * @dev: pointer to the physical device, if any
- * @of_node: The device_node of the subdev, usually the same as dev->of_node.
  * @fwnode: The fwnode_handle of the subdev, usually the same as
  *	    either dev->of_node->fwnode or dev->fwnode (whichever is non-NULL).
  * @async_list: Links this subdev to a global subdev_list or @notifier->done
@@ -820,7 +819,6 @@ struct v4l2_subdev {
 	void *host_priv;
 	struct video_device *devnode;
 	struct device *dev;
-	struct device_node *of_node;
 	struct fwnode_handle *fwnode;
 	struct list_head async_list;
 	struct v4l2_async_subdev *asd;
-- 
2.7.4
