Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49486 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935640AbdIYWZy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 18:25:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v14 15/28] v4l: async: Allow binding notifiers to sub-devices
Date: Tue, 26 Sep 2017 01:25:26 +0300
Message-Id: <20170925222540.371-16-sakari.ailus@linux.intel.com>
In-Reply-To: <20170925222540.371-1-sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Registering a notifier has required the knowledge of struct v4l2_device
for the reason that sub-devices generally are registered to the
v4l2_device (as well as the media device, also available through
v4l2_device).

This information is not available for sub-device drivers at probe time.

What this patch does is that it allows registering notifiers without
having v4l2_device around. Instead the sub-device pointer is stored in the
notifier. Once the sub-device of the driver that registered the notifier
is registered, the notifier will gain the knowledge of the v4l2_device,
and the binding of async sub-devices from the sub-device driver's notifier
may proceed.

The root notifier's complete callback is only called when all sub-device
notifiers are completed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 218 +++++++++++++++++++++++++++++------
 include/media/v4l2-async.h           |  16 ++-
 2 files changed, 199 insertions(+), 35 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 1d4132305243..735f72f81740 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -124,11 +124,109 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
 	return NULL;
 }
 
+/* Find the sub-device notifier registered by a sub-device driver. */
+static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
+	struct v4l2_subdev *sd)
+{
+	struct v4l2_async_notifier *n;
+
+	list_for_each_entry(n, &notifier_list, list)
+		if (n->sd == sd)
+			return n;
+
+	return NULL;
+}
+
+/* Get v4l2_device related to the notifier if one can be found. */
+static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
+	struct v4l2_async_notifier *notifier)
+{
+	while (notifier->parent)
+		notifier = notifier->parent;
+
+	return notifier->v4l2_dev;
+}
+
+/*
+ * Return true if all child sub-device notifiers are complete, false otherwise.
+ */
+static bool v4l2_async_notifier_can_complete(
+	struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd;
+
+	if (!list_empty(&notifier->waiting))
+		return false;
+
+	list_for_each_entry(sd, &notifier->done, async_list) {
+		struct v4l2_async_notifier *subdev_notifier =
+			v4l2_async_find_subdev_notifier(sd);
+
+		if (subdev_notifier &&
+		    !v4l2_async_notifier_can_complete(subdev_notifier))
+			return false;
+	}
+
+	return true;
+}
+
+/* Complete all notifiers. Call on the root notifier. */
+static int v4l2_async_notifier_complete(
+	struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd;
+
+	list_for_each_entry(sd, &notifier->done, async_list) {
+		struct v4l2_async_notifier *subdev_notifier =
+			v4l2_async_find_subdev_notifier(sd);
+		int ret;
+
+		if (!subdev_notifier)
+			continue;
+
+		ret = v4l2_async_notifier_complete(subdev_notifier);
+		if (ret)
+			return ret;
+	}
+
+	return v4l2_async_notifier_call_complete(notifier);
+}
+
+/*
+ * Complete notifiers if possible. This is done when all async sub-devices have
+ * been bound; v4l2_device is also available then.
+ */
+static int v4l2_async_notifier_try_complete(
+	struct v4l2_async_notifier *notifier)
+{
+	/* Quick check whether there are still more sub-devices here. */
+	if (!list_empty(&notifier->waiting))
+		return 0;
+
+	/* Check the entire notifier tree; find the root notifier first. */
+	while (notifier->parent)
+		notifier = notifier->parent;
+
+	/* This is root if it has v4l2_dev. */
+	if (!notifier->v4l2_dev)
+		return 0;
+
+	/* Is everything ready? */
+	if (!v4l2_async_notifier_can_complete(notifier))
+		return 0;
+
+	return v4l2_async_notifier_complete(notifier);
+}
+
+static int v4l2_async_notifier_try_all_subdevs(
+	struct v4l2_async_notifier *notifier);
+
 static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 				   struct v4l2_device *v4l2_dev,
 				   struct v4l2_subdev *sd,
 				   struct v4l2_async_subdev *asd)
 {
+	struct v4l2_async_notifier *subdev_notifier;
 	int ret;
 
 	ret = v4l2_device_register_subdev(v4l2_dev, sd);
@@ -149,8 +247,17 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
-	if (list_empty(&notifier->waiting))
-		return v4l2_async_notifier_call_complete(notifier);
+	/*
+	 * See if the sub-device has a notifier. If it does, proceed
+	 * with checking for its async sub-devices.
+	 */
+	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
+	if (subdev_notifier && !subdev_notifier->parent) {
+		subdev_notifier->parent = notifier;
+		ret = v4l2_async_notifier_try_all_subdevs(subdev_notifier);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
@@ -159,10 +266,15 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 static int v4l2_async_notifier_try_all_subdevs(
 	struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
-	struct v4l2_subdev *sd, *tmp;
+	struct v4l2_device *v4l2_dev =
+		v4l2_async_notifier_find_v4l2_dev(notifier);
+	struct v4l2_subdev *sd;
 
-	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
+	if (!v4l2_dev)
+		return 0;
+
+again:
+	list_for_each_entry(sd, &subdev_list, async_list) {
 		struct v4l2_async_subdev *asd;
 		int ret;
 
@@ -171,10 +283,16 @@ static int v4l2_async_notifier_try_all_subdevs(
 			continue;
 
 		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
-		if (ret < 0) {
-			mutex_unlock(&list_lock);
+		if (ret < 0)
 			return ret;
-		}
+
+		/*
+		 * v4l2_async_match_notify() may lead to registering a
+		 * new notifier and thus changing the async subdevs
+		 * list. In order to proceed safely from here, restart
+		 * parsing the list from the beginning.
+		 */
+		goto again;
 	}
 
 	return 0;
@@ -201,15 +319,6 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
 
-	if (!notifier->num_subdevs) {
-		int ret;
-
-		ret = v4l2_async_notifier_call_complete(notifier);
-		notifier->v4l2_dev = NULL;
-
-		return ret;
-	}
-
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdevs[i];
 
@@ -236,18 +345,20 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
+	ret = v4l2_async_notifier_try_complete(notifier);
+
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
 	mutex_unlock(&list_lock);
 
-	return 0;
+	return ret;
 }
 
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
-	if (WARN_ON(!v4l2_dev))
+	if (WARN_ON(!v4l2_dev || notifier->sd))
 		return -EINVAL;
 
 	notifier->v4l2_dev = v4l2_dev;
@@ -256,18 +367,31 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
-void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
+					struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_subdev *sd, *tmp;
+	if (WARN_ON(!sd || notifier->v4l2_dev))
+		return -EINVAL;
 
-	if (!notifier->v4l2_dev)
-		return;
+	notifier->sd = sd;
 
-	mutex_lock(&list_lock);
+	return __v4l2_async_notifier_register(notifier);
+}
+EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
 
-	list_del(&notifier->list);
+/* Unbind all sub-devices in the notifier tree. */
+static void v4l2_async_notifier_unbind_all_subdevs(
+	struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd, *tmp;
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		struct v4l2_async_notifier *subdev_notifier =
+			v4l2_async_find_subdev_notifier(sd);
+
+		if (subdev_notifier)
+			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
+
 		v4l2_async_cleanup(sd);
 
 		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
@@ -275,9 +399,24 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		list_move(&sd->async_list, &subdev_list);
 	}
 
-	mutex_unlock(&list_lock);
+	notifier->parent = NULL;
+}
 
+void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+{
+	if (!notifier->v4l2_dev && !notifier->sd)
+		return;
+
+	mutex_lock(&list_lock);
+
+	v4l2_async_notifier_unbind_all_subdevs(notifier);
+
+	notifier->sd = NULL;
 	notifier->v4l2_dev = NULL;
+
+	list_del(&notifier->list);
+
+	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
@@ -327,14 +466,25 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	INIT_LIST_HEAD(&sd->async_list);
 
 	list_for_each_entry(notifier, &notifier_list, list) {
-		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
-								      sd);
-		if (asd) {
-			int ret = v4l2_async_match_notify(
-				notifier, notifier->v4l2_dev, sd, asd);
-			mutex_unlock(&list_lock);
-			return ret;
-		}
+		struct v4l2_device *v4l2_dev =
+			v4l2_async_notifier_find_v4l2_dev(notifier);
+		struct v4l2_async_subdev *asd;
+		int ret;
+
+		if (!v4l2_dev)
+			continue;
+
+		asd = v4l2_async_find_match(notifier, sd);
+		if (!asd)
+			continue;
+
+		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
+
+		if (!ret)
+			ret = v4l2_async_notifier_try_complete(notifier);
+
+		mutex_unlock(&list_lock);
+		return ret;
 	}
 
 	/* None matched, wait for hot-plugging */
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 7d56c355138b..0b30a631ad19 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -102,7 +102,9 @@ struct v4l2_async_notifier_operations {
  * @num_subdevs: number of subdevices used in the subdevs array
  * @max_subdevs: number of subdevices allocated in the subdevs array
  * @subdevs:	array of pointers to subdevice descriptors
- * @v4l2_dev:	pointer to struct v4l2_device
+ * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
+ * @sd:		sub-device that registered the notifier, NULL otherwise
+ * @parent:	parent notifier
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
@@ -113,6 +115,8 @@ struct v4l2_async_notifier {
 	unsigned int max_subdevs;
 	struct v4l2_async_subdev **subdevs;
 	struct v4l2_device *v4l2_dev;
+	struct v4l2_subdev *sd;
+	struct v4l2_async_notifier *parent;
 	struct list_head waiting;
 	struct list_head done;
 	struct list_head list;
@@ -128,6 +132,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier);
 
 /**
+ * v4l2_async_subdev_notifier_register - registers a subdevice asynchronous
+ *					 notifier for a sub-device
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @notifier: pointer to &struct v4l2_async_notifier
+ */
+int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
+					struct v4l2_async_notifier *notifier);
+
+/**
  * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous notifier
  *
  * @notifier: pointer to &struct v4l2_async_notifier
-- 
2.11.0
