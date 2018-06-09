Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57301 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbeFILaQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2018 07:30:16 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: kieran.bingham+renesas@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 1/2] dt/bindings: media: Add DT bindings for Maxim Integrated MAX9286
Date: Sat,  9 Jun 2018 13:30:04 +0200
Message-Id: <1528543805-23945-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528543805-23945-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528543805-23945-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The MAX9286 deserializes video data received on up to 4 Gigabit
Multimedia Serial Links (GMSL) and outputs them on a CSI-2 port using up
to 4 data lanes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 .../bindings/media/i2c/maxim,max9286.txt           | 180 +++++++++++++++++++++
 1 file changed, 180 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
new file mode 100644
index 0000000..8c099bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
@@ -0,0 +1,180 @@
+Maxim Integrated Quad GMSL Deserializer
+---------------------------------------
+
+The MAX9286 deserializes receives video data on up to 4 Gigabit Multimedia
+Serial Links (GMSL) and outputs them on a CSI-2 port using up to 4 data lanes.
+
+In addition to video data, the GMSL links carry a bidirectional control
+channel that encapsulates I2C messages. The MAX9286 forwards all I2C traffic
+not addressed to itself to the other side of the links, where a GMSL
+serializer will output it on a local I2C bus. In the other direction all I2C
+traffic received over GMSL by the MAX9286 is output on the local I2C bus.
+
+Required Properties:
+
+- compatible: Shall be "maxim,max9286"
+- reg: I2C device address
+
+Optional Properties:
+
+- poc-supply: Regulator providing Power over Coax to the cameras
+- pwdn-gpios: GPIO connected to the #PWDN pin
+
+Required endpoint nodes:
+-----------------------
+
+The connections to the MAX9286 GMSL and its endpoint nodes are modeled using
+the OF graph bindings in accordance with the video interface bindings defined
+in Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+The following table lists the port number corresponding to each device port.
+
+        Port            Description
+        ----------------------------------------
+        Port 0          GMSL Input 0
+        Port 1          GMSL Input 1
+        Port 2          GMSL Input 2
+        Port 3          GMSL Input 3
+        Port 4          CSI-2 Output
+
+Optional Endpoint Properties for GSML Input Ports (Port [0-3]):
+
+- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
+  remote node port.
+
+Required Endpoint Properties for CSI-2 Output Port (Port 4):
+
+- data-lanes: array of physical CSI-2 data lane indexes.
+- clock-lanes: index of CSI-2 clock lane.
+
+Required i2c-mux nodes:
+----------------------
+
+Each remote GMSL endpoint is modeled as child busses of an i2c bus
+multiplexer/switch, in accordance with bindings described in
+Documentation/devicetree/bindings/i2c/i2c-mux.txt.
+
+Required i2c child bus properties:
+- all properties described as required i2c child bus nodes properties in
+  Documentation/devicetree/bindings/i2c/i2c-mux.txt.
+
+Example:
+-------
+
+	gmsl-deserializer@2c {
+		compatible = "maxim,max9286";
+		reg = <0x2c>;
+		poc-supply = <&camera_poc_12v>;
+		pwdn-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
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
+			port@1 {
+				reg = <1>;
+				max9286_in1: endpoint {
+					remote-endpoint = <&rdacm20_out1>;
+				};
+			};
+
+			port@2 {
+				reg = <2>;
+				max9286_in2: endpoint {
+					remote-endpoint = <&rdacm20_out2>;
+				};
+			};
+
+			port@3 {
+				reg = <3>;
+				max9286_in3: endpoint {
+					remote-endpoint = <&rdacm20_out3>;
+				};
+			};
+
+			port@4 {
+				reg = <4>;
+				max9286_out: endpoint {
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
+				compatible = "imi,rdacm20";
+				reg = <0x51 0x61>;
+
+				port {
+					rdacm20_out0: endpoint {
+						remote-endpoint = <&max9286_in0>;
+					};
+				};
+
+			};
+		};
+
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+
+			camera@52 {
+				compatible = "imi,rdacm20";
+				reg = <0x52 0x62>;
+				port {
+					rdacm20_out1: endpoint {
+						remote-endpoint = <&max9286_in1>;
+					};
+				};
+			};
+		};
+
+		i2c@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <2>;
+
+			camera@53 {
+				compatible = "imi,rdacm20";
+				reg = <0x53 0x63>;
+				port {
+					rdacm20_out2: endpoint {
+						remote-endpoint = <&max9286_in2>;
+					};
+				};
+			};
+		};
+
+		i2c@3 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <3>;
+
+			camera@54 {
+				compatible = "imi,rdacm20";
+				reg = <0x54 0x64>;
+				port {
+					rdacm20_out3: endpoint {
+						remote-endpoint = <&max9286_in3>;
+					};
+				};
+			};
+		};
+	};
-- 
2.7.4
