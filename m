Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:40987 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730304AbeKFUTy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:19:54 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 3/6] media: dt-bindings: rcar-csi2: Add R8A77990
Date: Tue,  6 Nov 2018 11:54:24 +0100
Message-Id: <1541501667-28817-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compatible string for R-Car E3 R8A77990 to the list of supported SoCs.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
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
