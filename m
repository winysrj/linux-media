Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway06.websitewelcome.com ([69.93.35.3]:55729 "HELO
	gateway06.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754084Ab0C2WHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 18:07:38 -0400
Date: Mon, 29 Mar 2010 15:00:54 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: cleanup of driver disconnect code
To: linux-media@vger.kernel.org
cc: david@identd.dyndns.org, mchehab@infradead.org,
	"Dean A." <dean@sensoray.com>, laurent.pinchart@ideasonboard.com,
	isely@pobox.com, andre.goddard@gmail.com
Message-ID: <tkrat.7f9b79c0eafb6d4f@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1269899865 25200
# Node ID c437bd6f3659885afbe20ad12857347f0850156b
# Parent  a539e5b689454b8feb6b5acf5a67516b142c2823
s2255drv: cleanup of driver disconnect code

From: Dean Anderson <dean@sensoray.com>

simplifies use of kref in driver

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r a539e5b68945 -r c437bd6f3659 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Sat Mar 27 23:09:47 2010 -0300
+++ b/linux/drivers/media/video/s2255drv.c	Mon Mar 29 14:57:45 2010 -0700
@@ -226,7 +226,6 @@
 
 struct s2255_dev {
 	int			frames;
-	int			users[MAX_CHANNELS];
 	struct mutex		lock;
 	struct mutex		open_lock;
 	int			resources[MAX_CHANNELS];
@@ -367,7 +366,6 @@
 static int s2255_set_mode(struct s2255_dev *dev, unsigned long chn,
 			  struct s2255_mode *mode);
 static int s2255_board_shutdown(struct s2255_dev *dev);
-static void s2255_exit_v4l(struct s2255_dev *dev);
 static void s2255_fwload_start(struct s2255_dev *dev, int reset);
 static void s2255_destroy(struct kref *kref);
 static long s2255_vendor_req(struct s2255_dev *dev, unsigned char req,
@@ -606,7 +604,6 @@
 	return 0;
 }
 
-
 static const struct s2255_fmt *format_by_fourcc(int fourcc)
 {
 	unsigned int i;
@@ -620,9 +617,6 @@
 	return NULL;
 }
 
-
-
-
 /* video buffer vmalloc implementation based partly on VIVI driver which is
  *          Copyright (c) 2006 by
  *                  Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
@@ -849,7 +843,6 @@
 	return v4l2_ctrl_query_menu(qmenu, NULL, NULL);
 }
 
-
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
@@ -1759,31 +1752,26 @@
 	int i = 0;
 	int cur_channel = -1;
 	int state;
-
 	dprintk(1, "s2255: open called (dev=%s)\n",
 		video_device_node_name(vdev));
-
 	lock_kernel();
-
-	for (i = 0; i < MAX_CHANNELS; i++) {
+	for (i = 0; i < MAX_CHANNELS; i++)
 		if (dev->vdev[i] == vdev) {
 			cur_channel = i;
 			break;
 		}
-	}
-
-	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_DISCONNECTING) {
+	/*
+	 * open lock necessary to prevent multiple instances
+	 * of v4l-conf (or other programs) from simultaneously
+	 * reloading firmware.
+	 */
+	mutex_lock(&dev->open_lock);
+	state = atomic_read(&dev->fw_data->fw_state);
+	switch (state) {
+	case S2255_FW_DISCONNECTING:
+		mutex_unlock(&dev->open_lock);
 		unlock_kernel();
-		printk(KERN_INFO "disconnecting\n");
 		return -ENODEV;
-	}
-	kref_get(&dev->kref);
-	mutex_lock(&dev->open_lock);
-
-	dev->users[cur_channel]++;
-	dprintk(4, "s2255: open_handles %d\n", dev->users[cur_channel]);
-
-	switch (atomic_read(&dev->fw_data->fw_state)) {
 	case S2255_FW_FAILED:
 		s2255_dev_err(&dev->udev->dev,
 			"firmware load failed. retrying.\n");
@@ -1794,6 +1782,8 @@
 				    (atomic_read(&dev->fw_data->fw_state)
 				     == S2255_FW_DISCONNECTING)),
 				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));
