Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48209 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbeHMMGx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 08:06:53 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v2 2/7] [media] dt-bindings: tvp5150: Add input port connectors DT bindings
Date: Mon, 13 Aug 2018 11:25:03 +0200
Message-Id: <20180813092508.1334-3-m.felsch@pengutronix.de>
In-Reply-To: <20180813092508.1334-1-m.felsch@pengutronix.de>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TVP5150/1 decoders support different video input sources to their
AIP1A/B pins.

Possible configurations are as follows:
  - Analog Composite signal connected to AIP1A.
  - Analog Composite signal connected to AIP1B.
  - Analog S-Video Y (luminance) and C (chrominance)
    signals connected to AIP1A and AIP1B respectively.

This patch extends the device tree bindings documentation to describe
how the input connectors for these devices should be defined in a DT.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

---
Changelog:
v2:
- adapt port layout in accordance with
  https://www.spinics.net/lists/linux-media/msg138546.html with the
  svideo-connector deviation (use only one endpoint)
---
 .../devicetree/bindings/media/i2c/tvp5150.txt | 191 +++++++++++++++++-
 1 file changed, 185 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
index 8c0fc1a26bf0..d647d671f14a 100644
--- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
+++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
@@ -12,11 +12,31 @@ Optional Properties:
 - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
 - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
 
-The device node must contain one 'port' child node for its digital output
-video port, in accordance with the video interface bindings defined in
-Documentation/devicetree/bindings/media/video-interfaces.txt.
+The device node must contain one 'port' child node per device physical input
+and output port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
+are numbered as follows
 
-Required Endpoint Properties for parallel synchronization:
+	  Name		Type		Port
+	--------------------------------------
+	  AIP1A		sink		0
+	  AIP1B		sink		1
+	  Y-OUT		src		2
+
+The device node must contain at least one sink port and the src port. Each input
+port must be linked to an endpoint defined in
+Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt. The
+port/connector layout is as follows
+
+tvp-5150 port@0 (AIP1A)
+	endpoint@0 -----------> Comp0-Con  port
+	endpoint@1 -----------> Svideo-Con port
+tvp-5150 port@1 (AIP1B)
+	endpoint   -----------> Comp1-Con  port
+tvp-5150 port@2
+	endpoint (video bitstream output at YOUT[0-7] parallel bus)
+
+Required Endpoint Properties for parallel synchronization on output port:
 
 - hsync-active: active state of the HSYNC signal. Must be <1> (HIGH).
 - vsync-active: active state of the VSYNC signal. Must be <1> (HIGH).
@@ -26,7 +46,140 @@ Required Endpoint Properties for parallel synchronization:
 If none of hsync-active, vsync-active and field-even-active is specified,
 the endpoint is assumed to use embedded BT.656 synchronization.
 
-Example:
+Examples:
+
+One Input:
+
+connector {
+	compatible = "composite-video-connector";
+	label = "Composite0";
+
+	port {
+		composite0_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_composite0>;
+		};
+	};
+};
+
+&i2c2 {
+	...
+	tvp5150@5c {
+		compatible = "ti,tvp5150";
+		reg = <0x5c>;
+		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
+		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
+
+		port@0 {
+			reg = <0>;
+
+			tvp5150_to_composite0: endpoint {
+				remote-endpoint = <&composite0_to_tvp5150>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			tvp5150_1: endpoint {
+				remote-endpoint = <&ccdc_ep>;
+			};
+		};
+	};
+};
+
+Two Inputs:
+
+comp_connector_1 {
+	compatible = "composite-video-connector";
+	label = "Composite1";
+
+	port {
+		composite1_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_composite1>;
+		};
+	};
+};
+
+svid_connector {
+	compatible = "svideo-connector";
+	label = "S-Video";
+
+	port {
+		svideo_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_svideo>;
+		};
+	};
+};
+
+&i2c2 {
+	...
+	tvp5150@5c {
+		compatible = "ti,tvp5150";
+		reg = <0x5c>;
+		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
+		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
+
+                port@0 {
+                        reg = <0>;
+
+                        tvp5150_to_svideo: endpoint@1 {
+                                reg = <1>;
+                                remote-endpoint = <&svideo_to_tvp5150>;
+                        };
+                };
+
+                port@1 {
+                        reg = <1>;
+
+                        tvp5150_to_composite1: endpoint {
+                                remote-endpoint = <&composite1_to_tvp5150>;
+                        };
+                };
+
+		port@2 {
+			reg = <2>;
+
+			tvp5150_1: endpoint {
+				remote-endpoint = <&ccdc_ep>;
+			};
+		};
+	};
+};
+
+Three Inputs:
+
+comp_connector_0 {
+	compatible = "composite-video-connector";
+	label = "Composite0";
+
+	port {
+		composite0_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_composite0>;
+		};
+	};
+};
+
+comp_connector_1 {
+	compatible = "composite-video-connector";
+	label = "Composite1";
+
+	port {
+		composite1_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_composite1>;
+		};
+	};
+};
+
+svid_connector {
+	compatible = "svideo-connector";
+	label = "S-Video";
+
+	port {
+		svideo_to_tvp5150: endpoint {
+			remote-endpoint = <&tvp5150_to_svideo>;
+		};
+	};
+};
 
 &i2c2 {
 	...
@@ -36,7 +189,33 @@ Example:
 		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
 		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
 
-		port {
+                port@0 {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+                        reg = <0>;
+
+                        tvp5150_to_composite0: endpoint@0 {
+                                reg = <0>;
+                                remote-endpoint = <&composite0_to_tvp5150>;
+                        };
+
+                        tvp5150_to_svideo: endpoint@1 {
+                                reg = <1>;
+                                remote-endpoint = <&svideo_to_tvp5150>;
+                        };
+                };
+
+                port@1 {
+                        reg = <1>;
+
+                        tvp5150_to_composite1: endpoint {
+                                remote-endpoint = <&composite1_to_tvp5150>;
+                        };
+                };
+
+		port@2 {
+			reg = <2>;
+
 			tvp5150_1: endpoint {
 				remote-endpoint = <&ccdc_ep>;
 			};
-- 
2.18.0
