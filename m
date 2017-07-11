Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58382 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932655AbdGKW3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 18:29:52 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 1/3] drm: rcar-du: Use the VBK interrupt for vblank events
Date: Wed, 12 Jul 2017 01:29:40 +0300
Message-Id: <20170711222942.27735-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170711222942.27735-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170711222942.27735-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When implementing support for interlaced modes, the driver switched from
reporting vblank events on the vertical blanking (VBK) interrupt to the
frame end interrupt (FRM). This incorrectly divided the reported refresh
rate by two. Fix it by moving back to the VBK interrupt.

Fixes: 906eff7fcada ("drm: rcar-du: Implement support for interlaced modes")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 98cf446391dc..17fd1cd5212c 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -698,7 +698,7 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
 	status = rcar_du_crtc_read(rcrtc, DSSR);
 	rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
 
-	if (status & DSSR_FRM) {
+	if (status & DSSR_VBK) {
 		drm_crtc_handle_vblank(&rcrtc->crtc);
 
 		if (rcdu->info->gen < 3)
-- 
Regards,

Laurent Pinchart
