Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932673AbbCIQfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH 10/19] sta2x11: embed video_device
Date: Mon,  9 Mar 2015 17:34:04 +0100
Message-Id: <1425918853-12371-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 34 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 22450f5..b8358df 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -127,7 +127,7 @@ static inline struct vip_buffer *to_vip_buffer(struct vb2_buffer *vb2)
  */
 struct sta2x11_vip {
 	struct v4l2_device v4l2_dev;
-	struct video_device *video_dev;
+	struct video_device video_dev;
 	struct pci_dev *pdev;
 	struct i2c_adapter *adapter;
 	unsigned int register_save_area[IRQ_COUNT + SAVE_COUNT + AUX_COUNT];
@@ -763,7 +763,7 @@ static const struct v4l2_ioctl_ops vip_ioctl_ops = {
 
 static struct video_device video_dev_template = {
 	.name = KBUILD_MODNAME,
-	.release = video_device_release,
+	.release = video_device_release_empty,
 	.fops = &vip_fops,
 	.ioctl_ops = &vip_ioctl_ops,
 	.tvnorms = V4L2_STD_ALL,
@@ -1082,19 +1082,13 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 		goto release_buf;
 	}
 
-	/* Alloc, initialize and register video device */
-	vip->video_dev = video_device_alloc();
-	if (!vip->video_dev) {
-		ret = -ENOMEM;
-		goto release_irq;
-	}
+	/* Initialize and register video device */
+	vip->video_dev = video_dev_template;
+	vip->video_dev.v4l2_dev = &vip->v4l2_dev;
+	vip->video_dev.queue = &vip->vb_vidq;
+	video_set_drvdata(&vip->video_dev, vip);
 
-	vip->video_dev = &video_dev_template;
-	vip->video_dev->v4l2_dev = &vip->v4l2_dev;
-	vip->video_dev->queue = &vip->vb_vidq;
-	video_set_drvdata(vip->video_dev, vip);
-
-	ret = video_register_device(vip->video_dev, VFL_TYPE_GRABBER, -1);
+	ret = video_register_device(&vip->video_dev, VFL_TYPE_GRABBER, -1);
 	if (ret)
 		goto vrelease;
 
@@ -1124,12 +1118,9 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 	return 0;
 
 vunreg:
-	video_set_drvdata(vip->video_dev, NULL);
+	video_set_drvdata(&vip->video_dev, NULL);
 vrelease:
-	if (video_is_registered(vip->video_dev))
-		video_unregister_device(vip->video_dev);
-	else
-		video_device_release(vip->video_dev);
+	video_unregister_device(&vip->video_dev);
 release_irq:
 	free_irq(pdev->irq, vip);
 release_buf:
@@ -1175,9 +1166,8 @@ static void sta2x11_vip_remove_one(struct pci_dev *pdev)
 
 	sta2x11_vip_clear_register(vip);
 
-	video_set_drvdata(vip->video_dev, NULL);
-	video_unregister_device(vip->video_dev);
-	/*do not call video_device_release() here, is already done */
+	video_set_drvdata(&vip->video_dev, NULL);
+	video_unregister_device(&vip->video_dev);
 	free_irq(pdev->irq, vip);
 	pci_disable_msi(pdev);
 	vb2_queue_release(&vip->vb_vidq);
-- 
2.1.4

