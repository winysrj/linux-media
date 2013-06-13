Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36262 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961Ab3FMVkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 17:40:04 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, magnus.damm@gmail.com,
	prabhakar.csengg@gmail.com, s.hauer@pengutronix.de,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] V4L2: Merge struct v4l2_async_subdev_list with struct v4l2_subdev
Date: Thu, 13 Jun 2013 23:39:42 +0200
Message-Id: <1371159582-19163-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1370939028-8352-17-git-send-email-g.liakhovetski@gmx.de>
References: <1370939028-8352-17-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---

Please consider squashing such change or similar into patch
[PATCH v10 16/21] V4L2: support asynchronous subdevice registration

This patch has not been tested yet.
---
 drivers/media/v4l2-core/v4l2-async.c |   67 +++++++++++++++-------------------
 include/media/v4l2-async.h           |   15 +-------
 include/media/v4l2-subdev.h          |   13 +++----
 3 files changed, 36 insertions(+), 59 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 3590ccc..53f741d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -42,12 +42,10 @@ static LIST_HEAD(notifier_list);
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
@@ -79,16 +77,15 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
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
@@ -96,7 +93,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 			return ret;
 	}
 	/* Move from the global subdevice list to notifier's done */
-	list_move(&asdl->list, &notifier->done);
+	list_move(&sd->async_list, &notifier->done);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
@@ -111,21 +108,19 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
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
 
@@ -158,14 +153,14 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
-	list_for_each_entry_safe(asdl, tmp, &subdev_list, list) {
+	list_for_each_entry_safe(sd, tmp, &subdev_list, list) {
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
@@ -180,7 +175,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_register);
 
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_async_subdev_list *asdl, *tmp;
+	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->subdev_num;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
 	struct device *dev[n_subdev];
@@ -190,18 +185,16 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
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
@@ -230,24 +223,23 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 
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
 
@@ -257,23 +249,22 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
 
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
index 12bd39c..ba91c3b 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -57,25 +57,12 @@ struct v4l2_async_subdev {
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
  * @subdev_num:	number of subdevices
  * @subdev:	array of pointers to subdevices
  * @v4l2_dev:	pointer to struct v4l2_device
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
- * @done:	list of struct v4l2_async_subdev_list, already probed
+ * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
  * @bound:	a subdevice driver has successfully probed one of subdevices
  * @complete:	all subdevices have been probed successfully
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 21174af..45aa155 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -588,15 +588,14 @@ struct v4l2_subdev {
 	struct video_device *devnode;
 	/* pointer to the physical device */
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
1.7.4.1

