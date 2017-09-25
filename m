Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36732 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932656AbdIYMQP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 08:16:15 -0400
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Subject: [PATCH v4 1/2] media: dt: bindings: Add binding for tango HW IR
 decoder
To: Sean Young <sean@mess.org>, Mans Rullgard <mans@mansr.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        DT <devicetree@vger.kernel.org>
Message-ID: <308711ef-0ba8-d533-26fd-51e5b8f32cc8@free.fr>
Date: Mon, 25 Sep 2017 14:02:29 +0200
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
