Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:36434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbcHKUae (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 16:30:34 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
Subject: [PATCH v4 4/5] media: Add flags to tell whether to take graph mutex for an IOCTL
Date: Thu, 11 Aug 2016 23:29:17 +0300
Message-Id: <1470947358-31168-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New IOCTLs (especially for the request API) do not necessarily need the
graph mutex acquired. Leave this up to the drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 47 ++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d1b47a4..6f565a2 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -381,31 +381,36 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
 	return 0;
 }
 
-#define MEDIA_IOC_ARG(__cmd, func, from_user, to_user)	\
-	[_IOC_NR(MEDIA_IOC_##__cmd)] = {		\
-		.cmd = MEDIA_IOC_##__cmd,		\
+/* Do acquire the graph mutex */
+#define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
+
+#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
+		.cmd = MEDIA_IOC_##__cmd,				\
 		.fn = (long (*)(struct media_device *, void *))func,	\
-		.arg_from_user = from_user,		\
-		.arg_to_user = to_user,			\
+		.flags = fl,						\
+		.arg_from_user = from_user,				\
+		.arg_to_user = to_user,					\
 	}
 
-#define MEDIA_IOC(__cmd, func)						\
-	MEDIA_IOC_ARG(__cmd, func, copy_arg_from_user, copy_arg_to_user)
+#define MEDIA_IOC(__cmd, func, fl)					\
+	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
 
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
+	unsigned short flags;
 	long (*fn)(struct media_device *dev, void *arg);
 	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
 	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
 };
 
 static const struct media_ioctl_info ioctl_info[] = {
-	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
-	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
-	MEDIA_IOC(ENUM_LINKS, media_device_enum_links),
-	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
-	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
+	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 };
 
 static inline long is_valid_ioctl(const struct media_ioctl_info *info,
@@ -443,9 +448,13 @@ static long __media_device_ioctl(
 			goto out_free;
 	}
 
-	mutex_lock(&dev->graph_mutex);
+	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
+		mutex_lock(&dev->graph_mutex);
+
 	ret = info->fn(dev, karg);
-	mutex_unlock(&dev->graph_mutex);
+
+	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
+		mutex_unlock(&dev->graph_mutex);
 
 	if (!ret && info->arg_to_user)
 		ret = info->arg_to_user(arg, karg, cmd);
@@ -496,11 +505,11 @@ static long from_user_enum_links32(void *karg, void __user *uarg,
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
 
 static const struct media_ioctl_info compat_ioctl_info[] = {
-	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
-	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
-	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, from_user_enum_links32, NULL),
-	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
-	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
+	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, NULL),
+	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 };
 
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
-- 
2.7.4

