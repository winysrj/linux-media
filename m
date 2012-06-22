Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2374 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761507Ab2FVMVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/34] v4l2-ioctl.c: use the new table for priority ioctls.
Date: Fri, 22 Jun 2012 14:21:01 +0200
Message-Id: <139c9d84c9b8b45b3c00e9604f4082c58fb05d0b.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   60 ++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 39424eb..ef7db8a 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -470,6 +470,33 @@ static int v4l_s_output(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_s_output(file, fh, *(unsigned int *)arg);
 }
 
+static int v4l_g_priority(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd;
+	u32 *p = arg;
+
+	if (ops->vidioc_g_priority)
+		return ops->vidioc_g_priority(file, fh, arg);
+	vfd = video_devdata(file);
+	*p = v4l2_prio_max(&vfd->v4l2_dev->prio);
+	return 0;
+}
+
+static int v4l_s_priority(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd;
+	struct v4l2_fh *vfh;
+	u32 *p = arg;
+
+	if (ops->vidioc_s_priority)
+		return ops->vidioc_s_priority(file, fh, *p);
+	vfd = video_devdata(file);
+	vfh = file->private_data;
+	return v4l2_prio_change(&vfd->v4l2_dev->prio, &vfh->prio, *p);
+}
+
 static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -612,8 +639,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDIO, vidioc_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDOUT, vidioc_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
-	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
-	IOCTL_INFO(VIDIOC_S_PRIORITY, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_G_PRIORITY, v4l_g_priority, v4l_print_u32, 0),
+	IOCTL_INFO_FNC(VIDIOC_S_PRIORITY, v4l_s_priority, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
 	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
 	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
@@ -750,35 +777,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-
-	/* --- priority ------------------------------------------ */
-	case VIDIOC_G_PRIORITY:
-	{
-		enum v4l2_priority *p = arg;
-
-		if (ops->vidioc_g_priority) {
-			ret = ops->vidioc_g_priority(file, fh, p);
-		} else if (use_fh_prio) {
-			*p = v4l2_prio_max(&vfd->v4l2_dev->prio);
-			ret = 0;
-		}
-		if (!ret)
-			dbgarg(cmd, "priority is %d\n", *p);
-		break;
-	}
-	case VIDIOC_S_PRIORITY:
-	{
-		enum v4l2_priority *p = arg;
-
-		dbgarg(cmd, "setting priority to %d\n", *p);
-		if (ops->vidioc_s_priority)
-			ret = ops->vidioc_s_priority(file, fh, *p);
-		else
-			ret = v4l2_prio_change(&vfd->v4l2_dev->prio,
-							&vfh->prio, *p);
-		break;
-	}
-
 	/* --- capture ioctls ---------------------------------------- */
 	case VIDIOC_ENUM_FMT:
 	{
-- 
1.7.10

