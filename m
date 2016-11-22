Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33508 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755692AbcKVPwu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 10:52:50 -0500
Received: by mail-pg0-f53.google.com with SMTP id 3so8905992pgd.0
        for <linux-media@vger.kernel.org>; Tue, 22 Nov 2016 07:52:50 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
Subject: [PATCH v3 4/4] [media] dt-bindings: add TI VPIF documentation
Date: Tue, 22 Nov 2016 07:52:44 -0800
Message-Id: <20161122155244.802-5-khilman@baylibre.com>
In-Reply-To: <20161122155244.802-1-khilman@baylibre.com>
References: <20161122155244.802-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 .../bindings/media/ti,da850-vpif-capture.txt       | 65 ++++++++++++++++++++++
 .../devicetree/bindings/media/ti,da850-vpif.txt    |  8 +++
 2 files changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt

diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
new file mode 100644
index 000000000000..c447ac482c1d
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
@@ -0,0 +1,65 @@
+Texas Instruments VPIF Capture
+------------------------------
+
+The TI Video Port InterFace (VPIF) capture component is the primary
+component for video capture on the DA850 family of TI DaVinci SoCs.
+
+TI Document number reference: SPRUH82C
+
+Required properties:
+- compatible: must be "ti,da850-vpif-capture"
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
+		compatible = "ti,da850-vpif-capture";
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
diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
new file mode 100644
index 000000000000..d004e600aabe
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
@@ -0,0 +1,8 @@
+Texas Instruments VPIF
+----------------------
+
+The Video Port InterFace (VPIF) is the core component for video output
+and capture on DA850 TI Davinci SoCs.
+
+- compatible: must be "ti,da850-vpif"
+- reg: physical base address and length of the registers set for the device;
-- 
2.9.3

