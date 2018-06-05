Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34344 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbeFEXek (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 19:34:40 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v1 1/4] media: dt-bindings: max9286: add device tree binding
Date: Wed,  6 Jun 2018 00:34:32 +0100
Message-Id: <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide device tree binding documentation for the MAX9286 Quad GMSL
deserialiser.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/i2c/max9286.txt | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max9286.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/max9286.txt b/Documentation/devicetree/bindings/media/i2c/max9286.txt
new file mode 100644
index 000000000000..e6e5d2c93245
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
@@ -0,0 +1,75 @@
+* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
+
+Required Properties:
+ - compatible: Shall be "maxim,max9286"
+
+The following required properties are defined externally in
+Documentation/devicetree/bindings/i2c/i2c-mux.txt:
+ - Standard I2C mux properties.
+ - I2C child bus nodes.
+
+A maximum of 4 I2C child nodes can be specified on the MAX9286, to
+correspond with a maximum of 4 input devices.
+
+The device node must contain one 'port' child node per device input and output
+port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
+are numbered as follows.
+
+      Port        Type
+    ----------------------
+       0          sink
+       1          sink
+       2          sink
+       3          sink
+       4          source
+
+Example:
+&i2c4 {
+	gmsl-deserializer@0 {
+		compatible = "maxim,max9286";
+		reg = <0x4c>;
+		poc-supply = <&poc_12v>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				max9286_in0: endpoint {
+					remote-endpoint = <&rdacm20_out0>;
+				};
+			};
+
+			port@4 {
+				reg = <4>;
+				max9286_out0: endpoint {
+					clock-lanes = <0>;
+					data-lanes = <1 2 3 4>;
+					remote-endpoint = <&csi40_in>;
+				};
+			};
+		};
+
+		i2c@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			camera@51 {
+				compatible = MAXIM_CAMERA0;
+				reg = <0x51 0x61>;
+
+				port {
+					rdacm20_out0: endpoint {
+						remote-endpoint = <&max9286_in0>;
+					};
+				};
+			};
+		};
+	};
+};
-- 
2.17.0
