Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40345 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933326AbeGIWkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:40:12 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 16/17] media: v4l2: async: Remove notifier subdevs array
Date: Mon,  9 Jul 2018 15:39:16 -0700
Message-Id: <1531175957-1973-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All platform drivers have been converted to use
v4l2_async_notifier_add_subdev(), in place of adding
asd's to the notifier subdevs array. So the subdevs
array can now be removed from struct v4l2_async_notifier,
and remove the backward compatibility support for that
array in v4l2-async.c.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v5:
- also remove notifier num_subdevs and V4L2_MAX_SUBDEVS macro.
  Suggested by Sakari Ailus.
---
 drivers/media/v4l2-core/v4l2-async.c | 114 ++++++++---------------------------
 include/media/v4l2-async.h           |  21 ++-----
 include/media/v4l2-fwnode.h          |  12 ----
 3 files changed, 30 insertions(+), 117 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 78cf1a9..9d8343e 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -358,31 +358,23 @@ static bool __v4l2_async_notifier_has_async_subdev(
 /*
  * Find out whether an async sub-device was set up already or
  * whether it exists in a given notifier before @this_index.
+ * If @this_index < 0, search the notifier's entire @asd_list.
  */
 static bool v4l2_async_notifier_has_async_subdev(
 	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd,
-	unsigned int this_index)
+	int this_index)
 {
 	struct v4l2_async_subdev *asd_y;
-	unsigned int j;
+	int j = 0;
 
 	lockdep_assert_held(&list_lock);
 
 	/* Check that an asd is not being added more than once. */
-	if (notifier->subdevs) {
-		for (j = 0; j < this_index; j++) {
-			asd_y = notifier->subdevs[j];
-			if (asd_equal(asd, asd_y))
-				return true;
-		}
-	} else {
-		j = 0;
-		list_for_each_entry(asd_y, &notifier->asd_list, asd_list) {
-			if (j++ >= this_index)
-				break;
-			if (asd_equal(asd, asd_y))
-				return true;
-		}
+	list_for_each_entry(asd_y, &notifier->asd_list, asd_list) {
+		if (this_index >= 0 && j++ >= this_index)
+			break;
+		if (asd_equal(asd, asd_y))
+			return true;
 	}
 
 	/* Check that an asd does not exist in other notifiers. */
@@ -395,7 +387,7 @@ static bool v4l2_async_notifier_has_async_subdev(
 
 static int v4l2_async_notifier_asd_valid(struct v4l2_async_notifier *notifier,
 					 struct v4l2_async_subdev *asd,
-					 unsigned int this_index)
+					 int this_index)
 {
 	struct device *dev =
 		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
@@ -434,36 +426,19 @@ EXPORT_SYMBOL(v4l2_async_notifier_init);
 static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_async_subdev *asd;
-	int ret;
-	int i;
-
-	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
-		return -EINVAL;
+	int ret, i = 0;
 
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
 
 	mutex_lock(&list_lock);
 
-	if (notifier->subdevs) {
-		for (i = 0; i < notifier->num_subdevs; i++) {
-			asd = notifier->subdevs[i];
-
-			ret = v4l2_async_notifier_asd_valid(notifier, asd, i);
-			if (ret)
-				goto err_unlock;
+	list_for_each_entry(asd, &notifier->asd_list, asd_list) {
+		ret = v4l2_async_notifier_asd_valid(notifier, asd, i++);
+		if (ret)
+			goto err_unlock;
 
-			list_add_tail(&asd->list, &notifier->waiting);
-		}
-	} else {
-		i = 0;
-		list_for_each_entry(asd, &notifier->asd_list, asd_list) {
-			ret = v4l2_async_notifier_asd_valid(notifier, asd, i++);
-			if (ret)
-				goto err_unlock;
-
-			list_add_tail(&asd->list, &notifier->waiting);
-		}
+		list_add_tail(&asd->list, &notifier->waiting);
 	}
 
 	ret = v4l2_async_notifier_try_all_subdevs(notifier);
@@ -556,45 +531,22 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 static void __v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_async_subdev *asd, *tmp;
-	unsigned int i;
 
 	if (!notifier)
 		return;
 
-	if (notifier->subdevs) {
-		for (i = 0; i < notifier->num_subdevs; i++) {
-			asd = notifier->subdevs[i];
-
-			switch (asd->match_type) {
-			case V4L2_ASYNC_MATCH_FWNODE:
-				fwnode_handle_put(asd->match.fwnode);
-				break;
-			default:
-				break;
-			}
-
-			kfree(asd);
+	list_for_each_entry_safe(asd, tmp, &notifier->asd_list, asd_list) {
+		switch (asd->match_type) {
+		case V4L2_ASYNC_MATCH_FWNODE:
+			fwnode_handle_put(asd->match.fwnode);
+			break;
+		default:
+			break;
 		}
 
-		kvfree(notifier->subdevs);
-		notifier->subdevs = NULL;
-	} else {
-		list_for_each_entry_safe(asd, tmp,
-					 &notifier->asd_list, asd_list) {
-			switch (asd->match_type) {
-			case V4L2_ASYNC_MATCH_FWNODE:
-				fwnode_handle_put(asd->match.fwnode);
-				break;
-			default:
-				break;
-			}
-
-			list_del(&asd->asd_list);
-			kfree(asd);
-		}
+		list_del(&asd->asd_list);
+		kfree(asd);
 	}
-
-	notifier->num_subdevs = 0;
 }
 
 void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
@@ -614,27 +566,11 @@ int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
 
 	mutex_lock(&list_lock);
 
-	if (notifier->num_subdevs >= V4L2_MAX_SUBDEVS) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	/*
-	 * If caller uses this function, it cannot also allocate and
-	 * place asd's in the notifier->subdevs array.
-	 */
-	if (WARN_ON(notifier->subdevs)) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	ret = v4l2_async_notifier_asd_valid(notifier, asd,
-					    notifier->num_subdevs);
+	ret = v4l2_async_notifier_asd_valid(notifier, asd, -1);
 	if (ret)
 		goto unlock;
 
 	list_add_tail(&asd->asd_list, &notifier->asd_list);
-	notifier->num_subdevs++;
 
 unlock:
 	mutex_unlock(&list_lock);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 16b1e2b..89b152f 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -20,9 +20,6 @@ struct v4l2_device;
 struct v4l2_subdev;
 struct v4l2_async_notifier;
 
-/* A random max subdevice number, used to allocate an array on stack */
-#define V4L2_MAX_SUBDEVS 128U
-
 /**
  * enum v4l2_async_match_type - type of asynchronous subdevice logic to be used
  *	in order to identify a match
@@ -124,20 +121,16 @@ struct v4l2_async_notifier_operations {
  * struct v4l2_async_notifier - v4l2_device notifier data
  *
  * @ops:	notifier operations
- * @num_subdevs: number of subdevices used in the subdevs array
- * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
  * @sd:		sub-device that registered the notifier, NULL otherwise
  * @parent:	parent notifier
- * @asd_list:	master list of struct v4l2_async_subdev, replaces @subdevs
+ * @asd_list:	master list of struct v4l2_async_subdev
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
  */
 struct v4l2_async_notifier {
 	const struct v4l2_async_notifier_operations *ops;
-	unsigned int num_subdevs;
-	struct v4l2_async_subdev **subdevs;
 	struct v4l2_device *v4l2_dev;
 	struct v4l2_subdev *sd;
 	struct v4l2_async_notifier *parent;
@@ -164,10 +157,8 @@ void v4l2_async_notifier_init(struct v4l2_async_notifier *notifier);
  * @notifier: pointer to &struct v4l2_async_notifier
  * @asd: pointer to &struct v4l2_async_subdev
  *
- * This can be used before registering a notifier to add an
- * asd to the notifiers @asd_list. If the caller uses this
- * method to compose an asd list, it must never allocate
- * or place asd's in the @subdevs array.
+ * Call this function before registering a notifier to link the
+ * provided asd to the notifiers master @asd_list.
  */
 int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
 				   struct v4l2_async_subdev *asd);
@@ -184,10 +175,8 @@ int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
  *		     the driver's async sub-device struct, i.e. both
  *		     begin at the same memory address.
  *
- * This can be used before registering a notifier to add a
- * fwnode-matched asd to the notifiers master asd_list. If the caller
- * uses this method to compose an asd list, it must never allocate
- * or place asd's in the @subdevs array.
+ * Allocate a fwnode-matched asd of size asd_struct_size, and add it
+ * to the notifiers @asd_list.
  */
 struct v4l2_async_subdev *
 v4l2_async_notifier_add_fwnode_subdev(struct v4l2_async_notifier *notifier,
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 031ebb0..8b4873c 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -259,12 +259,6 @@ typedef int (*parse_endpoint_func)(struct device *dev,
  * This function may not be called on a registered notifier and may be called on
  * a notifier only once.
  *
- * Do not allocate the notifier's subdevs array, or change the notifier's
- * num_subdevs field. This is because this function uses
- * @v4l2_async_notifier_add_subdev to populate the notifier's asd_list,
- * which is in-place-of the subdevs array which must remain unallocated
- * and unused.
- *
  * The &struct v4l2_fwnode_endpoint passed to the callback function
  * @parse_endpoint is released once the function is finished. If there is a need
  * to retain that configuration, the user needs to allocate memory for it.
@@ -316,12 +310,6 @@ int v4l2_async_notifier_parse_fwnode_endpoints(
  * This function may not be called on a registered notifier and may be called on
  * a notifier only once per port.
  *
- * Do not allocate the notifier's subdevs array, or change the notifier's
- * num_subdevs field. This is because this function uses
- * @v4l2_async_notifier_add_subdev to populate the notifier's asd_list,
- * which is in-place-of the subdevs array which must remain unallocated
- * and unused.
- *
  * The &struct v4l2_fwnode_endpoint passed to the callback function
  * @parse_endpoint is released once the function is finished. If there is a need
  * to retain that configuration, the user needs to allocate memory for it.
-- 
2.7.4
