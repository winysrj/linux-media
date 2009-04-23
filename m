Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11b.verio-web.com ([204.202.242.87]:11903 "HELO
	mail11b.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754913AbZDWTEq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 15:04:46 -0400
Received: from mx24.stngva01.us.mxservers.net (204.202.242.8)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 0-0783063485
	for <linux-media@vger.kernel.org>; Thu, 23 Apr 2009 15:04:45 -0400 (EDT)
Date: Thu, 23 Apr 2009 12:04:41 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: patch: s2255drv: code cleanup
To: linux-media@vger.kernel.org, mchehab@infradead.org,
	video4linux-list@redhat.com
Message-ID: <tkrat.b7a503ea777a7f0e@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dean Anderson <dean@sensoray.com>

Removal of unused structure items. Response values defined. Driver revision printk.

Signed-off-by: Dean Anderson <dean@sensoray.com>

--- v4l-dvb-ebb7b82f2b48/linux/drivers/media/video/s2255drv.c.orig	2009-04-23 11:37:28.000000000 -0700
+++ v4l-dvb-ebb7b82f2b48/linux/drivers/media/video/s2255drv.c	2009-04-23 11:54:24.000000000 -0700
@@ -78,6 +78,8 @@
 #define MAX_CHANNELS		4
 #define S2255_MARKER_FRAME	0x2255DA4AL
 #define S2255_MARKER_RESPONSE	0x2255ACACL
+#define S2255_RESPONSE_SETMODE  0x01
+#define S2255_RESPONSE_FW       0x10
 #define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
@@ -179,9 +181,6 @@ struct s2255_bufferi {
 
 struct s2255_dmaqueue {
 	struct list_head	active;
-	/* thread for acquisition */
-	struct task_struct	*kthread;
-	int			frame;
 	struct s2255_dev	*dev;
 	int			channel;
 };
@@ -211,16 +210,11 @@ struct s2255_pipeinfo {
 	u32 max_transfer_size;
 	u32 cur_transfer_size;
 	u8 *transfer_buffer;
-	u32 transfer_flags;;
 	u32 state;
-	u32 prev_state;
-	u32 urb_size;
 	void *stream_urb;
 	void *dev;	/* back pointer to s2255_dev struct*/
 	u32 err_count;
-	u32 buf_index;
 	u32 idx;
-	u32 priority_set;
 };
 
 struct s2255_fmt; /*forward declaration */
@@ -240,8 +234,6 @@ struct s2255_dev {
 	struct list_head	s2255_devlist;
 	struct timer_list	timer;
 	struct s2255_fw	*fw_data;
-	int			board_num;
-	int			is_open;
 	struct s2255_pipeinfo	pipes[MAX_PIPE_BUFFERS];
 	struct s2255_bufferi		buffer[MAX_CHANNELS];
 	struct s2255_mode	mode[MAX_CHANNELS];
@@ -298,9 +290,10 @@ struct s2255_fh {
 	int			resources[MAX_CHANNELS];
 };
 
-#define CUR_USB_FWVER	774	/* current cypress EEPROM firmware version */
+/* current cypress EEPROM firmware version */
+#define S2255_CUR_USB_FWVER	((3 << 8) | 6)
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	13
+#define S2255_MINOR_VERSION	14
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -1819,7 +1812,6 @@ static int s2255_probe_v4l(struct s2255_
 		INIT_LIST_HEAD(&dev->vidq[i].active);
 		dev->vidq[i].dev = dev;
 		dev->vidq[i].channel = i;
-		dev->vidq[i].kthread = NULL;
 		/* register 4 video devices */
 		dev->vdev[i] = video_device_alloc();
 		memcpy(dev->vdev[i], &template, sizeof(struct video_device));
@@ -1840,7 +1832,9 @@ static int s2255_probe_v4l(struct s2255_
 			return ret;
 		}
 	}
-	printk(KERN_INFO "Sensoray 2255 V4L driver\n");
+	printk(KERN_INFO "Sensoray 2255 V4L driver Revision: %d.%d\n",
+	       S2255_MAJOR_VERSION,
+	       S2255_MINOR_VERSION);
 	return ret;
 }
 
@@ -1930,14 +1924,14 @@ static int save_frame(struct s2255_dev *
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
+				case S2255_RESPONSE_FW:
 
 					dev->chn_ready |= (1 << cc);
 					if ((dev->chn_ready & 0x0f) != 0x0f)
@@ -2173,10 +2167,15 @@ static int s2255_board_init(struct s2255
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
@@ -2284,8 +2283,7 @@ static int s2255_start_readpipe(struct s
 
 	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
 		pipe_info->state = 1;
-		pipe_info->buf_index = (u32) i;
-		pipe_info->priority_set = 0;
+		pipe_info->err_count = 0;
 		pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!pipe_info->stream_urb) {
 			dev_err(&dev->udev->dev,
@@ -2299,7 +2297,6 @@ static int s2255_start_readpipe(struct s
 				  pipe_info->cur_transfer_size,
 				  read_pipe_completion, pipe_info);
 
-		pipe_info->urb_size = sizeof(pipe_info->stream_urb);
 		dprintk(4, "submitting URB %p\n", pipe_info->stream_urb);
 		retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 		if (retval) {
@@ -2404,8 +2401,6 @@ static void s2255_stop_readpipe(struct s
 			if (pipe_info->state == 0)
 				continue;
 			pipe_info->state = 0;
-			pipe_info->prev_state = 1;
-
 		}
 	}
 
@@ -2543,7 +2538,9 @@ static int s2255_probe(struct usb_interf
 	s2255_probe_v4l(dev);
 	usb_reset_device(dev->udev);
 	/* load 2255 board specific */
-	s2255_board_init(dev);
+	retval = s2255_board_init(dev);
+	if (retval)
+		goto error;
 
 	dprintk(4, "before probe done %p\n", dev);
 	spin_lock_init(&dev->slock);

