Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:4931 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbcGULPj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 07:15:39 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH v3 1/5] media: Determine early whether an IOCTL is supported
Date: Thu, 21 Jul 2016 14:14:40 +0300
Message-Id: <1469099686-10938-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Preparation for refactoring media IOCTL handling to unify common parts.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 48 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1795abe..3ac526d 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -419,13 +419,33 @@ static long media_device_get_topology(struct media_device *mdev,
 	return 0;
 }
 
-static long media_device_ioctl(struct file *filp, unsigned int cmd,
-			       unsigned long arg)
+#define MEDIA_IOC(__cmd) \
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
+
+/* the table is indexed by _IOC_NR(cmd) */
+struct media_ioctl_info {
+	unsigned int cmd;
+};
+
+static inline long is_valid_ioctl(const struct media_ioctl_info *info,
+				  unsigned int len, unsigned int cmd)
+{
+	return (_IOC_NR(cmd) >= len
+		|| info[_IOC_NR(cmd)].cmd != cmd) ? -ENOIOCTLCMD : 0;
+}
+
+static long __media_device_ioctl(
+	struct file *filp, unsigned int cmd, void __user *arg,
+	const struct media_ioctl_info *info_array, unsigned int info_array_len)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = devnode->media_dev;
 	long ret;
 
+	ret = is_valid_ioctl(info_array, info_array_len, cmd);
+	if (ret)
+		return ret;
+
 	mutex_lock(&dev->graph_mutex);
 	switch (cmd) {
 	case MEDIA_IOC_DEVICE_INFO:
@@ -461,6 +481,22 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	return ret;
 }
 
+static const struct media_ioctl_info ioctl_info[] = {
+	MEDIA_IOC(DEVICE_INFO),
+	MEDIA_IOC(ENUM_ENTITIES),
+	MEDIA_IOC(ENUM_LINKS),
+	MEDIA_IOC(SETUP_LINK),
+	MEDIA_IOC(G_TOPOLOGY),
+};
+
+static long media_device_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	return __media_device_ioctl(
+		filp, cmd, (void __user *)arg,
+		ioctl_info, ARRAY_SIZE(ioctl_info));
+}
+
 #ifdef CONFIG_COMPAT
 
 struct media_links_enum32 {
@@ -491,6 +527,14 @@ static long media_device_enum_links32(struct media_device *mdev,
 
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
 
+static const struct media_ioctl_info compat_ioctl_info[] = {
+	MEDIA_IOC(DEVICE_INFO),
+	MEDIA_IOC(ENUM_ENTITIES),
+	MEDIA_IOC(ENUM_LINKS32),
+	MEDIA_IOC(SETUP_LINK),
+	MEDIA_IOC(G_TOPOLOGY),
+};
+
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
 				      unsigned long arg)
 {
-- 
2.7.4

