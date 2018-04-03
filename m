Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33252 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbeDCO3h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 10:29:37 -0400
Received: by mail-wr0-f193.google.com with SMTP id z73so18943068wrb.0
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2018 07:29:37 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 1/2] media: ov2680: dt: Add bindings for OV2680
Date: Tue,  3 Apr 2018 15:29:21 +0100
Message-Id: <20180403142922.20972-2-rui.silva@linaro.org>
In-Reply-To: <20180403142922.20972-1-rui.silva@linaro.org>
References: <20180403142922.20972-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the OV2680 camera sensor.

Reviewed-by: Rob Herring <robh@kernel.org>
CC: devicetree@vger.kernel.org
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 .../devicetree/bindings/media/i2c/ov2680.txt       | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2680.txt b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
new file mode 100644
index 000000000000..0e29f1a113c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
@@ -0,0 +1,40 @@
+* Omnivision OV2680 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: should be "ovti,ov2680".
+- clocks: reference to the xvclk input clock.
+- clock-names: should be "xvclk".
+
+Optional Properties:
+- powerdown-gpios: reference to the GPIO connected to the powerdown pin,
+		     if any. This is an active high signal to the OV2680.
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
+		powerdown-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
+
+		port {
+			ov2680_mipi_ep: endpoint {
+				remote-endpoint = <&mipi_sensor_ep>;
+				clock-lanes = <0>;
+				data-lanes = <1>;
+			};
+		};
+	};
+};
-- 
2.16.3
