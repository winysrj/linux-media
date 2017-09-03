Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49468 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753163AbdICRuE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 13:50:04 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v7 10/18] v4l: async: Introduce macros for calling async ops callbacks
Date: Sun,  3 Sep 2017 20:49:50 +0300
Message-Id: <20170903174958.27058-11-sakari.ailus@linux.intel.com>
In-Reply-To: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two macros to call async operations callbacks. Besides simplifying
callbacks, this allows async notifiers to have no ops set, i.e. it can be
left NULL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 19 +++++++------------
 include/media/v4l2-async.h           |  8 ++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 810f5e0273dc..91d04f00b4e4 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -107,16 +107,13 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 {
 	int ret;
 
-	if (notifier->ops->bound) {
-		ret = notifier->ops->bound(notifier, sd, asd);
-		if (ret < 0)
-			return ret;
-	}
+	ret = v4l2_async_notifier_call_int_op(notifier, bound, sd, asd);
+	if (ret < 0)
+		return ret;
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
-		if (notifier->ops->unbind)
-			notifier->ops->unbind(notifier, sd, asd);
+		v4l2_async_notifier_call_void_op(notifier, unbind, sd, asd);
 		return ret;
 	}
 
@@ -129,7 +126,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	list_move(&sd->async_list, &notifier->done);
 
 	if (list_empty(&notifier->waiting) && notifier->ops->complete)
-		return notifier->ops->complete(notifier);
+		return v4l2_async_notifier_call_int_op(notifier, complete);
 
 	return 0;
 }
@@ -232,8 +229,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		/* If we handled USB devices, we'd have to lock the parent too */
 		device_release_driver(d);
 
-		if (notifier->ops->unbind)
-			notifier->ops->unbind(notifier, sd, sd->asd);
+		v4l2_async_notifier_call_void_op(notifier, unbind, sd, sd->asd);
 
 		/*
 		 * Store device at the device cache, in order to call
@@ -344,8 +340,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 
 	v4l2_async_cleanup(sd);
 
-	if (notifier->ops->unbind)
-		notifier->ops->unbind(notifier, sd, sd->asd);
+	v4l2_async_notifier_call_void_op(notifier, unbind, sd, sd->asd);
 
 	mutex_unlock(&list_lock);
 }
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 3c48f8b66d12..c3e001e0d1f1 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -95,6 +95,14 @@ struct v4l2_async_notifier_operations {
 		       struct v4l2_async_subdev *asd);
 };
 
+#define v4l2_async_notifier_call_int_op(n, op, ...)			\
+	(((n)->ops && (n)->ops->op) ? (n)->ops->op(n, ## __VA_ARGS__) : 0)
+#define v4l2_async_notifier_call_void_op(n, op, ...)	 \
+	do {						 \
+		if ((n)->ops && (n)->ops->op)		 \
+			(n)->ops->op(n, ## __VA_ARGS__); \
+	} while (false)
+
 /**
  * struct v4l2_async_notifier - v4l2_device notifier data
  *
-- 
2.11.0
