Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbcHKUaL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 16:30:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
Subject: [PATCH v4 5/5] media: Support variable size IOCTL arguments
Date: Thu, 11 Aug 2016 23:29:18 +0300
Message-Id: <1470947358-31168-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maintain a list of supported IOCTL argument sizes and allow only those in
the list.

As an additional bonus, IOCTL handlers will be able to check whether the
caller actually set (using the argument size) the field vs. assigning it
to zero. Separate macro can be provided for that.

This will be easier for applications as well since there is no longer the
problem of setting the reserved fields zero, or at least it is a lesser
problem.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 56 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6f565a2..aa37520 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -384,22 +384,36 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
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
 	unsigned short flags;
+	/*
+	 * Sizes of the alternative arguments. If there are none, this
+	 * pointer is NULL.
+	 */
+	const unsigned short *alt_arg_sizes;
 	long (*fn)(struct media_device *dev, void *arg);
 	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
 	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
@@ -413,11 +427,40 @@ static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 };
 
+#define MASK_IOC_SIZE(cmd) \
+	((cmd) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
+
 static inline long is_valid_ioctl(const struct media_ioctl_info *info,
 				  unsigned int cmd)
 {
-	return (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
-		|| info[_IOC_NR(cmd)].cmd != cmd) ? -ENOIOCTLCMD : 0;
+	const unsigned short *alt_arg_sizes;
+
+	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info))
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
+	if (MASK_IOC_SIZE(info->cmd) != MASK_IOC_SIZE(cmd)
+	    || _IOC_SIZE(info->cmd) < _IOC_SIZE(cmd))
+		return -ENOIOCTLCMD;
+
+	alt_arg_sizes = info->alt_arg_sizes;
+	if (!alt_arg_sizes)
+		return -ENOIOCTLCMD;
+
+	for (; *alt_arg_sizes; alt_arg_sizes++)
+		if (_IOC_SIZE(cmd) == *alt_arg_sizes)
+			return 0;
+
+	return -ENOIOCTLCMD;
 }
 
 static long __media_device_ioctl(
@@ -448,6 +491,9 @@ static long __media_device_ioctl(
 			goto out_free;
 	}
 
+	/* Set the rest of the argument struct to zero */
+	memset(karg + _IOC_SIZE(cmd), 0, _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
+
 	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
 		mutex_lock(&dev->graph_mutex);
 
-- 
2.7.4

