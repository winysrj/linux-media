Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39837 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeEDMtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 08:49:13 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH 1/2] media: dt-bindings: add binding for TI SCAN921226H video deserializer
Date: Fri,  4 May 2018 14:49:02 +0200
Message-Id: <20180504124903.6276-2-jlu@pengutronix.de>
In-Reply-To: <20180504124903.6276-1-jlu@pengutronix.de>
References: <20180504124903.6276-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This deserializer can be used with sensors that directly produce a
10-bit LVDS stream and converts it to a parallel bus.

Controlling it via the optional GPIOs is mainly useful for avoiding
conflicts when another parallel sensor is connected to the same data bus
as the deserializer.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 .../bindings/media/ti,scan921226h.txt         | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,scan921226h.txt

diff --git a/Documentation/devicetree/bindings/media/ti,scan921226h.txt b/Documentation/devicetree/bindings/media/ti,scan921226h.txt
new file mode 100644
index 000000000000..4e475672d7bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,scan921226h.txt
@@ -0,0 +1,59 @@
+TI SCAN921226H Video Deserializer
+---------------------------------
+
+The SCAN921226H receives a LVDS serial data stream with embedded clock and
+converts it to a 10-bit wide parallel data bus and recovers parallel clock.
+Some CMOS sensors such as the ON Semiconductor MT9V024 produce a LVDS signal
+compatible with this deserializer.
+
+Required properties:
+- compatible : should be "ti,scan921226h"
+- #address-cells: should be <1>
+- #size-cells: should be <0>
+- port@0: serial (LVDS) input
+- port@1: parallel output
+
+The device node should contain two 'port' child nodes (one each for input and
+output), in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Optional Properties:
+- enable-gpios: reference to the GPIO connected to the REN (output enable) pin,
+  if any.
+- npwrdn-gpios: reference to the GPIO connected to the nPWRDN pin, if any.
+
+Optionally, #address-cells, #size-cells, and port nodes can be grouped under a
+ports node as described in Documentation/devicetree/bindings/graph.txt.
+
+Example:
+
+      csi0_deserializer: csi0_deserializer {
+              compatible = "ti,scan921226h";
+
+              enable-gpios = <&gpio5 20 GPIO_ACTIVE_HIGH>;
+              npwrdn-gpios = <&gpio1 24 GPIO_ACTIVE_HIGH>;
+
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              /* serial sink interface */
+              port@0 {
+                      reg = <0>;
+
+                      des0_in: endpoint {
+                              remote-endpoint = <&mt9v024_0_out>;
+                      };
+              };
+
+              /* parallel source interface */
+              port@1 {
+                      reg = <1>;
+
+                      des0_out: endpoint {
+                              remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+                              bus-width = <8>;
+                              hsync-active = <1>;
+                              vsync-active = <1>;
+                      };
+              };
+      };
-- 
2.17.0
