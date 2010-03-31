Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([69.93.179.29]:54154 "HELO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755091Ab0CaRgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 13:36:51 -0400
Date: Wed, 31 Mar 2010 10:36:47 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: cleanup of debug messages
To: linux-media@vger.kernel.org
Message-ID: <tkrat.122b40d925ca6c2a@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1270056198 25200
# Node ID db81e2f83909ee79dcca8496ceeda2653775e60a
# Parent  0690e4e1d81e785af1a5f06a13573dcf2cc5cb0c
s2255drv: cleanup of debug messages

From: Dean Anderson <dean@sensoray.com>

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r 0690e4e1d81e -r db81e2f83909 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Wed Mar 31 09:30:44 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Wed Mar 31 10:23:18 2010 -0700
@@ -57,10 +57,14 @@
 #include <linux/usb.h>
 #include "compat.h"
 
+#define S2255_MAJOR_VERSION	1
+#define S2255_MINOR_VERSION	19
+#define S2255_RELEASE		0
+#define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
+					       S2255_MINOR_VERSION, \
+					       S2255_RELEASE)
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
 
-
-
 /* default JPEG quality */
 #define S2255_DEF_JPEG_QUAL     50
 /* vendor request in */
@@ -310,13 +314,6 @@
 /* Need DSP version 5+ for video status feature */
 #define S2255_MIN_DSP_STATUS      5
 #define S2255_MIN_DSP_COLORFILTER 8
-#define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	18
-#define S2255_RELEASE		0
-#define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
-					       S2255_MINOR_VERSION, \
-					       S2255_RELEASE)
-
 #define S2255_NORMS		(V4L2_STD_PAL | V4L2_STD_NTSC)
 
 /* private V4L2 controls */
@@ -503,7 +500,7 @@
 static void s2255_timer(unsigned long user_data)
 {
 	struct s2255_fw *data = (struct s2255_fw *)user_data;
-	dprintk(100, "s2255 timer\n");
+	dprintk(100, "%s\n", __func__);
 	if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
 		printk(KERN_ERR "s2255: can't submit urb\n");
 		atomic_set(&data->fw_state, S2255_FW_FAILED);
@@ -525,7 +522,7 @@
 	struct s2255_fw *data = urb->context;
 	struct usb_device *udev = urb->dev;
 	int len;
-	dprintk(100, "udev %p urb %p", udev, urb);
+	dprintk(100, "%s: udev %p urb %p", __func__, udev, urb);
 	if (urb->status) {
 		dev_err(&udev->dev, "URB failed with status %d\n", urb->status);
 		atomic_set(&data->fw_state, S2255_FW_FAILED);
@@ -571,8 +568,8 @@
 		data->fw_loaded += len;
 	} else {
 		atomic_set(&data->fw_state, S2255_FW_LOADED_DSPWAIT);
+		dprintk(100, "%s: firmware upload complete\n", __func__);
 	}
-	dprintk(100, "2255 complete done\n");
 	return;
 
 }
@@ -583,9 +580,7 @@
 	struct s2255_buffer *buf;
 	unsigned long flags = 0;
 	int rc = 0;
-	dprintk(2, "wakeup: %p channel: %d\n", &dma_q, chn);
 	spin_lock_irqsave(&dev->slock, flags);
-
 	if (list_empty(&dma_q->active)) {
 		dprintk(1, "No active queue to serve\n");
 		rc = -1;
@@ -593,13 +588,11 @@
 	}
 	buf = list_entry(dma_q->active.next,
 			 struct s2255_buffer, vb.queue);
-
 	list_del(&buf->vb.queue);
 	do_gettimeofday(&buf->vb.ts);
-	dprintk(100, "[%p/%d] wakeup\n", buf, buf->vb.i);
 	s2255_fillbuff(dev, buf, dma_q->channel, jpgsize);
 	wake_up(&buf->vb.done);
