Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77NLoas022370
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 19:21:50 -0400
Received: from mail11c.verio-web.com (mail11c.verio-web.com [204.202.242.55])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m77NLbqf028156
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 19:21:37 -0400
Received: from mx96.stngva01.us.mxservers.net (198.173.112.13)
	by mail11c.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-0221141296
	for <video4linux-list@redhat.com>; Thu,  7 Aug 2008 19:21:36 -0400 (EDT)
Date: Thu, 7 Aug 2008 16:21:34 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, video4linux-list@redhat.com
Message-ID: <tkrat.e703f589e6ff1d88@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: greg@kroah.com, dean@sensoray.com
Subject: [PATCH] s2255drv for 2.6.27-rc2: firmware loading improved,
 kfree bug fixed
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

From: Dean Anderson <dean@sensoray.com>

This patch fixes timer issues in driver disconnect.
It also removes the restriction of one user per channel at a time.
Adds handshaking with USB firmware to confirm proper loading.


Signed-off-by: Dean Anderson <dean@sensoray.com>
---
patch to linux-2.6.27-rc2
Thanks to Oliver Neukum and Mauro Chehab for finding many issues.
Resource locking partly based on saa7134 driver.
Patch is large, but fixes critical issues especially "access after
kfree" in close routine.
Simplified save_frame routine.

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 04eb2c3..67a029b 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -64,21 +64,24 @@
 #define S2255_VR_FW		0x30
 /* USB endpoint number for configuring the device */
 #define S2255_CONFIG_EP         2
-/* maximum time for DSP to start responding after last FW word loaded(ms) */
-#define S2255_DSP_BOOTTIME      400
-/* maximum time to wait for firmware to load (ms) */
-#define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
+/* maximum time for DSP to start responding after last FW word loaded(ms)*/
+#define S2255_DSP_BOOTTIME      800
+/*
+ * maximum time to wait for firmware to load (ms)
+ */
+#define S2255_LOAD_TIMEOUT      (4000 + S2255_DSP_BOOTTIME)
 #define S2255_DEF_BUFS          16
+#define S2255_SETMODE_TIMEOUT   5000
 #define MAX_CHANNELS		4
-#define FRAME_MARKER		0x2255DA4AL
-#define MAX_PIPE_USBBLOCK	(40 * 1024)
-#define DEFAULT_PIPE_USBBLOCK	(16 * 1024)
+#define S2255_MARKER_FRAME	0x2255DA4AL
+#define S2255_MARKER_RESPONSE	0x2255ACACL
+#define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
 #define SYS_FRAMES		4
 /* maximum size is PAL full size plus room for the marker header(s) */
-#define SYS_FRAMES_MAXSIZE	(720 * 288 * 2 * 2 + 4096)
-#define DEF_USB_BLOCK		(4096)
+#define SYS_FRAMES_MAXSIZE	(720*288*2*2 + 4096)
+#define DEF_USB_BLOCK		S2255_USB_XFER_SIZE
 #define LINE_SZ_4CIFS_NTSC	640
 #define LINE_SZ_2CIFS_NTSC	640
 #define LINE_SZ_1CIFS_NTSC	320
@@ -106,6 +109,9 @@
 #define COLOR_YUVPL	1	/* YUV planar */
 #define COLOR_YUVPK	2	/* YUV packed */
 #define COLOR_Y8	4	/* monochrome */
+#define COLOR_JPG       5       /* JPEG */
+#define MASK_COLOR      0xff
+#define MASK_JPG_QUALITY 0xff00
 
 /* frame decimation. Not implemented by V4L yet(experimental in V4L) */
 #define FDEC_1		1	/* capture every frame. default */
@@ -146,16 +152,10 @@ struct s2255_mode {
 	u32 restart;	/* if DSP requires restart */
 };
 
-/* frame structure */
-#define FRAME_STATE_UNUSED	0
-#define FRAME_STATE_FILLING	1
-#define FRAME_STATE_FULL	2
-
 
 struct s2255_framei {
 	unsigned long size;
-
-	unsigned long ulState;	/* ulState ==0 unused, 1 being filled, 2 full */
+	unsigned long read_state;
 	void *lpvbits;		/* image data */
 	unsigned long cur_size;	/* current data copied to it */
 };
