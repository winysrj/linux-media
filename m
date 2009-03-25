Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:10258 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZCYXZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 19:25:24 -0400
Received: by qw-out-2122.google.com with SMTP id 8so316569qwh.37
        for <linux-media@vger.kernel.org>; Wed, 25 Mar 2009 16:25:22 -0700 (PDT)
To: Antoine Jacquet <royale@zerezo.com>, linux-media@vger.kernel.org
Subject: Patch implementing V4L2_CAP_STREAMING for zr364xx driver
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	video4linux-list@redhat.com
From: Lamarque Vieira Souza <lamarque@gmail.com>
Date: Wed, 25 Mar 2009 20:25:10 -0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_X1ryJGl4DMvwPVB"
Message-Id: <200903252025.11544.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_X1ryJGl4DMvwPVB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

	Hi,

        I have implemented V4L2_CAP_STREAMING for the zr364xx driver (see the 
attached file). Could you review the code for me? My 
Creative PC-CAM 880 works, but I do not have any other webcam to test the 
code. Besides the streaming implementation the patch also does:

. re-implement V4L2_CAP_READWRITE using videobuf.

. copy cam->udev->product to the card field of the v4l2_capability struct. 
That gives more information to the users about the webcam.

. move the brightness setting code from before requesting a frame (in 
read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is 
executed only when the application request a change in brightness and not 
before every frame read. Is there any reason to set the brightness before 
every frame read?

. comment part of zr364xx_vidioc_try_fmt_vid_cap. Skype + libv4l do not work 
if it is there and libv4's maintainer told me it is a driver bug, so I fix it.

	This patch is needed for applications such as mplayer, Kopete+libv4l and 
Skype+libv4l can make use of the webcam that comes with zr364xx chip. The 
patch is big, if you need it splitted into small patches I can do it.

	Best regards,

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/


--Boundary-00=_X1ryJGl4DMvwPVB
Content-Type: text/x-patch;
  charset="UTF-8";
  name="zr364xx.c-streaming.patch-2.6.29-20090325"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="zr364xx.c-streaming.patch-2.6.29-20090325"

--- linux-2.6.29/drivers/media/video/zr364xx.c	2009-03-25 19:06:37.241552912 -0300
+++ linux-2.6.29-lvs/drivers/media/video/zr364xx.c	2009-03-25 19:25:58.981551627 -0300
@@ -1,5 +1,5 @@
 /*
- * Zoran 364xx based USB webcam module version 0.72
+ * Zoran 364xx based USB webcam module version 0.73
  *
  * Allows you to use your USB webcam with V4L2 applications
  * This is still in heavy developpement !
@@ -10,6 +10,8 @@
  * Heavily inspired by usb-skeleton.c, vicam.c, cpia.c and spca50x.c drivers
  * V4L2 version inspired by meye.c driver
  *
+ * Some video buffer code by Lamarque based on s2255drv driver.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -25,7 +27,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -36,23 +37,33 @@
 #include <linux/highmem.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf-vmalloc.h>
 
 
 /* Version Information */
-#define DRIVER_VERSION "v0.72"
+#define ZR364_VERSION_CODE KERNEL_VERSION(0, 7, 3)
+#define DRIVER_VERSION "v0.73"
 #define DRIVER_AUTHOR "Antoine Jacquet, http://royale.zerezo.com/"
 #define DRIVER_DESC "Zoran 364xx"
 
 
 /* Camera */
-#define FRAMES 2
+#define FRAMES 1
 #define MAX_FRAME_SIZE 100000
 #define BUFFER_SIZE 0x1000
 #define CTRL_TIMEOUT 500
 
+#define ZR364XX_DEF_BUFS	4
+#define ZR364XX_READ_IDLE	0
+#define ZR364XX_READ_FRAME	1
 
 /* Debug macro */
-#define DBG(x...) if (debug) printk(KERN_INFO KBUILD_MODNAME x)
+#define DBG(fmt, args...) \
+	do { \
+		if (debug) { \
+			printk(KERN_INFO KBUILD_MODNAME " " fmt, ##args); \
+		} \
+	} while (0)
 
 
 /* Init methods, need to find nicer names for these
@@ -101,24 +112,96 @@ static struct usb_device_id device_table
 
 MODULE_DEVICE_TABLE(usb, device_table);
 
+struct zr364xx_mode {
+	u32 color;	/* output video color format */
+	u32 brightness;	/* brightness */
+};
+
+/* frame structure */
+struct zr364xx_framei {
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
+	struct zr364xx_camera	*cam;
+};
+
+struct zr364xx_pipeinfo {
+	u32 transfer_size;
+	u8 *transfer_buffer;
+	u32 transfer_flags;;
+	u32 state;
+	u32 prev_state;
+	u32 urb_size;
+	void *stream_urb;
+	void *cam;	/* back pointer to zr364xx_camera struct */
+	u32 err_count;
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
+	struct zr364xx_bufferi		buffer;
 	int skip;
-	int brightness;
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
+	struct zr364xx_pipeinfo	pipe[1];
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
@@ -272,139 +355,116 @@ static unsigned char header2[] = {
 };
 static unsigned char header3;
 
+/* ------------------------------------------------------------------
+   Videobuf operations
+   ------------------------------------------------------------------*/
 
+static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
+			unsigned int *size)
+{
+	struct zr364xx_camera *cam = vq->priv_data;
 
-/********************/
-/* V4L2 integration */
-/********************/
+	*size = cam->width * cam->height * (cam->fmt->depth >> 3);
 
-/* this function reads a full JPEG picture synchronously
- * TODO: do it asynchronously... */
-static int read_frame(struct zr364xx_camera *cam, int framenum)
-{
-	int i, n, temp, head, size, actual_length;
-	unsigned char *ptr = NULL, *jpeg;
-
-      redo:
-	/* hardware brightness */
-	n = send_control_msg(cam->udev, 1, 0x2001, 0, NULL, 0);
-	temp = (0x60 << 8) + 127 - cam->brightness;
-	n = send_control_msg(cam->udev, 1, temp, 0, NULL, 0);
-
-	/* during the first loop we are going to insert JPEG header */
-	head = 0;
-	/* this is the place in memory where we are going to build
-	 * the JPEG image */
-	jpeg = cam->framebuf + framenum * MAX_FRAME_SIZE;
-	/* read data... */
-	do {
-		n = usb_bulk_msg(cam->udev,
-				 usb_rcvbulkpipe(cam->udev, 0x81),
-				 cam->buffer, BUFFER_SIZE, &actual_length,
-				 CTRL_TIMEOUT);
-		DBG("buffer : %d %d", cam->buffer[0], cam->buffer[1]);
-		DBG("bulk : n=%d size=%d", n, actual_length);
-		if (n < 0) {
-			dev_err(&cam->udev->dev, "error reading bulk msg\n");
-			return 0;
-		}
-		if (actual_length < 0 || actual_length > BUFFER_SIZE) {
-			dev_err(&cam->udev->dev, "wrong number of bytes\n");
-			return 0;
-		}
-
-		/* swap bytes if camera needs it */
-		if (cam->method == METHOD0) {
-			u16 *buf = (u16*)cam->buffer;
-			for (i = 0; i < BUFFER_SIZE/2; i++)
-				swab16s(buf + i);
-		}
-
-		/* write the JPEG header */
-		if (!head) {
-			DBG("jpeg header");
-			ptr = jpeg;
-			memcpy(ptr, header1, sizeof(header1));
-			ptr += sizeof(header1);
-			header3 = 0;
-			memcpy(ptr, &header3, 1);
-			ptr++;
-			memcpy(ptr, cam->buffer, 64);
-			ptr += 64;
-			header3 = 1;
-			memcpy(ptr, &header3, 1);
-			ptr++;
-			memcpy(ptr, cam->buffer + 64, 64);
-			ptr += 64;
-			memcpy(ptr, header2, sizeof(header2));
-			ptr += sizeof(header2);
-			memcpy(ptr, cam->buffer + 128,
-			       actual_length - 128);
-			ptr += actual_length - 128;
-			head = 1;
-			DBG("header : %d %d %d %d %d %d %d %d %d",
-			    cam->buffer[0], cam->buffer[1], cam->buffer[2],
-			    cam->buffer[3], cam->buffer[4], cam->buffer[5],
-			    cam->buffer[6], cam->buffer[7], cam->buffer[8]);
-		} else {
-			memcpy(ptr, cam->buffer, actual_length);
-			ptr += actual_length;
-		}
-	}
-	/* ... until there is no more */
-	while (actual_length == BUFFER_SIZE);
-
-	/* we skip the 2 first frames which are usually buggy */
-	if (cam->skip) {
-		cam->skip--;
-		goto redo;
-	}
-
-	/* go back to find the JPEG EOI marker */
-	size = ptr - jpeg;
-	ptr -= 2;
-	while (ptr > jpeg) {
-		if (*ptr == 0xFF && *(ptr + 1) == 0xD9
-		    && *(ptr + 2) == 0xFF)
-			break;
-		ptr--;
-	}
-	if (ptr == jpeg)
-		DBG("No EOI marker");
+	if (*count == 0)
+		*count = ZR364XX_DEF_BUFS;
 
-	/* Sometimes there is junk data in the middle of the picture,
-	 * we want to skip this bogus frames */
-	while (ptr > jpeg) {
-		if (*ptr == 0xFF && *(ptr + 1) == 0xFF
-		    && *(ptr + 2) == 0xFF)
-			break;
-		ptr--;
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
+	/*Lamarque: is this really needed? Sometimes this blocks rmmod forever
+	 * after running Skype on an AMD64 system. */
+	/*videobuf_waiton(&buf->vb, 0, 0);*/
+
+	if (in_interrupt())
+		BUG();
+
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
+	DBG("%s, field=%d, fmt name = %s\n", __func__, field, cam->fmt != NULL ? cam->fmt->name : "");
+	if (cam->fmt == NULL)
+		return -EINVAL;
+
+	buf->vb.size = cam->width * cam->height * (cam->fmt->depth >> 3);
+
+	if (buf->vb.baddr != 0 && buf->vb.bsize < buf->vb.size) {
+		DBG("invalid buffer prepare\n");
+		return -EINVAL;
 	}
-	if (ptr != jpeg) {
-		DBG("Bogus frame ? %d", cam->nb);
-		goto redo;
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
 	}
 
-	DBG("jpeg : %d %d %d %d %d %d %d %d",
-	    jpeg[0], jpeg[1], jpeg[2], jpeg[3],
-	    jpeg[4], jpeg[5], jpeg[6], jpeg[7]);
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
+
+	DBG("%s\n", __func__);
 
-	return size;
+	buf->vb.state = VIDEOBUF_QUEUED;
+	list_add_tail(&buf->vb.queue, &cam->vidq.active);
 }
 
+static void buffer_release(struct videobuf_queue *vq,
+			   struct videobuf_buffer *vb)
+{
+	struct zr364xx_buffer *buf = container_of(vb, struct zr364xx_buffer, vb);
+
+	DBG("%s\n", __func__);
+	free_buffer(vq, buf);
+}
 
-static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t cnt,
+static struct videobuf_queue_ops zr364xx_video_qops = {
+	.buf_setup = buffer_setup,
+	.buf_prepare = buffer_prepare,
+	.buf_queue = buffer_queue,
+	.buf_release = buffer_release,
+};
+
+/********************/
+/* V4L2 integration */
+/********************/
+static int zr364xx_vidioc_streamon(struct file *file, void *priv,
+				   enum v4l2_buf_type type);
+
+static ssize_t zr364xx_read(struct file *file, char __user *buf, size_t count,
 			    loff_t * ppos)
 {
-	unsigned long count = cnt;
-	struct video_device *vdev = video_devdata(file);
-	struct zr364xx_camera *cam;
+	struct zr364xx_camera *cam = video_drvdata(file);
 
-	DBG("zr364xx_read: read %d bytes.", (int) count);
-
-	if (vdev == NULL)
-		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	DBG("%s\n", __func__);
 
 	if (!buf)
 		return -EINVAL;
@@ -412,22 +472,268 @@ static ssize_t zr364xx_read(struct file 
 	if (!count)
 		return -EINVAL;
 
-	/* NoMan Sux ! */
-	count = read_frame(cam, 0);
+	if (cam->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    zr364xx_vidioc_streamon(file, cam, cam->type) == 0) {
+		DBG("%s: reading %d bytes at pos %d.\n", __func__, (int) count, (int) *ppos);
+		return videobuf_read_one(&cam->vb_vidq, buf, count, ppos,
+					file->f_flags & O_NONBLOCK);
+	}
+
+	return 0;
+}
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
+			printk(KERN_DEBUG KBUILD_MODNAME ": unknown format?\n");
+		}
+		cam->last_frame = -1;
+	} else {
+		printk(KERN_ERR KBUILD_MODNAME ": =======no frame\n");
+		return;
+	}
+	DBG("%s: Buffer 0x%08lx size= %d\n", __func__,
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
+	/*DBG("buffer to user\n");*/
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
+	/* search done.  now find out if should be acquiring */
+	if (!cam->b_acquire) {
+		/* we found a frame, but this channel is turned off */
+		frm->ulState = ZR364XX_READ_IDLE;
+		return -EINVAL;
+	}
+
+	if (frm->lpvbits == NULL) {
+		DBG("%s: frame buffer == NULL.%p %p %d\n", __func__,
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
+	/*DBG("cur_size %lu urb size %d\n", frm->cur_size, purb->actual_length);*/
+
+	if (purb->actual_length < pipe_info->transfer_size) {
+		DBG("****************Buffer[%d]full*************\n", idx);
+		cam->last_frame = cam->cur_frame;
+		cam->cur_frame++;
+		/* end of system frame ring buffer, start at zero */
+		if (cam->cur_frame == cam->buffer.dwFrames)
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
 
-	if (copy_to_user(buf, cam->framebuf, count))
-		return -EFAULT;
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
+			/* we skip the 2 first frames which are usually buggy */
+			if (cam->skip)
+				cam->skip--;
+			else {
+				DBG("jpeg(%lu): %d %d %d %d %d %d %d %d\n", frm->cur_size,
+				    pdest[0], pdest[1], pdest[2], pdest[3],
+				    pdest[4], pdest[5], pdest[6], pdest[7]);
+
+				zr364xx_got_frame(cam, frm->cur_size);
+			}
+		}
+		cam->frame_count++;
+		frm->ulState = ZR364XX_READ_IDLE;
+		frm->cur_size = 0;
+	}
+	/* done successfully */
+	return 0;
+}
 
-	return count;
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
+	DBG("res: get\n");
+	mutex_unlock(&cam->lock);
+	return 1;
 }
 
+static inline int res_check(struct zr364xx_camera *cam)
+{
+	return cam->resources;
+}
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
+	struct zr364xx_camera *cam = video_drvdata(file);
+
 	memset(cap, 0, sizeof(*cap));
-	strcpy(cap->driver, DRIVER_DESC);
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	strlcpy(cap->driver, DRIVER_DESC, sizeof(cap->driver));
+	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
+	strlcpy(cap->bus_info, dev_name(&cam->udev->dev), sizeof(cap->bus_info));
+	cap->version = ZR364_VERSION_CODE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	return 0;
 }
 
@@ -461,12 +767,11 @@ static int zr364xx_vidioc_s_input(struct
 static int zr364xx_vidioc_queryctrl(struct file *file, void *priv,
 				    struct v4l2_queryctrl *c)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
 
-	if (vdev == NULL)
+	if (file == NULL)
 		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	cam = video_drvdata(file);
 
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -475,7 +780,7 @@ static int zr364xx_vidioc_queryctrl(stru
 		c->minimum = 0;
 		c->maximum = 127;
 		c->step = 1;
-		c->default_value = cam->brightness;
+		c->default_value = cam->mode.brightness;
 		c->flags = 0;
 		break;
 	default:
@@ -487,36 +792,42 @@ static int zr364xx_vidioc_queryctrl(stru
 static int zr364xx_vidioc_s_ctrl(struct file *file, void *priv,
 				 struct v4l2_control *c)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
+	int temp;
 
-	if (vdev == NULL)
+	if (file == NULL)
 		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	cam = video_drvdata(file);
 
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
-		cam->brightness = c->value;
+		cam->mode.brightness = c->value;
+		/* hardware brightness */
+		mutex_lock(&cam->lock);
+		send_control_msg(cam->udev, 1, 0x2001, 0, NULL, 0);
+		temp = (0x60 << 8) + 127 - cam->mode.brightness;
+		send_control_msg(cam->udev, 1, temp, 0, NULL, 0);
+		mutex_unlock(&cam->lock);
 		break;
 	default:
 		return -EINVAL;
 	}
+
 	return 0;
 }
 
 static int zr364xx_vidioc_g_ctrl(struct file *file, void *priv,
 				 struct v4l2_control *c)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
 
-	if (vdev == NULL)
+	if (file == NULL)
 		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	cam = video_drvdata(file);
 
 	switch (c->id) {
 	case V4L2_CID_BRIGHTNESS:
-		c->value = cam->brightness;
+		c->value = cam->mode.brightness;
 		break;
 	default:
 		return -EINVAL;
@@ -535,28 +846,41 @@ static int zr364xx_vidioc_enum_fmt_vid_c
 	f->index = 0;
 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
-	strcpy(f->description, "JPEG");
-	f->pixelformat = V4L2_PIX_FMT_JPEG;
+	strcpy(f->description, formats[0].name);
+	f->pixelformat = formats[0].fourcc;
 	return 0;
 }
 
+static char *decode_fourcc(__u32 pixelformat, char *buf)
+{
+	buf[0] = pixelformat & 0xff;
+	buf[1] = (pixelformat >> 8) & 0xff;
+	buf[2] = (pixelformat >> 16) & 0xff;
+	buf[3] = (pixelformat >> 24) & 0xff;
+	buf[4] = '\0';
+	return buf;
+}
+
 static int zr364xx_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				      struct v4l2_format *f)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct zr364xx_camera *cam;
-
-	if (vdev == NULL)
-		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	struct zr364xx_camera *cam = video_drvdata(file);
+	char pixelformat_name[5];
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG)
+	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG) {
+		DBG("%s: unsupported pixelformat V4L2_PIX_FMT_%s\n", __func__, decode_fourcc(f->fmt.pix.pixelformat, pixelformat_name));
 		return -EINVAL;
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
+	}
+
+	/* Lamarque 25/03/2009: Skype + libv4l do not work if we return -EINVAL here. */
+	/*if (f->fmt.pix.field != V4L2_FIELD_ANY &&
+	    f->fmt.pix.field != V4L2_FIELD_NONE) {
+		DBG("%s: unsupported field value %d\n",__func__, f->fmt.pix.field);
 		return -EINVAL;
+	}*/
+
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.width = cam->width;
 	f->fmt.pix.height = cam->height;