-	dprintk(2, "wakeup [buf/i] [%p/%d]\n", buf, buf->vb.i);
+	dprintk(2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
 unlock:
 	spin_unlock_irqrestore(&dev->slock, flags);
 	return 0;
@@ -608,7 +601,6 @@
 static const struct s2255_fmt *format_by_fourcc(int fourcc)
 {
 	unsigned int i;
-
 	for (i = 0; i < ARRAY_SIZE(formats); i++) {
 		if (-1 == formats[i].fourcc)
 			continue;
@@ -741,7 +733,6 @@
 	buf->vb.height = fh->height;
 	buf->vb.field = field;
 
-
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
 		rc = videobuf_iolock(vq, &buf->vb, NULL);
 		if (rc < 0)
@@ -761,9 +752,7 @@
 	struct s2255_fh *fh = vq->priv_data;
 	struct s2255_dev *dev = fh->dev;
 	struct s2255_dmaqueue *vidq = &dev->vidq[fh->channel];
-
 	dprintk(1, "%s\n", __func__);
-
 	buf->vb.state = VIDEOBUF_QUEUED;
 	list_add_tail(&buf->vb.queue, &vidq->active);
 }
@@ -909,10 +898,8 @@
 	if (field == V4L2_FIELD_ANY)
 		b_any_field = 1;
 
-	dprintk(4, "try format %d \n", is_ntsc);
-	/* supports 3 sizes. see s2255drv.h */
-	dprintk(50, "width test %d, height %d\n",
-		f->fmt.pix.width, f->fmt.pix.height);
+	dprintk(50, "%s NTSC: %d suggested width: %d, height: %d\n",
+		__func__, is_ntsc, f->fmt.pix.width, f->fmt.pix.height);
 	if (is_ntsc) {
 		/* NTSC */
 		if (f->fmt.pix.height >= NUM_LINES_1CIFS_NTSC * 2) {
@@ -967,29 +954,24 @@
 			}
 		}
 		if (f->fmt.pix.width >= LINE_SZ_4CIFS_PAL) {
-			dprintk(50, "pal 704\n");
 			f->fmt.pix.width = LINE_SZ_4CIFS_PAL;
 			field = V4L2_FIELD_SEQ_TB;
 		} else if (f->fmt.pix.width >= LINE_SZ_2CIFS_PAL) {
-			dprintk(50, "pal 352A\n");
 			f->fmt.pix.width = LINE_SZ_2CIFS_PAL;
 			field = V4L2_FIELD_TOP;
 		} else if (f->fmt.pix.width >= LINE_SZ_1CIFS_PAL) {
-			dprintk(50, "pal 352B\n");
 			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
 			field = V4L2_FIELD_TOP;
 		} else {
-			dprintk(50, "pal 352C\n");
 			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
 			field = V4L2_FIELD_TOP;
 		}
 	}
-
-	dprintk(50, "width %d height %d field %d \n", f->fmt.pix.width,
-		f->fmt.pix.height, f->fmt.pix.field);
 	f->fmt.pix.field = field;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	dprintk(50, "%s: set width %d height %d field %d\n", __func__,
+		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	return 0;
 }
 
@@ -1021,7 +1003,7 @@
 	}
 
 	if (res_locked(fh->dev, fh)) {
-		dprintk(1, "can't change format after started\n");
+		dprintk(1, "%s: channel busy\n", __func__);
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
@@ -1035,13 +1017,10 @@
 	if (fh->width > norm_minw(&fh->dev->vdev[fh->channel])) {
 		if (fh->height > norm_minh(&fh->dev->vdev[fh->channel])) {
 			if (fh->dev->cap_parm[fh->channel].capturemode &
-			    V4L2_MODE_HIGHQUALITY) {
+			    V4L2_MODE_HIGHQUALITY)
 				fh->mode.scale = SCALE_4CIFSI;
-				dprintk(2, "scale 4CIFSI\n");
-			} else {
+			else
 				fh->mode.scale = SCALE_4CIFS;
-				dprintk(2, "scale 4CIFS\n");
-			}
 		} else
 			fh->mode.scale = SCALE_2CIFS;
 
@@ -1197,19 +1176,13 @@
 	return usbInSize;
 }
 