@@ -184,6 +184,13 @@ struct s2255_dmaqueue {
 #define S2255_FW_LOADED_DSPWAIT	1
 #define S2255_FW_SUCCESS	2
 #define S2255_FW_FAILED		3
+#define S2255_FW_DISCONNECTING	4
+
+#define S2255_FW_MARKER         0x22552f2f
+
+/* 2255 read states */
+#define S2255_READ_IDLE         0
+#define S2255_READ_FRAME        1
 
 struct s2255_fw {
 	int		      fw_loaded;
@@ -192,7 +199,6 @@ struct s2255_fw {
 	atomic_t	      fw_state;
 	void		      *pfw_data;
 	wait_queue_head_t     wait_fw;
-	struct timer_list     dsp_wait;
 	const struct firmware *fw;
 };
 
@@ -239,10 +245,18 @@ struct s2255_dev {
 	int			last_frame[MAX_CHANNELS];
 	u32			cc;	/* current channel */
 	int			b_acquire[MAX_CHANNELS];
+	/* allocated image size */
 	unsigned long		req_image_size[MAX_CHANNELS];
+	unsigned long		pkt_size[MAX_CHANNELS];
 	int			bad_payload[MAX_CHANNELS];
 	unsigned long		frame_count[MAX_CHANNELS];
 	int			frame_ready;
+	int                     jpg_size[MAX_CHANNELS];
+	/* if channel configured to default state */
+	int                     chn_configured[MAX_CHANNELS];
+	wait_queue_head_t       wait_setmode[MAX_CHANNELS];
+	int                     setmode_ready[MAX_CHANNELS];
+	int                     chn_ready;
 	struct kref		kref;
 	spinlock_t              slock;
 };
@@ -263,7 +277,6 @@ struct s2255_buffer {
 
 struct s2255_fh {
 	struct s2255_dev	*dev;
-	unsigned int		resources;
 	const struct s2255_fmt	*fmt;
 	unsigned int		width;
 	unsigned int		height;
@@ -273,14 +286,9 @@ struct s2255_fh {
 	/* mode below is the desired mode.
 	   mode in s2255_dev is the current mode that was last set */
 	struct s2255_mode	mode;
+	int			resources[MAX_CHANNELS];
 };
 
-/*
- * TODO: fixme S2255_MAX_USERS. Do not limit open driver handles.
- * Limit V4L to one stream at a time.
- */
-#define S2255_MAX_USERS         1
-
 #define CUR_USB_FWVER	774	/* current cypress EEPROM firmware version */
 #define S2255_MAJOR_VERSION	1
 #define S2255_MINOR_VERSION	13
@@ -309,12 +317,13 @@ static void s2255_stop_readpipe(struct s2255_dev *dev);
 static int s2255_start_acquire(struct s2255_dev *dev, unsigned long chn);
 static int s2255_stop_acquire(struct s2255_dev *dev, unsigned long chn);
 static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
-			   int chn);
+			   int chn, int jpgsize);
 static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
 			  struct s2255_mode *mode);
 static int s2255_board_shutdown(struct s2255_dev *dev);
 static void s2255_exit_v4l(struct s2255_dev *dev);
 static void s2255_fwload_start(struct s2255_dev *dev);
+static void s2255_destroy(struct kref *kref);
 
 #define dprintk(level, fmt, arg...)					\
 	do {								\
@@ -410,6 +419,10 @@ static const struct s2255_fmt formats[] = {
 		.fourcc = V4L2_PIX_FMT_UYVY,
 		.depth = 16
 	}, {
+		.name = "JPG",
+		.fourcc = V4L2_PIX_FMT_JPEG,
+		.depth = 24
+	}, {
 		.name = "8bpp GREY",
 		.fourcc = V4L2_PIX_FMT_GREY,
 		.depth = 8
@@ -476,26 +489,13 @@ static void s2255_timer(unsigned long user_data)
 	dprintk(100, "s2255 timer\n");
 	if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
 		printk(KERN_ERR "s2255: can't submit urb\n");
-		if (data->fw) {
-			release_firmware(data->fw);
-			data->fw = NULL;
-		}
+		atomic_set(&data->fw_state, S2255_FW_FAILED);
+		/* wake up anything waiting for the firmware */
+		wake_up(&data->wait_fw);
 		return;
 	}
 }
 
-/* called when DSP is up and running.  DSP is guaranteed to
-   be running after S2255_DSP_BOOTTIME */
-static void s2255_dsp_running(unsigned long user_data)
-{
-	struct s2255_fw *data = (struct s2255_fw *)user_data;
-	dprintk(1, "dsp running\n");
-	atomic_set(&data->fw_state, S2255_FW_SUCCESS);
-	wake_up(&data->wait_fw);
-	printk(KERN_INFO "s2255: firmware loaded successfully\n");
-	return;
-}
-
 
 /* this loads the firmware asynchronously.
    Originally this was done synchroously in probe.
@@ -509,13 +509,18 @@ static void s2255_fwchunk_complete(struct urb *urb)
 	struct usb_device *udev = urb->dev;
 	int len;
 	dprintk(100, "udev %p urb %p", udev, urb);
-	/* TODO: fixme.  reflect change in status */
 	if (urb->status) {
 		dev_err(&udev->dev, "URB failed with status %d", urb->status);
+		atomic_set(&data->fw_state, S2255_FW_FAILED);
+		/* wake up anything waiting for the firmware */
+		wake_up(&data->wait_fw);
 		return;
 	}
 	if (data->fw_urb == NULL) {
-		dev_err(&udev->dev, "early disconncect\n");
+		dev_err(&udev->dev, "s2255 disconnected\n");
+		atomic_set(&data->fw_state, S2255_FW_FAILED);
+		/* wake up anything waiting for the firmware */
+		wake_up(&data->wait_fw);
 		return;
 	}
 #define CHUNK_SIZE 512
@@ -548,19 +553,14 @@ static void s2255_fwchunk_complete(struct urb *urb)
 		}
 		data->fw_loaded += len;
 	} else {
-		init_timer(&data->dsp_wait);
-		data->dsp_wait.function = s2255_dsp_running;
-		data->dsp_wait.data = (unsigned long)data;
 		atomic_set(&data->fw_state, S2255_FW_LOADED_DSPWAIT);
-		mod_timer(&data->dsp_wait, msecs_to_jiffies(S2255_DSP_BOOTTIME)
-			  + jiffies);
 	}
 	dprintk(100, "2255 complete done\n");
 	return;
 
 }
 
