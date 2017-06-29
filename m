Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752953AbdF2ODM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 10:03:12 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/2] drm: rcar-du: Enable the FRM interrupt for vblank
Date: Thu, 29 Jun 2017 15:02:55 +0100
Message-Id: <0e5b1635470b06924a0bc00ee1f4791602285ca5.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar_du_crtc_{enable,disable}_vblank functions are configured to
control the VBE interrupt event.

The implementation of interlaced support in the rcar-du changes the
required behavior such that vblanks are handled on frame end events, but
does not update the enable register to reflect this.

Enable the FRM interrupt in the DIER register using the FRE bit.

Fixes: 906eff7fcada ("drm: rcar-du: Implement support for interlaced
modes")

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 345eff72f581..9f53a8243941 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -620,7 +620,7 @@ static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
 
 	rcar_du_crtc_write(rcrtc, DSRCR, DSRCR_VBCL);
-	rcar_du_crtc_set(rcrtc, DIER, DIER_VBE);
+	rcar_du_crtc_set(rcrtc, DIER, DIER_FRE);
 
 	return 0;
 }
@@ -629,7 +629,7 @@ static void rcar_du_crtc_disable_vblank(struct drm_crtc *crtc)
 {
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
 
-	rcar_du_crtc_clr(rcrtc, DIER, DIER_VBE);
+	rcar_du_crtc_clr(rcrtc, DIER, DIER_FRE);
 }
 
 static const struct drm_crtc_funcs crtc_funcs = {
-- 
git-series 0.9.1
