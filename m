Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52685 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbZKRAiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Use the new video_device_node_name function
Date: Wed, 18 Nov 2009 01:38:43 +0100
Message-Id: <1258504731-8430-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all device drivers to use the new video_device_node_name function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/common/saa7146_fops.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
@@ -544,15 +544,13 @@ int saa7146_register_device(struct video
 		return err;
 	}
 
-	if( VFL_TYPE_GRABBER == type ) {
+	if (VFL_TYPE_GRABBER == type)
 		vv->video_minor = vfd->minor;
-		INFO(("%s: registered device video%d [v4l2]\n",
-			dev->name, vfd->num));
-	} else {
+	else
 		vv->vbi_minor = vfd->minor;
-		INFO(("%s: registered device vbi%d [v4l2]\n",
-			dev->name, vfd->num));
-	}
+
+	INFO(("%s: registered device %s [v4l2]\n",
+		dev->name, video_device_node_name(vfd)));
 
 	*vid = vfd;
 	return 0;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/bt8xx/bttv-driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
@@ -4276,8 +4276,8 @@ static int __devinit bttv_register_video
 	if (video_register_device(btv->video_dev, VFL_TYPE_GRABBER,
 				  video_nr[btv->c.nr]) < 0)
 		goto err;
-	printk(KERN_INFO "bttv%d: registered device video%d\n",
-	       btv->c.nr, btv->video_dev->num);
+	printk(KERN_INFO "bttv%d: registered device %s\n",
+	       btv->c.nr, video_device_node_name(btv->video_dev));
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
 	if (class_device_create_file(&btv->video_dev->dev,
 				     &class_device_attr_card)<0) {
@@ -4298,8 +4298,8 @@ static int __devinit bttv_register_video
 	if (video_register_device(btv->vbi_dev, VFL_TYPE_VBI,
 				  vbi_nr[btv->c.nr]) < 0)
 		goto err;
-	printk(KERN_INFO "bttv%d: registered device vbi%d\n",
-	       btv->c.nr, btv->vbi_dev->num);
+	printk(KERN_INFO "bttv%d: registered device %s\n",
+	       btv->c.nr, video_device_node_name(btv->vbi_dev));
 
 	if (!btv->has_radio)
 		return 0;
@@ -4310,8 +4310,8 @@ static int __devinit bttv_register_video
 	if (video_register_device(btv->radio_dev, VFL_TYPE_RADIO,
 				  radio_nr[btv->c.nr]) < 0)
 		goto err;
-	printk(KERN_INFO "bttv%d: registered device radio%d\n",
-	       btv->c.nr, btv->radio_dev->num);
+	printk(KERN_INFO "bttv%d: registered device %s\n",
+	       btv->c.nr, video_device_node_name(btv->radio_dev));
 
 	/* all done */
 	return 0;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cpia.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cpia.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cpia.c
@@ -1343,15 +1343,13 @@ out:
 
 static void create_proc_cpia_cam(struct cam_data *cam)
 {
-	char name[5 + 1 + 10 + 1];
 	struct proc_dir_entry *ent;
 
 	if (!cpia_proc_root || !cam)
 		return;
 
-	snprintf(name, sizeof(name), "video%d", cam->vdev.num);
-
-	ent = create_proc_entry(name, S_IFREG|S_IRUGO|S_IWUSR, cpia_proc_root);
+	ent = create_proc_entry(video_device_node_name(&cam->vdev),
+				S_IFREG|S_IRUGO|S_IWUSR, cpia_proc_root);
 	if (!ent)
 		return;
 
@@ -1369,13 +1367,10 @@ static void create_proc_cpia_cam(struct 
 
 static void destroy_proc_cpia_cam(struct cam_data *cam)
 {
-	char name[5 + 1 + 10 + 1];
-
 	if (!cam || !cam->proc_entry)
 		return;
 
-	snprintf(name, sizeof(name), "video%d", cam->vdev.num);
-	remove_proc_entry(name, cpia_proc_root);
+	remove_proc_entry(video_device_node_name(&cam->vdev), cpia_proc_root);
 	cam->proc_entry = NULL;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cpia2/cpia2_v4l.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cpia2/cpia2_v4l.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1967,9 +1967,9 @@ void cpia2_unregister_camera(struct came
 	if (!cam->open_count) {
 		video_unregister_device(cam->vdev);
 	} else {
-		LOG("/dev/video%d removed while open, "
-		    "deferring video_unregister_device\n",
-		    cam->vdev->num);
+		LOG("/dev/%s removed while open, deferring "
+		    "video_unregister_device\n",
+		    video_device_node_name(cam->vdev));
 	}
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx18/cx18-streams.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx18/cx18-streams.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx18/cx18-streams.c
@@ -219,6 +219,7 @@ static int cx18_reg_dev(struct cx18 *cx,
 {
 	struct cx18_stream *s = &cx->streams[type];
 	int vfl_type = cx18_stream_info[type].vfl_type;
+	const char *name;
 	int num, ret;
 
 	/* TODO: Shouldn't this be a VFL_TYPE_TRANSPORT or something?
@@ -258,29 +259,30 @@ static int cx18_reg_dev(struct cx18 *cx,
 		s->video_dev = NULL;
 		return ret;
 	}
-	num = s->video_dev->num;
+
+	name = video_device_node_name(s->video_dev);
 
 	switch (vfl_type) {
 	case VFL_TYPE_GRABBER:
-		CX18_INFO("Registered device video%d for %s (%d x %d kB)\n",
-			  num, s->name, cx->stream_buffers[type],
+		CX18_INFO("Registered device %s for %s (%d x %d kB)\n",
+			  name, s->name, cx->stream_buffers[type],
 			  cx->stream_buf_size[type]/1024);
 		break;
 
 	case VFL_TYPE_RADIO:
-		CX18_INFO("Registered device radio%d for %s\n",
-			num, s->name);
+		CX18_INFO("Registered device %s for %s\n",
+			name, s->name);
 		break;
 
 	case VFL_TYPE_VBI:
 		if (cx->stream_buffers[type])
-			CX18_INFO("Registered device vbi%d for %s "
+			CX18_INFO("Registered device %s for %s "
 				  "(%d x %d bytes)\n",
-				  num, s->name, cx->stream_buffers[type],
+				  name, s->name, cx->stream_buffers[type],
 				  cx->stream_buf_size[type]);
 		else
-			CX18_INFO("Registered device vbi%d for %s\n",
-				num, s->name);
+			CX18_INFO("Registered device %s for %s\n",
+				name, s->name);
 		break;
 	}
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-cards.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-cards.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -880,8 +880,9 @@ static void cx231xx_usb_disconnect(struc
 
 	if (dev->users) {
 		cx231xx_warn
-		    ("device /dev/video%d is open! Deregistration and memory "
-		     "deallocation are deferred on close.\n", dev->vdev->num);
+		    ("device /dev/%s is open! Deregistration and memory "
+		     "deallocation are deferred on close.\n",
+		     video_device_node_name(dev->vdev));
 
 		dev->state |= DEV_MISCONFIGURED;
 		cx231xx_uninit_isoc(dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2027,8 +2027,8 @@ void cx231xx_release_analog_resources(st
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		cx231xx_info("V4L2 device /dev/vbi%d deregistered\n",
-			     dev->vbi_dev->num);
+		cx231xx_info("V4L2 device /dev/%s deregistered\n",
+			     video_device_node_name(dev->vbi_dev));
 		if (-1 != dev->vbi_dev->minor)
 			video_unregister_device(dev->vbi_dev);
 		else
@@ -2036,8 +2036,8 @@ void cx231xx_release_analog_resources(st
 		dev->vbi_dev = NULL;
 	}
 	if (dev->vdev) {
-		cx231xx_info("V4L2 device /dev/video%d deregistered\n",
-			     dev->vdev->num);
+		cx231xx_info("V4L2 device /dev/%s deregistered\n",
+			     video_device_node_name(dev->vdev));
 		if (-1 != dev->vdev->minor)
 			video_unregister_device(dev->vdev);
 		else
@@ -2374,8 +2374,8 @@ int cx231xx_register_analog_devices(stru
 		return ret;
 	}
 
-	cx231xx_info("%s/0: registered device video%d [v4l2]\n",
-		     dev->name, dev->vdev->num);
+	cx231xx_info("%s/0: registered device %s [v4l2]\n",
+		     dev->name, video_device_node_name(dev->vdev));
 
 	/* Initialize VBI template */
 	memcpy(&cx231xx_vbi_template, &cx231xx_video_template,
@@ -2393,8 +2393,8 @@ int cx231xx_register_analog_devices(stru
 		return ret;
 	}
 
-	cx231xx_info("%s/0: registered device vbi%d\n",
-		     dev->name, dev->vbi_dev->num);
+	cx231xx_info("%s/0: registered device %s\n",
+		     dev->name, video_device_node_name(dev->vbi_dev));
 
 	if (cx231xx_boards[dev->model].radio.type == CX231XX_RADIO) {
 		dev->radio_dev = cx231xx_vdev_init(dev, &cx231xx_radio_template,
@@ -2409,12 +2409,13 @@ int cx231xx_register_analog_devices(stru
 			cx231xx_errdev("can't register radio device\n");
 			return ret;
 		}
-		cx231xx_info("Registered radio device as /dev/radio%d\n",
-			     dev->radio_dev->num);
+		cx231xx_info("Registered radio device as /dev/%s\n",
+			     video_device_node_name(dev->radio_dev));
 	}
 
-	cx231xx_info("V4L2 device registered as /dev/video%d and /dev/vbi%d\n",
-		     dev->vdev->num, dev->vbi_dev->num);
+	cx231xx_info("V4L2 device registered as /dev/%s and /dev/%s\n",
+		     video_device_node_name(dev->vdev),
+		     video_device_node_name(dev->vbi_dev));
 
 	return 0;
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-417.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
@@ -1817,8 +1817,8 @@ int cx23885_417_register(struct cx23885_
 		return err;
 	}
 
-	printk(KERN_INFO "%s: registered device video%d [mpeg]\n",
-	       dev->name, dev->v4l_device->num);
+	printk(KERN_INFO "%s: registered device video%s [mpeg]\n",
+	       dev->name, video_device_node_name(dev->v4l_device));
 
 	return 0;
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
@@ -1794,8 +1794,8 @@ int cx23885_video_register(struct cx2388
 			dev->name);
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s/0: registered device video%d [v4l2]\n",
-	       dev->name, dev->video_dev->num);
+	printk(KERN_INFO "%s/0: registered device %s [v4l2]\n",
+	       dev->name, video_device_node_name(dev->video_dev));
 #if 0
 	dev->vbi_dev = cx23885_vdev_init(dev, dev->pci,
 		&cx23885_vbi_template, "vbi");
@@ -1806,8 +1806,8 @@ int cx23885_video_register(struct cx2388
 			dev->name);
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s/0: registered device vbi%d\n",
-	       dev->name, dev->vbi_dev->num);
+	printk(KERN_INFO "%s/0: registered device %s\n",
+	       dev->name, video_device_node_name(dev));
 
 	if (dev->has_radio) {
 		dev->radio_dev = cx23885_vdev_init(dev, dev->pci,
@@ -1819,8 +1819,8 @@ int cx23885_video_register(struct cx2388
 			       dev->name);
 			goto fail_unreg;
 		}
-		printk(KERN_INFO "%s/0: registered device radio%d\n",
-		       dev->name, dev->radio_dev->num);
+		printk(KERN_INFO "%s/0: registered device %s\n",
+		       dev->name, video_device_node_name(dev));
 	}
 #endif
 	/* initial device configuration */
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-blackbird.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
@@ -1318,8 +1318,8 @@ static int blackbird_register_video(stru
 		       dev->core->name);
 		return err;
 	}
-	printk(KERN_INFO "%s/2: registered device video%d [mpeg]\n",
-	       dev->core->name, dev->mpeg_dev->num);
+	printk(KERN_INFO "%s/2: registered device %s [mpeg]\n",
+	       dev->core->name, video_device_node_name(dev->mpeg_dev));
 	return 0;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
@@ -2194,8 +2194,8 @@ static int __devinit cx8800_initdev(stru
 		       core->name);
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s/0: registered device video%d [v4l2]\n",
-	       core->name, dev->video_dev->num);
+	printk(KERN_INFO "%s/0: registered device %s [v4l2]\n",
+	       core->name, video_device_node_name(dev->video_dev));
 
 	dev->vbi_dev = cx88_vdev_init(core,dev->pci,&cx8800_vbi_template,"vbi");
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
@@ -2205,8 +2205,8 @@ static int __devinit cx8800_initdev(stru
 		       core->name);
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s/0: registered device vbi%d\n",
-	       core->name, dev->vbi_dev->num);
+	printk(KERN_INFO "%s/0: registered device %s\n",
+	       core->name, video_device_node_name(dev->vbi_dev));
 
 	if (core->board.radio.type == CX88_RADIO) {
 		dev->radio_dev = cx88_vdev_init(core,dev->pci,
@@ -2218,8 +2218,8 @@ static int __devinit cx8800_initdev(stru
 			       core->name);
 			goto fail_unreg;
 		}
-		printk(KERN_INFO "%s/0: registered device radio%d\n",
-		       core->name, dev->radio_dev->num);
+		printk(KERN_INFO "%s/0: registered device %s\n",
+		       core->name, video_device_node_name(dev->radio_dev));
 	}
 
 	/* everything worked */
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-cards.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -3017,9 +3017,9 @@ static void em28xx_usb_disconnect(struct
 
 	if (dev->users) {
 		em28xx_warn
-		    ("device /dev/video%d is open! Deregistration and memory "
+		    ("device /dev/%s is open! Deregistration and memory "
 		     "deallocation are deferred on close.\n",
-				dev->vdev->num);
+		     video_device_node_name(dev->vdev));
 
 		dev->state |= DEV_MISCONFIGURED;
 		em28xx_uninit_isoc(dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
@@ -2224,8 +2224,8 @@ void em28xx_release_analog_resources(str
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		em28xx_info("V4L2 device /dev/vbi%d deregistered\n",
-			    dev->vbi_dev->num);
+		em28xx_info("V4L2 device /dev/%s deregistered\n",
+			    video_device_node_name(dev->vbi_dev));
 		if (-1 != dev->vbi_dev->minor)
 			video_unregister_device(dev->vbi_dev);
 		else
@@ -2233,8 +2233,8 @@ void em28xx_release_analog_resources(str
 		dev->vbi_dev = NULL;
 	}
 	if (dev->vdev) {
-		em28xx_info("V4L2 device /dev/video%d deregistered\n",
-			    dev->vdev->num);
+		em28xx_info("V4L2 device /dev/%s deregistered\n",
+			    video_device_node_name(dev->vdev));
 		if (-1 != dev->vdev->minor)
 			video_unregister_device(dev->vdev);
 		else
@@ -2597,16 +2597,16 @@ int em28xx_register_analog_devices(struc
 			em28xx_errdev("can't register radio device\n");
 			return ret;
 		}
-		em28xx_info("Registered radio device as /dev/radio%d\n",
-			    dev->radio_dev->num);
+		em28xx_info("Registered radio device as /dev/%s\n",
+			    video_device_node_name(dev->radio_dev));
 	}
 
-	em28xx_info("V4L2 video device registered as /dev/video%d\n",
-				dev->vdev->num);
+	em28xx_info("V4L2 video device registered as /dev/%s\n",
+		    video_device_node_name(dev->vdev));
 
 	if (dev->vbi_dev)
-		em28xx_info("V4L2 VBI device registered as /dev/vbi%d\n",
-			    dev->vbi_dev->num);
+		em28xx_info("V4L2 VBI device registered as /dev/%s\n",
+			    video_device_node_name(dev->vbi_dev));
 
 	return 0;
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/et61x251/et61x251_core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/et61x251/et61x251_core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/et61x251/et61x251_core.c
@@ -591,8 +591,8 @@ static int et61x251_stream_interrupt(str
 	else if (cam->stream != STREAM_OFF) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "URB timeout reached. The camera is misconfigured. To "
-		       "use it, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use it, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -1199,7 +1199,8 @@ static void et61x251_release_resources(s
 
 	cam = container_of(kref, struct et61x251_device, kref);
 
-	DBG(2, "V4L2 device /dev/video%d deregistered", cam->v4ldev->num);
+	DBG(2, "V4L2 device /dev/%s deregistered",
+	    video_device_node_name(cam->v4ldev));
 	video_set_drvdata(cam->v4ldev, NULL);
 	video_unregister_device(cam->v4ldev);
 	usb_put_dev(cam->usbdev);
@@ -1240,8 +1241,8 @@ static int et61x251_open(struct file *fi
 	}
 
 	if (cam->users) {
-		DBG(2, "Device /dev/video%d is already in use",
-		       cam->v4ldev->num);
+		DBG(2, "Device /dev/%s is already in use",
+		       video_device_node_name(cam->v4ldev));
 		DBG(3, "Simultaneous opens are not supported");
 		if ((filp->f_flags & O_NONBLOCK) ||
 		    (filp->f_flags & O_NDELAY)) {
@@ -1284,7 +1285,8 @@ static int et61x251_open(struct file *fi
 	cam->frame_count = 0;
 	et61x251_empty_framequeues(cam);
 
-	DBG(3, "Video device /dev/video%d is open", cam->v4ldev->num);
+	DBG(3, "Video device /dev/%s is open",
+	    video_device_node_name(cam->v4ldev));
 
 out:
 	mutex_unlock(&cam->open_mutex);
@@ -1308,7 +1310,8 @@ static int et61x251_release(struct file 
 	cam->users--;
 	wake_up_interruptible_nr(&cam->wait_open, 1);
 
-	DBG(3, "Video device /dev/video%d closed", cam->v4ldev->num);
+	DBG(3, "Video device /dev/%s closed",
+	    video_device_node_name(cam->v4ldev));
 
 	kref_put(&cam->kref, et61x251_release_resources);
 
@@ -1850,8 +1853,8 @@ et61x251_vidioc_s_crop(struct et61x251_d
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_CROP failed because of hardware problems. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -1863,8 +1866,8 @@ et61x251_vidioc_s_crop(struct et61x251_d
 	    nbuffers != et61x251_request_buffers(cam, nbuffers, cam->io)) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_CROP failed because of not enough memory. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -ENOMEM;
 	}
 
@@ -2073,8 +2076,8 @@ et61x251_vidioc_try_s_fmt(struct et61x25
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_FMT failed because of hardware problems. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -2085,8 +2088,8 @@ et61x251_vidioc_try_s_fmt(struct et61x25
 	    nbuffers != et61x251_request_buffers(cam, nbuffers, cam->io)) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_FMT failed because of not enough memory. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -ENOMEM;
 	}
 
@@ -2134,7 +2137,7 @@ et61x251_vidioc_s_jpegcomp(struct et61x2
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_JPEGCOMP failed because of hardware "
 		       "problems. To use the camera, close and open "
-		       "/dev/video%d again.", cam->v4ldev->num);
+		       "/dev/%s again.", video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -2607,7 +2610,8 @@ et61x251_usb_probe(struct usb_interface*
 		goto fail;
 	}
 
-	DBG(2, "V4L2 device registered as /dev/video%d", cam->v4ldev->num);
+	DBG(2, "V4L2 device registered as /dev/%s",
+	    video_device_node_name(cam->v4ldev));
 
 	cam->module_param.force_munmap = force_munmap[dev_nr];
 	cam->module_param.frame_timeout = frame_timeout[dev_nr];
@@ -2658,9 +2662,9 @@ static void et61x251_usb_disconnect(stru
 	DBG(2, "Disconnecting %s...", cam->v4ldev->name);
 
 	if (cam->users) {
-		DBG(2, "Device /dev/video%d is open! Deregistration and "
-		       "memory deallocation are deferred.",
-		    cam->v4ldev->num);
+		DBG(2, "Device /dev/%s is open! Deregistration and memory "
+		       "deallocation are deferred.",
+		    video_device_node_name(cam->v4ldev));
 		cam->state |= DEV_MISCONFIGURED;
 		et61x251_stop_transfer(cam);
 		cam->state |= DEV_DISCONNECTED;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/gspca.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/gspca/gspca.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/gspca.c
@@ -1008,7 +1008,8 @@ static void gspca_release(struct video_d
 {
 	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
 
-	PDEBUG(D_PROBE, "/dev/video%d released", gspca_dev->vdev.num);
+	PDEBUG(D_PROBE, "/dev/%s released",
+		video_device_node_name(&gspca_dev->vdev));
 
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
@@ -2091,7 +2092,8 @@ int gspca_dev_probe(struct usb_interface
 	}
 
 	usb_set_intfdata(intf, gspca_dev);
-	PDEBUG(D_PROBE, "/dev/video%d created", gspca_dev->vdev.num);
+	PDEBUG(D_PROBE, "/dev/%s created",
+		video_device_node_name(&gspca_dev->vdev));
 	return 0;
 out:
 	kfree(gspca_dev->usb_buf);
@@ -2110,7 +2112,8 @@ void gspca_disconnect(struct usb_interfa
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 
-	PDEBUG(D_PROBE, "/dev/video%d disconnect", gspca_dev->vdev.num);
+	PDEBUG(D_PROBE, "/dev/%s disconnect",
+		video_device_node_name(&gspca_dev->vdev));
 	mutex_lock(&gspca_dev->usb_lock);
 	gspca_dev->present = 0;
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/ivtv/ivtv-streams.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/ivtv/ivtv-streams.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/ivtv/ivtv-streams.c
@@ -245,6 +245,7 @@ static int ivtv_reg_dev(struct ivtv *itv
 {
 	struct ivtv_stream *s = &itv->streams[type];
 	int vfl_type = ivtv_stream_info[type].vfl_type;
+	const char *name;
 	int num;
 
 	if (s->vdev == NULL)
@@ -268,24 +269,24 @@ static int ivtv_reg_dev(struct ivtv *itv
 		s->vdev = NULL;
 		return -ENOMEM;
 	}
-	num = s->vdev->num;
+	name = video_device_node_name(s->vdev);
 
 	switch (vfl_type) {
 	case VFL_TYPE_GRABBER:
-		IVTV_INFO("Registered device video%d for %s (%d kB)\n",
-			num, s->name, itv->options.kilobytes[type]);
+		IVTV_INFO("Registered device %s for %s (%d kB)\n",
+			name, s->name, itv->options.kilobytes[type]);
 		break;
 	case VFL_TYPE_RADIO:
-		IVTV_INFO("Registered device radio%d for %s\n",
-			num, s->name);
+		IVTV_INFO("Registered device %s for %s\n",
+			name, s->name);
 		break;
 	case VFL_TYPE_VBI:
 		if (itv->options.kilobytes[type])
-			IVTV_INFO("Registered device vbi%d for %s (%d kB)\n",
-				num, s->name, itv->options.kilobytes[type]);
+			IVTV_INFO("Registered device %s for %s (%d kB)\n",
+				name, s->name, itv->options.kilobytes[type]);
 		else
-			IVTV_INFO("Registered device vbi%d for %s\n",
-				num, s->name);
+			IVTV_INFO("Registered device %s for %s\n",
+				name, s->name);
 		break;
 	}
 	return 0;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -152,17 +152,6 @@ static struct v4l2_format pvr_format [] 
 };
 
 
-static const char *get_v4l_name(int v4l_type)
-{
-	switch (v4l_type) {
-	case VFL_TYPE_GRABBER: return "video";
-	case VFL_TYPE_RADIO: return "radio";
-	case VFL_TYPE_VBI: return "vbi";
-	default: return "?";
-	}
-}
-
-
 /*
  * pvr_ioctl()
  *
@@ -892,10 +881,8 @@ static long pvr2_v4l2_do_ioctl(struct fi
 
 static void pvr2_v4l2_dev_destroy(struct pvr2_v4l2_dev *dip)
 {
-	int num = dip->devbase.num;
 	struct pvr2_hdw *hdw = dip->v4lp->channel.mc_head->hdw;
 	enum pvr2_config cfg = dip->config;
-	int v4l_type = dip->v4l_type;
 
 	pvr2_hdw_v4l_store_minor_number(hdw,dip->minor_type,-1);
 
@@ -907,8 +894,8 @@ static void pvr2_v4l2_dev_destroy(struct
 	   are gone. */
 	video_unregister_device(&dip->devbase);
 
-	printk(KERN_INFO "pvrusb2: unregistered device %s%u [%s]\n",
-	       get_v4l_name(v4l_type), num,
+	printk(KERN_INFO "pvrusb2: unregistered device %s [%s]\n",
+	       video_device_node_name(&dip->devbase),
 	       pvr2_config_get_name(cfg));
 
 }
@@ -1322,8 +1309,8 @@ static void pvr2_v4l2_dev_init(struct pv
 			": Failed to register pvrusb2 v4l device\n");
 	}
 
-	printk(KERN_INFO "pvrusb2: registered device %s%u [%s]\n",
-	       get_v4l_name(dip->v4l_type), dip->devbase.num,
+	printk(KERN_INFO "pvrusb2: registered device %s [%s]\n",
+	       video_device_node_name(&dip->devbase),
 	       pvr2_config_get_name(dip->config));
 
 	pvr2_hdw_v4l_store_minor_number(vp->channel.mc_head->hdw,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/pwc/pwc-if.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/pwc/pwc-if.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/pwc/pwc-if.c
@@ -1815,7 +1815,8 @@ static int usb_pwc_probe(struct usb_inte
 		goto err_video_release;
 	}
 
-	PWC_INFO("Registered as /dev/video%d.\n", pdev->vdev->num);
+	PWC_INFO("Registered as /dev/%s.\n",
+		 video_device_node_name(pdev->vdev));
 
 	/* occupy slot */
 	if (hint < MAX_DEV_HINTS)
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-core.c
@@ -1107,8 +1107,8 @@ static int __devinit saa7134_initdev(str
 		       dev->name);
 		goto fail4;
 	}
-	printk(KERN_INFO "%s: registered device video%d [v4l2]\n",
-	       dev->name, dev->video_dev->num);
+	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
+	       dev->name, video_device_node_name(dev->video_dev));
 
 	dev->vbi_dev = vdev_init(dev, &saa7134_video_template, "vbi");
 
@@ -1116,8 +1116,8 @@ static int __devinit saa7134_initdev(str
 				    vbi_nr[dev->nr]);
 	if (err < 0)
 		goto fail4;
-	printk(KERN_INFO "%s: registered device vbi%d\n",
-	       dev->name, dev->vbi_dev->num);
+	printk(KERN_INFO "%s: registered device %s\n",
+	       dev->name, video_device_node_name(dev->vbi_dev));
 
 	if (card_has_radio(dev)) {
 		dev->radio_dev = vdev_init(dev,&saa7134_radio_template,"radio");
@@ -1125,8 +1125,8 @@ static int __devinit saa7134_initdev(str
 					    radio_nr[dev->nr]);
 		if (err < 0)
 			goto fail4;
-		printk(KERN_INFO "%s: registered device radio%d\n",
-		       dev->name, dev->radio_dev->num);
+		printk(KERN_INFO "%s: registered device %s\n",
+		       dev->name, video_device_node_name(dev->radio_dev));
 	}
 
 	/* everything worked */
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-empress.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-empress.c
@@ -552,8 +552,8 @@ static int empress_init(struct saa7134_d
 		dev->empress_dev = NULL;
 		return err;
 	}
-	printk(KERN_INFO "%s: registered device video%d [mpeg]\n",
-	       dev->name, dev->empress_dev->num);
+	printk(KERN_INFO "%s: registered device %s [mpeg]\n",
+	       dev->name, video_device_node_name(dev->empress_dev));
 
 	videobuf_queue_sg_init(&dev->empress_tsq, &saa7134_ts_qops,
 			    &dev->pci->dev, &dev->slock,
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/se401.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/se401.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/se401.c
@@ -1436,8 +1436,8 @@ static int se401_probe(struct usb_interf
 		err("video_register_device failed");
 		return -EIO;
 	}
-	dev_info(&intf->dev, "registered new video device: video%d\n",
-		 se401->vdev.num);
+	dev_info(&intf->dev, "registered new video device: %s\n",
+		 video_device_node_name(&se401->vdev));
 
 	usb_set_intfdata(intf, se401);
 	return 0;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/sn9c102/sn9c102_core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/sn9c102/sn9c102_core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/sn9c102/sn9c102_core.c
@@ -1011,8 +1011,8 @@ static int sn9c102_stream_interrupt(stru
 	else if (cam->stream != STREAM_OFF) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "URB timeout reached. The camera is misconfigured. "
-		       "To use it, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "To use it, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -1738,7 +1738,8 @@ static void sn9c102_release_resources(st
 
 	cam = container_of(kref, struct sn9c102_device, kref);
 
-	DBG(2, "V4L2 device /dev/video%d deregistered", cam->v4ldev->num);
+	DBG(2, "V4L2 device /dev/%s deregistered",
+	    video_device_node_name(cam->v4ldev));
 	video_set_drvdata(cam->v4ldev, NULL);
 	video_unregister_device(cam->v4ldev);
 	usb_put_dev(cam->usbdev);
@@ -1795,8 +1796,8 @@ static int sn9c102_open(struct file *fil
 	}
 
 	if (cam->users) {
-		DBG(2, "Device /dev/video%d is already in use",
-		       cam->v4ldev->num);
+		DBG(2, "Device /dev/%s is already in use",
+		       video_device_node_name(cam->v4ldev));
 		DBG(3, "Simultaneous opens are not supported");
 		/*
 		   open() must follow the open flags and should block
@@ -1849,7 +1850,8 @@ static int sn9c102_open(struct file *fil
 	cam->frame_count = 0;
 	sn9c102_empty_framequeues(cam);
 
-	DBG(3, "Video device /dev/video%d is open", cam->v4ldev->num);
+	DBG(3, "Video device /dev/%s is open",
+	    video_device_node_name(cam->v4ldev));
 
 out:
 	mutex_unlock(&cam->open_mutex);
@@ -1874,7 +1876,8 @@ static int sn9c102_release(struct file *
 	cam->users--;
 	wake_up_interruptible_nr(&cam->wait_open, 1);
 
-	DBG(3, "Video device /dev/video%d closed", cam->v4ldev->num);
+	DBG(3, "Video device /dev/%s closed",
+	    video_device_node_name(cam->v4ldev));
 
 	kref_put(&cam->kref, sn9c102_release_resources);
 
@@ -2437,8 +2440,8 @@ sn9c102_vidioc_s_crop(struct sn9c102_dev
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_CROP failed because of hardware problems. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -2450,8 +2453,8 @@ sn9c102_vidioc_s_crop(struct sn9c102_dev
 	    nbuffers != sn9c102_request_buffers(cam, nbuffers, cam->io)) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_CROP failed because of not enough memory. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -ENOMEM;
 	}
 
@@ -2694,8 +2697,8 @@ sn9c102_vidioc_try_s_fmt(struct sn9c102_
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_FMT failed because of hardware problems. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -2706,8 +2709,8 @@ sn9c102_vidioc_try_s_fmt(struct sn9c102_
 	    nbuffers != sn9c102_request_buffers(cam, nbuffers, cam->io)) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_FMT failed because of not enough memory. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -ENOMEM;
 	}
 
@@ -2752,9 +2755,9 @@ sn9c102_vidioc_s_jpegcomp(struct sn9c102
 	err += sn9c102_set_compression(cam, &jc);
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
-		DBG(1, "VIDIOC_S_JPEGCOMP failed because of hardware "
-		       "problems. To use the camera, close and open "
-		       "/dev/video%d again.", cam->v4ldev->num);
+		DBG(1, "VIDIOC_S_JPEGCOMP failed because of hardware problems. "
+		       "To use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -3350,7 +3353,8 @@ sn9c102_usb_probe(struct usb_interface* 
 		goto fail;
 	}
 
-	DBG(2, "V4L2 device registered as /dev/video%d", cam->v4ldev->num);
+	DBG(2, "V4L2 device registered as /dev/%s",
+	    video_device_node_name(cam->v4ldev));
 
 	video_set_drvdata(cam->v4ldev, cam);
 	cam->module_param.force_munmap = force_munmap[dev_nr];
@@ -3402,9 +3406,9 @@ static void sn9c102_usb_disconnect(struc
 	DBG(2, "Disconnecting %s...", cam->v4ldev->name);
 
 	if (cam->users) {
-		DBG(2, "Device /dev/video%d is open! Deregistration and "
-		       "memory deallocation are deferred.",
-		    cam->v4ldev->num);
+		DBG(2, "Device /dev/%s is open! Deregistration and memory "
+		       "deallocation are deferred.",
+		    video_device_node_name(cam->v4ldev));
 		cam->state |= DEV_MISCONFIGURED;
 		sn9c102_stop_transfer(cam);
 		cam->state |= DEV_DISCONNECTED;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/stk-webcam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/stk-webcam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/stk-webcam.c
@@ -1329,7 +1329,7 @@ static int stk_register_video_device(str
 		STK_ERROR("v4l registration failed\n");
 	else
 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
-			" /dev/video%d\n", dev->vdev.num);
+			 " /dev/%s\n", video_device_node_name(&dev->vdev));
 	return err;
 }
 
@@ -1420,7 +1420,7 @@ static void stk_camera_disconnect(struct
 	stk_remove_sysfs_files(&dev->vdev);
 
 	STK_INFO("Syntek USB2.0 Camera release resources "
-		"video device /dev/video%d\n", dev->vdev.num);
+		 "video device /dev/%s\n", video_device_node_name(&dev->vdev));
 
 	video_unregister_device(&dev->vdev);
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/stv680.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/stv680.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/stv680.c
@@ -1472,8 +1472,8 @@ static int stv680_probe (struct usb_inte
 		retval = -EIO;
 		goto error_vdev;
 	}
-	PDEBUG(0, "STV(i): registered new video device: video%d",
-		stv680->vdev->num);
+	PDEBUG(0, "STV(i): registered new video device: %s",
+		video_device_node_name(stv680->vdev));
 
 	usb_set_intfdata (intf, stv680);
 	retval = stv680_create_sysfs_files(stv680->vdev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvideo/usbvideo.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvideo/usbvideo.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvideo/usbvideo.c
@@ -1053,9 +1053,9 @@ int usbvideo_RegisterVideoDevice(struct 
 			 "%s: video_register_device() successful\n", __func__);
 	}
 
-	dev_info(&uvd->dev->dev, "%s on /dev/video%d: canvas=%s videosize=%s\n",
+	dev_info(&uvd->dev->dev, "%s on /dev/%s: canvas=%s videosize=%s\n",
 		 (uvd->handle != NULL) ? uvd->handle->drvName : "???",
-		 uvd->vdev.num, tmp2, tmp1);
+		 video_device_node_name(&uvd->vdev), tmp2, tmp1);
 
 	usb_get_dev(uvd->dev);
 	return 0;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvideo/vicam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvideo/vicam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvideo/vicam.c
@@ -1183,8 +1183,8 @@ vicam_probe( struct usb_interface *intf,
 		return -EIO;
 	}
 
-	printk(KERN_INFO "ViCam webcam driver now controlling video device %d\n",
-			cam->vdev.num);
+	printk(KERN_INFO "ViCam webcam driver now controlling device %s\n",
+		video_device_node_name(&cam->vdev));
 
 	usb_set_intfdata (intf, cam);
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvision/usbvision-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-video.c
@@ -1416,8 +1416,8 @@ static void usbvision_unregister_video(s
 {
 	// vbi Device:
 	if (usbvision->vbi) {
-		PDEBUG(DBG_PROBE, "unregister /dev/vbi%d [v4l2]",
-		       usbvision->vbi->num);
+		PDEBUG(DBG_PROBE, "unregister /dev/%s [v4l2]",
+		       video_device_node_name(usbvision->vbi));
 		if (usbvision->vbi->minor != -1) {
 			video_unregister_device(usbvision->vbi);
 		} else {
@@ -1428,8 +1428,8 @@ static void usbvision_unregister_video(s
 
 	// Radio Device:
 	if (usbvision->rdev) {
-		PDEBUG(DBG_PROBE, "unregister /dev/radio%d [v4l2]",
-		       usbvision->rdev->num);
+		PDEBUG(DBG_PROBE, "unregister /dev/%s [v4l2]",
+		       video_device_node_name(usbvision->rdev));
 		if (usbvision->rdev->minor != -1) {
 			video_unregister_device(usbvision->rdev);
 		} else {
@@ -1440,8 +1440,8 @@ static void usbvision_unregister_video(s
 
 	// Video Device:
 	if (usbvision->vdev) {
-		PDEBUG(DBG_PROBE, "unregister /dev/video%d [v4l2]",
-		       usbvision->vdev->num);
+		PDEBUG(DBG_PROBE, "unregister /dev/%s [v4l2]",
+		       video_device_node_name(usbvision->vdev));
 		if (usbvision->vdev->minor != -1) {
 			video_unregister_device(usbvision->vdev);
 		} else {
@@ -1466,8 +1466,8 @@ static int __devinit usbvision_register_
 				  video_nr)<0) {
 		goto err_exit;
 	}
-	printk(KERN_INFO "USBVision[%d]: registered USBVision Video device /dev/video%d [v4l2]\n",
-	       usbvision->nr, usbvision->vdev->num);
+	printk(KERN_INFO "USBVision[%d]: registered USBVision Video device /dev/%s [v4l2]\n",
+	       usbvision->nr, video_device_node_name(usbvision->vdev));
 
 	// Radio Device:
 	if (usbvision_device_data[usbvision->DevModel].Radio) {
@@ -1483,8 +1483,8 @@ static int __devinit usbvision_register_
 					  radio_nr)<0) {
 			goto err_exit;
 		}
-		printk(KERN_INFO "USBVision[%d]: registered USBVision Radio device /dev/radio%d [v4l2]\n",
-		       usbvision->nr, usbvision->rdev->num);
+		printk(KERN_INFO "USBVision[%d]: registered USBVision Radio device /dev/%s [v4l2]\n",
+		       usbvision->nr, video_device_node_name(usbvision->rdev));
 	}
 	// vbi Device:
 	if (usbvision_device_data[usbvision->DevModel].vbi) {
@@ -1499,8 +1499,8 @@ static int __devinit usbvision_register_
 					  vbi_nr)<0) {
 			goto err_exit;
 		}
-		printk(KERN_INFO "USBVision[%d]: registered USBVision VBI device /dev/vbi%d [v4l2] (Not Working Yet!)\n",
-		       usbvision->nr, usbvision->vbi->num);
+		printk(KERN_INFO "USBVision[%d]: registered USBVision VBI device /dev/%s [v4l2] (Not Working Yet!)\n",
+		       usbvision->nr, video_device_node_name(usbvision->vbi));
 	}
 	// all done
 	return 0;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/vivi.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
@@ -1151,7 +1151,8 @@ static int vivi_open(struct file *file)
 		return -EBUSY;
 	}
 
-	dprintk(dev, 1, "open /dev/video%d type=%s users=%d\n", dev->vfd->num,
+	dprintk(dev, 1, "open /dev/%s type=%s users=%d\n",
+		video_device_node_name(dev->vfd),
 		v4l2_type_names[V4L2_BUF_TYPE_VIDEO_CAPTURE], dev->users);
 
 	/* allocate + initialize per filehandle data */
@@ -1320,8 +1321,8 @@ static int vivi_release(void)
 		list_del(list);
 		dev = list_entry(list, struct vivi_dev, vivi_devlist);
 
-		v4l2_info(&dev->v4l2_dev, "unregistering /dev/video%d\n",
-			dev->vfd->num);
+		v4l2_info(&dev->v4l2_dev, "unregistering /dev/%s\n",
+			video_device_node_name(dev->vfd));
 		video_unregister_device(dev->vfd);
 		v4l2_device_unregister(&dev->v4l2_dev);
 		kfree(dev);
@@ -1382,8 +1383,8 @@ static int __init vivi_create_instance(i
 		video_nr++;
 
 	dev->vfd = vfd;
-	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as /dev/video%d\n",
-			vfd->num);
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as /dev/%s\n",
+			video_device_node_name(vfd));
 	return 0;
 
 rel_vdev:
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/w9968cf.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/w9968cf.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/w9968cf.c
@@ -2337,9 +2337,9 @@ static int w9968cf_sensor_init(struct w9
 error:
 	cam->sensor_initialized = 0;
 	cam->sensor = CC_UNKNOWN;
-	DBG(1, "Image sensor initialization failed for %s (/dev/video%d). "
+	DBG(1, "Image sensor initialization failed for %s (/dev/%s). "
 	       "Try to detach and attach this device again",
-	    symbolic(camlist, cam->id), cam->v4ldev->num)
+	    symbolic(camlist, cam->id), video_device_node_name(cam->v4ldev))
 	return err;
 }
 
@@ -2585,7 +2585,8 @@ static void w9968cf_release_resources(st
 {
 	mutex_lock(&w9968cf_devlist_mutex);
 
-	DBG(2, "V4L device deregistered: /dev/video%d", cam->v4ldev->num)
+	DBG(2, "V4L device deregistered: /dev/%s",
+	    video_device_node_name(cam->v4ldev))
 
 	video_unregister_device(cam->v4ldev);
 	list_del(&cam->v4llist);
@@ -2619,17 +2620,19 @@ static int w9968cf_open(struct file *fil
 
 	if (cam->sensor == CC_UNKNOWN) {
 		DBG(2, "No supported image sensor has been detected by the "
-		       "'ovcamchip' module for the %s (/dev/video%d). Make "
-		       "sure it is loaded *before* (re)connecting the camera.",
-		    symbolic(camlist, cam->id), cam->v4ldev->num)
+		       "'ovcamchip' module for the %s (/dev/%s). Make sure "
+		       "it is loaded *before* (re)connecting the camera.",
+		    symbolic(camlist, cam->id),
+		    video_device_node_name(cam->v4ldev))
 		mutex_unlock(&cam->dev_mutex);
 		up_read(&w9968cf_disconnect);
 		return -ENODEV;
 	}
 
 	if (cam->users) {
-		DBG(2, "%s (/dev/video%d) has been already occupied by '%s'",
-		    symbolic(camlist, cam->id), cam->v4ldev->num, cam->command)
+		DBG(2, "%s (/dev/%s) has been already occupied by '%s'",
+		    symbolic(camlist, cam->id),
+		    video_device_node_name(cam->v4ldev), cam->command)
 		if ((filp->f_flags & O_NONBLOCK)||(filp->f_flags & O_NDELAY)) {
 			mutex_unlock(&cam->dev_mutex);
 			up_read(&w9968cf_disconnect);
@@ -2650,8 +2653,8 @@ static int w9968cf_open(struct file *fil
 		mutex_lock(&cam->dev_mutex);
 	}
 
-	DBG(5, "Opening '%s', /dev/video%d ...",
-	    symbolic(camlist, cam->id), cam->v4ldev->num)
+	DBG(5, "Opening '%s', /dev/%s ...",
+	    symbolic(camlist, cam->id), video_device_node_name(cam->v4ldev))
 
 	cam->streaming = 0;
 	cam->misconfigured = 0;
@@ -3515,7 +3518,8 @@ w9968cf_usb_probe(struct usb_interface* 
 		goto fail;
 	}
 
-	DBG(2, "V4L device registered as /dev/video%d", cam->v4ldev->num)
+	DBG(2, "V4L device registered as /dev/%s",
+	    video_device_node_name(cam->v4ldev))
 
 	/* Set some basic constants */
 	w9968cf_configure_camera(cam, udev, mod_id, dev_nr);
@@ -3571,10 +3575,10 @@ static void w9968cf_usb_disconnect(struc
 		wake_up_interruptible_all(&cam->open);
 
 		if (cam->users) {
-			DBG(2, "The device is open (/dev/video%d)! "
+			DBG(2, "The device is open (/dev/%s)! "
 			       "Process name: %s. Deregistration and memory "
 			       "deallocation are deferred on close.",
-			    cam->v4ldev->num, cam->command)
+			    video_device_node_name(cam->v4ldev), cam->command)
 			cam->misconfigured = 1;
 			w9968cf_stop_transfer(cam);
 			wake_up_interruptible(&cam->wait_queue);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/zc0301/zc0301_core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/zc0301/zc0301_core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/zc0301/zc0301_core.c
@@ -542,8 +542,8 @@ static int zc0301_stream_interrupt(struc
 	else if (cam->stream != STREAM_OFF) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "URB timeout reached. The camera is misconfigured. To "
-		       "use it, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use it, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -644,7 +644,8 @@ static void zc0301_release_resources(str
 {
 	struct zc0301_device *cam = container_of(kref, struct zc0301_device,
 						 kref);
-	DBG(2, "V4L2 device /dev/video%d deregistered", cam->v4ldev->num);
+	DBG(2, "V4L2 device /dev/%s deregistered",
+	    video_device_node_name(cam->v4ldev));
 	video_set_drvdata(cam->v4ldev, NULL);
 	video_unregister_device(cam->v4ldev);
 	usb_put_dev(cam->usbdev);
@@ -683,7 +684,8 @@ static int zc0301_open(struct file *filp
 	}
 
 	if (cam->users) {
-		DBG(2, "Device /dev/video%d is busy...", cam->v4ldev->num);
+		DBG(2, "Device /dev/%s is busy...",
+		    video_device_node_name(cam->v4ldev));
 		DBG(3, "Simultaneous opens are not supported");
 		if ((filp->f_flags & O_NONBLOCK) ||
 		    (filp->f_flags & O_NDELAY)) {
@@ -726,7 +728,8 @@ static int zc0301_open(struct file *filp
 	cam->frame_count = 0;
 	zc0301_empty_framequeues(cam);
 
-	DBG(3, "Video device /dev/video%d is open", cam->v4ldev->num);
+	DBG(3, "Video device /dev/%s is open",
+	    video_device_node_name(cam->v4ldev));
 
 out:
 	mutex_unlock(&cam->open_mutex);
@@ -750,7 +753,8 @@ static int zc0301_release(struct file *f
 	cam->users--;
 	wake_up_interruptible_nr(&cam->wait_open, 1);
 
-	DBG(3, "Video device /dev/video%d closed", cam->v4ldev->num);
+	DBG(3, "Video device /dev/%s closed",
+	    video_device_node_name(cam->v4ldev));
 
 	kref_put(&cam->kref, zc0301_release_resources);
 
@@ -1280,8 +1284,8 @@ zc0301_vidioc_s_crop(struct zc0301_devic
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_CROP failed because of hardware problems. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -1293,8 +1297,8 @@ zc0301_vidioc_s_crop(struct zc0301_devic
 	    nbuffers != zc0301_request_buffers(cam, nbuffers, cam->io)) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_CROP failed because of not enough memory. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -ENOMEM;
 	}
 
@@ -1475,8 +1479,8 @@ zc0301_vidioc_try_s_fmt(struct zc0301_de
 	if (err) { /* atomic, no rollback in ioctl() */
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_FMT failed because of hardware problems. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -1487,8 +1491,8 @@ zc0301_vidioc_try_s_fmt(struct zc0301_de
 	    nbuffers != zc0301_request_buffers(cam, nbuffers, cam->io)) {
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_FMT failed because of not enough memory. To "
-		       "use the camera, close and open /dev/video%d again.",
-		    cam->v4ldev->num);
+		       "use the camera, close and open /dev/%s again.",
+		    video_device_node_name(cam->v4ldev));
 		return -ENOMEM;
 	}
 
@@ -1535,7 +1539,7 @@ zc0301_vidioc_s_jpegcomp(struct zc0301_d
 		cam->state |= DEV_MISCONFIGURED;
 		DBG(1, "VIDIOC_S_JPEGCOMP failed because of hardware "
 		       "problems. To use the camera, close and open "
-		       "/dev/video%d again.", cam->v4ldev->num);
+		       "/dev/%s again.", video_device_node_name(cam->v4ldev));
 		return -EIO;
 	}
 
@@ -2007,7 +2011,8 @@ zc0301_usb_probe(struct usb_interface* i
 		goto fail;
 	}
 
-	DBG(2, "V4L2 device registered as /dev/video%d", cam->v4ldev->num);
+	DBG(2, "V4L2 device registered as /dev/%s",
+	    video_device_node_name(cam->v4ldev));
 
 	cam->module_param.force_munmap = force_munmap[dev_nr];
 	cam->module_param.frame_timeout = frame_timeout[dev_nr];
@@ -2044,9 +2049,9 @@ static void zc0301_usb_disconnect(struct
 	DBG(2, "Disconnecting %s...", cam->v4ldev->name);
 
 	if (cam->users) {
-		DBG(2, "Device /dev/video%d is open! Deregistration and "
+		DBG(2, "Device /dev/%s is open! Deregistration and "
 		       "memory deallocation are deferred.",
-		    cam->v4ldev->num);
+		    video_device_node_name(cam->v4ldev));
 		cam->state |= DEV_MISCONFIGURED;
 		zc0301_stop_transfer(cam);
 		cam->state |= DEV_DISCONNECTED;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/zr364xx.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/zr364xx.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/zr364xx.c
@@ -1635,8 +1635,8 @@ static int zr364xx_probe(struct usb_inte
 
 	spin_lock_init(&cam->slock);
 
-	dev_info(&udev->dev, DRIVER_DESC " controlling video device %d\n",
-		 cam->vdev->num);
+	dev_info(&udev->dev, DRIVER_DESC " controlling device %s\n",
+		 video_device_node_name(cam->vdev));
 	return 0;
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/arv.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/arv.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/arv.c
@@ -865,8 +865,8 @@ static int __init ar_init(void)
 		goto out_dev;
 	}
 
-	printk("video%d: Found M64278 VGA (IRQ %d, Freq %dMHz).\n",
-		ar->vdev->num, M32R_IRQ_INT3, freq);
+	printk("%s: Found M64278 VGA (IRQ %d, Freq %dMHz).\n",
+		video_device_node_name(ar->vdev), M32R_IRQ_INT3, freq);
 
 	return 0;
 
Index: v4l-dvb-mc-uvc/linux/drivers/staging/go7007/go7007-v4l2.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/go7007/go7007-v4l2.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/go7007/go7007-v4l2.c
@@ -1837,8 +1837,8 @@ int go7007_v4l2_init(struct go7007 *go)
 	}
 	video_set_drvdata(go->video_dev, go);
 	++go->ref_count;
-	printk(KERN_INFO "%s: registered device video%d [v4l2]\n",
-	       go->video_dev->name, go->video_dev->num);
+	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
+	       go->video_dev->name, video_device_node_name(go->video_dev));
 
 	return 0;
 }
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/omap24xxcam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
@@ -1678,7 +1678,8 @@ static int omap24xxcam_device_register(s
 
 	omap24xxcam_poweron_reset(cam);
 
-	dev_info(cam->dev, "registered device video%d\n", vfd->minor);
+	dev_info(cam->dev, "registered device %s\n",
+		 video_device_node_name(vfd));
 
 	return 0;
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/hdpvr/hdpvr-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/hdpvr/hdpvr-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/hdpvr/hdpvr-core.c
@@ -376,8 +376,8 @@ static int hdpvr_probe(struct usb_interf
 	usb_set_intfdata(interface, dev);
 
 	/* let the user know what node this device is now attached to */
-	v4l2_info(&dev->v4l2_dev, "device now attached to /dev/video%d\n",
-		  dev->video_dev->minor);
+	v4l2_info(&dev->v4l2_dev, "device now attached to /dev/%s\n",
+		  video_device_node_name(dev->video_dev));
 	return 0;
 
 error:
@@ -391,13 +391,10 @@ error:
 static void hdpvr_disconnect(struct usb_interface *interface)
 {
 	struct hdpvr_device *dev;
-	int minor;
 
 	dev = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 
-	minor = dev->video_dev->minor;
-
 	/* prevent more I/O from starting and stop any ongoing */
 	mutex_lock(&dev->io_mutex);
 	dev->status = STATUS_DISCONNECTED;
@@ -425,7 +422,8 @@ static void hdpvr_disconnect(struct usb_
 
 	atomic_dec(&dev_nr);
 
-	v4l2_info(&dev->v4l2_dev, "device /dev/video%d disconnected\n", minor);
+	v4l2_info(&dev->v4l2_dev, "device /dev/%s disconnected\n",
+		  video_device_node_name(dev->video_dev));
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev->usbc_buf);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/gl860/gl860.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/gspca/gl860/gl860.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/gl860/gl860.c
@@ -534,8 +534,8 @@ static int sd_probe(struct usb_interface
 		gspca_dev = usb_get_intfdata(intf);
 
 		PDEBUG(D_PROBE,
-			"Camera is now controlling video device /dev/video%d",
-			gspca_dev->vdev.minor);
+			"Camera is now controlling video device /dev/%s",
+			video_device_node_name(&gspca_dev->vdev));
 	}
 
 	return ret;
