Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38532 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbeDSKSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 06:18:31 -0400
Received: by mail-wr0-f195.google.com with SMTP id h3-v6so12527217wrh.5
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2018 03:18:31 -0700 (PDT)
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
Subject: [PATCH 01/15] media: staging/imx: add support to media dev for no IPU systems
Date: Thu, 19 Apr 2018 11:17:58 +0100
Message-Id: <20180419101812.30688-2-rui.silva@linaro.org>
In-Reply-To: <20180419101812.30688-1-rui.silva@linaro.org>
References: <20180419101812.30688-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some i.MX SoC do not have IPU, like the i.MX7, add to the the media device
infrastructure support to be used in this type of systems that do not have
internal subdevices besides the CSI.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-media-dev.c        | 16 +++++++++++-----
 .../staging/media/imx/imx-media-internal-sd.c    |  3 +++
 drivers/staging/media/imx/imx-media.h            |  3 +++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index f67ec8e27093..a8afe0ec4134 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -92,6 +92,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
 	struct ipu_soc *ipu;
 	int ipu_id;
 
+	if (imxmd->no_ipu_present)
+		return 0;
+
 	ipu = dev_get_drvdata(csi_sd->dev->parent);
 	if (!ipu) {
 		v4l2_err(&imxmd->v4l2_dev,
@@ -481,16 +484,19 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto notifier_cleanup;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "add_internal_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
+	if (!imxmd->no_ipu_present) {
+		ret = imx_media_add_internal_subdevs(imxmd);
+		if (ret) {
+			v4l2_err(&imxmd->v4l2_dev,
+				 "add_internal_subdevs failed with %d\n", ret);
+			goto notifier_cleanup;
+		}
 	}
 
 	/* no subdevs? just bail */
 	if (imxmd->notifier.num_subdevs == 0) {
 		ret = -ENODEV;
+		v4l2_err(&imxmd->v4l2_dev, "no subdevs\n");
 		goto notifier_cleanup;
 	}
 
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 0fdc45dbfb76..4a246813b4e1 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -238,6 +238,9 @@ int imx_media_create_internal_links(struct imx_media_dev *imxmd,
 	struct media_pad *pad;
 	int i, j, ret;
 
+	if (imxmd->no_ipu_present)
+		return 0;
+
 	intsd = find_intsd_by_grp_id(sd->grp_id);
 	if (!intsd)
 		return -ENODEV;
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 44532cd5b812..0c63132861a0 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -147,6 +147,9 @@ struct imx_media_dev {
 
 	/* for async subdev registration */
 	struct v4l2_async_notifier notifier;
+
+	/* indicator to if the system lack IPU */
+	bool no_ipu_present;
 };
 
 enum codespace_sel {
-- 
2.17.0
