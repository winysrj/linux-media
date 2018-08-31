Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45468 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbeHaTuP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:50:15 -0400
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
Subject: [PATCH v4 3/6] arm64: dts: rockchip: add VPU device node for RK3399
Date: Fri, 31 Aug 2018 12:41:10 -0300
Message-Id: <20180831154113.18872-4-ezequiel@collabora.com>
In-Reply-To: <20180831154113.18872-1-ezequiel@collabora.com>
References: <20180831154113.18872-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the Video Processing Unit node for the RK3399 SoC.

Also, fix the VPU IOMMU node, which was disabled and lacking
its power domain property.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 6ba438427515..5dd840b3deb1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1231,6 +1231,18 @@
 		status = "disabled";
 	};
 
+	vpu: video-codec@ff650000 {
+		compatible = "rockchip,rk3399-vpu";
+		reg = <0x0 0xff650000 0x0 0x800>;
+		interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH 0>,
+			     <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH 0>;
+		interrupt-names = "vepu", "vdpu";
+		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
+		clock-names = "aclk", "hclk";
+		power-domains = <&power RK3399_PD_VCODEC>;
+		iommus = <&vpu_mmu>;
+	};
+
 	vpu_mmu: iommu@ff650800 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff650800 0x0 0x40>;
@@ -1238,8 +1250,8 @@
 		interrupt-names = "vpu_mmu";
 		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
 		clock-names = "aclk", "iface";
+		power-domains = <&power RK3399_PD_VCODEC>;
 		#iommu-cells = <0>;
-		status = "disabled";
 	};
 
 	vdec_mmu: iommu@ff660480 {
-- 
2.18.0
