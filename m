Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52686 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbZKRAiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Use video_device_node_name() instead of the minor number
Date: Wed, 18 Nov 2009 01:38:49 +0100
Message-Id: <1258504731-8430-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using the minor number in kernel log messages, use the device
node name as returned by the video_device_node_name() function. This
makes debug, informational and error messages easier to understand for
end users.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/tm6000/tm6000-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-video.c
@@ -1359,17 +1359,17 @@ static int vidioc_s_frequency (struct fi
 
 static int tm6000_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct tm6000_core *dev = video_drvdata(file);
 	struct tm6000_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	int i,rc;
 
-	printk(KERN_INFO "tm6000: open called (minor=%d)\n",minor);
+	printk(KERN_INFO "tm6000: open called (dev=%s)\n",
+		video_device_node_name(vdev));
 
-
-	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called "
-						"(minor=%d)\n",minor);
+	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called (dev=%s)\n",
+		video_device_node_name(vdev));
 
 #if 0 /* Avoids an oops at read() - seems to be semaphore related */
 	if (dev->users) {
@@ -1381,8 +1381,8 @@ static int tm6000_open(struct file *file
 	/* If more than one user, mutex should be added */
 	dev->users++;
 
-	dprintk(dev, V4L2_DEBUG_OPEN, "open minor=%d type=%s users=%d\n",
-				minor,v4l2_type_names[type],dev->users);
+	dprintk(dev, V4L2_DEBUG_OPEN, "open dev=%s type=%s users=%d\n",
+		video_device_node_name(vdev),v4l2_type_names[type],dev->users);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
@@ -1494,9 +1494,10 @@ static int tm6000_release(struct file *f
 {
 	struct tm6000_fh         *fh = file->private_data;
 	struct tm6000_core      *dev = fh->dev;
-	int minor = video_devdata(file)->minor;
+	struct video_device    *vdev = video_devdata(file);
 
-	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: close called (minor=%d, users=%d)\n",minor,dev->users);
+	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: close called (dev=%s, users=%d)\n",
+		video_device_node_name(vdev), dev->users);
 
 	dev->users--;
 
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-audups11.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-audups11.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-audups11.c
@@ -94,12 +94,13 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video0.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video0.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video0.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video1.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video1.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video1.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video2.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video2.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video2.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video3.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video3.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video3.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video4.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video4.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video4.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video5.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video5.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video5.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video6.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video6.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video6.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video7.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video7.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video7.c
@@ -93,13 +93,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-videoioctl.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-videoioctl.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-videoioctl.c
@@ -94,13 +94,14 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups10.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-vidups10.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups10.c
@@ -94,12 +94,13 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups9.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-vidups9.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups9.c
@@ -94,12 +94,13 @@ static struct videobuf_queue_ops cx25821
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
+	printk("open dev=%s type=%s\n", video_device_node_name(vdev),
+		v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/common/saa7146_fops.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
@@ -195,7 +195,6 @@ void saa7146_buffer_timeout(unsigned lon
 
 static int fops_open(struct file *file)
 {
-	unsigned int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146_dev *dev = video_drvdata(file);
 	struct saa7146_fh *fh = NULL;
@@ -203,7 +202,7 @@ static int fops_open(struct file *file)
 
 	enum v4l2_buf_type type;
 
-	DEB_EE(("file:%p, minor:%d\n", file, minor));
+	DEB_EE(("file:%p, dev:%s\n", file, video_device_node_name(vdev)));
 
 	if (mutex_lock_interruptible(&saa7146_devices_lock))
 		return -ERESTARTSYS;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/bt8xx/bttv-driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
@@ -3235,11 +3235,12 @@ err:
 static int bttv_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct bttv *btv = video_drvdata(file);
 	struct bttv_fh *fh;
 	enum v4l2_buf_type type = 0;
 
-	dprintk(KERN_DEBUG "bttv: open minor=%d\n",minor);
+	dprintk(KERN_DEBUG "bttv: open dev=%s\n", video_device_node_name(vdev));
 
 	lock_kernel();
 	if (btv->video_dev->minor == minor) {
@@ -3437,10 +3438,11 @@ static struct video_device bttv_video_te
 static int radio_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct bttv *btv = video_drvdata(file);
 	struct bttv_fh *fh;
 
-	dprintk("bttv: open minor=%d\n",minor);
+	dprintk("bttv: open dev=%s\n", video_device_node_name(vdev));
 
 	lock_kernel();
 	WARN_ON(btv->radio_dev && btv->radio_dev->minor != minor);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx18/cx18-fileops.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx18/cx18-fileops.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx18/cx18-fileops.c
@@ -730,8 +730,8 @@ int cx18_v4l2_open(struct file *filp)
 
 	mutex_lock(&cx->serialize_lock);
 	if (cx18_init_on_first_open(cx)) {
-		CX18_ERR("Failed to initialize on minor %d\n",
-			 video_dev->minor);
+		CX18_ERR("Failed to initialize on %s\n",
+			 video_device_node_name(video_dev));
 		mutex_unlock(&cx->serialize_lock);
 		return -ENXIO;
 	}
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
@@ -1916,7 +1916,6 @@ static int radio_queryctrl(struct file *
  */
 static int cx231xx_v4l2_open(struct file *filp)
 {
-	int minor = video_devdata(filp)->minor;
 	int errCode = 0, radio = 0;
 	struct video_device *vdev = video_devdata(filp);
 	struct cx231xx *dev = video_drvdata(filp);
@@ -1937,8 +1936,9 @@ static int cx231xx_v4l2_open(struct file
 
 	mutex_lock(&dev->lock);
 
-	cx231xx_videodbg("open minor=%d type=%s users=%d\n",
-			 minor, v4l2_type_names[fh_type], dev->users);
+	cx231xx_videodbg("open dev=%s type=%s users=%d\n",
+			 video_device_node_name(vdev), v4l2_type_names[fh_type],
+			 dev->users);
 
 #if 0				/* Keep */
 	errCode = cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/ivtv/ivtv-fileops.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/ivtv/ivtv-fileops.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/ivtv/ivtv-fileops.c
@@ -985,8 +985,8 @@ int ivtv_v4l2_open(struct file *filp)
 
 	mutex_lock(&itv->serialize_lock);
 	if (ivtv_init_on_first_open(itv)) {
-		IVTV_ERR("Failed to initialize on minor %d\n",
-				vdev->minor);
+		IVTV_ERR("Failed to initialize on device %s\n",
+			 video_device_node_name(vdev));
 		mutex_unlock(&itv->serialize_lock);
 		return -ENXIO;
 	}
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/ov511.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/ov511.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/ov511.c
@@ -5871,8 +5871,8 @@ ov51x_probe(struct usb_interface *intf, 
 	ov511_devused |= 1 << nr;
 	ov->nr = nr;
 
-	dev_info(&intf->dev, "Device at %s registered to minor %d\n",
-		 ov->usb_path, ov->vdev->minor);
+	dev_info(&intf->dev, "Device at %s registered to %s\n",
+		 ov->usb_path, video_device_node_name(ov->vdev));
 
 	usb_set_intfdata(intf, ov);
 	if (ov_create_sysfs(ov->vdev)) {
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/s2255drv.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
@@ -1531,7 +1531,6 @@ static int vidioc_s_parm(struct file *fi
 }
 static int s2255_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct s2255_dev *dev = video_drvdata(file);
 	struct s2255_fh *fh;
@@ -1539,7 +1538,9 @@ static int s2255_open(struct file *file)
 	int i = 0;
 	int cur_channel = -1;
 	int state;
-	dprintk(1, "s2255: open called (minor=%d)\n", minor);
+
+	dprintk(1, "s2255: open called (dev=%s)\n",
+		video_device_node_name(vdev));
 
 	lock_kernel();
 
@@ -1651,8 +1652,9 @@ static int s2255_open(struct file *file)
 	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
 		qctl_regs[i] = s2255_qctrl[i].default_value;
 
-	dprintk(1, "s2255drv: open minor=%d type=%s users=%d\n",
-		minor, v4l2_type_names[type], dev->users[cur_channel]);
+	dprintk(1, "s2255drv: open dev=%s type=%s users=%d\n",
+		video_device_node_name(vdev), v4l2_type_names[type],
+		dev->users[cur_channel]);
 	dprintk(2, "s2255drv: open: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n",
 		(unsigned long)fh, (unsigned long)dev,
 		(unsigned long)&dev->vidq[cur_channel]);
@@ -1729,7 +1731,8 @@ static int s2255_close(struct file *file
 {
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev = fh->dev;
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
+
 	if (!dev)
 		return -ENODEV;
 
@@ -1749,8 +1752,8 @@ static int s2255_close(struct file *file
 	mutex_unlock(&dev->open_lock);
 
 	kref_put(&dev->kref, s2255_destroy);
-	dprintk(1, "s2255: close called (minor=%d, users=%d)\n",
-		minor, dev->users[fh->channel]);
+	dprintk(1, "s2255: close called (dev=%s, users=%d)\n",
+		video_device_node_name(vdev), dev->users[fh->channel]);
 	kfree(fh);
 	return 0;
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/vivi.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
@@ -1225,8 +1225,7 @@ static int vivi_close(struct file *file)
 	struct vivi_fh         *fh = file->private_data;
 	struct vivi_dev *dev       = fh->dev;
 	struct vivi_dmaqueue *vidq = &dev->vidq;
-
-	int minor = video_devdata(file)->minor;
+	struct video_device  *vdev = video_devdata(file);
 
 	vivi_stop_thread(vidq);
 	videobuf_stop(&fh->vb_vidq);
@@ -1238,8 +1237,8 @@ static int vivi_close(struct file *file)
 	dev->users--;
 	mutex_unlock(&dev->mutex);
 
-	dprintk(dev, 1, "close called (minor=%d, users=%d)\n",
-		minor, dev->users);
+	dprintk(dev, 1, "close called (dev=%s, users=%d)\n",
+		video_device_node_name(vdev), dev->users);
 
 	return 0;
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-blackbird.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
@@ -1067,7 +1067,7 @@ static int vidioc_s_std (struct file *fi
 
 static int mpeg_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx8802_fh *fh;
 	struct cx8802_driver *drv = NULL;
@@ -1094,7 +1094,7 @@ static int mpeg_open(struct file *file)
 		unlock_kernel();
 		return -EINVAL;
 	}
-	dprintk(1,"open minor=%d\n",minor);
+	dprintk(1, "open dev=%s\n", video_device_node_name(vdev));
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
@@ -975,7 +975,6 @@ static int get_ressource(struct cx8800_f
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core;
@@ -997,8 +996,8 @@ static int video_open(struct file *file)
 
 	core = dev->core;
 
-	dprintk(1,"open minor=%d radio=%d type=%s\n",
-		minor,radio,v4l2_type_names[type]);
+	dprintk(1, "open dev=%s radio=%d type=%s\n",
+		video_device_node_name(vdev), radio, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
@@ -2123,7 +2123,6 @@ static int radio_queryctrl(struct file *
  */
 static int em28xx_v4l2_open(struct file *filp)
 {
-	int minor = video_devdata(filp)->minor;
 	int errCode = 0, radio = 0;
 	struct video_device *vdev = video_devdata(filp);
 	struct em28xx *dev = video_drvdata(filp);
@@ -2145,8 +2144,9 @@ static int em28xx_v4l2_open(struct file 
 
 	mutex_lock(&dev->lock);
 
-	em28xx_videodbg("open minor=%d type=%s users=%d\n",
-				minor, v4l2_type_names[fh_type], dev->users);
+	em28xx_videodbg("open dev=%s type=%s users=%d\n",
+			video_device_node_name(vdev), v4l2_type_names[fh_type],
+			dev->users);
 
 #if 0
 	errCode = em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-empress.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
@@ -86,11 +86,11 @@ static int ts_init_encoder(struct saa713
 
 static int ts_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
+	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
 
-	dprintk("open minor=%d\n",minor);
+	dprintk("open dev=%s\n", video_device_node_name(vdev));
 	err = -EBUSY;
 	if (!mutex_trylock(&dev->empress_tsq.vb_lock))
 		goto done;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-video.c
@@ -1326,7 +1326,6 @@ static int saa7134_resource(struct saa71
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh;
@@ -1345,8 +1344,8 @@ static int video_open(struct file *file)
 		break;
 	}
 
-	dprintk("open minor=%d radio=%d type=%s\n",minor,radio,
-		v4l2_type_names[type]);
+	dprintk("open dev=%s radio=%d type=%s\n", video_device_node_name(vdev),
+		radio, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
@@ -772,7 +772,6 @@ static int get_resource(struct cx23885_f
 
 static int video_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh;
@@ -791,8 +790,8 @@ static int video_open(struct file *file)
 		break;
 	}
 
-	dprintk(1, "open minor=%d radio=%d type=%s\n",
-		minor, radio, v4l2_type_names[type]);
+	dprintk(1, "open dev=%s radio=%d type=%s\n",
+		video_device_node_name(vdev), radio, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
