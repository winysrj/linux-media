Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:52684 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753509AbdGSKuU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:50:20 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v5 4/4] v4l: async: add subnotifier to subdevices
Date: Wed, 19 Jul 2017 12:49:46 +0200
Message-Id: <20170719104946.7322-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a subdevice specific notifier which can be used by a subdevice
driver to complement the master device notifier to extend the subdevice
discovery.

The master device registers the subdevices closest to itself in its
notifier while the subdevice(s) register notifiers for their closest
neighboring devices. Subdevice drivers configure a notifier at probe
time which is registered by the v4l2-async framework once the subdevice
itself is registered, since it's only at this point the v4l2_dev is
available to the subnotifier.

Using this incremental approach two problems can be solved:

1. The master device no longer has to care how many devices exist in
   the pipeline. It only needs to care about its closest subdevice and
   arbitrary long pipelines can be created without having to adapt the
   master device for each case.

2. Subdevices which are represented as a single DT node but register
   more than one subdevice can use this to improve the pipeline
   discovery, since the subdevice driver is the only one who knows which
   of its subdevices is linked with which subdevice of a neighboring DT
   node.

To allow subdevices to provide their own list of subdevices to the
v4l2-async framework v4l2_async_subdev_notifier_register() is added.
This new function must be called before the subdevice itself is
registered with the v4l2-async framework using
v4l2_async_register_subdev().

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/media/kapi/v4l2-subdev.rst |  12 +++
 drivers/media/v4l2-core/v4l2-async.c     | 142 +++++++++++++++++++++++++++----
 include/media/v4l2-async.h               |  25 ++++++
 include/media/v4l2-subdev.h              |   5 ++
 4 files changed, 169 insertions(+), 15 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index e1f0b726e438f963..ec9e7b7fb78f226d 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -262,6 +262,18 @@ is called. After all subdevices have been located the .complete() callback is
 called. When a subdevice is removed from the system the .unbind() method is
 called. All three callbacks are optional.
 
+Subdevice drivers might in turn register subnotifier objects with an
+array of other subdevice descriptors that the subdevice needs for its
+own operation. Subnotifiers are an extension of the bridge drivers
+notifier to allow for a incremental registering and matching of
+subdevices. This is useful when a driver only has information about
+which subdevice is closest to itself and would require knowledge from the
+driver of that subdevice to know which other subdevice(s) lie beyond.
+By registering subnotifiers drivers can incrementally move the subdevice
+matching down the chain of drivers. This is performed using the
+:c:func:`v4l2_async_subdev_notifier_register` call which must be performed
+before registering the subdevice using :c:func:`v4l2_async_register_subdev`.
+
 V4L2 sub-device userspace API
 -----------------------------
 
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index d91ff0a33fd3eaff..0cafb13025b5cbb6 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -100,6 +100,60 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 	return NULL;
 }
 
+static int v4l2_async_notifier_complete(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd, *tmp;
+
+	if (!notifier->num_subdevs)
+		return 0;
+
+	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list)
+		v4l2_async_notifier_complete(&sd->subnotifier);
+
+	if (notifier->complete)
+		return notifier->complete(notifier);
+
+	return 0;
+}
+
+static bool
+v4l2_async_is_notifier_complete(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd, *tmp;
+
+	if (!list_empty(&notifier->waiting))
+		return false;
+
+	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		/* Don't consider empty subnotifiers */
+		if (!sd->subnotifier.num_subdevs)
+			continue;
+
+		if (!v4l2_async_is_notifier_complete(&sd->subnotifier))
+			return false;
+	}
+
+	return true;
+}
+
+static int
+v4l2_async_try_complete_notifier(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_async_notifier *root = notifier;
+
+	while (root->subnotifier) {
+		root = subnotifier_to_v4l2_subdev(root)->notifier;
+		/* No root notifier can be found at this time */
+		if (!root)
+			return 0;
+	}
+
+	if (v4l2_async_is_notifier_complete(root))
+		return v4l2_async_notifier_complete(root);
+
+	return 0;
+}
+
 static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 				  struct v4l2_subdev *sd,
 				  struct v4l2_async_subdev *asd)
