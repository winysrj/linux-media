Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33063 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752589AbdEDPR1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 11:17:27 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 1/2] [media] dt-bindings: Add bindings for video-multiplexer device
Date: Thu,  4 May 2017 17:17:18 +0200
Message-Id: <1493911039-10693-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for the video multiplexer device.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
No changes since v3 [1].

This was previously sent as part of Steve's i.MX media series [2].

[1] https://patchwork.kernel.org/patch/9711997/
[2] https://patchwork.kernel.org/patch/9647951/
---
 .../devicetree/bindings/media/video-mux.txt        | 60 ++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt

diff --git a/Documentation/devicetree/bindings/media/video-mux.txt b/Documentation/devicetree/bindings/media/video-mux.txt
new file mode 100644
index 0000000000000..63b9dc913e456
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/video-mux.txt
@@ -0,0 +1,60 @@
+Video Multiplexer
+=================
+
+Video multiplexers allow to select between multiple input ports. Video received
+on the active input port is passed through to the output port. Muxes described
+by this binding are controlled by a multiplexer controller that is described by
+the bindings in Documentation/devicetree/bindings/mux/mux-controller.txt
+
+Required properties:
+- compatible : should be "video-mux"
+- mux-controls : mux controller node to use for operating the mux
+- #address-cells: should be <1>
+- #size-cells: should be <0>
+- port@*: at least three port nodes containing endpoints connecting to the
+  source and sink devices according to of_graph bindings. The last port is
+  the output port, all others are inputs.
+
+Optionally, #address-cells, #size-cells, and port nodes can be grouped under a
+ports node as described in Documentation/devicetree/bindings/graph.txt.
+
+Example:
+
+	mux: mux-controller {
+		compatible = "gpio-mux";
+		#mux-control-cells = <0>;
+
+		mux-gpios = <&gpio1 15 GPIO_ACTIVE_HIGH>;
+	};
+
+	video-mux {
+		compatible = "video-mux";
+		mux-controls = <&mux>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			mux_in0: endpoint {
+				remote-endpoint = <&video_source0_out>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			mux_in1: endpoint {
+				remote-endpoint = <&video_source1_out>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			mux_out: endpoint {
+				remote-endpoint = <&capture_interface_in>;
+			};
+		};
+	};
+};
-- 
2.11.0
