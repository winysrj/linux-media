Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D714BC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9DF20879
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="JHokqfDa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfCRObv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:51 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59216 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfCRObs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:48 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 07F4A989;
        Mon, 18 Mar 2019 15:31:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919500;
        bh=UNc4VPahsBoLL5Wankfn4WxjTCt+Y4WeFPec1OuImjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHokqfDajlU5yCfjT+esbRpzewvYKr4UQlNF3usYMPDeewmE4TPw+6s2x/s9ohh8K
         sdoM3SnpBRB8xo39AzlOw7jiWr3ySJ/LsIf36Llfj+tgOAOrCUm1tXeVg33cIAy9H9
         aSYT74bDIw1auALKypSDOs+DmqRsuupcObCmefBU=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 15/18] drm: rcar-du: Fix rcar_du_crtc structure documentation
Date:   Mon, 18 Mar 2019 16:31:18 +0200
Message-Id: <20190318143121.29561-16-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The rcar_du_crtc structure index field contains the CRTC hardware index,
not the hardware and software index. Update the documentation
accordingly.

Fixes: 5361cc7f8e91 ("drm: rcar-du: Split CRTC handling to support hardware indexing")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index 11814eafef77..af9527c1d238 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -28,7 +28,7 @@ struct rcar_du_vsp;
  * @clock: the CRTC functional clock
  * @extclock: external pixel dot clock (optional)
  * @mmio_offset: offset of the CRTC registers in the DU MMIO block
- * @index: CRTC software and hardware index
+ * @index: CRTC hardware index
  * @initialized: whether the CRTC has been initialized and clocks enabled
  * @dsysr: cached value of the DSYSR register
  * @vblank_enable: whether vblank events are enabled on this CRTC
-- 
Regards,

Laurent Pinchart

