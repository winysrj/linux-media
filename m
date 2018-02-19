Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:35584 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbeBSRGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 12:06:40 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 01/11] dt-bindings: media: Add Renesas CEU bindings
Date: Mon, 19 Feb 2018 17:59:34 +0100
Message-Id: <1519059584-30844-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for Renesas Capture Engine Unit (CEU).

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/renesas,ceu.txt      | 81 ++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
new file mode 100644
index 0000000..3fc66df
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
@@ -0,0 +1,81 @@
+Renesas Capture Engine Unit (CEU)
+----------------------------------------------
+
+The Capture Engine Unit is the image capture interface found in the Renesas
+SH Mobile and RZ SoCs.
+
+The interface supports a single parallel input with data bus width of 8 or 16
+bits.
+
+Required properties:
+- compatible: Shall be "renesas,r7s72100-ceu" for CEU units found in RZ/A1H
+  and RZ/A1M SoCs.
+- reg: Registers address base and size.
+- interrupts: The interrupt specifier.
+
+The CEU supports a single parallel input and should contain a single 'port'
+subnode with a single 'endpoint'. Connection to input devices are modeled
+according to the video interfaces OF bindings specified in:
+Documentation/devicetree/bindings/media/video-interfaces.txt
+
+Optional endpoint properties applicable to parallel input bus described in
+the above mentioned "video-interfaces.txt" file are supported.
+
+- hsync-active: Active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+  If property is not present, default is active high.
+- vsync-active: Active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+  If property is not present, default is active high.
+
+Example:
+
+The example describes the connection between the Capture Engine Unit and an
+OV7670 image sensor connected to i2c1 interface.
+
+ceu: ceu@e8210000 {
+	reg = <0xe8210000 0x209c>;
+	compatible = "renesas,r7s72100-ceu";
+	interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&vio_pins>;
+
+	status = "okay";
+
+	port {
+		ceu_in: endpoint {
+			remote-endpoint = <&ov7670_out>;
+
+			hsync-active = <1>;
+			vsync-active = <0>;
+		};
+	};
+};
+
+i2c1: i2c@fcfee400 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c1_pins>;
+
+	status = "okay";
+
+	clock-frequency = <100000>;
+
+	ov7670: camera@21 {
+		compatible = "ovti,ov7670";
+		reg = <0x21>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&vio_pins>;
+
+		reset-gpios = <&port3 11 GPIO_ACTIVE_LOW>;
+		powerdown-gpios = <&port3 12 GPIO_ACTIVE_HIGH>;
+
+		port {
+			ov7670_out: endpoint {
+				remote-endpoint = <&ceu_in>;
+
+				hsync-active = <1>;
+				vsync-active = <0>;
+			};
+		};
+	};
+};
-- 
2.7.4
