Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18466 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3GVSFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 14:05:44 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC00L7WNL6IAO0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jul 2013 03:05:42 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 5/5] V4L2: Fold struct v4l2_async_subdev_list with struct
 v4l2_subdev
Date: Mon, 22 Jul 2013 20:04:47 +0200
Message-id: <1374516287-7638-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By integrating the v4l2-async API internals a bit more with
the core overall the v4l2-async code becomes a bit simpler
and easier to follow.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-async.c |   67 +++++++++++++++-------------------
 include/media/v4l2-async.h           |   15 +-------
 include/media/v4l2-subdev.h          |   13 +++----
 3 files changed, 36 insertions(+), 59 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ed31a65..b350ab9 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -49,12 +49,10 @@ static LIST_HEAD(notifier_list);
 static DEFINE_MUTEX(list_lock);
 
 static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
-						    struct v4l2_async_subdev_list *asdl)
+						    struct v4l2_subdev *sd)
 {
-	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
 	struct v4l2_async_subdev *asd;
-	bool (*match)(struct device *,
-		      struct v4l2_async_subdev *);
+	bool (*match)(struct device *, struct v4l2_async_subdev *);
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
 		/* bus_type has been verified valid before */
@@ -89,16 +87,15 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 }
 
 static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
-				  struct v4l2_async_subdev_list *asdl,
+				  struct v4l2_subdev *sd,
 				  struct v4l2_async_subdev *asd)
 {
-	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
 	int ret;
 
 	/* Remove from the waiting list */
 	list_del(&asd->list);
-	asdl->asd = asd;
-	asdl->notifier = notifier;
+	sd->asd = asd;
+	sd->notifier = notifier;
 
 	if (notifier->bound) {
 		ret = notifier->bound(notifier, sd, asd);
@@ -106,7 +103,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 			return ret;
 	}
 	/* Move from the global subdevice list to notifier's done */
-	list_move(&asdl->list, &notifier->done);
+	list_move(&sd->async_list, &notifier->done);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
@@ -121,21 +118,19 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	return 0;
 }
 
-static void v4l2_async_cleanup(struct v4l2_async_subdev_list *asdl)
+static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 {
-	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
-
 	v4l2_device_unregister_subdev(sd);
-	/* Subdevice driver will reprobe and put asdl back onto the list */
-	list_del_init(&asdl->list);
-	asdl->asd = NULL;
+	/* Subdevice driver will reprobe and put the subdev back onto the list */
+	list_del_init(&sd->async_list);
+	sd->asd = NULL;
 	sd->dev = NULL;
 }
 
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_async_subdev_list *asdl, *tmp;
+	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
 	int i;
 
@@ -169,14 +164,14 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
-	list_for_each_entry_safe(asdl, tmp, &subdev_list, list) {
+	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
 		int ret;
 
-		asd = v4l2_async_belongs(notifier, asdl);
+		asd = v4l2_async_belongs(notifier, sd);
 		if (!asd)
 			continue;
 
-		ret = v4l2_async_test_notify(notifier, asdl, asd);
+		ret = v4l2_async_test_notify(notifier, sd, asd);
 		if (ret < 0) {
 			mutex_unlock(&list_lock);
 			return ret;
@@ -191,7 +186,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_register);
 
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_async_subdev_list *asdl, *tmp;
+	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->num_subdevs;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
 	struct device *dev[n_subdev];
@@ -201,18 +196,16 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
 	list_del(&notifier->list);
 
-	list_for_each_entry_safe(asdl, tmp, &notifier->done, list) {
-		struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
-
+	list_for_each_entry_safe(sd, tmp, &notifier->done, list) {
 		dev[i] = get_device(sd->dev);
 
-		v4l2_async_cleanup(asdl);
+		v4l2_async_cleanup(sd);
 
 		/* If we handled USB devices, we'd have to lock the parent too */
 		device_release_driver(dev[i++]);
 
 		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asdl.asd);
+			notifier->unbind(notifier, sd, sd->asd);
 	}
 
 	mutex_unlock(&list_lock);
@@ -241,24 +234,23 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
-	struct v4l2_async_subdev_list *asdl = &sd->asdl;
 	struct v4l2_async_notifier *notifier;
 
 	mutex_lock(&list_lock);
 
-	INIT_LIST_HEAD(&asdl->list);
+	INIT_LIST_HEAD(&sd->async_list);
 
 	list_for_each_entry(notifier, &notifier_list, list) {
-		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, asdl);
+		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
 		if (asd) {
-			int ret = v4l2_async_test_notify(notifier, asdl, asd);
+			int ret = v4l2_async_test_notify(notifier, sd, asd);
 			mutex_unlock(&list_lock);
 			return ret;
 		}
 	}
 
 	/* None matched, wait for hot-plugging */
