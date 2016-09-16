Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:58700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761994AbcIPLuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:50:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        mchehab@s-opensource.com
Subject: [PATCH v5 2/4] media: Unify IOCTL handler calling
Date: Fri, 16 Sep 2016 14:49:06 +0300
Message-Id: <1474026548-28829-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each IOCTL handler can be listed in an array instead of using a large and
cumbersome switch. Do that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 51 +++++++++++++-------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index f321264..4ac912b 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -419,20 +419,24 @@ static long media_device_get_topology(struct media_device *mdev,
 	return 0;
 }
 
-#define MEDIA_IOC(__cmd) \
-	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
+#define MEDIA_IOC(__cmd, func)						\
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
+		.cmd = MEDIA_IOC_##__cmd,				\
+		.fn = (long (*)(struct media_device *, void __user *))func,    \
+	}
 
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
+	long (*fn)(struct media_device *dev, void __user *arg);
 };
 
 static const struct media_ioctl_info ioctl_info[] = {
-	MEDIA_IOC(DEVICE_INFO),
-	MEDIA_IOC(ENUM_ENTITIES),
-	MEDIA_IOC(ENUM_LINKS),
-	MEDIA_IOC(SETUP_LINK),
-	MEDIA_IOC(G_TOPOLOGY),
+	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
+	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
+	MEDIA_IOC(ENUM_LINKS, media_device_enum_links),
+	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
+	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -440,42 +444,17 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = devnode->media_dev;
+	const struct media_ioctl_info *info;
 	long ret;
 
 	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
 	    || ioctl_info[_IOC_NR(cmd)].cmd != cmd)
 		return -ENOIOCTLCMD;
 
-	mutex_lock(&dev->graph_mutex);
-	switch (cmd) {
-	case MEDIA_IOC_DEVICE_INFO:
-		ret = media_device_get_info(dev,
-				(struct media_device_info __user *)arg);
-		break;
-
-	case MEDIA_IOC_ENUM_ENTITIES:
-		ret = media_device_enum_entities(dev,
-				(struct media_entity_desc __user *)arg);
-		break;
-
-	case MEDIA_IOC_ENUM_LINKS:
-		ret = media_device_enum_links(dev,
-				(struct media_links_enum __user *)arg);
-		break;
+	info = &ioctl_info[_IOC_NR(cmd)];
 
-	case MEDIA_IOC_SETUP_LINK:
-		ret = media_device_setup_link(dev,
-				(struct media_link_desc __user *)arg);
-		break;
-
-	case MEDIA_IOC_G_TOPOLOGY:
-		ret = media_device_get_topology(dev,
-				(struct media_v2_topology __user *)arg);
-		break;
-
-	default:
-		ret = -ENOIOCTLCMD;
-	}
+	mutex_lock(&dev->graph_mutex);
+	ret = info->fn(dev, (void __user *)arg);
 	mutex_unlock(&dev->graph_mutex);
 
 	return ret;
-- 
2.7.4

