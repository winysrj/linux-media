Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46549 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756588AbcIAV1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 17:27:22 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 6/7] Documentation: bindings: add documentation for ir-spi
 device driver
Date: Fri, 02 Sep 2016 02:16:28 +0900
Message-id: <20160901171629.15422-7-andi.shyti@samsung.com>
In-reply-to: <20160901171629.15422-1-andi.shyti@samsung.com>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the ir-spi driver's binding which is a IR led driven
through the SPI line.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 Documentation/devicetree/bindings/media/spi-ir.txt | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt

diff --git a/Documentation/devicetree/bindings/media/spi-ir.txt b/Documentation/devicetree/bindings/media/spi-ir.txt
new file mode 100644
index 0000000..85cb21b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi-ir.txt
@@ -0,0 +1,26 @@
+Device tree bindings for IR LED connected through SPI bus which is used as
+remote controller.
+
+The IR LED switch is connected to the MOSI line of the SPI device and the data
+are delivered thourgh that.
+
+Required properties:
+	- compatible: should be "ir-spi".
+
+Optional properties:
+	- irled,switch: specifies the gpio switch which enables the irled/
+	- negated: boolean value that specifies whether the output is negated
+	  with a NOT gate.
+	- duty-cycle: 8 bit value that stores the percentage of the duty cycle.
+	  it can be 50, 60, 70, 75, 80 or 90.
+
+Example:
+
+        irled@0 {
+                compatible = "ir-spi";
+                reg = <0x0>;
+                spi-max-frequency = <5000000>;
+                irled,switch = <&gpr3 3 0>;
+		negated;
+		duty-cycle = /bits/ 8 <60>;
+        };
-- 
2.9.3

