Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NL74RW019453
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 17:07:04 -0400
Received: from mail-fx0-f180.google.com (mail-fx0-f180.google.com
	[209.85.220.180])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2NL6jTT031460
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 17:06:45 -0400
Received: by fxm28 with SMTP id 28so1949966fxm.3
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 14:06:45 -0700 (PDT)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Lamarque Vieira Souza <lamarque@gmail.com>
In-Reply-To: <200903231217.45740.lamarque@gmail.com>
References: <200903231217.45740.lamarque@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 00:07:42 +0300
Message-Id: <1237842462.31041.81.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Patch implementing V4L2_CAP_STREAMING for zr364xx driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello, Lamarque
May i make few comments ?

On Mon, 2009-03-23 at 12:17 -0300, Lamarque Vieira Souza wrote:
> 	Hi,
> 
> 	I have implemented V4L2_CAP_STREAMING for the zr364xx driver (see the 
> attached file). I had to disable V4L2_CAP_READWRITE until I re-implement it 
> using V4L2_CAP_STREAMING as backend. Could you review the code for me? My 
> Creative PC-CAM 880 works, but I do not have any other webcam to test the 
> code. Besides the streaming implementation the patch also does:
> 
> . copy cam->udev->product to the card field of the v4l2_capability struct. 
> That gives more info to the users about the card.
> 
> . add v4l_compat_ioctl32 to file_operations struct. 32-bit applications 
> (mplayer, Skype, Shockwave Flash) need that to detect the webcam on my AMD64 
> distribution (Gentoo).
> 
> . move the brightness setting code from before requesting a frame (in 
> read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is 
> executed only when the application request a change in brightness and not 
> before every frame read. Is there any reason to set the brightness before 
> every frame read?
> 
> 	Best regards,

I inlined patch in e-mail to make it easy.

--- zr364xx.c.orig	2009-03-21 08:51:41.289597517 -0300
+++ zr364xx.c	2009-03-23 03:26:00.445999283 -0300
@@ -1,15 +1,18 @@
 /*
- * Zoran 364xx based USB webcam module version 0.72
+ * Zoran 364xx based USB webcam module version 0.73
  *
  * Allows you to use your USB webcam with V4L2 applications
  * This is still in heavy developpement !
  *
- * Copyright (C) 2004  Antoine Jacquet <royale@zerezo.com>
+ * Copyright (C) 2009  Antoine Jacquet <royale@zerezo.com>

Maybe it's better not to touch the year here ?

  * http://royale.zerezo.com/zr364xx/
+ *                     Lamarque V. Souza <lamarque_souza@hotmail.com>
  *
  * Heavily inspired by usb-skeleton.c, vicam.c, cpia.c and spca50x.c drivers
  * V4L2 version inspired by meye.c driver
  *
+ * Some video buffer code by Lamarque based on s2255drv driver.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -36,24 +39,36 @@
 #include <linux/highmem.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf-vmalloc.h>
 
 
 /* Version Information */
-#define DRIVER_VERSION "v0.72"
-#define DRIVER_AUTHOR "Antoine Jacquet, http://royale.zerezo.com/"
+#define ZR364_VERSION_CODE KERNEL_VERSION(0, 7, 3)
+#define DRIVER_VERSION "v0.73"
+#define DRIVER_AUTHOR "Antoine Jacquet (http://royale.zerezo.com/), Lamarque V. Souza"
 #define DRIVER_DESC "Zoran 364xx"
 
 
 /* Camera */
-#define FRAMES 2
+#define FRAMES 4
 #define MAX_FRAME_SIZE 100000
 #define BUFFER_SIZE 0x1000
 #define CTRL_TIMEOUT 500
+#define ZR364XX_DEF_BUFS	4
+#define MAX_PIPE_BUFFERS	1
+#define ZR364XX_READ_IDLE	0
+#define ZR364XX_READ_FRAME	1
 
+/* usb config commands */
+#define IN_DATA_TOKEN	0x2255c0de
 
 /* Debug macro */
-#define DBG(x...) if (debug) printk(KERN_INFO KBUILD_MODNAME x)
-
+#define DBG(fmt, args...) \
+	do { \
+		if (debug) { \
+			printk(KERN_INFO KBUILD_MODNAME " " fmt, ##args); \
+		} \
+	} while (0)
 
 /* Init methods, need to find nicer names for these
  * the exact names of the chipsets would be the best if someone finds it */
@@ -101,24 +116,102 @@ static struct usb_device_id device_table
 
 MODULE_DEVICE_TABLE(usb, device_table);
 
+struct zr364xx_mode {
+	u32 color;	/* output video color format */
+	u32 bright;	/* brightness */
+};
+
+/* frame structure */
+struct zr364xx_framei {
+	unsigned long size;
+	unsigned long ulState;	/* ulState:ZR364XX_READ_IDLE, ZR364XX_READ_FRAME*/
+	void *lpvbits;		/* image data */
+	unsigned long cur_size;	/* current data copied to it */
+};
+
+/* image buffer structure */
+struct zr364xx_bufferi {
+	unsigned long dwFrames;			/* number of frames in buffer */
+	struct zr364xx_framei frame[FRAMES];	/* array of FRAME structures */
+};
+
+struct zr364xx_dmaqueue {
+	struct list_head	active;
+	/* thread for acquisition */
+	struct task_struct	*kthread;

Is this member of struct used ?
I can find only cam->vidq.kthread = NULL; in zr364xx_probe function..

+	int			frame;
+	struct zr364xx_camera	*cam;
+	int			channel;
+};
+
+struct zr364xx_pipeinfo {
+	u32 max_transfer_size;
+	u32 cur_transfer_size;
+	u8 *transfer_buffer;
+	u32 transfer_flags;;
+	u32 state;
+	u32 prev_state;
+	u32 urb_size;
+	void *stream_urb;
+	void *cam;	/* back pointer to zr364xx_camera struct*/
+	u32 err_count;
+	u32 buf_index;
+	u32 idx;
+	u32 priority_set;
+};
+
+struct zr364xx_fmt {
+	char *name;
+	u32 fourcc;
+	int depth;
+};
+
+/* image formats.  */
+static const struct zr364xx_fmt formats[] = {
+	{
+		.name = "JPG",
+		.fourcc = V4L2_PIX_FMT_JPEG,
+		.depth = 24
+	}
+};
 
 /* Camera stuff */
 struct zr364xx_camera {
 	struct usb_device *udev;	/* save off the usb device pointer */
 	struct usb_interface *interface;/* the interface for this device */
 	struct video_device *vdev;	/* v4l video device */
-	u8 *framebuf;
 	int nb;
-	unsigned char *buffer;
-	int skip;
-	int brightness;
+	struct zr364xx_bufferi		buffer;
 	int width;
 	int height;
 	int method;
 	struct mutex lock;
+	struct mutex open_lock;
 	int users;
+
+	spinlock_t		slock;
+	struct zr364xx_dmaqueue	vidq;
+	int 			resources;
+	int			last_frame;
+	int			cur_frame;
+	unsigned long		frame_count;
+	int			b_acquire;
+	struct zr364xx_pipeinfo	pipes[MAX_PIPE_BUFFERS];
+
+	u8			read_endpoint;
+
+	const struct zr364xx_fmt * fmt;
+	struct videobuf_queue	vb_vidq;
+	enum v4l2_buf_type	type;
+	struct zr364xx_mode	mode;
 };
 
+/* buffer for one video frame */
+struct zr364xx_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer vb;
+	const struct zr364xx_fmt *fmt;
+};
 
 /* function used to send initialisation commands to the camera */
 static int send_control_msg(struct usb_device *udev, u8 request, u16 value,
@@ -272,12 +365,103 @@ static unsigned char header2[] = {
 };
 static unsigned char header3;
 
+/* ------------------------------------------------------------------
+   Videobuf operations
+   ------------------------------------------------------------------*/
+
+static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
+			unsigned int *size)
+{
+	struct zr364xx_camera *cam = vq->priv_data;
+
+	*size = cam->width * cam->height * (cam->fmt->depth >> 3);
+
+	if (*count == 0)
+		*count = ZR364XX_DEF_BUFS;
+
+	while (*size * (*count) > ZR364XX_DEF_BUFS * 1024 * 1024)
+		(*count)--;
+
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct zr364xx_buffer *buf)
+{
+	DBG("%s\n", __func__);
+
+	videobuf_waiton(&buf->vb, 0, 0);
+	videobuf_vmalloc_free(&buf->vb);
+	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
+			  enum v4l2_field field)
+{
+	struct zr364xx_camera *cam = vq->priv_data;
+	struct zr364xx_buffer *buf = container_of(vb, struct zr364xx_buffer, vb);
+	int rc;
+
+	DBG("%s, field=%d\n", __func__, field);
+	if (cam->fmt == NULL)
+		return -EINVAL;
+
+	buf->vb.size = cam->width * cam->height * (cam->fmt->depth >> 3);
+
+	if (buf->vb.baddr != 0 && buf->vb.bsize < buf->vb.size) {
+		DBG("invalid buffer prepare\n");
+		return -EINVAL;
+	}
+
+	buf->fmt = cam->fmt;
+	buf->vb.width = cam->width;
+	buf->vb.height = cam->height;
+	buf->vb.field = field;
+
+	if (buf->vb.state == VIDEOBUF_NEEDS_INIT) {
+		rc = videobuf_iolock(vq, &buf->vb, NULL);
+		if (rc < 0)
+			goto fail;
+	}
+
+	buf->vb.state = VIDEOBUF_PREPARED;
+	return 0;
+fail:
+	free_buffer(vq, buf);
+	return rc;
+}
+
+static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+	struct zr364xx_buffer *buf = container_of(vb, struct zr364xx_buffer, vb);
+	struct zr364xx_camera *cam = vq->priv_data;
 
+	DBG("%s\n", __func__);
+
+	buf->vb.state = VIDEOBUF_QUEUED;
+	list_add_tail(&buf->vb.queue, &cam->vidq.active);
+}
+
+static void buffer_release(struct videobuf_queue *vq,
+			   struct videobuf_buffer *vb)
+{
+	struct zr364xx_buffer *buf = container_of(vb, struct zr364xx_buffer, vb);
+
+	DBG("%s\n", __func__);
+	free_buffer(vq, buf);
+}
+
+static struct videobuf_queue_ops zr364xx_video_qops = {
+	.buf_setup = buffer_setup,
+	.buf_prepare = buffer_prepare,
+	.buf_queue = buffer_queue,
+	.buf_release = buffer_release,
+};
 
 /********************/
 /* V4L2 integration */
 /********************/
 
