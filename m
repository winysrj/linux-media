Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:37793 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751675AbeCWEOr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 00:14:47 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: media: Binding document for OV7251 camera sensor
Date: Fri, 23 Mar 2018 12:14:19 +0800
Message-Id: <1521778460-8717-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1521778460-8717-1-git-send-email-todor.tomov@linaro.org>
References: <1521778460-8717-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the document for ov7251 device tree binding.

CC: Rob Herring <robh@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>
CC: devicetree@vger.kernel.org
Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/i2c/ov7251.txt       | 51 ++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7251.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov7251.txt b/Documentation/devicetree/bindings/media/i2c/ov7251.txt
new file mode 100644
index 0000000..4ee6888
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov7251.txt
@@ -0,0 +1,51 @@
+* Omnivision 1/7.5-Inch B&W VGA CMOS Digital Image Sensor
+
+The Omnivision OV7251 is a 1/7.5-Inch CMOS active pixel digital image sensor with
+an active array size of 640H x 480V. It is programmable through a serial I2C
+interface.
+
+Required Properties:
+- compatible: Value should be "ovti,ov7251".
+- clocks: Reference to the xclk clock.
+- clock-names: Should be "xclk".
+- clock-frequency: Frequency of the xclk clock.
+- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH. This corresponds
+  to the hardware pin XSHUTDOWN which is physically active low.
+- vdddo-supply: Chip digital IO regulator.
+- vdda-supply: Chip analog regulator.
+- vddd-supply: Chip digital core regulator.
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	&i2c1 {
+		...
+
+		ov7251: camera-sensor@60 {
+			compatible = "ovti,ov7251";
+			reg = <0x60>;
+
+			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&camera_bw_default>;
+
+			clocks = <&clks 200>;
+			clock-names = "xclk";
+			clock-frequency = <24000000>;
+
+			vdddo-supply = <&camera_dovdd_1v8>;
+			vdda-supply = <&camera_avdd_2v8>;
+			vddd-supply = <&camera_dvdd_1v2>;
+
+			port {
+				ov7251_ep: endpoint {
+					clock-lanes = <1>;
+					data-lanes = <0>;
+					remote-endpoint = <&csi0_ep>;
+				};
+			};
+		};
+	};
-- 
2.7.4
