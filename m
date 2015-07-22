Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36849 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934129AbbGVLXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 07:23:43 -0400
Received: by lbbqi7 with SMTP id qi7so54082251lbb.3
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2015 04:23:42 -0700 (PDT)
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
Date: Wed, 22 Jul 2015 14:23:04 +0300
Message-Id: <1437564185-13593-3-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1437564185-13593-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1437564185-13593-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
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

