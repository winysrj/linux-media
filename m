Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32978 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbeAIOsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:48:41 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH v4 1/5] dt-bindings: media: Add bindings for OV5695
Date: Tue,  9 Jan 2018 22:48:20 +0800
Message-Id: <1515509304-15941-2-git-send-email-zhengsq@rock-chips.com>
In-Reply-To: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
References: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the OV5695 sensor.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 .../devicetree/bindings/media/i2c/ov5695.txt       | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5695.txt b/Documentation/devicetree/bindings/media/i2c/ov5695.txt
new file mode 100644
index 0000000..2f2f698
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5695.txt
@@ -0,0 +1,41 @@
+* Omnivision OV5695 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: shall be "ovti,ov5695"
+- clocks: reference to the xvclk input clock
+- clock-names: shall be "xvclk"
+- avdd-supply: Analog voltage supply, 2.8 volts
+- dovdd-supply: Digital I/O voltage supply, 1.8 volts
+- dvdd-supply: Digital core voltage supply, 1.2 volts
+- reset-gpios: Low active reset gpio
+
+The device node shall contain one 'port' child node with an
+'endpoint' subnode for its digital output video port,
+in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+The endpoint optional property 'data-lanes' shall be "<1 2>".
+
+Example:
+&i2c7 {
+	camera-sensor: ov5695@36 {
+		compatible = "ovti,ov5695";
+		reg = <0x36>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&clk_24m_cam>;
+
+		clocks = <&cru SCLK_TESTCLKOUT1>;
+		clock-names = "xvclk";
+
+		avdd-supply = <&pp2800_cam>;
+		dovdd-supply = <&pp1800>;
+		dvdd-supply = <&pp1250_cam>;
+		reset-gpios = <&gpio2 5 GPIO_ACTIVE_LOW>;
+
+		port {
+			wcam_out: endpoint {
+				remote-endpoint = <&mipi_in_wcam>;
+				data-lanes = <1 2>;
+			};
+		};
+	};
+};
-- 
1.9.1
