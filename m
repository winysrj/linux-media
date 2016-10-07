Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51666 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938757AbcJGQB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 15/22] ARM: dts: imx6qdl: Add MIPI CSI-2 D-PHY compatible and clocks
Date: Fri,  7 Oct 2016 18:01:00 +0200
Message-Id: <20161007160107.5074-16-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From the data sheets it is not quite clear what the clock inputs should
be named, but freescale code calls them "dphy_clk" (would that be per?)
and "pixel_clk" and connects them to the mipi_core_cfg and emi_podf
clocks, respectively.  The mipi_core_cfg control is called hsi_tx
currently, but it really gates a whole lot of other clocks, too.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index cd325bd..2be6de4 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1123,9 +1123,16 @@
 			};
 
 			mipi_csi: mipi@021dc000 {
+				compatible = "fsl,imx6q-mipi-csi2", "dw-mipi-csi2";
 				reg = <0x021dc000 0x4000>;
+				clocks = <&clks IMX6QDL_CLK_HSI_TX>,	/* mipi_core_cfg/ipg_clk_root */
+					 <&clks IMX6QDL_CLK_HSI_TX>,	/* mipi_core_cfg/video_27m_clk_root */
+					 <&clks IMX6QDL_CLK_HSI_TX>,	/* mipi_core_cfg/video_27m_clk_root */
+					 <&clks IMX6QDL_CLK_EIM_PODF>;	/* shoid be ipu1_ipu_hsp_clk_root on S/DL, axi_clk_root on D/Q */
+				clock-names = "pclk", "cfg", "ref", "pixel";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				status = "disabled";
 			};
 
 			mipi_dsi: mipi@021e0000 {
-- 
2.9.3

