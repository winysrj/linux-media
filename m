Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36086 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755207AbeDWNsS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:48:18 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18-v6so14226388wrg.3
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 06:48:18 -0700 (PDT)
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
Subject: [PATCH v2 01/15] media: staging/imx: add support to media dev for no IPU systems
Date: Mon, 23 Apr 2018 14:47:36 +0100
Message-Id: <20180423134750.30403-2-rui.silva@linaro.org>
In-Reply-To: <20180423134750.30403-1-rui.silva@linaro.org>
References: <20180423134750.30403-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some i.MX SoC do not have IPU, like the i.MX7, add to the the media device
infrastructure support to be used in this type of systems that do not have
internal subdevices besides the CSI.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-media-dev.c      | 18 +++++++++++++-----
 .../staging/media/imx/imx-media-internal-sd.c  |  3 +++
 drivers/staging/media/imx/imx-media.h          |  3 +++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index f67ec8e27093..c0f277adeebe 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -92,6 +92,9 @@ static int imx_media_get_ipu(struct imx_media_dev *imxmd,
 	struct ipu_soc *ipu;
 	int ipu_id;
 
+	if (!imxmd->ipu_present)
+		return 0;
+
 	ipu = dev_get_drvdata(csi_sd->dev->parent);
 	if (!ipu) {
 		v4l2_err(&imxmd->v4l2_dev,
@@ -481,16 +484,21 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto notifier_cleanup;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "add_internal_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
+	imxmd->ipu_present = true;
+
+	if (imxmd->ipu_present) {
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
