Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB68C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 20:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF98220851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 20:25:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF98220851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbeLMUZe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 15:25:34 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:5356 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbeLMUZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 15:25:33 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2018 15:25:33 EST
X-IronPort-AV: E=Sophos;i="5.56,349,1539615600"; 
   d="scan'208";a="2555648"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 14 Dec 2018 05:20:30 +0900
Received: from fabrizio-dev.ree.adwin.renesas.com (unknown [10.226.37.69])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 29CE34072C4F;
        Fri, 14 Dec 2018 05:20:26 +0900 (JST)
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH] [media] v4l: vsp1: Add RZ/G support
Date:   Thu, 13 Dec 2018 20:20:24 +0000
Message-Id: <1544732424-6498-1-git-send-email-fabrizio.castro@bp.renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Document RZ/G1 and RZ/G2 support.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
---
 Documentation/devicetree/bindings/media/renesas,vsp1.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index 1642701..cd5a955 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -2,13 +2,13 @@
 
 The VSP is a video processing engine that supports up-/down-scaling, alpha
 blending, color space conversion and various other image processing features.
-It can be found in the Renesas R-Car second generation SoCs.
+It can be found in the Renesas R-Car Gen2, R-Car Gen3, RZ/G1, and RZ/G2 SoCs.
 
 Required properties:
 
   - compatible: Must contain one of the following values
-    - "renesas,vsp1" for the R-Car Gen2 VSP1
-    - "renesas,vsp2" for the R-Car Gen3 VSP2
+    - "renesas,vsp1" for the R-Car Gen2 and RZ/G1 VSP1
+    - "renesas,vsp2" for the R-Car Gen3 and RZ/G2 VSP2
 
   - reg: Base address and length of the registers block for the VSP.
   - interrupts: VSP interrupt specifier.
-- 
2.7.4

