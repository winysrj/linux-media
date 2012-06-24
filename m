Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1330 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2FXL3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/26] cpia2: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:55 +0200
Message-Id: <c3855da01d18443d4c13813f9a4ba2b1980219ce.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cpia2/cpia2_v4l.c |   39 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 55e9290..8c18cb1 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -84,21 +84,26 @@ MODULE_VERSION(CPIA_VERSION);
 static int cpia2_open(struct file *file)
 {
 	struct camera_data *cam = video_drvdata(file);
-	int retval = v4l2_fh_open(file);
+	int retval;
 
+	if (mutex_lock_interruptible(&cam->v4l2_lock))
+		return -ERESTARTSYS;
+	retval = v4l2_fh_open(file);
 	if (retval)
-		return retval;
+		goto open_unlock;
 
 	if (v4l2_fh_is_singular_file(file)) {
 		if (cpia2_allocate_buffers(cam)) {
 			v4l2_fh_release(file);
-			return -ENOMEM;
+			retval = -ENOMEM;
+			goto open_unlock;
 		}
 
 		/* reset the camera */
 		if (cpia2_reset_camera(cam) < 0) {
 			v4l2_fh_release(file);
-			return -EIO;
+			retval = -EIO;
+			goto open_unlock;
 		}
 
 		cam->APP_len = 0;
@@ -106,7 +111,9 @@ static int cpia2_open(struct file *file)
 	}
 
 	cpia2_dbg_dump_registers(cam);
-	return 0;
+open_unlock:
+	mutex_unlock(&cam->v4l2_lock);
+	return retval;
 }
 
 /******************************************************************************
@@ -119,6 +126,7 @@ static int cpia2_close(struct file *file)
 	struct video_device *dev = video_devdata(file);
 	struct camera_data *cam = video_get_drvdata(dev);
 
+	mutex_lock(&cam->v4l2_lock);
 	if (video_is_registered(&cam->vdev) && v4l2_fh_is_singular_file(file)) {
 		cpia2_usb_stream_stop(cam);
 
@@ -133,6 +141,7 @@ static int cpia2_close(struct file *file)
 		cam->stream_fh = NULL;
 		cam->mmapped = 0;
 	}
+	mutex_unlock(&cam->v4l2_lock);
 	return v4l2_fh_release(file);
 }
 
@@ -146,11 +155,16 @@ static ssize_t cpia2_v4l_read(struct file *file, char __user *buf, size_t count,
 {
 	struct camera_data *cam = video_drvdata(file);
 	int noblock = file->f_flags&O_NONBLOCK;
+	ssize_t ret;
 
 	if(!cam)
 		return -EINVAL;
 
-	return cpia2_read(cam, buf, count, noblock);
+	if (mutex_lock_interruptible(&cam->v4l2_lock))
+		return -ERESTARTSYS;
+	ret = cpia2_read(cam, buf, count, noblock);
+	mutex_unlock(&cam->v4l2_lock);
+	return ret;
 }
 
 
@@ -162,8 +176,12 @@ static ssize_t cpia2_v4l_read(struct file *file, char __user *buf, size_t count,
 static unsigned int cpia2_v4l_poll(struct file *filp, struct poll_table_struct *wait)
 {
 	struct camera_data *cam = video_drvdata(filp);
+	unsigned int res;
 
-	return cpia2_poll(cam, filp, wait);
+	mutex_lock(&cam->v4l2_lock);
+	res = cpia2_poll(cam, filp, wait);
+	mutex_unlock(&cam->v4l2_lock);
+	return res;
 }
 
 
@@ -987,10 +1005,13 @@ static int cpia2_mmap(struct file *file, struct vm_area_struct *area)
 	struct camera_data *cam = video_drvdata(file);
 	int retval;
 
+	if (mutex_lock_interruptible(&cam->v4l2_lock))
+		return -ERESTARTSYS;
 	retval = cpia2_remap_buffer(cam, area);
 
 	if(!retval)
 		cam->stream_fh = file->private_data;
+	mutex_unlock(&cam->v4l2_lock);
 	return retval;
 }
 
@@ -1147,10 +1168,6 @@ int cpia2_register_camera(struct camera_data *cam)
 	cam->vdev.ctrl_handler = hdl;
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &cam->vdev.flags);
 
 	reset_camera_struct_v4l(cam);
 
-- 
1.7.10

