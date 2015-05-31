Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37421 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272AbbEaWZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 18:25:47 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, linux-leds@vger.kernel.org,
	j.anaszewski@samsung.com, cooloney@gmail.com,
	s.nawrocki@samsung.com, mchehab@osg.samsung.com,
	g.liakhovetski@gmx.de
Subject: [PATCH v1.1 1/5] v4l: async: Add a pointer to of_node to struct v4l2_subdev, match it
Date: Mon,  1 Jun 2015 01:24:39 +0300
Message-Id: <1433111079-22457-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4071589.mUaJIGvIJX@avalon>
References: <4071589.mUaJIGvIJX@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 async sub-devices are currently matched (OF case) based on the struct
device_node pointer in struct device. LED devices may have more than one
LED, and in that case the OF node to match is not directly the device's
node, but a LED's node.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since v1:

- Move conditional setting of struct v4l2_subdev.of_node from
  v4l2_device_register_subdev() to v4l2_async_register_subdev.

- Remove the check for NULL struct v4l2_subdev.of_node from match_of() as
  it's no longer needed.

- Unconditionally state in the struct v4l2_subdev.of_node field comment that
  the field contains (a pointer to) the sub-device's of_node.

 drivers/media/v4l2-core/v4l2-async.c | 34 ++++++++++++++++++++++------------
 include/media/v4l2-subdev.h          |  2 ++
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 85a6a34..b0badac 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -22,10 +22,10 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 #if IS_ENABLED(CONFIG_I2C)
-	struct i2c_client *client = i2c_verify_client(dev);
+	struct i2c_client *client = i2c_verify_client(sd->dev);
 	return client &&
 		asd->match.i2c.adapter_id == client->adapter->nr &&
 		asd->match.i2c.address == client->addr;
@@ -34,14 +34,24 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 #endif
 }
 
-static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_devname(struct v4l2_subdev *sd,
+			  struct v4l2_async_subdev *asd)
 {
-	return !strcmp(asd->match.device_name.name, dev_name(dev));
+	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
-static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return dev->of_node == asd->match.of.node;
+	return sd->of_node == asd->match.of.node;
+}
+
+static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
+{
+	if (!asd->match.custom.match)
+		/* Match always */
+		return true;
+
+	return asd->match.custom.match(sd->dev, asd);
 }
 
 static LIST_HEAD(subdev_list);
@@ -51,17 +61,14 @@ static DEFINE_MUTEX(list_lock);
 static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
 						    struct v4l2_subdev *sd)
 {
+	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
 	struct v4l2_async_subdev *asd;
-	bool (*match)(struct device *, struct v4l2_async_subdev *);
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
 		/* bus_type has been verified valid before */
 		switch (asd->match_type) {
 		case V4L2_ASYNC_MATCH_CUSTOM:
-			match = asd->match.custom.match;
-			if (!match)
-				/* Match always */
-				return asd;
+			match = match_custom;
 			break;
 		case V4L2_ASYNC_MATCH_DEVNAME:
 			match = match_devname;
@@ -79,7 +86,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 		}
 
 		/* match cannot be NULL here */
-		if (match(sd->dev, asd))
+		if (match(sd, asd))
 			return asd;
 	}
 
@@ -266,6 +273,9 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *notifier;
 
+	if (!sd->of_node && sd->dev)
+		sd->of_node = sd->dev->of_node;
+
 	mutex_lock(&list_lock);
 
 	INIT_LIST_HEAD(&sd->async_list);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 8f5da73..8a17c24 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -603,6 +603,8 @@ struct v4l2_subdev {
 	struct video_device *devnode;
 	/* pointer to the physical device, if any */
 	struct device *dev;
+	/* A device_node of the subdev, usually the same as dev->of_node. */
+	struct device_node *of_node;
 	/* Links this subdev to a global subdev_list or @notifier->done list. */
 	struct list_head async_list;
 	/* Pointer to respective struct v4l2_async_subdev. */
-- 
2.1.4

