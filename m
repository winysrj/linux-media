Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491AbZHFXFf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:05:35 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v0 3/5] V4L: vpif display - updates to support vpif capture on DM6467
Date: Thu,  6 Aug 2009 19:05:30 -0400
Message-Id: <1249599930-21767-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

The structure name for vpif display driver changed since it was not unique. So this
update is done to reflect the same. Also removed the code related to register
address space iomap. Uses v4l2_i2c_new_subdev_board() instead of
v4l2_i2c_new_probed_subdev() so that platform data can be added for subdevice
configuration for polarities.

NOTE: This is only for review. Final patch for merge will be
sent later. This patch is dependent on the patch from Chaithrika for vpif display.

Mandatory reviewers : Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/vpif_display.c |   52 +++++++--------------------
 1 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 8ea65d7..ccc38b3 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -683,7 +683,7 @@ static int vpif_release(struct file *filep)
 static int vpif_querycap(struct file *file, void  *priv,
 				struct v4l2_capability *cap)
 {
-	struct vpif_config *config = vpif_dev->platform_data;
+	struct vpif_display_config *config = vpif_dev->platform_data;
 
 	cap->version = VPIF_DISPLAY_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
@@ -1053,7 +1053,7 @@ static int vpif_streamon(struct file *file, void *priv,
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
 	struct vpif_params *vpif = &ch->vpifparams;
-	struct vpif_config *vpif_config_data =
+	struct vpif_display_config *vpif_config_data =
 					vpif_dev->platform_data;
 	unsigned long addr = 0;
 	int ret = 0;
@@ -1239,7 +1239,7 @@ static int vpif_enum_output(struct file *file, void *fh,
 				struct v4l2_output *output)
 {
 
-	struct vpif_config *config = vpif_dev->platform_data;
+	struct vpif_display_config *config = vpif_dev->platform_data;
 
 	if (output->index >= config->output_count) {
 		vpif_dbg(1, debug, "Invalid output index\n");
@@ -1422,10 +1422,10 @@ vpif_init_free_channel_objects:
  */
 static __init int vpif_probe(struct platform_device *pdev)
 {
-	const struct vpif_subdev_info *subdevdata;
+	struct vpif_subdev_info *subdevdata;
 	int i, j = 0, k, q, m, err = 0;
 	struct i2c_adapter *i2c_adap;
-	struct vpif_config *config;
+	struct vpif_display_config *config;
 	struct common_obj *common;
 	struct channel_obj *ch;
 	struct video_device *vfd;
@@ -1433,30 +1433,14 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int subdev_count;
 
 	vpif_dev = &pdev->dev;
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		v4l2_err(vpif_dev->driver,
-				"Error getting platform resource\n");
-		return -ENOENT;
-	}
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
-						vpif_dev->driver->name)) {
-		v4l2_err(vpif_dev->driver, "VPIF: failed request_mem_region\n");
-		return -ENXIO;
-	}
+	err = initialize_vpif();
 
-	vpif_base = ioremap_nocache(res->start, res->end - res->start + 1);
-	if (!vpif_base) {
-		v4l2_err(vpif_dev->driver, "Unable to ioremap VPIF reg\n");
-		err = -ENXIO;
-		goto resource_exit;
+	if (err) {
+		v4l2_err(vpif_dev->driver, "Error initializing vpif\n");
+		return err;
 	}
 
-	vpif_base_addr_init(vpif_base);
-
-	initialize_vpif();
-
 	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
 	if (err) {
 		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
@@ -1489,7 +1473,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto video_dev_alloc_exit;
+			goto vpif_int_err;
 		}
 
 		/* Initialize field of video device */
@@ -1566,10 +1550,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < subdev_count; i++) {
-		vpif_obj.sd[i] = v4l2_i2c_new_probed_subdev(&vpif_obj.v4l2_dev,
+		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
 						i2c_adap, subdevdata[i].name,
-						subdevdata[i].name,
-						&subdevdata[i].addr);
+						&subdevdata[i].board_info,
+						NULL);
+
 		if (!vpif_obj.sd[i]) {
 			vpif_err("Error registering v4l2 subdevice\n");
 			goto probe_subdev_out;
@@ -1599,12 +1584,6 @@ vpif_int_err:
 		res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
 		m = res->end;
 	}
-video_dev_alloc_exit:
-	iounmap(vpif_base);
-resource_exit:
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
-
 	return err;
 }
 
@@ -1666,9 +1645,6 @@ static void vpif_cleanup(void)
 		i++;
 	}
 
-	iounmap(vpif_base);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
 	platform_driver_unregister(&vpif_driver);
 	kfree(vpif_obj.sd);
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)
-- 
1.6.0.4

