Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3506 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3BDMgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 07:36:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/8] stk-webcam: don't use private_data, use video_drvdata
Date: Mon,  4 Feb 2013 13:36:17 +0100
Message-Id: <8a7a6611db69c0db3a2864c18340c8814afead00.1359981193.git.hans.verkuil@cisco.com>
In-Reply-To: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2d4b37cad1af7790d44cc541b4a5519716e6a98c.1359981193.git.hans.verkuil@cisco.com>
References: <2d4b37cad1af7790d44cc541b4a5519716e6a98c.1359981193.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

file->private_data is needed to store the pointer to struct v4l2_fh.
So use video_drvdata to get hold of the stk_camera struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   32 +++++++++++++-----------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index ff5b461..24dc240 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -566,11 +566,7 @@ static void stk_free_buffers(struct stk_camera *dev)
 static int v4l_stk_open(struct file *fp)
 {
 	static int first_init = 1; /* webcam LED management */
-	struct stk_camera *dev;
-	struct video_device *vdev;
-
-	vdev = video_devdata(fp);
-	dev = vdev_to_camera(vdev);
+	struct stk_camera *dev = video_drvdata(fp);
 
 	if (dev == NULL || !is_present(dev))
 		return -ENXIO;
@@ -580,7 +576,6 @@ static int v4l_stk_open(struct file *fp)
 	else
 		first_init = 0;
 
-	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);
 
 	return 0;
@@ -588,7 +583,7 @@ static int v4l_stk_open(struct file *fp)
 
 static int v4l_stk_release(struct file *fp)
 {
-	struct stk_camera *dev = fp->private_data;
+	struct stk_camera *dev = video_drvdata(fp);
 
 	if (dev->owner == fp) {
 		stk_stop_stream(dev);
@@ -611,7 +606,7 @@ static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
 	int ret;
 	unsigned long flags;
 	struct stk_sio_buffer *sbuf;
-	struct stk_camera *dev = fp->private_data;
+	struct stk_camera *dev = video_drvdata(fp);
 
 	if (!is_present(dev))
 		return -EIO;
@@ -667,7 +662,7 @@ static ssize_t v4l_stk_read(struct file *fp, char __user *buf,
 
 static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
 {
-	struct stk_camera *dev = fp->private_data;
+	struct stk_camera *dev = video_drvdata(fp);
 
 	poll_wait(fp, &dev->wait_frame, wait);
 
@@ -703,7 +698,7 @@ static int v4l_stk_mmap(struct file *fp, struct vm_area_struct *vma)
 	unsigned int i;
 	int ret;
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	struct stk_camera *dev = fp->private_data;
+	struct stk_camera *dev = video_drvdata(fp);
 	struct stk_sio_buffer *sbuf = NULL;
 
 	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
@@ -841,7 +836,7 @@ static int stk_vidioc_g_fmt_vid_cap(struct file *filp,
 		void *priv, struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix_format = &f->fmt.pix;
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(stk_sizes) &&
@@ -946,7 +941,7 @@ static int stk_vidioc_s_fmt_vid_cap(struct file *filp,
 		void *priv, struct v4l2_format *fmtd)
 {
 	int ret;
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 
 	if (dev == NULL)
 		return -ENODEV;
@@ -973,7 +968,7 @@ static int stk_vidioc_s_fmt_vid_cap(struct file *filp,
 static int stk_vidioc_reqbufs(struct file *filp,
 		void *priv, struct v4l2_requestbuffers *rb)
 {
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 
 	if (dev == NULL)
 		return -ENODEV;
@@ -999,7 +994,7 @@ static int stk_vidioc_reqbufs(struct file *filp,
 static int stk_vidioc_querybuf(struct file *filp,
 		void *priv, struct v4l2_buffer *buf)
 {
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 	struct stk_sio_buffer *sbuf;
 
 	if (buf->index >= dev->n_sbufs)
@@ -1012,7 +1007,7 @@ static int stk_vidioc_querybuf(struct file *filp,
 static int stk_vidioc_qbuf(struct file *filp,
 		void *priv, struct v4l2_buffer *buf)
 {
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 	struct stk_sio_buffer *sbuf;
 	unsigned long flags;
 
@@ -1036,7 +1031,7 @@ static int stk_vidioc_qbuf(struct file *filp,
 static int stk_vidioc_dqbuf(struct file *filp,
 		void *priv, struct v4l2_buffer *buf)
 {
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 	struct stk_sio_buffer *sbuf;
 	unsigned long flags;
 	int ret;
@@ -1069,7 +1064,7 @@ static int stk_vidioc_dqbuf(struct file *filp,
 static int stk_vidioc_streamon(struct file *filp,
 		void *priv, enum v4l2_buf_type type)
 {
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 	if (is_streaming(dev))
 		return 0;
 	if (dev->sio_bufs == NULL)
@@ -1081,7 +1076,7 @@ static int stk_vidioc_streamon(struct file *filp,
 static int stk_vidioc_streamoff(struct file *filp,
 		void *priv, enum v4l2_buf_type type)
 {
-	struct stk_camera *dev = priv;
+	struct stk_camera *dev = video_drvdata(filp);
 	unsigned long flags;
 	int i;
 	stk_stop_stream(dev);
@@ -1184,6 +1179,7 @@ static int stk_register_video_device(struct stk_camera *dev)
 	dev->vdev = stk_v4l_data;
 	dev->vdev.debug = debug;
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	video_set_drvdata(&dev->vdev, dev);
 	err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (err)
 		STK_ERROR("v4l registration failed\n");
-- 
1.7.10.4

