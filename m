Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7PGxBIU014282
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 12:59:11 -0400
Received: from mail11c.verio-web.com (mail11c.verio-web.com [204.202.242.55])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7PGwxqX020075
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 12:58:59 -0400
Received: from mx55.stngva01.us.mxservers.net (204.202.242.111)
	by mail11c.verio-web.com (RS ver 1.0.95vs) with SMTP id 3-0981303538
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 12:58:58 -0400 (EDT)
Date: Mon, 25 Aug 2008 09:58:55 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, video4linux-list@redhat.com
Message-ID: <tkrat.299efdf58af0cd27@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: greg@kroah.com, dean@sensoray.com
Subject: [PATCH] s2255drv: firmware improvement patch
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

Fix for reloading firmware when removing and reloading driver
Handshaking for firmware loading and changing modes.
Removes the restriction of one user per channel at a time.
JPEG capture mode added.

Signed-off-by: Dean Anderson <dean@sensoray.com>
---
Resource locking partly based on saa7134 driver.
Diff from latest http://linuxtv.org/hg/v4l-dvb.


--- v4l-dvb-a4843e1304e6/linux/drivers/media/video/s2255drv.c.orig	2008-08-24 08:28:11.000000000 -0700
+++ v4l-dvb-a4843e1304e6/linux/drivers/media/video/s2255drv.c	2008-08-25 09:31:01.000000000 -0700
@@ -68,20 +68,21 @@
 /* USB endpoint number for configuring the device */
 #define S2255_CONFIG_EP         2
 /* maximum time for DSP to start responding after last FW word loaded(ms) */
-#define S2255_DSP_BOOTTIME      400
+#define S2255_DSP_BOOTTIME      800
 /* maximum time to wait for firmware to load (ms) */
 #define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
 #define S2255_DEF_BUFS          16
+#define S2255_SETMODE_TIMEOUT   500
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
@@ -109,6 +110,9 @@
 #define COLOR_YUVPL	1	/* YUV planar */
 #define COLOR_YUVPK	2	/* YUV packed */
 #define COLOR_Y8	4	/* monochrome */
+#define COLOR_JPG       5       /* JPEG */
+#define MASK_COLOR      0xff
+#define MASK_JPG_QUALITY 0xff00
 
 /* frame decimation. Not implemented by V4L yet(experimental in V4L) */
 #define FDEC_1		1	/* capture every frame. default */
@@ -149,16 +153,14 @@ struct s2255_mode {
 	u32 restart;	/* if DSP requires restart */
 };
 
-/* frame structure */
-#define FRAME_STATE_UNUSED	0
-#define FRAME_STATE_FILLING	1
-#define FRAME_STATE_FULL	2
 
+#define S2255_READ_IDLE	        0
+#define S2255_READ_FRAME	1
 
+/* frame structure */
 struct s2255_framei {
 	unsigned long size;
-
-	unsigned long ulState;	/* ulState ==0 unused, 1 being filled, 2 full */
+	unsigned long ulState;	/* ulState:S2255_READ_IDLE, S2255_READ_FRAME*/
 	void *lpvbits;		/* image data */
 	unsigned long cur_size;	/* current data copied to it */
 };
