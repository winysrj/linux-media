Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway13.websitewelcome.com ([67.18.137.85]:41162 "HELO
	gateway13.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752761Ab0DLRZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 13:25:55 -0400
Date: Mon, 12 Apr 2010 10:19:13 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
Subject: [PATCH] s2255drv: cleanup of device structure
To: linux-media@vger.kernel.org
Message-ID: <tkrat.7c7e306760d428af@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <linux-dev@sensoray.com>
# Date 1271092523 25200
# Node ID 686a2330f4a6a4c79e299a17663f0f150031098e
# Parent  f2f44853e2eb914d4fc6c7004631839b86fb6d0e
s2255drv: cleanup of device structure

From: Dean Anderson <linux-dev@sensoray.com>

cleanup of device structure
better organization of channels instead of multiple arrays in device
simplifies open callback by removing search for channel index
adding v4l2_device_disconnect

Priority: normal

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff -r f2f44853e2eb -r 686a2330f4a6 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Fri Apr 09 15:51:28 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Mon Apr 12 10:15:23 2010 -0700
@@ -191,7 +191,6 @@
 struct s2255_dmaqueue {
 	struct list_head	active;
 	struct s2255_dev	*dev;
-	int			channel;
 };
 
 /* for firmware loading, fw_state */
@@ -226,51 +225,60 @@
 };
 
 struct s2255_fmt; /*forward declaration */
+struct s2255_dev;
+
+struct s2255_channel {
+	struct video_device	vdev;
+	int			resources;
+	struct s2255_dmaqueue	vidq;
+	struct s2255_bufferi	buffer;
+	struct s2255_mode	mode;
+	/* jpeg compression */
+	struct v4l2_jpegcompression jc;
+	/* capture parameters (for high quality mode full size) */
+	struct v4l2_captureparm cap_parm;
+	int			cur_frame;
+	int			last_frame;
+
+	int			b_acquire;
+	/* allocated image size */
+	unsigned long		req_image_size;
+	/* received packet size */
+	unsigned long		pkt_size;
+	int			bad_payload;
+	unsigned long		frame_count;
+	/* if JPEG image */
+	int                     jpg_size;
+	/* if channel configured to default state */
+	int                     configured;
+	wait_queue_head_t       wait_setmode;
+	int                     setmode_ready;
+	/* video status items */
+	int                     vidstatus;
+	wait_queue_head_t       wait_vidstatus;
+	int                     vidstatus_ready;
+	unsigned int		width;
+	unsigned int		height;
+	const struct s2255_fmt	*fmt;
+	int idx; /* channel number on device, 0-3 */
+};
+
 
 struct s2255_dev {
-	struct video_device	vdev[MAX_CHANNELS];
+	struct s2255_channel    channel[MAX_CHANNELS];
 	struct v4l2_device 	v4l2_dev;
-	atomic_t                channels; /* number of channels registered */
+	atomic_t                num_channels;
 	int			frames;
 	struct mutex		lock;
 	struct mutex		open_lock;
-	int			resources[MAX_CHANNELS];
 	struct usb_device	*udev;
 	struct usb_interface	*interface;
 	u8			read_endpoint;
-
-	struct s2255_dmaqueue	vidq[MAX_CHANNELS];
 	struct timer_list	timer;
 	struct s2255_fw	*fw_data;
 	struct s2255_pipeinfo	pipe;
-	struct s2255_bufferi	buffer[MAX_CHANNELS];
-	struct s2255_mode	mode[MAX_CHANNELS];
-	/* jpeg compression */
-	struct v4l2_jpegcompression jc[MAX_CHANNELS];
-	/* capture parameters (for high quality mode full size) */
-	struct v4l2_captureparm cap_parm[MAX_CHANNELS];
-	const struct s2255_fmt	*cur_fmt[MAX_CHANNELS];
-	int			cur_frame[MAX_CHANNELS];
-	int			last_frame[MAX_CHANNELS];
 	u32			cc;	/* current channel */
-	int			b_acquire[MAX_CHANNELS];
-	/* allocated image size */
-	unsigned long		req_image_size[MAX_CHANNELS];
-	/* received packet size */
-	unsigned long		pkt_size[MAX_CHANNELS];
-	int			bad_payload[MAX_CHANNELS];
-	unsigned long		frame_count[MAX_CHANNELS];
 	int			frame_ready;
-	/* if JPEG image */
-	int                     jpg_size[MAX_CHANNELS];
-	/* if channel configured to default state */
-	int                     chn_configured[MAX_CHANNELS];
-	wait_queue_head_t       wait_setmode[MAX_CHANNELS];
-	int                     setmode_ready[MAX_CHANNELS];
-	/* video status items */
-	int                     vidstatus[MAX_CHANNELS];
-	wait_queue_head_t       wait_vidstatus[MAX_CHANNELS];
-	int                     vidstatus_ready[MAX_CHANNELS];
 	int                     chn_ready;
 	spinlock_t              slock;
 	/* dsp firmware version (f2255usb.bin) */
@@ -298,16 +306,10 @@
 
 struct s2255_fh {
 	struct s2255_dev	*dev;
-	const struct s2255_fmt	*fmt;
-	unsigned int		width;
-	unsigned int		height;
 	struct videobuf_queue	vb_vidq;
 	enum v4l2_buf_type	type;
-	int			channel;
-	/* mode below is the desired mode.
-	   mode in s2255_dev is the current mode that was last set */
-	struct s2255_mode	mode;
-	int			resources[MAX_CHANNELS];
+	struct s2255_channel	*channel;
+	int			resources;
 };
 
 /* current cypress EEPROM firmware version */
@@ -360,12 +362,11 @@
 
 static int s2255_start_readpipe(struct s2255_dev *dev);
 static void s2255_stop_readpipe(struct s2255_dev *dev);
-static int s2255_start_acquire(struct s2255_dev *dev, unsigned long chn);
-static int s2255_stop_acquire(struct s2255_dev *dev, unsigned long chn);
-static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
-			   int chn, int jpgsize);
-static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
-			  struct s2255_mode *mode);
+static int s2255_start_acquire(struct s2255_channel *channel);
+static int s2255_stop_acquire(struct s2255_channel *channel);
+static void s2255_fillbuff(struct s2255_channel *chn, struct s2255_buffer *buf,
+			   int jpgsize);
+static int s2255_set_mode(struct s2255_channel *chan, struct s2255_mode *mode);
 static int s2255_board_shutdown(struct s2255_dev *dev);
 static void s2255_fwload_start(struct s2255_dev *dev, int reset);
 static void s2255_destroy(struct s2255_dev *dev);
@@ -577,10 +578,11 @@
 
 }
 
-static int s2255_got_frame(struct s2255_dev *dev, int chn, int jpgsize)
+static int s2255_got_frame(struct s2255_channel *channel, int jpgsize)
 {
-	struct s2255_dmaqueue *dma_q = &dev->vidq[chn];
+	struct s2255_dmaqueue *dma_q = &channel->vidq;
 	struct s2255_buffer *buf;
+	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
 	unsigned long flags = 0;
 	int rc = 0;
 	spin_lock_irqsave(&dev->slock, flags);
@@ -593,7 +595,7 @@
 			 struct s2255_buffer, vb.queue);
 	list_del(&buf->vb.queue);
 	do_gettimeofday(&buf->vb.ts);
