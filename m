Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37338 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933582AbeF2Suu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 14:50:50 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/17] media: v4l2: async: Allow searching for asd of any type
Date: Fri, 29 Jun 2018 11:49:46 -0700
Message-Id: <1530298220-5097-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
References: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Generalize v4l2_async_notifier_fwnode_has_async_subdev() to allow
searching for any type of async subdev, not just fwnodes. Rename to
v4l2_async_notifier_has_async_subdev() and pass it an asd pointer.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v4:
- none
Changes since v3:
- removed TODO to support asd compare with CUSTOM match type in
  asd_equal().
Changes since v2:
- code optimization in asd_equal(), and remove unneeded braces,
  suggested by Sakari Ailus.
Changes since v1:
- none
---
 drivers/media/v4l2-core/v4l2-async.c | 73 +++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 2b08d03..0e7e529 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -124,6 +124,31 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
 	return NULL;
 }
 
+/* Compare two asd's for equivalence */
+static bool asd_equal(struct v4l2_async_subdev *asd_x,
+		      struct v4l2_async_subdev *asd_y)
+{
+	if (asd_x->match_type != asd_y->match_type)
+		return false;
+
+	switch (asd_x->match_type) {
+	case V4L2_ASYNC_MATCH_DEVNAME:
+		return strcmp(asd_x->match.device_name,
+			      asd_y->match.device_name) == 0;
+	case V4L2_ASYNC_MATCH_I2C:
+		return asd_x->match.i2c.adapter_id ==
+			asd_y->match.i2c.adapter_id &&
+			asd_x->match.i2c.address ==
+			asd_y->match.i2c.address;
+	case V4L2_ASYNC_MATCH_FWNODE:
+		return asd_x->match.fwnode == asd_y->match.fwnode;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /* Find the sub-device notifier registered by a sub-device driver. */
 static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
 	struct v4l2_subdev *sd)
@@ -308,29 +333,22 @@ static void v4l2_async_notifier_unbind_all_subdevs(
 	notifier->parent = NULL;
 }
 
-/* See if an fwnode can be found in a notifier's lists. */
-static bool __v4l2_async_notifier_fwnode_has_async_subdev(
-	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode)
+/* See if an async sub-device can be found in a notifier's lists. */
+static bool __v4l2_async_notifier_has_async_subdev(
+	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd)
 {
-	struct v4l2_async_subdev *asd;
+	struct v4l2_async_subdev *asd_y;
 	struct v4l2_subdev *sd;
 
-	list_for_each_entry(asd, &notifier->waiting, list) {
-		if (asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
-			continue;
-
-		if (asd->match.fwnode == fwnode)
+	list_for_each_entry(asd_y, &notifier->waiting, list)
+		if (asd_equal(asd, asd_y))
 			return true;
-	}
 
 	list_for_each_entry(sd, &notifier->done, async_list) {
 		if (WARN_ON(!sd->asd))
 			continue;
 
-		if (sd->asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
-			continue;
-
-		if (sd->asd->match.fwnode == fwnode)
+		if (asd_equal(asd, sd->asd))
 			return true;
 	}
 
@@ -338,32 +356,28 @@ static bool __v4l2_async_notifier_fwnode_has_async_subdev(
 }
 
 /*
- * Find out whether an async sub-device was set up for an fwnode already or
+ * Find out whether an async sub-device was set up already or
  * whether it exists in a given notifier before @this_index.
  */
-static bool v4l2_async_notifier_fwnode_has_async_subdev(
-	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode,
+static bool v4l2_async_notifier_has_async_subdev(
+	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd,
 	unsigned int this_index)
 {
 	unsigned int j;
 
 	lockdep_assert_held(&list_lock);
 
-	/* Check that an fwnode is not being added more than once. */
+	/* Check that an asd is not being added more than once. */
 	for (j = 0; j < this_index; j++) {
-		struct v4l2_async_subdev *asd = notifier->subdevs[this_index];
-		struct v4l2_async_subdev *other_asd = notifier->subdevs[j];
+		struct v4l2_async_subdev *asd_y = notifier->subdevs[j];
 
-		if (other_asd->match_type == V4L2_ASYNC_MATCH_FWNODE &&
-		    asd->match.fwnode ==
-		    other_asd->match.fwnode)
+		if (asd_equal(asd, asd_y))
 			return true;
 	}
 
-	/* Check than an fwnode did not exist in other notifiers. */
+	/* Check that an asd does not exist in other notifiers. */
 	list_for_each_entry(notifier, &notifier_list, list)
-		if (__v4l2_async_notifier_fwnode_has_async_subdev(
-			    notifier, fwnode))
+		if (__v4l2_async_notifier_has_async_subdev(notifier, asd))
 			return true;
 
 	return false;
@@ -392,12 +406,11 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 		case V4L2_ASYNC_MATCH_CUSTOM:
 		case V4L2_ASYNC_MATCH_DEVNAME:
 		case V4L2_ASYNC_MATCH_I2C:
-			break;
 		case V4L2_ASYNC_MATCH_FWNODE:
-			if (v4l2_async_notifier_fwnode_has_async_subdev(
-				    notifier, asd->match.fwnode, i)) {
+			if (v4l2_async_notifier_has_async_subdev(
+				    notifier, asd, i)) {
 				dev_err(dev,
-					"fwnode has already been registered or in notifier's subdev list\n");
+					"asd has already been registered or in notifier's subdev list\n");
 				ret = -EEXIST;
 				goto err_unlock;
 			}
-- 
2.7.4
