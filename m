Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:2101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbcEDXH0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 19:07:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
Subject: [PATCH v2.1 5/5] media: Support variable size IOCTL arguments
Date: Thu,  5 May 2016 02:06:57 +0300
Message-Id: <1462403217-4584-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462360855-23354-6-git-send-email-sakari.ailus@linux.intel.com>
References: <1462360855-23354-6-git-send-email-sakari.ailus@linux.intel.com>
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
since v2:

- Use a list of supported argument sizes instead of a minimum value.

 drivers/media/media-device.c | 52 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e88e6d3..5cfeccf 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -393,32 +393,71 @@ static long copy_arg_to_user_nop(void __user *uarg, void *karg,
 /* Do acquire the graph mutex */
 #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
 
-#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
+#define MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz, from_user, to_user)	\
 	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
 		.cmd = MEDIA_IOC_##__cmd,				\
 		.fn = (long (*)(struct media_device *, void *))func,	\
 		.flags = fl,						\
+		.alt_arg_sizes = alt_sz,				\
 		.arg_from_user = from_user,				\
 		.arg_to_user = to_user,					\
 	}
 
-#define MEDIA_IOC(__cmd, func, fl)					\
-	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
+#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
+	MEDIA_IOC_SZ_ARG(__cmd, func, fl, NULL, from_user, to_user)
+
+#define MEDIA_IOC_SZ(__cmd, func, fl, alt_sz)			\
+	MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz,		\
+			 copy_arg_from_user, copy_arg_to_user)
+
+#define MEDIA_IOC(__cmd, func, fl)				\
+	MEDIA_IOC_ARG(__cmd, func, fl,				\
+		      copy_arg_from_user, copy_arg_to_user)
 
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
 	long (*fn)(struct media_device *dev, void *arg);
 	unsigned short flags;
+	const unsigned short *alt_arg_sizes;
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
+	const unsigned short *alt_arg_sizes;
+
+	if (unlikely(_IOC_NR(cmd) >= len))
+		return -ENOIOCTLCMD;
+
+	info += _IOC_NR(cmd);
+
+	if (info->cmd == cmd)
+		return 0;
+
+	/*
+	 * Verify that the size-dependent patch of the IOCTL command
+	 * matches and that the size does not exceed the principal
+	 * argument size.
+	 */
+	if (unlikely(MASK_IOC_SIZE(info->cmd) != MASK_IOC_SIZE(cmd)
+		     || _IOC_SIZE(info->cmd) < _IOC_SIZE(cmd)))
+		return -ENOIOCTLCMD;
+
+	alt_arg_sizes = info->alt_arg_sizes;
+	if (unlikely(!alt_arg_sizes))
+		return -ENOIOCTLCMD;
+
+	for (; *alt_arg_sizes; alt_arg_sizes++)
+		if (_IOC_SIZE(cmd) == *alt_arg_sizes)
+			return 0;
+
+	return -ENOIOCTLCMD;
 }
 
 static long __media_device_ioctl(
@@ -445,6 +484,9 @@ static long __media_device_ioctl(
 
 	info->arg_from_user(karg, arg, cmd);
 
+	/* Set the rest of the argument struct to zero */
+	memset(karg + _IOC_SIZE(cmd), 0, _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
+
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_lock(&dev->graph_mutex);
 
-- 
2.1.4