+#if 0
 /* this function reads a full JPEG picture synchronously
  * TODO: do it asynchronously... */
 static int read_frame(struct zr364xx_camera *cam, int framenum)
@@ -288,7 +472,7 @@ static int read_frame(struct zr364xx_cam
       redo:
 	/* hardware brightness */
 	n = send_control_msg(cam->udev, 1, 0x2001, 0, NULL, 0);
-	temp = (0x60 << 8) + 127 - cam->brightness;
+	temp = (0x60 << 8) + 127 - cam->mode.bright;
 	n = send_control_msg(cam->udev, 1, temp, 0, NULL, 0);
 
 	/* during the first loop we are going to insert JPEG header */
@@ -388,11 +572,12 @@ static int read_frame(struct zr364xx_cam
 	DBG("jpeg : %d %d %d %d %d %d %d %d",
 	    jpeg[0], jpeg[1], jpeg[2], jpeg[3],
 	    jpeg[4], jpeg[5], jpeg[6], jpeg[7]);
-
 	return size;
 }
+#endif
 
 
+#if 0
 static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t cnt,
 			    loff_t * ppos)
 {
@@ -400,7 +585,7 @@ static ssize_t zr364xx_read(struct file 
 	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
 
-	DBG("zr364xx_read: read %d bytes.", (int) count);
+	DBG("zr364xx_read: read %d bytes.\n", (int) count);
 
 	if (vdev == NULL)
 		return -ENODEV;
@@ -415,19 +600,269 @@ static ssize_t zr364xx_read(struct file 
 	/* NoMan Sux ! */
 	count = read_frame(cam, 0);
 
-	if (copy_to_user(buf, cam->framebuf, count))
-		return -EFAULT;
+	if (cam->last_frame != -1 ) {
+		if (copy_to_user(buf, cam->buffer.frame[cam->last_frame].lpvbits, count))
+			return -EFAULT;
+	}
+	else {
+		return 0;
+	}
 
 	return count;
 }
+#endif
+
+/* video buffer vmalloc implementation based partly on VIVI driver which is
+ *          Copyright (c) 2006 by
+ *                  Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
+ *                  Ted Walther <ted--a.t--enumera.com>
+ *                  John Sokol <sokol--a.t--videotechnology.com>
+ *                  http://v4l.videotechnology.com/
+ *
+ */
+static void zr364xx_fillbuff(struct zr364xx_camera *cam, struct zr364xx_buffer *buf, int jpgsize)
+{
+	int pos = 0;
+	struct timeval ts;
+	const char *tmpbuf;
+	char *vbuf = videobuf_to_vmalloc(&buf->vb);
+	unsigned long last_frame;
+	struct zr364xx_framei *frm;
+
+	if (!vbuf)
+		return;
+
+	last_frame = cam->last_frame;
+	if (last_frame != -1) {
+		frm = &cam->buffer.frame[last_frame];
+		tmpbuf = (const char *)cam->buffer.frame[last_frame].lpvbits;
+		switch (buf->fmt->fourcc) {
+		case V4L2_PIX_FMT_JPEG:
+			buf->vb.size = jpgsize;
+			memcpy(vbuf, tmpbuf, buf->vb.size);
+			break;
+		default:
+			printk(KERN_DEBUG "zr364xx: unknown format?\n");
+		}
+		cam->last_frame = -1;
+	} else {
+		printk(KERN_ERR "zr364xx: =======no frame\n");
+		return;
+	}
+	DBG("zr364xx fill at : Buffer 0x%08lx size= %d\n",
+		(unsigned long)vbuf, pos);
+	/* tell v4l buffer was filled */
+
+	buf->vb.field_count = cam->frame_count * 2;
+	do_gettimeofday(&ts);
+	buf->vb.ts = ts;
+	buf->vb.state = VIDEOBUF_DONE;
+}
+
+static int zr364xx_got_frame(struct zr364xx_camera *cam, int jpgsize)
+{
+	struct zr364xx_dmaqueue *dma_q = &cam->vidq;
+	struct zr364xx_buffer *buf;
+	unsigned long flags = 0;
+	int rc = 0;
+
+	DBG("wakeup: %p\n", &dma_q);
+	spin_lock_irqsave(&cam->slock, flags);
+
+	if (list_empty(&dma_q->active)) {
+		DBG("No active queue to serve\n");
+		rc = -1;
+		goto unlock;
+	}
+	buf = list_entry(dma_q->active.next,
+			 struct zr364xx_buffer, vb.queue);
+
+	if (!waitqueue_active(&buf->vb.done)) {
+		/* no one active */
+		rc = -1;
+		goto unlock;
+	}
+	list_del(&buf->vb.queue);
+	do_gettimeofday(&buf->vb.ts);
+	DBG("[%p/%d] wakeup\n", buf, buf->vb.i);
+	zr364xx_fillbuff(cam, buf, jpgsize);
+	wake_up(&buf->vb.done);
+	DBG("wakeup [buf/i] [%p/%d]\n", buf, buf->vb.i);
+unlock:
+	spin_unlock_irqrestore(&cam->slock, flags);
+	return 0;
+}
+
+/* this function moves the usb stream read pipe data
+ * into the system buffers.
+ * returns 0 on success, EAGAIN if more data to process (call this
+ * function again).
+ */
+static int zr364xx_read_video_callback(struct zr364xx_camera *cam,
+                                       struct zr364xx_pipeinfo *pipe_info,
+                                       struct urb *purb)
+{
+	unsigned char *pdest;
+	unsigned char *psrc;
+	s32 idx = -1;
+	struct zr364xx_framei *frm;
+	int i = 0;
+	unsigned char *ptr = NULL;
+
+	DBG("buffer to user\n");
+	idx = cam->cur_frame;
+	frm = &cam->buffer.frame[idx];
+
+	/* swap bytes if camera needs it */
+	if (cam->method == METHOD0) {
+		u16 *buf = (u16*)pipe_info->transfer_buffer;
+		for (i = 0; i < purb->actual_length/2; i++)
+			swab16s(buf + i);
+	}
+
+	/* search done.  now find out if should be acquiring on this channel */
+	if (!cam->b_acquire) {
+		/* we found a frame, but this channel is turned off */
+		frm->ulState = ZR364XX_READ_IDLE;
+		return -EINVAL;
+	}
+
+	if (frm->lpvbits == NULL) {
+		DBG("zr364xx frame buffer == NULL.%p %p %d\n",
+			frm, cam, idx);
+		return -ENOMEM;
+	}
+
+	psrc = (u8 *)pipe_info->transfer_buffer;
+	ptr = pdest = frm->lpvbits;
+
+	if (frm->ulState == ZR364XX_READ_IDLE) {
+		frm->ulState = ZR364XX_READ_FRAME;
+		frm->cur_size = 0;
+
+		DBG("jpeg header, ");
+		memcpy(ptr, header1, sizeof(header1));
+		ptr += sizeof(header1);
+		header3 = 0;
+		memcpy(ptr, &header3, 1);
+		ptr++;
+		memcpy(ptr, psrc, 64);
+		ptr += 64;
+		header3 = 1;
+		memcpy(ptr, &header3, 1);
+		ptr++;
+		memcpy(ptr, psrc + 64, 64);
+		ptr += 64;
+		memcpy(ptr, header2, sizeof(header2));
+		ptr += sizeof(header2);
+		memcpy(ptr, psrc + 128,
+		       purb->actual_length - 128);
+		ptr += purb->actual_length - 128;
+		DBG("header : %d %d %d %d %d %d %d %d %d\n",
+		    psrc[0], psrc[1], psrc[2],
+		    psrc[3], psrc[4], psrc[5],
+		    psrc[6], psrc[7], psrc[8]);
+		frm->cur_size = ptr - pdest;
+	}
+	else {
+		pdest += frm->cur_size;
+		memcpy(pdest, psrc, purb->actual_length);
+		frm->cur_size += purb->actual_length;
+	}
+	DBG("cur_size %lu size %d\n", frm->cur_size, purb->actual_length);
+
+	if (purb->actual_length < pipe_info->cur_transfer_size) {
+		DBG("****************Buffer[%d]full*************\n", idx);
+		cam->last_frame = cam->cur_frame;
+		cam->cur_frame++;
+		/* end of system frame ring buffer, start at zero */
+		if ((cam->cur_frame == FRAMES) ||
+		    (cam->cur_frame == cam->buffer.dwFrames))
+			cam->cur_frame = 0;
+
+		/* frame ready */
+		/* go back to find the JPEG EOI marker */
+		ptr = pdest = frm->lpvbits;
+		ptr += frm->cur_size - 2;
+		while (ptr > pdest) {
+			if (*ptr == 0xFF && *(ptr + 1) == 0xD9
+			    && *(ptr + 2) == 0xFF)
+				break;
+			ptr--;
+		}
+		if (ptr == pdest)
+			DBG("No EOI marker\n");
+
+		/* Sometimes there is junk data in the middle of the picture,
+		 * we want to skip this bogus frames */
+		while (ptr > pdest) {
+			if (*ptr == 0xFF && *(ptr + 1) == 0xFF
+			    && *(ptr + 2) == 0xFF)
+				break;
+			ptr--;
+		}
+		if (ptr != pdest) {
+			DBG("Bogus frame ? %d\n", ++(cam->nb));
+		}
+		else if (cam->b_acquire)
+		{
+			DBG("jpeg(%lu): %d %d %d %d %d %d %d %d\n", frm->cur_size,
+			    pdest[0], pdest[1], pdest[2], pdest[3],
+			    pdest[4], pdest[5], pdest[6], pdest[7]);
+
+			zr364xx_got_frame(cam, frm->cur_size);
+		}
+		cam->frame_count++;
+		frm->ulState = ZR364XX_READ_IDLE;
+		frm->cur_size = 0;
+	}
+	/* done successfully */
+	return 0;
+}
 
+static int res_get(struct zr364xx_camera *cam)
+{
+	/* is it free? */
+	mutex_lock(&cam->lock);
+	if (cam->resources) {
+		/* no, someone else uses it */
+		mutex_unlock(&cam->lock);
+		return 0;
+	}
+	/* it's free, grab it */
+	cam->resources = 1;
+	DBG("zr364xx: res: get\n");
+	mutex_unlock(&cam->lock);
+	return 1;
+}
+
+static int res_check(struct zr364xx_camera *cam)
+{
+	return cam->resources;
+}

You can make this function inline, right ?

+
+static void res_free(struct zr364xx_camera *cam)
+{
+	mutex_lock(&cam->lock);
+	cam->resources = 0;
+	mutex_unlock(&cam->lock);
+	DBG("res: put\n");
+}
 
 static int zr364xx_vidioc_querycap(struct file *file, void *priv,
 				   struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+
 	memset(cap, 0, sizeof(*cap));
-	strcpy(cap->driver, DRIVER_DESC);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	strlcpy(cap->driver, DRIVER_DESC, sizeof(cap->driver));
+	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
+	strlcpy(cap->bus_info, dev_name(&cam->udev->dev), sizeof(cap->bus_info));
+	cap->version = ZR364_VERSION_CODE;
+	/* Lamarque TODO: re-implement CAP_READWRITE using CAP_STREAMING as backend
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;*/
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	return 0;
 }
 
@@ -475,7 +910,7 @@ static int zr364xx_vidioc_queryctrl(stru
 		c->minimum = 0;
 		c->maximum = 127;
 		c->step = 1;
-		c->default_value = cam->brightness;
+		c->default_value = cam->mode.bright;
 		c->flags = 0;
 		break;
 	default:
@@ -489,6 +924,7 @@ static int zr364xx_vidioc_s_ctrl(struct 
 {
 	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
+	int temp;
 
 	if (vdev == NULL)
 		return -ENODEV;
@@ -496,11 +932,19 @@ static int zr364xx_vidioc_s_ctrl(struct 
 
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
-		cam->brightness = c->value;
+		cam->mode.bright = c->value;
 		break;
 	default:
 		return -EINVAL;
 	}
+
+	/* hardware brightness */
+	mutex_lock(&cam->lock);
+	send_control_msg(cam->udev, 1, 0x2001, 0, NULL, 0);
+	temp = (0x60 << 8) + 127 - cam->mode.bright;
+	send_control_msg(cam->udev, 1, temp, 0, NULL, 0);
+	mutex_unlock(&cam->lock);
+
 	return 0;
 }
 
@@ -516,7 +960,7 @@ static int zr364xx_vidioc_g_ctrl(struct 
 
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
-		c->value = cam->brightness;
+		c->value = cam->mode.bright;
 		break;
 	default:
 		return -EINVAL;
@@ -535,8 +979,8 @@ static int zr364xx_vidioc_enum_fmt_vid_c
 	f->index = 0;
 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
-	strcpy(f->description, "JPEG");
-	f->pixelformat = V4L2_PIX_FMT_JPEG;
+	strcpy(f->description, formats[0].name);
+	f->pixelformat = formats[0].fourcc;
 	return 0;
 }
 
@@ -581,7 +1025,7 @@ static int zr364xx_vidioc_g_fmt_vid_cap(
 		return -EINVAL;
 	memset(&f->fmt.pix, 0, sizeof(struct v4l2_pix_format));
 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	f->fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
+	f->fmt.pix.pixelformat = formats[0].fourcc;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.width = cam->width;
 	f->fmt.pix.height = cam->height;
@@ -616,23 +1060,266 @@ static int zr364xx_vidioc_s_fmt_vid_cap(
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
 	f->fmt.pix.priv = 0;
+
+	cam->mode.color = V4L2_PIX_FMT_JPEG;
 	DBG("ok!");

\n ?

 	return 0;
 }
 
+static int zr364xx_vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	int rc;
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+	rc = videobuf_reqbufs(&cam->vb_vidq, p);
+	return rc;
+}
+
+static int zr364xx_vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	int rc;
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+	rc = videobuf_querybuf(&cam->vb_vidq, p);
+	return rc;
+}
+
+static int zr364xx_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	int rc;
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+	rc = videobuf_qbuf(&cam->vb_vidq, p);
+	return rc;
+}
+
+static int zr364xx_vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	int rc;
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+	rc = videobuf_dqbuf(&cam->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	return rc;
+}

To decrease amount of code here you can use something like this:

struct zr364xx_camera *cam = video_drvdata(file);

to get *cam from struct file directly(without vdev).


+static void read_pipe_completion(struct urb *purb)
+{
+	struct zr364xx_pipeinfo *pipe_info;
+	struct zr364xx_camera *cam;
+	int status;
+	int pipe;
+
+	pipe_info = purb->context;
+	DBG("%s %p, status %d\n", __func__, purb, purb->status);
+	if (pipe_info == NULL) {
+		err("no context!");


+		return;
+	}
+
+	cam = pipe_info->cam;
+	if (cam == NULL) {
+		err("no context!");

Do you use err() macro from usb.h ?
If yes - as i know it's better not to use this macros, because this macros can suddenly became deprecated.
It's more comfortable to use printk or dev_err.

+		return;
+	}
+	status = purb->status;
+	if (status != 0) {
+		DBG("read_pipe_completion: err\n");
+		return;
+	}
+
+	if (pipe_info->state == 0) {
+		DBG("exiting USB pipe\n");
+		return;
+	}
+
+	if (purb->actual_length < 0 || purb->actual_length > pipe_info->cur_transfer_size) {
+		dev_err(&cam->udev->dev, "wrong number of bytes\n");
+		return;
+	}
+
+	zr364xx_read_video_callback(cam, pipe_info, purb);
+
+	pipe_info->err_count = 0;
+	pipe = usb_rcvbulkpipe(cam->udev, cam->read_endpoint);
+
+	/* reuse urb */
+	usb_fill_bulk_urb(pipe_info->stream_urb, cam->udev,
+			  pipe,
+			  pipe_info->transfer_buffer,
+			  pipe_info->cur_transfer_size,
+			  read_pipe_completion, pipe_info);
+	
+	if (pipe_info->state != 0) {
+		if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL)) {
+			dev_err(&cam->udev->dev, "error submitting urb\n");
+			usb_free_urb(pipe_info->stream_urb);
+		}
+	} else {
+		DBG("read pipe complete state 0\n");
+	}
+	return;
+}
+
+static int zr364xx_start_readpipe(struct zr364xx_camera *cam)
+{
+	int pipe;
+	int retval;
+	int i;
+	struct zr364xx_pipeinfo *pipe_info = cam->pipes;
+	pipe = usb_rcvbulkpipe(cam->udev, cam->read_endpoint);
+	DBG("%s: start pipe IN %x\n", __func__, cam->read_endpoint);
+
+	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
+		pipe_info->state = 1;
+		pipe_info->buf_index = (u32) i;
+		pipe_info->priority_set = 0;
+		pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!pipe_info->stream_urb) {
+			dev_err(&cam->udev->dev, "ReadStream: Unable to alloc URB");

\n ?

+			return -ENOMEM;
+		}
+		/* transfer buffer allocated in board_init */
+		usb_fill_bulk_urb(pipe_info->stream_urb, cam->udev,
+				  pipe,
+				  pipe_info->transfer_buffer,
+				  pipe_info->cur_transfer_size,
+				  read_pipe_completion, pipe_info);
+
+		pipe_info->urb_size = sizeof(pipe_info->stream_urb);
+		DBG("submitting URB %p\n", pipe_info->stream_urb);
+		retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
+		if (retval) {
+			printk(KERN_ERR "zr364xx: start read pipe failed\n");
+			return retval;
+		}
+	}
+
+	return 0;
+}
+
+static void zr364xx_stop_readpipe(struct zr364xx_camera *cam)
+{
+	int j;
+
+	if (cam == NULL) {
+		err("zr364xx: invalid device");

err()..

+		return;
+	}
+	DBG("stop read pipe\n");
+	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
+		struct zr364xx_pipeinfo *pipe_info = &cam->pipes[j];
+		if (pipe_info) {
+			if (pipe_info->state == 0)
+				continue;
+			pipe_info->state = 0;
+			pipe_info->prev_state = 1;
+
+		}
+	}
+
+	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
+		struct zr364xx_pipeinfo *pipe_info = &cam->pipes[j];
+		if (pipe_info->stream_urb) {
+			/* cancel urb */
+			usb_kill_urb(pipe_info->stream_urb);
+			usb_free_urb(pipe_info->stream_urb);
+			pipe_info->stream_urb = NULL;
+		}
+	}
+	DBG("zr364xx stop read pipe: %d\n", j);
+	return;
+}
+
+/* starts acquisition process */
+static int zr364xx_start_acquire(struct zr364xx_camera *cam)
+{
+	int j;
+
+	DBG("zr364xx: start acquire\n");
+
+	cam->last_frame = -1;
+	cam->cur_frame = 0;
+	for (j = 0; j < FRAMES; j++) {
+		cam->buffer.frame[j].ulState = ZR364XX_READ_IDLE;
+		cam->buffer.frame[j].cur_size = 0;
+	}
+	return 0;
+}
+
+static int zr364xx_stop_acquire(struct zr364xx_camera *cam)
+{
+	DBG("stop acquire: releasing states\n");
+
+	cam->b_acquire = 0;
+	return 0;
+}
+
 static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 				   enum v4l2_buf_type type)
 {
-	return 0;
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+	int j;
+	int res;
+
+	DBG("%s\n", __func__);
+
+	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dev_err(&cam->udev->dev, "invalid fh type0\n");
+		return -EINVAL;
+	}
+	if (cam->type != type) {
+		dev_err(&cam->udev->dev, "invalid fh type1\n");
+		return -EINVAL;
+	}
+
+	if (!res_get(cam)) {
+		dev_err(&cam->udev->dev, "zr364xx: stream busy\n");

As i understand the behavour of dev_err you don't need "zr364xx:" chars in this message.

+		return -EBUSY;
+	}
+
+	cam->last_frame = -1;
+	cam->cur_frame = 0;
+	cam->frame_count = 0;
+	for (j = 0; j < FRAMES; j++) {
+		cam->buffer.frame[j].ulState = ZR364XX_READ_IDLE;
+		cam->buffer.frame[j].cur_size = 0;
+	}
+	res = videobuf_streamon(&cam->vb_vidq);
+	if (res == 0) {
+		zr364xx_start_acquire(cam);
+		cam->b_acquire = 1;
+	} else {
+		res_free(cam);
+	}
+	return res;
 }
 
 static int zr364xx_vidioc_streamoff(struct file *file, void *priv,
 				    enum v4l2_buf_type type)
 {
+	int res;
+	struct video_device *vdev = video_devdata(file);
+	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+
+	DBG("%s\n", __func__);
+	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		printk(KERN_ERR "invalid fh type0\n");

It's better to add module name here.

+		return -EINVAL;
+	}
+	if (cam->type != type) {
+		printk(KERN_ERR "invalid type i\n");

The same here.

+		return -EINVAL;
+	}
+	zr364xx_stop_acquire(cam);
+	res = videobuf_streamoff(&cam->vb_vidq);
+	if (res < 0)
+		return res;
+	res_free(cam);
 	return 0;
 }
 
