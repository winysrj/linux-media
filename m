Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2488 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2EFM2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/17] gspca: use video_drvdata(file) instead of file->private_data.
Date: Sun,  6 May 2012 14:28:18 +0200
Message-Id: <d645ee49552944146180c0717eddf1188527fb19.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Prepare for control events: free up file->private_data by using
video_drvdata(file) to get to the gspca_dev struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |   64 ++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 7668e24..271e339 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1061,7 +1061,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 			struct v4l2_dbg_register *reg)
 {
 	int ret;
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
 		return -EINVAL;
@@ -1085,7 +1085,7 @@ static int vidioc_s_register(struct file *file, void *priv,
 			struct v4l2_dbg_register *reg)
 {
 	int ret;
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
 		return -EINVAL;
@@ -1110,7 +1110,7 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 			struct v4l2_dbg_chip_ident *chip)
 {
 	int ret;
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->get_chip_ident)
 		return -EINVAL;
@@ -1130,7 +1130,7 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 				struct v4l2_fmtdesc *fmtdesc)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int i, j, index;
 	__u32 fmt_tb[8];
 
@@ -1172,7 +1172,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *fmt)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int mode;
 
 	mode = gspca_dev->curr_mode;
@@ -1217,7 +1217,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file,
 			      void *priv,
 			      struct v4l2_format *fmt)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	ret = try_fmt_vid_cap(gspca_dev, fmt);
@@ -1229,7 +1229,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *fmt)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
@@ -1268,7 +1268,7 @@ out:
 static int vidioc_enum_framesizes(struct file *file, void *priv,
 				  struct v4l2_frmsizeenum *fsize)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int i;
 	__u32 index = 0;
 
@@ -1294,7 +1294,7 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(filp);
 	int mode = wxh_to_mode(gspca_dev, fival->width, fival->height);
 	__u32 i;
 
@@ -1333,10 +1333,9 @@ static void gspca_release(struct video_device *vfd)
 
 static int dev_open(struct file *file)
 {
-	struct gspca_dev *gspca_dev;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	PDEBUG(D_STREAM, "[%s] open", current->comm);
-	gspca_dev = (struct gspca_dev *) video_devdata(file);
 	if (!gspca_dev->present)
 		return -ENODEV;
 
@@ -1344,7 +1343,6 @@ static int dev_open(struct file *file)
 	if (!try_module_get(gspca_dev->module))
 		return -ENODEV;
 
-	file->private_data = gspca_dev;
 #ifdef GSPCA_DEBUG
 	/* activate the v4l2 debug */
 	if (gspca_debug & D_V4L2)
@@ -1359,7 +1357,7 @@ static int dev_open(struct file *file)
 
 static int dev_close(struct file *file)
 {
-	struct gspca_dev *gspca_dev = file->private_data;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	PDEBUG(D_STREAM, "[%s] close", current->comm);
 	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
@@ -1375,7 +1373,6 @@ static int dev_close(struct file *file)
 		}
 		frame_free(gspca_dev);
 	}
-	file->private_data = NULL;
 	module_put(gspca_dev->module);
 	mutex_unlock(&gspca_dev->queue_lock);
 
@@ -1387,7 +1384,7 @@ static int dev_close(struct file *file)
 static int vidioc_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	/* protect the access to the usb device */
@@ -1439,7 +1436,7 @@ static int get_ctrl(struct gspca_dev *gspca_dev,
 static int vidioc_queryctrl(struct file *file, void *priv,
 			   struct v4l2_queryctrl *q_ctrl)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	const struct ctrl *ctrls;
 	struct gspca_ctrl *gspca_ctrl;
 	int i, idx;
@@ -1482,7 +1479,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 static int vidioc_s_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	const struct ctrl *ctrls;
 	struct gspca_ctrl *gspca_ctrl;
 	int idx, ret;
@@ -1531,7 +1528,7 @@ out:
 static int vidioc_g_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	const struct ctrl *ctrls;
 	int idx, ret;
 
@@ -1562,7 +1559,7 @@ out:
 static int vidioc_querymenu(struct file *file, void *priv,
 			    struct v4l2_querymenu *qmenu)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (!gspca_dev->sd_desc->querymenu)
 		return -EINVAL;
@@ -1572,7 +1569,7 @@ static int vidioc_querymenu(struct file *file, void *priv,
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *input)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	if (input->index != 0)
 		return -EINVAL;
@@ -1599,7 +1596,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *rb)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int i, ret = 0, streaming;
 
 	i = rb->memory;			/* (avoid compilation warning) */
