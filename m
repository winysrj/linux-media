Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46392 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753470AbdKOHb5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 02:31:57 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, heiko@sntech.de,
        mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com, zhengsq@rock-chips.com,
        zyc@rock-chips.com, eddie.cai.linux@gmail.com,
        jeffy.chen@rock-chips.com, allon.huang@rock-chips.com,
        p.zabel@pengutronix.de, slongerbeam@gmail.com,
        linux@armlinux.org.uk, Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [RFC PATCH 5/5] ARM: dts: rockchip: add isp node for rk3288
Date: Wed, 15 Nov 2017 15:31:32 +0800
Message-Id: <20171115073132.30123-5-jacob-chen@iotwrt.com>
In-Reply-To: <20171115073132.30123-1-jacob-chen@iotwrt.com>
References: <20171115073132.30123-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

rk3288 have a Embedded 13M ISP and MIPI-CSI2 interface.

Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 60658c5c9a48..f9a81137146d 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -962,6 +962,30 @@
 		status = "disabled";
 	};
 
+	isp: isp@ff910000 {
+		compatible = "rockchip,rk3288-cif-isp";
+		reg = <0x0 0xff910000 0x0 0x4000>;
+		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_ISP>, <&cru ACLK_ISP>,
+			 <&cru HCLK_ISP>, <&cru PCLK_ISP_IN>,
+			 <&cru SCLK_ISP_JPE>;
+		clock-names = "clk_isp", "aclk_isp",
+			      "hclk_isp", "pclk_isp_in",
+			      "sclk_isp_jpe";
+		assigned-clocks = <&cru SCLK_ISP>;
+		assigned-clock-rates = <400000000>;
+		power-domains = <&power RK3288_PD_VIO>;
+		iommus = <&isp_mmu>;
+		status = "disabled";
+		isp_mipi_phy_rx0: isp-mipi-phy-rx0 {
+			compatible = "rockchip,rk3288-mipi-dphy";
+			rockchip,grf = <&grf>;
+			clocks = <&cru SCLK_MIPIDSI_24M>, <&cru PCLK_MIPI_CSI>;
+			clock-names = "dphy-ref", "pclk";
+			status = "disabled";
+		};
+	};
+
 	isp_mmu: iommu@ff914000 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff914000 0x0 0x100>, <0x0 0xff915000 0x0 0x100>;
-- 
2.14.2
