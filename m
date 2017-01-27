Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:4146 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932526AbdA0KdA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 05:33:00 -0500
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] [media] v4l2-async: failing functions shouldn't have side effects
Date: Fri, 27 Jan 2017 12:32:56 +0200
Message-Id: <1485513176-6958-1-git-send-email-tuukka.toivonen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-async had several functions doing some operations and then
not undoing the operations in a failure situation. For example,
v4l2_async_test_notify() moved a subdev into notifier's done list
even if registering the subdev (v4l2_device_register_subdev) failed.
If the subdev was allocated and v4l2_async_register_subdev() called
from the driver's probe() function, as usually, the probe()
function freed the allocated subdev and returned a failure.
Nevertheless, the subdev was still left into the notifier's done
list, causing an access to already freed memory when the notifier
was later unregistered.

A hand-edited call trace leaving freed subdevs into the notifier:

v4l2_async_register_notifier(notifier, asd)
cameradrv_probe
 sd = devm_kzalloc()
 v4l2_async_register_subdev(sd)
  v4l2_async_test_notify(notifier, sd, asd)
   list_move(sd, &notifier->done)
   v4l2_device_register_subdev(notifier->v4l2_dev, sd)
    cameradrv_registered(sd) -> fails
->v4l2_async_register_subdev returns failure
->cameradrv_probe returns failure
->devres frees the allocated sd
->sd was freed but it still remains in the notifier's list.

This patch fixes this and several other cases where a failing
function could leave nodes into a linked list while the caller
might free the node due to a failure.

Signed-off-by: Tuukka Toivonen <tuukka.toivonen@intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada20..82d7530 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -99,18 +99,11 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 {
 	int ret;
 
-	/* Remove from the waiting list */
-	list_del(&asd->list);
-	sd->asd = asd;
-	sd->notifier = notifier;
-
 	if (notifier->bound) {
 		ret = notifier->bound(notifier, sd, asd);
 		if (ret < 0)
 			return ret;
 	}
-	/* Move from the global subdevice list to notifier's done */
-	list_move(&sd->async_list, &notifier->done);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
@@ -119,6 +112,14 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 		return ret;
 	}
 
+	/* Remove from the waiting list */
+	list_del(&asd->list);
+	sd->asd = asd;
+	sd->notifier = notifier;
+
+	/* Move from the global subdevice list to notifier's done */
+	list_move(&sd->async_list, &notifier->done);
+
 	if (list_empty(&notifier->waiting) && notifier->complete)
 		return notifier->complete(notifier);
 
@@ -168,9 +169,6 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 
 	mutex_lock(&list_lock);
 
-	/* Keep also completed notifiers on the list */
-	list_add(&notifier->list, &notifier_list);
-
 	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
 		int ret;
 
@@ -185,6 +183,9 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		}
 	}
 
+	/* Keep also completed notifiers on the list */
+	list_add(&notifier->list, &notifier_list);
+
 	mutex_unlock(&list_lock);
 
 	return 0;
-- 
1.9.1

