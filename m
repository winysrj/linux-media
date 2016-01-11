Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:33608 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbcAKCN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 21:13:26 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v2] rcar_jpu: Add R-Car Gen2 Fallback Compatibility String
Date: Mon, 11 Jan 2016 11:13:20 +0900
Message-Id: <1452478400-4267-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add fallback compatibility string.
This is in keeping with the fallback scheme being adopted wherever
appropriate for drivers for Renesas SoCs.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

---
v2
* Make fallback compat string for R-Car Gen2 rather than all renesas
  hardware: that seems too generic
---
 Documentation/devicetree/bindings/media/renesas,jpu.txt | 13 +++++++------
 drivers/media/platform/rcar_jpu.c                       |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,jpu.txt b/Documentation/devicetree/bindings/media/renesas,jpu.txt
index 0cb94201bf92..d3436e5190f9 100644
--- a/Documentation/devicetree/bindings/media/renesas,jpu.txt
+++ b/Documentation/devicetree/bindings/media/renesas,jpu.txt
@@ -5,11 +5,12 @@ and decoding function conforming to the JPEG baseline process, so that the JPU
 can encode image data and decode JPEG data quickly.
 
 Required properties:
-  - compatible: should containg one of the following:
-			- "renesas,jpu-r8a7790" for R-Car H2
-			- "renesas,jpu-r8a7791" for R-Car M2-W
-			- "renesas,jpu-r8a7792" for R-Car V2H
-			- "renesas,jpu-r8a7793" for R-Car M2-N
+- compatible: "renesas,jpu-<soctype>", "renesas,rcar-gen2-jpu" as fallback.
+	Examples with soctypes are:
+	  - "renesas,jpu-r8a7790" for R-Car H2
+	  - "renesas,jpu-r8a7791" for R-Car M2-W
+	  - "renesas,jpu-r8a7792" for R-Car V2H
+	  - "renesas,jpu-r8a7793" for R-Car M2-N
 
   - reg: Base address and length of the registers block for the JPU.
   - interrupts: JPU interrupt specifier.
@@ -17,7 +18,7 @@ Required properties:
 
 Example: R8A7790 (R-Car H2) JPU node
 	jpeg-codec@fe980000 {
-		compatible = "renesas,jpu-r8a7790";
+		compatible = "renesas,jpu-r8a7790", "renesas,rcar-gen2-jpu";
 		reg = <0 0xfe980000 0 0x10300>;
 		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index f8e3e83c52a2..4caae52d9864 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1611,6 +1611,7 @@ static const struct of_device_id jpu_dt_ids[] = {
 	{ .compatible = "renesas,jpu-r8a7791" }, /* M2-W */
 	{ .compatible = "renesas,jpu-r8a7792" }, /* V2H */
 	{ .compatible = "renesas,jpu-r8a7793" }, /* M2-N */
+	{ .compatible = "renesas,rcar-gen2-jpu" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, jpu_dt_ids);
-- 
2.7.0.rc3.207.g0ac5344

