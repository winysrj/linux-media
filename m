Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18466 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3GVSFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 14:05:43 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC00L7WNL6IAO0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jul 2013 03:05:31 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 2/5] V4L2: Rename v4l2_async_bus_* to v4l2_async_match_*
Date: Mon, 22 Jul 2013 20:04:44 +0200
Message-id: <1374516287-7638-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum v4l2_async_bus_type also selects a method subdevs are matched
in the notification handlers, rename it to v4l2_async_match_type
so V4L2_ASYNC_MATCH_OF entry can be further added for matching by
device tree node pointer.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |    2 +-
 drivers/media/v4l2-core/v4l2-async.c           |   26 ++++++++++++------------
 include/media/v4l2-async.h                     |   12 +++++------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 2dd0e52..8af572b 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1475,7 +1475,7 @@ static int scan_async_group(struct soc_camera_host *ici,
 			break;
 	}
 
-	if (i == size || asd[i]->bus_type != V4L2_ASYNC_BUS_I2C) {
+	if (i == size || asd[i]->match_type != V4L2_ASYNC_MATCH_I2C) {
 		/* All useless */
 		dev_err(ici->v4l2_dev.dev, "No I2C data source found!\n");
 		return -ENODEV;
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ff87c29..86934ca 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -34,9 +34,9 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 #endif
 }
 
-static bool match_platform(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
 {
-	return !strcmp(asd->match.platform.name, dev_name(dev));
+	return !strcmp(asd->match.device_name.name, dev_name(dev));
 }
 
 static LIST_HEAD(subdev_list);
@@ -53,17 +53,17 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
 		/* bus_type has been verified valid before */
-		switch (asd->bus_type) {
-		case V4L2_ASYNC_BUS_CUSTOM:
+		switch (asd->match_type) {
+		case V4L2_ASYNC_MATCH_CUSTOM:
 			match = asd->match.custom.match;
 			if (!match)
 				/* Match always */
 				return asd;
 			break;
-		case V4L2_ASYNC_BUS_PLATFORM:
-			match = match_platform;
+		case V4L2_ASYNC_MATCH_DEVNAME:
+			match = match_devname;
 			break;
-		case V4L2_ASYNC_BUS_I2C:
+		case V4L2_ASYNC_MATCH_I2C:
 			match = match_i2c;
 			break;
 		default:
@@ -141,15 +141,15 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdev[i];
 
-		switch (asd->bus_type) {
-		case V4L2_ASYNC_BUS_CUSTOM:
-		case V4L2_ASYNC_BUS_PLATFORM:
-		case V4L2_ASYNC_BUS_I2C:
+		switch (asd->match_type) {
+		case V4L2_ASYNC_MATCH_CUSTOM:
+		case V4L2_ASYNC_MATCH_DEVNAME:
+		case V4L2_ASYNC_MATCH_I2C:
 			break;
 		default:
 			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
-				"Invalid bus-type %u on %p\n",
-				asd->bus_type, asd);
+				"Invalid match type %u on %p\n",
+				asd->match_type, asd);
 			return -EINVAL;
 		}
 		list_add_tail(&asd->list, &notifier->waiting);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index c3ec6ac..33e3b2a 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -22,10 +22,10 @@ struct v4l2_async_notifier;
 /* A random max subdevice number, used to allocate an array on stack */
 #define V4L2_MAX_SUBDEVS 128U
 
-enum v4l2_async_bus_type {
-	V4L2_ASYNC_BUS_CUSTOM,
-	V4L2_ASYNC_BUS_PLATFORM,
-	V4L2_ASYNC_BUS_I2C,
+enum v4l2_async_match_type {
+	V4L2_ASYNC_MATCH_CUSTOM,
+	V4L2_ASYNC_MATCH_DEVNAME,
+	V4L2_ASYNC_MATCH_I2C,
 };
 
 /**
@@ -36,11 +36,11 @@ enum v4l2_async_bus_type {
  *		probed, to a notifier->waiting list
  */
 struct v4l2_async_subdev {
-	enum v4l2_async_bus_type bus_type;
+	enum v4l2_async_match_type match_type;
 	union {
 		struct {
 			const char *name;
-		} platform;
+		} device_name;
 		struct {
 			int adapter_id;
 			unsigned short address;
-- 
1.7.9.5

