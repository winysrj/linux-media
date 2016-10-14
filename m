Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59211 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757091AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 22/57] [media] davinci: don't break long lines
Date: Fri, 14 Oct 2016 17:20:10 -0300
Message-Id: <4974ed297d393d69122e2409c9697d8ec623e738.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/dm355_ccdc.c   |  3 +--
 drivers/media/platform/davinci/dm644x_ccdc.c  |  3 +--
 drivers/media/platform/davinci/vpbe.c         | 15 +++++----------
 drivers/media/platform/davinci/vpfe_capture.c |  6 ++----
 drivers/media/platform/davinci/vpif_capture.c |  9 ++-------
 drivers/media/platform/davinci/vpif_display.c |  9 ++-------
 drivers/media/platform/davinci/vpss.c         |  6 ++----
 7 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index c90b9a4f0c24..11fa008331dd 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -334,8 +334,7 @@ static int ccdc_set_params(void __user *params)
 
 	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
 	if (x) {
-		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copying ccdc"
-			"params, %d\n", x);
+		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copying ccdcparams, %d\n", x);
 		return -EFAULT;
 	}
 
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 6fba32bec974..a83014da57d5 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -354,8 +354,7 @@ static int ccdc_set_params(void __user *params)
 
 	x = copy_from_user(&ccdc_raw_params, params, sizeof(ccdc_raw_params));
 	if (x) {
-		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copying"
-			   "ccdc params, %d\n", x);
+		dev_dbg(ccdc_cfg.dev, "ccdc_set_params: error in copyingccdc params, %d\n", x);
 		return -EFAULT;
 	}
 
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 9a6c2cc38acb..7d2670732805 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -705,15 +705,13 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					  "v4l2 sub device %s registered\n",
 					  enc_info->module_name);
 			else {
-				v4l2_err(&vpbe_dev->v4l2_dev, "encoder %s"
-					 " failed to register",
+				v4l2_err(&vpbe_dev->v4l2_dev, "encoder %s failed to register",
 					 enc_info->module_name);
 				ret = -ENODEV;
 				goto fail_kfree_encoders;
 			}
 		} else
-			v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c encoders"
-				 " currently not supported");
+			v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c encoders currently not supported");
 	}
 	/* Add amplifier subdevice for dm365 */
 	if ((strcmp(vpbe_dev->cfg->module_name, "dm365-vpbe-display") == 0) &&
@@ -735,8 +733,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					  amp_info->module_name);
 		} else {
 			    vpbe_dev->amp = NULL;
-			    v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c amplifiers"
-			    " currently not supported");
+			    v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c amplifiers currently not supported");
 		}
 	} else {
 	    vpbe_dev->amp = NULL;
@@ -835,15 +832,13 @@ static int vpbe_probe(struct platform_device *pdev)
 	if (!cfg->module_name[0] ||
 	    !cfg->osd.module_name[0] ||
 	    !cfg->venc.module_name[0]) {
-		v4l2_err(pdev->dev.driver, "vpbe display module names not"
-			 " defined\n");
+		v4l2_err(pdev->dev.driver, "vpbe display module names not defined\n");
 		return ret;
 	}
 
 	vpbe_dev = kzalloc(sizeof(*vpbe_dev), GFP_KERNEL);
 	if (vpbe_dev == NULL) {
-		v4l2_err(pdev->dev.driver, "Unable to allocate memory"
-			 " for vpbe_device\n");
+		v4l2_err(pdev->dev.driver, "Unable to allocate memory for vpbe_device\n");
 		return -ENOMEM;
 	}
 	vpbe_dev->cfg = cfg;
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 6efb2f1631c4..ca22c3493f55 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -919,8 +919,7 @@ static const struct vpfe_pixel_format *
 	else
 		pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
 
-	v4l2_info(&vpfe_dev->v4l2_dev, "adjusted width = %d, height ="
-		 " %d, bpp = %d, bytesperline = %d, sizeimage = %d\n",
+	v4l2_info(&vpfe_dev->v4l2_dev, "adjusted width = %d, height = %d, bpp = %d, bytesperline = %d, sizeimage = %d\n",
 		 pixfmt->width, pixfmt->height, vpfe_pix_fmt->bpp,
 		 pixfmt->bytesperline, pixfmt->sizeimage);
 	return vpfe_pix_fmt;
@@ -1088,8 +1087,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
 					&subdev,
 					&index,
 					inp->index) < 0) {
-		v4l2_err(&vpfe_dev->v4l2_dev, "input information not found"
-			 " for the subdev\n");
+		v4l2_err(&vpfe_dev->v4l2_dev, "input information not found for the subdev\n");
 		return -EINVAL;
 	}
 	sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5104cc0ee40e..c6a3a904afc8 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1152,11 +1152,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 				timings->bt.vfrontporch &&
 				(timings->bt.vbackporch ||
 				 timings->bt.vsync))) {
-		vpif_dbg(2, debug, "Timings for width, height, "
-				"horizontal back porch, horizontal sync, "
-				"horizontal front porch, vertical back porch, "
-				"vertical sync and vertical back porch "
-				"must be defined\n");
+		vpif_dbg(2, debug, "Timings for width, height, horizontal back porch, horizontal sync, horizontal front porch, vertical back porch, vertical sync and vertical back porch must be defined\n");
 		return -EINVAL;
 	}
 
