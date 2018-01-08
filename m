Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:42591 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932946AbeAHNg2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 08:36:28 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH v3 4/4] dt-bindings: media: Add bindings for OV2685
Date: Mon,  8 Jan 2018 21:36:07 +0800
Message-Id: <1515418567-14406-4-git-send-email-zhengsq@rock-chips.com>
In-Reply-To: <1515418567-14406-1-git-send-email-zhengsq@rock-chips.com>
References: <1515418567-14406-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the OV2685 sensor.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 .../devicetree/bindings/media/i2c/ov2685.txt       | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2685.txt b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
new file mode 100644
index 0000000..f1586a2
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
@@ -0,0 +1,41 @@
+* Omnivision OV2685 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: shall be "ovti,ov2685"
+- clocks: reference to the xvclk input clock
+- clock-names: shall be "xvclk"
+- avdd-supply: Analog voltage supply, 2.8 volts
+- dovdd-supply: Digital I/O voltage supply, 1.8 volts
+- dvdd-supply: Digital core voltage supply, 1.8 volts
+- reset-gpios: Low active reset gpio
+
+The device node shall contain one 'port' child node with an
+'endpoint' subnode for its digital output video port,
+in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+The endpoint optional property 'data-lanes' shall be "<1>".
+
+Example:
+&i2c7 {
+	camera-sensor: ov2685@3c {
+		compatible = "ovti,ov2685";
+		reg = <0x3c>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&clk_24m_cam>;
+
+		clocks = <&cru SCLK_TESTCLKOUT1>;
+		clock-names = "xvclk";
+
+		avdd-supply = <&pp2800_cam>;
+		dovdd-supply = <&pp1800>;
+		dvdd-supply = <&pp1800>;
+		reset-gpios = <&gpio2 3 GPIO_ACTIVE_LOW>;
+
+		port {
+			ucam_out: endpoint {
+				remote-endpoint = <&mipi_in_ucam>;
+				data-lanes = <1>;
+			};
+		};
+	};
+};
-- 
1.9.1
