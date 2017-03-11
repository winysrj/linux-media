Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46829 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755616AbdCKLXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:23:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 01/16] ov7670: document device tree bindings
Date: Sat, 11 Mar 2017 12:23:13 +0100
Message-Id: <20170311112328.11802-2-hverkuil@xs4all.nl>
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add binding documentation and add that file to the MAINTAINERS entry.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../devicetree/bindings/media/i2c/ov7670.txt       | 43 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
new file mode 100644
index 000000000000..826b6563b009
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
@@ -0,0 +1,43 @@
+* Omnivision OV7670 CMOS sensor
+
+The Omnivision OV7670 sensor supports multiple resolutions output, such as
+CIF, SVGA, UXGA. It also can support the YUV422/420, RGB565/555 or raw RGB
+output formats.
+
+Required Properties:
+- compatible: should be "ovti,ov7670"
+- clocks: reference to the xclk input clock.
+- clock-names: should be "xclk".
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the resetb pin, if any.
+  Active is low.
+- powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
+  Active is high.
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	i2c1: i2c@f0018000 {
+		ov7670: camera@21 {
+			compatible = "ovti,ov7670";
+			reg = <0x21>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
+			reset-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
+			powerdown-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
+			clocks = <&pck0>;
+			clock-names = "xclk";
+			assigned-clocks = <&pck0>;
+			assigned-clock-rates = <25000000>;
+
+			port {
+				ov7670_0: endpoint {
+					remote-endpoint = <&isi_0>;
+				};
+			};
+		};
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index 83a42ef1d1a7..93500928ca4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9273,6 +9273,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/ov7670.c
+F:	Documentation/devicetree/bindings/media/i2c/ov7670.txt
 
 ONENAND FLASH DRIVER
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-- 
2.11.0
