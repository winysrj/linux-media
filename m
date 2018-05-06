Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35916 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbeEFOTs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 10:19:48 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v5 01/14] media: dt-bindings: ov772x: add device tree binding
Date: Sun,  6 May 2018 23:19:16 +0900
Message-Id: <1525616369-8843-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a device tree binding documentation for OV7720/OV7725 sensor.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh+dt@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v5
- No changes

 .../devicetree/bindings/media/i2c/ov772x.txt       | 40 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
new file mode 100644
index 0000000..0b3ede5
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
@@ -0,0 +1,40 @@
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
+
+		port {
+			ov772x_0: endpoint {
+				remote-endpoint = <&vcap1_in0>;
+			};
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index df6e9bb..cd4c270 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10356,6 +10356,7 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/i2c/ov772x.c
 F:	include/media/i2c/ov772x.h
+F:	Documentation/devicetree/bindings/media/i2c/ov772x.txt
 
 OMNIVISION OV7740 SENSOR DRIVER
 M:	Wenyou Yang <wenyou.yang@microchip.com>
-- 
2.7.4
