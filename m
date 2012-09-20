Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2464 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2ITMHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/14] vpif_capture: first init subdevs, then register device nodes.
Date: Thu, 20 Sep 2012 14:06:26 +0200
Message-Id: <ae44074a4e31ff3f584835b072208718ed7608c4.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When device nodes are registered they must be ready for use
immediately, so make sure the subdevs are loaded first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   47 +++++++++++--------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index e40eacd1..98423b5 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2139,24 +2139,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
-		ch->channel_id = j;
-		common = &(ch->common[VPIF_VIDEO_INDEX]);
-		spin_lock_init(&common->irqlock);
-		mutex_init(&common->lock);
-		ch->video_dev->lock = &common->lock;
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
-		err = video_register_device(ch->video_dev,
-					    VFL_TYPE_GRABBER, (j ? 1 : 0));
-		if (err)
-			goto probe_out;
-
-		video_set_drvdata(ch->video_dev, ch);
-
-	}
-
 	i2c_adap = i2c_get_adapter(1);
 	config = pdev->dev.platform_data;
 
@@ -2166,7 +2148,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-		goto probe_out;
+		goto vpif_dev_alloc_err;
 	}
 
 	for (i = 0; i < subdev_count; i++) {
@@ -2183,19 +2165,27 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 		v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",
 			  subdevdata->name);
-
-		if (vpif_obj.sd[i])
-			vpif_obj.sd[i]->grp_id = 1 << i;
 	}
 
+	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
+		ch = vpif_obj.dev[j];
+		ch->channel_id = j;
+		common = &(ch->common[VPIF_VIDEO_INDEX]);
+		spin_lock_init(&common->irqlock);
+		mutex_init(&common->lock);
+		ch->video_dev->lock = &common->lock;
+		/* Initialize prio member of channel object */
+		v4l2_prio_init(&ch->prio);
+		video_set_drvdata(ch->video_dev, ch);
+
+		err = video_register_device(ch->video_dev,
+					    VFL_TYPE_GRABBER, (j ? 1 : 0));
+		if (err)
+			goto probe_out;
+	}
 	v4l2_info(&vpif_obj.v4l2_dev, "VPIF capture driver initialized\n");
 	return 0;
 
-probe_subdev_out:
-	/* free sub devices memory */
-	kfree(vpif_obj.sd);
-
-	j = VPIF_CAPTURE_MAX_DEVICES;
 probe_out:
 	for (k = 0; k < j; k++) {
 		/* Get the pointer to the channel object */
@@ -2203,6 +2193,9 @@ probe_out:
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 	}
+probe_subdev_out:
+	/* free sub devices memory */
+	kfree(vpif_obj.sd);
 
 vpif_dev_alloc_err:
 	k = VPIF_CAPTURE_MAX_DEVICES-1;
-- 
1.7.10.4

