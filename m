Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34265 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdGGJwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:52:06 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 5/6] [media] dt-bindings: gpio-ir-tx: add support for GPIO IR Transmitter
Date: Fri,  7 Jul 2017 10:52:03 +0100
Message-Id: <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
In-Reply-To: <cover.1499419624.git.sean@mess.org>
References: <cover.1499419624.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the device tree bindings for the GPIO Bit Banging IR
Transmitter.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt

diff --git a/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
new file mode 100644
index 0000000..bc08d89
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
@@ -0,0 +1,11 @@
+Device tree bindings for IR LED connected through gpio pin which is used as
+remote controller transmitter.
+
+Required properties:
+	- compatible: should be "gpio-ir-tx".
+
+Example:
+	irled@0 {
+		compatible = "gpio-ir-tx";
+		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
+	};
-- 
2.9.4
