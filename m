Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150A8C10F0E
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB1D12085A
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="NByQhRXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfCRObp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:45 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59216 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfCRObo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:44 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 801001998;
        Mon, 18 Mar 2019 15:31:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919497;
        bh=PPQouBreckvNEq5Az7u+R+1N0vcXdYdVBF8G+De03Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NByQhRXm1iUuCppx1BQ7F6LFUY01e9Cut84ynMCm5x/cj9L52jAyaGvT1yUAhNa9N
         aIkMfvG2y/jV+hg681q9obMK3222K6mT+RV8ozUxjLq24h0M0tz+7wj4VPLJ7NJTgO
         RDed2ZyckVoovkDistSkouWT1lcMMEoa9/Q7wyMI=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 10/18] media: vsp1: drm: Extend frame completion API to the DU driver
Date:   Mon, 18 Mar 2019 16:31:13 +0200
Message-Id: <20190318143121.29561-11-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VSP1 driver will need to pass extra flags to the DU through the
frame completion API. Replace the completed bool flag by a bitmask to
support this.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Changes since v6:

- Add a comment to keep VSP1_DU_STATUS_* and VSP1_DL_FRAME_END_* in sync
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 4 ++--
 drivers/media/platform/vsp1/vsp1_dl.h  | 1 +
 drivers/media/platform/vsp1/vsp1_drm.c | 4 ++--
 drivers/media/platform/vsp1/vsp1_drm.h | 2 +-
 include/media/vsp1.h                   | 4 +++-
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index f6deea90dcce..520929389666 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -27,14 +27,14 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_vsp.h"
 
-static void rcar_du_vsp_complete(void *private, bool completed, u32 crc)
+static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
 {
 	struct rcar_du_crtc *crtc = private;
 
 	if (crtc->vblank_enable)
 		drm_crtc_handle_vblank(&crtc->crtc);
 
-	if (completed)
+	if (status & VSP1_DU_STATUS_COMPLETE)
 		rcar_du_crtc_finish_page_flip(crtc);
 
 	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index e0fdb145e6ed..079ba5af0315 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -17,6 +17,7 @@ struct vsp1_dl_body_pool;
 struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
+/* Keep these flags in sync with VSP1_DU_STATUS_* in include/media/vsp1.h. */
 #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
 #define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index d1c88e8aee52..bd95683c1cd9 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -34,14 +34,14 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 				       unsigned int completion)
 {
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
-	bool complete = completion & VSP1_DL_FRAME_END_COMPLETED;
 
 	if (drm_pipe->du_complete) {
 		struct vsp1_entity *uif = drm_pipe->uif;
+		unsigned int status = completion & VSP1_DU_STATUS_COMPLETE;
 		u32 crc;
 
 		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
-		drm_pipe->du_complete(drm_pipe->du_private, complete, crc);
+		drm_pipe->du_complete(drm_pipe->du_private, status, crc);
 	}
 
 	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index 8dfd274a59e2..e85ad4366fbb 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -42,7 +42,7 @@ struct vsp1_drm_pipeline {
 	struct vsp1_du_crc_config crc;
 
 	/* Frame synchronisation */
-	void (*du_complete)(void *data, bool completed, u32 crc);
+	void (*du_complete)(void *data, unsigned int status, u32 crc);
 	void *du_private;
 };
 
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 1cf868360701..877496936487 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -17,6 +17,8 @@ struct device;
 
 int vsp1_du_init(struct device *dev);
 
+#define VSP1_DU_STATUS_COMPLETE		BIT(0)
+
 /**
  * struct vsp1_du_lif_config - VSP LIF configuration
  * @width: output frame width
@@ -32,7 +34,7 @@ struct vsp1_du_lif_config {
 	unsigned int height;
 	bool interlaced;
 
-	void (*callback)(void *data, bool completed, u32 crc);
+	void (*callback)(void *data, unsigned int status, u32 crc);
 	void *callback_data;
 };
 
-- 
Regards,

Laurent Pinchart

