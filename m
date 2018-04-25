Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47685 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753943AbeDYLPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 07:15:36 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: geert@linux-m68k.org, horms@verge.net.au, robh+dt@kernel.org,
        mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: media: renesas-ceu: Add R-Mobile R8A7740
Date: Wed, 25 Apr 2018 13:15:19 +0200
Message-Id: <1524654920-18749-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524654920-18749-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524654920-18749-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add R-Mobile A1 R8A7740 SoC to the list of compatible values for the CEU
unit.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/renesas,ceu.txt | 7 ++++---
 drivers/media/platform/renesas-ceu.c                    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
index 3fc66df..8a7a616 100644
--- a/Documentation/devicetree/bindings/media/renesas,ceu.txt
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
@@ -2,14 +2,15 @@ Renesas Capture Engine Unit (CEU)
 ----------------------------------------------
 
 The Capture Engine Unit is the image capture interface found in the Renesas
-SH Mobile and RZ SoCs.
+SH Mobile, R-Mobile and RZ SoCs.
 
 The interface supports a single parallel input with data bus width of 8 or 16
 bits.
 
 Required properties:
-- compatible: Shall be "renesas,r7s72100-ceu" for CEU units found in RZ/A1H
-  and RZ/A1M SoCs.
+- compatible: Shall be one of the following values:
+	"renesas,r7s72100-ceu" for CEU units found in RZ/A1H and RZ/A1M SoCs
+	"renesas,r8a7740-ceu" for CEU units found in R-Mobile A1 R8A7740 SoCs
 - reg: Registers address base and size.
 - interrupts: The interrupt specifier.
 
diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 6599dba..c964a56 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -1545,6 +1545,7 @@ static const struct ceu_data ceu_data_sh4 = {
 #if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id ceu_of_match[] = {
 	{ .compatible = "renesas,r7s72100-ceu", .data = &ceu_data_rz },
+	{ .compatible = "renesas,r8a7740-ceu", .data = &ceu_data_rz },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ceu_of_match);
-- 
2.7.4
