Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:59138 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750835AbeDXXoV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 19:44:21 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: remove generic gen3 compatible string
Date: Wed, 25 Apr 2018 01:43:21 +0200
Message-Id: <20180424234321.22367-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The compatible string "renesas,rcar-gen3-vin" was added before the
Gen3 driver code was added but it's not possible to use. Each SoC in the
Gen3 series require SoC specific knowledge in the driver to function.
Remove it before it is added to any device tree descriptions.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index ba31431d4b1fbdbb..a19517e1c669eb35 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -24,7 +24,6 @@ on Gen3 platforms to a CSI-2 receiver.
    - "renesas,vin-r8a77970" for the R8A77970 device
    - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
      device.
-   - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
 
    When compatible with the generic version nodes must list the
    SoC-specific version corresponding to the platform first
-- 
2.17.0