-static int s2255_got_frame(struct s2255_dev *dev, int chn)
+static int s2255_got_frame(struct s2255_dev *dev, int chn, int jpgsize)
 {
 	struct s2255_dmaqueue *dma_q = &dev->vidq[chn];
 	struct s2255_buffer *buf;
@@ -585,8 +585,7 @@ static int s2255_got_frame(struct s2255_dev *dev, int chn)
 	list_del(&buf->vb.queue);
 	do_gettimeofday(&buf->vb.ts);
 	dprintk(100, "[%p/%d] wakeup\n", buf, buf->vb.i);
-
-	s2255_fillbuff(dev, buf, dma_q->channel);
+	s2255_fillbuff(dev, buf, dma_q->channel, jpgsize);
 	wake_up(&buf->vb.done);
 	dprintk(2, "wakeup [buf/i] [%p/%d]\n", buf, buf->vb.i);
 unlock:
@@ -620,7 +619,7 @@ static const struct s2255_fmt *format_by_fourcc(int fourcc)
  *
  */
 static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
-			   int chn)
+			   int chn, int jpgsize)
 {
 	int pos = 0;
 	struct timeval ts;
@@ -648,6 +647,10 @@ static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
 		case V4L2_PIX_FMT_GREY:
 			memcpy(vbuf, tmpbuf, buf->vb.width * buf->vb.height);
 			break;
+		case V4L2_PIX_FMT_JPEG:
+			buf->vb.size = jpgsize;
+			memcpy(vbuf, tmpbuf, buf->vb.size);
+			break;
 		case V4L2_PIX_FMT_YUV422P:
 			memcpy(vbuf, tmpbuf,
 			       buf->vb.width * buf->vb.height * 2);
@@ -657,7 +660,6 @@ static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
 		}
 		dev->last_frame[chn] = -1;
 		/* done with the frame, free it */
-		frm->ulState = 0;
 		dprintk(4, "freeing buffer\n");
 	} else {
 		printk(KERN_ERR "s2255: =======no frame\n");
@@ -789,7 +791,8 @@ static int res_get(struct s2255_dev *dev, struct s2255_fh *fh)
 	}
 	/* it's free, grab it */
 	dev->resources[fh->channel] = 1;
-	dprintk(1, "res: get\n");
+	fh->resources[fh->channel] = 1;
+	dprintk(1, "s2255: res: get\n");
 	mutex_unlock(&dev->lock);
 	return 1;
 }
@@ -799,9 +802,18 @@ static int res_locked(struct s2255_dev *dev, struct s2255_fh *fh)
 	return dev->resources[fh->channel];
 }
 
+static int res_check(struct s2255_fh *fh)
+{
+	return fh->resources[fh->channel];
+}
+
+
 static void res_free(struct s2255_dev *dev, struct s2255_fh *fh)
 {
+	mutex_lock(&dev->lock);
 	dev->resources[fh->channel] = 0;
+	fh->resources[fh->channel] = 0;
+	mutex_unlock(&dev->lock);
 	dprintk(1, "res: put\n");
 }
 
@@ -1010,6 +1022,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	case V4L2_PIX_FMT_GREY:
 		fh->mode.color = COLOR_Y8;
 		break;
+	case V4L2_PIX_FMT_JPEG:
+		fh->mode.color = COLOR_JPG | (50 << 8);
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 		fh->mode.color = COLOR_YUVPL;
 		break;
@@ -1068,11 +1083,13 @@ static int vidioc_cgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
 #endif
 
 /* write to the configuration pipe, synchronously */
-static int s2255_write_config(struct usb_device *udev, unsigned char *pbuf,
+static int s2255_write_config(struct s2255_dev *dev,
+			      unsigned char *pbuf,
 			      int size)
 {
 	int pipe;
 	int done;
+	struct usb_device *udev = dev->udev;
 	long retval = -1;
 	if (udev) {
 		pipe = usb_sndbulkpipe(udev, S2255_CONFIG_EP);
@@ -1128,7 +1145,7 @@ static u32 get_transfer_size(struct s2255_mode *mode)
 		}
 	}
 	outImageSize = linesPerFrame * pixelsPerLine;
-	if (mode->color != COLOR_Y8) {
+	if ((mode->color & MASK_COLOR) != COLOR_Y8) {
 		/* 2 bytes/pixel if not monochrome */
 		outImageSize *= 2;
 	}
@@ -1174,6 +1191,7 @@ static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
 	u32 *buffer;
 	unsigned long chn_rev;
 
+	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
 	dprintk(3, "mode scale [%ld] %p %d\n", chn, mode, mode->scale);
 	dprintk(3, "mode scale [%ld] %p %d\n", chn, &dev->mode[chn],
@@ -1188,6 +1206,7 @@ static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
+		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 
@@ -1196,19 +1215,26 @@ static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
 	buffer[1] = (u32) chn_rev;
 	buffer[2] = CMD_SET_MODE;
 	memcpy(&buffer[3], &dev->mode[chn], sizeof(struct s2255_mode));
-	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
+	res = s2255_write_config(dev, (unsigned char *)buffer, 512);
 	if (debug)
 		dump_verify_mode(dev, mode);
 	kfree(buffer);
 	dprintk(1, "set mode done chn %lu, %d\n", chn, res);
 
 	/* wait at least 3 frames before continuing */
-	if (mode->restart)
-		msleep(125);
+
+	if (mode->restart) {
+		dev->setmode_ready[chn] = 0;
+		wait_event_timeout(dev->wait_setmode[chn],
+				   (dev->setmode_ready[chn] != 0),
+				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
+		if (dev->setmode_ready[chn] != 1)
+			printk(KERN_DEBUG "s2255: no set mode response\n");
+	}
 
 	/* clear the restart flag */
 	dev->mode[chn].restart = 0;
-
+	mutex_unlock(&dev->lock);
 	return res;
 }
 
@@ -1232,7 +1258,7 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	}
 
 	if (!res_get(dev, fh)) {
-		dev_err(&dev->udev->dev, "res get busy\n");
+		dev_err(&dev->udev->dev, "s2255: stream busy\n");
 		return -EBUSY;
 	}
 
@@ -1258,7 +1284,7 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	dev->bad_payload[chn] = 0;
 	dev->cur_frame[chn] = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
-		dev->buffer[chn].frame[j].ulState = 0;
+		dev->buffer[chn].frame[j].read_state = S2255_READ_IDLE;
 		dev->buffer[chn].frame[j].cur_size = 0;
 	}
 	res = videobuf_streamon(&fh->vb_vidq);
@@ -1288,8 +1314,11 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	}
 	s2255_stop_acquire(dev, fh->channel);
 	res = videobuf_streamoff(&fh->vb_vidq);
