Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35745 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcDXVKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:32 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so17587695wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:31 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 18/24] v4l2-async: per notifier locking
Date: Mon, 25 Apr 2016 00:08:18 +0300
Message-Id: <1461532104-24032-19-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sebastian Reichel <sre@kernel.org>

---
 drivers/media/v4l2-core/v4l2-async.c | 50 ++++++++++++++++++------------------
 include/media/v4l2-async.h           |  2 ++
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a4b224d..27789cd 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -56,7 +56,6 @@ static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 
 static LIST_HEAD(subdev_list);
 static LIST_HEAD(notifier_list);
-static DEFINE_MUTEX(list_lock);
 
 static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
 						    struct v4l2_subdev *sd)
@@ -106,14 +105,17 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 
 	if (notifier->bound) {
 		ret = notifier->bound(notifier, sd, asd);
-		if (ret < 0)
+		if (ret < 0) {
+			dev_warn(notifier->v4l2_dev->dev, "subdev bound failed\n");
 			return ret;
+		}
 	}
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
+		dev_warn(notifier->v4l2_dev->dev, "subdev register failed\n");
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, asd);
 		return ret;
@@ -146,7 +148,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 {
 	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
-	int i;
+	int ret = 0, i;
 
 	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
@@ -154,6 +156,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	notifier->v4l2_dev = v4l2_dev;
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
+	mutex_init(&notifier->lock);
 
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdevs[i];
@@ -173,28 +176,22 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		list_add_tail(&asd->list, &notifier->waiting);
 	}
 
-	mutex_lock(&list_lock);
-
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
+	mutex_lock(&notifier->lock);
 
 	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
-		int ret;
-
 		asd = v4l2_async_belongs(notifier, sd);
 		if (!asd)
 			continue;
 
 		ret = v4l2_async_test_notify(notifier, sd, asd);
-		if (ret < 0) {
-			mutex_unlock(&list_lock);
-			return ret;
-		}
+		if (ret < 0)
+			break;
 	}
+	mutex_unlock(&notifier->lock);
 
-	mutex_unlock(&list_lock);
-
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
@@ -215,7 +212,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 			"Failed to allocate device cache!\n");
 	}
 
-	mutex_lock(&list_lock);
+	mutex_lock(&notifier->lock);
 
 	list_del(&notifier->list);
 
@@ -242,7 +239,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 			put_device(d);
 	}
 
-	mutex_unlock(&list_lock);
+	mutex_unlock(&notifier->lock);
 
 	/*
 	 * Call device_attach() to reprobe devices
@@ -267,6 +264,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	}
 	kfree(dev);
 
+	mutex_destroy(&notifier->lock);
 	notifier->v4l2_dev = NULL;
 
 	/*
@@ -279,6 +277,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *notifier;
+	struct v4l2_async_notifier *tmp;
 
 	/*
 	 * No reference taken. The reference is held by the device
@@ -288,24 +287,25 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	if (!sd->of_node && sd->dev)
 		sd->of_node = sd->dev->of_node;
 
-	mutex_lock(&list_lock);
-
 	INIT_LIST_HEAD(&sd->async_list);
 
-	list_for_each_entry(notifier, &notifier_list, list) {
-		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
+	list_for_each_entry_safe(notifier, tmp, &notifier_list, list) {
+		struct v4l2_async_subdev *asd;
+
+		/* TODO: FIXME: if this is called by ->bound() we will also iterate over the locked notifier */
+		mutex_lock_nested(&notifier->lock, SINGLE_DEPTH_NESTING);
+		asd = v4l2_async_belongs(notifier, sd);
 		if (asd) {
 			int ret = v4l2_async_test_notify(notifier, sd, asd);
-			mutex_unlock(&list_lock);
+			mutex_unlock(&notifier->lock);
 			return ret;
 		}
+		mutex_unlock(&notifier->lock);
 	}
 
 	/* None matched, wait for hot-plugging */
 	list_add(&sd->async_list, &subdev_list);
 
-	mutex_unlock(&list_lock);
-
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_async_register_subdev);
@@ -320,7 +320,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 		return;
 	}
 
-	mutex_lock(&list_lock);
+	mutex_lock_nested(&notifier->lock, SINGLE_DEPTH_NESTING);
 
 	list_add(&sd->asd->list, &notifier->waiting);
 
@@ -329,6 +329,6 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	if (notifier->unbind)
 		notifier->unbind(notifier, sd, sd->asd);
 
-	mutex_unlock(&list_lock);
+	mutex_unlock(&notifier->lock);
 }
 EXPORT_SYMBOL(v4l2_async_unregister_subdev);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 1d6d7da..d2178c1 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -71,6 +71,7 @@ struct v4l2_async_subdev {
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
+ * @lock:       lock hold when the notifier is being processed
  * @bound:	a subdevice driver has successfully probed one of subdevices
  * @complete:	all subdevices have been probed successfully
  * @unbind:	a subdevice is leaving
@@ -82,6 +83,7 @@ struct v4l2_async_notifier {
 	struct list_head waiting;
 	struct list_head done;
 	struct list_head list;
+	struct mutex lock;
 	int (*bound)(struct v4l2_async_notifier *notifier,
 		     struct v4l2_subdev *subdev,
 		     struct v4l2_async_subdev *asd);
-- 
1.9.1