-	list_add(&asdl->list, &subdev_list);
+	list_add(&sd->async_list, &subdev_list);
 
 	mutex_unlock(&list_lock);
 
@@ -268,23 +260,22 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
 
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
-	struct v4l2_async_subdev_list *asdl = &sd->asdl;
-	struct v4l2_async_notifier *notifier = asdl->notifier;
+	struct v4l2_async_notifier *notifier = sd->notifier;
 
-	if (!asdl->asd) {
-		if (!list_empty(&asdl->list))
-			v4l2_async_cleanup(asdl);
+	if (!sd->asd) {
+		if (!list_empty(&sd->async_list))
+			v4l2_async_cleanup(sd);
 		return;
 	}
 
 	mutex_lock(&list_lock);
 
-	list_add(&asdl->asd->list, &notifier->waiting);
+	list_add(&sd->asd->list, &notifier->waiting);
 
-	v4l2_async_cleanup(asdl);
+	v4l2_async_cleanup(sd);
 
 	if (notifier->unbind)
-		notifier->unbind(notifier, sd, sd->asdl.asd);
+		notifier->unbind(notifier, sd, sd->asd);
 
 	mutex_unlock(&list_lock);
 }
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 4e7834a..0b2b32b 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -62,25 +62,12 @@ struct v4l2_async_subdev {
 };
 
 /**
- * v4l2_async_subdev_list - provided by subdevices
- * @list:	links struct v4l2_async_subdev_list objects to a global list
- *		before probing, and onto notifier->done after probing
- * @asd:	pointer to respective struct v4l2_async_subdev
- * @notifier:	pointer to managing notifier
- */
-struct v4l2_async_subdev_list {
-	struct list_head list;
-	struct v4l2_async_subdev *asd;
-	struct v4l2_async_notifier *notifier;
-};
-
-/**
  * v4l2_async_notifier - v4l2_device notifier data
  * @num_subdevs:number of subdevices
  * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	pointer to struct v4l2_device
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
- * @done:	list of struct v4l2_async_subdev_list, already probed
+ * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
  * @bound:	a subdevice driver has successfully probed one of subdevices
  * @complete:	all subdevices have been probed successfully
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 3250cc5..bfda0fe 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -586,15 +586,14 @@ struct v4l2_subdev {
 	struct video_device *devnode;
 	/* pointer to the physical device, if any */
 	struct device *dev;
-	struct v4l2_async_subdev_list asdl;
+	/* Links this subdev to a global subdev_list or @notifier->done list. */
+	struct list_head async_list;
+	/* Pointer to respective struct v4l2_async_subdev. */
+	struct v4l2_async_subdev *asd;
+	/* Pointer to the managing notifier. */
+	struct v4l2_async_notifier *notifier;
 };
 
-static inline struct v4l2_subdev *v4l2_async_to_subdev(
-			struct v4l2_async_subdev_list *asdl)
-{
-	return container_of(asdl, struct v4l2_subdev, asdl);
-}
-
 #define media_entity_to_v4l2_subdev(ent) \
 	container_of(ent, struct v4l2_subdev, entity)
 #define vdev_to_v4l2_subdev(vdev) \
-- 
1.7.9.5

