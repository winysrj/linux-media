Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:60497 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab2IRKxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:31 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 08/11] vpif_display: first init subdevs, then register device nodes.
Date: Tue, 18 Sep 2012 12:53:10 +0200
Message-Id: <369565a83366f83712f1e547b59f36b007674ca9.1347965140.git.hans.verkuil@cisco.com>
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
 drivers/media/video/davinci/vpif_display.c |   59 ++++++++++++++--------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 19338b4..a6e8ddd 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1674,6 +1674,32 @@ static __init int vpif_probe(struct platform_device *pdev)
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
@@ -1713,6 +1739,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		   This driver needs auditing so that this flag can be removed. */
 		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
 		ch->video_dev->lock = &common->lock;
+		video_set_drvdata(ch->video_dev, ch);
 
 		/* register video device */
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
@@ -1722,42 +1749,12 @@ static __init int vpif_probe(struct platform_device *pdev)
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
@@ -1765,6 +1762,8 @@ probe_out:
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

