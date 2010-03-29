Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway09.websitewelcome.com ([69.93.179.27]:38860 "HELO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751156Ab0C2WPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 18:15:08 -0400
Date: Mon, 29 Mar 2010 15:15:01 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: code cleanup
To: linux-media@vger.kernel.org
Message-ID: <tkrat.a25da9e9182ef79b@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1269900678 25200
# Node ID 18586e4ac3ed5972dac2015600f8c21e26c0fc16
# Parent  c437bd6f3659885afbe20ad12857347f0850156b
s2255drv: code cleanup

From: Dean Anderson <dean@sensoray.com>

removal of unused pipe array (of size one).

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r c437bd6f3659 -r 18586e4ac3ed linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Mon Mar 29 14:57:45 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Mon Mar 29 15:11:18 2010 -0700
@@ -85,7 +85,6 @@
 #define S2255_RESPONSE_STATUS   cpu_to_le32(0x20)
 #define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
-#define MAX_PIPE_BUFFERS	1
 #define SYS_FRAMES		4
 /* maximum size is PAL full size plus room for the marker header(s) */
 #define SYS_FRAMES_MAXSIZE	(720*288*2*2 + 4096)
@@ -237,8 +236,8 @@
 	struct video_device	*vdev[MAX_CHANNELS];
 	struct timer_list	timer;
 	struct s2255_fw	*fw_data;
-	struct s2255_pipeinfo	pipes[MAX_PIPE_BUFFERS];
-	struct s2255_bufferi		buffer[MAX_CHANNELS];
+	struct s2255_pipeinfo	pipe;
+	struct s2255_bufferi	buffer[MAX_CHANNELS];
 	struct s2255_mode	mode[MAX_CHANNELS];
 	/* jpeg compression */
 	struct v4l2_jpegcompression jc[MAX_CHANNELS];
@@ -2334,25 +2333,21 @@
 
 static int s2255_board_init(struct s2255_dev *dev)
 {
-	int j;
 	struct s2255_mode mode_def = DEF_MODEI_NTSC_CONT;
 	int fw_ver;
+	int j;
+	struct s2255_pipeinfo *pipe = &dev->pipe;
 	dprintk(4, "board init: %p", dev);
+	memset(pipe, 0, sizeof(*pipe));
+	pipe->dev = dev;
+	pipe->cur_transfer_size = S2255_USB_XFER_SIZE;
+	pipe->max_transfer_size = S2255_USB_XFER_SIZE;
 
-	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
-		struct s2255_pipeinfo *pipe = &dev->pipes[j];
-
-		memset(pipe, 0, sizeof(*pipe));
-		pipe->dev = dev;
-		pipe->cur_transfer_size = S2255_USB_XFER_SIZE;
-		pipe->max_transfer_size = S2255_USB_XFER_SIZE;
-
-		pipe->transfer_buffer = kzalloc(pipe->max_transfer_size,
-						GFP_KERNEL);
-		if (pipe->transfer_buffer == NULL) {
-			dprintk(1, "out of memory!\n");
-			return -ENOMEM;
-		}
+	pipe->transfer_buffer = kzalloc(pipe->max_transfer_size,
+					GFP_KERNEL);
+	if (pipe->transfer_buffer == NULL) {
+		dprintk(1, "out of memory!\n");
+		return -ENOMEM;
 	}
 	/* query the firmware */
 	fw_ver = s2255_get_fx2fw(dev);
@@ -2401,12 +2396,8 @@
 
 	for (i = 0; i < MAX_CHANNELS; i++)
 		s2255_release_sys_buffers(dev, i);
-
-	/* release transfer buffers */
-	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
-		struct s2255_pipeinfo *pipe = &dev->pipes[i];
-		kfree(pipe->transfer_buffer);
-	}
+	/* release transfer buffer */
+	kfree(dev->pipe.transfer_buffer);
 	return 0;
 }
 
@@ -2472,35 +2463,30 @@
 {
 	int pipe;
 	int retval;
-	int i;
-	struct s2255_pipeinfo *pipe_info = dev->pipes;
+	struct s2255_pipeinfo *pipe_info = &dev->pipe;
 	pipe = usb_rcvbulkpipe(dev->udev, dev->read_endpoint);
 	dprintk(2, "start pipe IN %d\n", dev->read_endpoint);
+	pipe_info->state = 1;
+	pipe_info->err_count = 0;
+	pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!pipe_info->stream_urb) {
+		dev_err(&dev->udev->dev,
+			"ReadStream: Unable to alloc URB\n");
+		return -ENOMEM;
+	}
+	/* transfer buffer allocated in board_init */
+	usb_fill_bulk_urb(pipe_info->stream_urb, dev->udev,
+			  pipe,
+			  pipe_info->transfer_buffer,
+			  pipe_info->cur_transfer_size,
+			  read_pipe_completion, pipe_info);
 
-	for (i = 0; i < MAX_PIPE_BUFFERS; i++) {
-		pipe_info->state = 1;
-		pipe_info->err_count = 0;
-		pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!pipe_info->stream_urb) {
-			dev_err(&dev->udev->dev,
-				"ReadStream: Unable to alloc URB\n");
-			return -ENOMEM;
-		}
-		/* transfer buffer allocated in board_init */
-		usb_fill_bulk_urb(pipe_info->stream_urb, dev->udev,
-				  pipe,
-				  pipe_info->transfer_buffer,
-				  pipe_info->cur_transfer_size,
-				  read_pipe_completion, pipe_info);
-
-		dprintk(4, "submitting URB %p\n", pipe_info->stream_urb);
-		retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
-		if (retval) {
-			printk(KERN_ERR "s2255: start read pipe failed\n");
-			return retval;
-		}
+	dprintk(4, "submitting URB %p\n", pipe_info->stream_urb);
+	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
+	if (retval) {
+		printk(KERN_ERR "s2255: start read pipe failed\n");
+		return retval;
 	}
-
 	return 0;
 }
 
@@ -2581,30 +2567,19 @@
 
 static void s2255_stop_readpipe(struct s2255_dev *dev)
 {
-	int j;
+	struct s2255_pipeinfo *pipe = &dev->pipe;
 	if (dev == NULL) {
 		s2255_dev_err(&dev->udev->dev, "invalid device\n");
 		return;
 	}
-	dprintk(4, "stop read pipe\n");
-	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
-		struct s2255_pipeinfo *pipe_info = &dev->pipes[j];
-		if (pipe_info) {
-			if (pipe_info->state == 0)
-				continue;
-			pipe_info->state = 0;
-		}
+	pipe->state = 0;
+	if (pipe->stream_urb) {
+		/* cancel urb */
+		usb_kill_urb(pipe->stream_urb);
+		usb_free_urb(pipe->stream_urb);
+		pipe->stream_urb = NULL;
 	}
-	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
-		struct s2255_pipeinfo *pipe_info = &dev->pipes[j];
-		if (pipe_info->stream_urb) {
-			/* cancel urb */
-			usb_kill_urb(pipe_info->stream_urb);
-			usb_free_urb(pipe_info->stream_urb);
-			pipe_info->stream_urb = NULL;
-		}
-	}
-	dprintk(2, "s2255 stop read pipe: %d\n", j);
+	dprintk(4, "%s", __func__);
 	return;
 }
 

