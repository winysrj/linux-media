Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20616 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbcD2IqU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 04:46:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: [PATCH 3/3] media: Refactor IOCTL handler calling
Date: Fri, 29 Apr 2016 11:43:20 +0300
Message-Id: <1461919400-2658-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the switch by a nice array of supported IOCTLs, just like in V4L2.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 58 +++++++++++++++-----------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4a66a2d5..8a4daf9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -363,18 +363,22 @@ static long media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
-#define MEDIA_IOC(__cmd) \
-	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
+#define MEDIA_IOC(__cmd, func)						\
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
+		.cmd = MEDIA_IOC_##__cmd,				\
+		.fn = (long (*)(struct media_device *, void *))func,	\
+	}
 
 /* the table is indexed by _IOC_NR(cmd) */
-static const struct {
+static const struct media_ioctl_info {
 	unsigned int cmd;
+	long (*fn)(struct media_device *dev, void *arg);
 } media_ioctl_info[] = {
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
 
 static unsigned int media_ioctl_max_arg_size(void) {
@@ -395,11 +399,15 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = to_media_device(devnode);
+	const struct media_ioctl_info *info;
 	char karg[media_ioctl_max_arg_size()];
 	long ret;
 
-	if (_IOC_NR(cmd) >= ARRAY_SIZE(media_ioctl_info)
-	    || media_ioctl_info[_IOC_NR(cmd)].cmd != cmd)
+	if (_IOC_NR(cmd) >= ARRAY_SIZE(media_ioctl_info))
+		return -ENOIOCTLCMD;
+
+	info = &media_ioctl_info[_IOC_NR(cmd)];
+	if (info->cmd != cmd)
 		return -ENOIOCTLCMD;
 
 	/* All media IOCTLs are _IOWR() */
@@ -407,35 +415,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		return -EFAULT;
 
 	mutex_lock(&dev->graph_mutex);
-	switch (cmd) {
-	case MEDIA_IOC_DEVICE_INFO:
-		ret = media_device_get_info(dev,
-				(struct media_device_info *)karg);
-		break;
-
-	case MEDIA_IOC_ENUM_ENTITIES:
-		ret = media_device_enum_entities(dev,
-				(struct media_entity_desc *)karg);
-		break;
-
-	case MEDIA_IOC_ENUM_LINKS:
-		ret = media_device_enum_links(dev,
-				(struct media_links_enum *)karg);
-		break;
-
-	case MEDIA_IOC_SETUP_LINK:
-		ret = media_device_setup_link(dev,
-				(struct media_link_desc *)karg);
-		break;
-
-	case MEDIA_IOC_G_TOPOLOGY:
-		ret = media_device_get_topology(dev,
-				(struct media_v2_topology *)karg);
-		break;
-
-	default:
-		ret = -ENOIOCTLCMD;
-	}
+	ret = info->fn(dev, karg);
 	mutex_unlock(&dev->graph_mutex);
 
 	if (!ret && copy_to_user((void *)arg, karg, _IOC_SIZE(cmd)))
-- 
1.9.1

