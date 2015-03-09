Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39460 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932758AbbCIQgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 16/19] tm6000: embed video_device
Date: Mon,  9 Mar 2015 17:34:10 +0100
Message-Id: <1425918853-12371-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c | 59 +++++++++------------------------
 drivers/media/usb/tm6000/tm6000.h       |  4 +--
 2 files changed, 17 insertions(+), 46 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 0f14d3c..77ce9ef 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1576,7 +1576,7 @@ static struct video_device tm6000_template = {
 	.name		= "tm6000",
 	.fops           = &tm6000_fops,
 	.ioctl_ops      = &video_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.tvnorms        = TM6000_STD,
 };
 
@@ -1609,25 +1609,19 @@ static struct video_device tm6000_radio_template = {
  * ------------------------------------------------------------------
  */
 
-static struct video_device *vdev_init(struct tm6000_core *dev,
+static void vdev_init(struct tm6000_core *dev,
+		struct video_device *vfd,
 		const struct video_device
 		*template, const char *type_name)
 {
-	struct video_device *vfd;
-
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
-
 	*vfd = *template;
 	vfd->v4l2_dev = &dev->v4l2_dev;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->lock = &dev->lock;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
 
 	video_set_drvdata(vfd, dev);
-	return vfd;
 }
 
 int tm6000_v4l2_register(struct tm6000_core *dev)
@@ -1658,62 +1652,46 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	if (ret)
 		goto free_ctrl;
 
-	dev->vfd = vdev_init(dev, &tm6000_template, "video");
+	vdev_init(dev, &dev->vfd, &tm6000_template, "video");
 
-	if (!dev->vfd) {
-		printk(KERN_INFO "%s: can't register video device\n",
-		       dev->name);
-		ret = -ENOMEM;
-		goto free_ctrl;
-	}
-	dev->vfd->ctrl_handler = &dev->ctrl_handler;
+	dev->vfd.ctrl_handler = &dev->ctrl_handler;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vidq.queued);
 
-	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
+	ret = video_register_device(&dev->vfd, VFL_TYPE_GRABBER, video_nr);
 
 	if (ret < 0) {
 		printk(KERN_INFO "%s: can't register video device\n",
 		       dev->name);
-		video_device_release(dev->vfd);
-		dev->vfd = NULL;
 		goto free_ctrl;
 	}
 
 	printk(KERN_INFO "%s: registered device %s\n",
-	       dev->name, video_device_node_name(dev->vfd));
+	       dev->name, video_device_node_name(&dev->vfd));
 
 	if (dev->caps.has_radio) {
-		dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
+		vdev_init(dev, &dev->radio_dev, &tm6000_radio_template,
 							   "radio");
-		if (!dev->radio_dev) {
-			printk(KERN_INFO "%s: can't register radio device\n",
-			       dev->name);
-			ret = -ENXIO;
-			goto unreg_video;
-		}
-
-		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
-		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+		dev->radio_dev.ctrl_handler = &dev->radio_ctrl_handler;
+		ret = video_register_device(&dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr);
 		if (ret < 0) {
 			printk(KERN_INFO "%s: can't register radio device\n",
 			       dev->name);
-			video_device_release(dev->radio_dev);
 			goto unreg_video;
 		}
 
 		printk(KERN_INFO "%s: registered device %s\n",
-		       dev->name, video_device_node_name(dev->radio_dev));
+		       dev->name, video_device_node_name(&dev->radio_dev));
 	}
 
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 
 unreg_video:
-	video_unregister_device(dev->vfd);
+	video_unregister_device(&dev->vfd);
 free_ctrl:
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
@@ -1722,19 +1700,12 @@ free_ctrl:
 
 int tm6000_v4l2_unregister(struct tm6000_core *dev)
 {
-	video_unregister_device(dev->vfd);
+	video_unregister_device(&dev->vfd);
 
 	/* if URB buffers are still allocated free them now */
 	tm6000_free_urb_buffers(dev);
 
-	if (dev->radio_dev) {
-		if (video_is_registered(dev->radio_dev))
-			video_unregister_device(dev->radio_dev);
-		else
-			video_device_release(dev->radio_dev);
-		dev->radio_dev = NULL;
-	}
-
+	video_unregister_device(&dev->radio_dev);
 	return 0;
 }
 
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index 08bd074..f212794 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -220,8 +220,8 @@ struct tm6000_core {
 	struct tm6000_fh		*resources;	/* Points to fh that is streaming */
 	bool				is_res_read;
 
-	struct video_device		*vfd;
-	struct video_device		*radio_dev;
+	struct video_device		vfd;
+	struct video_device		radio_dev;
 	struct tm6000_dmaqueue		vidq;
 	struct v4l2_device		v4l2_dev;
 	struct v4l2_ctrl_handler	ctrl_handler;
-- 
2.1.4

