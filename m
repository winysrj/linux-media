Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33499 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbeDGPsy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 11:48:54 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 5/6] media: ov772x: add device tree binding
Date: Sun,  8 Apr 2018 00:48:09 +0900
Message-Id: <1523116090-13101-6-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
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
 .../devicetree/bindings/media/i2c/ov772x.txt       | 36 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
new file mode 100644
index 0000000..9b0df3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
@@ -0,0 +1,36 @@
+* Omnivision OV7720/OV7725 CMOS sensor
+
+Required Properties:
+- compatible: shall be one of
+	"ovti,ov7720"
+	"ovti,ov7725"
+- clocks: reference to the xclk input clock.
+- clock-names: shall be "xclk".
+
+Optional Properties:
+- rstb-gpios: reference to the GPIO connected to the RSTB pin, if any.
+- pwdn-gpios: reference to the GPIO connected to the PWDN pin, if any.
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
+		rstb-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_LOW>;
+		pwdn-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_LOW>;
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
index 7e48624..3e0224a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10295,6 +10295,7 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/i2c/ov772x.c
 F:	include/media/i2c/ov772x.h
+F:	Documentation/devicetree/bindings/media/i2c/ov772x.txt
 
 OMNIVISION OV7740 SENSOR DRIVER
 M:	Wenyou Yang <wenyou.yang@microchip.com>
-- 
2.7.4
