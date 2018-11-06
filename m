Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:39889 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbeKFUTw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:19:52 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 1/6] media: dt-bindings: rcar-vin: Add R8A77990 support
Date: Tue,  6 Nov 2018 11:54:22 +0100
Message-Id: <1541501667-28817-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compatible string for R-Car E3 R8A77990 to the list of SoCs supported by
rcar-vin driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index d329a4e..7c878ca 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -24,6 +24,7 @@ on Gen3 platforms to a CSI-2 receiver.
    - "renesas,vin-r8a7796" for the R8A7796 device
    - "renesas,vin-r8a77965" for the R8A77965 device
    - "renesas,vin-r8a77970" for the R8A77970 device
+   - "renesas,vin-r8a77990" for the R8A77990 device
    - "renesas,vin-r8a77995" for the R8A77995 device
    - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
      device.
-- 
2.7.4
