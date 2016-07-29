Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:36656 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbcG2IHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 04:07:31 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: <nicolas.ferre@atmel.com>
CC: <robh@kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	Songjun Wu <songjun.wu@microchip.com>,
	<devicetree@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Rob Herring <robh+dt@kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v7 2/2] [media] atmel-isc: DT binding for Image Sensor Controller driver
Date: Fri, 29 Jul 2016 15:54:08 +0800
Message-ID: <1469778856-24253-3-git-send-email-songjun.wu@microchip.com>
In-Reply-To: <1469778856-24253-1-git-send-email-songjun.wu@microchip.com>
References: <1469778856-24253-1-git-send-email-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DT binding documentation for ISC driver.

Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

Changes in v7: None
Changes in v6:
- Add "iscck" and "gck" to clock-names.

Changes in v5:
- Add clock-output-names.

Changes in v4:
- Remove the isc clock nodes.

Changes in v3:
- Remove the 'atmel,sensor-preferred'.
- Modify the isc clock node according to the Rob's remarks.

Changes in v2:
- Remove the unit address of the endpoint.
- Add the unit address to the clock node.
- Avoid using underscores in node names.
- Drop the "0x" in the unit address of the i2c node.
- Modify the description of 'atmel,sensor-preferred'.
- Add the description for the ISC internal clock.

 .../devicetree/bindings/media/atmel-isc.txt        | 65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt

diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Documentation/devicetree/bindings/media/atmel-isc.txt
new file mode 100644
index 0000000..bbe0e87c
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
@@ -0,0 +1,65 @@
+Atmel Image Sensor Controller (ISC)
+----------------------------------------------
+
+Required properties for ISC:
+- compatible
+	Must be "atmel,sama5d2-isc".
+- reg
+	Physical base address and length of the registers set for the device.
+- interrupts
+	Should contain IRQ line for the ISC.
+- clocks
+	List of clock specifiers, corresponding to entries in
+	the clock-names property;
+	Please refer to clock-bindings.txt.
+- clock-names
+	Required elements: "hclock", "iscck", "gck".
+- #clock-cells
+	Should be 0.
+- clock-output-names
+	Should be "isc-mck".
+- pinctrl-names, pinctrl-0
+	Please refer to pinctrl-bindings.txt.
+
+ISC supports a single port node with parallel bus. It should contain one
+'port' child node with child 'endpoint' node. Please refer to the bindings
+defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+isc: isc@f0008000 {
+	compatible = "atmel,sama5d2-isc";
+	reg = <0xf0008000 0x4000>;
+	interrupts = <46 IRQ_TYPE_LEVEL_HIGH 5>;
+	clocks = <&isc_clk>, <&iscck>, <&isc_gclk>;
+	clock-names = "hclock", "iscck", "gck";
+	#clock-cells = <0>;
+	clock-output-names = "isc-mck";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
+
+	port {
+		isc_0: endpoint {
+			remote-endpoint = <&ov7740_0>;
+			hsync-active = <1>;
+			vsync-active = <0>;
+			pclk-sample = <1>;
+		};
+	};
+};
+
+i2c1: i2c@fc028000 {
+	ov7740: camera@21 {
+		compatible = "ovti,ov7740";
+		reg = <0x21>;
+		clocks = <&isc>;
+		clock-names = "xvclk";
+		assigned-clocks = <&isc>;
+		assigned-clock-rates = <24000000>;
+
+		port {
+			ov7740_0: endpoint {
+				remote-endpoint = <&isc_0>;
+			};
+		};
+	};
+};
-- 
2.7.4

