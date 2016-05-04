Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbcEDLYO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:24:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH v2 2/5] media: Unify IOCTL handler calling
Date: Wed,  4 May 2016 14:20:52 +0300
Message-Id: <1462360855-23354-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each IOCTL handler can be listed in an array instead of using a large and
cumbersome switch. Do that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 89 ++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 66 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c24149d..9b5a88d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -419,12 +419,16 @@ static long media_device_get_topology(struct media_device *mdev,
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
 
 static inline long is_valid_ioctl(const struct media_ioctl_info *info,
@@ -440,53 +444,28 @@ static long __media_device_ioctl(
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = to_media_device(devnode);
+	const struct media_ioctl_info *info;
 	long ret;
 
 	ret = is_valid_ioctl(info_array, info_array_len, cmd);
 	if (ret)
 		return ret;
 
+	info = &info_array[_IOC_NR(cmd)];
+
 	mutex_lock(&dev->graph_mutex);
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
-
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
+	ret = info->fn(dev, arg);
 	mutex_unlock(&dev->graph_mutex);
 
 	return ret;
 }
 
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
@@ -528,41 +507,19 @@ static long media_device_enum_links32(struct media_device *mdev,
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
 
 static const struct media_ioctl_info compat_ioctl_info[] = {
-	MEDIA_IOC(DEVICE_INFO),
-	MEDIA_IOC(ENUM_ENTITIES),
-	MEDIA_IOC(ENUM_LINKS32),
-	MEDIA_IOC(SETUP_LINK),
-	MEDIA_IOC(G_TOPOLOGY),
+	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
+	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
+	MEDIA_IOC(ENUM_LINKS32, media_device_enum_links32),
+	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
+	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
 };
 
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 				      unsigned long arg)
 {
-	struct media_devnode *devnode = media_devnode_data(filp);
-	struct media_device *dev = to_media_device(devnode);
-	long ret;
-
-	switch (cmd) {
-	case MEDIA_IOC_DEVICE_INFO:
-	case MEDIA_IOC_ENUM_ENTITIES:
-	case MEDIA_IOC_SETUP_LINK:
-	case MEDIA_IOC_G_TOPOLOGY:
-		return __media_device_ioctl(
-			filp, cmd, (void __user *)arg,
-			compat_ioctl_info, ARRAY_SIZE(compat_ioctl_info));
-
-	case MEDIA_IOC_ENUM_LINKS32:
-		mutex_lock(&dev->graph_mutex);
-		ret = media_device_enum_links32(dev,
-				(struct media_links_enum32 __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
-		break;
-
-	default:
-		ret = -ENOIOCTLCMD;
-	}
-
-	return ret;
+	return __media_device_ioctl(
+		filp, cmd, (void __user *)arg,
+		compat_ioctl_info, ARRAY_SIZE(compat_ioctl_info));
 }
 #endif /* CONFIG_COMPAT */
 
-- 
1.9.1

