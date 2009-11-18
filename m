Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52685 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZKRAiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Use the video_drvdata function in drivers
Date: Wed, 18 Nov 2009 01:38:48 +0100
Message-Id: <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all device drivers to use the video_drvdata function instead of
maintaining a local list of minor to private data mappings. Call
video_set_drvdata to register the driver private pointer when not
already done.

Where applicable, the local list of mappings is completely removed when
it becomes unused.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-audups11.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-audups11.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-audups11.c
@@ -95,35 +95,18 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
-
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH11]
-		    && h->video_dev[SRAM_CH11]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev = dev;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video.c
@@ -189,6 +189,7 @@ struct video_device *cx25821_vdev_init(s
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name, type,
 		 cx25821_boards[dev->board].name);
+	video_set_drvdata(vfd, dev);
 	return vfd;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video0.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video0.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video0.c
@@ -95,36 +95,19 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH00]
-		    && h->video_dev[SRAM_CH00]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev = dev;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video1.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video1.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video1.c
@@ -95,36 +95,19 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH01]
-		    && h->video_dev[SRAM_CH01]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev = dev;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video2.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video2.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video2.c
@@ -95,36 +95,20 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH02]
-		    && h->video_dev[SRAM_CH02]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video3.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video3.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video3.c
@@ -95,36 +95,20 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH03]
-		    && h->video_dev[SRAM_CH03]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video4.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video4.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video4.c
@@ -95,36 +95,20 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH04]
-		    && h->video_dev[SRAM_CH04]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video5.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video5.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video5.c
@@ -95,36 +95,20 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH05]
-		    && h->video_dev[SRAM_CH05]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video6.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video6.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video6.c
@@ -95,36 +95,20 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH06]
-		    && h->video_dev[SRAM_CH06]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video7.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video7.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video7.c
@@ -94,36 +94,20 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH07]
-		    && h->video_dev[SRAM_CH07]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-videoioctl.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-videoioctl.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-videoioctl.c
@@ -95,35 +95,19 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
 
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->ioctl_dev && h->ioctl_dev->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev = dev;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups10.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-vidups10.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups10.c
@@ -95,35 +95,18 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
-
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH10]
-		    && h->video_dev[SRAM_CH10]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev = dev;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups9.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-vidups9.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-vidups9.c
@@ -95,35 +95,18 @@ static struct videobuf_queue_ops cx25821
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx25821_dev *h, *dev = NULL;
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
-
-	lock_kernel();
-	list_for_each(list, &cx25821_devlist) {
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		if (h->video_dev[SRAM_CH09]
-		    && h->video_dev[SRAM_CH09]->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
-	}
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	printk("open minor=%d type=%s\n", minor, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
 
 	file->private_data = fh;
 	fh->dev = dev;
Index: v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/tm6000/tm6000-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-video.c
@@ -121,8 +121,6 @@ static struct tm6000_fmt format[] = {
 	}
 };
 
-static LIST_HEAD(tm6000_corelist);
-
 /* ------------------------------------------------------------------
 	DMA and thread functions
    ------------------------------------------------------------------*/
@@ -1362,10 +1360,9 @@ static int vidioc_s_frequency (struct fi
 static int tm6000_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct tm6000_core *h,*dev = NULL;
+	struct tm6000_core *dev = video_drvdata(file);
 	struct tm6000_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	int i,rc;
 
 	printk(KERN_INFO "tm6000: open called (minor=%d)\n",minor);
@@ -1374,16 +1371,6 @@ static int tm6000_open(struct file *file
 	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called "
 						"(minor=%d)\n",minor);
 
-	list_for_each(list,&tm6000_corelist) {
-		h = list_entry(list, struct tm6000_core, tm6000_corelist);
-		if (h->vfd->minor == minor) {
-			dev  = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-	}
-	if (NULL == dev)
-		return -ENODEV;
-
 #if 0 /* Avoids an oops at read() - seems to be semaphore related */
 	if (dev->users) {
 		printk(KERN_INFO "this driver can be opened only once (users=%d)\n",dev->users);
@@ -1596,8 +1583,6 @@ int tm6000_v4l2_register(struct tm6000_c
 	}
 	dev->vfd = vfd;
 
-	list_add_tail(&dev->tm6000_corelist,&tm6000_corelist);
-
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vidq.queued);
@@ -1605,6 +1590,7 @@ int tm6000_v4l2_register(struct tm6000_c
 	memcpy (dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
 	dev->vfd->debug=tm6000_debug;
 	vfd->v4l2_dev = &dev->v4l2_dev;
+	video_set_drvdata(vfd, dev);
 
 	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000 USB2 board (Load status: %d)\n", ret);
@@ -1613,35 +1599,13 @@ int tm6000_v4l2_register(struct tm6000_c
 
 int tm6000_v4l2_unregister(struct tm6000_core *dev)
 {
-	struct tm6000_core *h;
-	struct list_head *pos, *tmp;
-
 	video_unregister_device(dev->vfd);
 
-	list_for_each_safe(pos, tmp, &tm6000_corelist) {
-		h = list_entry(pos, struct tm6000_core, tm6000_corelist);
-		if (h == dev) {
-			list_del(pos);
-		}
-	}
-
 	return 0;
 }
 
 int tm6000_v4l2_exit(void)
 {
-#if 0
-	struct tm6000_core *h;
-	struct list_head *list;
-
-	while (!list_empty(&tm6000_corelist)) {
-		list = tm6000_corelist.next;
-		list_del(list);
-		h = list_entry(list, struct tm6000_core, tm6000_corelist);
-		video_unregister_device(&h->vfd);
-		kfree (h);
-	}
-#endif
 	return 0;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/s2255drv.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
@@ -234,7 +234,6 @@ struct s2255_dev {
 
 	struct s2255_dmaqueue	vidq[MAX_CHANNELS];
 	struct video_device	*vdev[MAX_CHANNELS];
-	struct list_head	s2255_devlist;
 	struct timer_list	timer;
 	struct s2255_fw	*fw_data;
 	struct s2255_pipeinfo	pipes[MAX_PIPE_BUFFERS];
@@ -314,8 +313,6 @@ struct s2255_fh {
 /* Channels on box are in reverse order */
 static unsigned long G_chnmap[MAX_CHANNELS] = {3, 2, 1, 0};
 
-static LIST_HEAD(s2255_devlist);
-
 static int debug;
 static int *s2255_debug = &debug;
 
@@ -1535,31 +1532,22 @@ static int vidioc_s_parm(struct file *fi
 static int s2255_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct s2255_dev *h, *dev = NULL;
+	struct video_device *vdev = video_devdata(file);
+	struct s2255_dev *dev = video_drvdata(file);
 	struct s2255_fh *fh;
-	struct list_head *list;
-	enum v4l2_buf_type type = 0;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	int i = 0;
 	int cur_channel = -1;
 	int state;
 	dprintk(1, "s2255: open called (minor=%d)\n", minor);
 
 	lock_kernel();
-	list_for_each(list, &s2255_devlist) {
-		h = list_entry(list, struct s2255_dev, s2255_devlist);
-		for (i = 0; i < MAX_CHANNELS; i++) {
-			if (h->vdev[i]->minor == minor) {
-				cur_channel = i;
-				dev = h;
-				type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-			}
-		}
-	}
 
-	if ((NULL == dev) || (cur_channel == -1)) {
-		unlock_kernel();
-		printk(KERN_INFO "s2255: openv4l no dev\n");
-		return -ENODEV;
+	for (i = 0; i < MAX_CHANNELS; i++) {
+		if (dev->vdev[i] == vdev) {
+			cur_channel = i;
+			break;
+		}
 	}
 
 	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_DISCONNECTING) {
@@ -1700,7 +1688,6 @@ static unsigned int s2255_poll(struct fi
 static void s2255_destroy(struct kref *kref)
 {
 	struct s2255_dev *dev = to_s2255_dev(kref);
-	struct list_head *list;
 	int i;
 	if (!dev) {
 		printk(KERN_ERR "s2255drv: kref problem\n");
@@ -1734,10 +1721,6 @@ static void s2255_destroy(struct kref *k
 	usb_put_dev(dev->udev);
 	dprintk(1, "%s", __func__);
 
-	while (!list_empty(&s2255_devlist)) {
-		list = s2255_devlist.next;
-		list_del(list);
-	}
 	mutex_unlock(&dev->open_lock);
 	kfree(dev);
 }
@@ -1844,7 +1827,6 @@ static int s2255_probe_v4l(struct s2255_
 	int cur_nr = video_nr;
 
 	/* initialize all video 4 linux */
-	list_add_tail(&dev->s2255_devlist, &s2255_devlist);
 	/* register 4 video devices */
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		INIT_LIST_HEAD(&dev->vidq[i].active);
@@ -1854,6 +1836,7 @@ static int s2255_probe_v4l(struct s2255_
 		dev->vdev[i] = video_device_alloc();
 		memcpy(dev->vdev[i], &template, sizeof(struct video_device));
 		dev->vdev[i]->parent = &dev->interface->dev;
+		video_set_drvdata(dev->vdev[i], dev);
 		if (video_nr == -1)
 			ret = video_register_device(dev->vdev[i],
 						    VFL_TYPE_GRABBER,
Index: v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/common/saa7146_fops.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
@@ -196,42 +196,24 @@ void saa7146_buffer_timeout(unsigned lon
 static int fops_open(struct file *file)
 {
 	unsigned int minor = video_devdata(file)->minor;
-	struct saa7146_dev *h = NULL, *dev = NULL;
-	struct list_head *list;
+	struct video_device *vdev = video_devdata(file);
+	struct saa7146_dev *dev = video_drvdata(file);
 	struct saa7146_fh *fh = NULL;
 	int result = 0;
 
-	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	enum v4l2_buf_type type;
 
 	DEB_EE(("file:%p, minor:%d\n", file, minor));
 
 	if (mutex_lock_interruptible(&saa7146_devices_lock))
 		return -ERESTARTSYS;
 
-	list_for_each(list,&saa7146_devices) {
-		h = list_entry(list, struct saa7146_dev, item);
-		if( NULL == h->vv_data ) {
-			DEB_D(("device %p has not registered video devices.\n",h));
-			continue;
-		}
-		DEB_D(("trying: %p @ major %d,%d\n",h,h->vv_data->video_minor,h->vv_data->vbi_minor));
-
-		if (h->vv_data->video_minor == minor) {
-			dev = h;
-		}
-		if (h->vv_data->vbi_minor == minor) {
-			type = V4L2_BUF_TYPE_VBI_CAPTURE;
-			dev = h;
-		}
-	}
-	if (NULL == dev) {
-		DEB_S(("no such video device.\n"));
-		result = -ENODEV;
-		goto out;
-	}
-
 	DEB_D(("using: %p\n",dev));
 
+	type = vdev->vfl_type == VFL_TYPE_VBI
+	     ? V4L2_BUF_TYPE_VIDEO_CAPTURE
+	     : V4L2_BUF_TYPE_VBI_CAPTURE;
+
 	/* check if an extension is registered */
 	if( NULL == dev->ext ) {
 		DEB_S(("no extension registered for this device.\n"));
Index: v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-cards.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/tm6000/tm6000-cards.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000-cards.c
@@ -468,7 +468,6 @@ static int tm6000_usb_probe(struct usb_i
 		dev->model=card[nr];
 	}
 
-	INIT_LIST_HEAD(&dev->tm6000_corelist);
 	dev->udev= usbdev;
 	dev->devno=nr;
 
Index: v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/tm6000/tm6000.h
+++ v4l-dvb-mc-uvc/linux/drivers/staging/tm6000/tm6000.h
@@ -160,7 +160,6 @@ struct tm6000_core {
 	struct i2c_client		i2c_client;
 
 	/* video for linux */
-	struct list_head		tm6000_corelist;
 	int				users;
 
 	/* various device info */
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-417.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
@@ -1575,28 +1575,11 @@ static int vidioc_queryctrl(struct file 
 
 static int mpeg_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
-	struct cx23885_dev *h, *dev = NULL;
-	struct list_head *list;
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh;
 
 	dprintk(2, "%s()\n", __func__);
 
-	lock_kernel();
-	list_for_each(list, &cx23885_devlist) {
-		h = list_entry(list, struct cx23885_dev, devlist);
-		if (h->v4l_device &&
-		    h->v4l_device->minor == minor) {
-			dev = h;
-			break;
-		}
-	}
-
-	if (dev == NULL) {
-		unlock_kernel();
-		return -ENODEV;
-	}
-
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh) {
@@ -1604,6 +1587,8 @@ static int mpeg_open(struct file *file)
 		return -ENOMEM;
 	}
 
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev      = dev;
 
@@ -1810,6 +1795,7 @@ int cx23885_417_register(struct cx23885_
 	/* Allocate and initialize V4L video device */
 	dev->v4l_device = cx23885_video_dev_alloc(tsport,
 		dev->pci, &cx23885_mpeg_template, "mpeg");
+	video_set_drvdata(dev->v4l_device, dev);
 	err = video_register_device(dev->v4l_device,
 		VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-core.c
@@ -56,9 +56,6 @@ MODULE_PARM_DESC(card, "card type");
 
 static unsigned int cx23885_devcount;
 
-static DEFINE_MUTEX(devlist);
-LIST_HEAD(cx23885_devlist);
-
 #define NO_SYNC_LINE (-1U)
 
 /* FIXME, these allocations will change when
@@ -786,10 +783,6 @@ static int cx23885_dev_setup(struct cx23
 	dev->nr = cx23885_devcount++;
 	sprintf(dev->name, "cx23885[%d]", dev->nr);
 
-	mutex_lock(&devlist);
-	list_add_tail(&dev->devlist, &cx23885_devlist);
-	mutex_unlock(&devlist);
-
 	/* Configure the internal memory */
 	if (dev->pci->device == 0x8880) {
 		/* Could be 887 or 888, assume a default */
@@ -2006,10 +1999,6 @@ static void __devexit cx23885_finidev(st
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
-	mutex_lock(&devlist);
-	list_del(&dev->devlist);
-	mutex_unlock(&devlist);
-
 	cx23885_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
@@ -358,6 +358,7 @@ static struct video_device *cx23885_vdev
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 dev->name, type, cx23885_boards[dev->board].name);
+	video_set_drvdata(vfd, dev);
 	return vfd;
 }
 
@@ -772,34 +773,22 @@ static int get_resource(struct cx23885_f
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx23885_dev *h, *dev = NULL;
+	struct video_device *vdev = video_devdata(file);
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh;
-	struct list_head *list;
 	enum v4l2_buf_type type = 0;
 	int radio = 0;
 
-	lock_kernel();
-	list_for_each(list, &cx23885_devlist) {
-		h = list_entry(list, struct cx23885_dev, devlist);
-		if (h->video_dev &&
-		    h->video_dev->minor == minor) {
-			dev  = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-		if (h->vbi_dev &&
-		    h->vbi_dev->minor == minor) {
-			dev  = h;
-			type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		}
-		if (h->radio_dev &&
-		    h->radio_dev->minor == minor) {
-			radio = 1;
-			dev   = h;
-		}
-	}
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
 	}
 
 	dprintk(1, "open minor=%d radio=%d type=%s\n",
@@ -807,10 +796,11 @@ static int video_open(struct file *file)
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
+
+	lock_kernel();
+
 	file->private_data = fh;
 	fh->dev      = dev;
 	fh->radio    = radio;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885.h
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885.h
@@ -303,7 +303,6 @@ struct cx23885_tsport {
 };
 
 struct cx23885_dev {
-	struct list_head           devlist;
 	atomic_t                   refcount;
 	struct v4l2_device 	   v4l2_dev;
 
@@ -399,8 +398,6 @@ static inline struct cx23885_dev *to_cx2
 
 extern struct v4l2_subdev *cx23885_find_hw(struct cx23885_dev *dev, u32 hw);
 
-extern struct list_head cx23885_devlist;
-
 #define SRAM_CH01  0 /* Video A */
 #define SRAM_CH02  1 /* VBI A */
 #define SRAM_CH03  2 /* Video B */
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-core.c
@@ -66,32 +66,6 @@ MODULE_PARM_DESC(alt, "alternate setting
 static LIST_HEAD(cx231xx_devlist);
 static DEFINE_MUTEX(cx231xx_devlist_mutex);
 
-struct cx231xx *cx231xx_get_device(int minor,
-				   enum v4l2_buf_type *fh_type, int *has_radio)
-{
-	struct cx231xx *h, *dev = NULL;
-
-	*fh_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	*has_radio = 0;
-
-	mutex_lock(&cx231xx_devlist_mutex);
-	list_for_each_entry(h, &cx231xx_devlist, devlist) {
-		if (h->vdev->minor == minor)
-			dev = h;
-		if (h->vbi_dev->minor == minor) {
-			dev = h;
-			*fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		}
-		if (h->radio_dev && h->radio_dev->minor == minor) {
-			dev = h;
-			*has_radio = 1;
-		}
-	}
-	mutex_unlock(&cx231xx_devlist_mutex);
-
-	return dev;
-}
-
 /*
  * cx231xx_realease_resources()
  * unregisters the v4l2,i2c and usb devices
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
@@ -1918,13 +1918,22 @@ static int cx231xx_v4l2_open(struct file
 {
 	int minor = video_devdata(filp)->minor;
 	int errCode = 0, radio = 0;
-	struct cx231xx *dev = NULL;
+	struct video_device *vdev = video_devdata(filp);
+	struct cx231xx *dev = video_drvdata(filp);
 	struct cx231xx_fh *fh;
 	enum v4l2_buf_type fh_type = 0;
 
-	dev = cx231xx_get_device(minor, &fh_type, &radio);
-	if (NULL == dev)
-		return -ENODEV;
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		fh_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
+	}
 
 	mutex_lock(&dev->lock);
 
@@ -2326,6 +2335,7 @@ static struct video_device *cx231xx_vdev
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
+	video_set_drvdata(vfd, dev);
 	return vfd;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx.h
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx.h
@@ -698,8 +698,6 @@ void cx231xx_release_analog_resources(st
 int cx231xx_register_analog_devices(struct cx231xx *dev);
 void cx231xx_remove_from_devlist(struct cx231xx *dev);
 void cx231xx_add_into_devlist(struct cx231xx *dev);
-struct cx231xx *cx231xx_get_device(int minor,
-				   enum v4l2_buf_type *fh_type, int *has_radio);
 void cx231xx_init_extension(struct cx231xx *dev);
 void cx231xx_close_extension(struct cx231xx *dev);
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/au0828/au0828-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/au0828/au0828-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/au0828/au0828-video.c
@@ -41,7 +41,6 @@
 #include "au0828.h"
 #include "au0828-reg.h"
 
-static LIST_HEAD(au0828_devlist);
 static DEFINE_MUTEX(au0828_sysfs_lock);
 
 #define AU0828_VERSION_CODE KERNEL_VERSION(0, 0, 1)
@@ -742,29 +741,15 @@ static void res_free(struct au0828_fh *f
 
 static int au0828_v4l2_open(struct file *filp)
 {
-	int minor = video_devdata(filp)->minor;
 	int ret = 0;
-	struct au0828_dev *h, *dev = NULL;
+	struct au0828_dev *dev = video_drvdata(filp);
 	struct au0828_fh *fh;
-	int type = 0;
-	struct list_head *list;
+	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	list_for_each(list, &au0828_devlist) {
-		h = list_entry(list, struct au0828_dev, au0828list);
-		if (h->vdev->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
 #ifdef VBI_IS_WORKING
-		if (h->vbi_dev->minor == minor) {
-			dev = h;
-			type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		}
+	if (video_devdata(filp)->vfl_type == VFL_TYPE_GRABBER)
+		type = V4L2_BUF_TYPE_VBI_CAPTURE;
 #endif
-	}
-
-	if (NULL == dev)
-		return -ENODEV;
 
 	fh = kzalloc(sizeof(struct au0828_fh), GFP_KERNEL);
 	if (NULL == fh) {
@@ -1681,9 +1666,8 @@ int au0828_analog_register(struct au0828
 	strcpy(dev->vbi_dev->name, "au0828a vbi");
 #endif
 
-	list_add_tail(&dev->au0828list, &au0828_devlist);
-
 	/* Register the v4l2 device */
+	video_set_drvdata(dev->vdev, dev);
 	retval = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (retval != 0) {
 		dprintk(1, "unable to register video device (error = %d).\n",
@@ -1695,6 +1679,7 @@ int au0828_analog_register(struct au0828
 
 #ifdef VBI_IS_WORKING
 	/* Register the vbi device */
+	video_set_drvdata(dev->vbi_dev, dev);
 	retval = video_register_device(dev->vbi_dev, VFL_TYPE_VBI, -1);
 	if (retval != 0) {
 		dprintk(1, "unable to register vbi device (error = %d).\n",
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-blackbird.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
@@ -1068,20 +1068,14 @@ static int vidioc_s_std (struct file *fi
 static int mpeg_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx8802_dev *dev = NULL;
+	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx8802_fh *fh;
 	struct cx8802_driver *drv = NULL;
 	int err;
 
-	lock_kernel();
-	dev = cx8802_get_device(minor);
-
 	dprintk( 1, "%s\n", __func__);
 
-	if (dev == NULL) {
-		unlock_kernel();
-		return -ENODEV;
-	}
+	lock_kernel();
 
 	/* Make sure we can acquire the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
@@ -1148,10 +1142,6 @@ static int mpeg_release(struct file *fil
 	kfree(fh);
 
 	/* Make sure we release the hardware */
-	dev = cx8802_get_device(video_devdata(file)->minor);
-	if (dev == NULL)
-		return -ENODEV;
-
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
 	if (drv)
 		drv->request_release(drv);
@@ -1312,6 +1302,7 @@ static int blackbird_register_video(stru
 
 	dev->mpeg_dev = cx88_vdev_init(dev->core,dev->pci,
 				       &cx8802_mpeg_template,"mpeg");
+	video_set_drvdata(dev->mpeg_dev, dev);
 	err = video_register_device(dev->mpeg_dev,VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
 		printk(KERN_INFO "%s/2: can't register mpeg device\n",
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-mpeg.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-mpeg.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-mpeg.c
@@ -620,21 +620,6 @@ static int cx8802_resume_common(struct p
 	return 0;
 }
 
-#if defined(CONFIG_VIDEO_CX88_BLACKBIRD) || \
-    defined(CONFIG_VIDEO_CX88_BLACKBIRD_MODULE)
-struct cx8802_dev *cx8802_get_device(int minor)
-{
-	struct cx8802_dev *dev;
-
-	list_for_each_entry(dev, &cx8802_devlist, devlist)
-		if (dev->mpeg_dev && dev->mpeg_dev->minor == minor)
-			return dev;
-
-	return NULL;
-}
-EXPORT_SYMBOL(cx8802_get_device);
-#endif
-
 struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype)
 {
 	struct cx8802_driver *d;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
@@ -76,10 +76,6 @@ MODULE_PARM_DESC(vid_limit,"capture memo
 #define dprintk(level,fmt, arg...)	if (video_debug >= level) \
 	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
 
-/* ------------------------------------------------------------------ */
-
-static LIST_HEAD(cx8800_devlist);
-
 /* ------------------------------------------------------------------- */
 /* static data                                                         */
 
@@ -980,31 +976,23 @@ static int get_ressource(struct cx8800_f
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct cx8800_dev *h,*dev = NULL;
+	struct video_device *vdev = video_devdata(file);
+	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core;
 	struct cx8800_fh *fh;
 	enum v4l2_buf_type type = 0;
 	int radio = 0;
 
-	lock_kernel();
-	list_for_each_entry(h, &cx8800_devlist, devlist) {
-		if (h->video_dev->minor == minor) {
-			dev  = h;
-			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		}
-		if (h->vbi_dev->minor == minor) {
-			dev  = h;
-			type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		}
-		if (h->radio_dev &&
-		    h->radio_dev->minor == minor) {
-			radio = 1;
-			dev   = h;
-		}
-	}
-	if (NULL == dev) {
-		unlock_kernel();
-		return -ENODEV;
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
 	}
 
 	core = dev->core;
@@ -2187,6 +2175,7 @@ static int __devinit cx8800_initdev(stru
 	/* register v4l devices */
 	dev->video_dev = cx88_vdev_init(core,dev->pci,
 					&cx8800_video_template,"video");
+	video_set_drvdata(dev->video_dev, dev);
 	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
 				    video_nr[core->nr]);
 	if (err < 0) {
@@ -2198,6 +2187,7 @@ static int __devinit cx8800_initdev(stru
 	       core->name, video_device_node_name(dev->video_dev));
 
 	dev->vbi_dev = cx88_vdev_init(core,dev->pci,&cx8800_vbi_template,"vbi");
+	video_set_drvdata(dev->vbi_dev, dev);
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[core->nr]);
 	if (err < 0) {
@@ -2211,6 +2201,7 @@ static int __devinit cx8800_initdev(stru
 	if (core->board.radio.type == CX88_RADIO) {
 		dev->radio_dev = cx88_vdev_init(core,dev->pci,
 						&cx8800_radio_template,"radio");
+		video_set_drvdata(dev->radio_dev, dev);
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[core->nr]);
 		if (err < 0) {
@@ -2223,7 +2214,6 @@ static int __devinit cx8800_initdev(stru
 	}
 
 	/* everything worked */
-	list_add_tail(&dev->devlist,&cx8800_devlist);
 	pci_set_drvdata(pci_dev,dev);
 
 	/* initial device configuration */
@@ -2279,7 +2269,6 @@ static void __devexit cx8800_finidev(str
 
 	/* free memory */
 	btcx_riscmem_free(dev->pci,&dev->vidq.stopper);
-	list_del(&dev->devlist);
 	cx88_core_put(core,dev->pci);
 	kfree(dev);
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88.h
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88.h
@@ -426,7 +426,6 @@ struct cx8800_suspend_state {
 
 struct cx8800_dev {
 	struct cx88_core           *core;
-	struct list_head           devlist;
 #if 0
 	/* moved to cx88_core */
 	struct semaphore           lock;
@@ -690,7 +689,6 @@ int cx88_audio_thread(void *data);
 
 int cx8802_register_driver(struct cx8802_driver *drv);
 int cx8802_unregister_driver(struct cx8802_driver *drv);
-struct cx8802_dev *cx8802_get_device(int minor);
 struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
 
 /* ----------------------------------------------------------- */
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-cards.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -2744,10 +2744,6 @@ static int em28xx_init_dev(struct em28xx
 	INIT_LIST_HEAD(&dev->vbiq.active);
 	INIT_LIST_HEAD(&dev->vbiq.queued);
 
-#if 0
-	video_set_drvdata(dev->vbi_dev, dev);
-#endif
-
 	if (dev->board.has_msp34xx) {
 		/* Send a reset to other chips via gpio */
 		errCode = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
@@ -2124,16 +2124,24 @@ static int radio_queryctrl(struct file *
 static int em28xx_v4l2_open(struct file *filp)
 {
 	int minor = video_devdata(filp)->minor;
-	int errCode = 0, radio;
-	struct em28xx *dev;
-	enum v4l2_buf_type fh_type;
+	int errCode = 0, radio = 0;
+	struct video_device *vdev = video_devdata(filp);
+	struct em28xx *dev = video_drvdata(filp);
+	enum v4l2_buf_type fh_type = 0;
 	struct em28xx_fh *fh;
 	enum v4l2_field field;
 
-	dev = em28xx_get_device(minor, &fh_type, &radio);
-
-	if (NULL == dev)
-		return -ENODEV;
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		fh_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
+	}
 
 	mutex_lock(&dev->lock);
 
@@ -2516,6 +2524,7 @@ static struct video_device *em28xx_vdev_
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
 		 dev->name, type_name);
 
+	video_set_drvdata(vfd, dev);
 	return vfd;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx.h
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx.h
@@ -676,9 +676,6 @@ int em28xx_gpio_set(struct em28xx *dev, 
 void em28xx_wake_i2c(struct em28xx *dev);
 void em28xx_remove_from_devlist(struct em28xx *dev);
 void em28xx_add_into_devlist(struct em28xx *dev);
-struct em28xx *em28xx_get_device(int minor,
-				 enum v4l2_buf_type *fh_type,
-				 int *has_radio);
 int em28xx_register_extension(struct em28xx_ops *dev);
 void em28xx_unregister_extension(struct em28xx_ops *dev);
 void em28xx_init_extension(struct em28xx *dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-core.c
@@ -858,6 +858,7 @@ static struct video_device *vdev_init(st
 	vfd->debug   = video_debug;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 dev->name, type, saa7134_boards[dev->board].name);
+	video_set_drvdata(vfd, dev);
 	return vfd;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-empress.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
@@ -87,17 +87,9 @@ static int ts_init_encoder(struct saa713
 static int ts_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct saa7134_dev *dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
 
-	lock_kernel();
-	list_for_each_entry(dev, &saa7134_devlist, devlist)
-		if (dev->empress_dev && dev->empress_dev->minor == minor)
-			goto found;
-	unlock_kernel();
-	return -ENODEV;
- found:
-
 	dprintk("open minor=%d\n",minor);
 	err = -EBUSY;
 	if (!mutex_trylock(&dev->empress_tsq.vb_lock))
@@ -543,6 +535,7 @@ static int empress_init(struct saa7134_d
 	INIT_WORK(&dev->empress_workqueue, empress_signal_update);
 #endif
 
+	video_set_drvdata(dev->empress_dev, dev);
 	err = video_register_device(dev->empress_dev,VFL_TYPE_GRABBER,
 				    empress_nr[dev->nr]);
 	if (err < 0) {
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-video.c
@@ -1327,29 +1327,23 @@ static int saa7134_resource(struct saa71
 static int video_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
-	struct saa7134_dev *dev;
+	struct video_device *vdev = video_devdata(file);
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh;
-	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	enum v4l2_buf_type type = 0;
 	int radio = 0;
 
-	mutex_lock(&saa7134_devlist_lock);
-	list_for_each_entry(dev, &saa7134_devlist, devlist) {
-		if (dev->video_dev && (dev->video_dev->minor == minor))
-			goto found;
-		if (dev->radio_dev && (dev->radio_dev->minor == minor)) {
-			radio = 1;
-			goto found;
-		}
-		if (dev->vbi_dev && (dev->vbi_dev->minor == minor)) {
-			type = V4L2_BUF_TYPE_VBI_CAPTURE;
-			goto found;
-		}
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case VFL_TYPE_VBI:
+		type = V4L2_BUF_TYPE_VBI_CAPTURE;
+		break;
+	case VFL_TYPE_RADIO:
+		radio = 1;
+		break;
 	}
-	mutex_unlock(&saa7134_devlist_lock);
-	return -ENODEV;
-
-found:
-	mutex_unlock(&saa7134_devlist_lock);
 
 	dprintk("open minor=%d radio=%d type=%s\n",minor,radio,
 		v4l2_type_names[type]);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-core.c
@@ -1138,34 +1138,6 @@ void em28xx_wake_i2c(struct em28xx *dev)
 static LIST_HEAD(em28xx_devlist);
 static DEFINE_MUTEX(em28xx_devlist_mutex);
 
-struct em28xx *em28xx_get_device(int minor,
-				 enum v4l2_buf_type *fh_type,
-				 int *has_radio)
-{
-	struct em28xx *h, *dev = NULL;
-
-	*fh_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	*has_radio = 0;
-
-	mutex_lock(&em28xx_devlist_mutex);
-	list_for_each_entry(h, &em28xx_devlist, devlist) {
-		if (h->vdev->minor == minor)
-			dev = h;
-		if (h->vbi_dev && h->vbi_dev->minor == minor) {
-			dev = h;
-			*fh_type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		}
-		if (h->radio_dev &&
-		    h->radio_dev->minor == minor) {
-			dev = h;
-			*has_radio = 1;
-		}
-	}
-	mutex_unlock(&em28xx_devlist_mutex);
-
-	return dev;
-}
-
 /*
  * em28xx_realease_resources()
  * unregisters the v4l2,i2c and usb devices
