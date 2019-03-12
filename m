Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91BCC10F00
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC59C2173C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="m1ctiNuI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfCLXTF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:19:05 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:40482 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfCLXTF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 19:19:05 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 470552DF;
        Wed, 13 Mar 2019 00:19:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552432743;
        bh=NXlZKyakZbnEO70GUVwLvHDMgE/msW09ytzgJvcOp+4=;
        h=From:To:Cc:Subject:Date:From;
        b=m1ctiNuIdUM1mkVp9OOrKw4zPICRSVfN4o/r745sNyKggSQI7G5+wbnlWmQ4zXlzT
         ALJT0kDqoTcZ35u9JA+xhbLG3T75Ze1ivzHuNBZms+S7xS0f2+yHxFq/9Jk7UrE3fj
         x4LCymXbmZfboJUr5g6PSpMgdEIPdmMpj4MAYTZI=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH] drm: rcar-du: lvds: Fix post-DLL divider calculation
Date:   Wed, 13 Mar 2019 01:18:53 +0200
Message-Id: <20190312231853.3150-1-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The PLL parameters are computed by looping over the range of acceptable
M, N and E values, and selecting the combination that produces the
output frequency closest to the target. The internal frequency
constraints are taken into account by restricting the tested values for
the PLL parameters, reducing the search space. The target frequency,
however, is only taken into account when computing the post-PLL divider,
which can result in a 0 value for the divider when the PLL output
frequency being tested is lower than half of the target frequency.
Subsequent loops will produce a better set of PLL parameters, but for
some of the iterations this can result in a division by 0.

Fix it by clamping the divider value. We could instead restrict the E
values being tested in the inner loop, but that would require additional
calculation that would likely be less efficient as the E parameter can
only take three different values.

Fixes: c25c01361199 ("drm: rcar-du: lvds: D3/E3 support")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_lvds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index 7ef97b2a6eda..9f5ff1acab4e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -283,7 +283,7 @@ static void rcar_lvds_d3_e3_pll_calc(struct rcar_lvds *lvds, struct clk *clk,
 				 * divider.
 				 */
 				fout = fvco / (1 << e) / div7;
-				div = DIV_ROUND_CLOSEST(fout, target);
+				div = max(1UL, DIV_ROUND_CLOSEST(fout, target));
 				diff = abs(fout / div - target);
 
 				if (diff < pll->diff) {
-- 
Regards,

Laurent Pinchart