+		/* state may have changed, re-read */
+		state = atomic_read(&dev->fw_data->fw_state);
 		break;
 	case S2255_FW_NOTLOADED:
 	case S2255_FW_LOADED_DSPWAIT:
@@ -1806,52 +1796,44 @@
 				    (atomic_read(&dev->fw_data->fw_state)
 				     == S2255_FW_DISCONNECTING)),
 			msecs_to_jiffies(S2255_LOAD_TIMEOUT));
+		/* state may have changed, re-read */
+		state = atomic_read(&dev->fw_data->fw_state);
 		break;
 	case S2255_FW_SUCCESS:
 	default:
 		break;
 	}
-	state = atomic_read(&dev->fw_data->fw_state);
-	if (state != S2255_FW_SUCCESS) {
-		int rc;
-		switch (state) {
-		case S2255_FW_FAILED:
-			printk(KERN_INFO "2255 FW load failed. %d\n", state);
-			rc = -ENODEV;
-			break;
-		case S2255_FW_DISCONNECTING:
-			printk(KERN_INFO "%s: disconnecting\n", __func__);
-			rc = -ENODEV;
-			break;
-		case S2255_FW_LOADED_DSPWAIT:
-		case S2255_FW_NOTLOADED:
-			printk(KERN_INFO "%s: firmware not loaded yet"
-			       "please try again later\n",
-			       __func__);
-			rc = -EAGAIN;
-			break;
-		default:
-			printk(KERN_INFO "%s: unknown state\n", __func__);
-			rc = -EFAULT;
-			break;
-		}
-		dev->users[cur_channel]--;
-		mutex_unlock(&dev->open_lock);
-		kref_put(&dev->kref, s2255_destroy);
+	mutex_unlock(&dev->open_lock);
+	/* state may have changed in above switch statement */
+	switch (state) {
+	case S2255_FW_SUCCESS:
+		break;
+	case S2255_FW_FAILED:
+		printk(KERN_INFO "2255 firmware load failed.\n");
 		unlock_kernel();
-		return rc;
+		return -ENODEV;
+	case S2255_FW_DISCONNECTING:
+		printk(KERN_INFO "%s: disconnecting\n", __func__);
+		unlock_kernel();
+		return -ENODEV;
+	case S2255_FW_LOADED_DSPWAIT:
+	case S2255_FW_NOTLOADED:
+		printk(KERN_INFO "%s: firmware not loaded yet"
+		       "please try again later\n",
+		       __func__);
+		unlock_kernel();
+		return -EAGAIN;
+	default:
+		printk(KERN_INFO "%s: unknown state\n", __func__);
+		unlock_kernel();
+		return -EFAULT;
 	}
-
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh) {
-		dev->users[cur_channel]--;
-		mutex_unlock(&dev->open_lock);
-		kref_put(&dev->kref, s2255_destroy);
 		unlock_kernel();
 		return -ENOMEM;
 	}
-
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1866,9 +1848,8 @@
 		s2255_set_mode(dev, cur_channel, &fh->mode);
 		dev->chn_configured[cur_channel] = 1;
 	}
-	dprintk(1, "s2255drv: open dev=%s type=%s users=%d\n",
-		video_device_node_name(vdev), v4l2_type_names[type],
-		dev->users[cur_channel]);
+	dprintk(1, "s2255drv: open dev=%s type=%s\n",
+		video_device_node_name(vdev), v4l2_type_names[type]);
 	dprintk(2, "s2255drv: open: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n",
 		(unsigned long)fh, (unsigned long)dev,
 		(unsigned long)&dev->vidq[cur_channel]);
@@ -1880,8 +1861,6 @@
 				    fh->type,
 				    V4L2_FIELD_INTERLACED,
 				    sizeof(struct s2255_buffer), fh);
-
-	mutex_unlock(&dev->open_lock);
 	unlock_kernel();
 	return 0;
 }
