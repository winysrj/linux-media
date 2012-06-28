Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3923 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2F1Gst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 32/33] pwc: use the new vb2 helpers.
Date: Thu, 28 Jun 2012 08:48:26 +0200
Message-Id: <fe94fb1fde888fe98c55f9af3936f67a292d518e.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/pwc/pwc-if.c  |  155 ++++---------------------------------
 drivers/media/video/pwc/pwc-v4l.c |  140 +++------------------------------
 drivers/media/video/pwc/pwc.h     |    3 -
 3 files changed, 24 insertions(+), 274 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index ec4e2ef..b310c14 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -136,19 +136,13 @@ static int leds[2] = { 100, 0 };
 
 /***/
 
-static int pwc_video_close(struct file *file);
-static ssize_t pwc_video_read(struct file *file, char __user *buf,
-			  size_t count, loff_t *ppos);
-static unsigned int pwc_video_poll(struct file *file, poll_table *wait);
-static int  pwc_video_mmap(struct file *file, struct vm_area_struct *vma);
-
 static const struct v4l2_file_operations pwc_fops = {
 	.owner =	THIS_MODULE,
 	.open =		v4l2_fh_open,
-	.release =     	pwc_video_close,
-	.read =		pwc_video_read,
-	.poll =		pwc_video_poll,
-	.mmap =		pwc_video_mmap,
+	.release =	vb2_fop_release,
+	.read =		vb2_fop_read,
+	.poll =		vb2_fop_poll,
+	.mmap =		vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
 static struct video_device pwc_template = {
@@ -562,17 +556,6 @@ static const char *pwc_sensor_type_to_string(unsigned int sensor_type)
 /***************************************************************************/
 /* Video4Linux functions */
 
-int pwc_test_n_set_capt_file(struct pwc_device *pdev, struct file *file)
-{
-	if (pdev->capt_file != NULL &&
-	    pdev->capt_file != file)
-		return -EBUSY;
-
-	pdev->capt_file = file;
-
-	return 0;
-}
-
 static void pwc_video_release(struct v4l2_device *v)
 {
 	struct pwc_device *pdev = container_of(v, struct pwc_device, v4l2_dev);
@@ -583,113 +566,6 @@ static void pwc_video_release(struct v4l2_device *v)
 	kfree(pdev);
 }
 
-static int pwc_video_close(struct file *file)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-
-	/*
-	 * If we're still streaming vb2_queue_release will call stream_stop
-	 * so we must take both the v4l2_lock and the vb_queue_lock.
-	 */
-	if (mutex_lock_interruptible(&pdev->v4l2_lock))
-		return -ERESTARTSYS;
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock)) {
-		mutex_unlock(&pdev->v4l2_lock);
-		return -ERESTARTSYS;
-	}
-
-	if (pdev->capt_file == file) {
-		vb2_queue_release(&pdev->vb_queue);
-		pdev->capt_file = NULL;
-	}
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	mutex_unlock(&pdev->v4l2_lock);
-
-	return v4l2_fh_release(file);
-}
-
-static ssize_t pwc_video_read(struct file *file, char __user *buf,
-			      size_t count, loff_t *ppos)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int lock_v4l2 = 0;
-	ssize_t ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret)
-		goto out;
-
-	/* stream_start will get called so we must take the v4l2_lock */
-	if (pdev->vb_queue.fileio == NULL)
-		lock_v4l2 = 1;
-
-	/* Use try_lock, since we're taking the locks in the *wrong* order! */
-	if (lock_v4l2 && !mutex_trylock(&pdev->v4l2_lock)) {
-		ret = -ERESTARTSYS;
-		goto out;
-	}
-	ret = vb2_read(&pdev->vb_queue, buf, count, ppos,
-		       file->f_flags & O_NONBLOCK);
-	if (lock_v4l2)
-		mutex_unlock(&pdev->v4l2_lock);
-out:
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static unsigned int pwc_video_poll(struct file *file, poll_table *wait)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	struct vb2_queue *q = &pdev->vb_queue;
-	unsigned long req_events = poll_requested_events(wait);
-	unsigned int ret = POLL_ERR;
-	int lock_v4l2 = 0;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return POLL_ERR;
-
-	/* Will this start fileio and thus call start_stream? */
-	if ((req_events & (POLLIN | POLLRDNORM)) &&
-	    q->num_buffers == 0 && !q->streaming && q->fileio == NULL) {
-		if (pwc_test_n_set_capt_file(pdev, file))
-			goto out;
-		lock_v4l2 = 1;
-	}
-
-	/* Use try_lock, since we're taking the locks in the *wrong* order! */
-	if (lock_v4l2 && !mutex_trylock(&pdev->v4l2_lock))
-		goto out;
-	ret = vb2_poll(&pdev->vb_queue, file, wait);
-	if (lock_v4l2)
-		mutex_unlock(&pdev->v4l2_lock);
-
-out:
-	if (!pdev->udev)
-		ret |= POLLHUP;
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_mmap(&pdev->vb_queue, vma);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
 /***************************************************************************/
 /* Videobuf2 operations */
 
