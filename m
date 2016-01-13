Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33946 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbcAMR7J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 12:59:09 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v3] media: soc_camera: rcar_vin: Add rcar fallback compatibility string
Date: Thu, 14 Jan 2016 02:58:38 +0900
Message-Id: <1452707918-4321-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add fallback compatibility string for R-Car Gen2 and Gen3, This is
in keeping with the fallback scheme being adopted wherever appropriate
for drivers for Renesas SoCs.

Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is based on the for-4.6-1 branch of Guennadi's v4l-dvb tree.

v3 [Yoshihiro Kaneko]
* rebased to for-4.6-1 branch of Guennadi's tree.

v2 [Yoshihiro Kaneko]
* As suggested by Geert Uytterhoeven
  drivers/media/platform/soc_camera/rcar_vin.c:
    - The generic compatibility values are listed at the end of the
      rcar_vin_of_table[].

 Documentation/devicetree/bindings/media/rcar_vin.txt | 8 +++++++-
 drivers/media/platform/soc_camera/rcar_vin.c         | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 619193c..e1a92c9 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves and suppot one input
 channel which can be either RGB, YUYV or BT656.
 
  - compatible: Must be one of the following
+   - "renesas,rcar-gen2-vin" for R-Car Gen2 Series
+   - "renesas,rcar-gen3-vin" for R-Car Gen3 Series
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7793" for the R8A7793 device
@@ -13,6 +15,10 @@ channel which can be either RGB, YUYV or BT656.
    - "renesas,vin-r8a7790" for the R8A7790 device
    - "renesas,vin-r8a7779" for the R8A7779 device
    - "renesas,vin-r8a7778" for the R8A7778 device
+
+   When compatible with the generic version, nodes must list the SoC-specific
+   version corresponding to the platform first followed by the generic version.
+
  - reg: the register base and size for the device registers
  - interrupts: the interrupt for the device
  - clocks: Reference to the parent clock
@@ -37,7 +43,7 @@ Device node example
 	};
 
         vin0: vin@0xe6ef0000 {
-                compatible = "renesas,vin-r8a7790";
+                compatible = "renesas,vin-r8a7790","renesas,rcar-gen2-vin";
                 clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
                 reg = <0 0xe6ef0000 0 0x1000>;
                 interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index dc75a80..b72a048 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1826,6 +1826,8 @@ static const struct of_device_id rcar_vin_of_table[] = {
 	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
 	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
-- 
1.9.1

