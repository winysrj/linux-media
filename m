Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54616 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbdEBQyf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 12:54:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>, hverkuil@xs4all.nl,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l2-async: add v4l2_async_match()
Date: Tue,  2 May 2017 18:54:13 +0200
Message-Id: <20170502165413.7559-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For drivers registering notifiers with more then one subdevices it's
difficult to know exactly which one is being bound in each call to the
notifiers bound callback. Comparing OF nodes became harder after the
introduction of fwnode where the two following comparisons are not equal
but where so previous to fwnode.

asd.match.fwnode.fwnode == of_fwnode_handle(subdev->dev->of_node)

asd.match.fwnode.fwnode == of_fwnode_handle(subdev->of_node)

It's also not ideal to directly access the asd.match union without first
checking the match_type. So to make it easier for drivers to perform
this type of matching export the v4l2 async match helpers with a new
symbol v4l2_async_match(). This wold replace the comparisons above with:

v4l2_async_match(subdev, &asd)

Suggested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 52 +++++++++++++++++++++---------------
 include/media/v4l2-async.h           | 11 ++++++++
 2 files changed, 41 insertions(+), 22 deletions(-)

Depends on '[PATCH v3 0/7] V4L2 fwnode support' and tested on Renesas 
R-Car H3 and M3-W together with rcar-vin Gen3 patches.

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index cbd919d4edd27e17..c291ffda4d18202b 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -60,6 +60,35 @@ static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 	return asd->match.custom.match(sd->dev, asd);
 }
 
+bool v4l2_async_match(struct v4l2_subdev *sd,
+		      struct v4l2_async_subdev *asd)
+{
+	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
+
+	switch (asd->match_type) {
+	case V4L2_ASYNC_MATCH_CUSTOM:
+		match = match_custom;
+		break;
+	case V4L2_ASYNC_MATCH_DEVNAME:
+		match = match_devname;
+		break;
+	case V4L2_ASYNC_MATCH_I2C:
+		match = match_i2c;
+		break;
+	case V4L2_ASYNC_MATCH_FWNODE:
+		match = match_fwnode;
+		break;
+	default:
+		/* Cannot happen, unless someone breaks us */
+		WARN_ON(true);
+		return false;
+	}
+
+	/* match cannot be NULL here */
+	return match(sd, asd);
+}
+EXPORT_SYMBOL(v4l2_async_match);
+
 static LIST_HEAD(subdev_list);
 static LIST_HEAD(notifier_list);
 static DEFINE_MUTEX(list_lock);
@@ -67,32 +96,11 @@ static DEFINE_MUTEX(list_lock);
 static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
 						    struct v4l2_subdev *sd)
 {
-	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
 	struct v4l2_async_subdev *asd;
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
 		/* bus_type has been verified valid before */
-		switch (asd->match_type) {
-		case V4L2_ASYNC_MATCH_CUSTOM:
-			match = match_custom;
-			break;
-		case V4L2_ASYNC_MATCH_DEVNAME:
-			match = match_devname;
-			break;
-		case V4L2_ASYNC_MATCH_I2C:
-			match = match_i2c;
-			break;
-		case V4L2_ASYNC_MATCH_FWNODE:
-			match = match_fwnode;
-			break;
-		default:
-			/* Cannot happen, unless someone breaks us */
-			WARN_ON(true);
-			return NULL;
-		}
-
-		/* match cannot be NULL here */
-		if (match(sd, asd))
+		if (v4l2_async_match(sd, asd))
 			return asd;
 	}
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index c69d8c8a66d0093a..45677387282919d7 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -135,4 +135,15 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd);
  * @sd: pointer to &struct v4l2_subdev
  */
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
+
+/**
+ * v4l2_async_match - match a subdevice with a asynchronous subdevice descriptor
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @asd: pointer to &struct v4l2_async_subdev
+ *
+ * Return: true if @asd matches @sd else false
+ */
+bool v4l2_async_match(struct v4l2_subdev *sd,
+		      struct v4l2_async_subdev *asd);
 #endif
-- 
2.12.2