@@ -782,6 +658,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (!pdev->udev)
 		return -ENODEV;
 
+	if (mutex_lock_interruptible(&pdev->v4l2_lock))
+		return -ERESTARTSYS;
 	/* Turn on camera and set LEDS on */
 	pwc_camera_power(pdev, 1);
 	pwc_set_leds(pdev, leds[0], leds[1]);
@@ -794,6 +672,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 		/* And cleanup any queued bufs!! */
 		pwc_cleanup_queued_bufs(pdev);
 	}
+	mutex_unlock(&pdev->v4l2_lock);
 
 	return r;
 }
@@ -802,6 +681,8 @@ static int stop_streaming(struct vb2_queue *vq)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 
+	if (mutex_lock_interruptible(&pdev->v4l2_lock))
+		return -ERESTARTSYS;
 	if (pdev->udev) {
 		pwc_set_leds(pdev, 0, 0);
 		pwc_camera_power(pdev, 0);
@@ -809,6 +690,7 @@ static int stop_streaming(struct vb2_queue *vq)
 	}
 
 	pwc_cleanup_queued_bufs(pdev);
+	mutex_unlock(&pdev->v4l2_lock);
 
 	return 0;
 }
@@ -1136,6 +1018,8 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	/* Init video_device structure */
 	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
 	strcpy(pdev->vdev.name, name);
+	pdev->vdev.queue = &pdev->vb_queue;
+	pdev->vdev.queue->lock = &pdev->vb_queue_lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &pdev->vdev.flags);
 	video_set_drvdata(&pdev->vdev, pdev);
 
@@ -1190,15 +1074,6 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->vdev.v4l2_dev = &pdev->v4l2_dev;
 	pdev->vdev.lock = &pdev->v4l2_lock;
 
-	/*
-	 * Don't take v4l2_lock for these ioctls. This improves latency if
-	 * v4l2_lock is taken for a long time, e.g. when changing a control
-	 * value, and a new frame is ready to be dequeued.
-	 */
-	v4l2_disable_ioctl_locking(&pdev->vdev, VIDIOC_DQBUF);
-	v4l2_disable_ioctl_locking(&pdev->vdev, VIDIOC_QBUF);
-	v4l2_disable_ioctl_locking(&pdev->vdev, VIDIOC_QUERYBUF);
-
 	rc = video_register_device(&pdev->vdev, VFL_TYPE_GRABBER, -1);
 	if (rc < 0) {
 		PWC_ERROR("Failed to register as video device (%d).\n", rc);
@@ -1253,20 +1128,18 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	struct v4l2_device *v = usb_get_intfdata(intf);
 	struct pwc_device *pdev = container_of(v, struct pwc_device, v4l2_dev);
 
-	mutex_lock(&pdev->v4l2_lock);
-
 	mutex_lock(&pdev->vb_queue_lock);
+	mutex_lock(&pdev->v4l2_lock);
 	/* No need to keep the urbs around after disconnection */
 	if (pdev->vb_queue.streaming)
 		pwc_isoc_cleanup(pdev);
 	pdev->udev = NULL;
 	pwc_cleanup_queued_bufs(pdev);
-	mutex_unlock(&pdev->vb_queue_lock);
 
 	v4l2_device_disconnect(&pdev->v4l2_dev);
 	video_unregister_device(&pdev->vdev);
-
 	mutex_unlock(&pdev->v4l2_lock);
+	mutex_unlock(pdev->vb_queue.lock);
 
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 	if (pdev->button_dev)
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index c691e29..114ae41 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -468,17 +468,8 @@ static int pwc_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f)
 	if (ret < 0)
 		return ret;
 
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret)
-		goto leave;
-
-	if (pdev->vb_queue.streaming) {
-		ret = -EBUSY;
-		goto leave;
-	}
+	if (vb2_is_busy(&pdev->vb_queue))
+		return -EBUSY;
 
 	pixelformat = f->fmt.pix.pixelformat;
 
