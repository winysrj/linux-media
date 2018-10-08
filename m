Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:35432 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbeJIEZv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 00:25:51 -0400
From: Vladimir Zapolskiy <vz@mleia.com>
To: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sandeep Jain <Sandeep_Jain@mentor.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI DS90Ux9xx ICs
Date: Tue,  9 Oct 2018 00:11:59 +0300
Message-Id: <20181008211205.2900-2-vz@mleia.com>
In-Reply-To: <20181008211205.2900-1-vz@mleia.com>
References: <20181008211205.2900-1-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sandeep Jain <Sandeep_Jain@mentor.com>

The change adds device tree binding description of TI DS90Ux9xx
series of serializer and deserializer controllers which support video,
audio and control data transmission over FPD-III Link connection.

Signed-off-by: Sandeep Jain <Sandeep_Jain@mentor.com>
[vzapolskiy: various updates and corrections of secondary importance]
Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
---
 .../devicetree/bindings/mfd/ti,ds90ux9xx.txt  | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt

diff --git a/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
new file mode 100644
index 000000000000..0733da88f7ef
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx.txt
@@ -0,0 +1,66 @@
+Texas Instruments DS90Ux9xx de-/serializer controllers
+
+Required properties:
+- compatible: Must contain a generic "ti,ds90ux9xx" value and
+	may contain one more specific value from the list:
+	"ti,ds90ub925q",
+	"ti,ds90uh925q",
+	"ti,ds90ub927q",
+	"ti,ds90uh927q",
+	"ti,ds90ub926q",
+	"ti,ds90uh926q",
+	"ti,ds90ub928q",
+	"ti,ds90uh928q",
+	"ti,ds90ub940q",
+	"ti,ds90uh940q".
+
+Optional properties:
+- reg : Specifies the I2C slave address of a local de-/serializer.
+- power-gpios : GPIO line to control supplied power to the device.
+- ti,backward-compatible-mode : Overrides backward compatibility mode.
+	Possible values are "<1>" or "<0>".
+	If "ti,backward-compatible-mode" is not mentioned, the backward
+	compatibility mode is not touched and given by hardware pin strapping.
+- ti,low-frequency-mode : Overrides low frequency mode.
+	Possible values are "<1>" or "<0>".
+	If "ti,low-frequency-mode" is not mentioned, the low frequency mode
+	is not touched and given by hardware pin strapping.
+- ti,video-map-select-msb: Sets video bridge pins to MSB mode, if it is set
+	MAPSEL pin value is ignored.
+- ti,video-map-select-lsb: Sets video bridge pins to LSB mode, if it is set
+	MAPSEL pin value is ignored.
+- ti,pixel-clock-edge : Selects Pixel Clock Edge.
+	Possible values are "<1>" or "<0>".
+	If "ti,pixel-clock-edge" is High <1>, output data is strobed on the
+	Rising edge of the PCLK. If ti,pixel-clock-edge is Low <0>, data is
+	strobed on the Falling edge of the PCLK.
+	If "ti,pixel-clock-edge" is not mentioned, the pixel clock edge
+	value is not touched and given by hardware pin strapping.
+- ti,spread-spectrum-clock-generation : Spread Sprectrum Clock Generation.
+	Possible values are from "<0>" to "<7>". The same value will be
+	written to SSC register. If "ti,spread-spectrum-clock-gen" is not
+	found, then SSCG will be disabled.
+
+TI DS90Ux9xx serializers and deserializer device nodes may contain a number
+of children device nodes to describe and enable particular subcomponents
+found on ICs.
+
+Example:
+
+serializer: serializer@c {
+	compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
+	reg = <0xc>;
+	power-gpios = <&gpio5 12 GPIO_ACTIVE_HIGH>;
+	ti,backward-compatible-mode = <0>;
+	ti,low-frequency-mode = <0>;
+	ti,pixel-clock-edge = <0>;
+	...
+}
+
+deserializer: deserializer@3c {
+	compatible = "ti,ds90ub940q", "ti,ds90ux9xx";
+	reg = <0x3c>;
+	power-gpios = <&gpio6 31 GPIO_ACTIVE_HIGH>;
+	...
+}
+
-- 
2.17.1
