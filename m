Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54095 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeHTNcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 09:32:07 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au, robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [RFT 3/8] dt-bindings: media: rcar-csi2: Add R8A77990
Date: Mon, 20 Aug 2018 12:16:37 +0200
Message-Id: <1534760202-20114-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compatible string for R-Car E3 R8A77990 to the list of supported SoCs.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
index 2d385b6..2824489 100644
--- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
+++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
@@ -12,6 +12,7 @@ Mandatory properties
    - "renesas,r8a7796-csi2" for the R8A7796 device.
    - "renesas,r8a77965-csi2" for the R8A77965 device.
    - "renesas,r8a77970-csi2" for the R8A77970 device.
+   - "renesas,r8a77990-csi2" for the R8A77990 device.

  - reg: the register base and size for the device registers
  - interrupts: the interrupt for the device
--
2.7.4