-static void dump_verify_mode(struct s2255_dev *sdev, struct s2255_mode *mode)
+static void s2255_print_cfg(struct s2255_dev *sdev, struct s2255_mode *mode)
 {
 	struct device *dev = &sdev->udev->dev;
 	dev_info(dev, "------------------------------------------------\n");
-	dev_info(dev, "verify mode\n");
-	dev_info(dev, "format: %d\n", mode->format);
-	dev_info(dev, "scale: %d\n", mode->scale);
-	dev_info(dev, "fdec: %d\n", mode->fdec);
-	dev_info(dev, "color: %d\n", mode->color);
+	dev_info(dev, "format: %d\nscale %d\n", mode->format, mode->scale);
+	dev_info(dev, "fdec: %d\ncolor %d\n", mode->fdec, mode->color);
 	dev_info(dev, "bright: 0x%x\n", mode->bright);
-	dev_info(dev, "restart: 0x%x\n", mode->restart);
-	dev_info(dev, "usb_block: 0x%x\n", mode->usb_block);
-	dev_info(dev, "single: 0x%x\n", mode->single);
 	dev_info(dev, "------------------------------------------------\n");
 }
 
@@ -1229,11 +1202,7 @@
 	unsigned long chn_rev;
 	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
-	dprintk(3, "mode scale [%ld] %p %d\n", chn, mode, mode->scale);
-	dprintk(3, "mode scale [%ld] %p %d\n", chn, &dev->mode[chn],
-		dev->mode[chn].scale);
-	dprintk(2, "mode contrast %x\n", mode->contrast);
-
+	dprintk(3, "%s channel %lu\n", __func__, chn);
 	/* if JPEG, set the quality */
 	if ((mode->color & MASK_COLOR) == COLOR_JPG) {
 		mode->color &= ~MASK_COLOR;
@@ -1241,19 +1210,16 @@
 		mode->color &= ~MASK_JPG_QUALITY;
 		mode->color |= (dev->jc[chn].quality << 8);
 	}
-
 	/* save the mode */
 	dev->mode[chn] = *mode;
 	dev->req_image_size[chn] = get_transfer_size(mode);
-	dprintk(1, "transfer size %ld\n", dev->req_image_size[chn]);
-
+	dprintk(1, "%s: reqsize %ld\n", __func__, dev->req_image_size[chn]);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
 		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
-
 	/* set the mode */
 	buffer[0] = IN_DATA_TOKEN;
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
@@ -1262,10 +1228,8 @@
 	dev->setmode_ready[chn] = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
-		dump_verify_mode(dev, mode);
+		s2255_print_cfg(dev, mode);
 	kfree(buffer);
-	dprintk(1, "set mode done chn %lu, %d\n", chn, res);
-
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
 		wait_event_timeout(dev->wait_setmode[chn],
@@ -1276,10 +1240,10 @@
 			res = -EFAULT;
 		}
 	}
-
 	/* clear the restart flag */
 	dev->mode[chn].restart = 0;
 	mutex_unlock(&dev->lock);
+	dprintk(1, "%s chn %lu, result: %d\n", __func__, chn, res);
 	return res;
 }
 
@@ -1291,7 +1255,7 @@
 	u32 chn_rev;
 	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
-	dprintk(4, "%s chan %d\n", __func__, chn_rev);
+	dprintk(4, "%s chan %lu\n", __func__, chn);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1360,7 +1324,6 @@
 	new_mode->restart = 0;
 	*old_mode = *new_mode;
 	dev->cur_fmt[chn] = fh->fmt;
-	dprintk(1, "%s[%d]\n", __func__, chn);
 	dev->last_frame[chn] = -1;
 	dev->bad_payload[chn] = 0;
 	dev->cur_frame[chn] = 0;
@@ -1383,7 +1346,6 @@
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
-
 	dprintk(4, "%s\n, channel: %d", __func__, fh->channel);
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		printk(KERN_ERR "invalid fh type0\n");
@@ -1405,15 +1367,12 @@
 	struct s2255_mode *mode;
 	struct videobuf_queue *q = &fh->vb_vidq;
 	int ret = 0;
-
 	mutex_lock(&q->vb_lock);
-
 	if (videobuf_queue_is_busy(q)) {
 		dprintk(1, "queue busy\n");
 		ret = -EBUSY;
 		goto out_s_std;
 	}
