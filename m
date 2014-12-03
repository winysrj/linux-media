Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26701 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaLCQHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 11:07:50 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	devicetree@vger.kernel.org
Subject: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim max77693
Date: Wed, 03 Dec 2014 17:06:41 +0100
Message-id: <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree binding documentation for
the flash cell of the Maxim max77693 multifunctional device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   89 ++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 01e9f30..25a6e78 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -41,7 +41,66 @@ Optional properties:
 	 To get more informations, please refer to documentaion.
 	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
 
+- led : the LED submodule device node
+
+There are two led outputs available - fled1 and fled2. Each of them can
+control a separate led or they can be connected together to double
+the maximum current for a single connected led. One led is represented
+by one child node.
+
+Required properties:
+- compatible : Must be "maxim,max77693-led".
+
+Optional properties:
+- maxim,fleds : Array of current outputs in order: fled1, fled2.
+	Note: both current outputs can be connected to a single led
+	Possible values:
+		MAX77693_LED_FLED_UNUSED - the output is left disconnected,
+		MAX77693_LED_FLED_USED - a diode is connected to the output.
+- maxim,trigger-type : Array of trigger types in order: flash, torch.
+	Possible trigger types:
+		MAX77693_LED_TRIG_TYPE_EDGE - Rising edge of the signal triggers
+			the flash/torch,
+		MAX77693_LED_TRIG_TYPE_LEVEL - Signal level controls duration of
+			the flash/torch.
+- maxim,trigger : Array of flags indicating which trigger can activate given led
+	in order: fled1, fled2.
+	Possible flag values (can be combined):
+		MAX77693_LED_TRIG_FLASHEN - FLASHEN pin of the chip,
+		MAX77693_LED_TRIG_TORCHEN - TORCHEN pin of the chip,
+		MAX77693_LED_TRIG_SOFTWARE - software via I2C command.
+- maxim,boost-mode :
+	In boost mode the device can produce up to 1.2A of total current
+	on both outputs. The maximum current on each output is reduced
+	to 625mA then. If there are two child led nodes defined then boost
+	is enabled by default.
+	Possible values:
+		MAX77693_LED_BOOST_OFF - no boost,
+		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
+		MAX77693_LED_BOOST_FIXED - fixed mode.
+- maxim,boost-vout : Output voltage of the boost module in millivolts.
+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
+	if chip estimates that system voltage could drop below this level due
+	to flash power consumption.
+
+Required properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+- maxim,fled_id : Identifier of the fled output the led is connected to;
+		MAX77693_LED_FLED1 - FLED1 output of the device - it has to be
+			used also if a single LED is connected to both outputs,
+		MAX77693_LED_FLED2 - FLED2 output of the device.
+
+Optional properties of the LED child node:
+- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 15625 - 250000
+- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 15625 - 1000000
+- flash-timeout-microsec : see Documentation/devicetree/bindings/leds/common.txt
+		Range: 62500 - 1000000
+
 Example:
+#include <dt-bindings/mfd/max77693.h>
+
 	max77693@66 {
 		compatible = "maxim,max77693";
 		reg = <0x66>;
@@ -73,4 +132,34 @@ Example:
 			pwms = <&pwm 0 40000 0>;
 			pwm-names = "haptic";
 		};
+
+		led {
+			compatible = "maxim,max77693-led";
+			maxim,fleds = <MAX77693_LED_FLED_USED
+				       MAX77693_LED_FLED_USED>;
+			maxim,trigger = <MAX77693_LED_TRIG_ALL
+					 (MAX77693_LED_TRIG_TORCHEN |
+					 MAX77693_LED_TRIG_SOFTWARE)>;
+			maxim,trigger-type = <MAX77693_LED_TRIG_TYPE_EDGE
+					      MAX77693_LED_TRIG_TYPE_LEVEL>;
+			maxim,boost-mode = <MAX77693_LED_BOOST_ADAPTIVE>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+
+			camera1_flash: led1 {
+				maxim,fled_id = <MAX77693_LED_FLED1>;
+				label = "max77693-flash1";
+				max-microamp = <250000>;
+				flash-max-microamp = <625000>;
+				flash-timeout-microsec = <1000000>;
+			};
+
+			camera2_flash: led2 {
+				maxim,fled_id = <MAX77693_LED_FLED2>;
+				label = "max77693-flash2";
+				max-microamp = <250000>;
+				flash-max-microamp = <500000>;
+				flash-timeout-microsec = <1000000>;
+			};
+		};
 	};
-- 
1.7.9.5

