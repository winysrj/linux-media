Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44088 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752488AbcLLPz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/15] ov2640 bindings update
Date: Mon, 12 Dec 2016 16:55:17 +0100
Message-Id: <20161212155520.41375-13-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the bindings for this device based on a working DT example.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/i2c/ov2640.txt       | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
index c429b5b..5e6c445 100644
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
@@ -20,20 +20,18 @@ Documentation/devicetree/bindings/media/video-interfaces.txt.
 Example:
 
 	i2c1: i2c@f0018000 {
+		status = "okay";
+
 		ov2640: camera@0x30 {
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
-- 
2.10.2

