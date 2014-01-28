Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway13.websitewelcome.com ([69.93.154.15]:52009 "EHLO
	gateway13.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932266AbaA1X4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jan 2014 18:56:35 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway13.websitewelcome.com (Postfix) with ESMTP id C850F60591FC1
	for <linux-media@vger.kernel.org>; Tue, 28 Jan 2014 17:31:35 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Jan 2014 17:31:34 -0600
From: dean@sensoray.com
To: <linux-media@vger.kernel.org>
Cc: <hverkuil@xs4all.nl>, <linux-dev@sensoray.com>
Subject: [PATCH]: s2255drv: checkpatch fix: coding style fix
Message-ID: <aaaf620bc50c7b8a8c725266fa82e1a4@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes all style warnings from scripts/checkpatch -f

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
  drivers/media/usb/s2255/s2255drv.c |  328 
++++++++++++++++--------------------
  1 file changed, 147 insertions(+), 181 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c 
b/drivers/media/usb/s2255/s2255drv.c
index 6bc9b8e..c938b02 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -259,7 +259,7 @@ struct s2255_channel {

  struct s2255_dev {
  	struct s2255_channel    channel[MAX_CHANNELS];
-	struct v4l2_device 	v4l2_dev;
+	struct v4l2_device      v4l2_dev;
  	atomic_t                num_channels;
  	int			frames;
  	struct mutex		lock;	/* channels[].vdev.lock */
@@ -352,7 +352,6 @@ struct s2255_fh {
  static unsigned long G_chnmap[MAX_CHANNELS] = {3, 2, 1, 0};

  static int debug;
-static int *s2255_debug = &debug;

  static int s2255_start_readpipe(struct s2255_dev *dev);
  static void s2255_stop_readpipe(struct s2255_dev *dev);
@@ -373,13 +372,8 @@ static long s2255_vendor_req(struct s2255_dev 
*dev, unsigned char req,
  #define s2255_dev_err(dev, fmt, arg...)					\
  		dev_err(dev, S2255_DRIVER_NAME " - " fmt, ##arg)

-#define dprintk(level, fmt, arg...)					\
-	do {								\
-		if (*s2255_debug >= (level)) {				\
-			printk(KERN_DEBUG S2255_DRIVER_NAME		\
-				": " fmt, ##arg);			\
-		}							\
-	} while (0)
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)

  static struct usb_driver s2255_driver;

@@ -498,7 +492,7 @@ static void planar422p_to_yuv_packed(const unsigned 
char *in,
  static void s2255_reset_dsppower(struct s2255_dev *dev)
  {
  	s2255_vendor_req(dev, 0x40, 0x0000, 0x0001, NULL, 0, 1);
-	msleep(10);
+	msleep(20);
  	s2255_vendor_req(dev, 0x50, 0x0000, 0x0000, NULL, 0, 1);
  	msleep(600);
  	s2255_vendor_req(dev, 0x10, 0x0000, 0x0000, NULL, 0, 1);
@@ -510,9 +504,8 @@ static void s2255_reset_dsppower(struct s2255_dev 
*dev)
  static void s2255_timer(unsigned long user_data)
  {
  	struct s2255_fw *data = (struct s2255_fw *)user_data;
-	dprintk(100, "%s\n", __func__);
  	if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
-		printk(KERN_ERR "s2255: can't submit urb\n");
+		pr_err("s2255: can't submit urb\n");
  		atomic_set(&data->fw_state, S2255_FW_FAILED);
  		/* wake up anything waiting for the firmware */
  		wake_up(&data->wait_fw);
@@ -532,7 +525,6 @@ static void s2255_fwchunk_complete(struct urb *urb)
  	struct s2255_fw *data = urb->context;
  	struct usb_device *udev = urb->dev;
  	int len;
-	dprintk(100, "%s: udev %p urb %p", __func__, udev, urb);
  	if (urb->status) {
  		dev_err(&udev->dev, "URB failed with status %d\n", urb->status);
  		atomic_set(&data->fw_state, S2255_FW_FAILED);
@@ -559,9 +551,6 @@ static void s2255_fwchunk_complete(struct urb *urb)
  		if (len < CHUNK_SIZE)
  			memset(data->pfw_data, 0, CHUNK_SIZE);

-		dprintk(100, "completed len %d, loaded %d \n", len,
-			data->fw_loaded);
-
  		memcpy(data->pfw_data,
  		       (char *) data->fw->data + data->fw_loaded, len);

@@ -576,10 +565,8 @@ static void s2255_fwchunk_complete(struct urb 
*urb)
  			return;
  		}
  		data->fw_loaded += len;
-	} else {
+	} else
  		atomic_set(&data->fw_state, S2255_FW_LOADED_DSPWAIT);
-		dprintk(100, "%s: firmware upload complete\n", __func__);
-	}
  	return;

  }
@@ -593,7 +580,7 @@ static int s2255_got_frame(struct s2255_channel 
*channel, int jpgsize)
  	int rc = 0;
  	spin_lock_irqsave(&dev->slock, flags);
  	if (list_empty(&dma_q->active)) {
-		dprintk(1, "No active queue to serve\n");
+		dprintk(dev, 1, "No active queue to serve\n");
  		rc = -1;
  		goto unlock;
  	}
@@ -603,7 +590,7 @@ static int s2255_got_frame(struct s2255_channel 
*channel, int jpgsize)
  	v4l2_get_timestamp(&buf->vb.ts);
  	s2255_fillbuff(channel, buf, jpgsize);
  	wake_up(&buf->vb.done);
-	dprintk(2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
+	dprintk(dev, 2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
  unlock:
  	spin_unlock_irqrestore(&dev->slock, flags);
  	return rc;
@@ -615,9 +602,9 @@ static const struct s2255_fmt *format_by_fourcc(int 
fourcc)
  	for (i = 0; i < ARRAY_SIZE(formats); i++) {
  		if (-1 == formats[i].fourcc)
  			continue;
-	if (!jpeg_enable && ((formats[i].fourcc == V4L2_PIX_FMT_JPEG) ||
-			     (formats[i].fourcc == V4L2_PIX_FMT_MJPEG)))
-	    continue;
+		if (!jpeg_enable && ((formats[i].fourcc == V4L2_PIX_FMT_JPEG) ||
+				     (formats[i].fourcc == V4L2_PIX_FMT_MJPEG)))
+			continue;
  		if (formats[i].fourcc == fourcc)
  			return formats + i;
  	}
@@ -667,18 +654,17 @@ static void s2255_fillbuff(struct s2255_channel 
*channel,
  			       buf->vb.width * buf->vb.height * 2);
  			break;
  		default:
-			printk(KERN_DEBUG "s2255: unknown format?\n");
+			pr_info("s2255: unknown format?\n");
  		}
  		channel->last_frame = -1;
  	} else {
-		printk(KERN_ERR "s2255: =======no frame\n");
+		pr_err("s2255: =======no frame\n");
  		return;
-
  	}
-	dprintk(2, "s2255fill at : Buffer 0x%08lx size= %d\n",
-		(unsigned long)vbuf, pos);
+	if (debug >= 2)
+		pr_debug("s2255fill at : Buffer 0x%08lx size= %d\n",
+		       (unsigned long)vbuf, pos);
  	/* tell v4l buffer was filled */
-
  	buf->vb.field_count = channel->frame_count * 2;
  	v4l2_get_timestamp(&buf->vb.ts);
  	buf->vb.state = VIDEOBUF_DONE;
@@ -707,8 +693,6 @@ static int buffer_setup(struct videobuf_queue *vq, 
unsigned int *count,

  static void free_buffer(struct videobuf_queue *vq, struct s2255_buffer 
*buf)
  {
-	dprintk(4, "%s\n", __func__);
-
  	videobuf_vmalloc_free(&buf->vb);
  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
  }
@@ -722,7 +706,7 @@ static int buffer_prepare(struct videobuf_queue 
*vq, struct videobuf_buffer *vb,
  	int rc;
  	int w = channel->width;
  	int h = channel->height;
-	dprintk(4, "%s, field=%d\n", __func__, field);
+	dprintk(fh->dev, 4, "%s, field=%d\n", __func__, field);
  	if (channel->fmt == NULL)
  		return -EINVAL;

@@ -730,12 +714,12 @@ static int buffer_prepare(struct videobuf_queue 
*vq, struct videobuf_buffer *vb,
  	    (w > norm_maxw(channel)) ||
  	    (h < norm_minh(channel)) ||
  	    (h > norm_maxh(channel))) {
-		dprintk(4, "invalid buffer prepare\n");
+		dprintk(fh->dev, 4, "invalid buffer prepare\n");
  		return -EINVAL;
  	}
  	buf->vb.size = w * h * (channel->fmt->depth >> 3);
  	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size) {
-		dprintk(4, "invalid buffer prepare\n");
+		dprintk(fh->dev, 4, "invalid buffer prepare\n");
  		return -EINVAL;
  	}

@@ -763,7 +747,7 @@ static void buffer_queue(struct videobuf_queue *vq, 
struct videobuf_buffer *vb)
  	struct s2255_fh *fh = vq->priv_data;
  	struct s2255_channel *channel = fh->channel;
  	struct s2255_dmaqueue *vidq = &channel->vidq;
-	dprintk(1, "%s\n", __func__);
+	dprintk(fh->dev, 1, "%s\n", __func__);
  	buf->vb.state = VIDEOBUF_QUEUED;
  	list_add_tail(&buf->vb.queue, &vidq->active);
  }
@@ -773,7 +757,7 @@ static void buffer_release(struct videobuf_queue 
*vq,
  {
  	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
  	struct s2255_fh *fh = vq->priv_data;
-	dprintk(4, "%s %d\n", __func__, fh->channel->idx);
+	dprintk(fh->dev, 4, "%s %d\n", __func__, fh->channel->idx);
  	free_buffer(vq, buf);
  }

@@ -794,7 +778,7 @@ static int res_get(struct s2255_fh *fh)
  	/* it's free, grab it */
  	channel->resources = 1;
  	fh->resources = 1;
-	dprintk(1, "s2255: res: get\n");
+	dprintk(fh->dev, 1, "s2255: res: get\n");
  	return 1;
  }

@@ -814,7 +798,6 @@ static void res_free(struct s2255_fh *fh)
  	struct s2255_channel *channel = fh->channel;
  	channel->resources = 0;
  	fh->resources = 0;
-	dprintk(1, "res: put\n");
  }

  static int vidioc_querycap(struct file *file, void *priv,
@@ -841,7 +824,6 @@ static int vidioc_enum_fmt_vid_cap(struct file 
*file, void *priv,
  	if (!jpeg_enable && ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
  			(formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
  		return -EINVAL;
-	dprintk(4, "name %s\n", formats[index].name);
  	strlcpy(f->description, formats[index].name, sizeof(f->description));
  	f->pixelformat = formats[index].fourcc;
  	return 0;
@@ -885,7 +867,7 @@ static int vidioc_try_fmt_vid_cap(struct file 
*file, void *priv,

  	field = f->fmt.pix.field;

-	dprintk(50, "%s NTSC: %d suggested width: %d, height: %d\n",
+	dprintk(fh->dev, 50, "%s NTSC: %d suggested width: %d, height: %d\n",
  		__func__, is_ntsc, f->fmt.pix.width, f->fmt.pix.height);
  	if (is_ntsc) {
  		/* NTSC */
@@ -927,7 +909,7 @@ static int vidioc_try_fmt_vid_cap(struct file 
*file, void *priv,
  	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
  	f->fmt.pix.priv = 0;
-	dprintk(50, "%s: set width %d height %d field %d\n", __func__,
+	dprintk(fh->dev, 50, "%s: set width %d height %d field %d\n", 
__func__,
  		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
  	return 0;
  }
@@ -955,13 +937,13 @@ static int vidioc_s_fmt_vid_cap(struct file 
*file, void *priv,
  	mutex_lock(&q->vb_lock);

  	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		dprintk(1, "queue busy\n");
+		dprintk(fh->dev, 1, "queue busy\n");
  		ret = -EBUSY;
  		goto out_s_fmt;
  	}

  	if (res_locked(fh)) {
-		dprintk(1, "%s: channel busy\n", __func__);
+		dprintk(fh->dev, 1, "%s: channel busy\n", __func__);
  		ret = -EBUSY;
  		goto out_s_fmt;
  	}
@@ -1160,7 +1142,7 @@ static int s2255_set_mode(struct s2255_channel 
*channel,
  	int i;

  	chn_rev = G_chnmap[channel->idx];
-	dprintk(3, "%s channel: %d\n", __func__, channel->idx);
+	dprintk(dev, 3, "%s channel: %d\n", __func__, channel->idx);
  	/* if JPEG, set the quality */
  	if ((mode->color & MASK_COLOR) == COLOR_JPG) {
  		mode->color &= ~MASK_COLOR;
@@ -1171,7 +1153,7 @@ static int s2255_set_mode(struct s2255_channel 
*channel,
  	/* save the mode */
  	channel->mode = *mode;
  	channel->req_image_size = get_transfer_size(mode);
-	dprintk(1, "%s: reqsize %ld\n", __func__, channel->req_image_size);
+	dprintk(dev, 1, "%s: reqsize %ld\n", __func__, 
channel->req_image_size);
  	buffer = kzalloc(512, GFP_KERNEL);
  	if (buffer == NULL) {
  		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1194,13 +1176,13 @@ static int s2255_set_mode(struct s2255_channel 
*channel,
  				   (channel->setmode_ready != 0),
  				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
  		if (channel->setmode_ready != 1) {
-			printk(KERN_DEBUG "s2255: no set mode response\n");
+			dprintk(dev, 0, "s2255: no set mode response\n");
  			res = -EFAULT;
  		}
  	}
  	/* clear the restart flag */
  	channel->mode.restart = 0;
-	dprintk(1, "%s chn %d, result: %d\n", __func__, channel->idx, res);
+	dprintk(dev, 1, "%s chn %d, result: %d\n", __func__, channel->idx, 
res);
  	return res;
  }

@@ -1211,7 +1193,7 @@ static int s2255_cmd_status(struct s2255_channel 
*channel, u32 *pstatus)
  	u32 chn_rev;
  	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
  	chn_rev = G_chnmap[channel->idx];
-	dprintk(4, "%s chan %d\n", __func__, channel->idx);
+	dprintk(dev, 4, "%s chan %d\n", __func__, channel->idx);
  	buffer = kzalloc(512, GFP_KERNEL);
  	if (buffer == NULL) {
  		dev_err(&dev->udev->dev, "out of mem\n");
@@ -1229,11 +1211,11 @@ static int s2255_cmd_status(struct 
s2255_channel *channel, u32 *pstatus)
  			   (channel->vidstatus_ready != 0),
  			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
  	if (channel->vidstatus_ready != 1) {
-		printk(KERN_DEBUG "s2255: no vidstatus response\n");
+		dprintk(dev, 0, "s2255: no vidstatus response\n");
  		res = -EFAULT;
  	}
  	*pstatus = channel->vidstatus;
-	dprintk(4, "%s, vid status %d\n", __func__, *pstatus);
+	dprintk(dev, 4, "%s, vid status %d\n", __func__, *pstatus);
  	return res;
  }

@@ -1244,7 +1226,7 @@ static int vidioc_streamon(struct file *file, 
void *priv, enum v4l2_buf_type i)
  	struct s2255_dev *dev = fh->dev;
  	struct s2255_channel *channel = fh->channel;
  	int j;
-	dprintk(4, "%s\n", __func__);
+	dprintk(dev, 4, "%s\n", __func__);
  	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
  		dev_err(&dev->udev->dev, "invalid fh type0\n");
  		return -EINVAL;
@@ -1279,15 +1261,13 @@ static int vidioc_streamon(struct file *file, 
void *priv, enum v4l2_buf_type i)
  static int vidioc_streamoff(struct file *file, void *priv, enum 
v4l2_buf_type i)
  {
  	struct s2255_fh *fh = priv;
-	dprintk(4, "%s\n, channel: %d", __func__, fh->channel->idx);
+	dprintk(fh->dev, 4, "%s\n, channel: %d", __func__, fh->channel->idx);
  	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		printk(KERN_ERR "invalid fh type0\n");
+		dprintk(fh->dev, 1, "invalid fh type0\n");
  		return -EINVAL;
  	}
-	if (i != fh->type) {
-		printk(KERN_ERR "invalid type i\n");
+	if (i != fh->type)
  		return -EINVAL;
-	}
  	s2255_stop_acquire(fh->channel);
  	videobuf_streamoff(&fh->vb_vidq);
  	res_free(fh);
@@ -1304,13 +1284,13 @@ static int vidioc_s_std(struct file *file, void 
*priv, v4l2_std_id i)

  	mutex_lock(&q->vb_lock);
  	if (res_locked(fh)) {
-		dprintk(1, "can't change standard after started\n");
+		dprintk(fh->dev, 1, "can't change standard after started\n");
  		ret = -EBUSY;
  		goto out_s_std;
  	}
  	mode = fh->channel->mode;
  	if (i & V4L2_STD_525_60) {
-		dprintk(4, "%s 60 Hz\n", __func__);
+		dprintk(fh->dev, 4, "%s 60 Hz\n", __func__);
  		/* if changing format, reset frame decimation/intervals */
  		if (mode.format != FORMAT_NTSC) {
  			mode.restart = 1;
@@ -1320,7 +1300,7 @@ static int vidioc_s_std(struct file *file, void 
*priv, v4l2_std_id i)
  			channel->height = NUM_LINES_4CIFS_NTSC * 2;
  		}
  	} else if (i & V4L2_STD_625_50) {
-		dprintk(4, "%s 50 Hz\n", __func__);
+		dprintk(fh->dev, 4, "%s 50 Hz\n", __func__);
  		if (mode.format != FORMAT_PAL) {
  			mode.restart = 1;
  			mode.format = FORMAT_PAL;
@@ -1370,7 +1350,8 @@ static int vidioc_enum_input(struct file *file, 
void *priv,
  	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
  		int rc;
  		rc = s2255_cmd_status(fh->channel, &status);
-		dprintk(4, "s2255_cmd_status rc: %d status %x\n", rc, status);
+		dprintk(dev, 4, "s2255_cmd_status rc: %d status %x\n",
+			rc, status);
  		if (rc == 0)
  			inp->status =  (status & 0x01) ? 0
  				: V4L2_IN_ST_NO_SIGNAL;
@@ -1405,10 +1386,7 @@ static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
  	struct s2255_channel *channel =
  		container_of(ctrl->handler, struct s2255_channel, hdl);
  	struct s2255_mode mode;
-
  	mode = channel->mode;
-	dprintk(4, "%s\n", __func__);
-
  	/* update the mode to the corresponding value */
  	switch (ctrl->id) {
  	case V4L2_CID_BRIGHTNESS:
@@ -1450,7 +1428,7 @@ static int vidioc_g_jpegcomp(struct file *file, 
void *priv,

  	memset(jc, 0, sizeof(*jc));
  	jc->quality = channel->jpegqual;
-	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
+	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
  	return 0;
  }

@@ -1462,7 +1440,7 @@ static int vidioc_s_jpegcomp(struct file *file, 
void *priv,
  	if (jc->quality < 0 || jc->quality > 100)
  		return -EINVAL;
  	v4l2_ctrl_s_ctrl(channel->jpegqual_ctrl, jc->quality);
-	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
+	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
  	return 0;
  }

@@ -1494,7 +1472,8 @@ static int vidioc_g_parm(struct file *file, void 
*priv,
  		sp->parm.capture.timeperframe.numerator = def_num * 5;
  		break;
  	}
-	dprintk(4, "%s capture mode, %d timeperframe %d/%d\n", __func__,
+	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
+		__func__,
  		sp->parm.capture.capturemode,
  		sp->parm.capture.timeperframe.numerator,
  		sp->parm.capture.timeperframe.denominator);
@@ -1535,7 +1514,7 @@ static int vidioc_s_parm(struct file *file, void 
*priv,
  	mode.fdec = fdec;
  	sp->parm.capture.timeperframe.denominator = def_dem;
  	s2255_set_mode(channel, &mode);
-	dprintk(4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
+	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec 
%d\n",
  		__func__,
  		sp->parm.capture.capturemode,
  		sp->parm.capture.timeperframe.numerator,
@@ -1604,7 +1583,8 @@ static int vidioc_enum_frameintervals(struct file 
*file, void *priv,
  	fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
  	fe->discrete.denominator = is_ntsc ? 30000 : 25000;
  	fe->discrete.numerator = (is_ntsc ? 1001 : 1000) * 
frm_dec[fe->index];
-	dprintk(4, "%s discrete %d/%d\n", __func__, fe->discrete.numerator,
+	dprintk(fh->dev, 4, "%s discrete %d/%d\n", __func__,
+		fe->discrete.numerator,
  		fe->discrete.denominator);
  	return 0;
  }
@@ -1617,7 +1597,7 @@ static int __s2255_open(struct file *file)
  	struct s2255_fh *fh;
  	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  	int state;
-	dprintk(1, "s2255: open called (dev=%s)\n",
+	dprintk(dev, 1, "s2255: open called (dev=%s)\n",
  		video_device_node_name(vdev));
  	state = atomic_read(&dev->fw_data->fw_state);
  	switch (state) {
@@ -1640,7 +1620,7 @@ static int __s2255_open(struct file *file)
  	case S2255_FW_LOADED_DSPWAIT:
  		/* give S2255_LOAD_TIMEOUT time for firmware to load in case
  		   driver loaded and then device immediately opened */
-		printk(KERN_INFO "%s waiting for firmware load\n", __func__);
+		pr_info("%s waiting for firmware load\n", __func__);
  		wait_event_timeout(dev->fw_data->wait_fw,
  				   ((atomic_read(&dev->fw_data->fw_state)
  				     == S2255_FW_SUCCESS) ||
@@ -1659,16 +1639,15 @@ static int __s2255_open(struct file *file)
  	case S2255_FW_SUCCESS:
  		break;
  	case S2255_FW_FAILED:
-		printk(KERN_INFO "2255 firmware load failed.\n");
+		pr_info("2255 firmware load failed.\n");
  		return -ENODEV;
  	case S2255_FW_DISCONNECTING:
-		printk(KERN_INFO "%s: disconnecting\n", __func__);
+		pr_info("%s: disconnecting\n", __func__);
  		return -ENODEV;
  	case S2255_FW_LOADED_DSPWAIT:
  	case S2255_FW_NOTLOADED:
-		printk(KERN_INFO "%s: firmware not loaded yet"
-		       "please try again later\n",
-		       __func__);
+		pr_info("%s: firmware not loaded, please retry\n",
+			__func__);
  		/*
  		 * Timeout on firmware load means device unusable.
  		 * Set firmware failure state.
@@ -1678,7 +1657,7 @@ static int __s2255_open(struct file *file)
  			   S2255_FW_FAILED);
  		return -EAGAIN;
  	default:
-		printk(KERN_INFO "%s: unknown state\n", __func__);
+		pr_info("%s: unknown state\n", __func__);
  		return -EFAULT;
  	}
  	/* allocate + initialize per filehandle data */
@@ -1697,12 +1676,12 @@ static int __s2255_open(struct file *file)
  		s2255_set_mode(channel, &channel->mode);
  		channel->configured = 1;
  	}
-	dprintk(1, "%s: dev=%s type=%s\n", __func__,
+	dprintk(dev, 1, "%s: dev=%s type=%s\n", __func__,
  		video_device_node_name(vdev), v4l2_type_names[type]);
-	dprintk(2, "%s: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n", __func__,
+	dprintk(dev, 2, "%s: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n", 
__func__,
  		(unsigned long)fh, (unsigned long)dev,
  		(unsigned long)&channel->vidq);
-	dprintk(4, "%s: list_empty active=%d\n", __func__,
+	dprintk(dev, 4, "%s: list_empty active=%d\n", __func__,
  		list_empty(&channel->vidq.active));
  	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
  				    NULL, &dev->slock,
@@ -1732,7 +1711,7 @@ static unsigned int s2255_poll(struct file *file,
  	struct s2255_dev *dev = fh->dev;
  	int rc = v4l2_ctrl_poll(file, wait);

-	dprintk(100, "%s\n", __func__);
+	dprintk(dev, 100, "%s\n", __func__);
  	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
  		return POLLERR;
  	mutex_lock(&dev->lock);
@@ -1743,6 +1722,7 @@ static unsigned int s2255_poll(struct file *file,

  static void s2255_destroy(struct s2255_dev *dev)
  {
+	dprintk(dev, 1, "%s", __func__);
  	/* board shutdown stops the read pipe if it is running */
  	s2255_board_shutdown(dev);
  	/* make sure firmware still not trying to load */
@@ -1760,7 +1740,6 @@ static void s2255_destroy(struct s2255_dev *dev)
  	mutex_destroy(&dev->lock);
  	usb_put_dev(dev->udev);
  	v4l2_device_unregister(&dev->v4l2_dev);
-	dprintk(1, "%s", __func__);
  	kfree(dev);
  }

@@ -1782,7 +1761,7 @@ static int s2255_release(struct file *file)
  	}
  	videobuf_mmap_free(&fh->vb_vidq);
  	mutex_unlock(&dev->lock);
-	dprintk(1, "%s (dev=%s)\n", __func__, video_device_node_name(vdev));
+	dprintk(dev, 1, "%s[%s]\n", __func__, video_device_node_name(vdev));
  	v4l2_fh_del(&fh->fh);
  	v4l2_fh_exit(&fh->fh);
  	kfree(fh);
@@ -1794,16 +1773,15 @@ static int s2255_mmap_v4l(struct file *file, 
struct vm_area_struct *vma)
  	struct s2255_fh *fh = file->private_data;
  	struct s2255_dev *dev;
  	int ret;
-
  	if (!fh)
  		return -ENODEV;
  	dev = fh->dev;
-	dprintk(4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
+	dprintk(dev, 4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
  	if (mutex_lock_interruptible(&dev->lock))
  		return -ERESTARTSYS;
  	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
  	mutex_unlock(&dev->lock);
-	dprintk(4, "%s vma start=0x%08lx, size=%ld, ret=%d\n", __func__,
+	dprintk(dev, 4, "%s vma start=0x%08lx, size=%ld, ret=%d\n", __func__,
  		(unsigned long)vma->vm_start,
  		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start, ret);
  	return ret;
@@ -1852,10 +1830,11 @@ static void s2255_video_device_release(struct 
video_device *vdev)
  	struct s2255_channel *channel =
  		container_of(vdev, struct s2255_channel, vdev);

-	v4l2_ctrl_handler_free(&channel->hdl);
-	dprintk(4, "%s, chnls: %d\n", __func__,
+	dprintk(dev, 4, "%s, chnls: %d\n", __func__,
  		atomic_read(&dev->num_channels));

+	v4l2_ctrl_handler_free(&channel->hdl);
+
  	if (atomic_dec_and_test(&dev->num_channels))
  		s2255_destroy(dev);
  	return;
@@ -1913,7 +1892,8 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
  				0, 100, 1, S2255_DEF_JPEG_QUAL);
  		if (dev->dsp_fw_ver >= S2255_MIN_DSP_COLORFILTER &&
  		    (dev->pid != 0x2257 || channel->idx <= 1))
-			v4l2_ctrl_new_custom(&channel->hdl, &color_filter_ctrl, NULL);
+			v4l2_ctrl_new_custom(&channel->hdl, &color_filter_ctrl,
+					     NULL);
  		if (channel->hdl.error) {
  			ret = channel->hdl.error;
  			v4l2_ctrl_handler_free(&channel->hdl);
@@ -1947,15 +1927,15 @@ static int s2255_probe_v4l(struct s2255_dev 
*dev)
  			  video_device_node_name(&channel->vdev));

  	}
-	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %s\n",
-	       S2255_VERSION);
+	pr_info("Sensoray 2255 V4L driver Revision: %s\n",
+		S2255_VERSION);
  	/* if no channels registered, return error and probe will fail*/
  	if (atomic_read(&dev->num_channels) == 0) {
  		v4l2_device_unregister(&dev->v4l2_dev);
  		return ret;
  	}
  	if (atomic_read(&dev->num_channels) != MAX_CHANNELS)
-		printk(KERN_WARNING "s2255: Not all channels available.\n");
+		pr_warn("s2255: Not all channels available.\n");
  	return 0;
  }

@@ -1981,11 +1961,11 @@ static int save_frame(struct s2255_dev *dev, 
struct s2255_pipeinfo *pipe_info)
  	s32 idx = -1;
  	struct s2255_framei *frm;
  	unsigned char *pdata;
-	struct s2255_channel *channel;
-	dprintk(100, "buffer to user\n");
-	channel = &dev->channel[dev->cc];
-	idx = channel->cur_frame;
-	frm = &channel->buffer.frame[idx];
+	struct s2255_channel *ch;
+	dprintk(dev, 100, "buffer to user\n");
+	ch = &dev->channel[dev->cc];
+	idx = ch->cur_frame;
+	frm = &ch->buffer.frame[idx];
  	if (frm->ulState == S2255_READ_IDLE) {
  		int jj;
  		unsigned int cc;
@@ -1997,28 +1977,27 @@ static int save_frame(struct s2255_dev *dev, 
struct s2255_pipeinfo *pipe_info)
  		for (jj = 0; jj < (pipe_info->cur_transfer_size - 12); jj++) {
  			switch (*pdword) {
  			case S2255_MARKER_FRAME:
-				dprintk(4, "found frame marker at offset:"
-					" %d [%x %x]\n", jj, pdata[0],
-					pdata[1]);
+				dprintk(dev, 4, "marker @ offset: %d [%x %x]\n",
+					jj, pdata[0], pdata[1]);
  				offset = jj + PREFIX_SIZE;
  				bframe = 1;
  				cc = le32_to_cpu(pdword[1]);
  				if (cc >= MAX_CHANNELS) {
-					printk(KERN_ERR
-					       "bad channel\n");
+					dprintk(dev, 0,
+						"bad channel\n");
  					return -EINVAL;
  				}
  				/* reverse it */
  				dev->cc = G_chnmap[cc];
-				channel = &dev->channel[dev->cc];
+				ch = &dev->channel[dev->cc];
  				payload =  le32_to_cpu(pdword[3]);
-				if (payload > channel->req_image_size) {
-					channel->bad_payload++;
+				if (payload > ch->req_image_size) {
+					ch->bad_payload++;
  					/* discard the bad frame */
  					return -EINVAL;
  				}
-				channel->pkt_size = payload;
-				channel->jpg_size = le32_to_cpu(pdword[4]);
+				ch->pkt_size = payload;
+				ch->jpg_size = le32_to_cpu(pdword[4]);
  				break;
  			case S2255_MARKER_RESPONSE:

@@ -2029,34 +2008,34 @@ static int save_frame(struct s2255_dev *dev, 
struct s2255_pipeinfo *pipe_info)
  				cc = G_chnmap[le32_to_cpu(pdword[1])];
  				if (cc >= MAX_CHANNELS)
  					break;
-				channel = &dev->channel[cc];
+				ch = &dev->channel[cc];
  				switch (pdword[2]) {
  				case S2255_RESPONSE_SETMODE:
  					/* check if channel valid */
  					/* set mode ready */
-					channel->setmode_ready = 1;
-					wake_up(&channel->wait_setmode);
-					dprintk(5, "setmode ready %d\n", cc);
+					ch->setmode_ready = 1;
+					wake_up(&ch->wait_setmode);
+					dprintk(dev, 5, "setmode rdy %d\n", cc);
  					break;
  				case S2255_RESPONSE_FW:
  					dev->chn_ready |= (1 << cc);
  					if ((dev->chn_ready & 0x0f) != 0x0f)
  						break;
  					/* all channels ready */
-					printk(KERN_INFO "s2255: fw loaded\n");
+					pr_info("s2255: fw loaded\n");
  					atomic_set(&dev->fw_data->fw_state,
  						   S2255_FW_SUCCESS);
  					wake_up(&dev->fw_data->wait_fw);
  					break;
  				case S2255_RESPONSE_STATUS:
-					channel->vidstatus = le32_to_cpu(pdword[3]);
-					channel->vidstatus_ready = 1;
-					wake_up(&channel->wait_vidstatus);
-					dprintk(5, "got vidstatus %x chan %d\n",
+					ch->vidstatus = le32_to_cpu(pdword[3]);
+					ch->vidstatus_ready = 1;
+					wake_up(&ch->wait_vidstatus);
+					dprintk(dev, 5, "vstat %x chan %d\n",
  						le32_to_cpu(pdword[3]), cc);
  					break;
  				default:
-					printk(KERN_INFO "s2255 unknown resp\n");
+					pr_info("s2255 unknown resp\n");
  				}
  			default:
  				pdata++;
@@ -2068,11 +2047,11 @@ static int save_frame(struct s2255_dev *dev, 
struct s2255_pipeinfo *pipe_info)
  		if (!bframe)
  			return -EINVAL;
  	}
-	channel = &dev->channel[dev->cc];
-	idx = channel->cur_frame;
-	frm = &channel->buffer.frame[idx];
+	ch = &dev->channel[dev->cc];
+	idx = ch->cur_frame;
+	frm = &ch->buffer.frame[idx];
  	/* search done.  now find out if should be acquiring on this channel 
*/
-	if (!channel->b_acquire) {
+	if (!ch->b_acquire) {
  		/* we found a frame, but this channel is turned off */
  		frm->ulState = S2255_READ_IDLE;
  		return -EINVAL;
@@ -2088,7 +2067,7 @@ static int save_frame(struct s2255_dev *dev, 
struct s2255_pipeinfo *pipe_info)


  	if (frm->lpvbits == NULL) {
-		dprintk(1, "s2255 frame buffer == NULL.%p %p %d %d",
+		dprintk(dev, 1, "s2255 frame buffer == NULL.%p %p %d %d",
  			frm, dev, dev->cc, idx);
  		return -ENOMEM;
  	}
@@ -2097,28 +2076,28 @@ static int save_frame(struct s2255_dev *dev, 
struct s2255_pipeinfo *pipe_info)

  	copy_size = (pipe_info->cur_transfer_size - offset);

-	size = channel->pkt_size - PREFIX_SIZE;
+	size = ch->pkt_size - PREFIX_SIZE;

  	/* sanity check on pdest */
-	if ((copy_size + frm->cur_size) < channel->req_image_size)
+	if ((copy_size + frm->cur_size) < ch->req_image_size)
  		memcpy(pdest, psrc, copy_size);

  	frm->cur_size += copy_size;
-	dprintk(4, "cur_size size %lu size %lu \n", frm->cur_size, size);
+	dprintk(dev, 4, "cur_size: %lu, size: %lu\n", frm->cur_size, size);

  	if (frm->cur_size >= size) {
-		dprintk(2, "****************[%d]Buffer[%d]full*************\n",
+		dprintk(dev, 2, "******[%d]Buffer[%d]full*******\n",
  			dev->cc, idx);
-		channel->last_frame = channel->cur_frame;
-		channel->cur_frame++;
+		ch->last_frame = ch->cur_frame;
+		ch->cur_frame++;
  		/* end of system frame ring buffer, start at zero */
-		if ((channel->cur_frame == SYS_FRAMES) ||
-		    (channel->cur_frame == channel->buffer.dwFrames))
-			channel->cur_frame = 0;
+		if ((ch->cur_frame == SYS_FRAMES) ||
+		    (ch->cur_frame == ch->buffer.dwFrames))
+			ch->cur_frame = 0;
  		/* frame ready */
-		if (channel->b_acquire)
-			s2255_got_frame(channel, channel->jpg_size);
-		channel->frame_count++;
+		if (ch->b_acquire)
+			s2255_got_frame(ch, ch->jpg_size);
+		ch->frame_count++;
  		frm->ulState = S2255_READ_IDLE;
  		frm->cur_size = 0;

@@ -2131,7 +2110,7 @@ static void s2255_read_video_callback(struct 
s2255_dev *dev,
  				      struct s2255_pipeinfo *pipe_info)
  {
  	int res;
-	dprintk(50, "callback read video \n");
+	dprintk(dev, 50, "callback read video\n");

  	if (dev->cc >= MAX_CHANNELS) {
  		dev->cc = 0;
@@ -2141,9 +2120,9 @@ static void s2255_read_video_callback(struct 
s2255_dev *dev,
  	/* otherwise copy to the system buffers */
  	res = save_frame(dev, pipe_info);
  	if (res != 0)
-		dprintk(4, "s2255: read callback failed\n");
+		dprintk(dev, 4, "s2255: read callback failed\n");

-	dprintk(50, "callback read video done\n");
+	dprintk(dev, 50, "callback read video done\n");
  	return;
  }

@@ -2181,9 +2160,9 @@ static int s2255_get_fx2fw(struct s2255_dev *dev)
  	ret = s2255_vendor_req(dev, S2255_VR_FW, 0, 0, transBuffer, 2,
  			       S2255_VR_IN);
  	if (ret < 0)
-		dprintk(2, "get fw error: %x\n", ret);
+		dprintk(dev, 2, "get fw error: %x\n", ret);
  	fw = transBuffer[0] + (transBuffer[1] << 8);
-	dprintk(2, "Get FW %x %x\n", transBuffer[0], transBuffer[1]);
+	dprintk(dev, 2, "Get FW %x %x\n", transBuffer[0], transBuffer[1]);
  	return fw;
  }

@@ -2195,7 +2174,6 @@ static int s2255_create_sys_buffers(struct 
s2255_channel *channel)
  {
  	unsigned long i;
  	unsigned long reqsize;
-	dprintk(1, "create sys buffers\n");
  	channel->buffer.dwFrames = SYS_FRAMES;
  	/* always allocate maximum size(PAL) for system buffers */
  	reqsize = SYS_FRAMES_MAXSIZE;
@@ -2206,12 +2184,9 @@ static int s2255_create_sys_buffers(struct 
s2255_channel *channel)
  	for (i = 0; i < SYS_FRAMES; i++) {
  		/* allocate the frames */
  		channel->buffer.frame[i].lpvbits = vmalloc(reqsize);
-		dprintk(1, "valloc %p chan %d, idx %lu, pdata %p\n",
-			&channel->buffer.frame[i], channel->idx, i,
-			channel->buffer.frame[i].lpvbits);
  		channel->buffer.frame[i].size = reqsize;
  		if (channel->buffer.frame[i].lpvbits == NULL) {
-			printk(KERN_INFO "out of memory.  using less frames\n");
+			pr_info("out of memory.  using less frames\n");
  			channel->buffer.dwFrames = i;
  			break;
  		}
@@ -2231,13 +2206,9 @@ static int s2255_create_sys_buffers(struct 
s2255_channel *channel)
  static int s2255_release_sys_buffers(struct s2255_channel *channel)
  {
  	unsigned long i;
-	dprintk(1, "release sys buffers\n");
  	for (i = 0; i < SYS_FRAMES; i++) {
-		if (channel->buffer.frame[i].lpvbits) {
-			dprintk(1, "vfree %p\n",
-				channel->buffer.frame[i].lpvbits);
+		if (channel->buffer.frame[i].lpvbits)
  			vfree(channel->buffer.frame[i].lpvbits);
-		}
  		channel->buffer.frame[i].lpvbits = NULL;
  	}
  	return 0;
@@ -2249,7 +2220,7 @@ static int s2255_board_init(struct s2255_dev 
*dev)
  	int fw_ver;
  	int j;
  	struct s2255_pipeinfo *pipe = &dev->pipe;
-	dprintk(4, "board init: %p", dev);
+	dprintk(dev, 4, "board init: %p", dev);
  	memset(pipe, 0, sizeof(*pipe));
  	pipe->dev = dev;
  	pipe->cur_transfer_size = S2255_USB_XFER_SIZE;
@@ -2258,18 +2229,18 @@ static int s2255_board_init(struct s2255_dev 
*dev)
  	pipe->transfer_buffer = kzalloc(pipe->max_transfer_size,
  					GFP_KERNEL);
  	if (pipe->transfer_buffer == NULL) {
-		dprintk(1, "out of memory!\n");
+		dprintk(dev, 1, "out of memory!\n");
  		return -ENOMEM;
  	}
  	/* query the firmware */
  	fw_ver = s2255_get_fx2fw(dev);

-	printk(KERN_INFO "s2255: usb firmware version %d.%d\n",
-	       (fw_ver >> 8) & 0xff,
-	       fw_ver & 0xff);
+	pr_info("s2255: usb firmware version %d.%d\n",
+		(fw_ver >> 8) & 0xff,
+		fw_ver & 0xff);

  	if (fw_ver < S2255_CUR_USB_FWVER)
-		printk(KERN_INFO "s2255: newer USB firmware available\n");
+		pr_info("s2255: newer USB firmware available\n");

  	for (j = 0; j < MAX_CHANNELS; j++) {
  		struct s2255_channel *channel = &dev->channel[j];
@@ -2290,14 +2261,14 @@ static int s2255_board_init(struct s2255_dev 
*dev)
  	}
  	/* start read pipe */
  	s2255_start_readpipe(dev);
-	dprintk(1, "%s: success\n", __func__);
+	dprintk(dev, 1, "%s: success\n", __func__);
  	return 0;
  }

  static int s2255_board_shutdown(struct s2255_dev *dev)
  {
  	u32 i;
-	dprintk(1, "%s: dev: %p", __func__,  dev);
+	dprintk(dev, 1, "%s: dev: %p", __func__,  dev);

  	for (i = 0; i < MAX_CHANNELS; i++) {
  		if (dev->channel[i].b_acquire)
@@ -2318,13 +2289,10 @@ static void read_pipe_completion(struct urb 
*purb)
  	int status;
  	int pipe;
  	pipe_info = purb->context;
-	dprintk(100, "%s: urb:%p, status %d\n", __func__, purb,
-		purb->status);
  	if (pipe_info == NULL) {
  		dev_err(&purb->dev->dev, "no context!\n");
  		return;
  	}
-
  	dev = pipe_info->dev;
  	if (dev == NULL) {
  		dev_err(&purb->dev->dev, "no context!\n");
@@ -2333,13 +2301,13 @@ static void read_pipe_completion(struct urb 
*purb)
  	status = purb->status;
  	/* if shutting down, do not resubmit, exit immediately */
  	if (status == -ESHUTDOWN) {
-		dprintk(2, "%s: err shutdown\n", __func__);
+		dprintk(dev, 2, "%s: err shutdown\n", __func__);
  		pipe_info->err_count++;
  		return;
  	}

  	if (pipe_info->state == 0) {
-		dprintk(2, "%s: exiting USB pipe", __func__);
+		dprintk(dev, 2, "%s: exiting USB pipe", __func__);
  		return;
  	}

@@ -2347,7 +2315,7 @@ static void read_pipe_completion(struct urb 
*purb)
  		s2255_read_video_callback(dev, pipe_info);
  	else {
  		pipe_info->err_count++;
-		dprintk(1, "%s: failed URB %d\n", __func__, status);
+		dprintk(dev, 1, "%s: failed URB %d\n", __func__, status);
  	}

  	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
@@ -2359,11 +2327,10 @@ static void read_pipe_completion(struct urb 
*purb)
  			  read_pipe_completion, pipe_info);

  	if (pipe_info->state != 0) {
-		if (usb_submit_urb(pipe_info->stream_urb, GFP_ATOMIC)) {
+		if (usb_submit_urb(pipe_info->stream_urb, GFP_ATOMIC))
  			dev_err(&dev->udev->dev, "error submitting urb\n");
-		}
  	} else {
-		dprintk(2, "%s :complete state 0\n", __func__);
+		dprintk(dev, 2, "%s :complete state 0\n", __func__);
  	}
  	return;
  }
@@ -2374,7 +2341,7 @@ static int s2255_start_readpipe(struct s2255_dev 
*dev)
  	int retval;
  	struct s2255_pipeinfo *pipe_info = &dev->pipe;
  	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
-	dprintk(2, "%s: IN %d\n", __func__, dev->read_endpoint);
+	dprintk(dev, 2, "%s: IN %d\n", __func__, dev->read_endpoint);
  	pipe_info->state = 1;
  	pipe_info->err_count = 0;
  	pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2391,7 +2358,7 @@ static int s2255_start_readpipe(struct s2255_dev 
*dev)
  			  read_pipe_completion, pipe_info);
  	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
  	if (retval) {
-		printk(KERN_ERR "s2255: start read pipe failed\n");
+		pr_err("s2255: start read pipe failed\n");
  		return retval;
  	}
  	return 0;
@@ -2428,7 +2395,7 @@ static int s2255_start_acquire(struct 
s2255_channel *channel)
  	if (res != 0)
  		dev_err(&dev->udev->dev, "CMD_START error\n");

-	dprintk(2, "start acquire exit[%d] %d \n", channel->idx, res);
+	dprintk(dev, 2, "start acquire exit[%d] %d\n", channel->idx, res);
  	kfree(buffer);
  	return 0;
  }
@@ -2454,7 +2421,7 @@ static int s2255_stop_acquire(struct 
s2255_channel *channel)
  		dev_err(&dev->udev->dev, "CMD_STOP error\n");
  	kfree(buffer);
  	channel->b_acquire = 0;
-	dprintk(4, "%s: chn %d, res %d\n", __func__, channel->idx, res);
+	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, channel->idx, res);
  	return res;
  }

@@ -2469,7 +2436,7 @@ static void s2255_stop_readpipe(struct s2255_dev 
*dev)
  		usb_free_urb(pipe->stream_urb);
  		pipe->stream_urb = NULL;
  	}
-	dprintk(4, "%s", __func__);
+	dprintk(dev, 4, "%s", __func__);
  	return;
  }

@@ -2501,7 +2468,6 @@ static int s2255_probe(struct usb_interface 
*interface,
  	int retval = -ENOMEM;
  	__le32 *pdata;
  	int fw_size;
-	dprintk(2, "%s\n", __func__);
  	/* allocate memory for our device state and initialize it to zero */
  	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
  	if (dev == NULL) {
@@ -2521,12 +2487,12 @@ static int s2255_probe(struct usb_interface 
*interface,
  		retval = -ENODEV;
  		goto errorUDEV;
  	}
-	dprintk(1, "dev: %p, udev %p interface %p\n", dev,
+	dprintk(dev, 1, "dev: %p, udev %p interface %p\n", dev,
  		dev->udev, interface);
  	dev->interface = interface;
  	/* set up the endpoint information  */
  	iface_desc = interface->cur_altsetting;
-	dprintk(1, "num endpoints %d\n", iface_desc->desc.bNumEndpoints);
+	dprintk(dev, 1, "num endpoints %d\n", 
iface_desc->desc.bNumEndpoints);
  	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
  		endpoint = &iface_desc->endpoint[i].desc;
  		if (!dev->read_endpoint && usb_endpoint_is_bulk_in(endpoint)) {
@@ -2564,7 +2530,7 @@ static int s2255_probe(struct usb_interface 
*interface,
  	/* load the first chunk */
  	if (request_firmware(&dev->fw_data->fw,
  			     FIRMWARE_FILE_NAME, &dev->udev->dev)) {
-		printk(KERN_ERR "sensoray 2255 failed to get firmware\n");
+		dev_err(&interface->dev, "sensoray 2255 failed to get firmware\n");
  		goto errorREQFW;
  	}
  	/* check the firmware is valid */
@@ -2572,21 +2538,21 @@ static int s2255_probe(struct usb_interface 
*interface,
  	pdata = (__le32 *) &dev->fw_data->fw->data[fw_size - 8];

  	if (*pdata != S2255_FW_MARKER) {
-		printk(KERN_INFO "Firmware invalid.\n");
+		dev_err(&interface->dev, "Firmware invalid.\n");
  		retval = -ENODEV;
  		goto errorFWMARKER;
  	} else {
  		/* make sure firmware is the latest */
  		__le32 *pRel;
  		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
-		printk(KERN_INFO "s2255 dsp fw version %x\n", le32_to_cpu(*pRel));
+		pr_info("s2255 dsp fw version %x\n", le32_to_cpu(*pRel));
  		dev->dsp_fw_ver = le32_to_cpu(*pRel);
  		if (dev->dsp_fw_ver < S2255_CUR_DSP_FWVER)
-			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
+			pr_info("s2255: f2255usb.bin out of date.\n");
  		if (dev->pid == 0x2257 &&
  				dev->dsp_fw_ver < S2255_MIN_DSP_COLORFILTER)
-			printk(KERN_WARNING "s2255: 2257 requires firmware %d"
-			       " or above.\n", S2255_MIN_DSP_COLORFILTER);
+			pr_warn("2257 needs firmware %d or above.\n",
+				S2255_MIN_DSP_COLORFILTER);
  	}
  	usb_reset_device(dev->udev);
  	/* load 2255 board specific */
@@ -2618,7 +2584,7 @@ errorUDEV:
  	mutex_destroy(&dev->lock);
  errorFWDATA1:
  	kfree(dev);
-	printk(KERN_WARNING "Sensoray 2255 driver load failed: 0x%x\n", 
retval);
+	pr_warn("Sensoray 2255 driver load failed: 0x%x\n", retval);
  	return retval;
  }

