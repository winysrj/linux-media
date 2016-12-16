Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53758 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759041AbcLPGMv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 01:12:51 -0500
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v5 5/6] Documentation: bindings: add documentation for ir-spi
 device driver
Date: Fri, 16 Dec 2016 15:12:17 +0900
Message-id: <20161216061218.5906-6-andi.shyti@samsung.com>
In-reply-to: <20161216061218.5906-1-andi.shyti@samsung.com>
References: <20161216061218.5906-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the ir-spi driver's binding which is a IR led driven
through the SPI line.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
Reviewed-by: Sean Young <sean@mess.org>
---
 .../devicetree/bindings/leds/irled/spi-ir-led.txt  | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt

diff --git a/Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt b/Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt
new file mode 100644
index 0000000..896b699
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt
@@ -0,0 +1,29 @@
+Device tree bindings for IR LED connected through SPI bus which is used as
+remote controller.
+
+The IR LED switch is connected to the MOSI line of the SPI device and the data
+are delivered thourgh that.
+
+Required properties:
+	- compatible: should be "ir-spi-led".
+
+Optional properties:
+	- duty-cycle: 8 bit balue that represents the percentage of one period
+	  in which the signal is active.  It can be 50, 60, 70, 75, 80 or 90.
+	- led-active-low: boolean value that specifies whether the output is
+	  negated with a NOT gate.
+	- power-supply: specifies the power source. It can either be a regulator
+	  or a gpio which enables a regulator, i.e. a regulator-fixed as
+	  described in
+	  Documentation/devicetree/bindings/regulator/fixed-regulator.txt
+
+Example:
+
+	irled@0 {
+		compatible = "ir-spi-led";
+		reg = <0x0>;
+		spi-max-frequency = <5000000>;
+		power-supply = <&vdd_led>;
+		led-active-low;
+		duty-cycle = /bits/ 8 <60>;
+	};
-- 
2.10.2