@@ -1670,7 +1667,7 @@ out:
 static int vidioc_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *v4l2_buf)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	struct gspca_frame *frame;
 
 	if (v4l2_buf->index < 0
@@ -1685,7 +1682,7 @@ static int vidioc_querybuf(struct file *file, void *priv,
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type buf_type)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1726,7 +1723,7 @@ out:
 static int vidioc_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type buf_type)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1770,7 +1767,7 @@ out:
 static int vidioc_g_jpegcomp(struct file *file, void *priv,
 			struct v4l2_jpegcompression *jpegcomp)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	if (!gspca_dev->sd_desc->get_jcomp)
@@ -1789,7 +1786,7 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 static int vidioc_s_jpegcomp(struct file *file, void *priv,
 			struct v4l2_jpegcompression *jpegcomp)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	if (!gspca_dev->sd_desc->set_jcomp)
@@ -1808,7 +1805,7 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 static int vidioc_g_parm(struct file *filp, void *priv,
 			struct v4l2_streamparm *parm)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	parm->parm.capture.readbuffers = gspca_dev->nbufread;
 
@@ -1834,7 +1831,7 @@ static int vidioc_g_parm(struct file *filp, void *priv,
 static int vidioc_s_parm(struct file *filp, void *priv,
 			struct v4l2_streamparm *parm)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(filp);
 	int n;
 
 	n = parm->parm.capture.readbuffers;
@@ -1864,7 +1861,7 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 
 static int dev_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct gspca_dev *gspca_dev = file->private_data;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	struct gspca_frame *frame;
 	struct page *page;
 	unsigned long addr, start, size;
@@ -1967,7 +1964,7 @@ static int frame_ready(struct gspca_dev *gspca_dev, struct file *file,
 static int vidioc_dqbuf(struct file *file, void *priv,
 			struct v4l2_buffer *v4l2_buf)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	struct gspca_frame *frame;
 	int i, j, ret;
 
@@ -2043,7 +2040,7 @@ out:
 static int vidioc_qbuf(struct file *file, void *priv,
 			struct v4l2_buffer *v4l2_buf)
 {
-	struct gspca_dev *gspca_dev = priv;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	struct gspca_frame *frame;
 	int i, index, ret;
 
@@ -2137,7 +2134,7 @@ static int read_alloc(struct gspca_dev *gspca_dev,
 
 static unsigned int dev_poll(struct file *file, poll_table *wait)
 {
-	struct gspca_dev *gspca_dev = file->private_data;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	int ret;
 
 	PDEBUG(D_FRAM, "poll");
@@ -2168,7 +2165,7 @@ static unsigned int dev_poll(struct file *file, poll_table *wait)
 static ssize_t dev_read(struct file *file, char __user *data,
 		    size_t count, loff_t *ppos)
 {
-	struct gspca_dev *gspca_dev = file->private_data;
+	struct gspca_dev *gspca_dev = video_drvdata(file);
 	struct gspca_frame *frame;
 	struct v4l2_buffer v4l2_buf;
 	struct timeval timestamp;
@@ -2353,6 +2350,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
 	gspca_dev->vdev = gspca_template;
 	gspca_dev->vdev.parent = &intf->dev;
+	video_set_drvdata(&gspca_dev->vdev, gspca_dev);
 	gspca_dev->module = module;
 	gspca_dev->present = 1;
 
-- 
1.7.10

