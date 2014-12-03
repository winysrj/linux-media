Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26767 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaLCQIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 11:08:32 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v9 12/19] v4l2-async: add V4L2_ASYNC_MATCH_CUSTOM_OF
 matching type
Date: Wed, 03 Dec 2014 17:06:47 +0100
Message-id: <1417622814-10845-13-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are cases where a v4l2 sub-device is not related to the
main Device Tree node of a device, but to its child node.
Add v4l2_async_get_of_node_by_subdev function to facilitate
associating a sub-device with different Device Tree node
than the one from the related struct device. Added is also
V4L2_ASYNC_MATCH_CUSTOM_OF matching type to declare this
type of matching.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c |  106 ++++++++++++++++++++++++++++++----
 include/media/v4l2-async.h           |    4 ++
 2 files changed, 98 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 8140992..faa16484 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -22,6 +22,17 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
+static LIST_HEAD(subdev_list);
+static LIST_HEAD(notifier_list);
+static LIST_HEAD(custom_of_list);
+static DEFINE_MUTEX(list_lock);
+
+struct v4l2_subdev_to_of_node {
+	struct v4l2_subdev *sd;
+	struct device_node *node;
+	struct list_head list;
+};
+
 static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 #if IS_ENABLED(CONFIG_I2C)
@@ -44,9 +55,17 @@ static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 	return sd->dev->of_node == asd->match.of.node;
 }
 
-static LIST_HEAD(subdev_list);
-static LIST_HEAD(notifier_list);
-static DEFINE_MUTEX(list_lock);
+static bool match_custom_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
+{
+	struct v4l2_subdev_to_of_node *sd_to_of;
+
+	list_for_each_entry(sd_to_of, &custom_of_list, list)
+		if ((sd_to_of->sd == sd) &&
+		    (sd_to_of->node == asd->match.of.node))
+			return true;
+
+	return false;
+}
 
 static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
 						    struct v4l2_subdev *sd)
@@ -72,6 +91,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 		case V4L2_ASYNC_MATCH_OF:
 			match = match_of;
 			break;
+		case V4L2_ASYNC_MATCH_CUSTOM_OF:
+			match = match_custom_of;
+			break;
 		default:
 			/* Cannot happen, unless someone breaks us */
 			WARN_ON(true);
@@ -120,9 +142,19 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 {
+	struct v4l2_subdev_to_of_node *sd_to_of, *tmp;
+
 	v4l2_device_unregister_subdev(sd);
 	/* Subdevice driver will reprobe and put the subdev back onto the list */
 	list_del_init(&sd->async_list);
+
+	list_for_each_entry_safe(sd_to_of, tmp, &custom_of_list, list) {
+		if (sd_to_of->sd == sd) {
+			list_del(&sd_to_of->list);
+			kfree (sd_to_of);
+		}
+	}
+
 	sd->asd = NULL;
 	sd->dev = NULL;
 }
@@ -149,6 +181,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		case V4L2_ASYNC_MATCH_DEVNAME:
 		case V4L2_ASYNC_MATCH_I2C:
 		case V4L2_ASYNC_MATCH_OF:
+		case V4L2_ASYNC_MATCH_CUSTOM_OF:
 			break;
 		default:
 			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
@@ -262,32 +295,65 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 }
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
-int v4l2_async_register_subdev(struct v4l2_subdev *sd)
+static int __v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *notifier;
 
-	mutex_lock(&list_lock);
-
 	INIT_LIST_HEAD(&sd->async_list);
 
 	list_for_each_entry(notifier, &notifier_list, list) {
 		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
-		if (asd) {
-			int ret = v4l2_async_test_notify(notifier, sd, asd);
-			mutex_unlock(&list_lock);
-			return ret;
-		}
+		if (asd)
+			return v4l2_async_test_notify(notifier, sd, asd);
 	}
 
 	/* None matched, wait for hot-plugging */
 	list_add(&sd->async_list, &subdev_list);
 
+	return 0;
+}
+
+int v4l2_async_register_subdev(struct v4l2_subdev *sd)
+{
+	int ret;
+
+	mutex_lock(&list_lock);
+
+	ret = __v4l2_async_register_subdev(sd);
+
 	mutex_unlock(&list_lock);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_register_subdev);
 
+int v4l2_async_register_subdev_with_of(struct v4l2_subdev *sd,
+				       struct device_node *of_node)
+{
+	int ret;
+	struct v4l2_subdev_to_of_node *sd_to_of;
+
+	sd_to_of = kmalloc(sizeof(*sd_to_of), GFP_KERNEL);
+	if (!sd_to_of)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&sd_to_of->list);
+
+	sd_to_of->sd = sd;
+	sd_to_of->node = of_node;
+
+	mutex_lock(&list_lock);
+
+	list_add(&sd_to_of->list, &custom_of_list);
+
+	ret = __v4l2_async_register_subdev(sd);
+
+	mutex_unlock(&list_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_async_register_subdev_with_of);
+
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *notifier = sd->notifier;
@@ -310,3 +376,19 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_unregister_subdev);
+
+/* caller must ensure list_lock held */
+struct device_node *v4l2_async_get_of_node_by_subdev(struct v4l2_subdev *sd)
+{
+	struct v4l2_subdev_to_of_node *sd_to_of;
+
+	lockdep_assert_held(&list_lock);
+
+	list_for_each_entry(sd_to_of, &custom_of_list, list) {
+		if (sd_to_of->sd == sd)
+			return sd_to_of->node;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(v4l2_async_get_of_node_by_subdev);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 1c0b586..10fce8e 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -28,6 +28,7 @@ enum v4l2_async_match_type {
 	V4L2_ASYNC_MATCH_DEVNAME,
 	V4L2_ASYNC_MATCH_I2C,
 	V4L2_ASYNC_MATCH_OF,
+	V4L2_ASYNC_MATCH_CUSTOM_OF,
 };
 
 /**
@@ -93,5 +94,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier);
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
 int v4l2_async_register_subdev(struct v4l2_subdev *sd);
+int v4l2_async_register_subdev_with_of(struct v4l2_subdev *sd,
+				       struct device_node *of_node);
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
+struct device_node *v4l2_async_get_of_node_by_subdev(struct v4l2_subdev *sd);
 #endif
-- 
1.7.9.5

