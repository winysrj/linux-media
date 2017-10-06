Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:46789 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752187AbdJFMio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 08:38:44 -0400
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
CC: DT <devicetree@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mans Rullgard <mans@mansr.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Subject: [PATCH v8 1/3] media: dt: bindings: Add binding for tango HW IR
 decoder
Message-ID: <3d911a4a-1945-08a7-ae19-0cd0dc6aaacd@sigmadesigns.com>
Date: Fri, 6 Oct 2017 14:23:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
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
2.14.2
