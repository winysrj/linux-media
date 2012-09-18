Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:8274 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2IRKxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:30 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 07/11] vpif_capture: first init subdevs, then register device nodes.
Date: Tue, 18 Sep 2012 12:53:09 +0200
Message-Id: <ee0ac2f8564eb7a713d50279762829a396eb2f35.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When device nodes are registered they must be ready for use
immediately, so make sure the subdevs are loaded first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.c |   55 ++++++++++++----------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index f11b9e3..0d67443 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2122,28 +2122,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
-		ch = vpif_obj.dev[j];
-		ch->channel_id = j;
-		common = &(ch->common[VPIF_VIDEO_INDEX]);
-		spin_lock_init(&common->irqlock);
-		mutex_init(&common->lock);
-		/* Locking in file operations other than ioctl should be done
-		   by the driver, not the V4L2 core.
-		   This driver needs auditing so that this flag can be removed. */
-		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
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
 
@@ -2153,7 +2131,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-		goto probe_out;
+		goto vpif_dev_alloc_err;
 	}
 
 	for (i = 0; i < subdev_count; i++) {
@@ -2170,19 +2148,31 @@ static __init int vpif_probe(struct platform_device *pdev)
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
+		/* Locking in file operations other than ioctl should be done
+		   by the driver, not the V4L2 core.
+		   This driver needs auditing so that this flag can be removed. */
+		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
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
@@ -2190,6 +2180,9 @@ probe_out:
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

