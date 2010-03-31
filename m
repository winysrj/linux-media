Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([69.56.159.17]:46922 "HELO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755962Ab0CaOly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 10:41:54 -0400
Date: Wed, 31 Mar 2010 07:41:51 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: removal of big kernel lock
To: linux-media@vger.kernel.org
Message-ID: <tkrat.01ad6f348d78ae3e@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1270046291 25200
# Node ID c72bdc8732abc0cf7bc376babfd06b2d999bdcf4
# Parent  2ab296deae938864b06b29cc224eb4b670ae3aa9
s2255drv: removal of BKL

From: Dean Anderson <dean@sensoray.com>

big kernel lock removed from open function.
v4l2 code does not require locking the open function except
to check asynchronous firmware load state, which is protected
by a mutex

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r 2ab296deae93 -r c72bdc8732ab linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Wed Mar 31 07:30:56 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Wed Mar 31 07:38:11 2010 -0700
@@ -1753,7 +1753,6 @@
 	int state;
 	dprintk(1, "s2255: open called (dev=%s)\n",
 		video_device_node_name(vdev));
-	lock_kernel();
 	for (i = 0; i < MAX_CHANNELS; i++)
 		if (&dev->vdev[i] == vdev) {
 			cur_channel = i;
@@ -1769,7 +1768,6 @@
 	switch (state) {
 	case S2255_FW_DISCONNECTING:
 		mutex_unlock(&dev->open_lock);
-		unlock_kernel();
 		return -ENODEV;
 	case S2255_FW_FAILED:
 		s2255_dev_err(&dev->udev->dev,
@@ -1809,30 +1807,24 @@
 		break;
 	case S2255_FW_FAILED:
 		printk(KERN_INFO "2255 firmware load failed.\n");
-		unlock_kernel();
 		return -ENODEV;
 	case S2255_FW_DISCONNECTING:
 		printk(KERN_INFO "%s: disconnecting\n", __func__);
-		unlock_kernel();
 		return -ENODEV;
 	case S2255_FW_LOADED_DSPWAIT:
 	case S2255_FW_NOTLOADED:
 		printk(KERN_INFO "%s: firmware not loaded yet"
 		       "please try again later\n",
 		       __func__);
-		unlock_kernel();
 		return -EAGAIN;
 	default:
 		printk(KERN_INFO "%s: unknown state\n", __func__);
-		unlock_kernel();
 		return -EFAULT;
 	}
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
-		unlock_kernel();
+	if (NULL == fh)
 		return -ENOMEM;
-	}
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1860,7 +1852,6 @@
 				    fh->type,
 				    V4L2_FIELD_INTERLACED,
 				    sizeof(struct s2255_buffer), fh);
-	unlock_kernel();
 	return 0;
 }
 

