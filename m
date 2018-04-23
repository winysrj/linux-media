Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43315 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755390AbeDWNsq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:48:46 -0400
Received: by mail-wr0-f195.google.com with SMTP id v15-v6so23387992wrm.10
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 06:48:45 -0700 (PDT)
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
Subject: [PATCH v2 06/15] media: staging/imx: add imx7 capture subsystem
Date: Mon, 23 Apr 2018 14:47:41 +0100
Message-Id: <20180423134750.30403-7-rui.silva@linaro.org>
In-Reply-To: <20180423134750.30403-1-rui.silva@linaro.org>
References: <20180423134750.30403-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add imx7 capture subsystem to imx-media core to allow the use some of the
existing modules for i.MX5/6 with i.MX7 SoC.

Since i.MX7 does not have an IPU unset the ipu_present flag to differentiate
some runtime behaviors.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-media-dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index c0f277adeebe..be68235c4caa 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -486,6 +486,9 @@ static int imx_media_probe(struct platform_device *pdev)
 
 	imxmd->ipu_present = true;
 
+	if (of_device_is_compatible(node, "fsl,imx7-capture-subsystem"))
+		imxmd->ipu_present = false;
+
 	if (imxmd->ipu_present) {
 		ret = imx_media_add_internal_subdevs(imxmd);
 		if (ret) {
@@ -543,6 +546,7 @@ static int imx_media_remove(struct platform_device *pdev)
 
 static const struct of_device_id imx_media_dt_ids[] = {
 	{ .compatible = "fsl,imx-capture-subsystem" },
+	{ .compatible = "fsl,imx7-capture-subsystem" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx_media_dt_ids);
-- 
2.17.0