-
 	if (res_locked(fh->dev, fh)) {
 		dprintk(1, "can't change standard after started\n");
 		ret = -EBUSY;
@@ -1455,10 +1414,8 @@
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
 	u32 status = 0;
-
 	if (inp->index != 0)
 		return -EINVAL;
-
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = S2255_NORMS;
 	inp->status = 0;
@@ -1614,7 +1571,7 @@
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
 	*jc = dev->jc[fh->channel];
-	dprintk(2, "getting jpegcompression, quality %d\n", jc->quality);
+	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
 
@@ -1626,7 +1583,7 @@
 	if (jc->quality < 0 || jc->quality > 100)
 		return -EINVAL;
 	dev->jc[fh->channel].quality = jc->quality;
-	dprintk(2, "setting jpeg quality %d\n", jc->quality);
+	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
 
@@ -1842,14 +1799,13 @@
 		s2255_set_mode(dev, cur_channel, &fh->mode);
 		dev->chn_configured[cur_channel] = 1;
 	}
-	dprintk(1, "s2255drv: open dev=%s type=%s\n",
+	dprintk(1, "%s: dev=%s type=%s\n", __func__,
 		video_device_node_name(vdev), v4l2_type_names[type]);
-	dprintk(2, "s2255drv: open: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n",
+	dprintk(2, "%s: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n", __func__,
 		(unsigned long)fh, (unsigned long)dev,
 		(unsigned long)&dev->vidq[cur_channel]);
-	dprintk(4, "s2255drv: open: list_empty active=%d\n",
+	dprintk(4, "%s: list_empty active=%d\n", __func__,
 		list_empty(&dev->vidq[cur_channel].active));
-
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
 				    NULL, &dev->slock,
 				    fh->type,
@@ -1865,10 +1821,8 @@
 	struct s2255_fh *fh = file->private_data;
 	int rc;
 	dprintk(100, "%s\n", __func__);
-
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
-
 	rc = videobuf_poll_stream(file, &fh->vb_vidq, wait);
 	return rc;
 }
@@ -1881,7 +1835,6 @@
 	/* make sure firmware still not trying to load */
 	del_timer(&dev->timer);  /* only started in .probe and .open */
 	if (dev->fw_data->fw_urb) {
-		dprintk(2, "kill fw_urb\n");
 		usb_kill_urb(dev->fw_data->fw_urb);
 		usb_free_urb(dev->fw_data->fw_urb);
 		dev->fw_data->fw_urb = NULL;
@@ -1926,14 +1879,11 @@
 
 	if (!fh)
 		return -ENODEV;
-	dprintk(4, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
-
+	dprintk(4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
 	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
-
-	dprintk(4, "vma start=0x%08lx, size=%ld, ret=%d\n",
+	dprintk(4, "%s vma start=0x%08lx, size=%ld, ret=%d\n", __func__,
 		(unsigned long)vma->vm_start,
 		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start, ret);
-
 	return ret;
 }
 
@@ -2011,7 +1961,6 @@
 		/* register 4 video devices */
 		memcpy(&dev->vdev[i], &template, sizeof(struct video_device));
 		dev->vdev[i].parent = &dev->interface->dev;
-		video_set_drvdata(&dev->vdev[i], dev);
 		if (video_nr == -1)
 			ret = video_register_device(&dev->vdev[i],
 						    VFL_TYPE_GRABBER,
@@ -2031,7 +1980,6 @@
 			  video_device_node_name(&dev->vdev[i]));
 
 	}
-
 	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %d.%d\n",
 	       S2255_MAJOR_VERSION,
 	       S2255_MINOR_VERSION);
@@ -2386,15 +2334,14 @@
 	}
 	/* start read pipe */
 	s2255_start_readpipe(dev);
-
-	dprintk(1, "S2255: board initialized\n");
+	dprintk(1, "%s: success\n", __func__);
 	return 0;
 }
 
 static int s2255_board_shutdown(struct s2255_dev *dev)
 {
 	u32 i;
-	dprintk(1, "S2255: board shutdown: %p", dev);
+	dprintk(1, "%s: dev: %p", __func__,  dev);
 
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		if (dev->b_acquire[i])
@@ -2416,9 +2363,8 @@
 	struct s2255_dev *dev;
 	int status;
 	int pipe;
-
 	pipe_info = purb->context;
-	dprintk(100, "read pipe completion %p, status %d\n", purb,
+	dprintk(100, "%s: urb:%p, status %d\n", __func__, purb,
 		purb->status);
 	if (pipe_info == NULL) {
 		dev_err(&purb->dev->dev, "no context!\n");
@@ -2433,13 +2379,13 @@
 	status = purb->status;
 	/* if shutting down, do not resubmit, exit immediately */
 	if (status == -ESHUTDOWN) {
-		dprintk(2, "read_pipe_completion: err shutdown\n");
+		dprintk(2, "%s: err shutdown\n", __func__);
 		pipe_info->err_count++;
 		return;
 	}
 
 	if (pipe_info->state == 0) {
-		dprintk(2, "exiting USB pipe");
+		dprintk(2, "%s: exiting USB pipe", __func__);
 		return;
 	}
 
@@ -2447,7 +2393,7 @@
 		s2255_read_video_callback(dev, pipe_info);
 	else {
 		pipe_info->err_count++;
-		dprintk(1, "s2255drv: failed URB %d\n", status);
+		dprintk(1, "%s: failed URB %d\n", __func__, status);
 	}
 
 	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
@@ -2463,7 +2409,7 @@
 			dev_err(&dev->udev->dev, "error submitting urb\n");
 		}
 	} else {
-		dprintk(2, "read pipe complete state 0\n");
+		dprintk(2, "%s :complete state 0\n", __func__);
 	}
 	return;
 }
@@ -2474,7 +2420,7 @@
 	int retval;
 	struct s2255_pipeinfo *pipe_info = &dev->pipe;
 	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
-	dprintk(2, "start pipe IN %d\n", dev->read_endpoint);
+	dprintk(2, "%s: IN %d\n", __func__, dev->read_endpoint);
 	pipe_info->state = 1;
 	pipe_info->err_count = 0;
 	pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2489,8 +2435,6 @@
 			  pipe_info->transfer_buffer,
 			  pipe_info->cur_transfer_size,
 			  read_pipe_completion, pipe_info);
