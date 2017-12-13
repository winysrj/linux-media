Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:47633 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbdLMS0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 13:26:36 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: sakari.ailus@linux.intel.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/5] include: v4l2_async: Add 'owner' field to notifier
Date: Wed, 13 Dec 2017 19:26:18 +0100
Message-Id: <1513189580-32202-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Notifiers can be registered as root notifiers (identified by a 'struct
v4l2_device *') or subdevice notifiers (identified by a 'struct
v4l2_subdev *'). In order to identify a notifier no matter if it is root
or not, add a 'struct fwnode_handle *owner' field, whose name can be
printed out for debug purposes.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 2 ++
 include/media/v4l2-async.h           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a6bddff..0a1bf1d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -447,6 +447,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		return -EINVAL;
 
 	notifier->v4l2_dev = v4l2_dev;
+	notifier->owner = dev_fwnode(v4l2_dev->dev);
 
 	ret = __v4l2_async_notifier_register(notifier);
 	if (ret)
@@ -465,6 +466,7 @@ int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	notifier->sd = sd;
+	notifier->owner = dev_fwnode(sd->dev);
 
 	ret = __v4l2_async_notifier_register(notifier);
 	if (ret)
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 6152434..a15c01d 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -106,6 +106,7 @@ struct v4l2_async_notifier_operations {
  * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
  * @sd:		sub-device that registered the notifier, NULL otherwise
  * @parent:	parent notifier
+ * @owner:	reference to notifier fwnode_handle, mostly useful for debug
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
@@ -118,6 +119,7 @@ struct v4l2_async_notifier {
 	struct v4l2_device *v4l2_dev;
 	struct v4l2_subdev *sd;
 	struct v4l2_async_notifier *parent;
+	struct fwnode_handle *owner;
 	struct list_head waiting;
 	struct list_head done;
 	struct list_head list;
-- 
2.7.4
