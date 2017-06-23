Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:35787 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754457AbdFWJir (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 05:38:47 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl
Cc: chris.paterson2@renesas.com, geert+renesas@glider.be,
        horms@verge.net.au, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH] dt-bindings: media: Add r8a7796 DRIF bindings
Date: Fri, 23 Jun 2017 10:25:02 +0100
Message-Id: <20170623092502.57818-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add r8a7796 DRIF bindings.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
Hi DT & Media maintainers, All,

   This patch adds DRIF bindings for R8A7796 SoC.
   It is based on media_tree - commit 76724b30f222

Thanks,
Ramesh.

 Documentation/devicetree/bindings/media/renesas,drif.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt b/Documentation/devicetree/bindings/media/renesas,drif.txt
index 39516b94c28f..0d8974aa8b38 100644
--- a/Documentation/devicetree/bindings/media/renesas,drif.txt
+++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
@@ -40,6 +40,7 @@ To summarize,
 Required properties of an internal channel:
 -------------------------------------------
 - compatible:	"renesas,r8a7795-drif" if DRIF controller is a part of R8A7795 SoC.
+		"renesas,r8a7796-drif" if DRIF controller is a part of R8A7796 SoC.
 		"renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible device.
 
 		When compatible with the generic version, nodes must list the
-- 
2.12.2
