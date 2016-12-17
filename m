Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:35665 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932942AbcLQAr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 19:47:57 -0500
Received: by mail-pg0-f42.google.com with SMTP id p66so37603155pga.2
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2016 16:47:56 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6.1 1/5] [media] davinci: VPIF: fix module loading, init errors
Date: Fri, 16 Dec 2016 16:47:54 -0800
Message-Id: <20161217004754.10241-1-khilman@baylibre.com>
In-Reply-To: <20161207183025.20684-2-khilman@baylibre.com>
References: <20161207183025.20684-2-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix problems with automatic module loading by adding MODULE_ALIAS.  Also
fix various load-time errors cause by incorrect or not present
platform_data.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
Minor tweaks since v6
- added ack from Sakari
- droped an extraneous change for NULL subdev_info

 drivers/media/platform/davinci/vpif.c         |  5 ++++-
 drivers/media/platform/davinci/vpif_capture.c | 13 +++++++++++++
 drivers/media/platform/davinci/vpif_display.c |  6 ++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 0380cf2e5775..f50148dcba64 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -32,6 +32,9 @@
 MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
 MODULE_LICENSE("GPL");
 
+#define VPIF_DRIVER_NAME	"vpif"
+MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
+
 #define VPIF_CH0_MAX_MODES	22
 #define VPIF_CH1_MAX_MODES	2
 #define VPIF_CH2_MAX_MODES	15
@@ -466,7 +469,7 @@ static const struct dev_pm_ops vpif_pm = {
 
 static struct platform_driver vpif_driver = {
 	.driver = {
-		.name	= "vpif",
+		.name	= VPIF_DRIVER_NAME,
 		.pm	= vpif_pm_ops,
 	},
 	.remove = vpif_remove,
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5104cc0ee40e..892a26f3c5b4 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -45,6 +45,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 
 #define VPIF_DRIVER_NAME	"vpif_capture"
+MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
 
 /* global variables */
 static struct vpif_device vpif_obj = { {NULL} };
@@ -647,6 +648,10 @@ static int vpif_input_to_subdev(
 
 	vpif_dbg(2, debug, "vpif_input_to_subdev\n");
 
+	if (!chan_cfg)
+		return -1;
+	if (input_index >= chan_cfg->input_count)
+		return -1;
 	subdev_name = chan_cfg->inputs[input_index].subdev_name;
 	if (subdev_name == NULL)
 		return -1;
@@ -685,6 +690,9 @@ static int vpif_set_input(
 	if (sd_index >= 0) {
 		sd = vpif_obj.sd[sd_index];
 		subdev_info = &vpif_cfg->subdev_info[sd_index];
+	} else {
+		/* no subdevice, no input to setup */
+		return 0;
 	}
 
 	/* first setup input path from sub device to vpif */
@@ -1435,6 +1443,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	vpif_dev = &pdev->dev;
 
 	err = initialize_vpif();
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 75b27233ec2f..7f632b757d32 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -42,6 +42,7 @@ module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 
 #define VPIF_DRIVER_NAME	"vpif_display"
+MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
 
 /* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
 static int ycmux_mode;
@@ -1249,6 +1250,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
 
-- 
2.9.3