@@ -189,6 +191,10 @@ struct s2255_dmaqueue {
 #define S2255_FW_FAILED		3
 #define S2255_FW_DISCONNECTING  4
 
+#define S2255_FW_MARKER         0x22552f2f
+/* 2255 read states */
+#define S2255_READ_IDLE         0
+#define S2255_READ_FRAME        1
 struct s2255_fw {
 	int		      fw_loaded;
 	int		      fw_size;
@@ -196,7 +202,6 @@ struct s2255_fw {
 	atomic_t	      fw_state;
 	void		      *pfw_data;
 	wait_queue_head_t     wait_fw;
-	struct timer_list     dsp_wait;
 	const struct firmware *fw;
 };
 
@@ -243,10 +248,20 @@ struct s2255_dev {
 	int			last_frame[MAX_CHANNELS];
 	u32			cc;	/* current channel */
 	int			b_acquire[MAX_CHANNELS];
+	/* allocated image size */
 	unsigned long		req_image_size[MAX_CHANNELS];
+	/* received packet size */
+	unsigned long		pkt_size[MAX_CHANNELS];
 	int			bad_payload[MAX_CHANNELS];
 	unsigned long		frame_count[MAX_CHANNELS];
 	int			frame_ready;
+	/* if JPEG image */
+	int                     jpg_size[MAX_CHANNELS];
+	/* if channel configured to default state */
+	int                     chn_configured[MAX_CHANNELS];
+	wait_queue_head_t       wait_setmode[MAX_CHANNELS];
+	int                     setmode_ready[MAX_CHANNELS];
+	int                     chn_ready;
 	struct kref		kref;
 	spinlock_t              slock;
 };
@@ -307,12 +322,16 @@ static void s2255_stop_readpipe(struct s
 static int s2255_start_acquire(struct s2255_dev *dev, unsigned long chn);
 static int s2255_stop_acquire(struct s2255_dev *dev, unsigned long chn);
 static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
-			   int chn);
+			   int chn, int jpgsize);
 static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
 			  struct s2255_mode *mode);
 static int s2255_board_shutdown(struct s2255_dev *dev);
 static void s2255_exit_v4l(struct s2255_dev *dev);
