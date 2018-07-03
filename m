Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43419 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbeGCOId (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 10:08:33 -0400
Received: by mail-wr0-f193.google.com with SMTP id f18-v6so2119058wre.10
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 07:08:32 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v7 1/2] media: ov2680: dt: Add bindings for OV2680
Date: Tue,  3 Jul 2018 15:08:02 +0100
Message-Id: <20180703140803.19580-2-rui.silva@linaro.org>
In-Reply-To: <20180703140803.19580-1-rui.silva@linaro.org>
References: <20180703140803.19580-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the OV2680 camera sensor.

CC: devicetree@vger.kernel.org
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 .../devicetree/bindings/media/i2c/ov2680.txt  | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2680.txt b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
new file mode 100644
index 000000000000..11e925ed9dad
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
@@ -0,0 +1,46 @@
+* Omnivision OV2680 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: should be "ovti,ov2680".
+- clocks: reference to the xvclk input clock.
+- clock-names: should be "xvclk".
+- DOVDD-supply: Digital I/O voltage supply.
+- DVDD-supply: Digital core voltage supply.
+- AVDD-supply: Analog voltage supply.
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the powerdown/reset pin,
+               if any. This is an active low signal to the OV2680.
+
+The device node must contain one 'port' child node for its digital output
+video port, and this port must have a single endpoint in accordance with
+ the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Endpoint node required properties for CSI-2 connection are:
+- remote-endpoint: a phandle to the bus receiver's endpoint node.
+- clock-lanes: should be set to <0> (clock lane on hardware lane 0).
+- data-lanes: should be set to <1> (one CSI-2 lane supported).
+
+Example:
+
+&i2c2 {
+	ov2680: camera-sensor@36 {
+		compatible = "ovti,ov2680";
+		reg = <0x36>;
+		clocks = <&osc>;
+		clock-names = "xvclk";
+		reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
+		DOVDD-supply = <&sw2_reg>;
+		DVDD-supply = <&sw2_reg>;
+		AVDD-supply = <&reg_peri_3p15v>;
+
+		port {
+			ov2680_to_mipi: endpoint {
+				remote-endpoint = <&mipi_from_sensor>;
+				clock-lanes = <0>;
+				data-lanes = <1>;
+			};
+		};
+	};
+};
-- 
2.18.0