@@ -119,6 +173,17 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 		return ret;
 	}
 
+	/* Register the subnotifier if it's not empty */
+	if (sd->subnotifier.num_subdevs) {
+		ret = v4l2_async_notifier_register(sd->v4l2_dev,
+						   &sd->subnotifier);
+		if (ret) {
+			if (notifier->unbind)
+				notifier->unbind(notifier, sd, asd);
+			v4l2_device_unregister_subdev(sd);
+			return ret;
+		}
+	}
 	/* Remove from the waiting list */
 	list_del(&asd->list);
 	sd->asd = asd;
@@ -127,10 +192,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
-	if (list_empty(&notifier->waiting) && notifier->complete)
-		return notifier->complete(notifier);
-
-	return 0;
+	return v4l2_async_try_complete_notifier(notifier);
 }
 
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
@@ -140,6 +202,7 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	list_del_init(&sd->async_list);
 	sd->asd = NULL;
 	sd->dev = NULL;
+	sd->notifier = NULL;
 }
 
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
@@ -175,8 +238,17 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		list_add_tail(&asd->list, &notifier->waiting);
 	}
 
-	mutex_lock(&list_lock);
+	if (notifier->subnotifier)
+		lockdep_assert_held(&list_lock);
+	else
+		mutex_lock(&list_lock);
 
+	/*
+	 * This function can be called recursively so the list
+	 * might be modified in a recursive call. Start from the
+	 * top of the list each iteration.
+	 */
+again:
 	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
 		int ret;
 
@@ -186,15 +258,18 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 		ret = v4l2_async_test_notify(notifier, sd, asd);
 		if (ret < 0) {
-			mutex_unlock(&list_lock);
+			if (!notifier->subnotifier)
+				mutex_unlock(&list_lock);
 			return ret;
 		}
+		goto again;
 	}
 
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
-	mutex_unlock(&list_lock);
+	if (!notifier->subnotifier)
+		mutex_unlock(&list_lock);
 
 	return 0;
 }
@@ -205,14 +280,17 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->num_subdevs;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
-	struct device **dev;
 	int i, count = 0;
+	struct {
+		struct device *dev;
+		struct v4l2_subdev *sd;
+	} *cache;
 
 	if (!notifier->v4l2_dev)
 		return;
 
-	dev = kvmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
+	cache = kvmalloc_array(n_subdev, sizeof(*cache), GFP_KERNEL);
+	if (!cache) {
 		dev_err(notifier->v4l2_dev->dev,
 			"Failed to allocate device cache!\n");
 		return;
@@ -223,7 +301,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		dev[count] = get_device(sd->dev);
+		cache[count].dev = get_device(sd->dev);
+		cache[count].sd = sd;
 		count++;
 
 		if (notifier->unbind)
@@ -235,20 +314,24 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	mutex_unlock(&list_lock);
 
 	for (i = 0; i < count; i++) {
+		sd = cache[i].sd;
+		/* If the subdev have a notifier unregister it */
+		if (sd->subnotifier.num_subdevs)
+			v4l2_async_notifier_unregister(&sd->subnotifier);
+
 		/* If we handled USB devices, we'd have to lock the parent too */
-		device_release_driver(dev[i]);
+		device_release_driver(cache[i].dev);
 	}
 
 	/*
 	 * Call device_attach() to reprobe devices
 	 */
 	for (i = 0; i < count; i++) {
-		struct device *d = dev[i];
+		struct device *d = cache[i].dev;
 
 		if (d && device_attach(d) < 0) {
 			const char *name = "(none)";
 			int lock = device_trylock(d);
-
 			if (lock && d->driver)
 				name = d->driver->name;
 			dev_err(d, "Failed to re-probe to %s\n", name);
@@ -257,7 +340,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		}
 		put_device(d);
 	}
-	kvfree(dev);
+	kvfree(cache);
 
 	notifier->v4l2_dev = NULL;
 
@@ -312,6 +395,9 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 		return;
 	}
 
+	if (sd->subnotifier.num_subdevs)
+		v4l2_async_notifier_unregister(&sd->subnotifier);
+
 	mutex_lock(&list_lock);
 
 	list_add(&sd->asd->list, &notifier->waiting);