@@ -1181,8 +1177,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 			std_info->l11 = std_info->vsize -
 				(bt->il_vfrontporch - 1);
 		} else {
-			vpif_dbg(2, debug, "Required timing values for "
-					"interlaced BT format missing\n");
+			vpif_dbg(2, debug, "Required timing values for interlaced BT format missing\n");
 			return -EINVAL;
 		}
 	} else {
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 75b27233ec2f..6b3ea1e8e97f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -954,11 +954,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 				timings->bt.vfrontporch &&
 				(timings->bt.vbackporch ||
 				 timings->bt.vsync))) {
-		vpif_dbg(2, debug, "Timings for width, height, "
-				"horizontal back porch, horizontal sync, "
-				"horizontal front porch, vertical back porch, "
-				"vertical sync and vertical back porch "
-				"must be defined\n");
+		vpif_dbg(2, debug, "Timings for width, height, horizontal back porch, horizontal sync, horizontal front porch, vertical back porch, vertical sync and vertical back porch must be defined\n");
 		return -EINVAL;
 	}
 
@@ -983,8 +979,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 			std_info->l11 = std_info->vsize -
 				(bt->il_vfrontporch - 1);
 		} else {
-			vpif_dbg(2, debug, "Required timing values for "
-					"interlaced BT format missing\n");
+			vpif_dbg(2, debug, "Required timing values for interlaced BT format missing\n");
 			return -EINVAL;
 		}
 	} else {
diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index fce86f17dffc..f277c7ee86bf 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -261,8 +261,7 @@ static int dm355_enable_clock(enum vpss_clock_sel clock_sel, int en)
 		shift = 6;
 		break;
 	default:
-		printk(KERN_ERR "dm355_enable_clock:"
-				" Invalid selector: %d\n", clock_sel);
+		printk(KERN_ERR "dm355_enable_clock: Invalid selector: %d\n", clock_sel);
 		return -EINVAL;
 	}
 
@@ -421,8 +420,7 @@ static int vpss_probe(struct platform_device *pdev)
 	else if (!strcmp(platform_name, "dm644x_vpss"))
 		oper_cfg.platform = DM644X;
 	else {
-		dev_err(&pdev->dev, "vpss driver not supported on"
-			" this platform\n");
+		dev_err(&pdev->dev, "vpss driver not supported on this platform\n");
 		return -ENODEV;
 	}
 
-- 
2.7.4


