Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34810 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdGaDI5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 23:08:57 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yakir Yang <ykk@rock-chips.com>
Subject: [PATCH v3 5/5] dt-bindings: Document the Rockchip RGA bindings
Date: Mon, 31 Jul 2017 11:07:40 +0800
Message-Id: <1501470460-12014-6-git-send-email-jacob-chen@iotwrt.com>
In-Reply-To: <1501470460-12014-1-git-send-email-jacob-chen@iotwrt.com>
References: <1501470460-12014-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT bindings documentation for Rockchip RGA

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---
 .../devicetree/bindings/media/rockchip-rga.txt     | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt

diff --git a/Documentation/devicetree/bindings/media/rockchip-rga.txt b/Documentation/devicetree/bindings/media/rockchip-rga.txt
new file mode 100644
index 0000000..fd5276a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rockchip-rga.txt
@@ -0,0 +1,33 @@
+device-tree bindings for rockchip 2D raster graphic acceleration controller (RGA)
+
+RGA is a standalone 2D raster graphic acceleration unit. It accelerates 2D
+graphics operations, such as point/line drawing, image scaling, rotation,
+BitBLT, alpha blending and image blur/sharpness.
+
+Required properties:
+- compatible: value should be one of the following
+		"rockchip,rk3288-rga";
+		"rockchip,rk3399-rga";
+
+- interrupts: RGA interrupt specifier.
+
+- clocks: phandle to RGA sclk/hclk/aclk clocks
+
+- clock-names: should be "aclk", "hclk" and "sclk"
+
+- resets: Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names: should be "core", "axi" and "ahb"
+
+Example:
+SoC-specific DT entry:
+	rga: rga@ff680000 {
+		compatible = "rockchip,rk3399-rga";
+		reg = <0xff680000 0x10000>;
+		interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_RGA>, <&cru HCLK_RGA>, <&cru SCLK_RGA_CORE>;
+		clock-names = "aclk", "hclk", "sclk";
+
+		resets = <&cru SRST_RGA_CORE>, <&cru SRST_A_RGA>, <&cru SRST_H_RGA>;
+		reset-names = "core, "axi", "ahb";
+	};
-- 
2.7.4
