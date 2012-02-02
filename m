Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3321 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab2BBL5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:57:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/6] v4l2: standardize log start/end message.
Date: Thu,  2 Feb 2012 12:56:31 +0100
Message-Id: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
In-Reply-To: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
References: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For drivers that properly use the v4l2 framework (i.e. set v4l2_dev in the
video_device struct), the start and end messages of VIDIOC_LOG_STATUS are
now generated automatically. People tended to forget these, but the v4l2-ctl
tool scans for these messages, and it also makes it easier to read the status
output in the kernel log.

The cx18, ivtv and bttv drivers were changed since they no longer need to
log these start/end messages.

In saa7164 two empty log_status functions were removed.

Also added a helper function to v4l2-ctrl.c that can be used as the
vidioc_log_status callback if all you need to do is to log the current control
values. This is now used by pwc and vivi.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Steven Toth <stoth@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/bt8xx/bttv-driver.c       |    4 ----
 drivers/media/video/cx18/cx18-ioctl.c         |    4 ----
 drivers/media/video/ivtv/ivtv-ioctl.c         |    5 -----
 drivers/media/video/pwc/pwc-v4l.c             |   10 +---------
 drivers/media/video/saa7164/saa7164-encoder.c |    6 ------
 drivers/media/video/saa7164/saa7164-vbi.c     |    6 ------
 drivers/media/video/v4l2-ctrls.c              |   12 ++++++++++++
 drivers/media/video/v4l2-ioctl.c              |    6 ++++++
 drivers/media/video/vivi.c                    |   10 +---------
 include/media/v4l2-ctrls.h                    |    4 ++++
 10 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 76c301f..e581b37 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -2035,11 +2035,7 @@ static int bttv_log_status(struct file *file, void *f)
 	struct bttv_fh *fh  = f;
 	struct bttv *btv = fh->btv;
 
-	pr_info("%d: ========  START STATUS CARD #%d  ========\n",
-		btv->c.nr, btv->c.nr);
 	bttv_call_all(btv, core, log_status);
-	pr_info("%d: ========  END STATUS CARD   #%d  ========\n",
-		btv->c.nr, btv->c.nr);
 	return 0;
 }
 
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 66b1c15..be49f68 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -1085,8 +1085,6 @@ static int cx18_log_status(struct file *file, void *fh)
 	struct v4l2_audio audin;
 	int i;
 
-	CX18_INFO("=================  START STATUS CARD #%d  "
-		  "=================\n", cx->instance);
 	CX18_INFO("Version: %s  Card: %s\n", CX18_VERSION, cx->card_name);
 	if (cx->hw_flags & CX18_HW_TVEEPROM) {
 		struct tveeprom tv;
@@ -1120,8 +1118,6 @@ static int cx18_log_status(struct file *file, void *fh)
 	CX18_INFO("Read MPEG/VBI: %lld/%lld bytes\n",
 			(long long)cx->mpg_data_received,
 			(long long)cx->vbi_data_inserted);
-	CX18_INFO("==================  END STATUS CARD #%d  "
-		  "==================\n", cx->instance);
 	return 0;
 }
 
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index b063077..2c92b12 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1479,8 +1479,6 @@ static int ivtv_log_status(struct file *file, void *fh)
 	struct v4l2_audio audin;
 	int i;
 
-	IVTV_INFO("=================  START STATUS CARD #%d  =================\n",
-		       itv->instance);
 	IVTV_INFO("Version: %s Card: %s\n", IVTV_VERSION, itv->card_name);
 	if (itv->hw_flags & IVTV_HW_TVEEPROM) {
 		struct tveeprom tv;
@@ -1569,9 +1567,6 @@ static int ivtv_log_status(struct file *file, void *fh)
 	IVTV_INFO("Read MPG/VBI: %lld/%lld bytes\n",
 			(long long)itv->mpg_data_received,
 			(long long)itv->vbi_data_inserted);
-	IVTV_INFO("==================  END STATUS CARD #%d  ==================\n",
-			itv->instance);
-
 	return 0;
 }
 
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index f495eeb..2834e3e 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -1146,14 +1146,6 @@ leave:
 	return ret;
 }
 
