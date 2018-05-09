Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44315 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965768AbeEIWrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 18:47:18 -0400
Received: by mail-pl0-f68.google.com with SMTP id e6-v6so90790plt.11
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 15:47:18 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 03/14] media: v4l2: async: Add v4l2_async_notifier_add_subdev
Date: Wed,  9 May 2018 15:46:52 -0700
Message-Id: <1525906023-827-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
References: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_notifier_add_subdev() adds an asd to the notifier. It checks
that no other equivalent asd's have already been added to this notifier's
asd list, or to other registered notifier's waiting or done lists, and
increments num_subdevs.

v4l2_async_notifier_add_subdev() does not make use of the notifier subdevs
array, otherwise it would have to re-allocate the array every time the
function was called. In place of the subdevs array, the function adds
the newly allocated asd to a new master asd_list. The function will
return error with a WARN() if it is ever called with the subdevs array
allocated.

In v4l2_async_notifier_has_async_subdev(), __v4l2_async_notifier_register(),
and v4l2_async_notifier_cleanup(), maintain backward compatibility with
the subdevs array, by alternatively operate on the subdevs array or a
non-empty notifier->asd_list.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v3:
- init notifier lists after the sanity checks.
Changes since v2:
- add a NULL asd pointer check to v4l2_async_notifier_asd_valid().
Changes since v1:
- none
---
 drivers/media/v4l2-core/v4l2-async.c | 206 +++++++++++++++++++++++++++--------
 include/media/v4l2-async.h           |  26 ++++-
 2 files changed, 187 insertions(+), 45 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 0e7e529..48d66ae 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -363,16 +363,26 @@ static bool v4l2_async_notifier_has_async_subdev(
 	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd,
 	unsigned int this_index)
 {
+	struct v4l2_async_subdev *asd_y;
 	unsigned int j;
 
 	lockdep_assert_held(&list_lock);
 
 	/* Check that an asd is not being added more than once. */
-	for (j = 0; j < this_index; j++) {
-		struct v4l2_async_subdev *asd_y = notifier->subdevs[j];
-
-		if (asd_equal(asd, asd_y))
-			return true;
+	if (notifier->subdevs) {
+		for (j = 0; j < this_index; j++) {
+			asd_y = notifier->subdevs[j];
+			if (asd_equal(asd, asd_y))
+				return true;
+		}
+	} else {
+		j = 0;
+		list_for_each_entry(asd_y, &notifier->asd_list, asd_list) {
+			if (j++ >= this_index)
+				break;
+			if (asd_equal(asd, asd_y))
+				return true;
+		}
 	}
 
 	/* Check that an asd does not exist in other notifiers. */
@@ -383,10 +393,46 @@ static bool v4l2_async_notifier_has_async_subdev(
 	return false;
 }
 
-static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
+static int v4l2_async_notifier_asd_valid(struct v4l2_async_notifier *notifier,
+					 struct v4l2_async_subdev *asd,
+					 unsigned int this_index)
 {
 	struct device *dev =
 		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
+
+	if (!asd)
+		return -EINVAL;
+
+	switch (asd->match_type) {
+	case V4L2_ASYNC_MATCH_CUSTOM:
+	case V4L2_ASYNC_MATCH_DEVNAME:
+	case V4L2_ASYNC_MATCH_I2C:
+	case V4L2_ASYNC_MATCH_FWNODE:
+		if (v4l2_async_notifier_has_async_subdev(notifier, asd,
+							 this_index))
+			return -EEXIST;
+		break;
+	default:
+		dev_err(dev, "Invalid match type %u on %p\n",
+			asd->match_type, asd);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void __v4l2_async_notifier_init(struct v4l2_async_notifier *notifier)
+{
+	lockdep_assert_held(&list_lock);
+
+	INIT_LIST_HEAD(&notifier->asd_list);
+	INIT_LIST_HEAD(&notifier->waiting);
+	INIT_LIST_HEAD(&notifier->done);
+	notifier->lists_initialized = true;
+}
+
+static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
+{
 	struct v4l2_async_subdev *asd;
 	int ret;
 	int i;
@@ -394,34 +440,40 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
 
-	INIT_LIST_HEAD(&notifier->waiting);
-	INIT_LIST_HEAD(&notifier->done);
-
 	mutex_lock(&list_lock);
 
-	for (i = 0; i < notifier->num_subdevs; i++) {
-		asd = notifier->subdevs[i];
+	if (!notifier->lists_initialized)
+		__v4l2_async_notifier_init(notifier);
 
-		switch (asd->match_type) {
-		case V4L2_ASYNC_MATCH_CUSTOM:
-		case V4L2_ASYNC_MATCH_DEVNAME:
-		case V4L2_ASYNC_MATCH_I2C:
-		case V4L2_ASYNC_MATCH_FWNODE:
-			if (v4l2_async_notifier_has_async_subdev(
-				    notifier, asd, i)) {
-				dev_err(dev,
-					"asd has already been registered or in notifier's subdev list\n");
-				ret = -EEXIST;
-				goto err_unlock;
-			}
-			break;
-		default:
-			dev_err(dev, "Invalid match type %u on %p\n",
-				asd->match_type, asd);
+	if (!list_empty(&notifier->asd_list)) {
+		/*
+		 * Caller must have either used v4l2_async_notifier_add_subdev
+		 * to add asd's to notifier->asd_list, or provided the
+		 * notifier->subdevs array, but not both.
+		 */
+		if (WARN_ON(notifier->subdevs)) {
 			ret = -EINVAL;
 			goto err_unlock;
 		}
-		list_add_tail(&asd->list, &notifier->waiting);
+
+		i = 0;
+		list_for_each_entry(asd, &notifier->asd_list, asd_list) {
+			ret = v4l2_async_notifier_asd_valid(notifier, asd, i++);
+			if (ret)
+				goto err_unlock;
+
+			list_add_tail(&asd->list, &notifier->waiting);
+		}
+	} else if (notifier->subdevs) {
+		for (i = 0; i < notifier->num_subdevs; i++) {
+			asd = notifier->subdevs[i];
+
+			ret = v4l2_async_notifier_asd_valid(notifier, asd, i);
+			if (ret)
+				goto err_unlock;
+
+			list_add_tail(&asd->list, &notifier->waiting);
+		}
 	}
 
 	ret = v4l2_async_notifier_try_all_subdevs(notifier);
@@ -511,36 +563,102 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 }
 EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
-void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
+static void __v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
 {
+	struct v4l2_async_subdev *asd, *tmp;
 	unsigned int i;
 
-	if (!notifier || !notifier->max_subdevs)
+	if (!notifier)
 		return;
 
-	for (i = 0; i < notifier->num_subdevs; i++) {
-		struct v4l2_async_subdev *asd = notifier->subdevs[i];
+	if (notifier->subdevs) {
+		if (!notifier->max_subdevs)
+			return;
 
-		switch (asd->match_type) {
-		case V4L2_ASYNC_MATCH_FWNODE:
-			fwnode_handle_put(asd->match.fwnode);
-			break;
-		default:
-			WARN_ON_ONCE(true);
-			break;
+		for (i = 0; i < notifier->num_subdevs; i++) {
+			asd = notifier->subdevs[i];
+
+			switch (asd->match_type) {
+			case V4L2_ASYNC_MATCH_FWNODE:
+				fwnode_handle_put(asd->match.fwnode);
+				break;
+			default:
+				break;
+			}
+
+			kfree(asd);
 		}
 
-		kfree(asd);
+		notifier->max_subdevs = 0;
+		kvfree(notifier->subdevs);
+		notifier->subdevs = NULL;
+	} else if (notifier->lists_initialized) {
+		list_for_each_entry_safe(asd, tmp,
+					 &notifier->asd_list, asd_list) {
+			switch (asd->match_type) {
+			case V4L2_ASYNC_MATCH_FWNODE:
+				fwnode_handle_put(asd->match.fwnode);
+				break;
+			default:
+				break;
+			}
+
+			list_del(&asd->asd_list);
+			kfree(asd);
+		}
 	}
 
-	notifier->max_subdevs = 0;
 	notifier->num_subdevs = 0;
+}
+
+void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
+{
+	mutex_lock(&list_lock);
 
-	kvfree(notifier->subdevs);
-	notifier->subdevs = NULL;
+	__v4l2_async_notifier_cleanup(notifier);
+
+	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
 
+int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
+				   struct v4l2_async_subdev *asd)
+{
+	int ret;
+
+	mutex_lock(&list_lock);
+
+	if (notifier->num_subdevs >= V4L2_MAX_SUBDEVS) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	/*
+	 * If caller uses this function, it cannot also allocate and
+	 * place asd's in the notifier->subdevs array.
+	 */
+	if (WARN_ON(notifier->subdevs)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (!notifier->lists_initialized)
+		__v4l2_async_notifier_init(notifier);
+
+	ret = v4l2_async_notifier_asd_valid(notifier, asd,
+					    notifier->num_subdevs);
+	if (ret)
+		goto unlock;
+
+	list_add_tail(&asd->asd_list, &notifier->asd_list);
+	notifier->num_subdevs++;
+
+unlock:
+	mutex_unlock(&list_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_subdev);
+
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *subdev_notifier;
@@ -614,7 +732,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	mutex_lock(&list_lock);
 
 	__v4l2_async_notifier_unregister(sd->subdev_notifier);
-	v4l2_async_notifier_cleanup(sd->subdev_notifier);
+	__v4l2_async_notifier_cleanup(sd->subdev_notifier);
 	kfree(sd->subdev_notifier);
 	sd->subdev_notifier = NULL;
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 1592d32..6e752ef 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -73,6 +73,8 @@ enum v4l2_async_match_type {
  * @match.custom.priv:
  *		Driver-specific private struct with match parameters
  *		to be used if %V4L2_ASYNC_MATCH_CUSTOM.
+ * @asd_list:	used to add struct v4l2_async_subdev objects to the
+ *		master notifier->asd_list
  * @list:	used to link struct v4l2_async_subdev objects, waiting to be
  *		probed, to a notifier->waiting list
  *
@@ -98,6 +100,7 @@ struct v4l2_async_subdev {
 
 	/* v4l2-async core private: not to be used by drivers */
 	struct list_head list;
+	struct list_head asd_list;
 };
 
 /**
@@ -127,9 +130,11 @@ struct v4l2_async_notifier_operations {
  * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
  * @sd:		sub-device that registered the notifier, NULL otherwise
  * @parent:	parent notifier
+ * @asd_list:	master list of struct v4l2_async_subdev, replaces @subdevs
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
+ * @lists_initialized: list_head's have been initialized
  */
 struct v4l2_async_notifier {
 	const struct v4l2_async_notifier_operations *ops;
@@ -139,12 +144,29 @@ struct v4l2_async_notifier {
 	struct v4l2_device *v4l2_dev;
 	struct v4l2_subdev *sd;
 	struct v4l2_async_notifier *parent;
+	struct list_head asd_list;
 	struct list_head waiting;
 	struct list_head done;
 	struct list_head list;
+	bool lists_initialized;
 };
 
 /**
+ * v4l2_async_notifier_add_subdev - Add an async subdev to the
+ *				notifier's master asd_list.
+ *
+ * @notifier: pointer to &struct v4l2_async_notifier
+ * @asd: pointer to &struct v4l2_async_subdev
+ *
+ * This can be used before registering a notifier to add an
+ * asd to the notifiers master asd_list. If the caller uses
+ * this method to compose an asd list, it must never allocate
+ * or place asd's in the @subdevs array.
+ */
+int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
+				   struct v4l2_async_subdev *asd);
+
+/**
  * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
  *
  * @v4l2_dev: pointer to &struct v4l2_device
@@ -177,7 +199,9 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
  * Release memory resources related to a notifier, including the async
  * sub-devices allocated for the purposes of the notifier but not the notifier
  * itself. The user is responsible for calling this function to clean up the
- * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints or
+ * notifier after calling
+ * @v4l2_async_notifier_add_subdev,
+ * @v4l2_async_notifier_parse_fwnode_endpoints or
  * @v4l2_fwnode_reference_parse_sensor_common.
  *
  * There is no harm from calling v4l2_async_notifier_cleanup in other
-- 
2.7.4