@@ -564,24 +888,24 @@ static int zr364xx_vidioc_try_fmt_vid_ca
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
 	f->fmt.pix.priv = 0;
+	DBG("%s: V4L2_PIX_FMT_%s (%d) ok!\n", __func__, decode_fourcc(f->fmt.pix.pixelformat, pixelformat_name), f->fmt.pix.field);
 	return 0;
 }
 
 static int zr364xx_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
 
-	if (vdev == NULL)
+	if (file == NULL)
 		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	cam = video_drvdata(file);
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	memset(&f->fmt.pix, 0, sizeof(struct v4l2_pix_format));
 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	f->fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
+	f->fmt.pix.pixelformat = formats[0].fourcc;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.width = cam->width;
 	f->fmt.pix.height = cam->height;
@@ -592,23 +916,26 @@ static int zr364xx_vidioc_g_fmt_vid_cap(
 	return 0;
 }
 
+/* Lamarque TODO: implement changing resolution on the fly */
 static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct zr364xx_camera *cam;
-
-	if (vdev == NULL)
-		return -ENODEV;
-	cam = video_get_drvdata(vdev);
+	struct zr364xx_camera *cam = video_drvdata(file);
+	struct videobuf_queue *q = &cam->vb_vidq;
+	char pixelformat_name[5];
+	int ret = zr364xx_vidioc_try_fmt_vid_cap(file, cam, f);
+
+	if (ret < 0)
+		return (ret);
+	
+	mutex_lock(&q->vb_lock);
+
+	if (videobuf_queue_is_busy(&cam->vb_vidq)) {
+		DBG("%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG)
-		return -EINVAL;
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.width = cam->width;
 	f->fmt.pix.height = cam->height;
@@ -616,19 +943,251 @@ static int zr364xx_vidioc_s_fmt_vid_cap(
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
 	f->fmt.pix.priv = 0;
-	DBG("ok!");
+	cam->vb_vidq.field = f->fmt.pix.field;
+	cam->mode.color = V4L2_PIX_FMT_JPEG;
+	ret = 0;
+
+out:
+	mutex_unlock(&q->vb_lock);
+
+	DBG("%s: V4L2_PIX_FMT_%s (%d) ok!\n", __func__, decode_fourcc(f->fmt.pix.pixelformat, pixelformat_name), f->fmt.pix.field);
+	return ret;
+}
+
+static int zr364xx_vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	int rc;
+	struct zr364xx_camera *cam = video_drvdata(file);
+	rc = videobuf_reqbufs(&cam->vb_vidq, p);
+	return rc;
+}
+
+static int zr364xx_vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	int rc;
+	struct zr364xx_camera *cam = video_drvdata(file);
+	rc = videobuf_querybuf(&cam->vb_vidq, p);
+	return rc;
+}
+
+static int zr364xx_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	int rc;
+	struct zr364xx_camera *cam = video_drvdata(file);
+	DBG("%s\n", __func__);
+	rc = videobuf_qbuf(&cam->vb_vidq, p);
+	return rc;
+}
+
+static int zr364xx_vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	int rc;
+	struct zr364xx_camera *cam = video_drvdata(file);
+	DBG("%s\n", __func__);
+	rc = videobuf_dqbuf(&cam->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	return rc;
+}
+
+static void read_pipe_completion(struct urb *purb)
+{
+	struct zr364xx_pipeinfo *pipe_info;
+	struct zr364xx_camera *cam;
+	int pipe;
+
+	pipe_info = purb->context;
+	/*DBG("%s %p, status %d\n", __func__, purb, purb->status);*/
+	if (pipe_info == NULL) {
+		printk(KERN_ERR KBUILD_MODNAME ": no context!\n");
+		return;
+	}
+
+	cam = pipe_info->cam;
+	if (cam == NULL) {
+		printk(KERN_ERR KBUILD_MODNAME ": no context!\n");
+		return;
+	}
+	if (purb->status != 0) {
+		DBG("_%s: err status = %d\n", __func__, purb->status);
+		return;
+	}
+
+	if (pipe_info->state == 0) {
+		DBG("exiting USB pipe\n");
+		return;
+	}
+
+	if (purb->actual_length < 0 || purb->actual_length > pipe_info->transfer_size) {
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
+			  pipe_info->transfer_size,
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
+	struct zr364xx_pipeinfo *pipe_info = cam->pipe;
+	pipe = usb_rcvbulkpipe(cam->udev, cam->read_endpoint);
+	DBG("%s: start pipe IN x%x\n", __func__, cam->read_endpoint);
+
+	pipe_info->state = 1;
+	pipe_info->priority_set = 0;
+	pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!pipe_info->stream_urb) {
+		dev_err(&cam->udev->dev, "ReadStream: Unable to alloc URB\n");
+		return -ENOMEM;
+	}
+	/* transfer buffer allocated in board_init */
+	usb_fill_bulk_urb(pipe_info->stream_urb, cam->udev,
+			  pipe,
+			  pipe_info->transfer_buffer,
+			  pipe_info->transfer_size,
+			  read_pipe_completion, pipe_info);
+
+	pipe_info->urb_size = sizeof(pipe_info->stream_urb);
+	DBG("submitting URB %p\n", pipe_info->stream_urb);
+	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
+	if (retval) {
+		printk(KERN_ERR KBUILD_MODNAME ": start read pipe failed\n");
+		return retval;
+	}
+
+	return 0;
+}
+
+static void zr364xx_stop_readpipe(struct zr364xx_camera *cam)
+{
+	struct zr364xx_pipeinfo *pipe_info;
+
+	if (cam == NULL) {
+		printk(KERN_ERR KBUILD_MODNAME ": invalid device\n");
+		return;
+	}
+	DBG("stop read pipe\n");
+	pipe_info = cam->pipe;
+	if (pipe_info) {
+		if (pipe_info->state != 0) {
+			pipe_info->state = 0;
+			pipe_info->prev_state = 1;
+		}
+
+		if (pipe_info->stream_urb) {
+			/* cancel urb */
+			usb_kill_urb(pipe_info->stream_urb);
+			usb_free_urb(pipe_info->stream_urb);
+			pipe_info->stream_urb = NULL;
+		}
+	}
+	DBG("stop read pipe\n");
+	return;
+}
+
+/* starts acquisition process */
+static int zr364xx_start_acquire(struct zr364xx_camera *cam)
+{
+	int j;
+
+	DBG("start acquire\n");
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
+static inline int zr364xx_stop_acquire(struct zr364xx_camera *cam)
+{
+	cam->b_acquire = 0;
 	return 0;
 }
 
 static int zr364xx_vidioc_streamon(struct file *file, void *priv,
 				   enum v4l2_buf_type type)
 {
-	return 0;
+	struct zr364xx_camera *cam = video_drvdata(file);
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
+		dev_err(&cam->udev->dev, "stream busy\n");
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
+	DBG("%s: %d\n", __func__, res);
+	return res;
 }
 
 static int zr364xx_vidioc_streamoff(struct file *file, void *priv,
 				    enum v4l2_buf_type type)
 {
+	int res;
+	struct zr364xx_camera *cam = video_drvdata(file);
+
+	DBG("%s\n", __func__);
+	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dev_err(&cam->udev->dev, "invalid fh type0\n");
+		return -EINVAL;
+	}
+	if (cam->type != type) {
+		dev_err(&cam->udev->dev, "invalid fh type1\n");
+		return -EINVAL;
+	}
+	zr364xx_stop_acquire(cam);
+	res = videobuf_streamoff(&cam->vb_vidq);
+	if (res < 0)
+		return res;
+	res_free(cam);
 	return 0;
 }
 
