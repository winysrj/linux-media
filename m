Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4980 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2FJK0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/32] v4l2-ioctl.c: use the new table for priority ioctls.
Date: Sun, 10 Jun 2012 12:25:29 +0200
Message-Id: <bca23eb28a6b965351dc6ebe07857554b1b492b1.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   60 ++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index f33bb00..4a7b75b 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -478,6 +478,33 @@ static int v4l_s_output(const struct v4l2_ioctl_ops *ops,
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
@@ -620,8 +647,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
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
@@ -758,35 +785,6 @@ static long __video_do_ioctl(struct file *file,
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

