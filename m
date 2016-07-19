Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbcGSP5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:57:20 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [RFC 6/7] Documentation: bindings: add documentation for ir-spi device
 driver
Date: Wed, 20 Jul 2016 00:56:57 +0900
Message-id: <1468943818-26025-7-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the ir-spi driver's binding which is a IR led driven
through the SPI line.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 Documentation/devicetree/bindings/media/spi-ir.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt

diff --git a/Documentation/devicetree/bindings/media/spi-ir.txt b/Documentation/devicetree/bindings/media/spi-ir.txt
new file mode 100644
index 0000000..532da68
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi-ir.txt
@@ -0,0 +1,20 @@
+Device tree bindings for IR LED connected through SPI bus which is used as
+remote controller.
+
+The IR LED switch is connected to the MOSI line of the SPI device and the data
+are delivered thourgh that.
+
+Required properties:
+	- compatible: should be "ir-spi"
+
+Optional properties:
+	- irled,switch: specifies the gpio switch which enables the irled
+
+Example:
+
+        irled@0 {
+                compatible = "ir-spi";
+                reg = <0x0>;
+                spi-max-frequency = <5000000>;
+                irled,switch = <&gpr3 3 0>;
+        };
-- 
2.8.1

