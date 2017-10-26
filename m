Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39018 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751973AbdJZHyA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 03:54:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v16 04/32] v4l: async: Fix notifier complete callback error handling
Date: Thu, 26 Oct 2017 10:53:14 +0300
Message-Id: <20171026075342.5760-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The notifier complete callback may return an error. This error code was
simply returned to the caller but never handled properly.

Move calling the complete callback function to the caller from
v4l2_async_test_notify and undo the work that was done either in async
sub-device or async notifier registration.

Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 78 +++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 18 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ca281438a0ae..4924481451ca 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -122,9 +122,6 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	/* Move from the global subdevice list to notifier's done */
 	list_move(&sd->async_list, &notifier->done);
 
-	if (list_empty(&notifier->waiting) && notifier->complete)
-		return notifier->complete(notifier);
-
 	return 0;
 }
 
@@ -136,11 +133,27 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	sd->asd = NULL;
 }
 
+static void v4l2_async_notifier_unbind_all_subdevs(
+	struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd, *tmp;
+
+	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, sd->asd);
+
+		v4l2_async_cleanup(sd);
+
+		list_move(&sd->async_list, &subdev_list);
+	}
+}
+
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
 	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
+	int ret;
 	int i;
 
 	if (!v4l2_dev || !notifier->num_subdevs ||
@@ -185,19 +198,30 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		}
 	}
 
+	if (list_empty(&notifier->waiting) && notifier->complete) {
+		ret = notifier->complete(notifier);
+		if (ret)
+			goto err_complete;
+	}
+
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
 	mutex_unlock(&list_lock);
 
 	return 0;
+
+err_complete:
+	v4l2_async_notifier_unbind_all_subdevs(notifier);
+
+	mutex_unlock(&list_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
 void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_subdev *sd, *tmp;
-
 	if (!notifier->v4l2_dev)
 		return;
 
@@ -205,14 +229,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
 	list_del(&notifier->list);
 
-	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asd);
-
-		v4l2_async_cleanup(sd);
-
-		list_move(&sd->async_list, &subdev_list);
-	}
+	v4l2_async_notifier_unbind_all_subdevs(notifier);
 
 	mutex_unlock(&list_lock);
 
@@ -223,6 +240,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
 int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *notifier;
+	int ret;
 
 	/*
 	 * No reference taken. The reference is held by the device
@@ -238,19 +256,43 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 
 	list_for_each_entry(notifier, &notifier_list, list) {
 		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
-		if (asd) {
-			int ret = v4l2_async_test_notify(notifier, sd, asd);
-			mutex_unlock(&list_lock);
-			return ret;
-		}
+		int ret;
+
+		if (!asd)
+			continue;
+
+		ret = v4l2_async_test_notify(notifier, sd, asd);
+		if (ret)
+			goto err_unlock;
+
+		if (!list_empty(&notifier->waiting) || !notifier->complete)
+			goto out_unlock;
+
+		ret = notifier->complete(notifier);
+		if (ret)
+			goto err_cleanup;
+
+		goto out_unlock;
 	}
 
 	/* None matched, wait for hot-plugging */
 	list_add(&sd->async_list, &subdev_list);
 
+out_unlock:
 	mutex_unlock(&list_lock);
 
 	return 0;
+
+err_cleanup:
+	if (notifier->unbind)
+		notifier->unbind(notifier, sd, sd->asd);
+
+	v4l2_async_cleanup(sd);
+
+err_unlock:
+	mutex_unlock(&list_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_register_subdev);
 
-- 
2.11.0
