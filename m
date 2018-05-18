Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33348 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbeERSxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:53:38 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 01/20] pvrusb2: replace pvr2_v4l2_ioctl by video_ioctl2
Date: Fri, 18 May 2018 15:51:49 -0300
Message-Id: <20180518185208.17722-2-ezequiel@collabora.com>
In-Reply-To: <20180518185208.17722-1-ezequiel@collabora.com>
References: <20180518185208.17722-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

This driver is the only V4L driver that does not set unlocked_ioctl
to video_ioctl2.

The only thing that pvr2_v4l2_ioctl does besides calling video_ioctl2
is calling pvr2_hdw_commit_ctl(). Add pvr2_hdw_commit_ctl() calls to
the various ioctls that need this, and we can replace pvr2_v4l2_ioctl
by video_ioctl2.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Tested-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 83 ++++++++++++--------------------
 1 file changed, 31 insertions(+), 52 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 9fdc57c1658f..e53a80b589a1 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -159,9 +159,12 @@ static int pvr2_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
+	int ret;
 
-	return pvr2_ctrl_set_value(
+	ret = pvr2_ctrl_set_value(
 		pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_STDCUR), std);
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_querystd(struct file *file, void *priv, v4l2_std_id *std)
@@ -251,12 +254,15 @@ static int pvr2_s_input(struct file *file, void *priv, unsigned int inp)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
+	int ret;
 
 	if (inp >= fh->input_cnt)
 		return -EINVAL;
-	return pvr2_ctrl_set_value(
+	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_INPUT),
 			fh->input_map[inp]);
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_enumaudio(struct file *file, void *priv, struct v4l2_audio *vin)
@@ -315,13 +321,16 @@ static int pvr2_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
+	int ret;
 
 	if (vt->index != 0)
 		return -EINVAL;
 
-	return pvr2_ctrl_set_value(
+	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_AUDIOMODE),
 			vt->audmode);
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_s_frequency(struct file *file, void *priv, const struct v4l2_frequency *vf)
@@ -353,8 +362,10 @@ static int pvr2_s_frequency(struct file *file, void *priv, const struct v4l2_fre
 		fv = (fv * 125) / 2;
 	else
 		fv = fv * 62500;
-	return pvr2_ctrl_set_value(
+	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw,PVR2_CID_FREQUENCY),fv);
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_g_frequency(struct file *file, void *priv, struct v4l2_frequency *vf)
@@ -470,6 +481,7 @@ static int pvr2_s_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format
 	vcp = pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_VRES);
 	pvr2_ctrl_set_value(hcp, vf->fmt.pix.width);
 	pvr2_ctrl_set_value(vcp, vf->fmt.pix.height);
+	pvr2_hdw_commit_ctl(hdw);
 	return 0;
 }
 
@@ -597,9 +609,12 @@ static int pvr2_s_ctrl(struct file *file, void *priv, struct v4l2_control *vc)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
+	int ret;
 
-	return pvr2_ctrl_set_value(pvr2_hdw_get_ctrl_v4l(hdw, vc->id),
+	ret = pvr2_ctrl_set_value(pvr2_hdw_get_ctrl_v4l(hdw, vc->id),
 			vc->value);
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_g_ext_ctrls(struct file *file, void *priv,
@@ -658,10 +673,12 @@ static int pvr2_s_ext_ctrls(struct file *file, void *priv,
 				ctrl->value);
 		if (ret) {
 			ctls->error_idx = idx;
-			return ret;
+			goto commit;
 		}
 	}
-	return 0;
+commit:
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_try_ext_ctrls(struct file *file, void *priv,
@@ -764,23 +781,23 @@ static int pvr2_s_selection(struct file *file, void *priv,
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPL),
 			sel->r.left);
 	if (ret != 0)
-		return -EINVAL;
+		goto commit;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPT),
 			sel->r.top);
 	if (ret != 0)
-		return -EINVAL;
+		goto commit;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPW),
 			sel->r.width);
 	if (ret != 0)
-		return -EINVAL;
+		goto commit;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPH),
 			sel->r.height);
-	if (ret != 0)
-		return -EINVAL;
-	return 0;
+commit:
+	pvr2_hdw_commit_ctl(hdw);
+	return ret;
 }
 
 static int pvr2_log_status(struct file *file, void *priv)
@@ -905,44 +922,6 @@ static void pvr2_v4l2_internal_check(struct pvr2_channel *chp)
 }
 
 
-static long pvr2_v4l2_ioctl(struct file *file,
-			   unsigned int cmd, unsigned long arg)
-{
-
-	struct pvr2_v4l2_fh *fh = file->private_data;
-	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
-	long ret = -EINVAL;
-
-	if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL)
-		v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
-
-	if (!pvr2_hdw_dev_ok(hdw)) {
-		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
-			   "ioctl failed - bad or no context");
-		return -EFAULT;
-	}
-
-	ret = video_ioctl2(file, cmd, arg);
-
-	pvr2_hdw_commit_ctl(hdw);
-
-	if (ret < 0) {
-		if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL) {
-			pvr2_trace(PVR2_TRACE_V4LIOCTL,
-				   "pvr2_v4l2_do_ioctl failure, ret=%ld command was:",
-ret);
-			v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
-		}
-	} else {
-		pvr2_trace(PVR2_TRACE_V4LIOCTL,
-			   "pvr2_v4l2_do_ioctl complete, ret=%ld (0x%lx)",
-			   ret, ret);
-	}
-	return ret;
-
-}
-
-
 static int pvr2_v4l2_release(struct file *file)
 {
 	struct pvr2_v4l2_fh *fhp = file->private_data;
@@ -1205,7 +1184,7 @@ static const struct v4l2_file_operations vdev_fops = {
 	.open       = pvr2_v4l2_open,
 	.release    = pvr2_v4l2_release,
 	.read       = pvr2_v4l2_read,
-	.unlocked_ioctl = pvr2_v4l2_ioctl,
+	.unlocked_ioctl = video_ioctl2,
 	.poll       = pvr2_v4l2_poll,
 };
 
-- 
2.16.3
