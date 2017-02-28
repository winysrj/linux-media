Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35929 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752716AbdB1QSI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 11:18:08 -0500
Received: by mail-wm0-f41.google.com with SMTP id v77so89145112wmv.1
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 08:18:07 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 2/2] media: dt-bindings: vpif: extend the example with an output port
Date: Tue, 28 Feb 2017 17:08:54 +0100
Message-Id: <1488298134-6200-3-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1488298134-6200-1-git-send-email-bgolaszewski@baylibre.com>
References: <1488298134-6200-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the example more or less correspond with the da850-evm
hardware setup.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/ti,da850-vpif.txt    | 40 +++++++++++++++++-----
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
index 9c7510b..df7182a 100644
--- a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
+++ b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
@@ -16,8 +16,10 @@ Required properties:
 Video Capture:
 
 VPIF has a 16-bit parallel bus input, supporting 2 8-bit channels or a
-single 16-bit channel.  It should contain at least one port child node
-with child 'endpoint' node. Please refer to the bindings defined in
+single 16-bit channel. It should contain one or two port child nodes
+with child 'endpoint' node. If there are two ports then port@0 must
+describe the input and port@1 output channels. Please refer to the
+bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt.
 
 Example using 2 8-bit input channels, one of which is connected to an
@@ -28,19 +30,26 @@ I2C-connected TVP5147 decoder:
 		reg = <0x217000 0x1000>;
 		interrupts = <92>;
 
-		port {
-			vpif_ch0: endpoint@0 {
+		port@0 {
+			vpif_input_ch0: endpoint@0 {
 				reg = <0>;
 				bus-width = <8>;
-				remote-endpoint = <&composite>;
+				remote-endpoint = <&composite_in>;
 			};
 
-			vpif_ch1: endpoint@1 {
+			vpif_input_ch1: endpoint@1 {
 				reg = <1>;
 				bus-width = <8>;
 				data-shift = <8>;
 			};
 		};
+
+		port@1 {
+			vpif_output_ch0: endpoint {
+				bus-width = <8>;
+				remote-endpoint = <&composite_out>;
+			};
+		};
 	};
 
 [ ... ]
@@ -53,13 +62,28 @@ I2C-connected TVP5147 decoder:
 		status = "okay";
 
 		port {
-			composite: endpoint {
+			composite_in: endpoint {
 				hsync-active = <1>;
 				vsync-active = <1>;
 				pclk-sample = <0>;
 
 				/* VPIF channel 0 (lower 8-bits) */
-				remote-endpoint = <&vpif_ch0>;
+				remote-endpoint = <&vpif_input_ch0>;
+				bus-width = <8>;
+			};
+		};
+	};
+
+	adv7343@2a {
+		compatible = "adi,adv7343";
+		reg = <0x2a>;
+
+		port {
+			composite_out: endpoint {
+				adi,dac-enable = <1 1 1>;
+				adi,sd-dac-enable = <1>;
+
+				remote-endpoint = <&vpif_output_ch0>;
 				bus-width = <8>;
 			};
 		};
-- 
2.9.3
