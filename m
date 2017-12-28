Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55672 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753648AbdL1OBj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 09:01:39 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] dt-bindings: media: Add Renesas CEU bindings
Date: Thu, 28 Dec 2017 15:01:13 +0100
Message-Id: <1514469681-15602-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for Renesas Capture Engine Unit (CEU).

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 .../devicetree/bindings/media/renesas,ceu.txt      | 85 ++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
new file mode 100644
index 0000000..f45628e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
@@ -0,0 +1,85 @@
+Renesas Capture Engine Unit (CEU)
+----------------------------------------------
+
+The Capture Engine Unit is the image capture interface found on Renesas
+RZ chip series and on SH Mobile ones.
+
+The interface supports a single parallel input with data bus width up to
+8/16 bits.
+
+Required properties:
+- compatible
+	Must be one of:
+	- "renesas,ceu"
+	- "renesas,r7s72100-ceu"
+- reg
+	Physical address base and size.
+- interrupts
+	The interrupt specifier.
+- pinctrl-names, pinctrl-0
+	phandle of pin controller sub-node configuring pins for CEU operations.
+- remote-endpoint
+	phandle to an 'endpoint' subnode of a remote device node.
+
+CEU supports a single parallel input and should contain a single 'port' subnode
+with a single 'endpoint'. Optional endpoint properties applicable to parallel
+input bus described in "video-interfaces.txt" supported by this driver are:
+
+- hsync-active
+	active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+- vsync-active
+	active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+
+Example:
+
+The example describes the connection between the Capture Engine Unit and an
+OV7670 image sensor sitting on bus i2c1.
+
+ceu: ceu@e8210000 {
+	reg = <0xe8210000 0x209c>;
+	compatible = "renesas,ceu";
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
