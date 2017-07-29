Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49543 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdG2VIu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 17:08:50 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 2/4] drm: rcar-du: Wait for flip completion instead of vblank in commit tail
Date: Sun, 30 Jul 2017 00:08:53 +0300
Message-Id: <20170729210855.9187-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Page flips can take more than one vertical blanking to complete if
arming the page flips races with the vertical blanking interrupt.
Waiting for one vblank to complete the atomic commit in the commit tail
handler is thus incorrect, and can lead to framebuffers being released
while still being scanned out.

Fix this by waiting for flip completion instead, using the
drm_atomic_helper_wait_for_flip_done() helper.

Fixes: 0d230422d256 ("drm: rcar-du: Register a completion callback with VSP1")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index b91257dee98f..221e22922396 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -262,7 +262,7 @@ static void rcar_du_atomic_commit_tail(struct drm_atomic_state *old_state)
 	drm_atomic_helper_commit_modeset_enables(dev, old_state);
 
 	drm_atomic_helper_commit_hw_done(old_state);
-	drm_atomic_helper_wait_for_vblanks(dev, old_state);
+	drm_atomic_helper_wait_for_flip_done(dev, old_state);
 
 	drm_atomic_helper_cleanup_planes(dev, old_state);
 }
-- 
Regards,

Laurent Pinchart
