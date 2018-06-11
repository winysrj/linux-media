Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:46569 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbeFKPRy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 11:17:54 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, robh@kernel.org, devicetree@vger.kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: media: i2c: Document MT9V111 bindings
Date: Mon, 11 Jun 2018 17:17:32 +0200
Message-Id: <1528730253-25135-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for Aptina MT9V111 image sensor.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 .../bindings/media/i2c/aptina,mt9v111.txt          | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt b/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
new file mode 100644
index 0000000..bac4bf0
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
@@ -0,0 +1,46 @@
+* Aptina MT9V111 CMOS sensor
+----------------------------
+
+The Aptina MT9V111 is a 1/4-Inch VGA-format digital image sensor with a core
+based on Aptina MT9V011 sensor and an integrated Image Flow Processor (IFP).
+
+The sensor has an active pixel array of 649x489 pixels and can output a number
+of image resolution and formats controllable through a simple two-wires
+interface.
+
+Required properties:
+--------------------
+
+- compatible: shall be "aptina,mt9v111".
+- clocks: reference to the system clock input provider.
+
+Optional properties:
+--------------------
+
+- enable-gpios: output enable signal, pin name "OE#". Active low.
+- standby-gpios: low power state control signal, pin name "STANDBY".
+  Active high.
+- reset-gpios: chip reset signal, pin name "RESET#". Active low.
+
+The device node must contain one 'port' child node with one 'endpoint' child
+sub-node for its digital output video port, in accordance with the video
+interface bindings defined in:
+Documentation/devicetree/bindings/media/video-interfaces.txt
+
+Example:
+--------
+
+        &i2c1 {
+                camera@48 {
+                        compatible = "aptina,mt9v111";
+                        reg = <0x48>;
+
+                        clocks = <&camera_clk>;
+
+                        port {
+                                mt9v111_out: endpoint {
+                                        remote-endpoint = <&ceu_in>;
+                                };
+                        };
+                };
+        };
--
2.7.4
