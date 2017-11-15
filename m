Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45159 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdKOHby (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 02:31:54 -0500
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
Subject: [RFC PATCH 4/5] arm64: dts: rockchip: add isp0 node for rk3399
Date: Wed, 15 Nov 2017 15:31:31 +0800
Message-Id: <20171115073132.30123-4-jacob-chen@iotwrt.com>
In-Reply-To: <20171115073132.30123-1-jacob-chen@iotwrt.com>
References: <20171115073132.30123-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

rk3399 have two ISP, but we havn't test isp1, so just add isp0 at present.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index ab7629c5b856..f696e62d09dd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1577,6 +1577,32 @@
 		status = "disabled";
 	};
 
+	isp0: isp0@ff910000 {
+		compatible = "rockchip,rk3399-cif-isp";
+		reg = <0x0 0xff910000 0x0 0x4000>;
+		interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&cru SCLK_ISP0>,
+			 <&cru ACLK_ISP0>, <&cru ACLK_ISP0_WRAPPER>,
+			 <&cru HCLK_ISP0>, <&cru HCLK_ISP0_WRAPPER>;
+		clock-names = "clk_isp",
+			      "aclk_isp", "aclk_isp_wrap",
+			      "hclk_isp", "hclk_isp_wrap";
+		power-domains = <&power RK3399_PD_ISP0>;
+		iommus = <&isp0_mmu>;
+		status = "disabled";
+
+		isp_mipi_dphy_rx0: isp-mipi-dphy-rx0 {
+			compatible = "rockchip,rk3399-mipi-dphy";
+			rockchip,grf = <&grf>;
+			clocks = <&cru SCLK_MIPIDPHY_REF>,
+				 <&cru SCLK_DPHY_RX0_CFG>,
+				 <&cru PCLK_VIO_GRF>;
+			clock-names = "dphy-ref", "dphy-cfg", "grf";
+			power-domains = <&power RK3399_PD_VIO>;
+			status = "disabled";
+		};
+	};
+
 	isp0_mmu: iommu@ff914000 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff914000 0x0 0x100>, <0x0 0xff915000 0x0 0x100>;
-- 
2.14.2
