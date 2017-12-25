Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:37976 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752794AbdLYOLl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Dec 2017 09:11:41 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH 4/4] [media] dt/bindings: Add bindings for OV2685
Date: Mon, 25 Dec 2017 22:11:26 +0800
Message-Id: <1514211086-13440-4-git-send-email-zhengsq@rock-chips.com>
In-Reply-To: <1514211086-13440-1-git-send-email-zhengsq@rock-chips.com>
References: <1514211086-13440-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the OV2685 sensor.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 .../devicetree/bindings/media/i2c/ov2685.txt       | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2685.txt b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
new file mode 100644
index 0000000..c62db9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
@@ -0,0 +1,35 @@
+* Omnivision OV2685 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: should be "ovti,ov2685"
+- clocks: reference to the 24M xvclk input clock.
+- clock-names: should be "xvclk".
+- avdd-supply: Analog voltage supply, 2.8 volts
+- dvdd-supply: Digital core voltage supply, 1.2 volts
+- reset-gpios: Low active reset gpio
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	ucam: ov2680@3c {
+		compatible = "ovti,ov2685";
+		reg = <0x3c>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&clk_24m_cam &ucam_rst>;
+
+		clocks = <&cru SCLK_TESTCLKOUT1>;
+		clock-names = "xvclk";
+
+		avdd-supply = <&pp2800_cam>;
+		dovdd-supply = <&pp1800>;
+		reset-gpios = <&gpio2 3 GPIO_ACTIVE_LOW>;
+
+		port {
+			ucam_out: endpoint {
+				remote-endpoint = <&mipi_in_ucam>;
+				data-lanes = <1>;
+			};
+		};
+	};
-- 
1.9.1
