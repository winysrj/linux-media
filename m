Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50046 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730802AbeKVGek (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 01:34:40 -0500
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
Subject: [PATCH v10 3/4] arm64: dts: rockchip: add VPU device node for RK3399
Date: Wed, 21 Nov 2018 16:58:46 -0300
Message-Id: <20181121195846.23676-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 99e7f65c1779..040d3080565f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1226,6 +1226,18 @@
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
@@ -1233,8 +1245,8 @@
 		interrupt-names = "vpu_mmu";
 		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
 		clock-names = "aclk", "iface";
+		power-domains = <&power RK3399_PD_VCODEC>;
 		#iommu-cells = <0>;
-		status = "disabled";
 	};
 
 	vdec_mmu: iommu@ff660480 {
-- 
2.19.1
