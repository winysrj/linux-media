Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42898 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894AbaFSRXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 13:23:18 -0400
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id CD27D20C6E
	for <linux-media@vger.kernel.org>; Thu, 19 Jun 2014 13:23:15 -0400 (EDT)
From: Ramakrishnan Muthukrishnan <ram@fastmail.in>
To: linux-media@vger.kernel.org
Cc: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [REVIEW PATCH 1/4] media: v4l2-core: remove the use of V4L2_FL_USE_FH_PRIO flag.
Date: Thu, 19 Jun 2014 22:52:57 +0530
Message-Id: <1403198580-3126-2-git-send-email-ram@fastmail.in>
In-Reply-To: <1403198580-3126-1-git-send-email-ram@fastmail.in>
References: <1403198580-3126-1-git-send-email-ram@fastmail.in>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>

Since all the drivers that use `struct v4l2_fh' use the core priority
checking instead of doing it themselves, this flag can be removed.

This patch removes the usage of the flag from v4l2-core.

Signed-off-by: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   |  6 ++----
 drivers/media/v4l2-core/v4l2-fh.c    | 13 +++++++++----
 drivers/media/v4l2-core/v4l2-ioctl.c |  9 +++------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 634d863..35698aa 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -563,11 +563,9 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	/* vfl_type and vfl_dir independent ioctls */
 
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYCAP, vidioc_querycap);
-	if (ops->vidioc_g_priority ||
-			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
+	if (ops->vidioc_g_priority)
 		set_bit(_IOC_NR(VIDIOC_G_PRIORITY), valid_ioctls);
-	if (ops->vidioc_s_priority ||
-			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
+	if (ops->vidioc_s_priority)
 		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
 	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index e57c002..c97067a 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -37,6 +37,13 @@ void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	fh->ctrl_handler = vdev->ctrl_handler;
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
+	/*
+	 * determine_valid_ioctls() does not know if struct v4l2_fh
+	 * is used by this driver, but here we do. So enable the
+	 * prio ioctls here.
+	 */
+	set_bit(_IOC_NR(VIDIOC_G_PRIORITY), vdev->valid_ioctls);
+	set_bit(_IOC_NR(VIDIOC_S_PRIORITY), vdev->valid_ioctls);
 	fh->prio = V4L2_PRIORITY_UNSET;
 	init_waitqueue_head(&fh->wait);
 	INIT_LIST_HEAD(&fh->available);
@@ -49,8 +56,7 @@ void v4l2_fh_add(struct v4l2_fh *fh)
 {
 	unsigned long flags;
 
-	if (test_bit(V4L2_FL_USE_FH_PRIO, &fh->vdev->flags))
-		v4l2_prio_open(fh->vdev->prio, &fh->prio);
+	v4l2_prio_open(fh->vdev->prio, &fh->prio);
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_add(&fh->list, &fh->vdev->fh_list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
@@ -78,8 +84,7 @@ void v4l2_fh_del(struct v4l2_fh *fh)
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_del_init(&fh->list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-	if (test_bit(V4L2_FL_USE_FH_PRIO, &fh->vdev->flags))
-		v4l2_prio_close(fh->vdev->prio, fh->prio);
+	v4l2_prio_close(fh->vdev->prio, fh->prio);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_del);
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 16bffd8..8d4a25d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2190,7 +2190,6 @@ static long __video_do_ioctl(struct file *file,
 	const struct v4l2_ioctl_info *info;
 	void *fh = file->private_data;
 	struct v4l2_fh *vfh = NULL;
-	int use_fh_prio = 0;
 	int debug = vfd->debug;
 	long ret = -ENOTTY;
 
@@ -2200,10 +2199,8 @@ static long __video_do_ioctl(struct file *file,
 		return ret;
 	}
 
-	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
 		vfh = file->private_data;
-		use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
-	}
 
 	if (v4l2_is_known_ioctl(cmd)) {
 		info = &v4l2_ioctls[_IOC_NR(cmd)];
@@ -2212,7 +2209,7 @@ static long __video_do_ioctl(struct file *file,
 		    !((info->flags & INFO_FL_CTRL) && vfh && vfh->ctrl_handler))
 			goto done;
 
-		if (use_fh_prio && (info->flags & INFO_FL_PRIO)) {
+		if (vfh && (info->flags & INFO_FL_PRIO)) {
 			ret = v4l2_prio_check(vfd->prio, vfh->prio);
 			if (ret)
 				goto done;
@@ -2237,7 +2234,7 @@ static long __video_do_ioctl(struct file *file,
 		ret = -ENOTTY;
 	} else {
 		ret = ops->vidioc_default(file, fh,
-			use_fh_prio ? v4l2_prio_check(vfd->prio, vfh->prio) >= 0 : 0,
+			vfh ? v4l2_prio_check(vfd->prio, vfh->prio) >= 0 : 0,
 			cmd, arg);
 	}
 
-- 
2.0.0

