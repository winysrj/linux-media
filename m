Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52730 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936515AbcJXJDv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:03:51 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v4 2/4] dt-bindings: Add Renesas R-Car FDP1 bindings
Date: Mon, 24 Oct 2016 12:03:36 +0300
Message-Id: <1477299818-31935-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

The FDP1 is a de-interlacing module which converts interlaced video to
progressive video. It is also capable of performing pixel format conversion
between YCbCr/YUV formats and RGB formats.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,fdp1.txt     | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fdp1.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,fdp1.txt b/Documentation/devicetree/bindings/media/renesas,fdp1.txt
new file mode 100644
index 000000000000..e6abd2a17e66
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,fdp1.txt
@@ -0,0 +1,33 @@
+Renesas R-Car Fine Display Processor (FDP1)
+-------------------------------------------
+
+The FDP1 is a de-interlacing module which converts interlaced video to
+progressive video. It is capable of performing pixel format conversion between
+YCbCr/YUV formats and RGB formats. Only YCbCr/YUV formats are supported as
+an input to the module.
+
+ - compatible: Must be the following
+
+   - "renesas,fdp1" for generic compatible
+
+ - reg: the register base and size for the device registers
+ - interrupts : interrupt specifier for the FDP1 instance
+ - clocks: reference to the functional clock
+ - renesas,fcp: reference to the FCPF connected to the FDP1
+
+Optional properties:
+ - power-domains : power-domain property defined with a power domain specifier
+                            to respective power domain.
+
+
+Device node example
+-------------------
+
+	fdp1@fe940000 {
+		compatible = "renesas,fdp1";
+		reg = <0 0xfe940000 0 0x2400>;
+		interrupts = <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cpg CPG_MOD 119>;
+		power-domains = <&sysc R8A7795_PD_A3VP>;
+		renesas,fcp = <&fcpf0>;
+	};
-- 
Regards,

Laurent Pinchart

