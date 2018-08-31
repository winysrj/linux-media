Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45436 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbeHaTuH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:50:07 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 2/6] ARM: dts: rockchip: add VPU device node for RK3288
Date: Fri, 31 Aug 2018 12:41:09 -0300
Message-Id: <20180831154113.18872-3-ezequiel@collabora.com>
In-Reply-To: <20180831154113.18872-1-ezequiel@collabora.com>
References: <20180831154113.18872-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the Video Processing Unit node for RK3288 SoC.

Fix the VPU IOMMU node, which was disabled and lacking
its power domain property.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index d7e49d29ace5..093f941ae273 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1209,6 +1209,18 @@
 		};
 	};
 
+	vpu: video-codec@ff9a0000 {
+		compatible = "rockchip,rk3288-vpu";
+		reg = <0x0 0xff9a0000 0x0 0x800>;
+		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "vepu", "vdpu";
+		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
+		clock-names = "aclk", "hclk";
+		power-domains = <&power RK3288_PD_VIDEO>;
+		iommus = <&vpu_mmu>;
+	};
+
 	vpu_mmu: iommu@ff9a0800 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff9a0800 0x0 0x100>;
@@ -1216,8 +1228,8 @@
 		interrupt-names = "vpu_mmu";
 		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
 		clock-names = "aclk", "iface";
+		power-domains = <&power RK3288_PD_VIDEO>;
 		#iommu-cells = <0>;
-		status = "disabled";
 	};
 
 	hevc_mmu: iommu@ff9c0440 {
-- 
2.18.0
