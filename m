Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49140 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754324AbcJNRez (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:34:55 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 02/21] [media] v4l2-async: allow subdevices to add further subdevices to the notifier waiting list
Date: Fri, 14 Oct 2016 19:34:22 +0200
Message-Id: <1476466481-24030-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the v4l2_async_notifier needs to be given a list of matches
for all expected subdevices on creation. When chaining subdevices that
are asynchronously probed via device tree, the bridge device that sets
up the notifier does not know the complete list of subdevices, as it
can only parse its own device tree node to obtain information about
the nearest neighbor subdevices.
To support indirectly connected subdevices, we need to support amending
the existing notifier waiting list with newly found neighbor subdevices
with each registered subdevice.

This can be achieved by adding new v42l_async_subdev matches to the
notifier waiting list during the v4l2_subdev registered callback, which
is called under the list lock from either v4l2_async_register_subdev or
v4l2_async_notifier_register. For this purpose a new exported function
__v4l2_async_notifier_add_subdev is added.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Don't add more async subdevs than V4L2_MAX_SUBDEVS.
 - Fix v4l2_async_unregister, allocate a correctly sized device
   cache without modifying notifier->num_subdevs.
---
 drivers/media/v4l2-core/v4l2-async.c | 84 +++++++++++++++++++++++++++++++++---
 include/media/v4l2-async.h           | 12 ++++++
 2 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 1113df4..3ce6533 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -109,6 +109,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 		if (ret < 0)
 			return ret;
 	}
+
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
@@ -158,7 +159,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_async_subdev *asd;
-	int ret;
+	struct list_head *tail;
 	int i;
 
 	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
@@ -191,33 +192,91 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
-	ret = v4l2_async_test_notify_all(notifier);
+	do {
+		int ret;
+
+		tail = notifier->waiting.prev;
+
+		ret = v4l2_async_test_notify_all(notifier);
+		if (ret < 0) {
+			mutex_unlock(&list_lock);
+			return ret;
+		}
+
+		/*
+		 * If entries were added to the notifier waiting list, check
+		 * again if the corresponding subdevices are already available.
+		 */
+	} while (tail != notifier->waiting.prev);
 
 	mutex_unlock(&list_lock);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
+int __v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
+				     struct v4l2_async_subdev *asd)
+{
+	struct v4l2_async_subdev *tmp_asd;
+
+	lockdep_assert_held(&list_lock);
+
+	if (notifier->num_subdevs >= V4L2_MAX_SUBDEVS)
+		return -EINVAL;
+
+	if (asd->match_type != V4L2_ASYNC_MATCH_OF)
+		return -EINVAL;
+
+	/*
+	 * First check if the same notifier is already on the waiting or done
+	 * lists. This can happen if a subdevice with multiple outputs is added
+	 * by all its downstream subdevices.
+	 */
+	list_for_each_entry(tmp_asd, &notifier->waiting, list)
+		if (tmp_asd->match.of.node == asd->match.of.node)
+			return 0;
+	list_for_each_entry(tmp_asd, &notifier->done, list)
+		if (tmp_asd->match.of.node == asd->match.of.node)
+			return 0;
+
+	/*
+	 * Add the new async subdev to the notifier waiting list, so
+	 * v4l2_async_belongs may use it to compare against entries in
+	 * subdev_list.
+	 * In case the subdev matching asd has already been passed in the
+	 * subdev_list walk in v4l2_async_notifier_register, or if
+	 * we are called from v4l2_async_register_subdev, the subdev_list
+	 * will have to be walked again.
+	 */
+	list_add_tail(&asd->list, &notifier->waiting);
+
+	return 0;
+}
+
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_subdev *sd, *tmp;
-	unsigned int notif_n_subdev = notifier->num_subdevs;
-	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
+	unsigned int notif_n_subdev = 0;
+	unsigned int n_subdev;
 	struct device **dev;
 	int i = 0;
 
 	if (!notifier->v4l2_dev)
 		return;
 
+	mutex_lock(&list_lock);
+
+	list_for_each_entry(sd, &notifier->done, async_list)
+		notif_n_subdev++;
+	n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
+
 	dev = kmalloc(n_subdev * sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(notifier->v4l2_dev->dev,
 			"Failed to allocate device cache!\n");
 	}
 
-	mutex_lock(&list_lock);
-
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
@@ -296,8 +355,19 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	list_for_each_entry(notifier, &notifier_list, list) {
 		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
 		if (asd) {
+			struct list_head *tail = notifier->waiting.prev;
 			int ret = v4l2_async_test_notify(notifier, sd, asd);
+
+			/*
+			 * If entries were added to the notifier waiting list,
+			 * check if the corresponding subdevices are already
+			 * available.
+			 */
+			if (tail != notifier->waiting.prev)
+				ret = v4l2_async_test_notify_all(notifier);
+
 			mutex_unlock(&list_lock);
+
 			return ret;
 		}
 	}
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 8e2a236..e4e4b11 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -114,6 +114,18 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier);
 
 /**
+ * __v4l2_async_notifier_add_subdev - adds a subdevice to the notifier waitlist
+ *
+ * @notifier: notifier the calling subdev is bound to
+ * @asd: asynchronous subdev match
+ *
+ * To be called from inside a subdevices' registered_async callback to add
+ * additional subdevices to the notifier waiting list.
+ */
+int __v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
+				     struct v4l2_async_subdev *asd);
+
+/**
  * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
  *
  * @notifier: pointer to &struct v4l2_async_notifier
-- 
2.9.3

