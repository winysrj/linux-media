Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35896 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbcDWXtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:46 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 01/13] dt-bindings: Add Renesas R-Car FCP DT bindings
Date: Sun, 24 Apr 2016 02:49:48 +0300
Message-Id: <1461455400-28767-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FCP is a companion module of video processing modules in the Renesas
R-Car Gen3 SoCs. It provides data compression and decompression, data
caching, and conversion of AXI transaction in order to reduce the memory
bandwidth.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,fcp.txt      | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt

Cc: devicetree@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
new file mode 100644
index 000000000000..46beec97d625
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
@@ -0,0 +1,31 @@
+Renesas R-Car Frame Compression Processor (FCP)
+-----------------------------------------------
+
+The FCP is a companion module of video processing modules in the Renesas R-Car
+Gen3 SoCs. It provides data compression and decompression, data caching, and
+conversion of AXI transaction in order to reduce the memory bandwidth.
+
+There are three types of FCP whose configuration and behaviour highly depend
+on the module they are paired with.
+
+ - compatible: Must be one or more of the following
+
+   - "renesas,r8a7795-fcpv" for R8A7795 (R-Car H3) compatible 'FCP for VSP'
+   - "renesas,fcpv" for generic compatible 'FCP for VSP'
+
+   When compatible with the generic version, nodes must list the
+   SoC-specific version corresponding to the platform first, followed by the
+   family-specific and/or generic versions.
+
+ - reg: the register base and size for the device registers
+ - clocks: Reference to the functional clock
+
+
+Device node example
+-------------------
+
+	fcpvd1: fcp@fea2f000 {
+		compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
+		reg = <0 0xfea2f000 0 0x200>;
+		clocks = <&cpg CPG_MOD 602>;
+	};
-- 
2.7.3

