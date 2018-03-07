Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:31510 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754642AbeCGWF0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 17:05:26 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH v12 02/33] dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
Date: Wed,  7 Mar 2018 23:04:40 +0100
Message-Id: <20180307220511.9826-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Add compatible strings for r8a7743 and r8a7745. No driver change
is needed as "renesas,rcar-gen2-vin" will activate the right code.
However, it is good practice to document compatible strings for the
specific SoC as this allows SoC specific changes to the driver if
needed, in addition to document SoC support and therefore allow
checkpatch.pl to validate compatible string values.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 0ac715a5c331bc26..c60e6b0a89b67a8c 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves and suppot one input
 channel which can be either RGB, YUYV or BT656.
 
  - compatible: Must be one or more of the following
+   - "renesas,vin-r8a7743" for the R8A7743 device
+   - "renesas,vin-r8a7745" for the R8A7745 device
    - "renesas,vin-r8a7778" for the R8A7778 device
    - "renesas,vin-r8a7779" for the R8A7779 device
    - "renesas,vin-r8a7790" for the R8A7790 device
@@ -14,7 +16,8 @@ channel which can be either RGB, YUYV or BT656.
    - "renesas,vin-r8a7793" for the R8A7793 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7795" for the R8A7795 device
-   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
+   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
+     device.
    - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
 
    When compatible with the generic version nodes must list the
-- 
2.16.2
