Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31686 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756935AbcIPLus (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:50:48 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        mchehab@s-opensource.com
Subject: [PATCH v5 4/4] media: Add flags to tell whether to take graph mutex for an IOCTL
Date: Fri, 16 Sep 2016 14:49:08 +0300
Message-Id: <1474026548-28829-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New IOCTLs (especially for the request API) do not necessarily need the
graph mutex acquired. Leave this up to the drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c44406e..2783531 100644
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
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -436,9 +441,13 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
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
-- 
2.7.4

