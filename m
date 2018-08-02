Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49960 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbeHBVxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 17:53:05 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 1/6] dt-bindings: Document the Rockchip VPU bindings
Date: Thu,  2 Aug 2018 17:00:05 -0300
Message-Id: <20180802200010.24365-2-ezequiel@collabora.com>
In-Reply-To: <20180802200010.24365-1-ezequiel@collabora.com>
References: <20180802200010.24365-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add devicetree binding documentation for Rockchip Video Processing
Unit IP.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../bindings/media/rockchip-vpu.txt           | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt

diff --git a/Documentation/devicetree/bindings/media/rockchip-vpu.txt b/Documentation/devicetree/bindings/media/rockchip-vpu.txt
new file mode 100644
index 000000000000..5e0d421301ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rockchip-vpu.txt
@@ -0,0 +1,30 @@
+device-tree bindings for rockchip VPU codec
+
+Rockchip (Video Processing Unit) present in various Rockchip platforms,
+such as RK3288 and RK3399.
+
+Required properties:
+- compatible: value should be one of the following
+		"rockchip,rk3288-vpu";
+		"rockchip,rk3399-vpu";
+- interrupts: encoding and decoding interrupt specifiers
+- interrupt-names: should be "vepu" and "vdpu"
+- clocks: phandle to VPU aclk, hclk clocks
+- clock-names: should be "aclk" and "hclk"
+- power-domains: phandle to power domain node
+- iommus: phandle to a iommu node
+
+Example:
+SoC-specific DT entry:
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
-- 
2.18.0
