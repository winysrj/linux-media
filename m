Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2362 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab1FGPFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 05/18] v4l2-subdev: implement per-filehandle control handlers.
Date: Tue,  7 Jun 2011 17:05:10 +0200
Message-Id: <fce618c696c353c374cf7b494508727409809ef3.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

To be consistent with v4l2-ioctl.c.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-device.c |    1 +
 drivers/media/video/v4l2-subdev.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 4aae501..c72856c 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -209,6 +209,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		vdev->v4l2_dev = v4l2_dev;
 		vdev->fops = &v4l2_subdev_fops;
 		vdev->release = video_device_release_empty;
+		vdev->ctrl_handler = sd->ctrl_handler;
 		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
 					      sd->owner);
 		if (err < 0)
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 812729e..f396cc3 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -155,25 +155,25 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
-		return v4l2_queryctrl(sd->ctrl_handler, arg);
+		return v4l2_queryctrl(vfh->ctrl_handler, arg);
 
 	case VIDIOC_QUERYMENU:
-		return v4l2_querymenu(sd->ctrl_handler, arg);
+		return v4l2_querymenu(vfh->ctrl_handler, arg);
 
 	case VIDIOC_G_CTRL:
-		return v4l2_g_ctrl(sd->ctrl_handler, arg);
+		return v4l2_g_ctrl(vfh->ctrl_handler, arg);
 
 	case VIDIOC_S_CTRL:
-		return v4l2_s_ctrl(sd->ctrl_handler, arg);
+		return v4l2_s_ctrl(vfh->ctrl_handler, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
-		return v4l2_g_ext_ctrls(sd->ctrl_handler, arg);
+		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
 
 	case VIDIOC_S_EXT_CTRLS:
-		return v4l2_s_ext_ctrls(sd->ctrl_handler, arg);
+		return v4l2_s_ext_ctrls(vfh->ctrl_handler, arg);
 
 	case VIDIOC_TRY_EXT_CTRLS:
-		return v4l2_try_ext_ctrls(sd->ctrl_handler, arg);
+		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
 
 	case VIDIOC_DQEVENT:
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
-- 
1.7.1