+	if (res < 0)
+		return res;
 	res_free(dev, fh);
-	return res;
+
+	return 0;
 }
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
@@ -1441,10 +1470,13 @@ static int s2255_open(struct inode *inode, struct file *file)
 	enum v4l2_buf_type type = 0;
 	int i = 0;
 	int cur_channel = -1;
+	int state;
 	dprintk(1, "s2255: open called (minor=%d)\n", minor);
 
 	list_for_each(list, &s2255_devlist) {
 		h = list_entry(list, struct s2255_dev, s2255_devlist);
+		if (h == NULL)
+			return -ENODEV;
 		for (i = 0; i < MAX_CHANNELS; i++) {
 			if (h->vdev[i]->minor == minor) {
 				cur_channel = i;
@@ -1455,54 +1487,90 @@ static int s2255_open(struct inode *inode, struct file *file)
 	}
 
 	if ((NULL == dev) || (cur_channel == -1)) {
-		dprintk(1, "s2255: openv4l no dev\n");
+		printk(KERN_INFO "s2255: openv4l no dev\n");
 		return -ENODEV;
 	}
 
+	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_DISCONNECTING) {
+		printk(KERN_INFO "disconnecting\n");
+		return -ENODEV;
+	}
+	kref_get(&dev->kref);
 	mutex_lock(&dev->open_lock);
-
 	dev->users[cur_channel]++;
-	if (dev->users[cur_channel] > S2255_MAX_USERS) {
-		dev->users[cur_channel]--;
-		mutex_unlock(&dev->open_lock);
-		printk(KERN_INFO "s2255drv: too many open handles!\n");
-		return -EBUSY;
-	}
+	dprintk(4, "s2255: open_handles %d\n", dev->users[cur_channel]);
 
-	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_FAILED) {
+	switch (atomic_read(&dev->fw_data->fw_state)) {
+	case S2255_FW_FAILED:
 		err("2255 firmware load failed. retrying.\n");
 		s2255_fwload_start(dev);
 		wait_event_timeout(dev->fw_data->wait_fw,
-				   (atomic_read(&dev->fw_data->fw_state)
-				    != S2255_FW_NOTLOADED),
+				   ((atomic_read(&dev->fw_data->fw_state)
+				     == S2255_FW_SUCCESS) ||
+				    (atomic_read(&dev->fw_data->fw_state)
+				     == S2255_FW_DISCONNECTING)),
 				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
-		if (atomic_read(&dev->fw_data->fw_state)
-		    != S2255_FW_SUCCESS) {
-			printk(KERN_INFO "2255 FW load failed after 2 tries\n");
-			mutex_unlock(&dev->open_lock);
-			return -EFAULT;
-		}
-	} else if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_NOTLOADED) {
+		break;
+	case S2255_FW_NOTLOADED:
+	case S2255_FW_LOADED_DSPWAIT:
 		/* give S2255_LOAD_TIMEOUT time for firmware to load in case
 		   driver loaded and then device immediately opened */
 		printk(KERN_INFO "%s waiting for firmware load\n", __func__);
 		wait_event_timeout(dev->fw_data->wait_fw,
-				   (atomic_read(&dev->fw_data->fw_state)
-				   != S2255_FW_NOTLOADED),
-				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
-		if (atomic_read(&dev->fw_data->fw_state)
-		    != S2255_FW_SUCCESS) {
-			printk(KERN_INFO "2255 firmware not loaded"
-			       "try again\n");
-			mutex_unlock(&dev->open_lock);
-			return -EBUSY;
+				   ((atomic_read(&dev->fw_data->fw_state)
+				     == S2255_FW_SUCCESS) ||
+				    (atomic_read(&dev->fw_data->fw_state)
+				     == S2255_FW_DISCONNECTING)),
+			msecs_to_jiffies(S2255_LOAD_TIMEOUT));
+		break;
+	case S2255_FW_SUCCESS:
+	default:
+		break;
+	}
+	state = atomic_read(&dev->fw_data->fw_state);
+	if (state != S2255_FW_SUCCESS) {
+		int rc;
+		switch (state) {
+		case S2255_FW_FAILED:
+			printk(KERN_INFO "2255 FW load failed. %d\n", state);
+			printk(KERN_INFO "If you did modprobe -r or rmmod,\n");
+			printk(KERN_INFO "you must disconnect the device\n");
+			printk(KERN_INFO "and plug it back in and reloading\n");
+			printk(KERN_INFO "the driver\n");
+			rc = -ENODEV;
+			break;
+		case S2255_FW_DISCONNECTING:
+			printk(KERN_INFO "%s: disconnecting\n", __func__);
+			rc = -ENODEV;
+			break;
+		case S2255_FW_LOADED_DSPWAIT:
+			printk(KERN_INFO "If you did modprobe -r or rmmod,\n");
+			printk(KERN_INFO "you must disconnect the device\n");
+			printk(KERN_INFO "and plug it back in.\n");
+			printk(KERN_INFO "the driver\n");
+			/* fall thru */
+		case S2255_FW_NOTLOADED:
+			printk(KERN_INFO "%s: firmware load timed out\n",
+			       __func__);
+			rc = -EAGAIN;
+			break;
+		default:
+			printk(KERN_INFO "%s: unknown state\n", __func__);
+			rc = -EFAULT;
+			break;
 		}
+		dev->users[cur_channel]--;
+		mutex_unlock(&dev->open_lock);
+		kref_put(&dev->kref, s2255_destroy);
+		return rc;
 	}
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh) {
+		dev->users[cur_channel]--;
 		mutex_unlock(&dev->open_lock);
+		kref_put(&dev->kref, s2255_destroy);
 		return -ENOMEM;
 	}
 
@@ -1516,6 +1584,13 @@ static int s2255_open(struct inode *inode, struct file *file)
 	fh->height = NUM_LINES_4CIFS_NTSC * 2;
 	fh->channel = cur_channel;
 
+	/* configure channel to default state */
+	if (!dev->chn_configured[cur_channel]) {
+		s2255_set_mode(dev, cur_channel, &fh->mode);
+		dev->chn_configured[cur_channel] = 1;
+	}
+
+
 	/* Put all controls at a sane state */
 	for (i = 0; i < ARRAY_SIZE(s2255_qctrl); i++)
 		qctl_regs[i] = s2255_qctrl[i].default_value;
@@ -1534,8 +1609,8 @@ static int s2255_open(struct inode *inode, struct file *file)
 				    V4L2_FIELD_INTERLACED,
 				    sizeof(struct s2255_buffer), fh);
 