-
-	dprintk(4, "submitting URB %p\n", pipe_info->stream_urb);
 	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 	if (retval) {
 		printk(KERN_ERR "s2255: start read pipe failed\n");
@@ -2510,10 +2454,7 @@
 		dprintk(2, "start acquire failed, bad channel %lu\n", chn);
 		return -1;
 	}
-
 	chn_rev = G_chnmap[chn];
-	dprintk(1, "S2255: start acquire %lu \n", chn);
-
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -2557,20 +2498,15 @@
 		return -ENOMEM;
 	}
 	/* send the stop command */
-	dprintk(4, "stop acquire %lu\n", chn);
 	*(__le32 *) buffer = IN_DATA_TOKEN;
 	*((__le32 *) buffer + 1) = (__le32) cpu_to_le32(chn_rev);
 	*((__le32 *) buffer + 2) = CMD_STOP;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
-
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_STOP error\n");
-
-	dprintk(4, "stop acquire: releasing states \n");
-
 	kfree(buffer);
 	dev->b_acquire[chn] = 0;
-
+	dprintk(4, "%s: chn %lu, res %d\n", __func__, chn, res);
 	return res;
 }
 
@@ -2620,9 +2556,7 @@
 	int retval = -ENOMEM;
 	__le32 *pdata;
 	int fw_size;
-
-	dprintk(2, "s2255: probe\n");
-
+	dprintk(2, "%s\n", __func__);
 	/* allocate memory for our device state and initialize it to zero */
 	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
 	if (dev == NULL) {
@@ -2663,11 +2597,9 @@
 	}
 	/* set intfdata */
 	usb_set_intfdata(interface, dev);
-	dprintk(100, "after intfdata %p\n", dev);
 	init_timer(&dev->timer);
 	dev->timer.function = s2255_timer;
 	dev->timer.data = (unsigned long)dev->fw_data;
-
 	init_waitqueue_head(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		init_waitqueue_head(&dev->wait_setmode[i]);
@@ -2716,7 +2648,6 @@
 	retval = s2255_board_init(dev);
 	if (retval)
 		goto errorBOARDINIT;
-	dprintk(4, "before probe done %p\n", dev);
 	spin_lock_init(&dev->slock);
 	s2255_fwload_start(dev, 0);
 	/* kref for each vdev. Released on video_device_release callback */
@@ -2756,7 +2687,6 @@
 {
 	struct s2255_dev *dev = NULL;
 	int i;
-	dprintk(1, "s2255: disconnect interface %p\n", interface);
 	dev = usb_get_intfdata(interface);
 	/* unregister each video device. */
 	for (i = 0; i < MAX_CHANNELS; i++)

