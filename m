Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39234 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932320AbdJZHyf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 03:54:35 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v16 17/32] v4l: async: Prepare for async sub-device notifiers
Date: Thu, 26 Oct 2017 10:53:27 +0300
Message-Id: <20171026075342.5760-18-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor the V4L2 async framework a little in preparation for async
sub-device notifiers. This avoids making some structural changes in the
patch actually implementing sub-device notifiers, making that patch easier
to review.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 71 ++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 1b536d68cedf..eb31d96254d1 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -125,12 +125,13 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
 }
 
 static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
+				   struct v4l2_device *v4l2_dev,
 				   struct v4l2_subdev *sd,
 				   struct v4l2_async_subdev *asd)
 {
 	int ret;
 
-	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
 	if (ret < 0)
 		return ret;
 
@@ -151,6 +152,31 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	return 0;
 }
 
+/* Test all async sub-devices in a notifier for a match. */
+static int v4l2_async_notifier_try_all_subdevs(
+	struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
+	struct v4l2_subdev *sd, *tmp;
+
+	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
+		struct v4l2_async_subdev *asd;
+		int ret;
+
+		asd = v4l2_async_find_match(notifier, sd);
+		if (!asd)
+			continue;
+
+		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
+		if (ret < 0) {
+			mutex_unlock(&list_lock);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 {
 	v4l2_device_unregister_subdev(sd);
@@ -172,18 +198,15 @@ static void v4l2_async_notifier_unbind_all_subdevs(
 	}
 }
 
-int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
-				 struct v4l2_async_notifier *notifier)
+static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
 	int ret;
 	int i;
 
-	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
+	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
 
-	notifier->v4l2_dev = v4l2_dev;
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
 
@@ -216,18 +239,10 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 	mutex_lock(&list_lock);
 
-	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
-		int ret;
-
-		asd = v4l2_async_find_match(notifier, sd);
-		if (!asd)
-			continue;
-
-		ret = v4l2_async_match_notify(notifier, sd, asd);
-		if (ret < 0) {
-			mutex_unlock(&list_lock);
-			return ret;
-		}
+	ret = v4l2_async_notifier_try_all_subdevs(notifier);
+	if (ret) {
+		mutex_unlock(&list_lock);
+		return ret;
 	}
 
 	if (list_empty(&notifier->waiting)) {
@@ -250,6 +265,23 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 	return ret;
 }
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier)
+{
+	int ret;
+
+	if (WARN_ON(!v4l2_dev))
+		return -EINVAL;
+
+	notifier->v4l2_dev = v4l2_dev;
+
+	ret = __v4l2_async_notifier_register(notifier);
+	if (ret)
+		notifier->v4l2_dev = NULL;
+
+	return ret;
+}
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
@@ -324,7 +356,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 		if (!asd)
 			continue;
 
-		ret = v4l2_async_match_notify(notifier, sd, asd);
+		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
+					      asd);
 		if (ret)
 			goto err_unlock;
 
-- 
2.11.0
