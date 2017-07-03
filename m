Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44621 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdGCMka (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 08:40:30 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/2] dt-bindings: media: Add Cadence MIPI-CSI2RX Device Tree bindings
Date: Mon,  3 Jul 2017 14:40:22 +0200
Message-Id: <20170703124023.28352-2-maxime.ripard@free-electrons.com>
In-Reply-To: <20170703124023.28352-1-maxime.ripard@free-electrons.com>
References: <20170703124023.28352-1-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up to
4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
the hardware implementation.

It can operate with an external D-PHY, an internal one or no D-PHY at all
in some configurations.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/media/cdns-csi2rx.txt      | 87 ++++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt

diff --git a/Documentation/devicetree/bindings/media/cdns-csi2rx.txt b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
new file mode 100644
index 000000000000..b5bcb6ad18fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
@@ -0,0 +1,87 @@
+Cadence CSI2RX controller
+=========================
+
+The Cadence CSI2RX controller is a CSI-2 bridge supporting up to 4 CSI
+lanes in input, and 4 different pixel streams in output.
+
+Required properties:
+  - compatible: must be set to "cdns,csi2rx"
+  - reg: base address and size of the memory mapped region
+  - clocks: phandles to the clocks driving the controller
+  - clock-names: must contain:
+    * sys_clk: main clock
+    * p_clk: register bank clock
+    * p_free_clk: free running register bank clock
+    * pixel_ifX_clk: pixel stream output clock, one for each stream
+                     implemented in hardware, between 0 and 3
+    * dphy_rx_clk: D-PHY byte clock, if implemented in hardware
+  - phys: phandle to the external D-PHY
+  - phy-names: must contain dphy, if the implementation uses an
+               external D-PHY
+
+Required subnodes:
+  - ports: A ports node with endpoint definitions as defined in
+           Documentation/devicetree/bindings/media/video-interfaces.txt. The
+           first port subnode should be the input endpoint, the second one the
+           outputs
+
+  The output port should have as many endpoints as stream supported by
+  the hardware implementation, between 1 and 4, their ID being the
+  stream output number used in the implementation.
+
+Example:
+
+csi2rx: csi-bridge@0d060000 {
+	compatible = "cdns,csi2rx";
+	reg = <0x0d060000 0x1000>;
+	clocks = <&byteclock>, <&byteclock>, <&byteclock>,
+		 <&coreclock>, <&coreclock>,
+		 <&coreclock>, <&coreclock>;
+	clock-names = "sys_clk", "p_clk", "p_free_clk",
+		      "pixel_if0_clk", "pixel_if1_clk",
+		      "pixel_if2_clk", "pixel_if3_clk";
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			csi2rx_in_sensor: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&sensor_out_csi2rx>;
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+			};
+		};
+
+		port@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+
+			csi2rx_out_grabber0: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&grabber0_in_csi2rx>;
+			};
+
+			csi2rx_out_grabber1: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&grabber1_in_csi2rx>;
+			};
+
+			csi2rx_out_grabber2: endpoint@2 {
+				reg = <2>;
+				remote-endpoint = <&grabber2_in_csi2rx>;
+			};
+
+			csi2rx_out_grabber3: endpoint@3 {
+				reg = <3>;
+				remote-endpoint = <&grabber3_in_csi2rx>;
+			};
+		};
+	};
+};
-- 
2.13.0
