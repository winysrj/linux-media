Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:8171 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728127AbeIJTc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:32:29 -0400
From: Biju Das <biju.das@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Biju Das <biju.das@bp.renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
Date: Mon, 10 Sep 2018 15:31:14 +0100
Message-Id: <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document RZ/G2M (R8A774A1) SoC bindings.

The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).

Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
---
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
index 2d385b6..12fe685 100644
--- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
+++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
@@ -2,12 +2,13 @@ Renesas R-Car MIPI CSI-2
 ------------------------
 
 The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
-Renesas R-Car family of devices. It is used in conjunction with the
-R-Car VIN module, which provides the video capture capabilities.
+Renesas R-Car Gen3 and RZ/G2 family of devices. It is used in conjunction
+with the R-Car VIN module, which provides the video capture capabilities.
 
 Mandatory properties
 --------------------
  - compatible: Must be one or more of the following
+   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
    - "renesas,r8a7795-csi2" for the R8A7795 device.
    - "renesas,r8a7796-csi2" for the R8A7796 device.
    - "renesas,r8a77965-csi2" for the R8A77965 device.
-- 
2.7.4