@@ -1904,28 +1883,10 @@
 static void s2255_destroy(struct kref *kref)
 {
 	struct s2255_dev *dev = to_s2255_dev(kref);
-	int i;
-	if (!dev) {
-		printk(KERN_ERR "s2255drv: kref problem\n");
-		return;
-	}
-	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
-	wake_up(&dev->fw_data->wait_fw);
-	for (i = 0; i < MAX_CHANNELS; i++) {
-		dev->setmode_ready[i] = 1;
-		wake_up(&dev->wait_setmode[i]);
-		dev->vidstatus_ready[i] = 1;
-		wake_up(&dev->wait_vidstatus[i]);
-	}
-	mutex_lock(&dev->open_lock);
-	/* reset the DSP so firmware can be reload next time */
-	s2255_reset_dsppower(dev);
-	s2255_exit_v4l(dev);
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
 	/* make sure firmware still not trying to load */
 	del_timer(&dev->timer);  /* only started in .probe and .open */
-
 	if (dev->fw_data->fw_urb) {
 		dprintk(2, "kill fw_urb\n");
 		usb_kill_urb(dev->fw_data->fw_urb);
@@ -1936,24 +1897,22 @@
 		release_firmware(dev->fw_data->fw);
 	kfree(dev->fw_data->pfw_data);
 	kfree(dev->fw_data);
+	/* reset the DSP so firmware can be reloaded next time */
+	s2255_reset_dsppower(dev);
+	mutex_destroy(&dev->open_lock);
+	mutex_destroy(&dev->lock);
 	usb_put_dev(dev->udev);
 	dprintk(1, "%s", __func__);
-
-	mutex_unlock(&dev->open_lock);
 	kfree(dev);
 }
 
-static int s2255_close(struct file *file)
+static int s2255_release(struct file *file)
 {
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev = fh->dev;
 	struct video_device *vdev = video_devdata(file);
-
 	if (!dev)
 		return -ENODEV;
-
-	mutex_lock(&dev->open_lock);
-
 	/* turn off stream */
 	if (res_check(fh)) {
 		if (dev->b_acquire[fh->channel])
@@ -1961,15 +1920,8 @@
 		videobuf_streamoff(&fh->vb_vidq);
 		res_free(dev, fh);
 	}
-
 	videobuf_mmap_free(&fh->vb_vidq);
-	dev->users[fh->channel]--;
-
-	mutex_unlock(&dev->open_lock);
-
-	kref_put(&dev->kref, s2255_destroy);
-	dprintk(1, "s2255: close called (dev=%s, users=%d)\n",
-		video_device_node_name(vdev), dev->users[fh->channel]);
+	dprintk(1, "%s (dev=%s)\n", __func__, video_device_node_name(vdev));
 	kfree(fh);
 	return 0;
 }
@@ -1995,7 +1947,7 @@
 static const struct v4l2_file_operations s2255_fops_v4l = {
 	.owner = THIS_MODULE,
 	.open = s2255_open,
-	.release = s2255_close,
+	.release = s2255_release,
 	.poll = s2255_poll,
 	.ioctl = video_ioctl2,	/* V4L2 ioctl handler */
 	.mmap = s2255_mmap_v4l,
@@ -2031,11 +1983,19 @@
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 };
 
+static void s2255_video_device_release(struct video_device *vdev)
+{
+	struct s2255_dev *dev = video_get_drvdata(vdev);
+	video_device_release(vdev);
+	kref_put(&dev->kref, s2255_destroy);
+	return;
+}
+
 static struct video_device template = {
 	.name = "s2255v",
 	.fops = &s2255_fops_v4l,
 	.ioctl_ops = &s2255_ioctl_ops,
-	.release = video_device_release,
+	.release = s2255_video_device_release,
 	.tvnorms = S2255_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
 };
@@ -2079,21 +2039,6 @@
 	return ret;
 }
 
