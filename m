Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:63300 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaHYMfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 08:35:43 -0400
Received: by mail-la0-f42.google.com with SMTP id pv20so12823133lab.15
        for <linux-media@vger.kernel.org>; Mon, 25 Aug 2014 05:35:42 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: horms@verge.net.au, magnus.damm@gmail.com, m.chehab@samsung.com,
	robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk
Cc: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH v2 6/6] devicetree: bindings: Document Renesas JPEG Processing Unit.
Date: Mon, 25 Aug 2014 16:35:32 +0400
Message-Id: <1408970132-6690-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation for Renesas JPU devicetree node.

Changes since v1:
        - First line typo fixed
        - "renesas,jpu-gen2" compatability option added

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 .../devicetree/bindings/media/renesas,jpu.txt      | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,jpu.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,jpu.txt b/Documentation/devicetree/bindings/media/renesas,jpu.txt
new file mode 100644
index 0000000..44b07df
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,jpu.txt
@@ -0,0 +1,24 @@
+* Renesas JPEG processing unit.
+
+The JPEG processing unit (JPU) incorporates the JPEG codec with an encoding
+and decoding function conforming to the JPEG baseline process, so that the JPU
+can encode image data and decode JPEG data quickly.
+It can be found in the Renesas R-Car second generation SoCs.
+
+Required properties:
+  - compatible: should containg one of the following:
+			- "renesas,jpu-r8a7790" for R-Car H2
+			- "renesas,jpu-r8a7791" for R-Car M2
+			- "renesas,jpu-gen2" for R-Car second generation
+
+  - reg: Base address and length of the registers block for the JPU.
+  - interrupts: JPU interrupt specifier.
+  - clocks: A phandle + clock-specifier pair for the JPU functional clock.
+
+Example: R8A7790 (R-Car H2) JPU node
+	jpeg-codec@fe980000 {
+		compatible = "renesas,jpu-r8a7790";
+		reg = <0 0xfe980000 0 0x10300>;
+		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
+	};
-- 
2.1.0.rc1

