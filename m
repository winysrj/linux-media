Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:55931 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387925AbeGWJaU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 05:30:20 -0400
Subject: [PATCHv2 1/5] cec-gpio.txt: add v5-gpios for testing the 5V line
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180717132909.92158-1-hverkuil@xs4all.nl>
 <20180717132909.92158-2-hverkuil@xs4all.nl>
 <20180720180530.GA21569@rob-hp-laptop>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <edfab202-743e-8b9a-332c-18cedf8fc64d@xs4all.nl>
Date: Mon, 23 Jul 2018 10:30:14 +0200
MIME-Version: 1.0
In-Reply-To: <20180720180530.GA21569@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to debug the HDMI 5V line we need to add a new v5-gpios
property.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
Changes since v1:
- Document that hpd-gpios and 5v-gpios are meant for debugging those lines.
---
 .../devicetree/bindings/media/cec-gpio.txt    | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
index 12fcd55ed153..47e8d73d32a3 100644
--- a/Documentation/devicetree/bindings/media/cec-gpio.txt
+++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
@@ -4,8 +4,8 @@ The HDMI CEC GPIO module supports CEC implementations where the CEC line
 is hooked up to a pull-up GPIO line and - optionally - the HPD line is
 hooked up to another GPIO line.

-Please note: the maximum voltage for the CEC line is 3.63V, for the HPD
-line it is 5.3V. So you may need some sort of level conversion circuitry
+Please note: the maximum voltage for the CEC line is 3.63V, for the HPD and
+5V lines it is 5.3V. So you may need some sort of level conversion circuitry
 when connecting them to a GPIO line.

 Required properties:
@@ -19,18 +19,24 @@ following property is also required:
   - hdmi-phandle - phandle to the HDMI controller, see also cec.txt.

 If the CEC line is not associated with an HDMI receiver/transmitter, then
-the following property is optional:
+the following property is optional and can be used for debugging HPD changes:

   - hpd-gpios: gpio that the HPD line is connected to.

+This property is optional and can be used for debugging changes on the 5V line:
+
+  - v5-gpios: gpio that the 5V line is connected to.
+
 Example for the Raspberry Pi 3 where the CEC line is connected to
-pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
-connected to pin 11 aka BCM17 (some level shifter is needed for this!):
+pin 26 aka BCM7 aka CE1 on the GPIO pin header, the HPD line is
+connected to pin 11 aka BCM17 and the 5V line is connected to pin
+15 aka BCM22 (some level shifter is needed for the HPD and 5V lines!):

 #include <dt-bindings/gpio/gpio.h>

 cec-gpio {
-       compatible = "cec-gpio";
-       cec-gpios = <&gpio 7 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
-       hpd-gpios = <&gpio 17 GPIO_ACTIVE_HIGH>;
+	compatible = "cec-gpio";
+	cec-gpios = <&gpio 7 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
+	hpd-gpios = <&gpio 17 GPIO_ACTIVE_HIGH>;
+	v5-gpios = <&gpio 22 GPIO_ACTIVE_HIGH>;
 };
-- 
2.18.0
