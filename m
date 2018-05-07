Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35856 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbeEGQW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:27 -0400
Received: by mail-wm0-f65.google.com with SMTP id n10-v6so16407684wmc.1
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:27 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v3 01/14] media: staging/imx: add support to media dev for no IPU systems
Date: Mon,  7 May 2018 17:21:39 +0100
Message-Id: <20180507162152.2545-2-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some i.MX SoC do not have IPU, like the i.MX7, add to the the media device
infrastructure support to be used in this type of systems that do not have
internal subdevices besides the CSI.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-media-dev.c     | 38 ++++++++++++++++---
 .../staging/media/imx/imx-media-internal-sd.c |  3 ++
 drivers/staging/media/imx/imx-media.h         |  3 ++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index f67ec8e27093..b019dcefccd6 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -27,6 +27,12 @@
 #include <media/imx.h>
 #include "imx-media.h"
 
+static const struct of_device_id imx_media_dt_ids[];
+
+struct imx_media_driver_data {
+	bool ipu_present;
+};
+
 static inline struct imx_media_dev *notifier2dev(struct v4l2_async_notifier *n)
 {
 	return container_of(n, struct imx_media_dev, notifier);
@@ -92,6 +98,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
 	struct ipu_soc *ipu;
 	int ipu_id;
 
+	if (!imxmd->ipu_present)
+		return 0;
+
 	ipu = dev_get_drvdata(csi_sd->dev->parent);
 	if (!ipu) {
 		v4l2_err(&imxmd->v4l2_dev,
@@ -440,6 +449,8 @@ static const struct media_device_ops imx_media_md_ops = {
 
 static int imx_media_probe(struct platform_device *pdev)
 {
+	const struct imx_media_driver_data *drvdata;
+	const struct of_device_id *of_id;
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
 	struct imx_media_dev *imxmd;
@@ -481,16 +492,29 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto notifier_cleanup;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "add_internal_subdevs failed with %d\n", ret);
+	of_id = of_match_device(imx_media_dt_ids, &pdev->dev);
+	if (!of_id) {
+		v4l2_err(&imxmd->v4l2_dev, "failed to find driver data\n");
 		goto notifier_cleanup;
 	}
 
+	drvdata = of_id->data;
+
+	imxmd->ipu_present = drvdata->ipu_present;
+
+	if (imxmd->ipu_present) {
+		ret = imx_media_add_internal_subdevs(imxmd);
+		if (ret) {
+			v4l2_err(&imxmd->v4l2_dev,
+				 "add_internal_subdevs failed with %d\n", ret);
+			goto notifier_cleanup;
+		}
+	}
+
 	/* no subdevs? just bail */
 	if (imxmd->notifier.num_subdevs == 0) {
 		ret = -ENODEV;
+		v4l2_err(&imxmd->v4l2_dev, "no subdevs\n");
 		goto notifier_cleanup;
 	}
 
@@ -533,8 +557,12 @@ static int imx_media_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct imx_media_driver_data imx6_drvdata = {
+	.ipu_present = true,
+};
+
 static const struct of_device_id imx_media_dt_ids[] = {
-	{ .compatible = "fsl,imx-capture-subsystem" },
+	{ .compatible = "fsl,imx-capture-subsystem", .data = &imx6_drvdata },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx_media_dt_ids);
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 0fdc45dbfb76..2bcdc232369a 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -238,6 +238,9 @@ int imx_media_create_internal_links(struct imx_media_dev *imxmd,
 	struct media_pad *pad;
 	int i, j, ret;
 
+	if (!imxmd->ipu_present)
+		return 0;
+
 	intsd = find_intsd_by_grp_id(sd->grp_id);
 	if (!intsd)
 		return -ENODEV;
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 44532cd5b812..d40538ecf176 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -147,6 +147,9 @@ struct imx_media_dev {
 
 	/* for async subdev registration */
 	struct v4l2_async_notifier notifier;
+
+	/* indicator to if the system has IPU */
+	bool ipu_present;
 };
 
 enum codespace_sel {
-- 
2.17.0