-	s2255_fillbuff(dev, buf, dma_q->channel, jpgsize);
+	s2255_fillbuff(channel, buf, jpgsize);
 	wake_up(&buf->vb.done);
 	dprintk(2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
 unlock:
@@ -621,8 +623,8 @@
  *                  http://v4l.videotechnology.com/
  *
  */
-static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
-			   int chn, int jpgsize)
+static void s2255_fillbuff(struct s2255_channel *channel,
+			   struct s2255_buffer *buf, int jpgsize)
 {
 	int pos = 0;
 	struct timeval ts;
@@ -633,12 +635,11 @@
 
 	if (!vbuf)
 		return;
-
-	last_frame = dev->last_frame[chn];
+	last_frame = channel->last_frame;
 	if (last_frame != -1) {
-		frm = &dev->buffer[chn].frame[last_frame];
+		frm = &channel->buffer.frame[last_frame];
 		tmpbuf =
-		    (const char *)dev->buffer[chn].frame[last_frame].lpvbits;
+		    (const char *)channel->buffer.frame[last_frame].lpvbits;
 		switch (buf->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
 		case V4L2_PIX_FMT_UYVY:
@@ -661,7 +662,7 @@
 		default:
 			printk(KERN_DEBUG "s2255: unknown format?\n");
 		}
-		dev->last_frame[chn] = -1;
+		channel->last_frame = -1;
 	} else {
 		printk(KERN_ERR "s2255: =======no frame\n");
 		return;
@@ -671,7 +672,7 @@
 		(unsigned long)vbuf, pos);
 	/* tell v4l buffer was filled */
 
-	buf->vb.field_count = dev->frame_count[chn] * 2;
+	buf->vb.field_count = channel->frame_count * 2;
 	do_gettimeofday(&ts);
 	buf->vb.ts = ts;
 	buf->vb.state = VIDEOBUF_DONE;
@@ -686,8 +687,8 @@
 			unsigned int *size)
 {
 	struct s2255_fh *fh = vq->priv_data;
-
-	*size = fh->width * fh->height * (fh->fmt->depth >> 3);
+	struct s2255_channel *channel = fh->channel;
+	*size = channel->width * channel->height * (channel->fmt->depth >> 3);
 
 	if (0 == *count)
 		*count = S2255_DEF_BUFS;
@@ -710,30 +711,31 @@
 			  enum v4l2_field field)
 {
 	struct s2255_fh *fh = vq->priv_data;
+	struct s2255_channel *channel = fh->channel;
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	int rc;
+	int w = channel->width;
+	int h = channel->height;
 	dprintk(4, "%s, field=%d\n", __func__, field);
-	if (fh->fmt == NULL)
+	if (channel->fmt == NULL)
 		return -EINVAL;
 
-	if ((fh->width < norm_minw(&fh->dev->vdev[fh->channel])) ||
-	    (fh->width > norm_maxw(&fh->dev->vdev[fh->channel])) ||
-	    (fh->height < norm_minh(&fh->dev->vdev[fh->channel])) ||
-	    (fh->height > norm_maxh(&fh->dev->vdev[fh->channel]))) {
+	if ((w < norm_minw(&channel->vdev)) ||
+	    (w > norm_maxw(&channel->vdev)) ||
+	    (h < norm_minh(&channel->vdev)) ||
+	    (h > norm_maxh(&channel->vdev))) {
 		dprintk(4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
-
-	buf->vb.size = fh->width * fh->height * (fh->fmt->depth >> 3);
-
+	buf->vb.size = w * h * (channel->fmt->depth >> 3);
 	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size) {
 		dprintk(4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
 
-	buf->fmt = fh->fmt;
-	buf->vb.width = fh->width;
-	buf->vb.height = fh->height;
+	buf->fmt = channel->fmt;
+	buf->vb.width = w;
+	buf->vb.height = h;
 	buf->vb.field = field;
 
 	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
@@ -753,8 +755,8 @@
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_dev *dev = fh->dev;
-	struct s2255_dmaqueue *vidq = &dev->vidq[fh->channel];
+	struct s2255_channel *channel = fh->channel;
+	struct s2255_dmaqueue *vidq = &channel->vidq;
 	dprintk(1, "%s\n", __func__);
 	buf->vb.state = VIDEOBUF_QUEUED;
 	list_add_tail(&buf->vb.queue, &vidq->active);
@@ -765,7 +767,7 @@
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
-	dprintk(4, "%s %d\n", __func__, fh->channel);
+	dprintk(4, "%s %d\n", __func__, fh->channel->idx);
 	free_buffer(vq, buf);
 }
 
@@ -777,39 +779,44 @@
 };
 
 
-static int res_get(struct s2255_dev *dev, struct s2255_fh *fh)
+static int res_get(struct s2255_fh *fh)
 {
+	struct s2255_dev *dev = fh->dev;
 	/* is it free? */
+	struct s2255_channel *channel = fh->channel;
 	mutex_lock(&dev->lock);
-	if (dev->resources[fh->channel]) {
+	if (channel->resources) {
 		/* no, someone else uses it */
 		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
-	dev->resources[fh->channel] = 1;
-	fh->resources[fh->channel] = 1;
+	channel->resources = 1;
+	fh->resources = 1;
 	dprintk(1, "s2255: res: get\n");
 	mutex_unlock(&dev->lock);
 	return 1;
 }
 
-static int res_locked(struct s2255_dev *dev, struct s2255_fh *fh)
+static int res_locked(struct s2255_fh *fh)
 {
-	return dev->resources[fh->channel];
+	struct s2255_channel *channel = fh->channel;
+	return channel->resources;
 }
 
 static int res_check(struct s2255_fh *fh)
 {
-	return fh->resources[fh->channel];
+	return fh->resources;
 }
 
 
-static void res_free(struct s2255_dev *dev, struct s2255_fh *fh)
+static void res_free(struct s2255_fh *fh)
 {
+	struct s2255_channel *channel = fh->channel;
+	struct s2255_dev *dev = fh->dev;
 	mutex_lock(&dev->lock);
-	dev->resources[fh->channel] = 0;
-	fh->resources[fh->channel] = 0;
+	channel->resources = 0;
+	fh->resources = 0;
 	mutex_unlock(&dev->lock);
 	dprintk(1, "res: put\n");
 }
@@ -869,12 +876,13 @@
 			    struct v4l2_format *f)
 {
 	struct s2255_fh *fh = priv;
+	struct s2255_channel *channel = fh->channel;
 
-	f->fmt.pix.width = fh->width;
-	f->fmt.pix.height = fh->height;
+	f->fmt.pix.width = channel->width;
+	f->fmt.pix.height = channel->height;
 	f->fmt.pix.field = fh->vb_vidq.field;
-	f->fmt.pix.pixelformat = fh->fmt->fourcc;
-	f->fmt.pix.bytesperline = f->fmt.pix.width * (fh->fmt->depth >> 3);
+	f->fmt.pix.pixelformat = channel->fmt->fourcc;
+	f->fmt.pix.bytesperline = f->fmt.pix.width * (channel->fmt->depth >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	return 0;
 }
@@ -886,11 +894,10 @@
 	enum v4l2_field field;
 	int  b_any_field = 0;
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_channel *channel = fh->channel;
 	int is_ntsc;
-
 	is_ntsc =
-	    (dev->vdev[fh->channel].current_norm & V4L2_STD_NTSC) ? 1 : 0;
+		(channel->vdev.current_norm & V4L2_STD_NTSC) ? 1 : 0;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
@@ -982,8 +989,10 @@
 			    struct v4l2_format *f)
 {
 	struct s2255_fh *fh = priv;
+	struct s2255_channel *channel = fh->channel;
 	const struct s2255_fmt *fmt;
 	struct videobuf_queue *q = &fh->vb_vidq;
+	struct s2255_mode mode;
 	int ret;
 	int norm;
 
@@ -1005,54 +1014,61 @@
 		goto out_s_fmt;
 	}
 
-	if (res_locked(fh->dev, fh)) {
+	if (res_locked(fh)) {
 		dprintk(1, "%s: channel busy\n", __func__);
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
-
-	fh->fmt = fmt;
-	fh->width = f->fmt.pix.width;
-	fh->height = f->fmt.pix.height;
+	mode = channel->mode;
+	channel->fmt = fmt;
+	channel->width = f->fmt.pix.width;
+	channel->height = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type = f->type;
-	norm = norm_minw(&fh->dev->vdev[fh->channel]);
-	if (fh->width > norm_minw(&fh->dev->vdev[fh->channel])) {
-		if (fh->height > norm_minh(&fh->dev->vdev[fh->channel])) {
-			if (fh->dev->cap_parm[fh->channel].capturemode &
+	norm = norm_minw(&channel->vdev);
+	if (channel->width > norm_minw(&channel->vdev)) {
+		if (channel->height > norm_minh(&channel->vdev)) {
+			if (channel->cap_parm.capturemode &
 			    V4L2_MODE_HIGHQUALITY)
-				fh->mode.scale = SCALE_4CIFSI;
+				mode.scale = SCALE_4CIFSI;
 			else
-				fh->mode.scale = SCALE_4CIFS;
+				mode.scale = SCALE_4CIFS;
 		} else
-			fh->mode.scale = SCALE_2CIFS;
+			mode.scale = SCALE_2CIFS;
 
 	} else {
-		fh->mode.scale = SCALE_1CIFS;
+		mode.scale = SCALE_1CIFS;
 	}
-
 	/* color mode */
-	switch (fh->fmt->fourcc) {
+	switch (channel->fmt->fourcc) {
 	case V4L2_PIX_FMT_GREY:
-		fh->mode.color &= ~MASK_COLOR;
-		fh->mode.color |= COLOR_Y8;
+		mode.color &= ~MASK_COLOR;
+		mode.color |= COLOR_Y8;
 		break;
 	case V4L2_PIX_FMT_JPEG:
-		fh->mode.color &= ~MASK_COLOR;
-		fh->mode.color |= COLOR_JPG;
-		fh->mode.color |= (fh->dev->jc[fh->channel].quality << 8);
+		mode.color &= ~MASK_COLOR;
+		mode.color |= COLOR_JPG;
+		mode.color |= (channel->jc.quality << 8);
 		break;
 	case V4L2_PIX_FMT_YUV422P:
-		fh->mode.color &= ~MASK_COLOR;
-		fh->mode.color |= COLOR_YUVPL;
+		mode.color &= ~MASK_COLOR;
+		mode.color |= COLOR_YUVPL;
 		break;
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	default:
-		fh->mode.color &= ~MASK_COLOR;
-		fh->mode.color |= COLOR_YUVPK;
+		mode.color &= ~MASK_COLOR;
+		mode.color |= COLOR_YUVPK;
 		break;
 	}
+	if ((mode.color & MASK_COLOR) != (channel->mode.color & MASK_COLOR))
+		mode.restart = 1;
+	else if (mode.scale != channel->mode.scale)
+		mode.restart = 1;
+	else if (mode.format != channel->mode.format)
+		mode.restart = 1;
+	channel->mode = mode;
+	(void) s2255_set_mode(channel, &mode);
 	ret = 0;
 out_s_fmt:
 	mutex_unlock(&q->vb_lock);
@@ -1197,26 +1213,27 @@
  * When the restart parameter is set, we sleep for ONE frame to allow the
  * DSP time to get the new frame
  */
-static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
+static int s2255_set_mode(struct s2255_channel *channel,
 			  struct s2255_mode *mode)
 {
 	int res;
 	__le32 *buffer;
 	unsigned long chn_rev;
+	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
 	mutex_lock(&dev->lock);
-	chn_rev = G_chnmap[chn];
-	dprintk(3, "%s channel %lu\n", __func__, chn);
+	chn_rev = G_chnmap[channel->idx];
+	dprintk(3, "%s channel: %d\n", __func__, channel->idx);
 	/* if JPEG, set the quality */
 	if ((mode->color & MASK_COLOR) == COLOR_JPG) {
 		mode->color &= ~MASK_COLOR;
 		mode->color |= COLOR_JPG;
 		mode->color &= ~MASK_JPG_QUALITY;
-		mode->color |= (dev->jc[chn].quality << 8);
+		mode->color |= (channel->jc.quality << 8);
 	}
 	/* save the mode */
-	dev->mode[chn] = *mode;
-	dev->req_image_size[chn] = get_transfer_size(mode);
-	dprintk(1, "%s: reqsize %ld\n", __func__, dev->req_image_size[chn]);
+	channel->mode = *mode;
+	channel->req_image_size = get_transfer_size(mode);
+	dprintk(1, "%s: reqsize %ld\n", __func__, channel->req_image_size);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1227,38 +1244,38 @@
 	buffer[0] = IN_DATA_TOKEN;
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_SET_MODE;
-	memcpy(&buffer[3], &dev->mode[chn], sizeof(struct s2255_mode));
-	dev->setmode_ready[chn] = 0;
+	memcpy(&buffer[3], &channel->mode, sizeof(struct s2255_mode));
+	channel->setmode_ready = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
 		s2255_print_cfg(dev, mode);
 	kfree(buffer);
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
-		wait_event_timeout(dev->wait_setmode[chn],
-				   (dev->setmode_ready[chn] != 0),
+		wait_event_timeout(channel->wait_setmode,
+				   (channel->setmode_ready != 0),
 				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
-		if (dev->setmode_ready[chn] != 1) {
+		if (channel->setmode_ready != 1) {
 			printk(KERN_DEBUG "s2255: no set mode response\n");
 			res = -EFAULT;
 		}
 	}
 	/* clear the restart flag */
-	dev->mode[chn].restart = 0;
+	channel->mode.restart = 0;
 	mutex_unlock(&dev->lock);
-	dprintk(1, "%s chn %lu, result: %d\n", __func__, chn, res);
+	dprintk(1, "%s chn %d, result: %d\n", __func__, channel->idx, res);
 	return res;
 }
 
-static int s2255_cmd_status(struct s2255_dev *dev, unsigned long chn,
-			    u32 *pstatus)
+static int s2255_cmd_status(struct s2255_channel *channel, u32 *pstatus)
 {
 	int res;
 	__le32 *buffer;
 	u32 chn_rev;
+	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
 	mutex_lock(&dev->lock);
-	chn_rev = G_chnmap[chn];
-	dprintk(4, "%s chan %lu\n", __func__, chn);
+	chn_rev = G_chnmap[channel->idx];
+	dprintk(4, "%s chan %d\n", __func__, channel->idx);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1270,17 +1287,17 @@
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_STATUS;
 	*pstatus = 0;
-	dev->vidstatus_ready[chn] = 0;
+	channel->vidstatus_ready = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	kfree(buffer);
-	wait_event_timeout(dev->wait_vidstatus[chn],
-			   (dev->vidstatus_ready[chn] != 0),
+	wait_event_timeout(channel->wait_vidstatus,
+			   (channel->vidstatus_ready != 0),
 			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
-	if (dev->vidstatus_ready[chn] != 1) {
+	if (channel->vidstatus_ready != 1) {
 		printk(KERN_DEBUG "s2255: no vidstatus response\n");
 		res = -EFAULT;
 	}
-	*pstatus = dev->vidstatus[chn];
+	*pstatus = channel->vidstatus;
 	dprintk(4, "%s, vid status %d\n", __func__, *pstatus);
 	mutex_unlock(&dev->lock);
 	return res;
@@ -1291,9 +1308,7 @@
 	int res;
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
-	struct s2255_mode *new_mode;
-	struct s2255_mode *old_mode;
-	int chn;
+	struct s2255_channel *channel = fh->channel;
 	int j;
 	dprintk(4, "%s\n", __func__);
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
@@ -1305,51 +1320,32 @@
 		return -EINVAL;
 	}
 
-	if (!res_get(dev, fh)) {
+	if (!res_get(fh)) {
 		s2255_dev_err(&dev->udev->dev, "stream busy\n");
 		return -EBUSY;
 	}
-
-	/* send a set mode command everytime with restart.
-	   in case we switch resolutions or other parameters */
-	chn = fh->channel;
-	new_mode = &fh->mode;
-	old_mode = &fh->dev->mode[chn];
-
-	if ((new_mode->color & MASK_COLOR) != (old_mode->color & MASK_COLOR))
-		new_mode->restart = 1;
-	else if (new_mode->scale != old_mode->scale)
-		new_mode->restart = 1;
-	else if (new_mode->format != old_mode->format)
-		new_mode->restart = 1;
-
-	s2255_set_mode(dev, chn, new_mode);
-	new_mode->restart = 0;
-	*old_mode = *new_mode;
-	dev->cur_fmt[chn] = fh->fmt;
-	dev->last_frame[chn] = -1;
-	dev->bad_payload[chn] = 0;
-	dev->cur_frame[chn] = 0;
-	dev->frame_count[chn] = 0;
+	channel->last_frame = -1;
+	channel->bad_payload = 0;
+	channel->cur_frame = 0;
+	channel->frame_count = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
-		dev->buffer[chn].frame[j].ulState = S2255_READ_IDLE;
-		dev->buffer[chn].frame[j].cur_size = 0;
+		channel->buffer.frame[j].ulState = S2255_READ_IDLE;
+		channel->buffer.frame[j].cur_size = 0;
 	}
 	res = videobuf_streamon(&fh->vb_vidq);
 	if (res == 0) {
-		s2255_start_acquire(dev, chn);
-		dev->b_acquire[chn] = 1;
-	} else {
-		res_free(dev, fh);
-	}
+		s2255_start_acquire(channel);
+		channel->b_acquire = 1;
+	} else
+		res_free(fh);
+
 	return res;
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
-	dprintk(4, "%s\n, channel: %d", __func__, fh->channel);
+	dprintk(4, "%s\n, channel: %d", __func__, fh->channel->idx);
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		printk(KERN_ERR "invalid fh type0\n");
 		return -EINVAL;
@@ -1358,16 +1354,16 @@
 		printk(KERN_ERR "invalid type i\n");
 		return -EINVAL;
 	}
-	s2255_stop_acquire(dev, fh->channel);
+	s2255_stop_acquire(fh->channel);
 	videobuf_streamoff(&fh->vb_vidq);
-	res_free(dev, fh);
+	res_free(fh);
 	return 0;
 }
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_mode *mode;
+	struct s2255_mode mode;
 	struct videobuf_queue *q = &fh->vb_vidq;
 	int ret = 0;
 	mutex_lock(&q->vb_lock);
@@ -1376,29 +1372,32 @@
 		ret = -EBUSY;
 		goto out_s_std;
 	}
-	if (res_locked(fh->dev, fh)) {
+	if (res_locked(fh)) {
 		dprintk(1, "can't change standard after started\n");
 		ret = -EBUSY;
 		goto out_s_std;
 	}
-	mode = &fh->mode;
+	mode = fh->channel->mode;
 	if (*i & V4L2_STD_NTSC) {
 		dprintk(4, "%s NTSC\n", __func__);
 		/* if changing format, reset frame decimation/intervals */
-		if (mode->format != FORMAT_NTSC) {
-			mode->format = FORMAT_NTSC;
-			mode->fdec = FDEC_1;
+		if (mode.format != FORMAT_NTSC) {
+			mode.restart = 1;
+			mode.format = FORMAT_NTSC;
+			mode.fdec = FDEC_1;
 		}
 	} else if (*i & V4L2_STD_PAL) {
 		dprintk(4, "%s PAL\n", __func__);
-		mode->format = FORMAT_PAL;
-		if (mode->format != FORMAT_PAL) {
-			mode->format = FORMAT_PAL;
-			mode->fdec = FDEC_1;
+		if (mode.format != FORMAT_PAL) {
+			mode.restart = 1;
+			mode.format = FORMAT_PAL;
+			mode.fdec = FDEC_1;
 		}
 	} else {
 		ret = -EINVAL;
 	}
+	if (mode.restart)
+		s2255_set_mode(fh->channel, &mode);
 out_s_std:
 	mutex_unlock(&q->vb_lock);
 	return ret;
@@ -1416,6 +1415,7 @@
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
+	struct s2255_channel *channel = fh->channel;
 	u32 status = 0;
 	if (inp->index != 0)
 		return -EINVAL;
@@ -1424,7 +1424,7 @@
 	inp->status = 0;
 	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
 		int rc;
-		rc = s2255_cmd_status(dev, fh->channel, &status);
+		rc = s2255_cmd_status(fh->channel, &status);
 		dprintk(4, "s2255_cmd_status rc: %d status %x\n", rc, status);
 		if (rc == 0)
 			inp->status =  (status & 0x01) ? 0
@@ -1436,7 +1436,7 @@
 		strlcpy(inp->name, "Composite", sizeof(inp->name));
 		break;
 	case 0x2257:
-		strlcpy(inp->name, (fh->channel < 2) ? "Composite" : "S-Video",
+		strlcpy(inp->name, (channel->idx < 2) ? "Composite" : "S-Video",
 			sizeof(inp->name));
 		break;
 	}
@@ -1460,6 +1460,7 @@
 			    struct v4l2_queryctrl *qc)
 {
 	struct s2255_fh *fh = priv;
+	struct s2255_channel *channel = fh->channel;
 	struct s2255_dev *dev = fh->dev;
 	switch (qc->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -1477,7 +1478,7 @@
 	case V4L2_CID_PRIVATE_COLORFILTER:
 		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
 			return -EINVAL;
-		if ((dev->pid == 0x2257) && (fh->channel > 1))
+		if ((dev->pid == 0x2257) && (channel->idx > 1))
 			return -EINVAL;
 		strlcpy(qc->name, "Color Filter", sizeof(qc->name));
 		qc->type = V4L2_CTRL_TYPE_MENU;
@@ -1499,25 +1500,26 @@
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
+	struct s2255_channel *channel = fh->channel;
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = fh->mode.bright;
+		ctrl->value = channel->mode.bright;
 		break;
 	case V4L2_CID_CONTRAST:
-		ctrl->value = fh->mode.contrast;
+		ctrl->value = channel->mode.contrast;
 		break;
 	case V4L2_CID_SATURATION:
-		ctrl->value = fh->mode.saturation;
+		ctrl->value = channel->mode.saturation;
 		break;
 	case V4L2_CID_HUE:
-		ctrl->value = fh->mode.hue;
+		ctrl->value = channel->mode.hue;
 		break;
 	case V4L2_CID_PRIVATE_COLORFILTER:
 		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
 			return -EINVAL;
-		if ((dev->pid == 0x2257) && (fh->channel > 1))
+		if ((dev->pid == 0x2257) && (channel->idx > 1))
 			return -EINVAL;
-		ctrl->value = !((fh->mode.color & MASK_INPUT_TYPE) >> 16);
+		ctrl->value = !((channel->mode.color & MASK_INPUT_TYPE) >> 16);
 		break;
 	default:
 		return -EINVAL;
@@ -1530,41 +1532,42 @@
 			 struct v4l2_control *ctrl)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
-	struct s2255_mode *mode;
-	mode = &fh->mode;
+	struct s2255_channel *channel = fh->channel;
+	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	struct s2255_mode mode;
+	mode = channel->mode;
 	dprintk(4, "%s\n", __func__);
 	/* update the mode to the corresponding value */
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		mode->bright = ctrl->value;
+		mode.bright = ctrl->value;
 		break;
 	case V4L2_CID_CONTRAST:
-		mode->contrast = ctrl->value;
+		mode.contrast = ctrl->value;
 		break;
 	case V4L2_CID_HUE:
-		mode->hue = ctrl->value;
+		mode.hue = ctrl->value;
 		break;
 	case V4L2_CID_SATURATION:
-		mode->saturation = ctrl->value;
+		mode.saturation = ctrl->value;
 		break;
 	case V4L2_CID_PRIVATE_COLORFILTER:
 		if (dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
 			return -EINVAL;
-		if ((dev->pid == 0x2257) && (fh->channel > 1))
+		if ((dev->pid == 0x2257) && (channel->idx > 1))
 			return -EINVAL;
-		mode->color &= ~MASK_INPUT_TYPE;
-		mode->color |= ((ctrl->value ? 0 : 1) << 16);
+		mode.color &= ~MASK_INPUT_TYPE;
+		mode.color |= ((ctrl->value ? 0 : 1) << 16);
 		break;
 	default:
 		return -EINVAL;
 	}
-	mode->restart = 0;
+	mode.restart = 0;
 	/* set mode here.  Note: stream does not need restarted.
 	   some V4L programs restart stream unnecessarily
 	   after a s_crtl.
 	*/
-	s2255_set_mode(dev, fh->channel, mode);
+	s2255_set_mode(fh->channel, &mode);
 	return 0;
 }
 
@@ -1572,8 +1575,8 @@
 			 struct v4l2_jpegcompression *jc)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
-	*jc = dev->jc[fh->channel];
+	struct s2255_channel *channel = fh->channel;
+	*jc = channel->jc;
 	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
@@ -1582,10 +1585,10 @@
 			 struct v4l2_jpegcompression *jc)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_channel *channel = fh->channel;
 	if (jc->quality < 0 || jc->quality > 100)
 		return -EINVAL;
-	dev->jc[fh->channel].quality = jc->quality;
+	channel->jc.quality = jc->quality;
 	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
@@ -1594,17 +1597,17 @@
 			 struct v4l2_streamparm *sp)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
 	__u32 def_num, def_dem;
+	struct s2255_channel *channel = fh->channel;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	memset(sp, 0, sizeof(struct v4l2_streamparm));
 	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
-	sp->parm.capture.capturemode = dev->cap_parm[fh->channel].capturemode;
-	def_num = (fh->mode.format == FORMAT_NTSC) ? 1001 : 1000;
-	def_dem = (fh->mode.format == FORMAT_NTSC) ? 30000 : 25000;
+	sp->parm.capture.capturemode = channel->cap_parm.capturemode;
+	def_num = (channel->mode.format == FORMAT_NTSC) ? 1001 : 1000;
+	def_dem = (channel->mode.format == FORMAT_NTSC) ? 30000 : 25000;
 	sp->parm.capture.timeperframe.denominator = def_dem;
-	switch (fh->mode.fdec) {
+	switch (channel->mode.fdec) {
 	default:
 	case FDEC_1:
 		sp->parm.capture.timeperframe.numerator = def_num;
@@ -1630,17 +1633,19 @@
 			 struct v4l2_streamparm *sp)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_channel *channel = fh->channel;
+	struct s2255_mode mode;
 	int fdec = FDEC_1;
 	__u32 def_num, def_dem;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
+	mode = channel->mode;
 	/* high quality capture mode requires a stream restart */
-	if (dev->cap_parm[fh->channel].capturemode
-	    != sp->parm.capture.capturemode && res_locked(fh->dev, fh))
+	if (channel->cap_parm.capturemode
+	    != sp->parm.capture.capturemode && res_locked(fh))
 		return -EBUSY;
-	def_num = (fh->mode.format == FORMAT_NTSC) ? 1001 : 1000;
-	def_dem = (fh->mode.format == FORMAT_NTSC) ? 30000 : 25000;
+	def_num = (mode.format == FORMAT_NTSC) ? 1001 : 1000;
+	def_dem = (mode.format == FORMAT_NTSC) ? 30000 : 25000;
 	if (def_dem != sp->parm.capture.timeperframe.denominator)
 		sp->parm.capture.timeperframe.numerator = def_num;
 	else if (sp->parm.capture.timeperframe.numerator <= def_num)
@@ -1655,9 +1660,9 @@
 		sp->parm.capture.timeperframe.numerator = def_num * 5;
 		fdec = FDEC_5;
 	}
-	fh->mode.fdec = fdec;
+	mode.fdec = fdec;
 	sp->parm.capture.timeperframe.denominator = def_dem;
-	s2255_set_mode(dev, fh->channel, &fh->mode);
+	s2255_set_mode(channel, &mode);
 	dprintk(4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
 		__func__,
 		sp->parm.capture.capturemode,
@@ -1707,20 +1712,13 @@
 static int s2255_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct s2255_dev *dev = video_drvdata(file);
+	struct s2255_channel *channel = video_drvdata(file);
+	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
 	struct s2255_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	int i = 0;
-	int cur_channel = -1;
 	int state;
 	dprintk(1, "s2255: open called (dev=%s)\n",
 		video_device_node_name(vdev));
-
-	for (i = 0; i < MAX_CHANNELS; i++)
-		if (&dev->vdev[i] == vdev) {
-			cur_channel = i;
-			break;
-		}
 	/*
 	 * open lock necessary to prevent multiple instances
 	 * of v4l-conf (or other programs) from simultaneously
@@ -1791,24 +1789,20 @@
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	fh->mode = dev->mode[cur_channel];
-	fh->fmt = dev->cur_fmt[cur_channel];
-	/* default 4CIF NTSC */
-	fh->width = LINE_SZ_4CIFS_NTSC;
-	fh->height = NUM_LINES_4CIFS_NTSC * 2;
-	fh->channel = cur_channel;
-	/* configure channel to default state */
-	if (!dev->chn_configured[cur_channel]) {
-		s2255_set_mode(dev, cur_channel, &fh->mode);
-		dev->chn_configured[cur_channel] = 1;
+	fh->channel = channel;
+	if (!channel->configured) {
+		/* configure channel to default state */
+		channel->fmt = &formats[0];
+		s2255_set_mode(channel, &channel->mode);
+		channel->configured = 1;
 	}
 	dprintk(1, "%s: dev=%s type=%s\n", __func__,
 		video_device_node_name(vdev), v4l2_type_names[type]);
 	dprintk(2, "%s: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n", __func__,
 		(unsigned long)fh, (unsigned long)dev,
-		(unsigned long)&dev->vidq[cur_channel]);
+		(unsigned long)&channel->vidq);
 	dprintk(4, "%s: list_empty active=%d\n", __func__,
-		list_empty(&dev->vidq[cur_channel].active));
+		list_empty(&channel->vidq.active));
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
 				    NULL, &dev->slock,
 				    fh->type,
@@ -1850,6 +1844,7 @@
 	mutex_destroy(&dev->open_lock);
 	mutex_destroy(&dev->lock);
 	usb_put_dev(dev->udev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 	dprintk(1, "%s", __func__);
 	kfree(dev);
 }
@@ -1859,14 +1854,15 @@
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev = fh->dev;
 	struct video_device *vdev = video_devdata(file);
+	struct s2255_channel *channel = fh->channel;
 	if (!dev)
 		return -ENODEV;
 	/* turn off stream */
 	if (res_check(fh)) {
-		if (dev->b_acquire[fh->channel])
-			s2255_stop_acquire(dev, fh->channel);
+		if (channel->b_acquire)
+			s2255_stop_acquire(fh->channel);
 		videobuf_streamoff(&fh->vb_vidq);
-		res_free(dev, fh);
+		res_free(fh);
 	}
 	videobuf_mmap_free(&fh->vb_vidq);
 	dprintk(1, "%s (dev=%s)\n", __func__, video_device_node_name(vdev));
@@ -1930,9 +1926,10 @@
 
 static void s2255_video_device_release(struct video_device *vdev)
 {
-	struct s2255_dev *dev = video_get_drvdata(vdev);
-	dprintk(4, "%s, chnls: %d \n", __func__, atomic_read(&dev->channels));
-	if (atomic_dec_and_test(&dev->channels))
+	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
+	dprintk(4, "%s, chnls: %d \n", __func__,
+		atomic_read(&dev->num_channels));
+	if (atomic_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	return;
 }
@@ -1951,46 +1948,48 @@
 	int ret;
 	int i;
 	int cur_nr = video_nr;
+	struct s2255_channel *channel;
 	ret = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
 	/* initialize all video 4 linux */
 	/* register 4 video devices */
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		INIT_LIST_HEAD(&dev->vidq[i].active);
-		dev->vidq[i].dev = dev;
-		dev->vidq[i].channel = i;
+		channel = &dev->channel[i];
+		INIT_LIST_HEAD(&channel->vidq.active);
+		channel->vidq.dev = dev;
 		/* register 4 video devices */
-		memcpy(&dev->vdev[i], &template, sizeof(struct video_device));
-		dev->vdev[i].v4l2_dev = &dev->v4l2_dev;
-		video_set_drvdata(&dev->vdev[i], dev);
+		channel->vdev = template;
+		channel->vdev.v4l2_dev = &dev->v4l2_dev;
+		video_set_drvdata(&channel->vdev, channel);
 		if (video_nr == -1)
-			ret = video_register_device(&dev->vdev[i],
+			ret = video_register_device(&channel->vdev,
 						    VFL_TYPE_GRABBER,
 						    video_nr);
 		else
-			ret = video_register_device(&dev->vdev[i],
+			ret = video_register_device(&channel->vdev,
 						    VFL_TYPE_GRABBER,
 						    cur_nr + i);
+
 		if (ret) {
 			dev_err(&dev->udev->dev,
 				"failed to register video device!\n");
 			break;
 		}
-		atomic_inc(&dev->channels);
+		atomic_inc(&dev->num_channels);
 		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
-			  video_device_node_name(&dev->vdev[i]));
+			  video_device_node_name(&channel->vdev));
 
 	}
 	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %d.%d\n",
 	       S2255_MAJOR_VERSION,
 	       S2255_MINOR_VERSION);
 	/* if no channels registered, return error and probe will fail*/
-	if (atomic_read(&dev->channels) == 0) {
+	if (atomic_read(&dev->num_channels) == 0) {
 		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
-	if (atomic_read(&dev->channels) != MAX_CHANNELS)
+	if (atomic_read(&dev->num_channels) != MAX_CHANNELS)
 		printk(KERN_WARNING "s2255: Not all channels available.\n");
 	return 0;
 }
@@ -2017,12 +2016,11 @@
 	s32 idx = -1;
 	struct s2255_framei *frm;
 	unsigned char *pdata;
-
+	struct s2255_channel *channel;
 	dprintk(100, "buffer to user\n");
-
-	idx = dev->cur_frame[dev->cc];
-	frm = &dev->buffer[dev->cc].frame[idx];
-
+	channel = &dev->channel[dev->cc];
+	idx = channel->cur_frame;
+	frm = &channel->buffer.frame[idx];
 	if (frm->ulState == S2255_READ_IDLE) {
 		int jj;
 		unsigned int cc;
@@ -2047,16 +2045,18 @@
 				}
 				/* reverse it */
 				dev->cc = G_chnmap[cc];
+				channel = &dev->channel[dev->cc];
 				payload =  pdword[3];
-				if (payload > dev->req_image_size[dev->cc]) {
-					dev->bad_payload[dev->cc]++;
+				if (payload > channel->req_image_size) {
+					channel->bad_payload++;
 					/* discard the bad frame */
 					return -EINVAL;
 				}
-				dev->pkt_size[dev->cc] = payload;
-				dev->jpg_size[dev->cc] = pdword[4];
+				channel->pkt_size = payload;
+				channel->jpg_size = pdword[4];
 				break;
 			case S2255_MARKER_RESPONSE:
+
 				pdata += DEF_USB_BLOCK;
 				jj += DEF_USB_BLOCK;
 				if (pdword[1] >= MAX_CHANNELS)
@@ -2064,12 +2064,13 @@
 				cc = G_chnmap[pdword[1]];
 				if (cc >= MAX_CHANNELS)
 					break;
+				channel = &dev->channel[cc];
 				switch (pdword[2]) {
 				case S2255_RESPONSE_SETMODE:
 					/* check if channel valid */
 					/* set mode ready */
-					dev->setmode_ready[cc] = 1;
-					wake_up(&dev->wait_setmode[cc]);
+					channel->setmode_ready = 1;
+					wake_up(&channel->wait_setmode);
 					dprintk(5, "setmode ready %d\n", cc);
 					break;
 				case S2255_RESPONSE_FW:
@@ -2084,9 +2085,9 @@
 					wake_up(&dev->fw_data->wait_fw);
 					break;
 				case S2255_RESPONSE_STATUS:
-					dev->vidstatus[cc] = pdword[3];
-					dev->vidstatus_ready[cc] = 1;
-					wake_up(&dev->wait_vidstatus[cc]);
+					channel->vidstatus = pdword[3];
+					channel->vidstatus_ready = 1;
+					wake_up(&channel->wait_vidstatus);
 					dprintk(5, "got vidstatus %x chan %d\n",
 						pdword[3], cc);
 					break;
@@ -2103,13 +2104,11 @@
 		if (!bframe)
 			return -EINVAL;
 	}
-
-
-	idx = dev->cur_frame[dev->cc];
-	frm = &dev->buffer[dev->cc].frame[idx];
-
+	channel = &dev->channel[dev->cc];
+	idx = channel->cur_frame;
+	frm = &channel->buffer.frame[idx];
 	/* search done.  now find out if should be acquiring on this channel */
-	if (!dev->b_acquire[dev->cc]) {
+	if (!channel->b_acquire) {
 		/* we found a frame, but this channel is turned off */
 		frm->ulState = S2255_READ_IDLE;
 		return -EINVAL;
@@ -2134,30 +2133,28 @@
 
 	copy_size = (pipe_info->cur_transfer_size - offset);
 
-	size = dev->pkt_size[dev->cc] - PREFIX_SIZE;
+	size = channel->pkt_size - PREFIX_SIZE;
 
 	/* sanity check on pdest */
-	if ((copy_size + frm->cur_size) < dev->req_image_size[dev->cc])
+	if ((copy_size + frm->cur_size) < channel->req_image_size)
 		memcpy(pdest, psrc, copy_size);
 
 	frm->cur_size += copy_size;
 	dprintk(4, "cur_size size %lu size %lu \n", frm->cur_size, size);
 
 	if (frm->cur_size >= size) {
-
-		u32 cc = dev->cc;
 		dprintk(2, "****************[%d]Buffer[%d]full*************\n",
-			cc, idx);
-		dev->last_frame[cc] = dev->cur_frame[cc];
-		dev->cur_frame[cc]++;
+			dev->cc, idx);
+		channel->last_frame = channel->cur_frame;
+		channel->cur_frame++;
 		/* end of system frame ring buffer, start at zero */
-		if ((dev->cur_frame[cc] == SYS_FRAMES) ||
-		    (dev->cur_frame[cc] == dev->buffer[cc].dwFrames))
-			dev->cur_frame[cc] = 0;
+		if ((channel->cur_frame == SYS_FRAMES) ||
+		    (channel->cur_frame == channel->buffer.dwFrames))
+			channel->cur_frame = 0;
 		/* frame ready */
-		if (dev->b_acquire[cc])
-			s2255_got_frame(dev, cc, dev->jpg_size[cc]);
-		dev->frame_count[cc]++;
+		if (channel->b_acquire)
+			s2255_got_frame(channel, channel->jpg_size);
+		channel->frame_count++;
 		frm->ulState = S2255_READ_IDLE;
 		frm->cur_size = 0;
 
@@ -2230,16 +2227,12 @@
  * Create the system ring buffer to copy frames into from the
  * usb read pipe.
  */
-static int s2255_create_sys_buffers(struct s2255_dev *dev, unsigned long chn)
+static int s2255_create_sys_buffers(struct s2255_channel *channel)
 {
 	unsigned long i;
 	unsigned long reqsize;
 	dprintk(1, "create sys buffers\n");
-	if (chn >= MAX_CHANNELS)
-		return -1;
-
-	dev->buffer[chn].dwFrames = SYS_FRAMES;
-
+	channel->buffer.dwFrames = SYS_FRAMES;
 	/* always allocate maximum size(PAL) for system buffers */
 	reqsize = SYS_FRAMES_MAXSIZE;
 
@@ -2248,42 +2241,40 @@
 
 	for (i = 0; i < SYS_FRAMES; i++) {
 		/* allocate the frames */
-		dev->buffer[chn].frame[i].lpvbits = vmalloc(reqsize);
-
-		dprintk(1, "valloc %p chan %lu, idx %lu, pdata %p\n",
-			&dev->buffer[chn].frame[i], chn, i,
-			dev->buffer[chn].frame[i].lpvbits);
-		dev->buffer[chn].frame[i].size = reqsize;
-		if (dev->buffer[chn].frame[i].lpvbits == NULL) {
+		channel->buffer.frame[i].lpvbits = vmalloc(reqsize);
+		dprintk(1, "valloc %p chan %d, idx %lu, pdata %p\n",
+			&channel->buffer.frame[i], channel->idx, i,
+			channel->buffer.frame[i].lpvbits);
+		channel->buffer.frame[i].size = reqsize;
+		if (channel->buffer.frame[i].lpvbits == NULL) {
 			printk(KERN_INFO "out of memory.  using less frames\n");
-			dev->buffer[chn].dwFrames = i;
+			channel->buffer.dwFrames = i;
 			break;
 		}
 	}
 
 	/* make sure internal states are set */
 	for (i = 0; i < SYS_FRAMES; i++) {
-		dev->buffer[chn].frame[i].ulState = 0;
-		dev->buffer[chn].frame[i].cur_size = 0;
+		channel->buffer.frame[i].ulState = 0;
+		channel->buffer.frame[i].cur_size = 0;
 	}
 
-	dev->cur_frame[chn] = 0;
-	dev->last_frame[chn] = -1;
+	channel->cur_frame = 0;
+	channel->last_frame = -1;
 	return 0;
 }
 
-static int s2255_release_sys_buffers(struct s2255_dev *dev,
-				     unsigned long channel)
+static int s2255_release_sys_buffers(struct s2255_channel *channel)
 {
 	unsigned long i;
 	dprintk(1, "release sys buffers\n");
 	for (i = 0; i < SYS_FRAMES; i++) {
-		if (dev->buffer[channel].frame[i].lpvbits) {
+		if (channel->buffer.frame[i].lpvbits) {
 			dprintk(1, "vfree %p\n",
-				dev->buffer[channel].frame[i].lpvbits);
-			vfree(dev->buffer[channel].frame[i].lpvbits);
+				channel->buffer.frame[i].lpvbits);
+			vfree(channel->buffer.frame[i].lpvbits);
 		}
-		dev->buffer[channel].frame[i].lpvbits = NULL;
+		channel->buffer.frame[i].lpvbits = NULL;
 	}
 	return 0;
 }
@@ -2320,17 +2311,20 @@
 			fw_ver & 0xff);
 
 	for (j = 0; j < MAX_CHANNELS; j++) {
-		dev->b_acquire[j] = 0;
-		dev->mode[j] = mode_def;
+		struct s2255_channel *channel = &dev->channel[j];
+		channel->b_acquire = 0;
+		channel->mode = mode_def;
 		if (dev->pid == 0x2257 && j > 1)
-			dev->mode[j].color |= (1 << 16);
-		dev->jc[j].quality = S2255_DEF_JPEG_QUAL;
-		dev->cur_fmt[j] = &formats[0];
-		dev->mode[j].restart = 1;
-		dev->req_image_size[j] = get_transfer_size(&mode_def);
-		dev->frame_count[j] = 0;
+			channel->mode.color |= (1 << 16);
+		channel->jc.quality = S2255_DEF_JPEG_QUAL;
+		channel->width = LINE_SZ_4CIFS_NTSC;
+		channel->height = NUM_LINES_4CIFS_NTSC * 2;
+		channel->fmt = &formats[0];
+		channel->mode.restart = 1;
+		channel->req_image_size = get_transfer_size(&mode_def);
+		channel->frame_count = 0;
 		/* create the system buffers */
-		s2255_create_sys_buffers(dev, j);
+		s2255_create_sys_buffers(channel);
 	}
 	/* start read pipe */
 	s2255_start_readpipe(dev);
@@ -2344,14 +2338,12 @@
 	dprintk(1, "%s: dev: %p", __func__,  dev);
 
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		if (dev->b_acquire[i])
-			s2255_stop_acquire(dev, i);
+		if (dev->channel[i].b_acquire)
+			s2255_stop_acquire(&dev->channel[i]);
 	}
-
 	s2255_stop_readpipe(dev);
-
 	for (i = 0; i < MAX_CHANNELS; i++)
-		s2255_release_sys_buffers(dev, i);
+		s2255_release_sys_buffers(&dev->channel[i]);
 	/* release transfer buffer */
 	kfree(dev->pipe.transfer_buffer);
 	return 0;
@@ -2444,29 +2436,26 @@
 }
 
 /* starts acquisition process */
-static int s2255_start_acquire(struct s2255_dev *dev, unsigned long chn)
+static int s2255_start_acquire(struct s2255_channel *channel)
 {
 	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
 	int j;
-	if (chn >= MAX_CHANNELS) {
-		dprintk(2, "start acquire failed, bad channel %lu\n", chn);
-		return -1;
-	}
-	chn_rev = G_chnmap[chn];
+	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	chn_rev = G_chnmap[channel->idx];
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
 		return -ENOMEM;
 	}
 
-	dev->last_frame[chn] = -1;
-	dev->bad_payload[chn] = 0;
-	dev->cur_frame[chn] = 0;
+	channel->last_frame = -1;
+	channel->bad_payload = 0;
+	channel->cur_frame = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
-		dev->buffer[chn].frame[j].ulState = 0;
-		dev->buffer[chn].frame[j].cur_size = 0;
+		channel->buffer.frame[j].ulState = 0;
+		channel->buffer.frame[j].cur_size = 0;
 	}
 
 	/* send the start command */
@@ -2477,21 +2466,18 @@
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_START error\n");
 
-	dprintk(2, "start acquire exit[%lu] %d \n", chn, res);
+	dprintk(2, "start acquire exit[%d] %d \n", channel->idx, res);
 	kfree(buffer);
 	return 0;
 }
 
-static int s2255_stop_acquire(struct s2255_dev *dev, unsigned long chn)
+static int s2255_stop_acquire(struct s2255_channel *channel)
 {
 	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
-	if (chn >= MAX_CHANNELS) {
-		dprintk(2, "stop acquire failed, bad channel %lu\n", chn);
-		return -1;
-	}
-	chn_rev = G_chnmap[chn];
+	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	chn_rev = G_chnmap[channel->idx];
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
@@ -2505,8 +2491,8 @@
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_STOP error\n");
 	kfree(buffer);
-	dev->b_acquire[chn] = 0;
-	dprintk(4, "%s: chn %lu, res %d\n", __func__, chn, res);
+	channel->b_acquire = 0;
+	dprintk(4, "%s: chn %d, res %d\n", __func__, channel->idx, res);
 	return res;
 }
 
@@ -2563,7 +2549,7 @@
 		s2255_dev_err(&interface->dev, "out of memory\n");
 		return -ENOMEM;
 	}
-	atomic_set(&dev->channels, 0);
+	atomic_set(&dev->num_channels, 0);
 	dev->pid = id->idProduct;
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
@@ -2600,8 +2586,10 @@
 	dev->timer.data = (unsigned long)dev->fw_data;
 	init_waitqueue_head(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		init_waitqueue_head(&dev->wait_setmode[i]);
-		init_waitqueue_head(&dev->wait_vidstatus[i]);
+		struct s2255_channel *channel = &dev->channel[i];
+		dev->channel[i].idx = i;
+		init_waitqueue_head(&channel->wait_setmode);
+		init_waitqueue_head(&channel->wait_vidstatus);
 	}
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2639,7 +2627,7 @@
 			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
 		if (dev->pid == 0x2257 && *pRel < S2255_MIN_DSP_COLORFILTER)
 			printk(KERN_WARNING "s2255: 2257 requires firmware %d"
-			       "or above.\n", S2255_MIN_DSP_COLORFILTER);
+			       " or above.\n", S2255_MIN_DSP_COLORFILTER);
 	}
 	usb_reset_device(dev->udev);
 	/* load 2255 board specific */
@@ -2681,25 +2669,23 @@
 {
 	struct s2255_dev *dev = to_s2255_dev(usb_get_intfdata(interface));
 	int i;
-	int channels = atomic_read(&dev->channels);
-	v4l2_device_unregister(&dev->v4l2_dev);
+	int channels = atomic_read(&dev->num_channels);
+	v4l2_device_disconnect(&dev->v4l2_dev);
 	/*see comments in the uvc_driver.c usb disconnect function */
-	atomic_inc(&dev->channels);
+	atomic_inc(&dev->num_channels);
 	/* unregister each video device. */
-	for (i = 0; i < channels; i++) {
-		if (video_is_registered(&dev->vdev[i]))
-			video_unregister_device(&dev->vdev[i]);
-	}
+	for (i = 0; i < channels; i++)
+		video_unregister_device(&dev->channel[i].vdev);
 	/* wake up any of our timers */
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
 	wake_up(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		dev->setmode_ready[i] = 1;
-		wake_up(&dev->wait_setmode[i]);
-		dev->vidstatus_ready[i] = 1;
-		wake_up(&dev->wait_vidstatus[i]);
+		dev->channel[i].setmode_ready = 1;
+		wake_up(&dev->channel[i].wait_setmode);
+		dev->channel[i].vidstatus_ready = 1;
+		wake_up(&dev->channel[i].wait_vidstatus);
 	}
-	if (atomic_dec_and_test(&dev->channels))
+	if (atomic_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	dev_info(&interface->dev, "%s\n", __func__);
 }

