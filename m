Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45556 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751434AbdIOOSL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 10:18:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v13 11/25] v4l: async: Introduce helpers for calling async ops callbacks
Date: Fri, 15 Sep 2017 17:17:10 +0300
Message-Id: <20170915141724.23124-12-sakari.ailus@linux.intel.com>
In-Reply-To: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add three helper functions to call async operations callbacks. Besides
simplifying callbacks, this allows async notifiers to have no ops set,
i.e. it can be left NULL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 49 ++++++++++++++++++++++++++----------
 include/media/v4l2-async.h           |  1 +
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 7b2125b3d62f..c35d04b9122f 100644
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
 
@@ -123,8 +148,8 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
-	if (list_empty(&notifier->waiting) && notifier->ops->complete)
-		return notifier->ops->complete(notifier);
+	if (list_empty(&notifier->waiting))
+		return v4l2_async_notifier_call_complete(notifier);
 
 	return 0;
 }
@@ -210,8 +235,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
 		v4l2_async_cleanup(sd);
 
-		if (notifier->ops->unbind)
-			notifier->ops->unbind(notifier, sd, sd->asd);
+		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 	}
 
 	mutex_unlock(&list_lock);
@@ -300,8 +324,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 
 	v4l2_async_cleanup(sd);
 
-	if (notifier->ops->unbind)
-		notifier->ops->unbind(notifier, sd, sd->asd);
+	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
 
 	mutex_unlock(&list_lock);
 }
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 3c48f8b66d12..3bc8a7c0d83f 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -164,4 +164,5 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
  * @sd: pointer to &struct v4l2_subdev
  */
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
+
 #endif
-- 
2.11.0
