Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39035 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbdKXCiH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 21:38:07 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [PATCH v2 07/11] ARM: dts: rockchip: add isp node for rk3288
Date: Fri, 24 Nov 2017 10:37:02 +0800
Message-Id: <20171124023706.5702-8-jacob-chen@iotwrt.com>
In-Reply-To: <20171124023706.5702-1-jacob-chen@iotwrt.com>
References: <20171124023706.5702-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

rk3288 have a Embedded 13M ISP

Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index f3e7f98c2724..30677a0167fe 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -962,6 +962,23 @@
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
+	};
+
 	isp_mmu: iommu@ff914000 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff914000 0x0 0x100>, <0x0 0xff915000 0x0 0x100>;
-- 
2.15.0
