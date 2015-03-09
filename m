Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbbCIQfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/19] meye: embed video_device
Date: Mon,  9 Mar 2015 17:34:01 +0100
Message-Id: <1425918853-12371-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/meye/meye.c | 19 ++++++-------------
 drivers/media/pci/meye/meye.h |  2 +-
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 9d9f90c..3b5297d 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1546,7 +1546,7 @@ static struct video_device meye_template = {
 	.name		= "meye",
 	.fops		= &meye_fops,
 	.ioctl_ops 	= &meye_ioctl_ops,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 };
 
 static const struct v4l2_ctrl_ops meye_ctrl_ops = {
@@ -1633,11 +1633,6 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	}
 	ret = -ENOMEM;
 	meye.mchip_dev = pcidev;
-	meye.vdev = video_device_alloc();
-	if (!meye.vdev) {
-		v4l2_err(v4l2_dev, "video_device_alloc() failed!\n");
-		goto outnotdev;
-	}
 
 	meye.grab_temp = vmalloc(MCHIP_NB_PAGES_MJPEG * PAGE_SIZE);
 	if (!meye.grab_temp) {
@@ -1658,8 +1653,8 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 		goto outkfifoalloc2;
 	}
 
-	memcpy(meye.vdev, &meye_template, sizeof(meye_template));
-	meye.vdev->v4l2_dev = &meye.v4l2_dev;
+	meye.vdev = meye_template;
+	meye.vdev.v4l2_dev = &meye.v4l2_dev;
 
 	ret = -EIO;
 	if ((ret = sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 1))) {
@@ -1743,9 +1738,9 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	}
 
 	v4l2_ctrl_handler_setup(&meye.hdl);
-	meye.vdev->ctrl_handler = &meye.hdl;
+	meye.vdev.ctrl_handler = &meye.hdl;
 
-	if (video_register_device(meye.vdev, VFL_TYPE_GRABBER,
+	if (video_register_device(&meye.vdev, VFL_TYPE_GRABBER,
 				  video_nr) < 0) {
 		v4l2_err(v4l2_dev, "video_register_device failed\n");
 		goto outvideoreg;
@@ -1777,14 +1772,12 @@ outkfifoalloc2:
 outkfifoalloc1:
 	vfree(meye.grab_temp);
 outvmalloc:
-	video_device_release(meye.vdev);
-outnotdev:
 	return ret;
 }
 
 static void meye_remove(struct pci_dev *pcidev)
 {
-	video_unregister_device(meye.vdev);
+	video_unregister_device(&meye.vdev);
 
 	mchip_hic_stop();
 
diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
index 6fed927..751be5e 100644
--- a/drivers/media/pci/meye/meye.h
+++ b/drivers/media/pci/meye/meye.h
@@ -311,7 +311,7 @@ struct meye {
 	struct kfifo doneq;		/* queue for grabbed buffers */
 	spinlock_t doneq_lock;		/* lock protecting the queue */
 	wait_queue_head_t proc_list;	/* wait queue */
-	struct video_device *vdev;	/* video device parameters */
+	struct video_device vdev;	/* video device parameters */
 	u16 brightness;
 	u16 hue;
 	u16 contrast;
-- 
2.1.4