-static void s2255_fwload_start(struct s2255_dev *dev);
+static void s2255_fwload_start(struct s2255_dev *dev, int reset);
+static void s2255_destroy(struct kref *kref);
+static long s2255_vendor_req(struct s2255_dev *dev, unsigned char req,
+			     u16 index, u16 value, void *buf,
+			     s32 buf_len, int bOut);
 
 #define dprintk(level, fmt, arg...)					\
 	do {								\
@@ -408,6 +427,10 @@ static const struct s2255_fmt formats[] 
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
@@ -465,6 +488,13 @@ static void planar422p_to_yuv_packed(con
 	return;
 }
 
+void s2255_reset_dsppower(struct s2255_dev *dev)
+{
+	s2255_vendor_req(dev, 0x40, 0x0b0b, 0x0b0b, NULL, 0, 1);
+	msleep(10);
+	s2255_vendor_req(dev, 0x50, 0x0000, 0x0000, NULL, 0, 1);
+	return;
+}
 
 /* kickstarts the firmware loading. from probe
  */
@@ -481,18 +511,6 @@ static void s2255_timer(unsigned long us
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
@@ -550,19 +568,14 @@ static void s2255_fwchunk_complete(struc
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
@@ -587,8 +600,7 @@ static int s2255_got_frame(struct s2255_
 	list_del(&buf->vb.queue);
 	do_gettimeofday(&buf->vb.ts);
 	dprintk(100, "[%p/%d] wakeup\n", buf, buf->vb.i);
-
-	s2255_fillbuff(dev, buf, dma_q->channel);
+	s2255_fillbuff(dev, buf, dma_q->channel, jpgsize);
 	wake_up(&buf->vb.done);
 	dprintk(2, "wakeup [buf/i] [%p/%d]\n", buf, buf->vb.i);
 unlock:
@@ -622,7 +634,7 @@ static const struct s2255_fmt *format_by
  *
  */
 static void s2255_fillbuff(struct s2255_dev *dev, struct s2255_buffer *buf,
-			   int chn)
+			   int chn, int jpgsize)
 {
 	int pos = 0;
 	struct timeval ts;
@@ -650,6 +662,10 @@ static void s2255_fillbuff(struct s2255_
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
@@ -658,9 +674,6 @@ static void s2255_fillbuff(struct s2255_
 			printk(KERN_DEBUG "s2255: unknown format?\n");
 		}
 		dev->last_frame[chn] = -1;
-		/* done with the frame, free it */
-		frm->ulState = 0;
-		dprintk(4, "freeing buffer\n");
 	} else {
 		printk(KERN_ERR "s2255: =======no frame\n");
 		return;
@@ -1022,6 +1035,9 @@ static int vidioc_s_fmt_vid_cap(struct f
 	case V4L2_PIX_FMT_GREY:
 		fh->mode.color = COLOR_Y8;
 		break;
+	case V4L2_PIX_FMT_JPEG:
+		fh->mode.color = COLOR_JPG | (50 << 8);
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 		fh->mode.color = COLOR_YUVPL;
 		break;
@@ -1140,7 +1156,7 @@ static u32 get_transfer_size(struct s225
 		}
 	}
 	outImageSize = linesPerFrame * pixelsPerLine;
-	if (mode->color != COLOR_Y8) {
+	if ((mode->color & MASK_COLOR) != COLOR_Y8) {
 		/* 2 bytes/pixel if not monochrome */
 		outImageSize *= 2;
 	}
@@ -1186,6 +1202,7 @@ static int s2255_set_mode(struct s2255_d
 	u32 *buffer;
 	unsigned long chn_rev;
 
+	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
 	dprintk(3, "mode scale [%ld] %p %d\n", chn, mode, mode->scale);
 	dprintk(3, "mode scale [%ld] %p %d\n", chn, &dev->mode[chn],
@@ -1200,6 +1217,7 @@ static int s2255_set_mode(struct s2255_d
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
+		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 
@@ -1215,12 +1233,20 @@ static int s2255_set_mode(struct s2255_d
 	dprintk(1, "set mode done chn %lu, %d\n", chn, res);
 
 	/* wait at least 3 frames before continuing */
-	if (mode->restart)
-		msleep(125);
+	if (mode->restart) {
+		dev->setmode_ready[chn] = 0;
+		wait_event_timeout(dev->wait_setmode[chn],
+				   (dev->setmode_ready[chn] != 0),
+				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
+		if (dev->setmode_ready[chn] != 1) {
+			printk(KERN_DEBUG "s2255: no set mode response\n");
+			res = -EFAULT;
+		}
+	}
 
 	/* clear the restart flag */
 	dev->mode[chn].restart = 0;
-
+	mutex_unlock(&dev->lock);
 	return res;
 }
 
@@ -1270,7 +1296,7 @@ static int vidioc_streamon(struct file *
 	dev->bad_payload[chn] = 0;
 	dev->cur_frame[chn] = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
-		dev->buffer[chn].frame[j].ulState = 0;
+		dev->buffer[chn].frame[j].ulState = S2255_READ_IDLE;
 		dev->buffer[chn].frame[j].cur_size = 0;
 	}
 	res = videobuf_streamon(&fh->vb_vidq);
@@ -1455,6 +1481,7 @@ static int s2255_open(struct inode *inod
 	enum v4l2_buf_type type = 0;
 	int i = 0;
 	int cur_channel = -1;
+	int state;
 	dprintk(1, "s2255: open called (minor=%d)\n", minor);
 
 	lock_kernel();
@@ -1471,47 +1498,77 @@ static int s2255_open(struct inode *inod
 
 	if ((NULL == dev) || (cur_channel == -1)) {
 		unlock_kernel();
-		dprintk(1, "s2255: openv4l no dev\n");
+		printk(KERN_INFO "s2255: openv4l no dev\n");
 		return -ENODEV;
 	}
 
+	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_DISCONNECTING) {
+		unlock_kernel();
+		printk(KERN_INFO "disconnecting\n");
+		return -ENODEV;
+	}
+	kref_get(&dev->kref);
 	mutex_lock(&dev->open_lock);
 
 	dev->users[cur_channel]++;
 	dprintk(4, "s2255: open_handles %d\n", dev->users[cur_channel]);
 
-	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_FAILED) {
+	switch (atomic_read(&dev->fw_data->fw_state)) {
+	case S2255_FW_FAILED:
 		err("2255 firmware load failed. retrying.\n");
-		s2255_fwload_start(dev);
+		s2255_fwload_start(dev, 1);
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
-			printk(KERN_INFO "2255 FW load failed.\n");
-			dev->users[cur_channel]--;
-			mutex_unlock(&dev->open_lock);
-			unlock_kernel();
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
-			dev->users[cur_channel]--;
-			mutex_unlock(&dev->open_lock);
-			unlock_kernel();
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
+			rc = -ENODEV;
+			break;
+		case S2255_FW_DISCONNECTING:
+			printk(KERN_INFO "%s: disconnecting\n", __func__);
+			rc = -ENODEV;
+			break;
+		case S2255_FW_LOADED_DSPWAIT:
+		case S2255_FW_NOTLOADED:
+			printk(KERN_INFO "%s: firmware not loaded yet"
+			       "please try again later\n",
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
+		unlock_kernel();
+		return rc;
 	}
 
 	/* allocate + initialize per filehandle data */
@@ -1519,6 +1576,7 @@ static int s2255_open(struct inode *inod
 	if (NULL == fh) {
 		dev->users[cur_channel]--;
 		mutex_unlock(&dev->open_lock);
+		kref_put(&dev->kref, s2255_destroy);
 		unlock_kernel();
 		return -ENOMEM;
 	}
@@ -1533,6 +1591,13 @@ static int s2255_open(struct inode *inod
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
@@ -1551,7 +1616,6 @@ static int s2255_open(struct inode *inod
 				    V4L2_FIELD_INTERLACED,
 				    sizeof(struct s2255_buffer), fh);
 
-	kref_get(&dev->kref);
 	mutex_unlock(&dev->open_lock);
 	unlock_kernel();
 	return 0;
@@ -1575,30 +1639,24 @@ static unsigned int s2255_poll(struct fi
 static void s2255_destroy(struct kref *kref)
 {
 	struct s2255_dev *dev = to_s2255_dev(kref);
+	struct list_head *list;
+	int i;
 	if (!dev) {
 		printk(KERN_ERR "s2255drv: kref problem\n");
 		return;
 	}
-
-	/*
-	 * Wake up any firmware load waiting (only done in .open,
-	 * which holds the open_lock mutex)
-	 */
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
 	wake_up(&dev->fw_data->wait_fw);
-
-	/* prevent s2255_disconnect from racing s2255_open */
+	for (i = 0; i < MAX_CHANNELS; i++) {
+		dev->setmode_ready[i] = 1;
+		wake_up(&dev->wait_setmode[i]);
+	}
 	mutex_lock(&dev->open_lock);
+	/* reset the DSP so firmware can be reload next time */
+	s2255_reset_dsppower(dev);
 	s2255_exit_v4l(dev);
-	/*
-	 * device unregistered so no longer possible to open. open_mutex
-	 *  can be unlocked and timers deleted afterwards.
-	 */
-	mutex_unlock(&dev->open_lock);
-
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
-
 	/* make sure firmware still not trying to load */
 	del_timer(&dev->timer);  /* only started in .probe and .open */
 
@@ -1608,23 +1666,19 @@ static void s2255_destroy(struct kref *k
 		usb_free_urb(dev->fw_data->fw_urb);
 		dev->fw_data->fw_urb = NULL;
 	}
-
-	/*
-	 * delete the dsp_wait timer, which sets the firmware
-	 * state on completion.  This is done before fw_data
-	 * is freed below.
-	 */
-
-	del_timer(&dev->fw_data->dsp_wait); /* only started in .open */
-
 	if (dev->fw_data->fw)
 		release_firmware(dev->fw_data->fw);
 	kfree(dev->fw_data->pfw_data);
 	kfree(dev->fw_data);
-
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
@@ -1760,18 +1814,16 @@ static int s2255_probe_v4l(struct s2255_
 
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
 
@@ -1781,134 +1833,123 @@ static void s2255_exit_v4l(struct s2255_
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
+	frm = &dev->buffer[dev->cc].frame[idx];
 
-	if (bsearch) {
-		if (*(s32 *) pipe_info->transfer_buffer != FRAME_MARKER) {
-			u32 jj;
-			if (dbgsync == 0) {
-				dprintk(3, "not synched, discarding all packets"
-					"until marker\n");
+	if (frm->ulState == S2255_READ_IDLE) {
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
+					break;
+				case 0x10:
 
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
+					dev->chn_ready |= (1 << cc);
+					if ((dev->chn_ready & 0x0f) != 0x0f)
+						break;
+					/* all channels ready */
+					printk(KERN_INFO "s2255: fw loaded\n");
+					atomic_set(&dev->fw_data->fw_state,
+						   S2255_FW_SUCCESS);
+					wake_up(&dev->fw_data->wait_fw);
 					break;
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
+		frm->ulState = S2255_READ_IDLE;
+		return -EINVAL;
 	}
 
-	if (bsync) {
-		/* skip the marker 512 bytes (and offset if out of sync) */
-		psrc = (u8 *)pipe_info->transfer_buffer + offset + PREFIX_SIZE;
-	} else {
-		psrc = (u8 *)pipe_info->transfer_buffer;
+	if (frm->ulState == S2255_READ_IDLE) {
+		frm->ulState = S2255_READ_FRAME;
+		frm->cur_size = 0;
 	}
 
+	/* skip the marker 512 bytes (and offset if out of sync) */
+	psrc = (u8 *)pipe_info->transfer_buffer + offset;
+
+
 	if (frm->lpvbits == NULL) {
 		dprintk(1, "s2255 frame buffer == NULL.%p %p %d %d",
 			frm, dev, dev->cc, idx);
@@ -1917,33 +1958,20 @@ static int save_frame(struct s2255_dev *
 
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
@@ -1952,16 +1980,13 @@ static int save_frame(struct s2255_dev *
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
+		frm->ulState = S2255_READ_IDLE;
+		frm->cur_size = 0;
+
 	}
 	/* done successfully */
 	return 0;
@@ -1980,8 +2005,8 @@ static void s2255_read_video_callback(st
 	}
 	/* otherwise copy to the system buffers */
 	res = save_frame(dev, pipe_info);
-	if (res == EAGAIN)
-		save_frame(dev, pipe_info);
+	if (res != 0)
+		dprintk(4, "s2255: read callback failed\n");
 
 	dprintk(50, "callback read video done\n");
 	return;
@@ -2101,11 +2126,9 @@ static int s2255_board_init(struct s2255
 
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
@@ -2329,7 +2352,7 @@ static int s2255_stop_acquire(struct s22
 	kfree(buffer);
 	dev->b_acquire[chn] = 0;
 
-	return 0;
+	return res;
 }
 
 static void s2255_stop_readpipe(struct s2255_dev *dev)
@@ -2365,8 +2388,10 @@ static void s2255_stop_readpipe(struct s
 	return;
 }
 
-static void s2255_fwload_start(struct s2255_dev *dev)
+static void s2255_fwload_start(struct s2255_dev *dev, int reset)
 {
+	if (reset)
+		s2255_reset_dsppower(dev);
 	dev->fw_data->fw_size = dev->fw_data->fw->size;
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_NOTLOADED);
 	memcpy(dev->fw_data->pfw_data,
@@ -2389,6 +2414,8 @@ static int s2255_probe(struct usb_interf
 	struct usb_endpoint_descriptor *endpoint;
 	int i;
 	int retval = -ENOMEM;
+	__le32 *pdata;
+	int fw_size;
 
 	dprintk(2, "s2255: probe\n");
 
@@ -2443,6 +2470,8 @@ static int s2255_probe(struct usb_interf
 	dev->timer.data = (unsigned long)dev->fw_data;
 
 	init_waitqueue_head(&dev->fw_data->wait_fw);
+	for (i = 0; i < MAX_CHANNELS; i++)
+		init_waitqueue_head(&dev->wait_setmode[i]);
 
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2462,16 +2491,30 @@ static int s2255_probe(struct usb_interf
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
+	usb_reset_device(dev->udev);
 	/* load 2255 board specific */
 	s2255_board_init(dev);
 
 	dprintk(4, "before probe done %p\n", dev);
 	spin_lock_init(&dev->slock);
 
-	s2255_fwload_start(dev);
+	s2255_fwload_start(dev, 0);
 	dev_info(&interface->dev, "Sensoray 2255 detected\n");
 	return 0;
 error:
@@ -2482,14 +2525,30 @@ error:
 static void s2255_disconnect(struct usb_interface *interface)
 {
 	struct s2255_dev *dev = NULL;
+	int i;
 	dprintk(1, "s2255: disconnect interface %p\n", interface);
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
