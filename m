Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34555 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbcF3Qui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 12:50:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id 187so24376788wmz.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 09:50:37 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com, robh+dt@kernel.org,
	mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kieran@ksquared.org.uk
Subject: [PATCH v2 3/3] dt-bindings: Add Renesas R-Car FDP1 bindings
Date: Thu, 30 Jun 2016 17:50:30 +0100
Message-Id: <1467305430-25660-4-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1467305430-25660-1-git-send-email-kieran@bingham.xyz>
References: <1467305430-25660-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FDP1 is a de-interlacing module which converts interlaced video to
progressive video. It is also capable of performing pixel format conversion
between YCbCr/YUV formats and RGB formats.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
Changes since v1:
 - title fixed
 - Interrupts property documented
 - version specific compatibles removed as we have a hw version register
 - label removed from device node example
   * (fdp1 is not referenced by other nodes)

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
2.7.4

