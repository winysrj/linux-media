Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36980 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837AbbBCNrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 08:47:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: isely@isely.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] pvrusb2: use struct v4l2_fh
Date: Tue,  3 Feb 2015 14:46:55 +0100
Message-Id: <1422971216-47871-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
References: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

But using struct v4l2_fh both the prio handling and the linked list
implementation in pvrusb2 can be removed since both are now done in
the v4l2 core if you use struct v4l2_fh.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 81 +++++---------------------------
 1 file changed, 13 insertions(+), 68 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 91c1700..802b43b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
@@ -50,14 +51,11 @@ struct pvr2_v4l2_dev {
 };
 
 struct pvr2_v4l2_fh {
+	struct v4l2_fh fh;
 	struct pvr2_channel channel;
 	struct pvr2_v4l2_dev *pdi;
-	enum v4l2_priority prio;
 	struct pvr2_ioread *rhp;
 	struct file *file;
-	struct pvr2_v4l2 *vhead;
-	struct pvr2_v4l2_fh *vnext;
-	struct pvr2_v4l2_fh *vprev;
 	wait_queue_head_t wait_data;
 	int fw_mode_flag;
 	/* Map contiguous ordinal value to input id */
@@ -67,10 +65,6 @@ struct pvr2_v4l2_fh {
 
 struct pvr2_v4l2 {
 	struct pvr2_channel channel;
-	struct pvr2_v4l2_fh *vfirst;
-	struct pvr2_v4l2_fh *vlast;
-
-	struct v4l2_prio_state prio;
 
 	/* streams - Note that these must be separately, individually,
 	 * allocated pointers.  This is because the v4l core is going to
@@ -169,23 +163,6 @@ static int pvr2_querycap(struct file *file, void *priv, struct v4l2_capability *
 	return 0;
 }
 
-static int pvr2_g_priority(struct file *file, void *priv, enum v4l2_priority *p)
-{
-	struct pvr2_v4l2_fh *fh = file->private_data;
-	struct pvr2_v4l2 *vp = fh->vhead;
-
-	*p = v4l2_prio_max(&vp->prio);
-	return 0;
-}
-
-static int pvr2_s_priority(struct file *file, void *priv, enum v4l2_priority prio)
-{
-	struct pvr2_v4l2_fh *fh = file->private_data;
-	struct pvr2_v4l2 *vp = fh->vhead;
-
-	return v4l2_prio_change(&vp->prio, &fh->prio, prio);
-}
-
 static int pvr2_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
@@ -805,8 +782,6 @@ static int pvr2_log_status(struct file *file, void *priv)
 
 static const struct v4l2_ioctl_ops pvr2_ioctl_ops = {
 	.vidioc_querycap		    = pvr2_querycap,
-	.vidioc_g_priority		    = pvr2_g_priority,
-	.vidioc_s_priority		    = pvr2_s_priority,
 	.vidioc_s_audio			    = pvr2_s_audio,
 	.vidioc_g_audio			    = pvr2_g_audio,
 	.vidioc_enumaudio		    = pvr2_enumaudio,
@@ -911,7 +886,9 @@ static void pvr2_v4l2_internal_check(struct pvr2_channel *chp)
 	if (!vp->channel.mc_head->disconnect_flag) return;
 	pvr2_v4l2_dev_disassociate_parent(vp->dev_video);
 	pvr2_v4l2_dev_disassociate_parent(vp->dev_radio);
-	if (vp->vfirst) return;
+	if (!list_empty(&vp->dev_video->devbase.fh_list) ||
+	    !list_empty(&vp->dev_radio->devbase.fh_list))
+		return;
 	pvr2_v4l2_destroy_no_lock(vp);
 }
 
@@ -921,7 +898,6 @@ static long pvr2_v4l2_ioctl(struct file *file,
 {
 
 	struct pvr2_v4l2_fh *fh = file->private_data;
-	struct pvr2_v4l2 *vp = fh->vhead;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 	long ret = -EINVAL;
 
@@ -934,18 +910,6 @@ static long pvr2_v4l2_ioctl(struct file *file,
 		return -EFAULT;
 	}
 
-	/* check priority */
-	switch (cmd) {
-	case VIDIOC_S_CTRL:
-	case VIDIOC_S_STD:
-	case VIDIOC_S_INPUT:
-	case VIDIOC_S_TUNER:
-	case VIDIOC_S_FREQUENCY:
-		ret = v4l2_prio_check(&vp->prio, fh->prio);
-		if (ret)
-			return ret;
-	}
-
 	ret = video_ioctl2(file, cmd, arg);
 
 	pvr2_hdw_commit_ctl(hdw);
@@ -970,7 +934,7 @@ static long pvr2_v4l2_ioctl(struct file *file,
 static int pvr2_v4l2_release(struct file *file)
 {
 	struct pvr2_v4l2_fh *fhp = file->private_data;
-	struct pvr2_v4l2 *vp = fhp->vhead;
+	struct pvr2_v4l2 *vp = fhp->pdi->v4lp;
 	struct pvr2_hdw *hdw = fhp->channel.mc_head->hdw;
 
 	pvr2_trace(PVR2_TRACE_OPEN_CLOSE,"pvr2_v4l2_release");
@@ -984,22 +948,10 @@ static int pvr2_v4l2_release(struct file *file)
 		fhp->rhp = NULL;
 	}
 
-	v4l2_prio_close(&vp->prio, fhp->prio);
+	v4l2_fh_del(&fhp->fh);
+	v4l2_fh_exit(&fhp->fh);
 	file->private_data = NULL;
 
-	if (fhp->vnext) {
-		fhp->vnext->vprev = fhp->vprev;
-	} else {
-		vp->vlast = fhp->vprev;
-	}
-	if (fhp->vprev) {
-		fhp->vprev->vnext = fhp->vnext;
-	} else {
-		vp->vfirst = fhp->vnext;
-	}
-	fhp->vnext = NULL;
-	fhp->vprev = NULL;
-	fhp->vhead = NULL;
 	pvr2_channel_done(&fhp->channel);
 	pvr2_trace(PVR2_TRACE_STRUCT,
 		   "Destroying pvr_v4l2_fh id=%p",fhp);
@@ -1008,7 +960,9 @@ static int pvr2_v4l2_release(struct file *file)
 		fhp->input_map = NULL;
 	}
 	kfree(fhp);
-	if (vp->channel.mc_head->disconnect_flag && !vp->vfirst) {
+	if (vp->channel.mc_head->disconnect_flag &&
+	    list_empty(&vp->dev_video->devbase.fh_list) &&
+	    list_empty(&vp->dev_radio->devbase.fh_list)) {
 		pvr2_v4l2_destroy_no_lock(vp);
 	}
 	return 0;
@@ -1043,6 +997,7 @@ static int pvr2_v4l2_open(struct file *file)
 		return -ENOMEM;
 	}
 
+	v4l2_fh_init(&fhp->fh, &dip->devbase);
 	init_waitqueue_head(&fhp->wait_data);
 	fhp->pdi = dip;
 
@@ -1093,21 +1048,11 @@ static int pvr2_v4l2_open(struct file *file)
 		fhp->input_map[input_cnt++] = idx;
 	}
 
-	fhp->vnext = NULL;
-	fhp->vprev = vp->vlast;
-	if (vp->vlast) {
-		vp->vlast->vnext = fhp;
-	} else {
-		vp->vfirst = fhp;
-	}
-	vp->vlast = fhp;
-	fhp->vhead = vp;
-
 	fhp->file = file;
 	file->private_data = fhp;
-	v4l2_prio_open(&vp->prio, &fhp->prio);
 
 	fhp->fw_mode_flag = pvr2_hdw_cpufw_get_enabled(hdw);
+	v4l2_fh_add(&fhp->fh);
 
 	return 0;
 }
-- 
2.1.4

