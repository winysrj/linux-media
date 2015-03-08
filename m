Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43550 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbCHV5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 17:57:32 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: davinci: vpif_display: embed video_device struct in channel_obj
Date: Sun,  8 Mar 2015 21:57:24 +0000
Message-Id: <1425851844-1917-3-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_display.c | 49 +++++----------------------
 drivers/media/platform/davinci/vpif_display.h |  2 +-
 2 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 839c24d..682e5d5 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -829,7 +829,7 @@ static int vpif_set_output(struct vpif_display_config *vpif_cfg,
 	ch->sd = sd;
 	if (chan_cfg->outputs != NULL)
 		/* update tvnorms from the sub device output info */
-		ch->video_dev->tvnorms = chan_cfg->outputs[index].output.std;
+		ch->video_dev.tvnorms = chan_cfg->outputs[index].output.std;
 	return 0;
 }
 
@@ -1204,16 +1204,16 @@ static int vpif_probe_complete(void)
 			 ch, &ch->video_dev);
 
 		/* Initialize the video_device structure */
-		vdev = ch->video_dev;
+		vdev = &ch->video_dev;
 		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
-		vdev->release = video_device_release;
+		vdev->release = video_device_release_empty;
 		vdev->fops = &vpif_fops;
 		vdev->ioctl_ops = &vpif_ioctl_ops;
 		vdev->v4l2_dev = &vpif_obj.v4l2_dev;
 		vdev->vfl_dir = VFL_DIR_TX;
 		vdev->queue = q;
 		vdev->lock = &common->lock;
-		video_set_drvdata(ch->video_dev, ch);
+		video_set_drvdata(&ch->video_dev, ch);
 		err = video_register_device(vdev, VFL_TYPE_GRABBER,
 					    (j ? 3 : 2));
 		if (err < 0)
@@ -1227,9 +1227,7 @@ probe_out:
 		ch = vpif_obj.dev[k];
 		common = &ch->common[k];
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-		video_unregister_device(ch->video_dev);
-		video_device_release(ch->video_dev);
-		ch->video_dev = NULL;
+		video_unregister_device(&ch->video_dev);
 	}
 	return err;
 }
@@ -1246,13 +1244,11 @@ static int vpif_async_complete(struct v4l2_async_notifier *notifier)
 static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	int i, j = 0, err = 0;
-	int res_idx = 0;
 	struct i2c_adapter *i2c_adap;
-	struct channel_obj *ch;
-	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
+	int res_idx = 0;
+	int i, err;
 
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
@@ -1281,25 +1277,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		res_idx++;
 	}
 
-	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
-		/* Get the pointer to the channel object */
-		ch = vpif_obj.dev[i];
-
-		/* Allocate memory for video device */
-		vfd = video_device_alloc();
-		if (vfd == NULL) {
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
 	subdevdata = vpif_obj.config->subdevinfo;
@@ -1308,7 +1285,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-		goto vpif_sd_error;
+		goto vpif_unregister;
 	}
 
 	if (!vpif_obj.config->asd_sizes) {
@@ -1348,12 +1325,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 probe_subdev_out:
 	kfree(vpif_obj.sd);
-vpif_sd_error:
-	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
-		ch = vpif_obj.dev[i];
-		/* Note: does nothing if ch->video_dev == NULL */
-		video_device_release(ch->video_dev);
-	}
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
@@ -1379,9 +1350,7 @@ static int vpif_remove(struct platform_device *device)
 		common = &ch->common[VPIF_VIDEO_INDEX];
 		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
-		video_unregister_device(ch->video_dev);
-
-		ch->video_dev = NULL;
+		video_unregister_device(&ch->video_dev);
 		kfree(vpif_obj.dev[i]);
 	}
 
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 7b21a76..849e0e3 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -100,7 +100,7 @@ struct common_obj {
 
 struct channel_obj {
 	/* V4l2 specific parameters */
-	struct video_device *video_dev;	/* Identifies video device for
+	struct video_device video_dev;	/* Identifies video device for
 					 * this channel */
 	u32 field_id;			/* Indicates id of the field
 					 * which is being displayed */
-- 
2.1.0

