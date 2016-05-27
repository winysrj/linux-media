Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:38327 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbcE0PjQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 11:39:16 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, geert@linux-m68k.org, matrandg@cisco.com,
	linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 1/2] [media] media: i2c/ov5645: add the device tree binding document
Date: Fri, 27 May 2016 18:38:49 +0300
Message-Id: <1464363530-2253-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1464363530-2253-1-git-send-email-todor.tomov@linaro.org>
References: <1464363530-2253-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the document for ov5645 device tree binding.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../devicetree/bindings/media/i2c/ov5645.txt       | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
new file mode 100644
index 0000000..468cf83
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
@@ -0,0 +1,50 @@
+* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
+
+The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image sensor with
+an active array size of 2592H x 1944V. It is programmable through a serial I2C
+interface.
+
+Required Properties:
+- compatible: Value should be "ovti,ov5645".
+- clocks: Reference to the xclk clock.
+- clock-names: Should be "xclk".
+- enable-gpios: Chip enable GPIO. Polarity is GPIO_ACTIVE_HIGH.
+- reset-gpios: Chip reset GPIO. Polarity is GPIO_ACTIVE_LOW.
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
+		ov5645: ov5645@78 {
+			compatible = "ovti,ov5645";
+			reg = <0x78>;
+
+			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
+			reset-gpios = <&gpio5 20 GPIO_ACTIVE_LOW>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&camera_rear_default>;
+
+			clocks = <&clks 200>;
+			clock-names = "xclk";
+
+			vdddo-supply = <&camera_dovdd_1v8>;
+			vdda-supply = <&camera_avdd_2v8>;
+			vddd-supply = <&camera_dvdd_1v2>;
+
+			port {
+				ov5645_ep: endpoint {
+					clock-lanes = <1>;
+					data-lanes = <0 2>;
+					remote-endpoint = <&csi0_ep>;
+				};
+			};
+		};
+	};
-- 
1.9.1

