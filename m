Return-path: <mchehab@pedra>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3368 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1DDLwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:19 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFCv1 PATCH 3/9] v4l2-ioctl: add ctrl_handler to v4l2_fh
Date: Mon,  4 Apr 2011 13:51:48 +0200
Message-Id: <b4f1a4000c9764bfd326a4f9b3fbfa57b40ac102.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hverkuil@xs4all.nl>

This is required to implement control events and is also needed to allow
for per-filehandle control handlers.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-fh.c    |    2 ++
 drivers/media/video/v4l2-ioctl.c |   36 +++++++++++++++++++++++++++---------
 include/media/v4l2-fh.h          |    2 ++
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 717f71e..8635011 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -32,6 +32,8 @@
 int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
 	fh->vdev = vdev;
+	/* Inherit from video_device. May be overridden by the driver. */
+	fh->ctrl_handler = vdev->ctrl_handler;
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
 	fh->prio = V4L2_PRIORITY_UNSET;
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index a01ed39..b5b875b 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1418,7 +1418,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_queryctrl *p = arg;
 
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_queryctrl(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_queryctrl(vfd->ctrl_handler, p);
 		else if (ops->vidioc_queryctrl)
 			ret = ops->vidioc_queryctrl(file, fh, p);
@@ -1438,7 +1440,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_control *p = arg;
 
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_g_ctrl(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_g_ctrl(vfd->ctrl_handler, p);
 		else if (ops->vidioc_g_ctrl)
 			ret = ops->vidioc_g_ctrl(file, fh, p);
@@ -1470,12 +1474,16 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls ctrls;
 		struct v4l2_ext_control ctrl;
 
-		if (!vfd->ctrl_handler &&
+		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
 			!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
 			break;
 
 		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 
+		if (vfh && vfh->ctrl_handler) {
+			ret = v4l2_s_ctrl(vfh->ctrl_handler, p);
+			break;
+		}
 		if (vfd->ctrl_handler) {
 			ret = v4l2_s_ctrl(vfd->ctrl_handler, p);
 			break;
@@ -1501,7 +1509,9 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
 		else if (ops->vidioc_g_ext_ctrls && check_ext_ctrls(p, 0))
 			ret = ops->vidioc_g_ext_ctrls(file, fh, p);
@@ -1515,10 +1525,13 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!vfd->ctrl_handler && !ops->vidioc_s_ext_ctrls)
+		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
+				!ops->vidioc_s_ext_ctrls)
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_s_ext_ctrls(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_s_ext_ctrls(vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
@@ -1529,10 +1542,13 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!vfd->ctrl_handler && !ops->vidioc_try_ext_ctrls)
+		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
+				!ops->vidioc_try_ext_ctrls)
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_try_ext_ctrls(file, fh, p);
@@ -1542,7 +1558,9 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_querymenu *p = arg;
 
-		if (vfd->ctrl_handler)
+		if (vfh && vfh->ctrl_handler)
+			ret = v4l2_querymenu(vfh->ctrl_handler, p);
+		else if (vfd->ctrl_handler)
 			ret = v4l2_querymenu(vfd->ctrl_handler, p);
 		else if (ops->vidioc_querymenu)
 			ret = ops->vidioc_querymenu(file, fh, p);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 0206aa5..d247111 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -30,11 +30,13 @@
 
 struct video_device;
 struct v4l2_events;
+struct v4l2_ctrl_handler;
 
 struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
 	struct v4l2_events      *events; /* events, pending and subscribed */
+	struct v4l2_ctrl_handler *ctrl_handler;
 	enum v4l2_priority	prio;
 };
 
-- 
1.7.1

