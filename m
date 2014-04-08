Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58046 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaDHQot (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 12:44:49 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 4.1/6] v4l: vsp1: Add DT bindings documentation
Date: Tue,  8 Apr 2014 18:46:56 +0200
Message-Id: <1396975616-6618-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <4542787.8JEGs6DclK@avalon>
References: <4542787.8JEGs6DclK@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All parameters supplied through platform data can now be passed through
the device tree.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/media/renesas,vsp1.txt     | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,vsp1.txt

Changes since v3:

- Split DT bindings documentation and support in the driver to seperate patches
- Add a more verbose commit message

Changes since v2:

- Remove the interrupt-parent property
- Drop of_match_ptr() as the table is always compiled in

Changes since v1:

- Drop the clock-names property, as the VSP1 uses a single clock

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
new file mode 100644
index 0000000..87fe08a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -0,0 +1,43 @@
+* Renesas VSP1 Video Processing Engine
+
+The VSP1 is a video processing engine that supports up-/down-scaling, alpha
+blending, color space conversion and various other image processing features.
+It can be found in the Renesas R-Car second generation SoCs.
+
+Required properties:
+
+  - compatible: Must contain "renesas,vsp1"
+
+  - reg: Base address and length of the registers block for the VSP1.
+  - interrupts: VSP1 interrupt specifier.
+  - clocks: A phandle + clock-specifier pair for the VSP1 functional clock.
+
+  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP1.
+  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP1.
+  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP1.
+
+
+Optional properties:
+
+  - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
+    available.
+  - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT) module is
+    available.
+  - renesas,has-sru: Boolean, indicates that the Super Resolution Unit (SRU)
+    module is available.
+
+
+Example: R8A7790 (R-Car H2) VSP1-S node
+
+	vsp1@fe928000 {
+		compatible = "renesas,vsp1";
+		reg = <0 0xfe928000 0 0x8000>;
+		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7790_CLK_VSP1_S>;
+
+		renesas,has-lut;
+		renesas,has-sru;
+		renesas,#rpf = <5>;
+		renesas,#uds = <3>;
+		renesas,#wpf = <4>;
+	};
-- 
1.8.3.2

