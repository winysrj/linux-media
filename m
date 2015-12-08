Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44558 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbbLHFmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 00:42:33 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH] rcar_jpu: add fallback compatibility string
Date: Tue,  8 Dec 2015 14:42:29 +0900
Message-Id: <1449553349-20458-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add fallback compatibility string.
This is in keeping with the fallback scheme being adopted wherever
appropriate for drivers for Renesas SoCs.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 Documentation/devicetree/bindings/media/renesas,jpu.txt | 13 +++++++------
 drivers/media/platform/rcar_jpu.c                       |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,jpu.txt b/Documentation/devicetree/bindings/media/renesas,jpu.txt
index 0cb94201bf92..c96de75f0089 100644
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
+- compatible: "renesas,jpu-<soctype>", "renesas,jpu" as fallback.
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
+		compatible = "renesas,jpu-r8a7790", "renesas,jpu";
 		reg = <0 0xfe980000 0 0x10300>;
 		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index f8e3e83c52a2..53cec95abb08 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1611,6 +1611,7 @@ static const struct of_device_id jpu_dt_ids[] = {
 	{ .compatible = "renesas,jpu-r8a7791" }, /* M2-W */
 	{ .compatible = "renesas,jpu-r8a7792" }, /* V2H */
 	{ .compatible = "renesas,jpu-r8a7793" }, /* M2-N */
+	{ .compatible = "renesas,jpu" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, jpu_dt_ids);
-- 
2.1.4

