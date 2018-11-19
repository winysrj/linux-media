Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36808 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbeKTBxV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:53:21 -0500
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
Subject: [PATCH v8 2/3] arm64: dts: rockchip: add VPU device node for RK3399
Date: Mon, 19 Nov 2018 12:29:01 -0300
Message-Id: <20181119152902.31429-3-ezequiel@collabora.com>
In-Reply-To: <20181119152902.31429-1-ezequiel@collabora.com>
References: <20181119152902.31429-1-ezequiel@collabora.com>
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
