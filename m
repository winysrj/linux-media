Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:22526 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdIUOvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:51:38 -0400
To: Sean Young <sean@mess.org>, Mans Rullgard <mans@mansr.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Subject: [PATCH v3 1/2] media: dt: bindings: Add binding for tango HW IR
 decoder
Message-ID: <0e433f1b-ec16-5fce-ab21-085f69e266ce@free.fr>
Date: Thu, 21 Sep 2017 16:47:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT binding for the HW IR decoder embedded in SMP86xx/SMP87xx.

Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
---
 .../devicetree/bindings/media/tango-ir.txt          | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/tango-ir.txt

diff --git a/Documentation/devicetree/bindings/media/tango-ir.txt b/Documentation/devicetree/bindings/media/tango-ir.txt
new file mode 100644
index 000000000000..a9f00c2bf897
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/tango-ir.txt
@@ -0,0 +1,21 @@
+Sigma Designs Tango IR NEC/RC-5/RC-6 decoder (SMP86xx and SMP87xx)
+
+Required properties:
+
+- compatible: "sigma,smp8642-ir"
+- reg: address/size of NEC+RC5 area, address/size of RC6 area
+- interrupts: spec for IR IRQ
+- clocks: spec for IR clock (typically the crystal oscillator)
+
+Optional properties:
+
+- linux,rc-map-name: see Documentation/devicetree/bindings/media/rc.txt
+
+Example:
+
+	ir@10518 {
+		compatible = "sigma,smp8642-ir";
+		reg = <0x10518 0x18>, <0x105e0 0x1c>;
+		interrupts = <21 IRQ_TYPE_EDGE_RISING>;
+		clocks = <&xtal>;
+	};
-- 
2.11.0
