Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:9372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752557AbcJEHXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:23:19 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id C16A620C37
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:23:16 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 2/5] v4l: async: Match fwnode instead of of_node
Date: Wed,  5 Oct 2016 10:21:46 +0300
Message-Id: <1475652109-22164-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Match more generic fwnode instead of OF specific of_node. This will allows
ACPI support.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 12 ++++++++++++
 include/media/v4l2-async.h           |  5 +++++
 include/media/v4l2-subdev.h          |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada20..0dd5e85 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -45,6 +45,11 @@ static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 	return sd->of_node == asd->match.of.node;
 }
 
+static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
+{
+	return sd->fwnode == asd->match.fwnode.fwn;
+}
+
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 	if (!asd->match.custom.match)
@@ -79,6 +84,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 		case V4L2_ASYNC_MATCH_OF:
 			match = match_of;
 			break;
+		case V4L2_ASYNC_MATCH_FWNODE:
+			match = match_fwnode;
+			break;
 		default:
 			/* Cannot happen, unless someone breaks us */
 			WARN_ON(true);
@@ -156,6 +164,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		case V4L2_ASYNC_MATCH_DEVNAME:
 		case V4L2_ASYNC_MATCH_I2C:
 		case V4L2_ASYNC_MATCH_OF:
+		case V4L2_ASYNC_MATCH_FWNODE:
 			break;
 		default:
 			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
@@ -280,6 +289,9 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	 */
 	if (!sd->of_node && sd->dev)
 		sd->of_node = sd->dev->of_node;
+	if (!sd->fwnode && sd->dev)
+		sd->fwnode = sd->dev->of_node ?
+			&sd->dev->of_node->fwnode : sd->dev->fwnode;
 
 	mutex_lock(&list_lock);
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 8e2a236..d6768ab 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -32,6 +32,7 @@ struct v4l2_async_notifier;
  * @V4L2_ASYNC_MATCH_DEVNAME: Match will use the device name
  * @V4L2_ASYNC_MATCH_I2C: Match will check for I2C adapter ID and address
  * @V4L2_ASYNC_MATCH_OF: Match will use OF node
+ * @V4L2_ASYNC_MATCH_FWNODE: Match will use firmware node
  *
  * This enum is used by the asyncrhronous sub-device logic to define the
  * algorithm that will be used to match an asynchronous device.
@@ -41,6 +42,7 @@ enum v4l2_async_match_type {
 	V4L2_ASYNC_MATCH_DEVNAME,
 	V4L2_ASYNC_MATCH_I2C,
 	V4L2_ASYNC_MATCH_OF,
+	V4L2_ASYNC_MATCH_FWNODE,
 };
 
 /**
@@ -58,6 +60,9 @@ struct v4l2_async_subdev {
 			const struct device_node *node;
 		} of;
 		struct {
+			const struct fwnode_handle *fwn;
+		} fwnode;
+		struct {
 			const char *name;
 		} device_name;
 		struct {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..bb8ef1d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -788,6 +788,8 @@ struct v4l2_subdev_platform_data {
  * @devnode: subdev device node
  * @dev: pointer to the physical device, if any
  * @of_node: The device_node of the subdev, usually the same as dev->of_node.
+ * @fwnode: The fwnode_handle of the subdev, usually the same as
+ *	    either dev->of_node->fwnode or dev->fwnode (whichever is non-NULL).
  * @async_list: Links this subdev to a global subdev_list or @notifier->done
  *	list.
  * @asd: Pointer to respective &struct v4l2_async_subdev.
@@ -819,6 +821,7 @@ struct v4l2_subdev {
 	struct video_device *devnode;
 	struct device *dev;
 	struct device_node *of_node;
+	struct fwnode_handle *fwnode;
 	struct list_head async_list;
 	struct v4l2_async_subdev *asd;
 	struct v4l2_async_notifier *notifier;
-- 
2.7.4

