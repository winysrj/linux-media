Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37695 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbCIWLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 18:11:11 -0400
Received: by widem10 with SMTP id em10so10659782wid.2
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 15:11:10 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: sh_vou: embed video_device
Date: Mon,  9 Mar 2015 22:10:51 +0000
Message-Id: <1425939052-6375-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425939052-6375-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425939052-6375-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/sh_vou.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 6d1959d..dde1ccc 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -62,7 +62,7 @@ enum sh_vou_status {
 
 struct sh_vou_device {
 	struct v4l2_device v4l2_dev;
-	struct video_device *vdev;
+	struct video_device vdev;
 	atomic_t use_count;
 	struct sh_vou_pdata *pdata;
 	spinlock_t lock;
@@ -890,7 +890,7 @@ static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): 0x%llx\n", __func__, std_id);
 
-	if (std_id & ~vou_dev->vdev->tvnorms)
+	if (std_id & ~vou_dev->vdev.tvnorms)
 		return -EINVAL;
 
 	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
@@ -1193,7 +1193,7 @@ static int sh_vou_open(struct file *file)
 				       V4L2_BUF_TYPE_VIDEO_OUTPUT,
 				       V4L2_FIELD_NONE,
 				       sizeof(struct videobuf_buffer),
-				       vou_dev->vdev, &vou_dev->fop_lock);
+				       &vou_dev->vdev, &vou_dev->fop_lock);
 	mutex_unlock(&vou_dev->fop_lock);
 
 	file->private_data = vou_file;
@@ -1361,21 +1361,14 @@ static int sh_vou_probe(struct platform_device *pdev)
 		goto ev4l2devreg;
 	}
 
-	/* Allocate memory for video device */
-	vdev = video_device_alloc();
-	if (vdev == NULL) {
-		ret = -ENOMEM;
-		goto evdevalloc;
-	}
-
+	vdev = &vou_dev->vdev;
 	*vdev = sh_vou_video_template;
 	if (vou_pdata->bus_fmt == SH_VOU_BUS_8BIT)
 		vdev->tvnorms |= V4L2_STD_PAL;
 	vdev->v4l2_dev = &vou_dev->v4l2_dev;
-	vdev->release = video_device_release;
+	vdev->release = video_device_release_empty;
 	vdev->lock = &vou_dev->fop_lock;
 
-	vou_dev->vdev = vdev;
 	video_set_drvdata(vdev, vou_dev);
 
 	pm_runtime_enable(&pdev->dev);
@@ -1409,9 +1402,7 @@ ei2cnd:
 ereset:
 	i2c_put_adapter(i2c_adap);
 ei2cgadap:
-	video_device_release(vdev);
 	pm_runtime_disable(&pdev->dev);
-evdevalloc:
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 ev4l2devreg:
 	free_irq(irq, vou_dev);
@@ -1438,7 +1429,7 @@ static int sh_vou_remove(struct platform_device *pdev)
 	if (irq > 0)
 		free_irq(irq, vou_dev);
 	pm_runtime_disable(&pdev->dev);
-	video_unregister_device(vou_dev->vdev);
+	video_unregister_device(&vou_dev->vdev);
 	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	iounmap(vou_dev->base);
-- 
2.1.0

