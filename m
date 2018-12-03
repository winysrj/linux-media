Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36759 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbeLCKIW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 05:08:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id u3so11452689wrs.3
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 02:07:59 -0800 (PST)
From: Jagan Teki <jagan@amarulasolutions.com>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH 3/5] media: sun6i: Add vcc-csi supply regulator
Date: Mon,  3 Dec 2018 15:37:45 +0530
Message-Id: <20181203100747.16442-4-jagan@amarulasolutions.com>
In-Reply-To: <20181203100747.16442-1-jagan@amarulasolutions.com>
References: <20181203100747.16442-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the Allwinner A64 CSI controllers are supply with
VCC-PE pin, which may not be turned on by default.

Add support for such boards by adding voltage regulator handling
code to sun6i csi driver.

Used vcc-csi instead of vcc-pe to have better naming convention
wrt other controller pin supplies.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 .../media/platform/sunxi/sun6i-csi/sun6i_csi.c    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 6950585edb5a..5836fa5e6b01 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/sched.h>
 #include <linux/sizes.h>
@@ -36,6 +37,7 @@ struct sun6i_csi_dev {
 	struct clk			*clk_mod;
 	struct clk			*clk_ram;
 	struct reset_control		*rstc_bus;
+	struct regulator		*regulator;
 
 	int				planar_offset[3];
 };
@@ -163,9 +165,16 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 		clk_disable_unprepare(sdev->clk_ram);
 		clk_disable_unprepare(sdev->clk_mod);
 		reset_control_assert(sdev->rstc_bus);
+		regulator_disable(sdev->regulator);
 		return 0;
 	}
 
+	ret = regulator_enable(sdev->regulator);
+	if (ret) {
+		dev_err(sdev->dev, "Enable vcc csi supply err %d\n", ret);
+		return ret;
+	}
+
 	ret = clk_prepare_enable(sdev->clk_mod);
 	if (ret) {
 		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
@@ -809,6 +818,12 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
 	if (IS_ERR(io_base))
 		return PTR_ERR(io_base);
 
+	sdev->regulator = devm_regulator_get(&pdev->dev, "vcc-csi");
+	if (IS_ERR(sdev->regulator)) {
+		dev_err(&pdev->dev, "Unable to acquire csi vcc supply\n");
+		return PTR_ERR(sdev->regulator);
+	}
+
 	sdev->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "bus", io_base,
 						 &sun6i_csi_regmap_config);
 	if (IS_ERR(sdev->regmap)) {
-- 
2.18.0.321.gffc6fa0e3
