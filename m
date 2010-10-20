Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44879 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0JTJfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 05:35:24 -0400
Received: by bwz10 with SMTP id 10so1122943bwz.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 02:35:22 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 3/6] Staging: tm6000: fix braces, tabs, comments and space coding style issue in tm6000-video.c
Date: Wed, 20 Oct 2010 12:35:12 +0300
Message-Id: <1287567312-18830-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the tm6000-video.c file that fixed
up a braces, tabs, comments and space Errors and Warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/tm6000/tm6000-video.c |  410 ++++++++++++++++-----------------
 1 files changed, 204 insertions(+), 206 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index ce0a089..53f64be 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1,23 +1,23 @@
 /*
-   tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
-
-   Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
-
-   Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
-	- Fixed module load/unload
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation version 2
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *   tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+ *
+ *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ *  Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
+ *	- Fixed module load/unload
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -118,8 +118,9 @@ static struct tm6000_fmt format[] = {
 };
 
 /* ------------------------------------------------------------------
-	DMA and thread functions
-   ------------------------------------------------------------------*/
+ *	DMA and thread functions
+ * ------------------------------------------------------------------
+ */
 
 #define norm_maxw(a) 720
 #define norm_maxh(a) 576
@@ -189,17 +190,17 @@ static int copy_streams(u8 *data, unsigned long len,
 			struct urb *urb)
 {
 	struct tm6000_dmaqueue  *dma_q = urb->context;
-	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
-	u8 *ptr=data, *endp=data+len, c;
-	unsigned long header=0;
-	int rc=0;
+	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
+	u8 *ptr = data, *endp = data+len, c;
+	unsigned long header = 0;
+	int rc = 0;
 	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
 	struct tm6000_buffer *vbuf;
 	char *voutp = NULL;
 	unsigned int linewidth;
 
 	/* get video buffer */
-	get_next_buf (dma_q, &vbuf);
+	get_next_buf(dma_q, &vbuf);
 	if (!vbuf)
 		return rc;
 	voutp = videobuf_to_vmalloc(&vbuf->vb);
@@ -213,7 +214,7 @@ static int copy_streams(u8 *data, unsigned long len,
 				/* from last urb or packet */
 				header = dev->isoc_ctl.tmp_buf;
 				if (4 - dev->isoc_ctl.tmp_buf_len > 0) {
-					memcpy ((u8 *)&header +
+					memcpy((u8 *)&header +
 						dev->isoc_ctl.tmp_buf_len,
 						ptr,
 						4 - dev->isoc_ctl.tmp_buf_len);
@@ -224,7 +225,7 @@ static int copy_streams(u8 *data, unsigned long len,
 				if (ptr + 3 >= endp) {
 					/* have incomplete header */
 					dev->isoc_ctl.tmp_buf_len = endp - ptr;
-					memcpy (&dev->isoc_ctl.tmp_buf, ptr,
+					memcpy(&dev->isoc_ctl.tmp_buf, ptr,
 						dev->isoc_ctl.tmp_buf_len);
 					return rc;
 				}
@@ -261,13 +262,13 @@ static int copy_streams(u8 *data, unsigned long len,
 					/* Announces that a new buffer
 					 * were filled
 					 */
-					buffer_filled (dev, dma_q, vbuf);
-					dprintk (dev, V4L2_DEBUG_ISOC,
+					buffer_filled(dev, dma_q, vbuf);
+					dprintk(dev, V4L2_DEBUG_ISOC,
 							"new buffer filled\n");
-					get_next_buf (dma_q, &vbuf);
+					get_next_buf(dma_q, &vbuf);
 					if (!vbuf)
 						return rc;
-					voutp = videobuf_to_vmalloc (&vbuf->vb);
+					voutp = videobuf_to_vmalloc(&vbuf->vb);
 					if (!voutp)
 						return rc;
 					memset(voutp, 0, vbuf->vb.size);
@@ -301,7 +302,7 @@ static int copy_streams(u8 *data, unsigned long len,
 			case TM6000_URB_MSG_VIDEO:
 				/* Fills video buffer */
 				if (vbuf)
-					memcpy (&voutp[pos], ptr, cpysize);
+					memcpy(&voutp[pos], ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_AUDIO:
 				tm6000_call_fillbuf(dev, TM6000_AUDIO, ptr, cpysize);
@@ -338,9 +339,9 @@ static int copy_multiplexed(u8 *ptr, unsigned long len,
 			struct urb *urb)
 {
 	struct tm6000_dmaqueue  *dma_q = urb->context;
-	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
-	unsigned int pos=dev->isoc_ctl.pos,cpysize;
-	int rc=1;
+	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
+	unsigned int pos = dev->isoc_ctl.pos, cpysize;
+	int rc = 1;
 	struct tm6000_buffer *buf;
 	char *outp = NULL;
 
@@ -351,19 +352,18 @@ static int copy_multiplexed(u8 *ptr, unsigned long len,
 	if (!outp)
 		return 0;
 
-	while (len>0) {
-		cpysize=min(len,buf->vb.size-pos);
-		//printk("Copying %d bytes (max=%lu) from %p to %p[%u]\n",cpysize,(*buf)->vb.size,ptr,out_p,pos);
+	while (len > 0) {
+		cpysize = min(len, buf->vb.size-pos);
 		memcpy(&outp[pos], ptr, cpysize);
-		pos+=cpysize;
-		ptr+=cpysize;
-		len-=cpysize;
+		pos += cpysize;
+		ptr += cpysize;
+		len -= cpysize;
 		if (pos >= buf->vb.size) {
-			pos=0;
+			pos = 0;
 			/* Announces that a new buffer were filled */
-			buffer_filled (dev, dma_q, buf);
+			buffer_filled(dev, dma_q, buf);
 			dprintk(dev, V4L2_DEBUG_ISOC, "new buffer filled\n");
-			get_next_buf (dma_q, &buf);
+			get_next_buf(dma_q, &buf);
 			if (!buf)
 				break;
 			outp = videobuf_to_vmalloc(&(buf->vb));
@@ -373,16 +373,16 @@ static int copy_multiplexed(u8 *ptr, unsigned long len,
 		}
 	}
 
-	dev->isoc_ctl.pos=pos;
+	dev->isoc_ctl.pos = pos;
 	return rc;
 }
 
-static void inline print_err_status (struct tm6000_core *dev,
+static inline void print_err_status(struct tm6000_core *dev,
 				     int packet, int status)
 {
 	char *errmsg = "Unknown";
 
-	switch(status) {
+	switch (status) {
 	case -ENOENT:
 		errmsg = "unlinked synchronuously";
 		break;
@@ -408,7 +408,7 @@ static void inline print_err_status (struct tm6000_core *dev,
 		errmsg = "Device does not respond";
 		break;
 	}
-	if (packet<0) {
+	if (packet < 0) {
 		dprintk(dev, V4L2_DEBUG_QUEUE, "URB status %d [%s].\n",
 			status, errmsg);
 	} else {
@@ -424,20 +424,20 @@ static void inline print_err_status (struct tm6000_core *dev,
 static inline int tm6000_isoc_copy(struct urb *urb)
 {
 	struct tm6000_dmaqueue  *dma_q = urb->context;
-	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
-	int i, len=0, rc=1, status;
+	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
+	int i, len = 0, rc = 1, status;
 	char *p;
 
 	if (urb->status < 0) {
-		print_err_status (dev, -1, urb->status);
+		print_err_status(dev, -1, urb->status);
 		return 0;
 	}
 
 	for (i = 0; i < urb->number_of_packets; i++) {
 		status = urb->iso_frame_desc[i].status;
 
-		if (status<0) {
-			print_err_status (dev,i,status);
+		if (status < 0) {
+			print_err_status(dev, i, status);
 			continue;
 		}
 
@@ -446,9 +446,9 @@ static inline int tm6000_isoc_copy(struct urb *urb)
 		if (len > 0) {
 			p = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 			if (!urb->iso_frame_desc[i].status) {
-				if ((dev->fourcc)==V4L2_PIX_FMT_TM6000) {
-					rc=copy_multiplexed(p, len, urb);
-					if (rc<=0)
+				if ((dev->fourcc) == V4L2_PIX_FMT_TM6000) {
+					rc = copy_multiplexed(p, len, urb);
+					if (rc <= 0)
 						return rc;
 				} else {
 					copy_streams(p, len, urb);
@@ -460,8 +460,9 @@ static inline int tm6000_isoc_copy(struct urb *urb)
 }
 
 /* ------------------------------------------------------------------
-	URB control
-   ------------------------------------------------------------------*/
+ *	URB control
+ * ------------------------------------------------------------------
+ */
 
 /*
  * IRQ callback, called by URB callback
@@ -501,7 +502,7 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
 
 	dev->isoc_ctl.buf = NULL;
 	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
-		urb=dev->isoc_ctl.urb[i];
+		urb = dev->isoc_ctl.urb[i];
 		if (urb) {
 			usb_kill_urb(urb);
 			usb_unlink_urb(urb);
@@ -517,11 +518,11 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
 		dev->isoc_ctl.transfer_buffer[i] = NULL;
 	}
 
-	kfree (dev->isoc_ctl.urb);
-	kfree (dev->isoc_ctl.transfer_buffer);
+	kfree(dev->isoc_ctl.urb);
+	kfree(dev->isoc_ctl.transfer_buffer);
 
-	dev->isoc_ctl.urb=NULL;
-	dev->isoc_ctl.transfer_buffer=NULL;
+	dev->isoc_ctl.urb = NULL;
+	dev->isoc_ctl.transfer_buffer = NULL;
 	dev->isoc_ctl.num_bufs = 0;
 }
 
@@ -552,7 +553,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 
 	dev->isoc_ctl.max_pkt_size = size;
 
-	max_packets = ( framesize + size - 1) / size;
+	max_packets = (framesize + size - 1) / size;
 
 	if (max_packets > TM6000_MAX_ISO_PACKETS)
 		max_packets = TM6000_MAX_ISO_PACKETS;
@@ -594,10 +595,10 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
-			tm6000_err ("unable to allocate %i bytes for transfer"
+			tm6000_err("unable to allocate %i bytes for transfer"
 					" buffer %i%s\n",
 					sb_size, i,
-					in_interrupt()?" while in int":"");
+					in_interrupt() ? " while in int" : "");
 			tm6000_uninit_isoc(dev);
 			return -ENOMEM;
 		}
@@ -619,13 +620,13 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 	return 0;
 }
 
-static int tm6000_start_thread( struct tm6000_core *dev)
+static int tm6000_start_thread(struct tm6000_core *dev)
 {
 	struct tm6000_dmaqueue *dma_q = &dev->vidq;
 	int i;
 
-	dma_q->frame=0;
-	dma_q->ini_jiffies=jiffies;
+	dma_q->frame = 0;
+	dma_q->ini_jiffies = jiffies;
 
 	init_waitqueue_head(&dma_q->wq);
 
@@ -644,8 +645,9 @@ static int tm6000_start_thread( struct tm6000_core *dev)
 }
 
 /* ------------------------------------------------------------------
-	Videobuf operations
-   ------------------------------------------------------------------*/
+ *	Videobuf operations
+ * ------------------------------------------------------------------
+ */
 
 static int
 buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
@@ -656,9 +658,8 @@ buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
 	if (0 == *count)
 		*count = TM6000_DEF_BUF;
 
-	if (*count < TM6000_MIN_BUF) {
-		*count=TM6000_MIN_BUF;
-	}
+	if (*count < TM6000_MIN_BUF)
+		*count = TM6000_MIN_BUF;
 
 	while (*size * *count > vid_limit * 1024 * 1024)
 		(*count)--;
@@ -698,7 +699,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 						enum v4l2_field field)
 {
 	struct tm6000_fh     *fh  = vq->priv_data;
-	struct tm6000_buffer *buf = container_of(vb,struct tm6000_buffer,vb);
+	struct tm6000_buffer *buf = container_of(vb, struct tm6000_buffer, vb);
 	struct tm6000_core   *dev = fh->dev;
 	int rc = 0, urb_init = 0;
 
@@ -753,7 +754,7 @@ fail:
 static void
 buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
-	struct tm6000_buffer    *buf     = container_of(vb,struct tm6000_buffer,vb);
+	struct tm6000_buffer    *buf     = container_of(vb, struct tm6000_buffer, vb);
 	struct tm6000_fh        *fh      = vq->priv_data;
 	struct tm6000_core      *dev     = fh->dev;
 	struct tm6000_dmaqueue  *vidq    = &dev->vidq;
@@ -764,9 +765,9 @@ buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 static void buffer_release(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
-	struct tm6000_buffer   *buf  = container_of(vb,struct tm6000_buffer,vb);
+	struct tm6000_buffer   *buf  = container_of(vb, struct tm6000_buffer, vb);
 
-	free_buffer(vq,buf);
+	free_buffer(vq, buf);
 }
 
 static struct videobuf_queue_ops tm6000_video_qops = {
@@ -777,8 +778,9 @@ static struct videobuf_queue_ops tm6000_video_qops = {
 };
 
 /* ------------------------------------------------------------------
-	IOCTL handling
-   ------------------------------------------------------------------*/
+ *	IOCTL handling
+ * ------------------------------------------------------------------
+ */
 
 static int res_get(struct tm6000_core *dev, struct tm6000_fh *fh)
 {
@@ -790,7 +792,7 @@ static int res_get(struct tm6000_core *dev, struct tm6000_fh *fh)
 		return 0;
 	}
 	/* it's free, grab it */
-	dev->resources =1;
+	dev->resources = 1;
 	dprintk(dev, V4L2_DEBUG_RES_LOCK, "res: get\n");
 	mutex_unlock(&dev->lock);
 	return 1;
@@ -798,7 +800,7 @@ static int res_get(struct tm6000_core *dev, struct tm6000_fh *fh)
 
 static int res_locked(struct tm6000_core *dev)
 {
-	return (dev->resources);
+	return dev->resources;
 }
 
 static void res_free(struct tm6000_core *dev, struct tm6000_fh *fh)
@@ -810,16 +812,15 @@ static void res_free(struct tm6000_core *dev, struct tm6000_fh *fh)
 }
 
 /* ------------------------------------------------------------------
-	IOCTL vidioc handling
-   ------------------------------------------------------------------*/
-static int vidioc_querycap (struct file *file, void  *priv,
+ *	IOCTL vidioc handling
+ * ------------------------------------------------------------------
+ */
+static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	//	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
 
 	strlcpy(cap->driver, "tm6000", sizeof(cap->driver));
-	strlcpy(cap->card,"Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
-	//	strlcpy(cap->bus_info, dev->udev->dev.bus_id, sizeof(cap->bus_info));
+	strlcpy(cap->card, "Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
 	cap->version = TM6000_VERSION;
 	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
@@ -828,21 +829,21 @@ static int vidioc_querycap (struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
+static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
 	if (unlikely(f->index >= ARRAY_SIZE(format)))
 		return -EINVAL;
 
-	strlcpy(f->description,format[f->index].name,sizeof(f->description));
+	strlcpy(f->description, format[f->index].name, sizeof(f->description));
 	f->pixelformat = format[f->index].fourcc;
 	return 0;
 }
 
-static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 
 	f->fmt.pix.width        = fh->width;
 	f->fmt.pix.height       = fh->height;
@@ -853,10 +854,10 @@ static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
 
-	return (0);
+	return 0;
 }
 
-static struct tm6000_fmt* format_by_fourcc(unsigned int fourcc)
+static struct tm6000_fmt *format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -866,7 +867,7 @@ static struct tm6000_fmt* format_by_fourcc(unsigned int fourcc)
 	return NULL;
 }
 
-static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
 	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
@@ -882,15 +883,14 @@ static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
 
 	field = f->fmt.pix.field;
 
-	if (field == V4L2_FIELD_ANY) {
-//		field=V4L2_FIELD_INTERLACED;
-		field=V4L2_FIELD_SEQ_TB;
-	} else if (V4L2_FIELD_INTERLACED != field) {
+	if (field == V4L2_FIELD_ANY)
+		field = V4L2_FIELD_SEQ_TB;
+	else if (V4L2_FIELD_INTERLACED != field) {
 		dprintk(dev, V4L2_DEBUG_IOCTL_ARG, "Field type invalid.\n");
 		return -EINVAL;
 	}
 
-	tm6000_get_std_res (dev);
+	tm6000_get_std_res(dev);
 
 	f->fmt.pix.width  = dev->width;
 	f->fmt.pix.height = dev->height;
@@ -908,14 +908,14 @@ static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
 }
 
 /*FIXME: This seems to be generic enough to be at videodev2 */
-static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 	struct tm6000_core *dev = fh->dev;
-	int ret = vidioc_try_fmt_vid_cap(file,fh,f);
+	int ret = vidioc_try_fmt_vid_cap(file, fh, f);
 	if (ret < 0)
-		return (ret);
+		return ret;
 
 	fh->fmt           = format_by_fourcc(f->fmt.pix.pixelformat);
 	fh->width         = f->fmt.pix.width;
@@ -927,52 +927,52 @@ static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
 
 	tm6000_set_fourcc_format(dev);
 
-	return (0);
+	return 0;
 }
 
-static int vidioc_reqbufs (struct file *file, void *priv,
+static int vidioc_reqbufs(struct file *file, void *priv,
 			   struct v4l2_requestbuffers *p)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 
-	return (videobuf_reqbufs(&fh->vb_vidq, p));
+	return videobuf_reqbufs(&fh->vb_vidq, p);
 }
 
-static int vidioc_querybuf (struct file *file, void *priv,
+static int vidioc_querybuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 
-	return (videobuf_querybuf(&fh->vb_vidq, p));
+	return videobuf_querybuf(&fh->vb_vidq, p);
 }
 
-static int vidioc_qbuf (struct file *file, void *priv, struct v4l2_buffer *p)
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 
-	return (videobuf_qbuf(&fh->vb_vidq, p));
+	return videobuf_qbuf(&fh->vb_vidq, p);
 }
 
-static int vidioc_dqbuf (struct file *file, void *priv, struct v4l2_buffer *p)
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 
-	return (videobuf_dqbuf(&fh->vb_vidq, p,
-				file->f_flags & O_NONBLOCK));
+	return videobuf_dqbuf(&fh->vb_vidq, p,
+				file->f_flags & O_NONBLOCK);
 }
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
-static int vidiocgmbuf (struct file *file, void *priv, struct video_mbuf *mbuf)
+static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 
-	return videobuf_cgmbuf (&fh->vb_vidq, mbuf, 8);
+	return videobuf_cgmbuf(&fh->vb_vidq, mbuf, 8);
 }
 #endif
 
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 	struct tm6000_core *dev    = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -980,14 +980,14 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	if (i != fh->type)
 		return -EINVAL;
 
-	if (!res_get(dev,fh))
+	if (!res_get(dev, fh))
 		return -EBUSY;
-	return (videobuf_streamon(&fh->vb_vidq));
+	return videobuf_streamon(&fh->vb_vidq);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 	struct tm6000_core *dev    = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -996,23 +996,23 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 		return -EINVAL;
 
 	videobuf_streamoff(&fh->vb_vidq);
-	res_free(dev,fh);
+	res_free(dev, fh);
 
-	return (0);
+	return 0;
 }
 
-static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	int rc=0;
-	struct tm6000_fh   *fh=priv;
+	int rc = 0;
+	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	rc=tm6000_set_standard (dev, norm);
+	rc = tm6000_set_standard(dev, norm);
 
 	fh->width  = dev->width;
 	fh->height = dev->height;
 
-	if (rc<0)
+	if (rc < 0)
 		return rc;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -1020,21 +1020,21 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
-static int vidioc_enum_input (struct file *file, void *priv,
+static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
 {
 	switch (inp->index) {
 	case TM6000_INPUT_TV:
 		inp->type = V4L2_INPUT_TYPE_TUNER;
-		strcpy(inp->name,"Television");
+		strcpy(inp->name, "Television");
 		break;
 	case TM6000_INPUT_COMPOSITE:
 		inp->type = V4L2_INPUT_TYPE_CAMERA;
-		strcpy(inp->name,"Composite");
+		strcpy(inp->name, "Composite");
 		break;
 	case TM6000_INPUT_SVIDEO:
 		inp->type = V4L2_INPUT_TYPE_CAMERA;
-		strcpy(inp->name,"S-Video");
+		strcpy(inp->name, "S-Video");
 		break;
 	default:
 		return -EINVAL;
@@ -1044,48 +1044,48 @@ static int vidioc_enum_input (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct tm6000_fh   *fh=priv;
+	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
 
-	*i=dev->input;
+	*i = dev->input;
 
 	return 0;
 }
-static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct tm6000_fh   *fh=priv;
+	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
-	int rc=0;
+	int rc = 0;
 	char buf[1];
 
 	switch (i) {
 	case TM6000_INPUT_TV:
-		dev->input=i;
-		*buf=0;
+		dev->input = i;
+		*buf = 0;
 		break;
 	case TM6000_INPUT_COMPOSITE:
 	case TM6000_INPUT_SVIDEO:
-		dev->input=i;
-		*buf=1;
+		dev->input = i;
+		*buf = 1;
 		break;
 	default:
 		return -EINVAL;
 	}
-	rc=tm6000_read_write_usb (dev, USB_DIR_OUT | USB_TYPE_VENDOR,
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
 			       REQ_03_SET_GET_MCU_PIN, 0x03, 1, buf, 1);
 
 	if (!rc) {
-		dev->input=i;
-		rc=vidioc_s_std (file, priv, &dev->vfd->current_norm);
+		dev->input = i;
+		rc = vidioc_s_std(file, priv, &dev->vfd->current_norm);
 	}
 
-	return (rc);
+	return rc;
 }
 
 	/* --- controls ---------------------------------------------- */
-static int vidioc_queryctrl (struct file *file, void *priv,
+static int vidioc_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qc)
 {
 	int i;
@@ -1094,16 +1094,16 @@ static int vidioc_queryctrl (struct file *file, void *priv,
 		if (qc->id && qc->id == tm6000_qctrl[i].id) {
 			memcpy(qc, &(tm6000_qctrl[i]),
 				sizeof(*qc));
-			return (0);
+			return 0;
 		}
 
 	return -EINVAL;
 }
 
-static int vidioc_g_ctrl (struct file *file, void *priv,
+static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct tm6000_fh  *fh=priv;
+	struct tm6000_fh  *fh = priv;
 	struct tm6000_core *dev    = fh->dev;
 	int  val;
 
@@ -1125,41 +1125,41 @@ static int vidioc_g_ctrl (struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (val<0)
+	if (val < 0)
 		return val;
 
-	ctrl->value=val;
+	ctrl->value = val;
 
 	return 0;
 }
-static int vidioc_s_ctrl (struct file *file, void *priv,
+static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct tm6000_fh   *fh  =priv;
+	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
-	u8  val=ctrl->value;
+	u8  val = ctrl->value;
 
 	switch (ctrl->id) {
 	case V4L2_CID_CONTRAST:
-  tm6000_set_reg(dev, TM6010_REQ07_R08_LUMA_CONTRAST_ADJ, val);
+		tm6000_set_reg(dev, TM6010_REQ07_R08_LUMA_CONTRAST_ADJ, val);
 		return 0;
 	case V4L2_CID_BRIGHTNESS:
-  tm6000_set_reg(dev, TM6010_REQ07_R09_LUMA_BRIGHTNESS_ADJ, val);
+		tm6000_set_reg(dev, TM6010_REQ07_R09_LUMA_BRIGHTNESS_ADJ, val);
 		return 0;
 	case V4L2_CID_SATURATION:
-  tm6000_set_reg(dev, TM6010_REQ07_R0A_CHROMA_SATURATION_ADJ, val);
+		tm6000_set_reg(dev, TM6010_REQ07_R0A_CHROMA_SATURATION_ADJ, val);
 		return 0;
 	case V4L2_CID_HUE:
-  tm6000_set_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, val);
+		tm6000_set_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, val);
 		return 0;
 	}
 	return -EINVAL;
 }
 
-static int vidioc_g_tuner (struct file *file, void *priv,
+static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct tm6000_fh   *fh  =priv;
+	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	if (unlikely(UNSET == dev->tuner_type))
@@ -1176,10 +1176,10 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_tuner (struct file *file, void *priv,
+static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct tm6000_fh   *fh  =priv;
+	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	if (UNSET == dev->tuner_type)
@@ -1190,10 +1190,10 @@ static int vidioc_s_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_frequency (struct file *file, void *priv,
+static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct tm6000_fh   *fh  =priv;
+	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	if (unlikely(UNSET == dev->tuner_type))
@@ -1207,10 +1207,10 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_frequency (struct file *file, void *priv,
+static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct tm6000_fh   *fh  =priv;
+	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
 
 	if (unlikely(f->type != V4L2_TUNER_ANALOG_TV))
@@ -1221,17 +1221,15 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
 
-//	mutex_lock(&dev->lock);
 	dev->freq = f->frequency;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
-//	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
 /* ------------------------------------------------------------------
-	File operations for the device
-   ------------------------------------------------------------------*/
+ *	File operations for the device
+ * ------------------------------------------------------------------
+ */
 
 static int tm6000_open(struct file *file)
 {
@@ -1239,7 +1237,7 @@ static int tm6000_open(struct file *file)
 	struct tm6000_core *dev = video_drvdata(file);
 	struct tm6000_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	int i,rc;
+	int i, rc;
 
 	printk(KERN_INFO "tm6000: open called (dev=%s)\n",
 		video_device_node_name(vdev));
@@ -1256,7 +1254,7 @@ static int tm6000_open(struct file *file)
 		dev->users);
 
 	/* allocate + initialize per filehandle data */
-	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh) {
 		dev->users--;
 		return -ENOMEM;
@@ -1270,37 +1268,37 @@ static int tm6000_open(struct file *file)
 
 	fh->fmt      = format_by_fourcc(dev->fourcc);
 
-	tm6000_get_std_res (dev);
+	tm6000_get_std_res(dev);
 
 	fh->width    = dev->width;
 	fh->height   = dev->height;
 
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, "
 						"dev->vidq=0x%08lx\n",
-		(unsigned long)fh,(unsigned long)dev,(unsigned long)&dev->vidq);
+		(unsigned long)fh, (unsigned long)dev, (unsigned long)&dev->vidq);
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"queued=%d\n",list_empty(&dev->vidq.queued));
+				"queued=%d\n", list_empty(&dev->vidq.queued));
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty "
-				"active=%d\n",list_empty(&dev->vidq.active));
+				"active=%d\n", list_empty(&dev->vidq.active));
 
 	/* initialize hardware on analog mode */
-	if (dev->mode!=TM6000_MODE_ANALOG) {
-		rc=tm6000_init_analog_mode (dev);
-		if (rc<0)
+	if (dev->mode != TM6000_MODE_ANALOG) {
+		rc = tm6000_init_analog_mode(dev);
+		if (rc < 0)
 			return rc;
 
 		/* Put all controls at a sane state */
 		for (i = 0; i < ARRAY_SIZE(tm6000_qctrl); i++)
-			qctl_regs[i] =tm6000_qctrl[i].default_value;
+			qctl_regs[i] = tm6000_qctrl[i].default_value;
 
-		dev->mode=TM6000_MODE_ANALOG;
+		dev->mode = TM6000_MODE_ANALOG;
 	}
 
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &tm6000_video_qops,
 			NULL, &dev->slock,
 			fh->type,
 			V4L2_FIELD_INTERLACED,
-			sizeof(struct tm6000_buffer),fh);
+			sizeof(struct tm6000_buffer), fh);
 
 	return 0;
 }
@@ -1310,7 +1308,7 @@ tm6000_read(struct file *file, char __user *data, size_t count, loff_t *pos)
 {
 	struct tm6000_fh        *fh = file->private_data;
 
-	if (fh->type==V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		if (res_locked(fh->dev))
 			return -EBUSY;
 
@@ -1329,11 +1327,11 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
 
-	if (res_get(fh->dev,fh)) {
+	if (res_get(fh->dev, fh)) {
 		/* streaming capture */
 		if (list_empty(&fh->vb_vidq.stream))
 			return POLLERR;
-		buf = list_entry(fh->vb_vidq.stream.next,struct tm6000_buffer,vb.stream);
+		buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
 	} else {
 		/* read() capture */
 		return videobuf_poll_stream(file, &fh->vb_vidq,
@@ -1342,7 +1340,7 @@ tm6000_poll(struct file *file, struct poll_table_struct *wait)
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		return POLLIN|POLLRDNORM;
+		return POLLIN | POLLRDNORM;
 	return 0;
 }
 
@@ -1362,7 +1360,7 @@ static int tm6000_release(struct file *file)
 		videobuf_mmap_free(&fh->vb_vidq);
 	}
 
-	kfree (fh);
+	kfree(fh);
 
 	return 0;
 }
@@ -1372,7 +1370,7 @@ static int tm6000_mmap(struct file *file, struct vm_area_struct * vma)
 	struct tm6000_fh        *fh = file->private_data;
 	int ret;
 
-	ret=videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
 
 	return ret;
 }
@@ -1425,8 +1423,9 @@ static struct video_device tm6000_template = {
 };
 
 /* -----------------------------------------------------------------
-	Initialization and module stuff
-   ------------------------------------------------------------------*/
+ *	Initialization and module stuff
+ * ------------------------------------------------------------------
+ */
 
 int tm6000_v4l2_register(struct tm6000_core *dev)
 {
@@ -1434,17 +1433,16 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	struct video_device *vfd;
 
 	vfd = video_device_alloc();
-	if(!vfd) {
+	if (!vfd)
 		return -ENOMEM;
-	}
 	dev->vfd = vfd;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vidq.queued);
 
-	memcpy (dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
-	dev->vfd->debug=tm6000_debug;
+	memcpy(dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
+	dev->vfd->debug = tm6000_debug;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	video_set_drvdata(vfd, dev);
 
@@ -1466,11 +1464,11 @@ int tm6000_v4l2_exit(void)
 }
 
 module_param(video_nr, int, 0);
-MODULE_PARM_DESC(video_nr,"Allow changing video device number");
+MODULE_PARM_DESC(video_nr, "Allow changing video device number");
 
-module_param_named (debug, tm6000_debug, int, 0444);
-MODULE_PARM_DESC(debug,"activates debug info");
+module_param_named(debug, tm6000_debug, int, 0444);
+MODULE_PARM_DESC(debug, "activates debug info");
 
-module_param(vid_limit,int,0644);
-MODULE_PARM_DESC(vid_limit,"capture memory limit in megabytes");
+module_param(vid_limit, int, 0644);
+MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 
-- 
1.7.0.4

