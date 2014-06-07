Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47526 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaFGV5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:05 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so3830525pdi.30
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:05 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 05/43] imx-drm: ipu-v3: Map IOMUXC registers
Date: Sat,  7 Jun 2014 14:56:07 -0700
Message-Id: <1402178205-22697-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Map the IOMUXC registers, which will be needed by ipu-csi for mux
control.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |    8 ++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |    4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 2d95a7c..635dafe 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -1196,6 +1196,14 @@ static int ipu_probe(struct platform_device *pdev)
 	if (!ipu->cm_reg || !ipu->idmac_reg || !ipu->cpmem_base)
 		return -ENOMEM;
 
+	ipu->gp_reg = syscon_regmap_lookup_by_compatible(
+		"fsl,imx6q-iomuxc-gpr");
+	if (IS_ERR(ipu->gp_reg)) {
+		ret = PTR_ERR(ipu->gp_reg);
+		dev_err(&pdev->dev, "failed to map iomuxc regs with %d\n", ret);
+		return ret;
+	}
+
 	ipu->clk = devm_clk_get(&pdev->dev, "bus");
 	if (IS_ERR(ipu->clk)) {
 		ret = PTR_ERR(ipu->clk);
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 9e4cf4b..90c0c50 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -21,6 +21,9 @@ struct ipu_soc;
 #include <linux/device.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 
 #include <linux/platform_data/imx-ipu-v3.h>
 
@@ -163,6 +166,7 @@ struct ipu_soc {
 	void __iomem		*cm_reg;
 	void __iomem		*idmac_reg;
 	struct ipu_ch_param __iomem	*cpmem_base;
+	struct regmap		*gp_reg;
 
 	int			id;
 	int			usecount;
-- 
1.7.9.5

