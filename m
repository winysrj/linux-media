Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33668 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbeEGQWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:43 -0400
Received: by mail-wm0-f66.google.com with SMTP id x12-v6so15775975wmc.0
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:42 -0700 (PDT)
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
Subject: [PATCH v3 06/14] media: staging/imx: add imx7 capture subsystem
Date: Mon,  7 May 2018 17:21:44 +0100
Message-Id: <20180507162152.2545-7-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add imx7 capture subsystem to imx-media core to allow the use some of the
existing modules for i.MX5/6 with i.MX7 SoC.

Since i.MX7 does not have an IPU, add driver data with unset ipu_present flag
that change some runtime behaviors.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx-media-dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b019dcefccd6..55fe0321edc0 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -561,8 +561,13 @@ static const struct imx_media_driver_data imx6_drvdata = {
 	.ipu_present = true,
 };
 
+static const struct imx_media_driver_data imx7_drvdata = {
+	.ipu_present = false,
+};
+
 static const struct of_device_id imx_media_dt_ids[] = {
 	{ .compatible = "fsl,imx-capture-subsystem", .data = &imx6_drvdata },
+	{ .compatible = "fsl,imx7-capture-subsystem", .data = &imx7_drvdata },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx_media_dt_ids);
-- 
2.17.0
