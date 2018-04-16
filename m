Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36661 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbeDPCwa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 22:52:30 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 06/10] media: dt-bindings: ov772x: add device tree binding
Date: Mon, 16 Apr 2018 11:51:47 +0900
Message-Id: <1523847111-12986-7-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a device tree binding documentation for OV7720/OV7725 sensor.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Add "dt-bindings:" in the subject
- Add a brief description of the sensor
- Update the GPIO names
- Indicate the GPIO active level

 .../devicetree/bindings/media/i2c/ov772x.txt       | 42 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
new file mode 100644
index 0000000..b045503
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
@@ -0,0 +1,42 @@
+* Omnivision OV7720/OV7725 CMOS sensor
+
+The Omnivision OV7720/OV7725 sensor supports multiple resolutions output,
+such as VGA, QVGA, and any size scaling down from CIF to 40x30. It also can
+support the YUV422, RGB565/555/444, GRB422 or raw RGB output formats.
+
+Required Properties:
+- compatible: shall be one of
+	"ovti,ov7720"
+	"ovti,ov7725"
+- clocks: reference to the xclk input clock.
+- clock-names: shall be "xclk".
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the RSTB pin which is
+  active low, if any.
+- powerdown-gpios: reference to the GPIO connected to the PWDN pin which is
+  active high, if any.
+
+The device node shall contain one 'port' child node with one child 'endpoint'
+subnode for its digital output video port, in accordance with the video
+interface bindings defined in Documentation/devicetree/bindings/media/
+video-interfaces.txt.
+
+Example:
+
+&i2c0 {
+	ov772x: camera@21 {
+		compatible = "ovti,ov7725";
+		reg = <0x21>;
+		reset-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_LOW>;
+		powerdown-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_LOW>;
+		clocks = <&xclk>;
+		clock-names = "xclk";
+
+		port {
+			ov772x_0: endpoint {
+				remote-endpoint = <&vcap1_in0>;
+			};
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 0a1410d..f500953 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10344,6 +10344,7 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/i2c/ov772x.c
 F:	include/media/i2c/ov772x.h
+F:	Documentation/devicetree/bindings/media/i2c/ov772x.txt
 
 OMNIVISION OV7740 SENSOR DRIVER
 M:	Wenyou Yang <wenyou.yang@microchip.com>
-- 
2.7.4
