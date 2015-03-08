Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38075 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbCHV5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 17:57:30 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: davinci: vpif_capture: embed video_device struct in channel_obj
Date: Sun,  8 Mar 2015 21:57:23 +0000
Message-Id: <1425851844-1917-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425851844-1917-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425851844-1917-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Embed video_device struct (video_dev) in channel_obj and also the
Unregister path doesn't need to free the video_device structure,
hence, change the video_device.release callback point to
video_device_release_empty.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 52 ++++++---------------------
 drivers/media/platform/davinci/vpif_capture.h |  2 +-
 2 files changed, 11 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fa0a515..a5f5481 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -712,7 +712,7 @@ static int vpif_set_input(
 	ch->vpifparams.iface = chan_cfg->vpif_if;
 
 	/* update tvnorms from the sub device input info */
-	ch->video_dev->tvnorms = chan_cfg->inputs[index].input.std;
+	ch->video_dev.tvnorms = chan_cfg->inputs[index].input.std;
 	return 0;
 }
 
@@ -1337,7 +1337,7 @@ static int vpif_probe_complete(void)
 	struct video_device *vdev;
 	struct channel_obj *ch;
 	struct vb2_queue *q;
-	int i, j, err, k;
+	int j, err, k;
 
 	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
@@ -1384,16 +1384,16 @@ static int vpif_probe_complete(void)
 		INIT_LIST_HEAD(&common->dma_queue);
 
 		/* Initialize the video_device structure */
-		vdev = ch->video_dev;
+		vdev = &ch->video_dev;
 		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
-		vdev->release = video_device_release;
+		vdev->release = video_device_release_empty;
 		vdev->fops = &vpif_fops;
 		vdev->ioctl_ops = &vpif_ioctl_ops;
 		vdev->v4l2_dev = &vpif_obj.v4l2_dev;
 		vdev->vfl_dir = VFL_DIR_RX;
 		vdev->queue = q;
 		vdev->lock = &common->lock;
-		video_set_drvdata(ch->video_dev, ch);
+		video_set_drvdata(&ch->video_dev, ch);
 		err = video_register_device(vdev,
 					    VFL_TYPE_GRABBER, (j ? 1 : 0));
 		if (err)
@@ -1410,14 +1410,9 @@ probe_out:
 		common = &ch->common[k];
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
-		video_unregister_device(ch->video_dev);
+		video_unregister_device(&ch->video_dev);
 	}
 	kfree(vpif_obj.sd);
-	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
-		ch = vpif_obj.dev[i];
-		/* Note: does nothing if ch->video_dev == NULL */
-		video_device_release(ch->video_dev);
-	}
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
 	return err;
@@ -1438,13 +1433,11 @@ static int vpif_async_complete(struct v4l2_async_notifier *notifier)
 static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	int i, j, err;
-	int res_idx = 0;
 	struct i2c_adapter *i2c_adap;
-	struct channel_obj *ch;
-	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
+	int res_idx = 0;
+	int i, err;
 
 	vpif_dev = &pdev->dev;
 
@@ -1472,24 +1465,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		res_idx++;
 	}
 
-	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
-		/* Get the pointer to the channel object */
-		ch = vpif_obj.dev[i];
-		/* Allocate memory for video device */
-		vfd = video_device_alloc();
-		if (NULL == vfd) {
-			for (j = 0; j < i; j++) {
-				ch = vpif_obj.dev[j];
-				video_device_release(ch->video_dev);
-			}
-			err = -ENOMEM;
-			goto vpif_unregister;
-		}
-
-		/* Set video_dev to the video device */
-		ch->video_dev = vfd;
-	}
-
 	vpif_obj.config = pdev->dev.platform_data;
 
 	subdev_count = vpif_obj.config->subdev_count;
@@ -1498,7 +1473,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-		goto vpif_sd_error;
+		goto vpif_unregister;
 	}
 
 	if (!vpif_obj.config->asd_sizes) {
@@ -1541,13 +1516,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 probe_subdev_out:
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
-
-vpif_sd_error:
-	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
-		ch = vpif_obj.dev[i];
-		/* Note: does nothing if ch->video_dev == NULL */
-		video_device_release(ch->video_dev);
-	}
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
@@ -1576,7 +1544,7 @@ static int vpif_remove(struct platform_device *device)
 		common = &ch->common[VPIF_VIDEO_INDEX];
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
-		video_unregister_device(ch->video_dev);
+		video_unregister_device(&ch->video_dev);
 		kfree(vpif_obj.dev[i]);
 	}
 	return 0;
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index f65d28d..8b8a663 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -92,7 +92,7 @@ struct common_obj {
 
 struct channel_obj {
 	/* Identifies video device for this channel */
-	struct video_device *video_dev;
+	struct video_device video_dev;
 	/* Indicates id of the field which is being displayed */
 	u32 field_id;
 	/* flag to indicate whether decoder is initialized */
-- 
2.1.0

