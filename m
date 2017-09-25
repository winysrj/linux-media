Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49336 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754190AbdIYWZr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 18:25:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v14 03/28] v4l: async: Use more intuitive names for internal functions
Date: Tue, 26 Sep 2017 01:25:14 +0300
Message-Id: <20170925222540.371-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170925222540.371-1-sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename internal functions to make the names of the functions better
describe what they do.

	Old name			New name
	v4l2_async_test_notify	v4l2_async_match_notify
	v4l2_async_belongs	v4l2_async_find_match

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 60a1a50b9537..60ac2f4fc69e 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -60,8 +60,8 @@ static LIST_HEAD(subdev_list);
 static LIST_HEAD(notifier_list);
 static DEFINE_MUTEX(list_lock);
 
-static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
-						    struct v4l2_subdev *sd)
+static struct v4l2_async_subdev *v4l2_async_find_match(
+	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
 {
 	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
 	struct v4l2_async_subdev *asd;
@@ -95,9 +95,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 	return NULL;
 }
 
-static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
-				  struct v4l2_subdev *sd,
-				  struct v4l2_async_subdev *asd)
+static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *sd,
+				   struct v4l2_async_subdev *asd)
 {
 	int ret;
 
@@ -175,11 +175,11 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
 		int ret;
 
-		asd = v4l2_async_belongs(notifier, sd);
+		asd = v4l2_async_find_match(notifier, sd);
 		if (!asd)
 			continue;
 
-		ret = v4l2_async_test_notify(notifier, sd, asd);
+		ret = v4l2_async_match_notify(notifier, sd, asd);
 		if (ret < 0) {
 			mutex_unlock(&list_lock);
 			return ret;
@@ -238,9 +238,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	INIT_LIST_HEAD(&sd->async_list);
 
 	list_for_each_entry(notifier, &notifier_list, list) {
-		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, sd);
+		struct v4l2_async_subdev *asd = v4l2_async_find_match(notifier,
+								      sd);
 		if (asd) {
-			int ret = v4l2_async_test_notify(notifier, sd, asd);
+			int ret = v4l2_async_match_notify(notifier, sd, asd);
 			mutex_unlock(&list_lock);
 			return ret;
 		}
-- 
2.11.0
