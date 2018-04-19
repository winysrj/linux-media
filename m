Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39650 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbeDSKSk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 06:18:40 -0400
Received: by mail-wr0-f194.google.com with SMTP id q3-v6so2486231wrj.6
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2018 03:18:40 -0700 (PDT)
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
Subject: [PATCH 04/15] clk: imx7d: reset parent for mipi csi root
Date: Thu, 19 Apr 2018 11:18:01 +0100
Message-Id: <20180419101812.30688-5-rui.silva@linaro.org>
In-Reply-To: <20180419101812.30688-1-rui.silva@linaro.org>
References: <20180419101812.30688-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To guarantee that we do not get Overflow in image FIFO the outer bandwidth has
to be faster than inputer bandwidth. For that it must be possible to set a
faster frequency clock. So set new parent to sys_pfd3 clock for the mipi csi
block.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/clk/imx/clk-imx7d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/imx/clk-imx7d.c b/drivers/clk/imx/clk-imx7d.c
index f7f4db2e6fa6..9a1a18ceb132 100644
--- a/drivers/clk/imx/clk-imx7d.c
+++ b/drivers/clk/imx/clk-imx7d.c
@@ -891,6 +891,9 @@ static void __init imx7d_clocks_init(struct device_node *ccm_node)
 	clk_set_parent(clks[IMX7D_PLL_AUDIO_MAIN_BYPASS], clks[IMX7D_PLL_AUDIO_MAIN]);
 	clk_set_parent(clks[IMX7D_PLL_VIDEO_MAIN_BYPASS], clks[IMX7D_PLL_VIDEO_MAIN]);
 
+	clk_set_parent(clks[IMX7D_MIPI_CSI_ROOT_SRC],
+		       clks[IMX7D_PLL_SYS_PFD3_CLK]);
+
 	/* use old gpt clk setting, gpt1 root clk must be twice as gpt counter freq */
 	clk_set_parent(clks[IMX7D_GPT1_ROOT_SRC], clks[IMX7D_OSC_24M_CLK]);
 
-- 
2.17.0
