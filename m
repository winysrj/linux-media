Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:35472 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbeJIEZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 00:25:53 -0400
From: Vladimir Zapolskiy <vz@mleia.com>
To: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: [PATCH 3/7] dt-bindings: pinctrl: ds90ux9xx: add description of TI DS90Ux9xx pinmux
Date: Tue,  9 Oct 2018 00:12:01 +0300
Message-Id: <20181008211205.2900-4-vz@mleia.com>
In-Reply-To: <20181008211205.2900-1-vz@mleia.com>
References: <20181008211205.2900-1-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>

TI DS90Ux9xx de-/serializers have a capability to multiplex pin functions,
in particular a pin may have selectable functions of GPIO, GPIO line
transmitter, one of I2S lines, one of RGB24 video signal lines and so on.

The change adds a description of DS90Ux9xx pin multiplexers and GPIO
controllers.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
---
 .../bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt
new file mode 100644
index 000000000000..fbfa1a3cdf9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/ti,ds90ux9xx-pinctrl.txt
@@ -0,0 +1,83 @@
+TI DS90Ux9xx de-/serializer pinmux and GPIO subcontroller
+
+Required properties:
+- compatible: Must contain a generic "ti,ds90ux9xx-pinctrl" value and
+	may contain one more specific value from the list:
+	"ti,ds90ux925-pinctrl",
+	"ti,ds90ux926-pinctrl",
+	"ti,ds90ux927-pinctrl",
+	"ti,ds90ux928-pinctrl",
+	"ti,ds90ux940-pinctrl".
+
+- gpio-controller: Marks the device node as a GPIO controller.
+
+- #gpio-cells: Must be set to 2,
+	- the first cell is the GPIO offset number within the controller,
+	- the second cell is used to specify the GPIO line polarity.
+
+- gpio-ranges: Mapping to pin controller pins (as described in
+	Documentation/devicetree/bindings/gpio/gpio.txt)
+
+Optional properties:
+- ti,video-depth-18bit: Sets video bridge pins to RGB 18-bit mode.
+
+Available pins, groups and functions (reference to device datasheets):
+
+function: "gpio" ("gpio4" is on DS90Ux925 and DS90Ux926 only,
+		  "gpio9" is on DS90Ux940 only)
+ - pins: "gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6",
+	 "gpio7", "gpio8", "gpio9"
+
+function: "gpio-remote"
+ - pins: "gpio0", "gpio1", "gpio2", "gpio3"
+
+function: "pass" (DS90Ux940 specific only)
+ - pins: "gpio0", "gpio3"
+
+function: "i2s-1"
+ - group: "i2s-1"
+
+function: "i2s-2"
+ - group: "i2s-2"
+
+function: "i2s-3" (DS90Ux927, DS90Ux928 and DS90Ux940 specific only)
+ - group: "i2s-3"
+
+function: "i2s-4" (DS90Ux927, DS90Ux928 and DS90Ux940 specific only)
+ - group: "i2s-4"
+
+function: "i2s-m" (DS90Ux928 and DS90Ux940 specific only)
+ - group: "i2s-m"
+
+function: "parallel" (DS90Ux925 and DS90Ux926 specific only)
+ - group: "parallel"
+
+Example (deserializer with pins GPIO[3:0] set to bridged output
+	 function and pin GPIO4 in standard hogged GPIO function):
+
+deserializer {
+	compatible = "ti,ds90ub928q", "ti,ds90ux9xx";
+
+	ds90ux928_pctrl: pin-controller {
+		compatible = "ti,ds90ux928-pinctrl", "ti,ds90ux9xx-pinctrl";
+		gpio-controller;
+		#gpio-cells = <2>;
+		gpio-ranges = <&ds90ux928_pctrl 0 0 8>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&ds90ux928_pins>;
+
+		ds90ux928_pins: pinmux {
+			gpio-remote {
+				pins = "gpio0", "gpio1", "gpio2", "gpio3";
+				function = "gpio-remote";
+			};
+		};
+
+		rst {
+			gpio-hog;
+			gpios = <4 GPIO_ACTIVE_HIGH>;
+			output-high;
+		};
+	};
+};
-- 
2.17.1
