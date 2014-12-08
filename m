Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:19872 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaLHLbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:31:47 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>,
	<devicetree@vger.kernel.org>
Subject: [PATCH 5/5] media: ov2640: dt: add the device tree binding document
Date: Mon, 8 Dec 2014 19:29:07 +0800
Message-ID: <1418038147-13221-6-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the document for ov2640 dt.

Cc: devicetree@vger.kernel.org
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v1 -> v2:
  1. change the compatible string to be consistent with verdor file.
  2. change the clock and pins' name.
  3. add missed pinctrl in example.

 .../devicetree/bindings/media/i2c/ov2640.txt       | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
new file mode 100644
index 0000000..15be3cb
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
@@ -0,0 +1,44 @@
+* Omnivision ov2640 CMOS sensor
+
+The Omnivision OV2640 sensor support multiple resolutions output, such as
+CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
+output format.
+
+Required Properties :
+- compatible: Must be "ovti,ov2640"
+- clocks: reference master clock, if using external fixed clock, you
+          no need to have such property.
+- clock-names: Must be "xvclk", it means the master clock for ov2640.
+
+Optional Properties:
+- resetb-gpios: reset pin
+- pwdn-gpios: power down pin
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	i2c1: i2c@f0018000 {
+		ov2640: camera@0x30 {
+			compatible = "ovti,ov2640";
+			reg = <0x30>;
+
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_pck1 &pinctrl_ov2640_pwdn &pinctrl_ov2640_reset>;
+
+			resetb-gpios = <&pioE 24 GPIO_ACTIVE_HIGH>;
+			pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
+
+			clocks = <&pck1>;
+			clock-names = "xvclk";
+
+			port {
+				ov2640_0: endpoint {
+					remote-endpoint = <&isi_0>;
+					bus-width = <8>;
+				};
+			};
+		};
+	};
-- 
1.9.1

