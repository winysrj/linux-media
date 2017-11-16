Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:45669 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934507AbdKPMLl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 07:11:41 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH 1/2] dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
Date: Thu, 16 Nov 2017 12:11:29 +0000
Message-Id: <1510834290-25434-2-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1510834290-25434-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1510834290-25434-1-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compatible strings for r8a7743 and r8a7745. No driver change
change is needed as "renesas,rcar-gen2-vin" will activate the right
code. However, it is good practice to document compatible strings
for the specific SoC as this allows SoC specific changes to the
driver if needed, in addition to document SoC support and therefore
allow checkpatch.pl to validate compatible string values.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Biju Das <biju.das@bp.renesas.com>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 6e4ef8c..0042ef2 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -14,7 +14,10 @@ channel which can be either RGB, YUYV or BT656.
    - "renesas,vin-r8a7790" for the R8A7790 device
    - "renesas,vin-r8a7779" for the R8A7779 device
    - "renesas,vin-r8a7778" for the R8A7778 device
-   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
+   - "renesas,vin-r8a7745" for the R8A7745 device
+   - "renesas,vin-r8a7743" for the R8A7743 device
+   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
+     device.
    - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
 
    When compatible with the generic version nodes must list the
-- 
2.7.4
