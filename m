Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57949 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755341AbdCKLXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:23:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 10/16] ov2640: update bindings
Date: Sat, 11 Mar 2017 12:23:22 +0100
Message-Id: <20170311112328.11802-11-hverkuil@xs4all.nl>
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the bindings for this device based on a working DT example.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../devicetree/bindings/media/i2c/ov2640.txt       | 23 +++++++++-------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
index c429b5bdcaa0..989ce6cb6ac3 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov2640.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
@@ -1,8 +1,8 @@
 * Omnivision OV2640 CMOS sensor
 
-The Omnivision OV2640 sensor support multiple resolutions output, such as
-CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
-output format.
+The Omnivision OV2640 sensor supports multiple resolutions output, such as
+CIF, SVGA, UXGA. It also can support the YUV422/420, RGB565/555 or raw RGB
+output formats.
 
 Required Properties:
 - compatible: should be "ovti,ov2640"
@@ -20,26 +20,21 @@ Documentation/devicetree/bindings/media/video-interfaces.txt.
 Example:
 
 	i2c1: i2c@f0018000 {
-		ov2640: camera@0x30 {
+		ov2640: camera@30 {
 			compatible = "ovti,ov2640";
 			reg = <0x30>;
-
 			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_pck1 &pinctrl_ov2640_pwdn &pinctrl_ov2640_resetb>;
-
-			resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
-			pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
-
-			clocks = <&pck1>;
+			pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
+			resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
+			pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
+			clocks = <&pck0>;
 			clock-names = "xvclk";
-
-			assigned-clocks = <&pck1>;
+			assigned-clocks = <&pck0>;
 			assigned-clock-rates = <25000000>;
 
 			port {
 				ov2640_0: endpoint {
 					remote-endpoint = <&isi_0>;
-					bus-width = <8>;
 				};
 			};
 		};
-- 
2.11.0