-static void s2255_exit_v4l(struct s2255_dev *dev)
-{
-
-	int i;
-	for (i = 0; i < MAX_CHANNELS; i++) {
-		if (video_is_registered(dev->vdev[i])) {
-			video_unregister_device(dev->vdev[i]);
-			printk(KERN_INFO "s2255 unregistered\n");
-		} else {
-			video_device_release(dev->vdev[i]);
-			printk(KERN_INFO "s2255 released\n");
-		}
-	}
-}
-
 /* this function moves the usb stream read pipe data
  * into the system buffers.
  * returns 0 on success, EAGAIN if more data to process( call this
@@ -2408,9 +2353,7 @@
 			dprintk(1, "out of memory!\n");
 			return -ENOMEM;
 		}
-
 	}
-
 	/* query the firmware */
 	fw_ver = s2255_get_fx2fw(dev);
 
@@ -2447,7 +2390,6 @@
 static int s2255_board_shutdown(struct s2255_dev *dev)
 {
 	u32 i;
-
 	dprintk(1, "S2255: board shutdown: %p", dev);
 
 	for (i = 0; i < MAX_CHANNELS; i++) {
@@ -2640,7 +2582,6 @@
 static void s2255_stop_readpipe(struct s2255_dev *dev)
 {
 	int j;
-
 	if (dev == NULL) {
 		s2255_dev_err(&dev->udev->dev, "invalid device\n");
 		return;
@@ -2654,7 +2595,6 @@
 			pipe_info->state = 0;
 		}
 	}
-
 	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
 		struct s2255_pipeinfo *pipe_info = &dev->pipes[j];
 		if (pipe_info->stream_urb) {
@@ -2703,24 +2643,22 @@
 	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
 	if (dev == NULL) {
 		s2255_dev_err(&interface->dev, "out of memory\n");
-		goto error;
+		return -ENOMEM;
 	}
+	kref_init(&dev->kref);
 	dev->pid = id->idProduct;
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
-		goto error;
-
+		goto errorFWDATA1;
 	mutex_init(&dev->lock);
 	mutex_init(&dev->open_lock);
-
 	/* grab usb_device and save it */
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
 	if (dev->udev == NULL) {
 		dev_err(&interface->dev, "null usb device\n");
 		retval = -ENODEV;
-		goto error;
+		goto errorUDEV;
 	}
-	kref_init(&dev->kref);
 	dprintk(1, "dev: %p, kref: %p udev %p interface %p\n", dev, &dev->kref,
 		dev->udev, interface);
 	dev->interface = interface;
@@ -2737,14 +2675,11 @@
 
 	if (!dev->read_endpoint) {
 		dev_err(&interface->dev, "Could not find bulk-in endpoint\n");
-		goto error;
+		goto errorEP;
 	}
-
 	/* set intfdata */
 	usb_set_intfdata(interface, dev);
-
 	dprintk(100, "after intfdata %p\n", dev);
-
 	init_timer(&dev->timer);
 	dev->timer.function = s2255_timer;
 	dev->timer.data = (unsigned long)dev->fw_data;
@@ -2756,21 +2691,21 @@
 	}
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
-
 	if (!dev->fw_data->fw_urb) {
 		dev_err(&interface->dev, "out of memory!\n");
-		goto error;
+		goto errorFWURB;
 	}
+
 	dev->fw_data->pfw_data = kzalloc(CHUNK_SIZE, GFP_KERNEL);
 	if (!dev->fw_data->pfw_data) {
 		dev_err(&interface->dev, "out of memory!\n");
-		goto error;
+		goto errorFWDATA2;
 	}
 	/* load the first chunk */
 	if (request_firmware(&dev->fw_data->fw,
 			     FIRMWARE_FILE_NAME, &dev->udev->dev)) {
 		printk(KERN_ERR "sensoray 2255 failed to get firmware\n");
-		goto error;
+		goto errorREQFW;
 	}
 	/* check the firmware is valid */
 	fw_size = dev->fw_data->fw->size;
@@ -2779,7 +2714,7 @@
 	if (*pdata != S2255_FW_MARKER) {
 		printk(KERN_INFO "Firmware invalid.\n");
 		retval = -ENODEV;
-		goto error;
+		goto errorFWMARKER;
 	} else {
 		/* make sure firmware is the latest */
 		__le32 *pRel;
@@ -2789,26 +2724,53 @@
 		if (*pRel < S2255_CUR_DSP_FWVER)
 			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
 		if (dev->pid == 0x2257 && *pRel < S2255_MIN_DSP_COLORFILTER)
-			printk(KERN_WARNING "s2255: 2257 requires firmware 8 or above.\n");
+			printk(KERN_WARNING "s2255: 2257 requires firmware %d"
+			       "or above.\n", S2255_MIN_DSP_COLORFILTER);
 	}
-	/* loads v4l specific */
-	s2255_probe_v4l(dev);
 	usb_reset_device(dev->udev);
 	/* load 2255 board specific */
 	retval = s2255_board_init(dev);
 	if (retval)
-		goto error;
-
+		goto errorBOARDINIT;
 	dprintk(4, "before probe done %p\n", dev);
 	spin_lock_init(&dev->slock);
-
 	s2255_fwload_start(dev, 0);
+	/* kref for each vdev. Released on video_device_release callback */
+	for (i = 0; i < MAX_CHANNELS; i++)
+		kref_get(&dev->kref);
+	/* loads v4l specific */
+	retval = s2255_probe_v4l(dev);
+	if (retval)
+		goto errorV4L;
 	dev_info(&interface->dev, "Sensoray 2255 detected\n");
 	return 0;
-error:
+errorV4L:
+	for (i = 0; i < MAX_CHANNELS; i++)
+		if (dev->vdev[i] && video_is_registered(dev->vdev[i]))
+			video_unregister_device(dev->vdev[i]);
+errorBOARDINIT:
+	s2255_board_shutdown(dev);
+errorFWMARKER:
+	release_firmware(dev->fw_data->fw);
+errorREQFW:
+	kfree(dev->fw_data->pfw_data);
+errorFWDATA2:
+	usb_free_urb(dev->fw_data->fw_urb);
+errorFWURB:
+	del_timer(&dev->timer);
+errorEP:
+	usb_put_dev(dev->udev);
+errorUDEV:
+	kfree(dev->fw_data);
+	mutex_destroy(&dev->open_lock);
+	mutex_destroy(&dev->lock);
+errorFWDATA1:
+	kfree(dev);
+	printk(KERN_WARNING "Sensoray 2255 driver load failed: 0x%x\n", retval);
 	return retval;
 }
 
+
 /* disconnect routine. when board is removed physically or with rmmod */
 static void s2255_disconnect(struct usb_interface *interface)
 {
@@ -2816,11 +2778,11 @@
 	int i;
 	dprintk(1, "s2255: disconnect interface %p\n", interface);
 	dev = usb_get_intfdata(interface);
-
-	/*
-	 * wake up any of the timers to allow open_lock to be
-	 * acquired sooner
-	 */
+	/* unregister each video device. */
+	for (i = 0; i < MAX_CHANNELS; i++)
+		if (video_is_registered(dev->vdev[i]))
+			video_unregister_device(dev->vdev[i]);
+	/* wake up any of our timers */
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
 	wake_up(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
@@ -2829,16 +2791,9 @@
 		dev->vidstatus_ready[i] = 1;
 		wake_up(&dev->wait_vidstatus[i]);
 	}
-
-	mutex_lock(&dev->open_lock);
 	usb_set_intfdata(interface, NULL);
-	mutex_unlock(&dev->open_lock);
-
-	if (dev) {
-		kref_put(&dev->kref, s2255_destroy);
-		dprintk(1, "s2255drv: disconnect\n");
-		dev_info(&interface->dev, "s2255usb now disconnected\n");
-	}
+	kref_put(&dev->kref, s2255_destroy);
+	dev_info(&interface->dev, "%s\n", __func__);
 }
 
 static struct usb_driver s2255_driver = {
@@ -2851,15 +2806,12 @@
 static int __init usb_s2255_init(void)
 {
 	int result;
-
 	/* register this driver with the USB subsystem */
 	result = usb_register(&s2255_driver);
-
 	if (result)
 		pr_err(KBUILD_MODNAME
-			": usb_register failed. Error number %d\n", result);
-
-	dprintk(2, "s2255_init: done\n");
+		       ": usb_register failed. Error number %d\n", result);
+	dprintk(2, "%s\n", __func__);
 	return result;
 }
 

