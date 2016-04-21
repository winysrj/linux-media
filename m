Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33561 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcDUBOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 21:14:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	David Airlie <airlied@linux.ie>
Subject: [PATCH 2/2] drm: rcar-du: Add alpha support for VSP planes
Date: Thu, 21 Apr 2016 04:14:13 +0300
Message-Id: <1461201253-12170-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the global alpha multiplier of VSP planes configurable through the
alpha property, exactly as for the native DU planes.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 62e9619eaea4..7a588f1f6d69 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -180,9 +180,9 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 
 	WARN_ON(!pixelformat);
 
-	vsp1_du_atomic_update_zpos(plane->vsp->vsp, plane->index, pixelformat,
-				   fb->pitches[0], paddr, &src, &dst,
-				   state->zpos);
+	vsp1_du_atomic_update_ext(plane->vsp->vsp, plane->index, pixelformat,
+				  fb->pitches[0], paddr, &src, &dst,
+				  state->alpha, state->zpos);
 }
 
 static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
@@ -221,8 +221,8 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
 	if (plane->state->crtc)
 		rcar_du_vsp_plane_setup(rplane);
 	else
-		vsp1_du_atomic_update_zpos(rplane->vsp->vsp, rplane->index,
-					   0, 0, 0, NULL, NULL, 0);
+		vsp1_du_atomic_update_ext(rplane->vsp->vsp, rplane->index,
+					  0, 0, 0, NULL, NULL, 0, 0);
 }
 
 static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
-- 
2.7.3

