Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbbCIQf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/19] bttv: embed video_device
Date: Mon,  9 Mar 2015 17:34:02 +0100
Message-Id: <1425918853-12371-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 73 +++++++++++------------------------
 drivers/media/pci/bt8xx/bttvp.h       |  6 +--
 2 files changed, 25 insertions(+), 54 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 4ec2a3c..bc12060 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2474,7 +2474,7 @@ static int bttv_querycap(struct file *file, void  *priv,
 		return -EINVAL;
 
 	strlcpy(cap->driver, "bttv", sizeof(cap->driver));
-	strlcpy(cap->card, btv->video_dev->name, sizeof(cap->card));
+	strlcpy(cap->card, btv->video_dev.name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(btv->c.pci));
 	cap->capabilities =
@@ -2484,9 +2484,9 @@ static int bttv_querycap(struct file *file, void  *priv,
 		V4L2_CAP_DEVICE_CAPS;
 	if (no_overlay <= 0)
 		cap->capabilities |= V4L2_CAP_VIDEO_OVERLAY;
-	if (btv->vbi_dev)
+	if (video_is_registered(&btv->vbi_dev))
 		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
-	if (btv->radio_dev)
+	if (video_is_registered(&btv->radio_dev))
 		cap->capabilities |= V4L2_CAP_RADIO;
 
 	/*
@@ -3905,18 +3905,14 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 /* ----------------------------------------------------------------------- */
 /* initialization                                                          */
 
-static struct video_device *vdev_init(struct bttv *btv,
-				      const struct video_device *template,
-				      const char *type_name)
+static void vdev_init(struct bttv *btv,
+		      struct video_device *vfd,
+		      const struct video_device *template,
+		      const char *type_name)
 {
-	struct video_device *vfd;
-
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
 	*vfd = *template;
 	vfd->v4l2_dev = &btv->c.v4l2_dev;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	video_set_drvdata(vfd, btv);
 	snprintf(vfd->name, sizeof(vfd->name), "BT%d%s %s (%s)",
 		 btv->id, (btv->id==848 && btv->revision==0x12) ? "A" : "",
@@ -3927,32 +3923,13 @@ static struct video_device *vdev_init(struct bttv *btv,
 		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
 		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
 	}
-	return vfd;
 }
 
 static void bttv_unregister_video(struct bttv *btv)
 {
-	if (btv->video_dev) {
-		if (video_is_registered(btv->video_dev))
-			video_unregister_device(btv->video_dev);
-		else
-			video_device_release(btv->video_dev);
-		btv->video_dev = NULL;
-	}
-	if (btv->vbi_dev) {
-		if (video_is_registered(btv->vbi_dev))
-			video_unregister_device(btv->vbi_dev);
-		else
-			video_device_release(btv->vbi_dev);
-		btv->vbi_dev = NULL;
-	}
-	if (btv->radio_dev) {
-		if (video_is_registered(btv->radio_dev))
-			video_unregister_device(btv->radio_dev);
-		else
-			video_device_release(btv->radio_dev);
-		btv->radio_dev = NULL;
-	}
+	video_unregister_device(&btv->video_dev);
+	video_unregister_device(&btv->vbi_dev);
+	video_unregister_device(&btv->radio_dev);
 }
 
 /* register video4linux devices */
@@ -3962,44 +3939,38 @@ static int bttv_register_video(struct bttv *btv)
 		pr_notice("Overlay support disabled\n");
 
 	/* video */
-	btv->video_dev = vdev_init(btv, &bttv_video_template, "video");
+	vdev_init(btv, &btv->video_dev, &bttv_video_template, "video");
 
-	if (NULL == btv->video_dev)
-		goto err;
-	if (video_register_device(btv->video_dev, VFL_TYPE_GRABBER,
+	if (video_register_device(&btv->video_dev, VFL_TYPE_GRABBER,
 				  video_nr[btv->c.nr]) < 0)
 		goto err;
 	pr_info("%d: registered device %s\n",
-		btv->c.nr, video_device_node_name(btv->video_dev));
-	if (device_create_file(&btv->video_dev->dev,
+		btv->c.nr, video_device_node_name(&btv->video_dev));
+	if (device_create_file(&btv->video_dev.dev,
 				     &dev_attr_card)<0) {
 		pr_err("%d: device_create_file 'card' failed\n", btv->c.nr);
 		goto err;
 	}
 
 	/* vbi */
-	btv->vbi_dev = vdev_init(btv, &bttv_video_template, "vbi");
+	vdev_init(btv, &btv->vbi_dev, &bttv_video_template, "vbi");
 
-	if (NULL == btv->vbi_dev)
-		goto err;
-	if (video_register_device(btv->vbi_dev, VFL_TYPE_VBI,
+	if (video_register_device(&btv->vbi_dev, VFL_TYPE_VBI,
 				  vbi_nr[btv->c.nr]) < 0)
 		goto err;
 	pr_info("%d: registered device %s\n",
-		btv->c.nr, video_device_node_name(btv->vbi_dev));
+		btv->c.nr, video_device_node_name(&btv->vbi_dev));
 
 	if (!btv->has_radio)
 		return 0;
 	/* radio */
-	btv->radio_dev = vdev_init(btv, &radio_template, "radio");
-	if (NULL == btv->radio_dev)
-		goto err;
-	btv->radio_dev->ctrl_handler = &btv->radio_ctrl_handler;
-	if (video_register_device(btv->radio_dev, VFL_TYPE_RADIO,
+	vdev_init(btv, &btv->radio_dev, &radio_template, "radio");
+	btv->radio_dev.ctrl_handler = &btv->radio_ctrl_handler;
+	if (video_register_device(&btv->radio_dev, VFL_TYPE_RADIO,
 				  radio_nr[btv->c.nr]) < 0)
 		goto err;
 	pr_info("%d: registered device %s\n",
-		btv->c.nr, video_device_node_name(btv->radio_dev));
+		btv->c.nr, video_device_node_name(&btv->radio_dev));
 
 	/* all done */
 	return 0;
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index bc048c5..a444cfb 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -404,9 +404,9 @@ struct bttv {
 	struct v4l2_subdev	  *sd_tda7432;
 
 	/* video4linux (1) */
-	struct video_device *video_dev;
-	struct video_device *radio_dev;
-	struct video_device *vbi_dev;
+	struct video_device video_dev;
+	struct video_device radio_dev;
+	struct video_device vbi_dev;
 
 	/* controls */
 	struct v4l2_ctrl_handler   ctrl_handler;
-- 
2.1.4

