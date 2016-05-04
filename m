Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22143 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbcEDLYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:24:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH v2 5/5] media: Support variable size IOCTL arguments
Date: Wed,  4 May 2016 14:20:55 +0300
Message-Id: <1462360855-23354-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking for a strict size for the IOCTL arguments, place
minimum and maximum limits.

As an additional bonus, IOCTL handlers will be able to check whether the
caller actually set (using the argument size) the field vs. assigning it
to zero. Separate macro can be provided for that.

This will be easier for applications as well since there is no longer the
problem of setting the reserved fields zero, or at least it is a lesser
problem.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 45 +++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 8aef5b8..c638d3b 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -393,32 +393,44 @@ static long copy_arg_to_user_nop(void __user *uarg, void *karg,
 /* Do acquire the graph mutex */
 #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
 
-#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
+#define MEDIA_IOC_ARG(__cmd, arg_type, func, fl, from_user, to_user)	\
 	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
 		.cmd = MEDIA_IOC_##__cmd,				\
 		.fn = (long (*)(struct media_device *, void *))func,	\
 		.flags = fl,						\
+		.min_arg_size = sizeof(arg_type),			\
 		.arg_from_user = from_user,				\
 		.arg_to_user = to_user,					\
 	}
 
-#define MEDIA_IOC(__cmd, func, fl)					\
-	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
+#define MEDIA_IOC(__cmd, arg_type, func, fl)				\
+	MEDIA_IOC_ARG(__cmd, arg_type, func, fl,			\
+		      copy_arg_from_user, copy_arg_to_user)
 
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
 	long (*fn)(struct media_device *dev, void *arg);
 	unsigned short flags;
+	unsigned short min_arg_size;
 	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
 	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
 };
 
+#define MASK_IOC_SIZE(cmd) \
+	((cmd) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
+
 static inline long is_valid_ioctl(const struct media_ioctl_info *info,
 				  unsigned int len, unsigned int cmd)
 {
-	return (_IOC_NR(cmd) >= len
-		|| info[_IOC_NR(cmd)].cmd != cmd) ? -ENOIOCTLCMD : 0;
+	if (_IOC_NR(cmd) >= len)
+		return -ENOIOCTLCMD;
+
+	info += _IOC_NR(cmd);
+
+	return (MASK_IOC_SIZE(info->cmd) != MASK_IOC_SIZE(cmd)
+		|| _IOC_SIZE(cmd) < info->min_arg_size
+		|| _IOC_SIZE(cmd) > _IOC_SIZE(info->cmd)) ? -ENOIOCTLCMD : 0;
 }
 
 static unsigned int media_ioctl_max_arg_size(
@@ -454,6 +466,9 @@ static long __media_device_ioctl(
 
 	info->arg_from_user(karg, arg, cmd);
 
+	/* Set the rest of the argument struct to zero */
+	memset(karg + _IOC_SIZE(cmd), 0, _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
+
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_lock(&dev->graph_mutex);
 
@@ -469,11 +484,11 @@ static long __media_device_ioctl(
 }
 
 static const struct media_ioctl_info ioctl_info[] = {
-	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(DEVICE_INFO, struct media_device_info, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(ENUM_ENTITIES, struct media_entity_desc, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(ENUM_LINKS, struct media_links_enum, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(SETUP_LINK, struct media_link_desc, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(G_TOPOLOGY, struct media_v2_topology, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -519,11 +534,11 @@ static long from_user_enum_links32(void *karg, void __user *uarg,
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
 
 static const struct media_ioctl_info compat_ioctl_info[] = {
-	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, copy_arg_to_user_nop),
-	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(DEVICE_INFO, struct media_device_info, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(ENUM_ENTITIES, struct media_entity_desc, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC_ARG(ENUM_LINKS32, struct media_links_enum32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, copy_arg_to_user_nop),
+	MEDIA_IOC(SETUP_LINK, struct media_link_desc, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC(G_TOPOLOGY, struct media_v2_topology, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 };
 
 static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
-- 
1.9.1

