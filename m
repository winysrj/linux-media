Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40324 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751388AbdJDVu7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 18/32] v4l: async: Allow binding notifiers to sub-devices
Date: Thu,  5 Oct 2017 00:50:37 +0300
Message-Id: <20171004215051.13385-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
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

The complete callbacks will be called only when the v4l2_device is
available and no notifier has pending sub-devices to bind.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 239 ++++++++++++++++++++++++++++-------
 include/media/v4l2-async.h           |  16 ++-
 2 files changed, 211 insertions(+), 44 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 1812310746d9..3621ed6e6e3c 100644
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
@@ -149,17 +247,36 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
-	return 0;
+	/*
+	 * See if the sub-device has a notifier. If not, return here.
+	 */
+	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
+	if (!subdev_notifier || subdev_notifier->parent)
+		return 0;
+
+	/*
+	 * Proceed with checking for the sub-device notifier's async
+	 * sub-devices, and return the result. The error will be handled by the
+	 * caller.
+	 */
+	subdev_notifier->parent = notifier;
+
+	return v4l2_async_notifier_try_all_subdevs(subdev_notifier);
 }
 
 /* Test all async sub-devices in a notifier for a match. */
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
 
@@ -168,10 +285,16 @@ static int v4l2_async_notifier_try_all_subdevs(
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
@@ -185,17 +308,26 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	sd->asd = NULL;
 }
 
+/* Unbind all sub-devices in the notifier tree. */
 static void v4l2_async_notifier_unbind_all_subdevs(
 	struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_subdev *sd, *tmp;
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		struct v4l2_async_notifier *subdev_notifier =
+			v4l2_async_find_subdev_notifier(sd);
+
+		if (subdev_notifier)
+			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
+
 		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 		v4l2_async_cleanup(sd);
 
 		list_move(&sd->async_list, &subdev_list);
 	}
+
+	notifier->parent = NULL;
 }
 
 static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
@@ -210,15 +342,6 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
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
 
@@ -240,16 +363,12 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	mutex_lock(&list_lock);
 
 	ret = v4l2_async_notifier_try_all_subdevs(notifier);
-	if (ret) {
-		mutex_unlock(&list_lock);
-		return ret;
-	}
+	if (ret)
+		goto err_unbind;
 
-	if (list_empty(&notifier->waiting)) {
-		ret = v4l2_async_notifier_call_complete(notifier);
-		if (ret)
-			goto err_complete;
-	}
+	ret = v4l2_async_notifier_try_complete(notifier);
+	if (ret)
+		goto err_unbind;
 
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
@@ -258,7 +377,10 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 
 	return 0;
 
-err_complete:
+err_unbind:
+	/*
+	 * On failure, unbind all sub-devices registered through this notifier.
+	 */
 	v4l2_async_notifier_unbind_all_subdevs(notifier);
 
 	mutex_unlock(&list_lock);
@@ -270,7 +392,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
 	int ret;
-	if (WARN_ON(!v4l2_dev))
+
+	if (WARN_ON(!v4l2_dev || notifier->sd))
 		return -EINVAL;
 
 	notifier->v4l2_dev = v4l2_dev;
@@ -283,20 +406,39 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
+int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
+					struct v4l2_async_notifier *notifier)
+{
+	int ret;
+
+	if (WARN_ON(!sd || notifier->v4l2_dev))
+		return -EINVAL;
+
+	notifier->sd = sd;
+
+	ret = __v4l2_async_notifier_register(notifier);
+	if (ret)
+		notifier->sd = NULL;
+
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
+
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
-	if (!notifier->v4l2_dev)
+	if (!notifier->v4l2_dev && !notifier->sd)
 		return;
 
 	mutex_lock(&list_lock);
 
-	list_del(&notifier->list);
-
 	v4l2_async_notifier_unbind_all_subdevs(notifier);
 
-	mutex_unlock(&list_lock);
-
+	notifier->sd = NULL;
 	notifier->v4l2_dev = NULL;
+
+	list_del(&notifier->list);
+
+	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
@@ -332,6 +474,7 @@ EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
 
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
+	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
 	int ret;
 
@@ -348,24 +491,26 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	INIT_LIST_HEAD(&sd->async_list);
 
 	list_for_each_entry(notifier, &notifier_list, list) {
-		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
-								      sd);
+		struct v4l2_device *v4l2_dev =
+			v4l2_async_notifier_find_v4l2_dev(notifier);
+		struct v4l2_async_subdev *asd;
 		int ret;
 
+		if (!v4l2_dev)
+			continue;
+
+		asd = v4l2_async_find_match(notifier, sd);
 		if (!asd)
 			continue;
 
 		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
 					      asd);
 		if (ret)
-			goto err_unlock;
+			goto err_unbind;
 
-		if (!list_empty(&notifier->waiting))
-			goto out_unlock;
-
-		ret = v4l2_async_notifier_call_complete(notifier);
+		ret = v4l2_async_notifier_try_complete(notifier);
 		if (ret)
-			goto err_cleanup;
+			goto err_unbind;
 
 		goto out_unlock;
 	}
@@ -378,11 +523,19 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 
 	return 0;
 
-err_cleanup:
-	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
+err_unbind:
+	/*
+	 * Complete failed. Unbind the sub-devices bound through registering
+	 * this async sub-device.
+	 */
+	subdev_notifier = v4l2_async_find_subdev_notifier(sd);
+	if (subdev_notifier)
+		v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
+
+	if (sd->asd)
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 	v4l2_async_cleanup(sd);
 
-err_unlock:
 	mutex_unlock(&list_lock);
 
 	return ret;
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 68606afb5ef9..d33a52be2501 100644
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
