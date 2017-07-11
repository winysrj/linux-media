Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60265 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753909AbdGKLwo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 07:52:44 -0400
Date: Tue, 11 Jul 2017 12:52:41 +0100
From: Sean Young <sean@mess.org>
To: Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3] [media] dt-bindings: gpio-ir-tx: add support for GPIO IR
 Transmitter
Message-ID: <20170711115241.cprjvqirp7pyuhye@gofer.mess.org>
References: <cover.1499419624.git.sean@mess.org>
 <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
 <20170710150538.ql26gswdf2obch6o@rob-hp-laptop>
 <20170710151016.5iaokchdejxozrte@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170710151016.5iaokchdejxozrte@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the device tree bindings for the GPIO Bit Banging IR
Transmitter.

Signed-off-by: Sean Young <sean@mess.org>
---
 .../devicetree/bindings/leds/irled/gpio-ir-tx.txt          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt

diff --git a/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
new file mode 100644
index 0000000..cbe8dfd
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
@@ -0,0 +1,14 @@
+Device tree bindings for IR LED connected through gpio pin which is used as
+remote controller transmitter.
+
+Required properties:
+	- compatible: should be "gpio-ir-tx".
+	- gpios :  Should specify the IR LED GPIO, see "gpios property" in
+	  Documentation/devicetree/bindings/gpio/gpio.txt.  Active low LEDs
+	  should be indicated using flags in the GPIO specifier.
+
+Example:
+	irled@0 {
+		compatible = "gpio-ir-tx";
+		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
+	};
-- 
2.9.4
