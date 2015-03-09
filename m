Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59117 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbbCIVX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/18] marvell-ccic: switch to struct v4l2_fh
Date: Mon,  9 Mar 2015 22:22:12 +0100
Message-Id: <1425936143-5658-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use struct v4l2_fh to represent a filehandle. This fixes the missing
g/s_priority handling of this driver that v4l2-compliance complained
about.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 48 +++++++++++++------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 51c9c8c..8456017 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1314,7 +1314,7 @@ static void mcam_cleanup_vb2(struct mcam_camera *cam)
 static int mcam_vidioc_streamon(struct file *filp, void *priv,
 		enum v4l2_buf_type type)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1327,7 +1327,7 @@ static int mcam_vidioc_streamon(struct file *filp, void *priv,
 static int mcam_vidioc_streamoff(struct file *filp, void *priv,
 		enum v4l2_buf_type type)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1340,7 +1340,7 @@ static int mcam_vidioc_streamoff(struct file *filp, void *priv,
 static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
 		struct v4l2_requestbuffers *req)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1353,7 +1353,7 @@ static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
 static int mcam_vidioc_querybuf(struct file *filp, void *priv,
 		struct v4l2_buffer *buf)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1365,7 +1365,7 @@ static int mcam_vidioc_querybuf(struct file *filp, void *priv,
 static int mcam_vidioc_qbuf(struct file *filp, void *priv,
 		struct v4l2_buffer *buf)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1377,7 +1377,7 @@ static int mcam_vidioc_qbuf(struct file *filp, void *priv,
 static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
 		struct v4l2_buffer *buf)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1389,7 +1389,7 @@ static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
 static int mcam_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *cap)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(file);
 
 	strcpy(cap->driver, "marvell_ccic");
 	strcpy(cap->card, "marvell_ccic");
@@ -1415,7 +1415,7 @@ static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
 static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 		struct v4l2_format *fmt)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 	struct mcam_format_struct *f;
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
 	struct v4l2_mbus_framefmt mbus_fmt;
@@ -1445,7 +1445,7 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 		struct v4l2_format *fmt)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 	struct mcam_format_struct *f;
 	int ret;
 
@@ -1494,7 +1494,7 @@ out:
 static int mcam_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
 		struct v4l2_format *f)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 
 	f->fmt.pix = cam->pix_format;
 	return 0;
@@ -1534,7 +1534,7 @@ static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 static int mcam_vidioc_g_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parms)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1547,7 +1547,7 @@ static int mcam_vidioc_g_parm(struct file *filp, void *priv,
 static int mcam_vidioc_s_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parms)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1560,7 +1560,7 @@ static int mcam_vidioc_s_parm(struct file *filp, void *priv,
 static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
 		struct v4l2_frmsizeenum *sizes)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 	struct mcam_format_struct *f;
 	struct v4l2_subdev_frame_size_enum fse = {
 		.index = sizes->index,
@@ -1597,7 +1597,7 @@ static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
 static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
 		struct v4l2_frmivalenum *interval)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(filp);
 	struct mcam_format_struct *f;
 	struct v4l2_subdev_frame_interval_enum fie = {
 		.index = interval->index,
@@ -1625,7 +1625,7 @@ static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
 static int mcam_vidioc_g_register(struct file *file, void *priv,
 		struct v4l2_dbg_register *reg)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(file);
 
 	if (reg->reg > cam->regs_size - 4)
 		return -EINVAL;
@@ -1637,7 +1637,7 @@ static int mcam_vidioc_g_register(struct file *file, void *priv,
 static int mcam_vidioc_s_register(struct file *file, void *priv,
 		const struct v4l2_dbg_register *reg)
 {
-	struct mcam_camera *cam = priv;
+	struct mcam_camera *cam = video_drvdata(file);
 
 	if (reg->reg > cam->regs_size - 4)
 		return -EINVAL;
@@ -1678,9 +1678,10 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 static int mcam_v4l_open(struct file *filp)
 {
 	struct mcam_camera *cam = video_drvdata(filp);
-	int ret = 0;
+	int ret = v4l2_fh_open(filp);
 
-	filp->private_data = cam;
+	if (ret)
+		return ret;
 
 	cam->frame_state.frames = 0;
 	cam->frame_state.singles = 0;
@@ -1699,13 +1700,15 @@ static int mcam_v4l_open(struct file *filp)
 	(cam->users)++;
 out:
 	mutex_unlock(&cam->s_mutex);
+	if (ret)
+		v4l2_fh_release(filp);
 	return ret;
 }
 
 
 static int mcam_v4l_release(struct file *filp)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 
 	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
 			cam->frame_state.frames, cam->frame_state.singles,
@@ -1722,13 +1725,14 @@ static int mcam_v4l_release(struct file *filp)
 	}
 
 	mutex_unlock(&cam->s_mutex);
+	v4l2_fh_release(filp);
 	return 0;
 }
 
 static ssize_t mcam_v4l_read(struct file *filp,
 		char __user *buffer, size_t len, loff_t *pos)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1743,7 +1747,7 @@ static ssize_t mcam_v4l_read(struct file *filp,
 static unsigned int mcam_v4l_poll(struct file *filp,
 		struct poll_table_struct *pt)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
@@ -1755,7 +1759,7 @@ static unsigned int mcam_v4l_poll(struct file *filp,
 
 static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
 	mutex_lock(&cam->s_mutex);
-- 
2.1.4