@@ -324,3 +410,29 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_unregister_subdev);
+
+int v4l2_async_subdev_notifier_register(
+		struct v4l2_subdev *sd,
+		unsigned int num_subdevs,
+		struct v4l2_async_subdev **subdevs,
+		int (*bound)(struct v4l2_async_notifier *notifier,
+			     struct v4l2_subdev *subdev,
+			     struct v4l2_async_subdev *asd),
+		int (*complete)(struct v4l2_async_notifier *notifier),
+		void (*unbind)(struct v4l2_async_notifier *notifier,
+			       struct v4l2_subdev *subdev,
+			       struct v4l2_async_subdev *asd))
+{
+	if (!sd || !num_subdevs || !subdevs)
+		return -EINVAL;
+
+	sd->subnotifier.subnotifier = true;
+	sd->subnotifier.num_subdevs = num_subdevs;
+	sd->subnotifier.subdevs = subdevs;
+	sd->subnotifier.bound = bound;
+	sd->subnotifier.complete = complete;
+	sd->subnotifier.unbind = unbind;
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index c69d8c8a66d0093a..91f02d2b03b88135 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -78,6 +78,7 @@ struct v4l2_async_subdev {
 /**
  * struct v4l2_async_notifier - v4l2_device notifier data
  *
+ * @subnotifier: flag if this notifier is part of a v4l2_subdev
  * @num_subdevs: number of subdevices
  * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	pointer to struct v4l2_device
@@ -89,6 +90,7 @@ struct v4l2_async_subdev {
  * @unbind:	a subdevice is leaving
  */
 struct v4l2_async_notifier {
+	bool subnotifier;
 	unsigned int num_subdevs;
 	struct v4l2_async_subdev **subdevs;
 	struct v4l2_device *v4l2_dev;
@@ -135,4 +137,27 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
  * @sd: pointer to &struct v4l2_subdev
  */
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
+
+/**
+ * v4l2_async_subdev_notifier_register - registers a subdevice asynchronous
+ *	subnotifier
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @num_subdevs: number of subdevices
+ * @subdevs: array of pointers to subdevice descriptors
+ * @bound: a subdevice driver has successfully probed one of subdevices
+ * @complete: all subdevices have been probed successfully
+ * @unbind: a subdevice is leaving
+ */
+int v4l2_async_subdev_notifier_register(
+		struct v4l2_subdev *sd,
+		unsigned int num_subdevs,
+		struct v4l2_async_subdev **subdevs,
+		int (*bound)(struct v4l2_async_notifier *notifier,
+			     struct v4l2_subdev *subdev,
+			     struct v4l2_async_subdev *asd),
+		int (*complete)(struct v4l2_async_notifier *notifier),
+		void (*unbind)(struct v4l2_async_notifier *notifier,
+			       struct v4l2_subdev *subdev,
+			       struct v4l2_async_subdev *asd));
 #endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0f92ebd2d7101acf..13a04af16a627394 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -793,6 +793,7 @@ struct v4l2_subdev_platform_data {
  *	list.
  * @asd: Pointer to respective &struct v4l2_async_subdev.
  * @notifier: Pointer to the managing notifier.
+ * @subnotifier: Notifier for devices the subdevice depends on
  * @pdata: common part of subdevice platform data
  *
  * Each instance of a subdev driver should create this struct, either
@@ -823,6 +824,7 @@ struct v4l2_subdev {
 	struct list_head async_list;
 	struct v4l2_async_subdev *asd;
 	struct v4l2_async_notifier *notifier;
+	struct v4l2_async_notifier subnotifier;
 	struct v4l2_subdev_platform_data *pdata;
 };
 
@@ -838,6 +840,9 @@ struct v4l2_subdev {
 #define vdev_to_v4l2_subdev(vdev) \
 	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
+#define subnotifier_to_v4l2_subdev(sub) \
+	container_of(sub, struct v4l2_subdev, subnotifier)
+
 /**
  * struct v4l2_subdev_fh - Used for storing subdev information per file handle
  *
-- 
2.13.1
