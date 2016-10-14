Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40288 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754070AbcJNRey (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:34:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 01/21] [media] v4l2-async: move code out of v4l2_async_notifier_register into v4l2_async_test_nofity_all
Date: Fri, 14 Oct 2016 19:34:21 +0200
Message-Id: <1476466481-24030-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will be reused in the following patch to catch already registered,
newly added asynchronous subdevices from v4l2_async_register_subdev.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Add missing v4l2_async_test_notify_all() call.
---
 drivers/media/v4l2-core/v4l2-async.c | 38 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada20..1113df4 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -134,11 +134,31 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	sd->dev = NULL;
 }
 
+static int v4l2_async_test_notify_all(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd, *tmp;
+
+	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
+		struct v4l2_async_subdev *asd;
+		int ret;
+
+		asd = v4l2_async_belongs(notifier, sd);
+		if (!asd)
+			continue;
+
+		ret = v4l2_async_test_notify(notifier, sd, asd);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 				 struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_subdev *sd, *tmp;
 	struct v4l2_async_subdev *asd;
+	int ret;
 	int i;
 
 	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
@@ -171,23 +191,11 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
-	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
-		int ret;
-
-		asd = v4l2_async_belongs(notifier, sd);
-		if (!asd)
-			continue;
-
-		ret = v4l2_async_test_notify(notifier, sd, asd);
-		if (ret < 0) {
-			mutex_unlock(&list_lock);
-			return ret;
-		}
-	}
+	ret = v4l2_async_test_notify_all(notifier);
 
 	mutex_unlock(&list_lock);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_async_notifier_register);
 
-- 
2.9.3