@@ -637,28 +1196,19 @@ static int zr364xx_vidioc_streamoff(stru
 static int zr364xx_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct zr364xx_camera *cam = video_get_drvdata(vdev);
+	struct zr364xx_camera *cam = video_drvdata(file);
 	struct usb_device *udev = cam->udev;
 	int i, err;
 
-	DBG("zr364xx_open");
+	DBG("%s\n", __func__);
 
-	mutex_lock(&cam->lock);
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
@@ -674,6 +1224,14 @@ static int zr364xx_open(struct file *fil
 	cam->skip = 2;
 	cam->users++;
 	file->private_data = vdev;
+	cam->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	cam->fmt = formats;
+
+	videobuf_queue_vmalloc_init(&cam->vb_vidq, &zr364xx_video_qops,
+				    NULL, &cam->slock,
+				    cam->type,
+				    V4L2_FIELD_NONE,
+				    sizeof(struct zr364xx_buffer), cam);
 
 	/* Added some delay here, since opening/closing the camera quickly,
 	 * like Ekiga does during its startup, can crash the webcam
@@ -682,28 +1240,70 @@ static int zr364xx_open(struct file *fil
 	err = 0;
 
 out:
-	mutex_unlock(&cam->lock);
+ 	mutex_unlock(&cam->open_lock);
+ 	DBG("%s: %d\n", __func__, err);
 	return err;
 }
 
+static void zr364xx_destroy(struct zr364xx_camera *cam)
+{
+	unsigned long i;
+
+	if (!cam) {
+		printk(KERN_ERR KBUILD_MODNAME ", %s: no device\n", __func__);
+		return;
+	}
+	mutex_lock(&cam->open_lock);
+	if (cam->vdev)
+		video_unregister_device(cam->vdev);
+	cam->vdev = NULL;
+
+	/* stops the read pipe if it is running */
+	if (cam->b_acquire)
+		zr364xx_stop_acquire(cam);
+
+	zr364xx_stop_readpipe(cam);
+
+	/* release sys buffers */
+	for (i = 0; i < FRAMES; i++) {
+		if (cam->buffer.frame[i].lpvbits) {
+			DBG("vfree %p\n", cam->buffer.frame[i].lpvbits);
+			vfree(cam->buffer.frame[i].lpvbits);
+		}
+		cam->buffer.frame[i].lpvbits = NULL;
+	}
+
+	/* release transfer buffer */
+	kfree(cam->pipe->transfer_buffer);
+
+	DBG("%s\n", __func__);
+	mutex_unlock(&cam->open_lock);
+	kfree(cam);
+}
 
 /* release the camera */
 static int zr364xx_release(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam;
 	struct usb_device *udev;
 	int i, err;
 
-	DBG("zr364xx_release");
+ 	DBG("%s\n", __func__);
+ 	cam = video_drvdata(file);
 
-	if (vdev == NULL)
+ 	if (!cam)
 		return -ENODEV;
-	cam = video_get_drvdata(vdev);
 
+ 	mutex_lock(&cam->open_lock);
 	udev = cam->udev;
 
-	mutex_lock(&cam->lock);
+ 	/* turn off stream */
+ 	if (res_check(cam)) {
+ 		if (cam->b_acquire)
+ 			zr364xx_stop_acquire(cam);
+ 		videobuf_streamoff(&cam->vb_vidq);
+ 		res_free(cam);
+ 	}
 
 	cam->users--;
 	file->private_data = NULL;
@@ -726,40 +1326,43 @@ static int zr364xx_release(struct file *
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
-	struct video_device *vdev = video_devdata(file);
-	struct zr364xx_camera *cam;
-
-	DBG("zr364xx_mmap: %ld\n", size);
+	struct zr364xx_camera *cam = video_drvdata(file);
+	int ret;
 
-	if (vdev == NULL)
+	if (cam == NULL) {
+		DBG("%s: cam == NULL\n", __func__);
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
+	struct zr364xx_camera *cam = video_drvdata(file);
+	struct videobuf_queue *q = &cam->vb_vidq;
+	DBG("%s\n", __func__);
+
+	if (cam->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return POLLERR;
+
+	return videobuf_poll_stream(file, q, wait);
+}
 
 static const struct v4l2_file_operations zr364xx_fops = {
 	.owner = THIS_MODULE,
@@ -768,6 +1371,7 @@ static const struct v4l2_file_operations
 	.read = zr364xx_read,
 	.mmap = zr364xx_mmap,
 	.ioctl = video_ioctl2,
+	.poll = zr364xx_poll,
 };
 
 static const struct v4l2_ioctl_ops zr364xx_ioctl_ops = {
@@ -784,6 +1388,10 @@ static const struct v4l2_ioctl_ops zr364
 	.vidioc_queryctrl	= zr364xx_vidioc_queryctrl,
 	.vidioc_g_ctrl		= zr364xx_vidioc_g_ctrl,
 	.vidioc_s_ctrl		= zr364xx_vidioc_s_ctrl,
+	.vidioc_reqbufs         = zr364xx_vidioc_reqbufs,
+	.vidioc_querybuf        = zr364xx_vidioc_querybuf,
+	.vidioc_qbuf            = zr364xx_vidioc_qbuf,
+	.vidioc_dqbuf           = zr364xx_vidioc_dqbuf,
 };
 
 static struct video_device zr364xx_template = {
@@ -799,15 +1407,75 @@ static struct video_device zr364xx_templ
 /*******************/
 /* USB integration */
 /*******************/
+static int zr364xx_board_init(struct zr364xx_camera *cam)
+{
+	struct zr364xx_pipeinfo *pipe = cam->pipe;
+	unsigned long i;
+
+	DBG("board init: %p\n", cam);
+	memset(pipe, 0, sizeof(*pipe));
+	pipe->cam = cam;
+	pipe->transfer_size = BUFFER_SIZE;
+
+	pipe->transfer_buffer = kzalloc(pipe->transfer_size,
+					GFP_KERNEL);
+	if (pipe->transfer_buffer == NULL) {
+		DBG("out of memory!\n");
+		return -ENOMEM;
+	}
+
+	cam->b_acquire = 0;
+	cam->frame_count = 0;
+
+	/*** start create system buffers ***/
+	for (i = 0; i < FRAMES; i++) {
+		/* always allocate maximum size for system buffers */
+		cam->buffer.frame[i].lpvbits = vmalloc(MAX_FRAME_SIZE);
+
+		DBG("valloc %p, idx %lu, pdata %p\n",
+			&cam->buffer.frame[i], i,
+			cam->buffer.frame[i].lpvbits);
+		if (cam->buffer.frame[i].lpvbits == NULL) {
+			printk(KERN_INFO KBUILD_MODNAME ": out of memory. Using less frames\n");
+			break;
+		}
+	}
+
+	if ( i == 0 ) {
+		printk(KERN_INFO KBUILD_MODNAME ": out of memory. Aborting\n");
+		kfree(cam->pipe->transfer_buffer);
+		return -ENOMEM;
+	}
+	else
+		cam->buffer.dwFrames = i;
+
+	/* make sure internal states are set */
+	for (i = 0; i < FRAMES; i++) {
+		cam->buffer.frame[i].ulState = ZR364XX_READ_IDLE;
+		cam->buffer.frame[i].cur_size = 0;
+	}
+
+	cam->cur_frame = 0;
+	cam->last_frame = -1;
+	/*** end create system buffers ***/
+
+	/* start read pipe */
+	zr364xx_start_readpipe(cam);
+	DBG(": board initialized\n");
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
@@ -829,19 +1497,13 @@ static int zr364xx_probe(struct usb_inte
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
@@ -868,21 +1530,48 @@ static int zr364xx_probe(struct usb_inte
 	header2[439] = cam->width / 256;
 	header2[440] = cam->width % 256;
 
+	cam->users = 0;
 	cam->nb = 0;
-	cam->brightness = 64;
+	cam->mode.brightness = 64;
 	mutex_init(&cam->lock);
+	mutex_init(&cam->open_lock);
 
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
+
+	if (!cam->read_endpoint) {
+		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
+		return -ENOMEM;
+	}
+
+	/* v4l */
+	INIT_LIST_HEAD(&cam->vidq.active);
+	cam->vidq.cam = cam;
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
@@ -892,15 +1581,13 @@ static int zr364xx_probe(struct usb_inte
 static void zr364xx_disconnect(struct usb_interface *intf)
 {
 	struct zr364xx_camera *cam = usb_get_intfdata(intf);
+ 	videobuf_mmap_free(&cam->vb_vidq);
 	usb_set_intfdata(intf, NULL);
 	dev_info(&intf->dev, DRIVER_DESC " webcam unplugged\n");
 	if (cam->vdev)
 		video_unregister_device(cam->vdev);
 	cam->vdev = NULL;
-	kfree(cam->buffer);
-	if (cam->framebuf)
-		vfree(cam->framebuf);
-	kfree(cam);
+ 	zr364xx_destroy(cam);
 }
 
 

--Boundary-00=_X1ryJGl4DMvwPVB--
