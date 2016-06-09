Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36599 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbcFINlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 09:41:42 -0400
Received: by mail-wm0-f67.google.com with SMTP id m124so10779107wme.3
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 06:41:42 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Kieran Bingham <kieran@ksquared.org.uk>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	linux-media@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS - FDP1),
	linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
	- FDP1),
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
	DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] dt-bindings: Add Renesas R-Car FDP1 bindings
Date: Thu,  9 Jun 2016 14:41:34 +0100
Message-Id: <1465479695-18644-4-git-send-email-kieran@bingham.xyz>
In-Reply-To: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FDP1 is a de-interlacing module which converts interlaced video to
progressive video. It is also capable of performing pixel format conversion
between YCbCr/YUV formats and RGB formats.

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 .../devicetree/bindings/media/renesas,fdp1.txt     | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fdp1.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,fdp1.txt b/Documentation/devicetree/bindings/media/renesas,fdp1.txt
new file mode 100644
index 000000000000..e2da2aec5e9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,fdp1.txt
@@ -0,0 +1,34 @@
+Renesas R-Car Fine Display Processor (FDP1)
+-----------------------------------------------
+
+The FDP1 is a de-interlacing module which converts interlaced video to
+progressive video. It is capable of performing pixel format conversion between
+YCbCr/YUV formats and RGB formats. Only YCbCr/YUV formats are supported as
+an input to the module.
+
+ - compatible: Must be one or more of the following
+
+   - "renesas,r8a7795-fdp1" for R8A7795 (R-Car H3)
+   - "renesas,r8a7796-fdp1" for R8A7796 (R-Car M3-W)
+   - "renesas,fdp1" for generic compatible
+
+   When compatible with the generic version, nodes must list the
+   SoC-specific version corresponding to the platform first, followed by the
+   family-specific and/or generic versions.
+
+ - reg: the register base and size for the device registers
+ - clocks: Reference to the functional clock
+ - renesas,fcp: Reference to the FCPF connected to the FDP1
+
+
+Device node example
+-------------------
+
+	fdp1ch1: fdp1@fe940000 {
+		compatible = "renesas,r8a7795-fdp1", "renesas,fdp1";
+		reg = <0 0xfe940000 0 0x2400>;
+		interrupts = <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cpg CPG_MOD 119>;
+		power-domains = <&sysc R8A7795_PD_A3VP>;
+		renesas,fcp = <&fcpf0>;
+	};
\ No newline at end of file
-- 
2.7.4

