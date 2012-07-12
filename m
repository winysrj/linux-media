Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3561 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161293Ab2GLQHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 12:07:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Use a named union in struct v4l2_ioctl_info
Date: Thu, 12 Jul 2012 18:06:24 +0200
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207121806.24955.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

struct v4l2_ioctl_info uses an anonymous union, which is initialized
in the v4l2_ioctls table.

Unfortunately gcc < 4.6 uses a non-standard syntax for that, so trying to
compile v4l2-ioctl.c with an older gcc will fail.

It is possible to work around this by testing the gcc version, but in this
case it is easier to make the union named since it is used in only a few
places.

Randy, Stephen, this patch should solve the v4l2-ioctl.c compilation problem
in linux-next. Since Mauro is still on holiday you'll have to apply it manually.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 70e0efb..812beb0 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1806,7 +1806,7 @@ struct v4l2_ioctl_info {
 		u32 offset;
 		int (*func)(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *p);
-	};
+	} u;
 	void (*debug)(const void *arg, bool write_only);
 };
 
@@ -1831,7 +1831,7 @@ struct v4l2_ioctl_info {
 		.ioctl = _ioctl,					\
 		.flags = _flags | INFO_FL_STD,				\
 		.name = #_ioctl,					\
-		.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
+		.u.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
 		.debug = _debug,					\
 	}
 
@@ -1840,7 +1840,7 @@ struct v4l2_ioctl_info {
 		.ioctl = _ioctl,					\
 		.flags = _flags | INFO_FL_FUNC,				\
 		.name = #_ioctl,					\
-		.func = _func,						\
+		.u.func = _func,					\
 		.debug = _debug,					\
 	}
 
@@ -2038,11 +2038,11 @@ static long __video_do_ioctl(struct file *file,
 	if (info->flags & INFO_FL_STD) {
 		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
 		const void *p = vfd->ioctl_ops;
-		const vidioc_op *vidioc = p + info->offset;
+		const vidioc_op *vidioc = p + info->u.offset;
 
 		ret = (*vidioc)(file, fh, arg);
 	} else if (info->flags & INFO_FL_FUNC) {
-		ret = info->func(ops, file, fh, arg);
+		ret = info->u.func(ops, file, fh, arg);
 	} else if (!ops->vidioc_default) {
 		ret = -ENOTTY;
 	} else {
	
