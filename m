Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:36186 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbCHOlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:23 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 17/17] media: blackfin: bfin_capture: embed video_device struct in bcap_device
Date: Sun,  8 Mar 2015 14:40:53 +0000
Message-Id: <1425825653-14768-18-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Embed video_device struct (video_dev) in bcap_device and
Unregister path doesn't need to free the video_device
structure, hence, change the video_device.release callback
point to video_device_release_empty.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 27 ++++++++------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index d390f7c..6a437f8 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -64,7 +64,7 @@ struct bcap_device {
 	/* v4l2 control handler */
 	struct v4l2_ctrl_handler ctrl_handler;
 	/* device node data */
-	struct video_device *video_dev;
+	struct video_device video_dev;
 	/* sub device instance */
 	struct v4l2_subdev *sd;
 	/* capture config */
@@ -809,27 +809,20 @@ static int bcap_probe(struct platform_device *pdev)
 		goto err_free_ppi;
 	}
 
-	vfd = video_device_alloc();
-	if (!vfd) {
-		ret = -ENOMEM;
-		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
-		goto err_cleanup_ctx;
-	}
-
+	vfd = &bcap_dev->video_dev;
 	/* initialize field of video device */
-	vfd->release            = video_device_release;
+	vfd->release            = video_device_release_empty;
 	vfd->fops               = &bcap_fops;
 	vfd->ioctl_ops          = &bcap_ioctl_ops;
 	vfd->tvnorms            = 0;
 	vfd->v4l2_dev           = &bcap_dev->v4l2_dev;
 	strncpy(vfd->name, CAPTURE_DRV_NAME, sizeof(vfd->name));
-	bcap_dev->video_dev     = vfd;
 
 	ret = v4l2_device_register(&pdev->dev, &bcap_dev->v4l2_dev);
 	if (ret) {
 		v4l2_err(pdev->dev.driver,
 				"Unable to register v4l2 device\n");
-		goto err_release_vdev;
+		goto err_cleanup_ctx;
 	}
 	v4l2_info(&bcap_dev->v4l2_dev, "v4l2 device registered\n");
 
@@ -868,13 +861,13 @@ static int bcap_probe(struct platform_device *pdev)
 	vfd->queue = q;
 
 	/* register video device */
-	ret = video_register_device(bcap_dev->video_dev, VFL_TYPE_GRABBER, -1);
+	ret = video_register_device(&bcap_dev->video_dev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"Unable to register video device\n");
 		goto err_free_handler;
 	}
-	video_set_drvdata(bcap_dev->video_dev, bcap_dev);
+	video_set_drvdata(&bcap_dev->video_dev, bcap_dev);
 	v4l2_info(&bcap_dev->v4l2_dev, "video device registered as: %s\n",
 			video_device_node_name(vfd));
 
@@ -952,15 +945,11 @@ static int bcap_probe(struct platform_device *pdev)
 	}
 	return 0;
 err_unreg_vdev:
-	video_unregister_device(bcap_dev->video_dev);
-	bcap_dev->video_dev = NULL;
+	video_unregister_device(&bcap_dev->video_dev);
 err_free_handler:
 	v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
 err_unreg_v4l2:
 	v4l2_device_unregister(&bcap_dev->v4l2_dev);
-err_release_vdev:
-	if (bcap_dev->video_dev)
-		video_device_release(bcap_dev->video_dev);
 err_cleanup_ctx:
 	vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
 err_free_ppi:
@@ -977,7 +966,7 @@ static int bcap_remove(struct platform_device *pdev)
 						struct bcap_device, v4l2_dev);
 
 	bcap_free_sensor_formats(bcap_dev);
-	video_unregister_device(bcap_dev->video_dev);
+	video_unregister_device(&bcap_dev->video_dev);
 	v4l2_ctrl_handler_free(&bcap_dev->ctrl_handler);
 	v4l2_device_unregister(v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(bcap_dev->alloc_ctx);
-- 
2.1.0

