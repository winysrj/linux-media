Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116B1C10F0B
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D368E214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="fxYdsHgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfCMAGA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:06:00 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfCMAFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:55 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id F35419DB;
        Wed, 13 Mar 2019 01:05:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435550;
        bh=wJ9TD5iSpzEG8YYZBSzgMSH8VQMOVzLjHqElJ+znd+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxYdsHgJGmWCgLDFvXmRRd2jqoYXchKLhnuPvdeR0IMoSImn0YXbNbYSXDElE3aVX
         0EwTvomjLHion307kl8UOKQbD3Ci9VXpt+6Y5dxZXgWfDP51UdsenwFYRSKWQcJqlK
         FTV3+aqMRIeYQ+Kotl9FWqUJgHWFeNLRiPWi4Zus=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 10/18] media: vsp1: drm: Extend frame completion API to the DU driver
Date:   Wed, 13 Mar 2019 02:05:24 +0200
Message-Id: <20190313000532.7087-11-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
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
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 4 ++--
 drivers/media/platform/vsp1/vsp1_drm.c | 4 ++--
 drivers/media/platform/vsp1/vsp1_drm.h | 2 +-
 include/media/vsp1.h                   | 4 +++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 76a39eee7c9c..28bfeb8c24fb 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -26,14 +26,14 @@
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
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 5601a787688b..0367f88135bf 100644
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

