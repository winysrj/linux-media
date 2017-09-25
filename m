Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49498 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935905AbdIYWZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 18:25:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v14 16/28] v4l: async: Ensure only unique fwnodes are registered to notifiers
Date: Tue, 26 Sep 2017 01:25:27 +0300
Message-Id: <20170925222540.371-17-sakari.ailus@linux.intel.com>
In-Reply-To: <20170925222540.371-1-sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While registering a notifier, check that each newly added fwnode is
unique, and return an error if it is not. Also check that a newly added
notifier does not have the same fwnodes twice.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 88 ++++++++++++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 735f72f81740..470607da96b2 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -307,8 +307,71 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	sd->dev = NULL;
 }
 
+/* See if an fwnode can be found in a notifier's lists. */
+static bool __v4l2_async_notifier_fwnode_has_async_subdev(
+	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode)
+{
+	struct v4l2_async_subdev *asd;
+	struct v4l2_subdev *sd;
+
+	list_for_each_entry(asd, &notifier->waiting, list) {
+		if (asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
+			continue;
+
+		if (asd->match.fwnode.fwnode == fwnode)
+			return true;
+	}
+
+	list_for_each_entry(sd, &notifier->done, async_list) {
+		if (WARN_ON(!sd->asd))
+			continue;
+
+		if (sd->asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
+			continue;
+
+		if (sd->asd->match.fwnode.fwnode == fwnode)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Find out whether an async sub-device was set up for an fwnode already or
+ * whether it exists in a given notifier before @this_index.
+ */
+static bool v4l2_async_notifier_fwnode_has_async_subdev(
+	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode,
+	unsigned int this_index)
+{
+	unsigned int j;
+
+	lockdep_assert_held(&list_lock);
+
+	/* Check that an fwnode is not being added more than once. */
+	for (j = 0; j < this_index; j++) {
+		struct v4l2_async_subdev *asd = notifier->subdevs[this_index];
+		struct v4l2_async_subdev *other_asd = notifier->subdevs[j];
+
+		if (other_asd->match_type == V4L2_ASYNC_MATCH_FWNODE &&
+		    asd->match.fwnode.fwnode ==
+		    other_asd->match.fwnode.fwnode)
+			return true;
+	}
+
+	/* Check than an fwnode did not exist in other notifiers. */
+	list_for_each_entry(notifier, &notifier_list, list)
+		if (__v4l2_async_notifier_fwnode_has_async_subdev(
+			    notifier, fwnode))
+			return true;
+
+	return false;
+}
+
 static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 {
+	struct device *dev =
+		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
 	struct v4l2_async_subdev *asd;
 	int ret;
 	int i;
@@ -319,6 +382,8 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
 
+	mutex_lock(&list_lock);
+
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdevs[i];
 
@@ -326,30 +391,35 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 		case V4L2_ASYNC_MATCH_CUSTOM:
 		case V4L2_ASYNC_MATCH_DEVNAME:
 		case V4L2_ASYNC_MATCH_I2C:
+			break;
 		case V4L2_ASYNC_MATCH_FWNODE:
+			if (v4l2_async_notifier_fwnode_has_async_subdev(
+				    notifier, asd->match.fwnode.fwnode, i)) {
+				dev_err(dev,
+					"fwnode has already been registered or in notifier's subdev list\n");
+				ret = -EEXIST;
+				goto out_unlock;
+			}
 			break;
 		default:
-			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
-				"Invalid match type %u on %p\n",
+			dev_err(dev, "Invalid match type %u on %p\n",
 				asd->match_type, asd);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_unlock;
 		}
 		list_add_tail(&asd->list, &notifier->waiting);
 	}
 
-	mutex_lock(&list_lock);
-
 	ret = v4l2_async_notifier_try_all_subdevs(notifier);
-	if (ret) {
-		mutex_unlock(&list_lock);
-		return ret;
-	}
+	if (ret)
+		goto out_unlock;
 
 	ret = v4l2_async_notifier_try_complete(notifier);
 
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
 
+out_unlock:
 	mutex_unlock(&list_lock);
 
 	return ret;
-- 
2.11.0
