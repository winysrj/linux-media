Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56999 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751906AbdGGJwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:52:06 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 6/6] [media] dt-bindings: pwm-ir-tx: Add support for PWM IR Transmitter
Date: Fri,  7 Jul 2017 10:52:04 +0100
Message-Id: <e18cec2d3f66cd59d8683cb07fc59e3a2086cf6e.1499419624.git.sean@mess.org>
In-Reply-To: <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
References: <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
In-Reply-To: <cover.1499419624.git.sean@mess.org>
References: <cover.1499419624.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the device tree bindings for the PWM IR Transmitter.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt

diff --git a/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
new file mode 100644
index 0000000..66e5672
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
@@ -0,0 +1,13 @@
+Device tree bindings for IR LED connected through pwm pin which is used as
+remote controller transmitter.
+
+Required properties:
+	- compatible: should be "pwm-ir-tx".
+	- pwms : PWM property to point to the PWM device (phandle)/port (id)
+	  and to specify the period time to be used: <&phandle id period_ns>;
+
+Example:
+	irled {
+		compatible = "pwm-ir-tx";
+		pwms = <&pwm0 0 10000000>;
+	};
-- 
2.9.4