@@ -496,8 +487,6 @@ static int pwc_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f)
 	PWC_DEBUG_IOCTL("pwc_set_video_mode(), return=%d\n", ret);
 
 	pwc_vidioc_fill_fmt(f, pdev->width, pdev->height, pdev->pixfmt);
-leave:
-	mutex_unlock(&pdev->vb_queue_lock);
 	return ret;
 }
 
@@ -933,104 +922,6 @@ static int pwc_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *
 	return pwc_vidioc_try_fmt(pdev, f);
 }
 
-static int pwc_reqbufs(struct file *file, void *fh,
-		       struct v4l2_requestbuffers *rb)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_reqbufs(&pdev->vb_queue, rb);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static int pwc_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_querybuf(&pdev->vb_queue, buf);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static int pwc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_qbuf(&pdev->vb_queue, buf);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static int pwc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_dqbuf(&pdev->vb_queue, buf,
-				file->f_flags & O_NONBLOCK);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static int pwc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_streamon(&pdev->vb_queue, i);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
-static int pwc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
-{
-	struct pwc_device *pdev = video_drvdata(file);
-	int ret;
-
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret == 0)
-		ret = vb2_streamoff(&pdev->vb_queue, i);
-
-	mutex_unlock(&pdev->vb_queue_lock);
-	return ret;
-}
-
 static int pwc_enum_framesizes(struct file *file, void *fh,
 					 struct v4l2_frmsizeenum *fsize)
 {
@@ -1119,25 +1010,14 @@ static int pwc_s_parm(struct file *file, void *fh,
 	fps = parm->parm.capture.timeperframe.denominator /
 	      parm->parm.capture.timeperframe.numerator;
 
-	if (mutex_lock_interruptible(&pdev->vb_queue_lock))
-		return -ERESTARTSYS;
-
-	ret = pwc_test_n_set_capt_file(pdev, file);
-	if (ret)
-		goto leave;
-
-	if (pdev->vb_queue.streaming) {
-		ret = -EBUSY;
-		goto leave;
-	}
+	if (vb2_is_busy(&pdev->vb_queue))
+		return -EBUSY;
 
 	ret = pwc_set_video_mode(pdev, pdev->width, pdev->height, pdev->pixfmt,
 				 fps, &compression, 0);
 
 	pwc_g_parm(file, fh, parm);
 
-leave:
-	mutex_unlock(&pdev->vb_queue_lock);
 	return ret;
 }
 
@@ -1150,12 +1030,12 @@ const struct v4l2_ioctl_ops pwc_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap		    = pwc_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		    = pwc_s_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap		    = pwc_try_fmt_vid_cap,
-	.vidioc_reqbufs			    = pwc_reqbufs,
-	.vidioc_querybuf		    = pwc_querybuf,
-	.vidioc_qbuf			    = pwc_qbuf,
-	.vidioc_dqbuf			    = pwc_dqbuf,
-	.vidioc_streamon		    = pwc_streamon,
-	.vidioc_streamoff		    = pwc_streamoff,
+	.vidioc_reqbufs			    = vb2_ioctl_reqbufs,
+	.vidioc_querybuf		    = vb2_ioctl_querybuf,
+	.vidioc_qbuf			    = vb2_ioctl_qbuf,
+	.vidioc_dqbuf			    = vb2_ioctl_dqbuf,
+	.vidioc_streamon		    = vb2_ioctl_streamon,
+	.vidioc_streamoff		    = vb2_ioctl_streamoff,
 	.vidioc_log_status		    = v4l2_ctrl_log_status,
 	.vidioc_enum_framesizes		    = pwc_enum_framesizes,
 	.vidioc_enum_frameintervals	    = pwc_enum_frameintervals,
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index d6b5b21..7a6a0d3 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -239,7 +239,6 @@ struct pwc_device
 	int features;		/* feature bits */
 
 	/*** Video data ***/
-	struct file *capt_file;	/* file doing video capture */
 	int vendpoint;		/* video isoc endpoint */
 	int vcinterface;	/* video control interface */
 	int valternate;		/* alternate interface needed */
@@ -355,8 +354,6 @@ struct pwc_device
 extern int pwc_trace;
 #endif
 
-int pwc_test_n_set_capt_file(struct pwc_device *pdev, struct file *file);
-
 /** Functions in pwc-misc.c */
 /* sizes in pixels */
 extern const int pwc_image_sizes[PSZ_MAX][2];
-- 
1.7.10

