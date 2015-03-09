Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639AbbCIQfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/19] cx88: embed video_device
Date: Mon,  9 Mar 2015 17:34:00 +0100
Message-Id: <1425918853-12371-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 22 +++++-------
 drivers/media/pci/cx88/cx88-core.c      | 18 ++++------
 drivers/media/pci/cx88/cx88-video.c     | 61 ++++++++++++---------------------
 drivers/media/pci/cx88/cx88.h           | 17 ++++-----
 4 files changed, 46 insertions(+), 72 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index b6be46e..24216ef 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1102,32 +1102,26 @@ static int cx8802_blackbird_advise_release(struct cx8802_driver *drv)
 
 static void blackbird_unregister_video(struct cx8802_dev *dev)
 {
-	if (dev->mpeg_dev) {
-		if (video_is_registered(dev->mpeg_dev))
-			video_unregister_device(dev->mpeg_dev);
-		else
-			video_device_release(dev->mpeg_dev);
-		dev->mpeg_dev = NULL;
-	}
+	video_unregister_device(&dev->mpeg_dev);
 }
 
 static int blackbird_register_video(struct cx8802_dev *dev)
 {
 	int err;
 
-	dev->mpeg_dev = cx88_vdev_init(dev->core, dev->pci,
-				       &cx8802_mpeg_template, "mpeg");
-	dev->mpeg_dev->ctrl_handler = &dev->cxhdl.hdl;
-	video_set_drvdata(dev->mpeg_dev, dev);
-	dev->mpeg_dev->queue = &dev->vb2_mpegq;
-	err = video_register_device(dev->mpeg_dev, VFL_TYPE_GRABBER, -1);
+	cx88_vdev_init(dev->core, dev->pci, &dev->mpeg_dev,
+		       &cx8802_mpeg_template, "mpeg");
+	dev->mpeg_dev.ctrl_handler = &dev->cxhdl.hdl;
+	video_set_drvdata(&dev->mpeg_dev, dev);
+	dev->mpeg_dev.queue = &dev->vb2_mpegq;
+	err = video_register_device(&dev->mpeg_dev, VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
 		printk(KERN_INFO "%s/2: can't register mpeg device\n",
 		       dev->core->name);
 		return err;
 	}
 	printk(KERN_INFO "%s/2: registered device %s [mpeg]\n",
-	       dev->core->name, video_device_node_name(dev->mpeg_dev));
+	       dev->core->name, video_device_node_name(&dev->mpeg_dev));
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index c38d5a1..3501be9 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -985,17 +985,14 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 
 /* ------------------------------------------------------------------ */
 