-static int pwc_log_status(struct file *file, void *priv)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-
-	v4l2_ctrl_handler_log_status(&pdev->ctrl_handler, PWC_NAME);
-	return 0;
-}
-
 const struct v4l2_ioctl_ops pwc_ioctl_ops = {
 	.vidioc_querycap		    = pwc_querycap,
 	.vidioc_enum_input		    = pwc_enum_input,
@@ -1169,7 +1161,7 @@ const struct v4l2_ioctl_ops pwc_ioctl_ops = {
 	.vidioc_dqbuf			    = pwc_dqbuf,
 	.vidioc_streamon		    = pwc_streamon,
 	.vidioc_streamoff		    = pwc_streamoff,
-	.vidioc_log_status		    = pwc_log_status,
+	.vidioc_log_status		    = v4l2_ctrl_log_status,
 	.vidioc_enum_framesizes		    = pwc_enum_framesizes,
 	.vidioc_enum_frameintervals	    = pwc_enum_frameintervals,
 	.vidioc_g_parm			    = pwc_g_parm,
diff --git a/drivers/media/video/saa7164/saa7164-encoder.c b/drivers/media/video/saa7164/saa7164-encoder.c
index 2fd38a0..a9ed686 100644
--- a/drivers/media/video/saa7164/saa7164-encoder.c
+++ b/drivers/media/video/saa7164/saa7164-encoder.c
@@ -791,11 +791,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_log_status(struct file *file, void *priv)
-{
-	return 0;
-}
-
 static int fill_queryctrl(struct saa7164_encoder_params *params,
 	struct v4l2_queryctrl *c)
 {
@@ -1347,7 +1342,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
 	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
 	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
-	.vidioc_log_status	 = vidioc_log_status,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
 	.vidioc_g_chip_ident	 = saa7164_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/video/saa7164/saa7164-vbi.c b/drivers/media/video/saa7164/saa7164-vbi.c
index e2e0341..273cf80 100644
--- a/drivers/media/video/saa7164/saa7164-vbi.c
+++ b/drivers/media/video/saa7164/saa7164-vbi.c
@@ -730,11 +730,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_log_status(struct file *file, void *priv)
-{
-	return 0;
-}
-
 static int fill_queryctrl(struct saa7164_vbi_params *params,
 	struct v4l2_queryctrl *c)
 {
@@ -1256,7 +1251,6 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
 	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
 	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
-	.vidioc_log_status	 = vidioc_log_status,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
 #if 0
 	.vidioc_g_chip_ident	 = saa7164_g_chip_ident,
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index cccd42b..d070688 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2359,3 +2359,15 @@ void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
 	v4l2_ctrl_unlock(ctrl);
 }
 EXPORT_SYMBOL(v4l2_ctrl_del_event);
+
+int v4l2_ctrl_log_status(struct file *file, void *fh)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_fh *vfh = file->private_data;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) && vfd->v4l2_dev)
+		v4l2_ctrl_handler_log_status(vfh->ctrl_handler,
+			vfd->v4l2_dev->name);
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_ctrl_log_status);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index d0d7281..ae4f3b0d 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1911,7 +1911,13 @@ static long __video_do_ioctl(struct file *file,
 	{
 		if (!ops->vidioc_log_status)
 			break;
+		if (vfd->v4l2_dev)
+			pr_info("%s: =================  START STATUS  =================\n",
+				vfd->v4l2_dev->name);
 		ret = ops->vidioc_log_status(file, fh);
+		if (vfd->v4l2_dev)
+			pr_info("%s: ==================  END STATUS  ==================\n",
+				vfd->v4l2_dev->name);
 		break;
 	}
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 84ea88d..cef8c91 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -959,14 +959,6 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return vb2_streamoff(&dev->vb_vidq, i);
 }
 
-static int vidioc_log_status(struct file *file, void *priv)
-{
-	struct vivi_dev *dev = video_drvdata(file);
-
-	v4l2_ctrl_handler_log_status(&dev->ctrl_handler, dev->v4l2_dev.name);
-	return 0;
-}
-
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	return 0;
@@ -1210,7 +1202,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
-	.vidioc_log_status    = vidioc_log_status,
+	.vidioc_log_status    = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = vidioc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index eeb3df6..5f246c2 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -492,6 +492,10 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
 		struct v4l2_subscribed_event *sev);
 
+/* Can be used as a vidioc_log_status function that just dumps all controls
+   associated with the filehandle. */
+int v4l2_ctrl_log_status(struct file *file, void *fh);
+
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
-- 
1.7.8.3

