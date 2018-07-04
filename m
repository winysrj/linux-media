Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:38431 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932439AbeGDIvv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:51:51 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, horms@verge.net.au, geert@linux-m68k.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH RESEND] dt-bindings: media: rcar-vin: Add R8A77995 support
Date: Wed,  4 Jul 2018 10:51:36 +0200
Message-Id: <1530694296-6417-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compatible string for R-Car D3 R8A7795 to list of SoCs supported by
rcar-vin driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
---

Re-sending to have this collected with the following series:
[PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3

Thanks
  j
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index a19517e1..5c6f2a7 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -22,6 +22,7 @@ on Gen3 platforms to a CSI-2 receiver.
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7796" for the R8A7796 device
    - "renesas,vin-r8a77970" for the R8A77970 device
+   - "renesas,vin-r8a77995" for the R8A77995 device
    - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
      device.

--
2.7.4
