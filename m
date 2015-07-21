Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36518 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647AbbGUCBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 22:01:34 -0400
Received: by lagw2 with SMTP id w2so108001011lag.3
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 19:01:32 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	mchehab@osg.samsung.com
Cc: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH v3 2/3] devicetree: bindings: Document Renesas R-Car JPEG  Processing Unit
Date: Tue, 21 Jul 2015 05:00:21 +0300
Message-Id: <1437444022-28916-3-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Renesas R-Car JPEG processing unit driver device tree bindings 
documentation.

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
Changes since v2:
 - remove generic "renesas,jpu-gen2" descriptor

Changes since v1:
 - Fix typos

 .../devicetree/bindings/media/renesas,jpu.txt      | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,jpu.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,jpu.txt b/Documentation/devicetree/bindings/media/renesas,jpu.txt
new file mode 100644
index 0000000..0cb9420
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,jpu.txt
@@ -0,0 +1,24 @@
+* Renesas JPEG Processing Unit
+
+The JPEG processing unit (JPU) incorporates the JPEG codec with an encoding
+and decoding function conforming to the JPEG baseline process, so that the JPU
+can encode image data and decode JPEG data quickly.
+
+Required properties:
+  - compatible: should containg one of the following:
+			- "renesas,jpu-r8a7790" for R-Car H2
+			- "renesas,jpu-r8a7791" for R-Car M2-W
+			- "renesas,jpu-r8a7792" for R-Car V2H
+			- "renesas,jpu-r8a7793" for R-Car M2-N
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
2.1.4

