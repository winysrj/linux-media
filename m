Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38577 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeEGQWe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:34 -0400
Received: by mail-wm0-f67.google.com with SMTP id m198-v6so15661704wmg.3
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:34 -0700 (PDT)
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
        Rui Miguel Silva <rui.silva@linaro.org>,
        linux-clk@vger.kernel.org
Subject: [PATCH v3 03/14] clk: imx7d: fix mipi dphy div parent
Date: Mon,  7 May 2018 17:21:41 +0100
Message-Id: <20180507162152.2545-4-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the mipi dphy root divider to mipi_dphy_pre_div, this would remove a orphan
clock and set the correct parent.

before:
cat clk_orphan_summary
                                 enable  prepare  protect
   clock                          count    count    count        rate   accuracy   phase
----------------------------------------------------------------------------------------
 mipi_dphy_post_div                   1        1        0           0          0 0
    mipi_dphy_root_clk                1        1        0           0          0 0

cat clk_dump | grep mipi_dphy
mipi_dphy_post_div                    1        1        0           0          0 0
    mipi_dphy_root_clk                1        1        0           0          0 0

after:
cat clk_dump | grep mipi_dphy
   mipi_dphy_src                     1        1        0    24000000          0 0
       mipi_dphy_cg                  1        1        0    24000000          0 0
          mipi_dphy_pre_div          1        1        0    24000000          0 0
             mipi_dphy_post_div      1        1        0    24000000          0 0
                mipi_dphy_root_clk   1        1        0    24000000          0 0

Fixes: 8f6d8094b215 ("ARM: imx: add imx7d clk tree support")

Cc: linux-clk@vger.kernel.org
Acked-by: Dong Aisheng <Aisheng.dong@nxp.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>

---
 drivers/clk/imx/clk-imx7d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx7d.c b/drivers/clk/imx/clk-imx7d.c
index 975a20d3cc94..f7f4db2e6fa6 100644
--- a/drivers/clk/imx/clk-imx7d.c
+++ b/drivers/clk/imx/clk-imx7d.c
@@ -729,7 +729,7 @@ static void __init imx7d_clocks_init(struct device_node *ccm_node)
 	clks[IMX7D_LCDIF_PIXEL_ROOT_DIV] = imx_clk_divider2("lcdif_pixel_post_div", "lcdif_pixel_pre_div", base + 0xa300, 0, 6);
 	clks[IMX7D_MIPI_DSI_ROOT_DIV] = imx_clk_divider2("mipi_dsi_post_div", "mipi_dsi_pre_div", base + 0xa380, 0, 6);
 	clks[IMX7D_MIPI_CSI_ROOT_DIV] = imx_clk_divider2("mipi_csi_post_div", "mipi_csi_pre_div", base + 0xa400, 0, 6);
-	clks[IMX7D_MIPI_DPHY_ROOT_DIV] = imx_clk_divider2("mipi_dphy_post_div", "mipi_csi_dphy_div", base + 0xa480, 0, 6);
+	clks[IMX7D_MIPI_DPHY_ROOT_DIV] = imx_clk_divider2("mipi_dphy_post_div", "mipi_dphy_pre_div", base + 0xa480, 0, 6);
 	clks[IMX7D_SAI1_ROOT_DIV] = imx_clk_divider2("sai1_post_div", "sai1_pre_div", base + 0xa500, 0, 6);
 	clks[IMX7D_SAI2_ROOT_DIV] = imx_clk_divider2("sai2_post_div", "sai2_pre_div", base + 0xa580, 0, 6);
 	clks[IMX7D_SAI3_ROOT_DIV] = imx_clk_divider2("sai3_post_div", "sai3_pre_div", base + 0xa600, 0, 6);
-- 
2.17.0
