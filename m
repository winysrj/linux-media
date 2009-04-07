Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11b.verio-web.com ([204.202.242.87]:45903 "HELO
	mail11b.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758127AbZDGSDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 14:03:22 -0400
Received: from mx09.stngva01.us.mxservers.net (204.202.242.68)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 4-0747516999
	for <linux-media@vger.kernel.org>; Tue,  7 Apr 2009 13:56:40 -0400 (EDT)
Date: Tue, 7 Apr 2009 10:56:36 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: patch: s2255drv high quality mode and video status querying
To: linux-media@vger.kernel.org, mchehab@infradead.org,
	video4linux-list@redhat.com
Message-ID: <tkrat.2351cf1cef386315@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dean Anderson <dean@sensoray.com>

This patch adds V4L2 video status capability and V4L2_MODE_HIGHQUALITY
operation.

Signed-off-by: Dean Anderson <dean@sensoray.com>

--- v4l-dvb-1e670024659d/linux/drivers/media/video/s2255drv.c.orig	2009-04-07 10:38:42.000000000 -0700
+++ v4l-dvb-1e670024659d/linux/drivers/media/video/s2255drv.c	2009-04-07 10:42:51.000000000 -0700
@@ -57,7 +57,8 @@
 
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
 
-
+#define S2255_REV_MAJOR 1
+#define S2255_REV_MINOR 20
 
 /* default JPEG quality */
 #define S2255_DEF_JPEG_QUAL     50
@@ -75,9 +76,13 @@
 #define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
 #define S2255_DEF_BUFS          16
 #define S2255_SETMODE_TIMEOUT   500
+#define S2255_VIDSTATUS_TIMEOUT 350
 #define MAX_CHANNELS		4
-#define S2255_MARKER_FRAME	0x2255DA4AL
-#define S2255_MARKER_RESPONSE	0x2255ACACL
+#define S2255_MARKER_FRAME	cpu_to_le32(0x2255DA4AL)
+#define S2255_MARKER_RESPONSE	cpu_to_le32(0x2255ACACL)
+#define S2255_RESPONSE_SETMODE  cpu_to_le32(0x01)
+#define S2255_RESPONSE_FW       cpu_to_le32(0x10)
+#define S2255_RESPONSE_STATUS   cpu_to_le32(0x20)
 #define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
@@ -100,14 +105,16 @@
 #define LINE_SZ_DEF		640
 #define NUM_LINES_DEF		240
 
-
 /* predefined settings */
 #define FORMAT_NTSC	1
 #define FORMAT_PAL	2
 
+/* SCALE_4CIFS is the 2 fields merge into one */
 #define SCALE_4CIFS	1	/* 640x480(NTSC) or 704x576(PAL) */
 #define SCALE_2CIFS	2	/* 640x240(NTSC) or 704x288(PAL) */
 #define SCALE_1CIFS	3	/* 320x240(NTSC) or 352x288(PAL) */
+/* SCALE_4CIFSI is the 2 fields interpolated into one */
+#define SCALE_4CIFSI	4	/* 640x480(NTSC) or 704x576(PAL) high quality */
 
 #define COLOR_YUVPL	1	/* YUV planar */
 #define COLOR_YUVPK	2	/* YUV packed */
@@ -134,12 +141,12 @@
 #define DEF_HUE		0
 
 /* usb config commands */
-#define IN_DATA_TOKEN	0x2255c0de
-#define CMD_2255	0xc2255000
-#define CMD_SET_MODE	(CMD_2255 | 0x10)
-#define CMD_START	(CMD_2255 | 0x20)
-#define CMD_STOP	(CMD_2255 | 0x30)
-#define CMD_STATUS	(CMD_2255 | 0x40)
+#define IN_DATA_TOKEN	cpu_to_le32(0x2255c0de)
+#define CMD_2255	cpu_to_le32(0xc2255000)
+#define CMD_SET_MODE	cpu_to_le32((CMD_2255 | 0x10))
+#define CMD_START	cpu_to_le32((CMD_2255 | 0x20))
+#define CMD_STOP	cpu_to_le32((CMD_2255 | 0x30))
+#define CMD_STATUS	cpu_to_le32((CMD_2255 | 0x40))
 
 struct s2255_mode {
 	u32 format;	/* input video format (NTSC, PAL) */
@@ -181,7 +188,6 @@ struct s2255_dmaqueue {
 	struct list_head	active;
 	/* thread for acquisition */
 	struct task_struct	*kthread;
-	int			frame;
 	struct s2255_dev	*dev;
 	int			channel;
 };
@@ -211,16 +217,12 @@ struct s2255_pipeinfo {
 	u32 max_transfer_size;
 	u32 cur_transfer_size;
 	u8 *transfer_buffer;
-	u32 transfer_flags;;
 	u32 state;
-	u32 prev_state;
 	u32 urb_size;
 	void *stream_urb;
 	void *dev;	/* back pointer to s2255_dev struct*/
 	u32 err_count;
-	u32 buf_index;
 	u32 idx;
-	u32 priority_set;
 };
 
 struct s2255_fmt; /*forward declaration */
@@ -239,14 +241,15 @@ struct s2255_dev {
 	struct video_device	*vdev[MAX_CHANNELS];
 	struct list_head	s2255_devlist;
 	struct timer_list	timer;
-	struct s2255_fw	*fw_data;
-	int			board_num;
-	int			is_open;
+	struct s2255_fw		*fw_data;
 	struct s2255_pipeinfo	pipes[MAX_PIPE_BUFFERS];
 	struct s2255_bufferi		buffer[MAX_CHANNELS];
 	struct s2255_mode	mode[MAX_CHANNELS];
 	/* jpeg compression */
 	struct v4l2_jpegcompression jc[MAX_CHANNELS];
+	/* capture parameters (for high quality mode full size) */
+	struct v4l2_captureparm cap_parm[MAX_CHANNELS];
+
 	const struct s2255_fmt	*cur_fmt[MAX_CHANNELS];
 	int			cur_frame[MAX_CHANNELS];
 	int			last_frame[MAX_CHANNELS];
@@ -265,9 +268,16 @@ struct s2255_dev {
 	int                     chn_configured[MAX_CHANNELS];
 	wait_queue_head_t       wait_setmode[MAX_CHANNELS];
 	int                     setmode_ready[MAX_CHANNELS];
+	/* video status items */
+	int                     vidstatus[MAX_CHANNELS];
+	wait_queue_head_t       wait_vidstatus[MAX_CHANNELS];
+	int                     vidstatus_ready[MAX_CHANNELS];
+
 	int                     chn_ready;
 	struct kref		kref;
 	spinlock_t              slock;
+	/* dsp firmware version (f2255usb.bin) */
+	int                     dsp_fw_ver;
 };
 #define to_s2255_dev(d) container_of(d, struct s2255_dev, kref)
 
@@ -298,7 +308,16 @@ struct s2255_fh {
 	int			resources[MAX_CHANNELS];
 };
 
-#define CUR_USB_FWVER	774	/* current cypress EEPROM firmware version */
+/* current cypress EEPROM firmware version (3.6) */
+#define S2255_CUR_USB_FWVER	((3 << 8) | 6)
+/* current DSP FW version */
+#define S2255_CUR_DSP_FWVER 5
+/*
+ * requires version 5 or later of firmware(above)
+ *  to enable vid status feature
+ */
+#define S2255_MIN_DSP_STATUS   5
+
 #define S2255_MAJOR_VERSION	1
 #define S2255_MINOR_VERSION	13
 #define S2255_RELEASE		0
@@ -577,6 +596,7 @@ static void s2255_fwchunk_complete(struc
 		}
 		data->fw_loaded += len;
 	} else {
+		dprintk(1, "s2255: fw sent waiting for response\n");
 		atomic_set(&data->fw_state, S2255_FW_LOADED_DSPWAIT);
 	}
 	dprintk(100, "2255 complete done\n");
@@ -1028,9 +1048,16 @@ static int vidioc_s_fmt_vid_cap(struct f
 	fh->type = f->type;
 	norm = norm_minw(fh->dev->vdev[fh->channel]);
 	if (fh->width > norm_minw(fh->dev->vdev[fh->channel])) {
-		if (fh->height > norm_minh(fh->dev->vdev[fh->channel]))
-			fh->mode.scale = SCALE_4CIFS;
-		else
+		if (fh->height > norm_minh(fh->dev->vdev[fh->channel])) {
+			if (fh->dev->cap_parm[fh->channel].capturemode &
+			    V4L2_MODE_HIGHQUALITY) {
+				fh->mode.scale = SCALE_4CIFSI;
+				dprintk(2, "scale 4CIFSI\n");
+			} else {
+				fh->mode.scale = SCALE_4CIFS;
+				dprintk(2, "scale 4CIFS\n");
+			}
+		} else
 			fh->mode.scale = SCALE_2CIFS;
 
 	} else {
@@ -1131,6 +1158,7 @@ static u32 get_transfer_size(struct s225
 	if (mode->format == FORMAT_NTSC) {
 		switch (mode->scale) {
 		case SCALE_4CIFS:
+		case SCALE_4CIFSI:
 			linesPerFrame = NUM_LINES_4CIFS_NTSC * 2;
 			pixelsPerLine = LINE_SZ_4CIFS_NTSC;
 			break;
@@ -1148,6 +1176,7 @@ static u32 get_transfer_size(struct s225
 	} else if (mode->format == FORMAT_PAL) {
 		switch (mode->scale) {
 		case SCALE_4CIFS:
+		case SCALE_4CIFSI:
 			linesPerFrame = NUM_LINES_4CIFS_PAL * 2;
 			pixelsPerLine = LINE_SZ_4CIFS_PAL;
 			break;
@@ -1207,8 +1236,8 @@ static int s2255_set_mode(struct s2255_d
 			  struct s2255_mode *mode)
 {
 	int res;
-	u32 *buffer;
-	unsigned long chn_rev;
+	__le32 *buffer;
+	u32 chn_rev;
 
 	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
@@ -1235,9 +1264,10 @@ static int s2255_set_mode(struct s2255_d
 
 	/* set the mode */
 	buffer[0] = IN_DATA_TOKEN;
-	buffer[1] = (u32) chn_rev;
+	buffer[1] = cpu_to_le32(chn_rev);
 	buffer[2] = CMD_SET_MODE;
 	memcpy(&buffer[3], &dev->mode[chn], sizeof(struct s2255_mode));
+	dev->setmode_ready[chn] = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
 		dump_verify_mode(dev, mode);
@@ -1246,7 +1276,6 @@ static int s2255_set_mode(struct s2255_d
 
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
-		dev->setmode_ready[chn] = 0;
 		wait_event_timeout(dev->wait_setmode[chn],
 				   (dev->setmode_ready[chn] != 0),
 				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
@@ -1262,6 +1291,43 @@ static int s2255_set_mode(struct s2255_d
 	return res;
 }
 
+static int s2255_cmd_status(struct s2255_dev *dev, unsigned long chn,
+			    u32 *pstatus)
+{
+	int res;
+	__le32 *buffer;
+	u32 chn_rev;
+
+	mutex_lock(&dev->lock);
+	chn_rev = G_chnmap[chn];
+	dprintk(4, "s2255_get_status: chan %d\n", chn_rev);
+	buffer = kzalloc(512, GFP_KERNEL);
+	if (buffer == NULL) {
+		dev_err(&dev->udev->dev, "out of mem\n");
+		mutex_unlock(&dev->lock);
+		return -ENOMEM;
+	}
+	/* form the get vid status command */
+	buffer[0] = IN_DATA_TOKEN;
+	buffer[1] = cpu_to_le32(chn_rev);
+	buffer[2] = CMD_STATUS;
+	*pstatus = 0;
+	dev->vidstatus_ready[chn] = 0;
+	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
+	kfree(buffer);
+	wait_event_timeout(dev->wait_vidstatus[chn],
+			   (dev->vidstatus_ready[chn] != 0),
+			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
+	if (dev->vidstatus_ready[chn] != 1) {
+		printk(KERN_DEBUG "s2255: no vidstatus response\n");
+		res = -EFAULT;
+	}
+	*pstatus = dev->vidstatus[chn];
+	dprintk(4, "s2255: vid status %d\n", *pstatus);
+	mutex_unlock(&dev->lock);
+	return res;
+}
+
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	int res;
@@ -1387,11 +1453,24 @@ out_s_std:
 static int vidioc_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *inp)
 {
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+	u32 status = 0;
+
 	if (inp->index != 0)
 		return -EINVAL;
 
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = S2255_NORMS;
+	inp->status = 0;
+	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
+		int rc;
+		rc = s2255_cmd_status(dev, fh->channel, &status);
+		dprintk(4, "s2255_cmd_status rc: %d status %x\n", rc, status);
+		if (rc == 0)
+			inp->status =  (status & 0x01) ? 0
+				: V4L2_IN_ST_NO_SIGNAL;
+	}
 	strlcpy(inp->name, "Camera", sizeof(inp->name));
 	return 0;
 }
@@ -1503,6 +1582,34 @@ static int vidioc_s_jpegcomp(struct file
 	dprintk(2, "setting jpeg quality %d\n", jc->quality);
 	return 0;
 }
+
+static int vidioc_g_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	sp->parm.capture.capturemode = dev->cap_parm[fh->channel].capturemode;
+	dprintk(2, "getting parm %d\n", sp->parm.capture.capturemode);
+	return 0;
+}
+
+static int vidioc_s_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+
+	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	dev->cap_parm[fh->channel].capturemode = sp->parm.capture.capturemode;
+	dprintk(2, "setting param capture mode %d\n",
+		sp->parm.capture.capturemode);
+	return 0;
+}
+
 static int s2255_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
@@ -1682,6 +1789,8 @@ static void s2255_destroy(struct kref *k
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		dev->setmode_ready[i] = 1;
 		wake_up(&dev->wait_setmode[i]);
+		dev->vidstatus_ready[i] = 1;
+		wake_up(&dev->wait_vidstatus[i]);
 	}
 	mutex_lock(&dev->open_lock);
 	/* reset the DSP so firmware can be reload next time */
@@ -1794,6 +1903,8 @@ static const struct v4l2_ioctl_ops s2255
 #endif
 	.vidioc_s_jpegcomp = vidioc_s_jpegcomp,
 	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
+	.vidioc_s_parm = vidioc_s_parm,
+	.vidioc_g_parm = vidioc_g_parm,
 };
 
 static struct video_device template = {
@@ -1840,7 +1951,9 @@ static int s2255_probe_v4l(struct s2255_
 			return ret;
 		}
 	}
-	printk(KERN_INFO "Sensoray 2255 V4L driver\n");
+	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %d.%d\n",
+	       S2255_REV_MAJOR,
+	       S2255_REV_MINOR);
 	return ret;
 }
 
@@ -1890,14 +2003,14 @@ static int save_frame(struct s2255_dev *
 	if (frm->ulState == S2255_READ_IDLE) {
 		int jj;
 		unsigned int cc;
-		s32 *pdword;
+		__le32 *pdword; /*data from dsp is little endian */
 		int payload;
 		/* search for marker codes */
 		pdata = (unsigned char *)pipe_info->transfer_buffer;
 		for (jj = 0; jj < (pipe_info->cur_transfer_size - 12); jj++) {
-			switch (*(s32 *) pdata) {
+			switch (*(__le32 *) pdata) {
 			case S2255_MARKER_FRAME:
-				pdword = (s32 *)pdata;
+				pdword = (__le32 *)pdata;
 				dprintk(4, "found frame marker at offset:"
 					" %d [%x %x]\n", jj, pdata[0],
 					pdata[1]);
@@ -1921,7 +2034,7 @@ static int save_frame(struct s2255_dev *
 				dev->jpg_size[dev->cc] = pdword[4];
 				break;
 			case S2255_MARKER_RESPONSE:
-				pdword = (s32 *)pdata;
+				pdword = (__le32 *)pdata;
 				pdata += DEF_USB_BLOCK;
 				jj += DEF_USB_BLOCK;
 				if (pdword[1] >= MAX_CHANNELS)
@@ -1930,15 +2043,14 @@ static int save_frame(struct s2255_dev *
 				if (!(cc >= 0 && cc < MAX_CHANNELS))
 					break;
 				switch (pdword[2]) {
-				case 0x01:
+				case S2255_RESPONSE_SETMODE:
 					/* check if channel valid */
 					/* set mode ready */
 					dev->setmode_ready[cc] = 1;
 					wake_up(&dev->wait_setmode[cc]);
 					dprintk(5, "setmode ready %d\n", cc);
 					break;
-				case 0x10:
-
+				case S2255_RESPONSE_FW:
 					dev->chn_ready |= (1 << cc);
 					if ((dev->chn_ready & 0x0f) != 0x0f)
 						break;
@@ -1948,6 +2060,13 @@ static int save_frame(struct s2255_dev *
 						   S2255_FW_SUCCESS);
 					wake_up(&dev->fw_data->wait_fw);
 					break;
+				case S2255_RESPONSE_STATUS:
+					dev->vidstatus[cc] = pdword[3];
+					dev->vidstatus_ready[cc] = 1;
+					wake_up(&dev->wait_vidstatus[cc]);
+					dprintk(5, "got vidstatus %x chan %d\n",
+						pdword[3], cc);
+					break;
 				default:
 					printk(KERN_INFO "s2255 unknwn resp\n");
 				}
@@ -2173,10 +2292,15 @@ static int s2255_board_init(struct s2255
 	/* query the firmware */
 	fw_ver = s2255_get_fx2fw(dev);
 
-	printk(KERN_INFO "2255 usb firmware version %d \n", fw_ver);
-	if (fw_ver < CUR_USB_FWVER)
+	printk(KERN_INFO "2255 usb firmware version %d.%d\n",
+	       (fw_ver >> 8) & 0xff,
+	       fw_ver & 0xff);
+
+	if (fw_ver < S2255_CUR_USB_FWVER)
 		dev_err(&dev->udev->dev,
-			"usb firmware not up to date %d\n", fw_ver);
+			"usb firmware not up to date %d.%d\n",
+			(fw_ver >> 8) & 0xff,
+			fw_ver & 0xff);
 
 	for (j = 0; j < MAX_CHANNELS; j++) {
 		dev->b_acquire[j] = 0;
@@ -2241,8 +2365,10 @@ static void read_pipe_completion(struct 
 		return;
 	}
 	status = purb->status;
-	if (status != 0) {
-		dprintk(2, "read_pipe_completion: err\n");
+	/* if shutting down, do not resubmit, exit immediately */
+	if (status == -ESHUTDOWN) {
+		dprintk(2, "read_pipe_completion: err shutdown\n");
+		pipe_info->err_count++;
 		return;
 	}
 
@@ -2251,9 +2377,13 @@ static void read_pipe_completion(struct 
 		return;
 	}
 
-	s2255_read_video_callback(dev, pipe_info);
+	if (status == 0)
+		s2255_read_video_callback(dev, pipe_info);
+	else {
+		pipe_info->err_count++;
+		dprintk(1, "s2255drv: failed URB %d\n", status);
+	}
 
-	pipe_info->err_count = 0;
 	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
 	/* reuse urb */
 	usb_fill_bulk_urb(pipe_info->stream_urb, dev->udev,
@@ -2265,7 +2395,6 @@ static void read_pipe_completion(struct 
 	if (pipe_info->state != 0) {
 		if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL)) {
 			dev_err(&dev->udev->dev, "error submitting urb\n");
-			usb_free_urb(pipe_info->stream_urb);
 		}
 	} else {
 		dprintk(2, "read pipe complete state 0\n");
@@ -2284,8 +2413,7 @@ static int s2255_start_readpipe(struct s
 
 	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
 		pipe_info->state = 1;
-		pipe_info->buf_index = (u32) i;
-		pipe_info->priority_set = 0;
+		pipe_info->err_count = 0;
 		pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!pipe_info->stream_urb) {
 			dev_err(&dev->udev->dev,
@@ -2316,7 +2444,7 @@ static int s2255_start_acquire(struct s2
 {
 	unsigned char *buffer;
 	int res;
-	unsigned long chn_rev;
+	u32 chn_rev;
 	int j;
 	if (chn >= MAX_CHANNELS) {
 		dprintk(2, "start acquire failed, bad channel %lu\n", chn);
@@ -2341,9 +2469,9 @@ static int s2255_start_acquire(struct s2
 	}
 
 	/* send the start command */
-	*(u32 *) buffer = IN_DATA_TOKEN;
-	*((u32 *) buffer + 1) = (u32) chn_rev;
-	*((u32 *) buffer + 2) = (u32) CMD_START;
+	*(__le32 *) buffer = IN_DATA_TOKEN;
+	*((__le32 *) buffer + 1) =  cpu_to_le32(chn_rev);
+	*((__le32 *) buffer + 2) = CMD_START;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_START error\n");
@@ -2373,9 +2501,9 @@ static int s2255_stop_acquire(struct s22
 
 	/* send the stop command */
 	dprintk(4, "stop acquire %lu\n", chn);
-	*(u32 *) buffer = IN_DATA_TOKEN;
-	*((u32 *) buffer + 1) = (u32) chn_rev;
-	*((u32 *) buffer + 2) = CMD_STOP;
+	*(__le32 *) buffer = IN_DATA_TOKEN;
+	*((__le32 *) buffer + 1) = cpu_to_le32(chn_rev);
+	*((__le32 *) buffer + 2) = CMD_STOP;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 
 	if (res != 0)
@@ -2404,8 +2532,6 @@ static void s2255_stop_readpipe(struct s
 			if (pipe_info->state == 0)
 				continue;
 			pipe_info->state = 0;
-			pipe_info->prev_state = 1;
-
 		}
 	}
 
@@ -2504,9 +2630,10 @@ static int s2255_probe(struct usb_interf
 	dev->timer.data = (unsigned long)dev->fw_data;
 
 	init_waitqueue_head(&dev->fw_data->wait_fw);
-	for (i = 0; i < MAX_CHANNELS; i++)
+	for (i = 0; i < MAX_CHANNELS; i++) {
 		init_waitqueue_head(&dev->wait_setmode[i]);
-
+		init_waitqueue_head(&dev->wait_vidstatus[i]);
+	}
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
 
@@ -2538,12 +2665,17 @@ static int s2255_probe(struct usb_interf
 		__le32 *pRel;
 		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
 		printk(KERN_INFO "s2255 dsp fw version %x\n", *pRel);
+		dev->dsp_fw_ver = *pRel;
+		if (*pRel < S2255_CUR_DSP_FWVER)
+			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
 	}
 	/* loads v4l specific */
 	s2255_probe_v4l(dev);
 	usb_reset_device(dev->udev);
 	/* load 2255 board specific */
-	s2255_board_init(dev);
+	retval = s2255_board_init(dev);
+	if (retval)
+		goto error;
 
 	dprintk(4, "before probe done %p\n", dev);
 	spin_lock_init(&dev->slock);
@@ -2572,6 +2704,8 @@ static void s2255_disconnect(struct usb_
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		dev->setmode_ready[i] = 1;
 		wake_up(&dev->wait_setmode[i]);
+		dev->vidstatus_ready[i] = 1;
+		wake_up(&dev->wait_vidstatus[i]);
 	}
 
 	mutex_lock(&dev->open_lock);

