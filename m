Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43881 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbZJTIOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:54 -0400
Message-Id: <20091020011215.343827441@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:17 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 07/14] v4l-mc: Remove devnode v4l2_dev field
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-mc-remove-devnode-v4l2-dev-field.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A pointer to the v4l2_device is stored in the v4l2_entity structure that
video_device derives from. There is no need to hold an extra copy of the
pointer.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/radio/dsbr100.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/radio/dsbr100.c
+++ v4l-dvb-mc/linux/drivers/media/radio/dsbr100.c
@@ -657,7 +657,7 @@ static int usb_dsbr100_probe(struct usb_
 	}
 
 	strlcpy(radio->videodev.name, v4l2_dev->name, sizeof(radio->videodev.name));
-	radio->videodev.v4l2_dev = v4l2_dev;
+	radio->videodev.entity.parent = v4l2_dev;
 	radio->videodev.fops = &usb_dsbr100_fops;
 	radio->videodev.ioctl_ops = &usb_dsbr100_ioctl_ops;
 	radio->videodev.release = usb_dsbr100_video_device_release;
Index: v4l-dvb-mc/linux/drivers/media/radio/radio-gemtek-pci.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/radio/radio-gemtek-pci.c
+++ v4l-dvb-mc/linux/drivers/media/radio/radio-gemtek-pci.c
@@ -414,7 +414,7 @@ static int __devinit gemtek_pci_probe(st
 	}
 
 	strlcpy(card->vdev.name, v4l2_dev->name, sizeof(card->vdev.name));
-	card->vdev.v4l2_dev = v4l2_dev;
+	card->vdev.entity.parent = v4l2_dev;
 	card->vdev.fops = &gemtek_pci_fops;
 	card->vdev.ioctl_ops = &gemtek_pci_ioctl_ops;
 	card->vdev.release = video_device_release_empty;
