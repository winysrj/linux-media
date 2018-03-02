Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:24075 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1163203AbeCBB6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:58:53 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH v11 01/32] dt-bindings: media: rcar_vin: Reverse SoC part number list
Date: Fri,  2 Mar 2018 02:57:20 +0100
Message-Id: <20180302015751.25596-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Change the sorting of the part numbers from descending to ascending to
match with other documentation.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 19357d0bbe6539b3..0ac715a5c331bc26 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -6,14 +6,14 @@ family of devices. The current blocks are always slaves and suppot one input
 channel which can be either RGB, YUYV or BT656.
 
  - compatible: Must be one or more of the following
-   - "renesas,vin-r8a7795" for the R8A7795 device
-   - "renesas,vin-r8a7794" for the R8A7794 device
-   - "renesas,vin-r8a7793" for the R8A7793 device
-   - "renesas,vin-r8a7792" for the R8A7792 device
-   - "renesas,vin-r8a7791" for the R8A7791 device
-   - "renesas,vin-r8a7790" for the R8A7790 device
-   - "renesas,vin-r8a7779" for the R8A7779 device
    - "renesas,vin-r8a7778" for the R8A7778 device
+   - "renesas,vin-r8a7779" for the R8A7779 device
+   - "renesas,vin-r8a7790" for the R8A7790 device
+   - "renesas,vin-r8a7791" for the R8A7791 device
+   - "renesas,vin-r8a7792" for the R8A7792 device
+   - "renesas,vin-r8a7793" for the R8A7793 device
+   - "renesas,vin-r8a7794" for the R8A7794 device
+   - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
    - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
 
-- 
2.16.2
