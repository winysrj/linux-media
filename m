Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51085 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754472AbcHSIjZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:39:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/6] drm: Don't implement empty prepare_fb()/cleanup_fb()
Date: Fri, 19 Aug 2016 11:39:29 +0300
Message-Id: <1471595974-28960-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plane .prepare_fb() and .cleanup_fb() helpers are optional, there's
no need to implement empty stubs, and no need to explicitly set the
function pointers to NULL either.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/arc/arcpgu_crtc.c               |  2 --
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c     | 15 ---------------
 drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c | 15 ---------------
 drivers/gpu/drm/tegra/dc.c                      | 17 -----------------
 drivers/gpu/drm/vc4/vc4_plane.c                 |  2 --
 5 files changed, 51 deletions(-)

diff --git a/drivers/gpu/drm/arc/arcpgu_crtc.c b/drivers/gpu/drm/arc/arcpgu_crtc.c
index ee0a61c2861b..7130b044b004 100644
--- a/drivers/gpu/drm/arc/arcpgu_crtc.c
+++ b/drivers/gpu/drm/arc/arcpgu_crtc.c
@@ -183,8 +183,6 @@ static void arc_pgu_plane_atomic_update(struct drm_plane *plane,
 }
 
 static const struct drm_plane_helper_funcs arc_pgu_plane_helper_funcs = {
-	.prepare_fb = NULL,
-	.cleanup_fb = NULL,
 	.atomic_update = arc_pgu_plane_atomic_update,
 };
 
diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c
index e50467a0deb0..a7e5486bd1e9 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c
@@ -169,25 +169,10 @@ static void fsl_dcu_drm_plane_atomic_update(struct drm_plane *plane,
 	return;
 }
 
-static void
-fsl_dcu_drm_plane_cleanup_fb(struct drm_plane *plane,
-			     const struct drm_plane_state *new_state)
-{
-}
-
-static int
-fsl_dcu_drm_plane_prepare_fb(struct drm_plane *plane,
-			     const struct drm_plane_state *new_state)
-{
-	return 0;
-}
-
 static const struct drm_plane_helper_funcs fsl_dcu_drm_plane_helper_funcs = {
 	.atomic_check = fsl_dcu_drm_plane_atomic_check,
 	.atomic_disable = fsl_dcu_drm_plane_atomic_disable,
 	.atomic_update = fsl_dcu_drm_plane_atomic_update,
-	.cleanup_fb = fsl_dcu_drm_plane_cleanup_fb,
-	.prepare_fb = fsl_dcu_drm_plane_prepare_fb,
 };
 
 static void fsl_dcu_drm_plane_destroy(struct drm_plane *plane)
diff --git a/drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c b/drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c
index c3707d47cd89..635ead039b8b 100644
--- a/drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c
+++ b/drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c
@@ -815,19 +815,6 @@ static void ade_disable_channel(struct ade_plane *aplane)
 	ade_compositor_routing_disable(base, ch);
 }
 
-static int ade_plane_prepare_fb(struct drm_plane *plane,
-				const struct drm_plane_state *new_state)
-{
-	/* do nothing */
-	return 0;
-}
-
-static void ade_plane_cleanup_fb(struct drm_plane *plane,
-				 const struct drm_plane_state *old_state)
-{
-	/* do nothing */
-}
-
 static int ade_plane_atomic_check(struct drm_plane *plane,
 				  struct drm_plane_state *state)
 {
@@ -895,8 +882,6 @@ static void ade_plane_atomic_disable(struct drm_plane *plane,
 }
 
 static const struct drm_plane_helper_funcs ade_plane_helper_funcs = {
-	.prepare_fb = ade_plane_prepare_fb,
-	.cleanup_fb = ade_plane_cleanup_fb,
 	.atomic_check = ade_plane_atomic_check,
 	.atomic_update = ade_plane_atomic_update,
 	.atomic_disable = ade_plane_atomic_disable,
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 8495bd01b544..3de7ce33d3d4 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -480,17 +480,6 @@ static const struct drm_plane_funcs tegra_primary_plane_funcs = {
 	.atomic_destroy_state = tegra_plane_atomic_destroy_state,
 };
 
-static int tegra_plane_prepare_fb(struct drm_plane *plane,
-				  const struct drm_plane_state *new_state)
-{
-	return 0;
-}
-
-static void tegra_plane_cleanup_fb(struct drm_plane *plane,
-				   const struct drm_plane_state *old_fb)
-{
-}
-
 static int tegra_plane_state_add(struct tegra_plane *plane,
 				 struct drm_plane_state *state)
 {
@@ -624,8 +613,6 @@ static void tegra_plane_atomic_disable(struct drm_plane *plane,
 }
 
 static const struct drm_plane_helper_funcs tegra_primary_plane_helper_funcs = {
-	.prepare_fb = tegra_plane_prepare_fb,
-	.cleanup_fb = tegra_plane_cleanup_fb,
 	.atomic_check = tegra_plane_atomic_check,
 	.atomic_update = tegra_plane_atomic_update,
 	.atomic_disable = tegra_plane_atomic_disable,
@@ -796,8 +783,6 @@ static const struct drm_plane_funcs tegra_cursor_plane_funcs = {
 };
 
 static const struct drm_plane_helper_funcs tegra_cursor_plane_helper_funcs = {
-	.prepare_fb = tegra_plane_prepare_fb,
-	.cleanup_fb = tegra_plane_cleanup_fb,
 	.atomic_check = tegra_cursor_atomic_check,
 	.atomic_update = tegra_cursor_atomic_update,
 	.atomic_disable = tegra_cursor_atomic_disable,
@@ -866,8 +851,6 @@ static const uint32_t tegra_overlay_plane_formats[] = {
 };
 
 static const struct drm_plane_helper_funcs tegra_overlay_plane_helper_funcs = {
-	.prepare_fb = tegra_plane_prepare_fb,
-	.cleanup_fb = tegra_plane_cleanup_fb,
 	.atomic_check = tegra_plane_atomic_check,
 	.atomic_update = tegra_plane_atomic_update,
 	.atomic_disable = tegra_plane_atomic_disable,
diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 29e4b400e25e..881bf489478b 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -735,8 +735,6 @@ void vc4_plane_async_set_fb(struct drm_plane *plane, struct drm_framebuffer *fb)
 }
 
 static const struct drm_plane_helper_funcs vc4_plane_helper_funcs = {
-	.prepare_fb = NULL,
-	.cleanup_fb = NULL,
 	.atomic_check = vc4_plane_atomic_check,
 	.atomic_update = vc4_plane_atomic_update,
 };
-- 
Regards,

Laurent Pinchart