Index: v4l-dvb-mc/linux/drivers/media/radio/radio-maestro.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/radio/radio-maestro.c
+++ v4l-dvb-mc/linux/drivers/media/radio/radio-maestro.c
@@ -373,7 +373,7 @@ static int __devinit maestro_probe(struc
 	dev->io = pci_resource_start(pdev, 0) + GPIO_DATA;
 
 	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
-	dev->vdev.v4l2_dev = v4l2_dev;
+	dev->vdev.entity.parent = v4l2_dev;
 	dev->vdev.fops = &maestro_fops;
 	dev->vdev.ioctl_ops = &maestro_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
Index: v4l-dvb-mc/linux/drivers/media/radio/radio-maxiradio.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/radio/radio-maxiradio.c
+++ v4l-dvb-mc/linux/drivers/media/radio/radio-maxiradio.c
@@ -397,7 +397,7 @@ static int __devinit maxiradio_init_one(
 
 	dev->io = pci_resource_start(pdev, 0);
 	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
-	dev->vdev.v4l2_dev = v4l2_dev;
+	dev->vdev.entity.parent = v4l2_dev;
 	dev->vdev.fops = &maxiradio_fops;
 	dev->vdev.ioctl_ops = &maxiradio_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
Index: v4l-dvb-mc/linux/drivers/media/radio/radio-mr800.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/radio/radio-mr800.c
+++ v4l-dvb-mc/linux/drivers/media/radio/radio-mr800.c
@@ -700,7 +700,7 @@ static int usb_amradio_probe(struct usb_
 	}
 
 	strlcpy(radio->videodev->name, v4l2_dev->name, sizeof(radio->videodev->name));
-	radio->videodev->v4l2_dev = v4l2_dev;
+	radio->videodev->entity.parent = v4l2_dev;
 	radio->videodev->fops = &usb_amradio_fops;
 	radio->videodev->ioctl_ops = &usb_amradio_ioctl_ops;
 	radio->videodev->release = usb_amradio_video_device_release;
Index: v4l-dvb-mc/linux/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/bt8xx/bttv-driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/bt8xx/bttv-driver.c
@@ -4204,7 +4204,7 @@ static struct video_device *vdev_init(st
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->v4l2_dev = &btv->c.v4l2_dev;
+	vfd->entity.parent = &btv->c.v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug   = bttv_debug;
 	video_set_drvdata(vfd, btv);
Index: v4l-dvb-mc/linux/drivers/media/video/cafe_ccic.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/cafe_ccic.c
+++ v4l-dvb-mc/linux/drivers/media/video/cafe_ccic.c
@@ -1972,7 +1972,7 @@ static int cafe_pci_probe(struct pci_dev
 	cam->vdev = cafe_v4l_template;
 	cam->vdev.debug = 0;
 /*	cam->vdev.debug = V4L2_DEBUG_IOCTL_ARG;*/
-	cam->vdev.v4l2_dev = &cam->v4l2_dev;
+	cam->vdev.entity.parent = &cam->v4l2_dev;
 	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
 		goto out_smbus;
Index: v4l-dvb-mc/linux/drivers/media/video/cx18/cx18-streams.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/cx18/cx18-streams.c
+++ v4l-dvb-mc/linux/drivers/media/video/cx18/cx18-streams.c
@@ -182,7 +182,7 @@ static int cx18_prep_dev(struct cx18 *cx
 		 cx->v4l2_dev.name, s->name);
 
 	s->video_dev->num = num;
-	s->video_dev->v4l2_dev = &cx->v4l2_dev;
+	s->video_dev->entity.parent = &cx->v4l2_dev;
 	s->video_dev->fops = &cx18_v4l2_enc_fops;
 	s->video_dev->release = video_device_release;
 	s->video_dev->tvnorms = V4L2_STD_ALL;
Index: v4l-dvb-mc/linux/drivers/media/video/cx231xx/cx231xx-video.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/cx231xx/cx231xx-video.c
+++ v4l-dvb-mc/linux/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2320,7 +2320,7 @@ static struct video_device *cx231xx_vdev
 
 	*vfd = *template;
 	vfd->minor = -1;
-	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->entity.parent = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug = video_debug;
 
Index: v4l-dvb-mc/linux/drivers/media/video/cx23885/cx23885-video.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/cx23885/cx23885-video.c
+++ v4l-dvb-mc/linux/drivers/media/video/cx23885/cx23885-video.c
@@ -353,7 +353,7 @@ static struct video_device *cx23885_vdev
 		return NULL;
 	*vfd = *template;
 	vfd->minor = -1;
-	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->entity.parent = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 dev->name, type, cx23885_boards[dev->board].name);
Index: v4l-dvb-mc/linux/drivers/media/video/cx88/cx88-core.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/cx88/cx88-core.c
+++ v4l-dvb-mc/linux/drivers/media/video/cx88/cx88-core.c
@@ -1057,7 +1057,7 @@ struct video_device *cx88_vdev_init(stru
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->v4l2_dev = &core->v4l2_dev;
+	vfd->entity.parent = &core->v4l2_dev;
 	vfd->parent = &pci->dev;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
Index: v4l-dvb-mc/linux/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/em28xx/em28xx-video.c
+++ v4l-dvb-mc/linux/drivers/media/video/em28xx/em28xx-video.c
@@ -2154,7 +2154,7 @@ static struct video_device *em28xx_vdev_
 
 	*vfd		= *template;
 	vfd->minor	= -1;
-	vfd->v4l2_dev	= &dev->v4l2_dev;
+	vfd->entity.parent = &dev->v4l2_dev;
 	vfd->release	= video_device_release;
 	vfd->debug	= video_debug;
 
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-streams.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-streams.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-streams.c
@@ -207,7 +207,7 @@ static int ivtv_prep_dev(struct ivtv *it
 			itv->v4l2_dev.name, s->name);
 
 	s->vdev->num = num;
-	s->vdev->v4l2_dev = &itv->v4l2_dev;
+	s->vdev->entity.parent = &itv->v4l2_dev;
 	s->vdev->fops = ivtv_stream_info[type].fops;
 	s->vdev->release = video_device_release;
 	s->vdev->tvnorms = V4L2_STD_ALL;
Index: v4l-dvb-mc/linux/drivers/media/video/saa7134/saa7134-core.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/saa7134/saa7134-core.c
+++ v4l-dvb-mc/linux/drivers/media/video/saa7134/saa7134-core.c
@@ -853,7 +853,7 @@ static struct video_device *vdev_init(st
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->v4l2_dev  = &dev->v4l2_dev;
+	vfd->entity.parent = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug   = video_debug;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
Index: v4l-dvb-mc/linux/drivers/media/video/usbvision/usbvision-video.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/usbvision/usbvision-video.c
+++ v4l-dvb-mc/linux/drivers/media/video/usbvision/usbvision-video.c
@@ -1406,7 +1406,7 @@ static struct video_device *usbvision_vd
 	}
 	*vdev = *vdev_template;
 //	vdev->minor   = -1;
-	vdev->v4l2_dev = &usbvision->v4l2_dev;
+	vdev->entity.parent = &usbvision->v4l2_dev;
 	snprintf(vdev->name, sizeof(vdev->name), "%s", name);
 	video_set_drvdata(vdev, usbvision);
 	return vdev;
Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-dev.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-dev.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-dev.c
@@ -439,8 +439,8 @@ int video_register_device(struct video_d
 
 	vdev->vfl_type = type;
 	vdev->cdev = NULL;
-	if (vdev->v4l2_dev && vdev->v4l2_dev->dev)
-		vdev->parent = vdev->v4l2_dev->dev;
+	if (vdev->entity.parent && vdev->entity.parent->dev)
+		vdev->parent = vdev->entity.parent->dev;
 
 	/* Part 2: find a free minor, kernel number and device index. */
 #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
@@ -573,13 +573,13 @@ int video_register_device(struct video_d
 	   reference to the device goes away. */
 	vdev->dev.release = v4l2_device_release;
 
-	if (vdev->v4l2_dev) {
+	if (vdev->entity.parent) {
 		vdev->entity.type = V4L2_ENTITY_TYPE_NODE;
 		vdev->entity.subtype = V4L2_NODE_TYPE_V4L;
 		vdev->entity.v4l.major = VIDEO_MAJOR;
 		vdev->entity.v4l.minor = vdev->minor;
 		vdev->entity.name = vdev->name;
-		ret = v4l2_device_register_node(vdev->v4l2_dev, vdev);
+		ret = v4l2_device_register_node(vdev->entity.parent, vdev);
 		if (ret < 0)
 			printk(KERN_ERR "error\n"); /* TODO */
 	}
Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-device.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
@@ -196,10 +196,10 @@ static long mc_ioctl(struct file *filp, 
 
 	switch (cmd) {
 	case VIDIOC_MC_ENUM_ENTITIES:
-		return mc_enum_entities(vdev->v4l2_dev, (struct v4l2_mc_entity __user *)arg);
+		return mc_enum_entities(vdev->entity.parent, (struct v4l2_mc_entity __user *)arg);
 
 	case VIDIOC_MC_ENUM_LINKS:
-		return mc_enum_links(vdev->v4l2_dev, (struct v4l2_mc_ios __user *)arg);
+		return mc_enum_links(vdev->entity.parent, (struct v4l2_mc_ios __user *)arg);
 
 	case VIDIOC_MC_G_ENTITY:
 		id = fh->ent ? fh->ent->id : 0;
@@ -208,17 +208,17 @@ static long mc_ioctl(struct file *filp, 
 	case VIDIOC_MC_S_ENTITY:
 		if (copy_from_user(&id, uarg, sizeof(*uarg)))
 			return -EFAULT;
-		ent = find_entity(vdev->v4l2_dev, id);
+		ent = find_entity(vdev->entity.parent, id);
 		if (ent == NULL)
 			return -EINVAL;
 		fh->ent = ent;
 		break;
 
 	case VIDIOC_MC_MAKE_LINK:
-		return mc_make_link(vdev->v4l2_dev, (struct v4l2_mc_link __user *)arg);
+		return mc_make_link(vdev->entity.parent, (struct v4l2_mc_link __user *)arg);
 
 	case VIDIOC_MC_DELETE_LINK:
-		return mc_delete_link(vdev->v4l2_dev, (struct v4l2_mc_link __user *)arg);
+		return mc_delete_link(vdev->entity.parent, (struct v4l2_mc_link __user *)arg);
 
 	default:
 		if (fh->ent == NULL || fh->ent->ioctl == NULL)
@@ -264,7 +264,7 @@ int v4l2_device_register(struct device *
 	vdev = &v4l2_dev->mc;
 
 	snprintf(vdev->name, sizeof(vdev->name), "media controller");
-	vdev->v4l2_dev = v4l2_dev;
+	vdev->entity.parent = v4l2_dev;
 	vdev->fops = &mc_fops;
 	vdev->release = video_device_release_empty;
 	return video_register_device(vdev, VFL_TYPE_MC, -1);
@@ -363,7 +363,7 @@ int v4l2_device_register_node(struct v4l
 	/* Check for valid input */
 	if (v4l2_dev == NULL || vdev == NULL)
 		return -EINVAL;
-	vdev->v4l2_dev = v4l2_dev;
+	vdev->entity.parent = v4l2_dev;
 	spin_lock(&v4l2_dev->lock);
 	vdev->entity.id = v4l2_dev->devnode_id++;
 	list_add_tail(&vdev->entity.list, &v4l2_dev->devnodes);
@@ -375,12 +375,12 @@ EXPORT_SYMBOL_GPL(v4l2_device_register_n
 void v4l2_device_unregister_node(struct video_device *vdev)
 {
 	/* return if it isn't registered */
-	if (vdev == NULL || vdev->v4l2_dev == NULL)
+	if (vdev == NULL || vdev->entity.parent == NULL)
 		return;
-	spin_lock(&vdev->v4l2_dev->lock);
+	spin_lock(&vdev->entity.parent->lock);
 	list_del(&vdev->entity.list);
-	spin_unlock(&vdev->v4l2_dev->lock);
-	vdev->v4l2_dev = NULL;
+	spin_unlock(&vdev->entity.parent->lock);
+	vdev->entity.parent = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_node);
 
Index: v4l-dvb-mc/linux/drivers/media/video/w9968cf.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/w9968cf.c
+++ v4l-dvb-mc/linux/drivers/media/video/w9968cf.c
@@ -3502,7 +3502,7 @@ w9968cf_usb_probe(struct usb_interface* 
 	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
 	video_set_drvdata(cam->v4ldev, cam);
-	cam->v4ldev->v4l2_dev = &cam->v4l2_dev;
+	cam->v4ldev->entity.parent = &cam->v4l2_dev;
 
 	err = video_register_device(cam->v4ldev, VFL_TYPE_GRABBER,
 				    video_nr[dev_nr]);
Index: v4l-dvb-mc/linux/include/media/v4l2-dev.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-dev.h
+++ v4l-dvb-mc/linux/include/media/v4l2-dev.h
@@ -29,7 +29,6 @@
 struct v4l2_ioctl_callbacks;
 struct video_device;
 struct v4l2_alsa_device;
-struct v4l2_device;
 
 /* Flag to mark the video_device struct as unregistered.
    Drivers can set this flag if they want to block all future
@@ -71,9 +70,8 @@ struct video_device
 #endif
 	struct cdev *cdev;		/* character device */
 
-	/* Set either parent or v4l2_dev if your driver uses v4l2_device */
+	/* Set either parent or entity.parent if your driver uses v4l2_device */
 	struct device *parent;		/* device parent */
-	struct v4l2_device *v4l2_dev;	/* v4l2_device parent */
 
 	/* device info */
 	char name[32];


