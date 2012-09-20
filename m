Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4009 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2ITMHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/14] vpif_display: first init subdevs, then register device nodes.
Date: Thu, 20 Sep 2012 14:06:27 +0200
Message-Id: <048bd3c0dc9ee3c7a26e9ef840cddeeff8cb83b6.1348142407.git.hans.verkuil@cisco.com>
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
 drivers/media/platform/davinci/vpif_display.c |   59 ++++++++++++-------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index f394599..e71c88f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1689,6 +1689,32 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_adap = i2c_get_adapter(1);
+	config = pdev->dev.platform_data;
+	subdev_count = config->subdev_count;
+	subdevdata = config->subdevinfo;
+	vpif_obj.sd = kzalloc(sizeof(struct v4l2_subdev *) * subdev_count,
+								GFP_KERNEL);
+	if (vpif_obj.sd == NULL) {
+		vpif_err("unable to allocate memory for subdevice pointers\n");
+		err = -ENOMEM;
+		goto vpif_int_err;
+	}
+
+	for (i = 0; i < subdev_count; i++) {
+		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
+						i2c_adap,
+						&subdevdata[i].board_info,
+						NULL);
+		if (!vpif_obj.sd[i]) {
+			vpif_err("Error registering v4l2 subdevice\n");
+			goto probe_subdev_out;
+		}
+
+		if (vpif_obj.sd[i])
+			vpif_obj.sd[i]->grp_id = 1 << i;
+	}
+
 	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
 		/* Initialize field of the channel objects */
@@ -1724,6 +1750,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
 		ch->video_dev->lock = &common->lock;
+		video_set_drvdata(ch->video_dev, ch);
 
 		/* register video device */
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
@@ -1733,42 +1760,12 @@ static __init int vpif_probe(struct platform_device *pdev)
 					  VFL_TYPE_GRABBER, (j ? 3 : 2));
 		if (err < 0)
 			goto probe_out;
-
-		video_set_drvdata(ch->video_dev, ch);
-	}
-
-	i2c_adap = i2c_get_adapter(1);
-	config = pdev->dev.platform_data;
-	subdev_count = config->subdev_count;
-	subdevdata = config->subdevinfo;
-	vpif_obj.sd = kzalloc(sizeof(struct v4l2_subdev *) * subdev_count,
-								GFP_KERNEL);
-	if (vpif_obj.sd == NULL) {
-		vpif_err("unable to allocate memory for subdevice pointers\n");
-		err = -ENOMEM;
-		goto probe_out;
-	}
-
-	for (i = 0; i < subdev_count; i++) {
-		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						i2c_adap,
-						&subdevdata[i].board_info,
-						NULL);
-		if (!vpif_obj.sd[i]) {
-			vpif_err("Error registering v4l2 subdevice\n");
-			goto probe_subdev_out;
-		}
-
-		if (vpif_obj.sd[i])
-			vpif_obj.sd[i]->grp_id = 1 << i;
 	}
 
 	v4l2_info(&vpif_obj.v4l2_dev,
 			" VPIF display driver initialized\n");
 	return 0;
 
-probe_subdev_out:
-	kfree(vpif_obj.sd);
 probe_out:
 	for (k = 0; k < j; k++) {
 		ch = vpif_obj.dev[k];
@@ -1776,6 +1773,8 @@ probe_out:
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
 	}
+probe_subdev_out:
+	kfree(vpif_obj.sd);
 vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 	vpif_err("VPIF IRQ request failed\n");
-- 
1.7.10.4

