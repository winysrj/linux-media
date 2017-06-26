Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56948 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbdFZSMu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 14:12:50 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 14/14] drm: rcar-du: Configure DPAD0 routing through last group on Gen3
Date: Mon, 26 Jun 2017 21:12:26 +0300
Message-Id: <20170626181226.29575-15-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 SoCs DPAD0 routing is configured through the last CRTC group,
unlike on Gen2 where it is configured through the first CRTC group. Fix
the driver accordingly.

Fixes: 2427b3037710 ("drm: rcar-du: Add R8A7795 device support")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_group.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_group.c b/drivers/gpu/drm/rcar-du/rcar_du_group.c
index 64738fca96d0..2abb2fdd143e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_group.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_group.c
@@ -208,23 +208,30 @@ void rcar_du_group_restart(struct rcar_du_group *rgrp)
 
 int rcar_du_set_dpad0_vsp1_routing(struct rcar_du_device *rcdu)
 {
+	struct rcar_du_group *rgrp;
+	struct rcar_du_crtc *crtc;
 	int ret;
 
 	if (!rcar_du_has(rcdu, RCAR_DU_FEATURE_EXT_CTRL_REGS))
 		return 0;
 
-	/* RGB output routing to DPAD0 and VSP1D routing to DU0/1/2 are
-	 * configured in the DEFR8 register of the first group. As this function
-	 * can be called with the DU0 and DU1 CRTCs disabled, we need to enable
-	 * the first group clock before accessing the register.
+	/*
+	 * RGB output routing to DPAD0 and VSP1D routing to DU0/1/2 are
+	 * configured in the DEFR8 register of the first group on Gen2 and the
+	 * last group on Gen3. As this function can be called with the DU
+	 * channels of the corresponding CRTCs disabled, we need to enable the
+	 * group clock before accessing the register.
 	 */
-	ret = clk_prepare_enable(rcdu->crtcs[0].clock);
+	rgrp = &rcdu->groups[DIV_ROUND_UP(rcdu->num_crtcs, 2) - 1];
+	crtc = &rcdu->crtcs[rgrp->index * 2];
+
+	ret = clk_prepare_enable(crtc->clock);
 	if (ret < 0)
 		return ret;
 
-	rcar_du_group_setup_defr8(&rcdu->groups[0]);
+	rcar_du_group_setup_defr8(rgrp);
 
-	clk_disable_unprepare(rcdu->crtcs[0].clock);
+	clk_disable_unprepare(crtc->clock);
 
 	return 0;
 }
-- 
Regards,

Laurent Pinchart
