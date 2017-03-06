Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58039 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753862AbdCFO6v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:58:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 06/15] atmel-isi: document device tree bindings
Date: Mon,  6 Mar 2017 15:56:07 +0100
Message-Id: <20170306145616.38485-7-hverkuil@xs4all.nl>
In-Reply-To: <20170306145616.38485-1-hverkuil@xs4all.nl>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the device tree bindings for this hardware.

Mostly copied from the atmel-isc bindings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/atmel-isi.txt        | 90 +++++++++++++---------
 1 file changed, 55 insertions(+), 35 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt b/Documentation/devicetree/bindings/media/atmel-isi.txt
index 251f008f220c..d6e93e8216af 100644
--- a/Documentation/devicetree/bindings/media/atmel-isi.txt
+++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
@@ -1,51 +1,71 @@
-Atmel Image Sensor Interface (ISI) SoC Camera Subsystem
-----------------------------------------------
+Atmel Image Sensor Interface (ISI)
+----------------------------------
 
-Required properties:
-- compatible: must be "atmel,at91sam9g45-isi"
-- reg: physical base address and length of the registers set for the device;
-- interrupts: should contain IRQ line for the ISI;
-- clocks: list of clock specifiers, corresponding to entries in
-          the clock-names property;
-- clock-names: must contain "isi_clk", which is the isi peripherial clock.
+Required properties for ISI:
+- compatible: must be "atmel,at91sam9g45-isi".
+- reg: physical base address and length of the registers set for the device.
+- interrupts: should contain IRQ line for the ISI.
+- clocks: list of clock specifiers, corresponding to entries in the clock-names
+	property; please refer to clock-bindings.txt.
+- clock-names: required elements: "isi_clk".
+- pinctrl-names, pinctrl-0: please refer to pinctrl-bindings.txt.
 
 ISI supports a single port node with parallel bus. It should contain one
 'port' child node with child 'endpoint' node. Please refer to the bindings
 defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
 
-Example:
-	isi: isi@f0034000 {
-		compatible = "atmel,at91sam9g45-isi";
-		reg = <0xf0034000 0x4000>;
-		interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
-
-		clocks = <&isi_clk>;
-		clock-names = "isi_clk";
+Endpoint node properties
+------------------------
 
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_isi>;
+- bus-width: <8> or <10> (mandatory)
+- hsync-active
+- vsync-active
+- pclk-sample
+- remote-endpoint: A phandle to the bus receiver's endpoint node.
 
-		port {
-			#address-cells = <1>;
-			#size-cells = <0>;
+Example:
 
-			isi_0: endpoint {
-				remote-endpoint = <&ov2640_0>;
-				bus-width = <8>;
-			};
+isi: isi@f0034000 {
+	compatible = "atmel,at91sam9g45-isi";
+	reg = <0xf0034000 0x4000>;
+	interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_isi_data_0_7>;
+	clocks = <&isi_clk>;
+	clock-names = "isi_clk";
+	status = "ok";
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		isi_0: endpoint {
+			remote-endpoint = <&ov2640_0>;
+			bus-width = <8>;
+			vsync-active = <1>;
+			hsync-active = <1>;
 		};
 	};
+};
+
+i2c1: i2c@f0018000 {
+	status = "okay";
 
-	i2c1: i2c@f0018000 {
-		ov2640: camera@0x30 {
-			compatible = "ovti,ov2640";
-			reg = <0x30>;
+	ov2640: camera@30 {
+		compatible = "ovti,ov2640";
+		reg = <0x30>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
+		resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
+		pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
+		clocks = <&pck0>;
+		clock-names = "xvclk";
+		assigned-clocks = <&pck0>;
+		assigned-clock-rates = <25000000>;
 
-			port {
-				ov2640_0: endpoint {
-					remote-endpoint = <&isi_0>;
-					bus-width = <8>;
-				};
+		port {
+			ov2640_0: endpoint {
+				remote-endpoint = <&isi_0>;
+				bus-width = <8>;
 			};
 		};
 	};
+};
-- 
2.11.0
