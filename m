Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3735 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1EYNeO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:14 -0400
Received: from tschai (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id p4PDYARX007307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 15:34:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 03/11] v4l2-ioctl: add ctrl_handler to v4l2_fh
Date: Wed, 25 May 2011 15:33:47 +0200
Message-Id: <25160efc9fb34579e7f05685d1f188acaa616b33.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
index 506edcc..75d475c 100644
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