-	kref_get(&dev->kref);
 	mutex_unlock(&dev->open_lock);
+
 	return 0;
 }
 
@@ -1557,52 +1632,45 @@ static unsigned int s2255_poll(struct file *file,
 static void s2255_destroy(struct kref *kref)
 {
 	struct s2255_dev *dev = to_s2255_dev(kref);
+	struct list_head *list;
+	int i;
 	if (!dev) {
 		printk(KERN_ERR "s2255drv: kref problem\n");
 		return;
 	}
-	/* prevent s2255_disconnect from racing s2255_open */
+	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
+	wake_up(&dev->fw_data->wait_fw);
+	for (i = 0; i < MAX_CHANNELS; i++) {
+		dev->setmode_ready[i] = 1;
+		wake_up(&dev->wait_setmode[i]);
+	}
 	mutex_lock(&dev->open_lock);
 	s2255_exit_v4l(dev);
-	/* device unregistered so no longer possible to open. open_mutex
-	   can be unlocked */
-	mutex_unlock(&dev->open_lock);
 
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
-
 	/* make sure firmware still not trying to load */
+	del_timer(&dev->timer);  /* only started in .probe and .open */
+
 	if (dev->fw_data->fw_urb) {
 		dprintk(2, "kill fw_urb\n");
 		usb_kill_urb(dev->fw_data->fw_urb);
 		usb_free_urb(dev->fw_data->fw_urb);
 		dev->fw_data->fw_urb = NULL;
 	}
-	/*
-	 * TODO: fixme(above, below): potentially leaving timers alive.
-	 *                            do not ignore timeout below if
-	 *                            it occurs.
-	 */
-
-	/* make sure we aren't waiting for the DSP */
-	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_LOADED_DSPWAIT) {
-		/* if we are, wait for the wakeup for fw_success or timeout */
-		wait_event_timeout(dev->fw_data->wait_fw,
-				   (atomic_read(&dev->fw_data->fw_state)
-				   == S2255_FW_SUCCESS),
-				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
-	}
-
-	if (dev->fw_data) {
-		if (dev->fw_data->fw)
-			release_firmware(dev->fw_data->fw);
-		kfree(dev->fw_data->pfw_data);
-		kfree(dev->fw_data);
-	}
-
+	if (dev->fw_data->fw)
+		release_firmware(dev->fw_data->fw);
+	kfree(dev->fw_data->pfw_data);
+	kfree(dev->fw_data);
 	usb_put_dev(dev->udev);
 	dprintk(1, "%s", __func__);
 	kfree(dev);
+
+	while (!list_empty(&s2255_devlist)) {
+		list = s2255_devlist.next;
+		list_del(list);
+	}
+	mutex_unlock(&dev->open_lock);
 }
 
 static int s2255_close(struct inode *inode, struct file *file)
@@ -1614,18 +1682,22 @@ static int s2255_close(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	mutex_lock(&dev->open_lock);
+	/* turn off stream */
+	if (res_check(fh)) {
+		if (dev->b_acquire[fh->channel])
+			s2255_stop_acquire(dev, fh->channel);
+		videobuf_streamoff(&fh->vb_vidq);
+		res_free(dev, fh);
+	}
 
-	if (dev->b_acquire[fh->channel])
-		s2255_stop_acquire(dev, fh->channel);
-	res_free(dev, fh);
 	videobuf_mmap_free(&fh->vb_vidq);
-	kfree(fh);
 	dev->users[fh->channel]--;
 	mutex_unlock(&dev->open_lock);
-
 	kref_put(&dev->kref, s2255_destroy);
 	dprintk(1, "s2255: close called (minor=%d, users=%d)\n",
 		minor, dev->users[fh->channel]);
+	kfree(fh);
+
 	return 0;
 }
 
@@ -1647,6 +1719,8 @@ static int s2255_mmap_v4l(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
+
+
 static const struct file_operations s2255_fops_v4l = {
 	.owner = THIS_MODULE,
 	.open = s2255_open,
@@ -1729,18 +1803,16 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 
 static void s2255_exit_v4l(struct s2255_dev *dev)
 {
-	struct list_head *list;
+
 	int i;
-	/* unregister the video devices */
-	while (!list_empty(&s2255_devlist)) {
-		list = s2255_devlist.next;
-		list_del(list);
-	}
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		if (-1 != dev->vdev[i]->minor)
+		if (-1 != dev->vdev[i]->minor) {
 			video_unregister_device(dev->vdev[i]);
-		else
+			printk(KERN_INFO "s2255 unregistered\n");
+		} else {
 			video_device_release(dev->vdev[i]);
+			printk(KERN_INFO "s2255 released\n");
+		}
 	}
 }
 
@@ -1750,134 +1822,123 @@ static void s2255_exit_v4l(struct s2255_dev *dev)
  * function again).
  *
  * Received frame structure:
- * bytes 0-3:  marker : 0x2255DA4AL (FRAME_MARKER)
+ * bytes 0-3:  marker : 0x2255DA4AL (S2255_MARKER_FRAME)
  * bytes 4-7:  channel: 0-3
  * bytes 8-11: payload size:  size of the frame
  * bytes 12-payloadsize+12:  frame data
  */
 static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 {
-	static int dbgsync; /* = 0; */
 	char *pdest;
 	u32 offset = 0;
-	int bsync = 0;
-	int btrunc = 0;
+	int bframe = 0;
 	char *psrc;
 	unsigned long copy_size;
 	unsigned long size;
 	s32 idx = -1;
 	struct s2255_framei *frm;
 	unsigned char *pdata;
-	unsigned long cur_size;
-	int bsearch = 0;
-	struct s2255_bufferi *buf;
+
 	dprintk(100, "buffer to user\n");
 
 	idx = dev->cur_frame[dev->cc];
-	buf = &dev->buffer[dev->cc];
-	frm = &buf->frame[idx];
-
-	if (frm->ulState == 0) {
-		frm->ulState = 1;
-		frm->cur_size = 0;
-		bsearch = 1;
-	} else if (frm->ulState == 2) {
-		/* system frame was not freed */
-		dprintk(2, "sys frame not free.  overrun ringbuf\n");
-		bsearch = 1;
-		frm->ulState = 1;
-		frm->cur_size = 0;
-	}
-
-	if (bsearch) {
-		if (*(s32 *) pipe_info->transfer_buffer != FRAME_MARKER) {
-			u32 jj;
-			if (dbgsync == 0) {
-				dprintk(3, "not synched, discarding all packets"
-					"until marker\n");
+	frm = &dev->buffer[dev->cc].frame[idx];
 
-				dbgsync++;
-			}
-			pdata = (unsigned char *)pipe_info->transfer_buffer;
-			for (jj = 0; jj < (pipe_info->cur_transfer_size - 12);
-			     jj++) {
-				if (*(s32 *) pdata == FRAME_MARKER) {
-					int cc;
-					dprintk(3,
-						"found frame marker at offset:"
-						" %d [%x %x]\n", jj, pdata[0],
-						pdata[1]);
-					offset = jj;
-					bsync = 1;
-					cc = *(u32 *) (pdata + sizeof(u32));
-					if (cc >= MAX_CHANNELS) {
-						printk(KERN_ERR
-						       "bad channel\n");
-						return -EINVAL;
-					}
-					/* reverse it */
-					dev->cc = G_chnmap[cc];
+	if (frm->read_state == S2255_READ_IDLE) {
+		int jj;
+		unsigned int cc;
+		s32 *pdword;
+		int payload;
+		/* search for marker codes */
+		pdata = (unsigned char *)pipe_info->transfer_buffer;
+		for (jj = 0; jj < (pipe_info->cur_transfer_size - 12); jj++) {
+			switch (*(s32 *) pdata) {
+			case S2255_MARKER_FRAME:
+				pdword = (s32 *)pdata;
+				dprintk(4, "found frame marker at offset:"
+					" %d [%x %x]\n", jj, pdata[0],
+					pdata[1]);
+				offset = jj + PREFIX_SIZE;
+				bframe = 1;
+				cc = pdword[1];
+				if (cc >= MAX_CHANNELS) {
+					printk(KERN_ERR
+					       "bad channel\n");
+					return -EINVAL;
+				}
+				/* reverse it */
+				dev->cc = G_chnmap[cc];
+				payload =  pdword[3];
+				if (payload > dev->req_image_size[dev->cc]) {
+					dev->bad_payload[dev->cc]++;
+					/* discard the bad frame */
+					return -EINVAL;
+				}
+				dev->pkt_size[dev->cc] = payload;
+				dev->jpg_size[dev->cc] = pdword[4];
+				break;
+			case S2255_MARKER_RESPONSE:
+				pdword = (s32 *)pdata;
+				pdata += DEF_USB_BLOCK;
+				jj += DEF_USB_BLOCK;
+				if (pdword[1] >= MAX_CHANNELS)
+					break;
+				cc = G_chnmap[pdword[1]];
+				if (!(cc >= 0 && cc < MAX_CHANNELS))
+					break;
+				switch (pdword[2]) {
+				case 0x01:
+					/* check if channel valid */
+					/* set mode ready */
+					dev->setmode_ready[cc] = 1;
+					wake_up(&dev->wait_setmode[cc]);
+					dprintk(5, "setmode ready %d\n", cc);
 					break;
+				case 0x10:
+
+					dev->chn_ready |= (1 << cc);
+					if ((dev->chn_ready & 0x0f) != 0x0f)
+						break;
+					/* all channels ready */
+					printk(KERN_INFO "s2255: fw loaded\n");
+					atomic_set(&dev->fw_data->fw_state,
+						   S2255_FW_SUCCESS);
+					wake_up(&dev->fw_data->wait_fw);
+					break;
+				default:
+					printk(KERN_INFO "s2255 unknwn resp\n");
 				}
+			default:
 				pdata++;
+				break;
 			}
-			if (bsync == 0)
-				return -EINVAL;
-		} else {
-			u32 *pword;
-			u32 payload;
-			int cc;
-			dbgsync = 0;
-			bsync = 1;
-			pword = (u32 *) pipe_info->transfer_buffer;
-			cc = pword[1];
-
-			if (cc >= MAX_CHANNELS) {
-				printk("invalid channel found. "
-					"throwing out data!\n");
-				return -EINVAL;
-			}
-			dev->cc = G_chnmap[cc];
-			payload = pword[2];
-			if (payload != dev->req_image_size[dev->cc]) {
-				dprintk(1, "[%d][%d]unexpected payload: %d"
-					"required: %lu \n", cc, dev->cc,
-					payload, dev->req_image_size[dev->cc]);
-				dev->bad_payload[dev->cc]++;
-				/* discard the bad frame */
-				return -EINVAL;
-			}
-
-		}
-	}
-	/* search done.  now find out if should be acquiring
-	   on this channel */
-	if (!dev->b_acquire[dev->cc]) {
-		frm->ulState = 0;
-		return -EINVAL;
+			if (bframe)
+				break;
+		} /* for */
+		if (!bframe)
+			return -EINVAL;
 	}
 
+
 	idx = dev->cur_frame[dev->cc];
 	frm = &dev->buffer[dev->cc].frame[idx];
 
-	if (frm->ulState == 0) {
-		frm->ulState = 1;
-		frm->cur_size = 0;
-	} else if (frm->ulState == 2) {
-		/* system frame ring buffer overrun */
-		dprintk(2, "sys frame overrun.  overwriting frame %d %d\n",
-			dev->cc, idx);
-		frm->ulState = 1;
-		frm->cur_size = 0;
+	/* search done.  now find out if should be acquiring on this channel */
+	if (!dev->b_acquire[dev->cc]) {
+		/* we found a frame, but this channel is turned off */
+		frm->read_state = S2255_READ_IDLE;
+		return -EINVAL;
 	}
 
-	if (bsync) {
-		/* skip the marker 512 bytes (and offset if out of sync) */
-		psrc = (u8 *)pipe_info->transfer_buffer + offset + PREFIX_SIZE;
-	} else {
-		psrc = (u8 *)pipe_info->transfer_buffer;
+	if (frm->read_state == S2255_READ_IDLE) {
+		frm->read_state = S2255_READ_FRAME;
+		frm->cur_size = 0;
 	}
 
+	/* skip the marker 512 bytes (and offset if out of sync) */
+	psrc = (u8 *)pipe_info->transfer_buffer + offset;
+
+
 	if (frm->lpvbits == NULL) {
 		dprintk(1, "s2255 frame buffer == NULL.%p %p %d %d",
 			frm, dev, dev->cc, idx);
@@ -1886,33 +1947,20 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 
 	pdest = frm->lpvbits + frm->cur_size;
 
-	if (bsync) {
-		copy_size =
-		    (pipe_info->cur_transfer_size - offset) - PREFIX_SIZE;
-		if (copy_size > pipe_info->cur_transfer_size) {
-			printk("invalid copy size, overflow!\n");
-			return -ENOMEM;
-		}
-	} else {
-		copy_size = pipe_info->cur_transfer_size;
-	}
+	copy_size = (pipe_info->cur_transfer_size - offset);
 
-	cur_size = frm->cur_size;
-	size = dev->req_image_size[dev->cc];
+	size = dev->pkt_size[dev->cc] - PREFIX_SIZE;
 
-	if ((copy_size + cur_size) > size) {
-		copy_size = size - cur_size;
-		btrunc = 1;
-	}
+	/* sanity check on pdest */
+	if ((copy_size + frm->cur_size) < dev->req_image_size[dev->cc])
+		memcpy(pdest, psrc, copy_size);
 
-	memcpy(pdest, psrc, copy_size);
-	cur_size += copy_size;
 	frm->cur_size += copy_size;
-	dprintk(50, "cur_size size %lu size %lu \n", cur_size, size);
+	dprintk(4, "cur_size size %lu size %lu \n", frm->cur_size, size);
+
+	if (frm->cur_size >= size) {
 
-	if (cur_size >= (size - PREFIX_SIZE)) {
 		u32 cc = dev->cc;
-		frm->ulState = 2;
 		dprintk(2, "****************[%d]Buffer[%d]full*************\n",
 			cc, idx);
 		dev->last_frame[cc] = dev->cur_frame[cc];
@@ -1921,16 +1969,13 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 		if ((dev->cur_frame[cc] == SYS_FRAMES) ||
 		    (dev->cur_frame[cc] == dev->buffer[cc].dwFrames))
 			dev->cur_frame[cc] = 0;
-
-		/* signal the semaphore for this channel */
+		/* frame ready */
 		if (dev->b_acquire[cc])
-			s2255_got_frame(dev, cc);
+			s2255_got_frame(dev, cc, dev->jpg_size[cc]);
 		dev->frame_count[cc]++;
-	}
-	/* frame was truncated */
-	if (btrunc) {
-		/* return more data to process */
-		return EAGAIN;
+		frm->read_state = S2255_READ_IDLE;
+		frm->cur_size = 0;
+
 	}
 	/* done successfully */
 	return 0;
@@ -1949,8 +1994,8 @@ static void s2255_read_video_callback(struct s2255_dev *dev,
 	}
 	/* otherwise copy to the system buffers */
 	res = save_frame(dev, pipe_info);
-	if (res == EAGAIN)
-		save_frame(dev, pipe_info);
+	if (res != 0)
+		dprintk(4, "s2255: read callback failed\n");
 
 	dprintk(50, "callback read video done\n");
 	return;
@@ -2033,7 +2078,7 @@ static int s2255_create_sys_buffers(struct s2255_dev *dev, unsigned long chn)
 
 	/* make sure internal states are set */
 	for (i = 0; i < SYS_FRAMES; i++) {
-		dev->buffer[chn].frame[i].ulState = 0;
+		dev->buffer[chn].frame[i].read_state = 0;
 		dev->buffer[chn].frame[i].cur_size = 0;
 	}
 
@@ -2070,11 +2115,9 @@ static int s2255_board_init(struct s2255_dev *dev)
 
 		memset(pipe, 0, sizeof(*pipe));
 		pipe->dev = dev;
-		pipe->cur_transfer_size = DEFAULT_PIPE_USBBLOCK;
-		pipe->max_transfer_size = MAX_PIPE_USBBLOCK;
+		pipe->cur_transfer_size = S2255_USB_XFER_SIZE;
+		pipe->max_transfer_size = S2255_USB_XFER_SIZE;
 
-		if (pipe->cur_transfer_size > pipe->max_transfer_size)
-			pipe->cur_transfer_size = pipe->max_transfer_size;
 		pipe->transfer_buffer = kzalloc(pipe->max_transfer_size,
 						GFP_KERNEL);
 		if (pipe->transfer_buffer == NULL) {
@@ -2247,8 +2290,9 @@ static int s2255_start_acquire(struct s2255_dev *dev, unsigned long chn)
 	dev->last_frame[chn] = -1;
 	dev->bad_payload[chn] = 0;
 	dev->cur_frame[chn] = 0;
+
 	for (j = 0; j < SYS_FRAMES; j++) {
-		dev->buffer[chn].frame[j].ulState = 0;
+		dev->buffer[chn].frame[j].read_state = 0;
 		dev->buffer[chn].frame[j].cur_size = 0;
 	}
 
@@ -2256,7 +2300,7 @@ static int s2255_start_acquire(struct s2255_dev *dev, unsigned long chn)
 	*(u32 *) buffer = IN_DATA_TOKEN;
 	*((u32 *) buffer + 1) = (u32) chn_rev;
 	*((u32 *) buffer + 2) = (u32) CMD_START;
-	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
+	res = s2255_write_config(dev, (unsigned char *)buffer, 512);
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_START error\n");
 
@@ -2288,7 +2332,7 @@ static int s2255_stop_acquire(struct s2255_dev *dev, unsigned long chn)
 	*(u32 *) buffer = IN_DATA_TOKEN;
 	*((u32 *) buffer + 1) = (u32) chn_rev;
 	*((u32 *) buffer + 2) = CMD_STOP;
-	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
+	res = s2255_write_config(dev, (unsigned char *)buffer, 512);
 
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_STOP error\n");
@@ -2358,9 +2402,10 @@ static int s2255_probe(struct usb_interface *interface,
 	struct usb_endpoint_descriptor *endpoint;
 	int i;
 	int retval = -ENOMEM;
+	__le32 *pdata;
+	int fw_size;
 
 	dprintk(2, "s2255: probe\n");
-
 	/* allocate memory for our device state and initialize it to zero */
 	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
 	if (dev == NULL) {
@@ -2383,6 +2428,7 @@ static int s2255_probe(struct usb_interface *interface,
 		goto error;
 	}
 	kref_init(&dev->kref);
+
 	dprintk(1, "dev: %p, kref: %p udev %p interface %p\n", dev, &dev->kref,
 		dev->udev, interface);
 	dev->interface = interface;
@@ -2412,6 +2458,8 @@ static int s2255_probe(struct usb_interface *interface,
 	dev->timer.data = (unsigned long)dev->fw_data;
 
 	init_waitqueue_head(&dev->fw_data->wait_fw);
+	for (i = 0; i < MAX_CHANNELS; i++)
+		init_waitqueue_head(&dev->wait_setmode[i]);
 
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2431,7 +2479,20 @@ static int s2255_probe(struct usb_interface *interface,
 		printk(KERN_ERR "sensoray 2255 failed to get firmware\n");
 		goto error;
 	}
+	/* check the firmware is valid */
+	fw_size = dev->fw_data->fw->size;
+	pdata = (__le32 *) &dev->fw_data->fw->data[fw_size - 8];
 
+	if (*pdata != S2255_FW_MARKER) {
+		printk(KERN_INFO "Firmware invalid.\n");
+		retval = -ENODEV;
+		goto error;
+	} else {
+		/* make sure firmware is the latest */
+		__le32 *pRel;
+		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
+		printk(KERN_INFO "s2255 dsp fw version %x\n", *pRel);
+	}
 	/* loads v4l specific */
 	s2255_probe_v4l(dev);
 	/* load 2255 board specific */
@@ -2451,14 +2512,32 @@ error:
 static void s2255_disconnect(struct usb_interface *interface)
 {
 	struct s2255_dev *dev = NULL;
+	int i;
 	dprintk(1, "s2255: disconnect interface %p\n", interface);
+
+
 	dev = usb_get_intfdata(interface);
+
+	/*
+	 * wake up any of the timers to allow open_lock to be
+	 * acquired sooner
+	 */
+	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
+	wake_up(&dev->fw_data->wait_fw);
+	for (i = 0; i < MAX_CHANNELS; i++) {
+		dev->setmode_ready[i] = 1;
+		wake_up(&dev->wait_setmode[i]);
+	}
+
+	mutex_lock(&dev->open_lock);
+	usb_set_intfdata(interface, NULL);
+	mutex_unlock(&dev->open_lock);
+
 	if (dev) {
 		kref_put(&dev->kref, s2255_destroy);
 		dprintk(1, "s2255drv: disconnect\n");
 		dev_info(&interface->dev, "s2255usb now disconnected\n");
 	}
-	usb_set_intfdata(interface, NULL);
 }
 
 static struct usb_driver s2255_driver = {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
