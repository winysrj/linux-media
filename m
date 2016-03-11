Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:33224 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbcCKDZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 22:25:57 -0500
From: Simon Horman <horms+renesas@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v3 1/2] media: soc_camera: rcar_vin: add R-Car Gen 2 and 3 fallback compatibility strings
Date: Fri, 11 Mar 2016 12:25:36 +0900
Message-Id: <1457666737-10519-2-git-send-email-horms+renesas@verge.net.au>
In-Reply-To: <1457666737-10519-1-git-send-email-horms+renesas@verge.net.au>
References: <1457666737-10519-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yoshihiro Kaneko <ykaneko0929@gmail.com>

Add fallback compatibility string for R-Car Gen 1 and 2.

In the case of Renesas R-Car hardware we know that there are generations of
SoCs, e.g. Gen 2 and 3. But beyond that its not clear what the relationship
between IP blocks might be. For example, I believe that r8a7790 is older
than r8a7791 but that doesn't imply that the latter is a descendant of the
former or vice versa.

We can, however, by examining the documentation and behaviour of the
hardware at run-time observe that the current driver implementation appears
to be compatible with the IP blocks on SoCs within a given generation.

For the above reasons and convenience when enabling new SoCs a
per-generation fallback compatibility string scheme being adopted for
drivers for Renesas SoCs.

Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
v3 [Simon Horman]
* Reworked and expanded changelog.
* Minor documentation enhancements.

v2 [Yoshihiro Kaneko]
* As suggested by Geert Uytterhoeven
  drivers/media/platform/soc_camera/rcar_vin.c:
    - The generic compatibility values are listed at the end of the
      rcar_vin_of_table[].

v1 [Yoshihiro Kaneko]
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 11 +++++++++--
 drivers/media/platform/soc_camera/rcar_vin.c         |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 619193ccf7ff..4266123888ed 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -5,7 +5,7 @@ The rcar_vin device provides video input capabilities for the Renesas R-Car
 family of devices. The current blocks are always slaves and suppot one input
 channel which can be either RGB, YUYV or BT656.
 
- - compatible: Must be one of the following
+ - compatible: Must be one or more of the following
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7793" for the R8A7793 device
@@ -13,6 +13,13 @@ channel which can be either RGB, YUYV or BT656.
    - "renesas,vin-r8a7790" for the R8A7790 device
    - "renesas,vin-r8a7779" for the R8A7779 device
    - "renesas,vin-r8a7778" for the R8A7778 device
+   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
+   - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
+
+   When compatible with the generic version nodes must list the
+   SoC-specific version corresponding to the platform first
+   followed by the generic version.
+
  - reg: the register base and size for the device registers
  - interrupts: the interrupt for the device
  - clocks: Reference to the parent clock
@@ -37,7 +44,7 @@ Device node example
 	};
 
         vin0: vin@0xe6ef0000 {
-                compatible = "renesas,vin-r8a7790";
+                compatible = "renesas,vin-r8a7790", "renesas,rcar-gen2-vin";
                 clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
                 reg = <0 0xe6ef0000 0 0x1000>;
                 interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 3b8edf458964..3f9c1b8456c3 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1845,6 +1845,8 @@ static const struct of_device_id rcar_vin_of_table[] = {
 	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
 	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
-- 
2.7.0.rc3.207.g0ac5344