-
 /* open the camera */
 static int zr364xx_open(struct inode *inode, struct file *file)
 {
@@ -641,24 +1328,14 @@ static int zr364xx_open(struct inode *in
 	struct usb_device *udev = cam->udev;
 	int i, err;
 
-	DBG("zr364xx_open");
-
-	mutex_lock(&cam->lock);
+	DBG("zr364xx_open\n");
+	mutex_lock(&cam->open_lock);
 
 	if (cam->users) {
 		err = -EBUSY;
 		goto out;
 	}
 
-	if (!cam->framebuf) {
-		cam->framebuf = vmalloc_32(MAX_FRAME_SIZE * FRAMES);
-		if (!cam->framebuf) {
-			dev_err(&cam->udev->dev, "vmalloc_32 failed!\n");
-			err = -ENOMEM;
-			goto out;
-		}
-	}
-
 	for (i = 0; init[cam->method][i].size != -1; i++) {
 		err =
 		    send_control_msg(udev, 1, init[cam->method][i].value,
@@ -671,9 +1348,16 @@ static int zr364xx_open(struct inode *in
 		}
 	}
 
-	cam->skip = 2;
 	cam->users++;
 	file->private_data = vdev;
+	cam->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	cam->fmt = formats;
+
+	videobuf_queue_vmalloc_init(&cam->vb_vidq, &zr364xx_video_qops,
+				    NULL, &cam->slock,
+				    cam->type,
+				    V4L2_FIELD_INTERLACED,
+				    sizeof(struct zr364xx_buffer), cam);
 
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
@@ -682,10 +1366,61 @@ static int zr364xx_open(struct inode *in
 	err = 0;
 
 out:
-	mutex_unlock(&cam->lock);
+	mutex_unlock(&cam->open_lock);
 	return err;
 }
 
+static int zr364xx_release_sys_buffers(struct zr364xx_camera *cam)
+{
+	unsigned long i;
+	DBG("release sys buffers\n");
+	for (i = 0; i < FRAMES; i++) {
+		if (cam->buffer.frame[i].lpvbits) {
+			DBG("vfree %p\n", cam->buffer.frame[i].lpvbits);
+			vfree(cam->buffer.frame[i].lpvbits);
+		}
+		cam->buffer.frame[i].lpvbits = NULL;
+	}
+	return 0;
+}
+
+static int zr364xx_board_shutdown(struct zr364xx_camera *cam)
+{
+	u32 i;
+
+	DBG("zr364xx: board shutdown: %p\n", cam);
+
+	if (cam->b_acquire)
+		zr364xx_stop_acquire(cam);
+
+	zr364xx_stop_readpipe(cam);
+	zr364xx_release_sys_buffers(cam);
+
+	/* release transfer buffers */
+	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
+		struct zr364xx_pipeinfo *pipe = &cam->pipes[i];
+		kfree(pipe->transfer_buffer);
+	}
+	return 0;
+}
+
+static void zr364xx_destroy(struct zr364xx_camera *cam)
+{
+	if (!cam) {
+		printk(KERN_ERR "zr364xx, %s: no device\n", __func__);
+		return;
+	}
+	mutex_lock(&cam->open_lock);
+	if (cam->vdev)
+		video_unregister_device(cam->vdev);
+	cam->vdev = NULL;
+
+	/* board shutdown stops the read pipe if it is running */
+	zr364xx_board_shutdown(cam);
+	DBG("%s\n", __func__);
+	mutex_unlock(&cam->open_lock);
+	kfree(cam);
+}
 
 /* release the camera */
 static int zr364xx_release(struct inode *inode, struct file *file)
@@ -695,15 +1430,26 @@ static int zr364xx_release(struct inode 
 	struct usb_device *udev;
 	int i, err;
 
-	DBG("zr364xx_release");
+	DBG("zr364xx_release\n");
 
 	if (vdev == NULL)
 		return -ENODEV;
+
 	cam = video_get_drvdata(vdev);
 
+	if (!cam)
+		return -ENODEV;
+
+	mutex_lock(&cam->open_lock);
 	udev = cam->udev;
 
-	mutex_lock(&cam->lock);
+	/* turn off stream */
+	if (res_check(cam)) {
+		if (cam->b_acquire)
+			zr364xx_stop_acquire(cam);
+		videobuf_streamoff(&cam->vb_vidq);
+		res_free(cam);
+	}
 
 	cam->users--;
 	file->private_data = NULL;
@@ -726,49 +1472,57 @@ static int zr364xx_release(struct inode 
 	err = 0;
 
 out:
-	mutex_unlock(&cam->lock);
+	mutex_unlock(&cam->open_lock);
+
 	return err;
 }
 
 
 static int zr364xx_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	void *pos;
-	unsigned long start = vma->vm_start;
-	unsigned long size = vma->vm_end - vma->vm_start;
 	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
+	int ret;
 
-	DBG("zr364xx_mmap: %ld\n", size);
-
-	if (vdev == NULL)
+	if (vdev == NULL) {
+		DBG("%s: vdev == NULL\n", __func__);
 		return -ENODEV;
-	cam = video_get_drvdata(vdev);
-
-	pos = cam->framebuf;
-	while (size > 0) {
-		if (vm_insert_page(vma, start, vmalloc_to_page(pos)))
-			return -EAGAIN;
-		start += PAGE_SIZE;
-		pos += PAGE_SIZE;
-		if (size > PAGE_SIZE)
-			size -= PAGE_SIZE;
-		else
-			size = 0;
 	}
+	DBG("mmap called, vma=0x%08lx\n", (unsigned long)vma);
 
-	return 0;
+	cam = video_get_drvdata(vdev);
+	ret = videobuf_mmap_mapper(&cam->vb_vidq, vma);
+
+	DBG("vma start=0x%08lx, size=%ld, ret=%d\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start, ret);
+	return ret;
 }
 
+static unsigned int zr364xx_poll(struct file *file,
+			       struct poll_table_struct *wait)
+{
+	struct zr364xx_camera *cam = file->private_data;
+	DBG("%s\n", __func__);
+
+	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return POLLERR;
+
+	return videobuf_poll_stream(file, &cam->vb_vidq, wait);
+}
 
 static const struct file_operations zr364xx_fops = {
 	.owner = THIS_MODULE,
 	.open = zr364xx_open,
 	.release = zr364xx_release,
-	.read = zr364xx_read,
+	/*.read = zr364xx_read, Lamarque TODO: re-implement. */
 	.mmap = zr364xx_mmap,
 	.ioctl = video_ioctl2,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = v4l_compat_ioctl32,
+#endif
 	.llseek = no_llseek,
+	.poll = zr364xx_poll,
 };
 
 static const struct v4l2_ioctl_ops zr364xx_ioctl_ops = {
@@ -785,6 +1539,10 @@ static const struct v4l2_ioctl_ops zr364
 	.vidioc_queryctrl	= zr364xx_vidioc_queryctrl,
 	.vidioc_g_ctrl		= zr364xx_vidioc_g_ctrl,
 	.vidioc_s_ctrl		= zr364xx_vidioc_s_ctrl,
+	.vidioc_reqbufs         = zr364xx_vidioc_reqbufs,
+	.vidioc_querybuf        = zr364xx_vidioc_querybuf,
+	.vidioc_qbuf            = zr364xx_vidioc_qbuf,
+	.vidioc_dqbuf           = zr364xx_vidioc_dqbuf,
 };
 
 static struct video_device zr364xx_template = {
@@ -795,20 +1553,95 @@ static struct video_device zr364xx_templ
 	.minor = -1,
 };
 
+/*
+ * Create the system ring buffer to copy frames into from the
+ * usb read pipe.
+ */
+static int zr364xx_create_sys_buffers(struct zr364xx_camera *cam)
+{
+	unsigned long i;
+	unsigned long reqsize;
+	DBG("create sys buffers\n");
+
+	cam->buffer.dwFrames = FRAMES;
+
+	/* always allocate maximum size for system buffers */
+	reqsize = MAX_FRAME_SIZE;
+
+	for (i = 0; i < FRAMES; i++) {
+		/* allocate the frames */
+		cam->buffer.frame[i].lpvbits = vmalloc(reqsize);
+
+		DBG("valloc %p, idx %lu, pdata %p\n",
+			&cam->buffer.frame[i], i,
+			cam->buffer.frame[i].lpvbits);
+		cam->buffer.frame[i].size = reqsize;
+		if (cam->buffer.frame[i].lpvbits == NULL) {
+			printk(KERN_INFO "out of memory.  using less frames\n");

Module name, please.

+			cam->buffer.dwFrames = i;
+			break;
+		}
+	}
 
+	/* make sure internal states are set */
+	for (i = 0; i < FRAMES; i++) {
+		cam->buffer.frame[i].ulState = ZR364XX_READ_IDLE;
+		cam->buffer.frame[i].cur_size = 0;
+	}
+
+	cam->cur_frame = 0;
+	cam->last_frame = -1;
+	return 0;
+}
 
 /*******************/
 /* USB integration */
 /*******************/
+static int zr364xx_board_init(struct zr364xx_camera *cam)
+{
+	int j;
+
+	DBG("board init: %p\n", cam);
+
+	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
+		struct zr364xx_pipeinfo *pipe = &cam->pipes[j];
+
+		memset(pipe, 0, sizeof(*pipe));
+		pipe->cam = cam;
+		pipe->cur_transfer_size = BUFFER_SIZE;
+		pipe->max_transfer_size = BUFFER_SIZE;
+
+		pipe->transfer_buffer = kzalloc(pipe->max_transfer_size,
+						GFP_KERNEL);
+		if (pipe->transfer_buffer == NULL) {
+			DBG("out of memory!\n");
+			return -ENOMEM;
+		}
+
+	}
+
+	cam->b_acquire = 0;
+	cam->frame_count = 0;
+	/* create the system buffers */
+	zr364xx_create_sys_buffers(cam);
+	
+	/* start read pipe */
+	zr364xx_start_readpipe(cam);
+	DBG("zr364xx: board initialized\n");
+	return 0;
+}
 
 static int zr364xx_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct zr364xx_camera *cam = NULL;
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
 	int err;
+	int i;
 
-	DBG("probing...");
+	DBG("probing...\n");
 
 	dev_info(&intf->dev, DRIVER_DESC " compatible webcam plugged\n");
 	dev_info(&intf->dev, "model %04x:%04x detected\n",
@@ -830,19 +1663,13 @@ static int zr364xx_probe(struct usb_inte
 		return -ENOMEM;
 	}
 	memcpy(cam->vdev, &zr364xx_template, sizeof(zr364xx_template));
+	cam->vdev->parent = &intf->dev;
 	video_set_drvdata(cam->vdev, cam);
 	if (debug)
 		cam->vdev->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
 
 	cam->udev = udev;
 
-	if ((cam->buffer = kmalloc(BUFFER_SIZE, GFP_KERNEL)) == NULL) {
-		dev_info(&udev->dev, "cam->buffer: out of memory !\n");
-		video_device_release(cam->vdev);
-		kfree(cam);
-		return -ENODEV;
-	}
-
 	switch (mode) {
 	case 1:
 		dev_info(&udev->dev, "160x120 mode selected\n");
@@ -869,21 +1696,49 @@ static int zr364xx_probe(struct usb_inte
 	header2[439] = cam->width / 256;
 	header2[440] = cam->width % 256;
 
+	cam->users = 0;
 	cam->nb = 0;
-	cam->brightness = 64;
+	cam->mode.bright = 64;
 	mutex_init(&cam->lock);
+	mutex_init(&cam->open_lock);
+
+	DBG("dev: %p, udev %p interface %p\n", cam, cam->udev, intf);
+
+	/* set up the endpoint information  */
+	iface_desc = intf->cur_altsetting;
+	DBG("num endpoints %d\n", iface_desc->desc.bNumEndpoints);
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &iface_desc->endpoint[i].desc;
+		if (!cam->read_endpoint && usb_endpoint_is_bulk_in(endpoint)) {
+			/* we found the bulk in endpoint */
+			cam->read_endpoint = endpoint->bEndpointAddress;
+		}
+	}
 
+	if (!cam->read_endpoint) {
+		dev_err(&intf->dev, "Could not find bulk-in endpoint");

\n ?

+		return -ENOMEM;
+	}
+
+	/* v4l */
+	INIT_LIST_HEAD(&cam->vidq.active);
+	cam->vidq.cam = cam;
+	cam->vidq.kthread = NULL;
 	err = video_register_device(cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
 		video_device_release(cam->vdev);
-		kfree(cam->buffer);
 		kfree(cam);
 		return err;
 	}
 
 	usb_set_intfdata(intf, cam);
 
+	/* load zr364xx board specific */
+	zr364xx_board_init(cam);
+
+	spin_lock_init(&cam->slock);
+
 	dev_info(&udev->dev, DRIVER_DESC " controlling video device %d\n",
 		 cam->vdev->num);
 	return 0;
@@ -893,16 +1748,15 @@ static int zr364xx_probe(struct usb_inte
 static void zr364xx_disconnect(struct usb_interface *intf)
 {
 	struct zr364xx_camera *cam = usb_get_intfdata(intf);
+
+	videobuf_mmap_free(&cam->vb_vidq);
 	usb_set_intfdata(intf, NULL);
 	dev_set_drvdata(&intf->dev, NULL);
 	dev_info(&intf->dev, DRIVER_DESC " webcam unplugged\n");
 	if (cam->vdev)
 		video_unregister_device(cam->vdev);
 	cam->vdev = NULL;
-	kfree(cam->buffer);
-	if (cam->framebuf)
-		vfree(cam->framebuf);
-	kfree(cam);
+	zr364xx_destroy(cam);
 }
 
 
@@ -918,7 +1772,6 @@ static struct usb_driver zr364xx_driver 
 	.id_table = device_table
 };
 
-
 static int __init zr364xx_init(void)
 {
 	int retval;


Also, our current maillist is linux-media@vger.kernel.org.
It's better to post patches there.

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
