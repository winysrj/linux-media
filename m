Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42588 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753579AbdIDNDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 09:03:40 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
Date: Mon,  4 Sep 2017 15:03:34 +0200
Message-Id: <20170904130335.23280-2-maxime.ripard@free-electrons.com>
In-Reply-To: <20170904130335.23280-1-maxime.ripard@free-electrons.com>
References: <20170904130335.23280-1-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up to
4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
the hardware implementation.

It can operate with an external D-PHY, an internal one or no D-PHY at all
in some configurations.

Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/media/cdns-csi2rx.txt      | 98 ++++++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt

diff --git a/Documentation/devicetree/bindings/media/cdns-csi2rx.txt b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
new file mode 100644
index 000000000000..2395030d8c72
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
@@ -0,0 +1,98 @@
+Cadence MIPI-CSI2 RX controller
+===============================
+
+The Cadence MIPI-CSI2 RX controller is a CSI-2 bridge supporting up to 4 CSI
+lanes in input, and 4 different pixel streams in output.
+
+Required properties:
+  - compatible: must be set to "cdns,csi2rx" and an SoC-specific compatible
+  - reg: base address and size of the memory mapped region
+  - clocks: phandles to the clocks driving the controller
+  - clock-names: must contain:
+    * sys_clk: main clock
+    * p_clk: register bank clock
+    * pixel_if[0-3]_clk: pixel stream output clock, one for each stream
+                         implemented in hardware, between 0 and 3
+
+Optional properties:
+  - phys: phandle to the external D-PHY, phy-names must be provided
+  - phy-names: must contain dphy, if the implementation uses an
+               external D-PHY
+
+Required subnodes:
+  - ports: A ports node with endpoint definitions as defined in
+           Documentation/devicetree/bindings/media/video-interfaces.txt. The
+           first port subnode should be the input endpoint, the next ones the
+           output, one for each stream supported by the CSI2-RX controller.
+           The ports ID must be the stream output number used in the
+           implementation, plus 1.
+
+Example:
+
+csi2rx: csi-bridge@0d060000 {
+	compatible = "cdns,csi2rx";
+	reg = <0x0d060000 0x1000>;
+	clocks = <&byteclock>, <&byteclock>
+		 <&coreclock>, <&coreclock>,
+		 <&coreclock>, <&coreclock>;
+	clock-names = "sys_clk", "p_clk",
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
+			csi2rx_in_sensor: endpoint {
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
+			csi2rx_out_grabber0: endpoint {
+				remote-endpoint = <&grabber0_in_csi2rx>;
+			};
+		};
+
+		port@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <2>;
+
+			csi2rx_out_grabber1: endpoint {
+				remote-endpoint = <&grabber1_in_csi2rx>;
+			};
+		};
+
+		port@3 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <3>;
+
+			csi2rx_out_grabber2: endpoint {
+				remote-endpoint = <&grabber2_in_csi2rx>;
+			};
+		};
+
+		port@4 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <4>;
+
+			csi2rx_out_grabber3: endpoint {
+				remote-endpoint = <&grabber3_in_csi2rx>;
+			};
+		};
+	};
+};
-- 
2.13.5
