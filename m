Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:36010 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753425AbcKSAcO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 19:32:14 -0500
Received: by mail-pg0-f44.google.com with SMTP id f188so107694672pgc.3
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 16:32:14 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4/4] [media] dt-bindings: add TI VPIF documentation
Date: Fri, 18 Nov 2016 16:32:08 -0800
Message-Id: <20161119003208.10550-4-khilman@baylibre.com>
In-Reply-To: <20161119003208.10550-1-khilman@baylibre.com>
References: <20161119003208.10550-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 .../devicetree/bindings/media/ti,vpif-capture.txt  | 65 ++++++++++++++++++++++
 .../devicetree/bindings/media/ti,vpif.txt          |  8 +++
 2 files changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,vpif-capture.txt
 create mode 100644 Documentation/devicetree/bindings/media/ti,vpif.txt

diff --git a/Documentation/devicetree/bindings/media/ti,vpif-capture.txt b/Documentation/devicetree/bindings/media/ti,vpif-capture.txt
new file mode 100644
index 000000000000..eaaaa46d3a5e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,vpif-capture.txt
@@ -0,0 +1,65 @@
+Texas Instruments VPIF Capture
+------------------------------
+
+The TI Video Port InterFace (VPIF) capture component is the primary
+component for video capture on some TI DaVinci family SoCs.
+
+TI Document number reference: SPRUH82C
+
+Required properties:
+- compatible: must be "ti,vpif-capture"
+- reg: physical base address and length of the registers set for the device;
+- interrupts: should contain IRQ line for the VPIF
+
+VPIF capture has a 16-bit parallel bus input, supporting 2 8-bit
+channels or a single 16-bit channel.  It should contain at least one
+port child node with child 'endpoint' node. Please refer to the
+bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example using 2 8-bit input channels, one of which is connected to an
+I2C-connected TVP5147 decoder:
+
+	vpif_capture: video-capture@0x00217000 {
+		compatible = "ti,vpif-capture";
+		reg = <0x00217000 0x1000>;
+		interrupts = <92>;
+
+		port {
+			vpif_ch0: endpoint@0 {
+				  reg = <0>;
+				  bus-width = <8>;
+				  remote-endpoint = <&composite>;
+			};
+
+			vpif_ch1: endpoint@1 {
+				  reg = <1>;
+				  bus-width = <8>;
+				  data-shift = <8>;
+			};
+		};
+	};
+
+[ ... ]
+
+&i2c0 {
+
+	tvp5147@5d {
+		compatible = "ti,tvp5147";
+		reg = <0x5d>;
+		status = "okay";
+
+		port {
+			composite: endpoint {
+				hsync-active = <1>;
+				vsync-active = <1>;
+				pclk-sample = <0>;
+
+				/* VPIF channel 0 (lower 8-bits) */
+				remote-endpoint = <&vpif_ch0>;
+				bus-width = <8>;
+			};
+		};
+	};
+
+};
diff --git a/Documentation/devicetree/bindings/media/ti,vpif.txt b/Documentation/devicetree/bindings/media/ti,vpif.txt
new file mode 100644
index 000000000000..0d5c16531c0e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,vpif.txt
@@ -0,0 +1,8 @@
+Texas Instruments VPIF
+----------------------
+
+The Video Port InterFace (VPIF) is the core component for video output
+and capture on TI Davinci family SoCs.
+
+- compatible: must be "ti,vpif"
+- reg: physical base address and length of the registers set for the device;
-- 
2.9.3

