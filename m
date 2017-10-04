Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40394 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751250AbdJDVu7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 14/32] v4l: async: Introduce helpers for calling async ops callbacks
Date: Thu,  5 Oct 2017 00:50:33 +0300
Message-Id: <20171004215051.13385-15-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add three helper functions to call async operations callbacks. Besides
simplifying callbacks, this allows async notifiers to have no ops set,
i.e. it can be left NULL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/v4l2-core/v4l2-async.c | 56 +++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 9d6fc5f25619..e170682dae78 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -25,6 +25,34 @@
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
+static int v4l2_async_notifier_call_bound(struct v4l2_async_notifier *n,
+					  struct v4l2_subdev *subdev,
+					  struct v4l2_async_subdev *asd)
+{
+	if (!n->ops || !n->ops->bound)
+		return 0;
+
+	return n->ops->bound(n, subdev, asd);
+}
+
+static void v4l2_async_notifier_call_unbind(struct v4l2_async_notifier *n,
+					    struct v4l2_subdev *subdev,
+					    struct v4l2_async_subdev *asd)
+{
+	if (!n->ops || !n->ops->unbind)
+		return;
+
+	n->ops->unbind(n, subdev, asd);
+}
+
+static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier *n)
+{
+	if (!n->ops || !n->ops->complete)
+		return 0;
+
+	return n->ops->complete(n);
+}
+
 static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 #if IS_ENABLED(CONFIG_I2C)
@@ -102,16 +130,13 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 {
 	int ret;
 
-	if (notifier->ops->bound) {
-		ret = notifier->ops->bound(notifier, sd, asd);
-		if (ret < 0)
-			return ret;
-	}
+	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
+	if (ret < 0)
+		return ret;
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
-		if (notifier->ops->unbind)
-			notifier->ops->unbind(notifier, sd, asd);
+		v4l2_async_notifier_call_unbind(notifier, sd, asd);
 		return ret;
 	}
 
@@ -140,8 +165,7 @@ static void v4l2_async_notifier_unbind_all_subdevs(
 	struct v4l2_subdev *sd, *tmp;
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		if (notifier->ops->unbind)
-			notifier->ops->unbind(notifier, sd, sd->asd);
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 		v4l2_async_cleanup(sd);
 
 		list_move(&sd->async_list, &subdev_list);
@@ -198,8 +222,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		}
 	}
 
-	if (list_empty(&notifier->waiting) && notifier->ops->complete) {
-		ret = notifier->ops->complete(notifier);
+	if (list_empty(&notifier->waiting)) {
+		ret = v4l2_async_notifier_call_complete(notifier);
 		if (ret)
 			goto err_complete;
 	}
@@ -296,10 +320,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 		if (ret)
 			goto err_unlock;
 
-		if (!list_empty(&notifier->waiting) || !notifier->ops->complete)
+		if (!list_empty(&notifier->waiting))
 			goto out_unlock;
 
-		ret = notifier->ops->complete(notifier);
+		ret = v4l2_async_notifier_call_complete(notifier);
 		if (ret)
 			goto err_cleanup;
 
@@ -315,8 +339,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	return 0;
 
 err_cleanup:
-	if (notifier->ops->unbind)
-		notifier->ops->unbind(notifier, sd, sd->asd);
+	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 	v4l2_async_cleanup(sd);
 
 err_unlock:
@@ -335,8 +358,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 
 		list_add(&sd->asd->list, &notifier->waiting);
 
-		if (notifier->ops->unbind)
-			notifier->ops->unbind(notifier, sd, sd->asd);
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 	}
 
 	v4l2_async_cleanup(sd);
-- 
2.11.0