-struct video_device *cx88_vdev_init(struct cx88_core *core,
-				    struct pci_dev *pci,
-				    const struct video_device *template_,
-				    const char *type)
+void cx88_vdev_init(struct cx88_core *core,
+		    struct pci_dev *pci,
+		    struct video_device *vfd,
+		    const struct video_device *template_,
+		    const char *type)
 {
-	struct video_device *vfd;
-
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
 	*vfd = *template_;
+
 	/*
 	 * The dev pointer of v4l2_device is NULL, instead we set the
 	 * video_device dev_parent pointer to the correct PCI bus device.
@@ -1004,11 +1001,10 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 	 */
 	vfd->v4l2_dev = &core->v4l2_dev;
 	vfd->dev_parent = &pci->dev;
-	vfd->release = video_device_release;
+	vfd->release = video_device_release_empty;
 	vfd->lock = &core->lock;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
-	return vfd;
 }
 
 struct cx88_core* cx88_core_get(struct pci_dev *pci)
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 860c98fc..c9decd8 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1274,27 +1274,9 @@ static const struct v4l2_ctrl_ops cx8800_ctrl_aud_ops = {
 
 static void cx8800_unregister_video(struct cx8800_dev *dev)
 {
-	if (dev->radio_dev) {
-		if (video_is_registered(dev->radio_dev))
-			video_unregister_device(dev->radio_dev);
-		else
-			video_device_release(dev->radio_dev);
-		dev->radio_dev = NULL;
-	}
-	if (dev->vbi_dev) {
-		if (video_is_registered(dev->vbi_dev))
-			video_unregister_device(dev->vbi_dev);
-		else
-			video_device_release(dev->vbi_dev);
-		dev->vbi_dev = NULL;
-	}
-	if (dev->video_dev) {
-		if (video_is_registered(dev->video_dev))
-			video_unregister_device(dev->video_dev);
-		else
-			video_device_release(dev->video_dev);
-		dev->video_dev = NULL;
-	}
+	video_unregister_device(&dev->radio_dev);
+	video_unregister_device(&dev->vbi_dev);
+	video_unregister_device(&dev->video_dev);
 }
 
 static int cx8800_initdev(struct pci_dev *pci_dev,
@@ -1485,12 +1467,12 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		goto fail_unreg;
 
 	/* register v4l devices */
-	dev->video_dev = cx88_vdev_init(core,dev->pci,
-					&cx8800_video_template,"video");
-	video_set_drvdata(dev->video_dev, dev);
-	dev->video_dev->ctrl_handler = &core->video_hdl;
-	dev->video_dev->queue = &dev->vb2_vidq;
-	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
+	cx88_vdev_init(core, dev->pci, &dev->video_dev,
+		       &cx8800_video_template, "video");
+	video_set_drvdata(&dev->video_dev, dev);
+	dev->video_dev.ctrl_handler = &core->video_hdl;
+	dev->video_dev.queue = &dev->vb2_vidq;
+	err = video_register_device(&dev->video_dev, VFL_TYPE_GRABBER,
 				    video_nr[core->nr]);
 	if (err < 0) {
 		printk(KERN_ERR "%s/0: can't register video device\n",
@@ -1498,12 +1480,13 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		goto fail_unreg;
 	}
 	printk(KERN_INFO "%s/0: registered device %s [v4l2]\n",
-	       core->name, video_device_node_name(dev->video_dev));
+	       core->name, video_device_node_name(&dev->video_dev));
 
-	dev->vbi_dev = cx88_vdev_init(core,dev->pci,&cx8800_vbi_template,"vbi");
-	video_set_drvdata(dev->vbi_dev, dev);
-	dev->vbi_dev->queue = &dev->vb2_vbiq;
-	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
+	cx88_vdev_init(core, dev->pci, &dev->vbi_dev,
+		       &cx8800_vbi_template, "vbi");
+	video_set_drvdata(&dev->vbi_dev, dev);
+	dev->vbi_dev.queue = &dev->vb2_vbiq;
+	err = video_register_device(&dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[core->nr]);
 	if (err < 0) {
 		printk(KERN_ERR "%s/0: can't register vbi device\n",
@@ -1511,14 +1494,14 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		goto fail_unreg;
 	}
 	printk(KERN_INFO "%s/0: registered device %s\n",
-	       core->name, video_device_node_name(dev->vbi_dev));
+	       core->name, video_device_node_name(&dev->vbi_dev));
 
 	if (core->board.radio.type == CX88_RADIO) {
-		dev->radio_dev = cx88_vdev_init(core,dev->pci,
-						&cx8800_radio_template,"radio");
-		video_set_drvdata(dev->radio_dev, dev);
-		dev->radio_dev->ctrl_handler = &core->audio_hdl;
-		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
+		cx88_vdev_init(core, dev->pci, &dev->radio_dev,
+			       &cx8800_radio_template, "radio");
+		video_set_drvdata(&dev->radio_dev, dev);
+		dev->radio_dev.ctrl_handler = &core->audio_hdl;
+		err = video_register_device(&dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[core->nr]);
 		if (err < 0) {
 			printk(KERN_ERR "%s/0: can't register radio device\n",
@@ -1526,7 +1509,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 			goto fail_unreg;
 		}
 		printk(KERN_INFO "%s/0: registered device %s\n",
-		       core->name, video_device_node_name(dev->radio_dev));
+		       core->name, video_device_node_name(&dev->radio_dev));
 	}
 
 	/* start tvaudio thread */
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 7748ca9..b9fe1ac 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -478,9 +478,9 @@ struct cx8800_dev {
 
 	/* various device info */
 	unsigned int               resources;
-	struct video_device        *video_dev;
-	struct video_device        *vbi_dev;
-	struct video_device        *radio_dev;
+	struct video_device        video_dev;
+	struct video_device        vbi_dev;
+	struct video_device        radio_dev;
 
 	/* pci i/o */
 	struct pci_dev             *pci;
@@ -563,7 +563,7 @@ struct cx8802_dev {
 	/* for blackbird only */
 	struct list_head           devlist;
 #if IS_ENABLED(CONFIG_VIDEO_CX88_BLACKBIRD)
-	struct video_device        *mpeg_dev;
+	struct video_device        mpeg_dev;
 	u32                        mailbox;
 
 	/* mpeg params */
@@ -647,10 +647,11 @@ extern int cx88_set_scale(struct cx88_core *core, unsigned int width,
 			  unsigned int height, enum v4l2_field field);
 extern int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm);
 
-extern struct video_device *cx88_vdev_init(struct cx88_core *core,
-					   struct pci_dev *pci,
-					   const struct video_device *template_,
-					   const char *type);
+extern void cx88_vdev_init(struct cx88_core *core,
+			   struct pci_dev *pci,
+			   struct video_device *vfd,
+			   const struct video_device *template_,
+			   const char *type);
 extern struct cx88_core *cx88_core_get(struct pci_dev *pci);
 extern void cx88_core_put(struct cx88_core *core,
 			  struct pci_dev *pci);
-- 
2.1.4

