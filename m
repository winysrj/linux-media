Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47825 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776AbbBCNry (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 08:47:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: isely@isely.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l2-core: drop g/s_priority ops
Date: Tue,  3 Feb 2015 14:46:56 +0100
Message-Id: <1422971216-47871-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
References: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The handling of VIDIOC_G/S_PRIORITY is now entirely done by the V4L2
core, so we can drop the g/s_priority ioctl ops.

We do have to make sure though that when S_PRIORITY is called we check
that the driver used struct v4l2_fh. This check can be removed once all
drivers are converted to that structure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 7 +++----
 drivers/media/v4l2-core/v4l2-ioctl.c | 6 ++----
 include/media/v4l2-ioctl.h           | 6 ------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 276a0d8..ebf4645 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -532,10 +532,9 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	/* vfl_type and vfl_dir independent ioctls */
 
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYCAP, vidioc_querycap);
-	if (ops->vidioc_g_priority)
-		set_bit(_IOC_NR(VIDIOC_G_PRIORITY), valid_ioctls);
-	if (ops->vidioc_s_priority)
-		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
+	set_bit(_IOC_NR(VIDIOC_G_PRIORITY), valid_ioctls);
+	set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
+
 	/* Note: the control handler can also be passed through the filehandle,
 	   and that can't be tested here. If the bit for these control ioctls
 	   is set, then the ioctl is valid. But if it is 0, then it can still
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b084072..09ad8dd 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1046,8 +1046,6 @@ static int v4l_g_priority(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd;
 	u32 *p = arg;
 
-	if (ops->vidioc_g_priority)
-		return ops->vidioc_g_priority(file, fh, arg);
 	vfd = video_devdata(file);
 	*p = v4l2_prio_max(vfd->prio);
 	return 0;
@@ -1060,9 +1058,9 @@ static int v4l_s_priority(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_fh *vfh;
 	u32 *p = arg;
 
-	if (ops->vidioc_s_priority)
-		return ops->vidioc_s_priority(file, fh, *p);
 	vfd = video_devdata(file);
+	if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
+		return -ENOTTY;
 	vfh = file->private_data;
 	return v4l2_prio_change(vfd->prio, &vfh->prio, *p);
 }
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 8537983..8fbbd76 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -23,12 +23,6 @@ struct v4l2_ioctl_ops {
 	/* VIDIOC_QUERYCAP handler */
 	int (*vidioc_querycap)(struct file *file, void *fh, struct v4l2_capability *cap);
 
-	/* Priority handling */
-	int (*vidioc_g_priority)   (struct file *file, void *fh,
-				    enum v4l2_priority *p);
-	int (*vidioc_s_priority)   (struct file *file, void *fh,
-				    enum v4l2_priority p);
-
 	/* VIDIOC_ENUM_FMT handlers */
 	int (*vidioc_enum_fmt_vid_cap)     (struct file *file, void *fh,
 					    struct v4l2_fmtdesc *f);
-- 
2.1.4

