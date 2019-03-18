Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740DFC10F0D
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463EE20989
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="itHyTU3L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfCRObv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:51 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59216 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfCRObt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:49 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 07BA41A46;
        Mon, 18 Mar 2019 15:31:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919501;
        bh=+G31zEp2OnJKx9UAEn41xHVdmBKtKFpDivV0KGOIXYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itHyTU3LhhLVoS4SOOR/2xTMjBNyI8uNfjRJJN446odjLSaqE8hZGCUprN5AhNF3P
         iXeBZ8p88PYMANoEWOHmjJupWtES54Pdr6aRWy0PktwFmCXEYfRB0dzxX+hIya2Ld7
         g2K0sxQ/4kVSBH1KLMQUpS+MEVZ9pi1M5rzY62EM=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 17/18] drm: rcar-du: vsp: Extract framebuffer (un)mapping to separate functions
Date:   Mon, 18 Mar 2019 16:31:20 +0200
Message-Id: <20190318143121.29561-18-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The rcar_du_vsp_plane_prepare_fb() and rcar_du_vsp_plane_cleanup_fb()
functions implement the DRM plane .prepare_fb() and .cleanup_fb()
operations. They map and unmap the framebuffer to/from the VSP
internally, which will be useful to implement writeback support. Split
the mapping and unmapping out to separate functions.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 69 ++++++++++++++++-----------
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h | 17 +++++++
 2 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index ddfe4de64915..7e25e9bc7829 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -10,6 +10,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc.h>
 #include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_fourcc.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_plane_helper.h>
@@ -174,26 +175,16 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 			      plane->index, &cfg);
 }
 
-static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
-					struct drm_plane_state *state)
+int rcar_du_vsp_map_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
+		       struct sg_table sg_tables[3])
 {
-	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
-	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
 	struct rcar_du_device *rcdu = vsp->dev;
 	unsigned int i;
 	int ret;
 
-	/*
-	 * There's no need to prepare (and unprepare) the framebuffer when the
-	 * plane is not visible, as it will not be displayed.
-	 */
-	if (!state->visible)
-		return 0;
-
-	for (i = 0; i < rstate->format->planes; ++i) {
-		struct drm_gem_cma_object *gem =
-			drm_fb_cma_get_gem_obj(state->fb, i);
-		struct sg_table *sgt = &rstate->sg_tables[i];
+	for (i = 0; i < fb->format->num_planes; ++i) {
+		struct drm_gem_cma_object *gem = drm_fb_cma_get_gem_obj(fb, i);
+		struct sg_table *sgt = &sg_tables[i];
 
 		ret = dma_get_sgtable(rcdu->dev, sgt, gem->vaddr, gem->paddr,
 				      gem->base.size);
@@ -208,15 +199,11 @@ static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
 		}
 	}
 
-	ret = drm_gem_fb_prepare_fb(plane, state);
-	if (ret)
-		goto fail;
-
 	return 0;
 
 fail:
 	while (i--) {
-		struct sg_table *sgt = &rstate->sg_tables[i];
+		struct sg_table *sgt = &sg_tables[i];
 
 		vsp1_du_unmap_sg(vsp->vsp, sgt);
 		sg_free_table(sgt);
@@ -225,22 +212,50 @@ static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
 	return ret;
 }
 
+static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
+					struct drm_plane_state *state)
+{
+	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
+	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
+	int ret;
+
+	/*
+	 * There's no need to prepare (and unprepare) the framebuffer when the
+	 * plane is not visible, as it will not be displayed.
+	 */
+	if (!state->visible)
+		return 0;
+
+	ret = rcar_du_vsp_map_fb(vsp, state->fb, rstate->sg_tables);
+	if (ret < 0)
+		return ret;
+
+	return drm_gem_fb_prepare_fb(plane, state);
+}
+
+void rcar_du_vsp_unmap_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
+			  struct sg_table sg_tables[3])
+{
+	unsigned int i;
+
+	for (i = 0; i < fb->format->num_planes; ++i) {
+		struct sg_table *sgt = &sg_tables[i];
+
+		vsp1_du_unmap_sg(vsp->vsp, sgt);
+		sg_free_table(sgt);
+	}
+}
+
 static void rcar_du_vsp_plane_cleanup_fb(struct drm_plane *plane,
 					 struct drm_plane_state *state)
 {
 	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
 	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
-	unsigned int i;
 
 	if (!state->visible)
 		return;
 
-	for (i = 0; i < rstate->format->planes; ++i) {
-		struct sg_table *sgt = &rstate->sg_tables[i];
-
-		vsp1_du_unmap_sg(vsp->vsp, sgt);
-		sg_free_table(sgt);
-	}
+	rcar_du_vsp_unmap_fb(vsp, state->fb, rstate->sg_tables);
 }
 
 static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
index db232037f24a..9b4724159378 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
@@ -12,8 +12,10 @@
 
 #include <drm/drm_plane.h>
 
+struct drm_framebuffer;
 struct rcar_du_format_info;
 struct rcar_du_vsp;
+struct sg_table;
 
 struct rcar_du_vsp_plane {
 	struct drm_plane plane;
@@ -60,6 +62,10 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc);
 void rcar_du_vsp_disable(struct rcar_du_crtc *crtc);
 void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc);
 void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc);
+int rcar_du_vsp_map_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
+		       struct sg_table sg_tables[3]);
+void rcar_du_vsp_unmap_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
+			  struct sg_table sg_tables[3]);
 #else
 static inline int rcar_du_vsp_init(struct rcar_du_vsp *vsp,
 				   struct device_node *np,
@@ -71,6 +77,17 @@ static inline void rcar_du_vsp_enable(struct rcar_du_crtc *crtc) { };
 static inline void rcar_du_vsp_disable(struct rcar_du_crtc *crtc) { };
 static inline void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc) { };
 static inline void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc) { };
+static inline int rcar_du_vsp_map_fb(struct rcar_du_vsp *vsp,
+				     struct drm_framebuffer *fb,
+				     struct sg_table sg_tables[3])
+{
+	return -ENXIO;
+}
+static inline void rcar_du_vsp_unmap_fb(struct rcar_du_vsp *vsp,
+					struct drm_framebuffer *fb,
+					struct sg_table sg_tables[3])
+{
+}
 #endif
 
 #endif /* __RCAR_DU_VSP_H__ */
-- 
Regards,

Laurent Pinchart

