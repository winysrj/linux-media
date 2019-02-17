Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5808FC10F00
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2015C2147C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="fbw00rFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfBQCtH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:49:07 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45164 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729699AbfBQCtG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:49:06 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 172271233;
        Sun, 17 Feb 2019 03:49:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550371742;
        bh=LVIjiIEkbi2B8LPG8rD2+D02EzHJ/YfldI44/b0XNlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbw00rFo37SJXe276jdIl8yQ6VjAl7IKt9LbrLMvBMZ3tvIU76vfHK0BPvv1qFvcC
         Q8kflNd8nbf271X6rYmo/btN/OFN+MvWdCbaRgB0QO5DEOKruIGRpqyDllCjQ4cvdi
         HThju3zO03vSywpUMkSlvacaF3DozxC/0UTjABZc=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 6/7] media: vsp1: Replace the display list internal flag with a flags field
Date:   Sun, 17 Feb 2019 04:48:51 +0200
Message-Id: <20190217024852.23328-7-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

To prepare for addition of more flags to the display list, replace the
'internal' flag field by a bitmask 'flags' field.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c    | 31 +++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_dl.h    |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c   |  6 ++++-
 drivers/media/platform/vsp1/vsp1_video.c |  2 +-
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 64af449791b0..886b3a69d329 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -178,7 +178,7 @@ struct vsp1_dl_cmd_pool {
  * @post_cmd: post command to be issued through extended dl header
  * @has_chain: if true, indicates that there's a partition chain
  * @chain: entry in the display list partition chain
- * @internal: whether the display list is used for internal purpose
+ * @flags: display list flags, a combination of VSP1_DL_FRAME_END_*
  */
 struct vsp1_dl_list {
 	struct list_head list;
@@ -197,7 +197,7 @@ struct vsp1_dl_list {
 	bool has_chain;
 	struct list_head chain;
 
-	bool internal;
+	unsigned int flags;
 };
 
 /**
@@ -861,13 +861,15 @@ static void vsp1_dl_list_commit_continuous(struct vsp1_dl_list *dl)
 	 *
 	 * If a display list is already pending we simply drop it as the new
 	 * display list is assumed to contain a more recent configuration. It is
-	 * an error if the already pending list has the internal flag set, as
-	 * there is then a process waiting for that list to complete. This
-	 * shouldn't happen as the waiting process should perform proper
-	 * locking, but warn just in case.
+	 * an error if the already pending list has the
+	 * VSP1_DL_FRAME_END_INTERNAL flag set, as there is then a process
+	 * waiting for that list to complete. This shouldn't happen as the
+	 * waiting process should perform proper locking, but warn just in
+	 * case.
 	 */
 	if (vsp1_dl_list_hw_update_pending(dlm)) {
-		WARN_ON(dlm->pending && dlm->pending->internal);
+		WARN_ON(dlm->pending &&
+			(dlm->pending->flags & VSP1_DL_FRAME_END_INTERNAL));
 		__vsp1_dl_list_put(dlm->pending);
 		dlm->pending = dl;
 		return;
@@ -897,7 +899,7 @@ static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
 	dlm->active = dl;
 }
 
-void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
+void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
 {
 	struct vsp1_dl_manager *dlm = dl->dlm;
 	struct vsp1_dl_list *dl_next;
@@ -912,7 +914,7 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
 		vsp1_dl_list_fill_header(dl_next, last);
 	}
 
-	dl->internal = internal;
+	dl->flags = dl_flags & ~VSP1_DL_FRAME_END_COMPLETED;
 
 	spin_lock_irqsave(&dlm->lock, flags);
 
@@ -941,9 +943,10 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
  * set in single-shot mode as display list processing is then not continuous and
  * races never occur.
  *
- * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the previous display list
- * has completed and had been queued with the internal notification flag.
- * Internal notification is only supported for continuous mode.
+ * The following flags are only supported for continuous mode.
+ *
+ * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the display list that just
+ * became active had been queued with the internal notification flag.
  */
 unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
@@ -986,9 +989,9 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	 * frame end interrupt. The display list thus becomes active.
 	 */
 	if (dlm->queued) {
-		if (dlm->queued->internal)
+		if (dlm->queued->flags & VSP1_DL_FRAME_END_INTERNAL)
 			flags |= VSP1_DL_FRAME_END_INTERNAL;
-		dlm->queued->internal = false;
+		dlm->queued->flags &= ~VSP1_DL_FRAME_END_INTERNAL;
 
 		__vsp1_dl_list_put(dlm->active);
 		dlm->active = dlm->queued;
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 125750dc8b5c..e0fdb145e6ed 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -61,7 +61,7 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
 struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl);
 struct vsp1_dl_ext_cmd *vsp1_dl_get_pre_cmd(struct vsp1_dl_list *dl);
-void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal);
+void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags);
 
 struct vsp1_dl_body_pool *
 vsp1_dl_body_pool_create(struct vsp1_device *vsp1, unsigned int num_bodies,
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 048190fd3a2d..9d20ef5cd5f8 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -537,6 +537,10 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 	struct vsp1_entity *next;
 	struct vsp1_dl_list *dl;
 	struct vsp1_dl_body *dlb;
+	unsigned int dl_flags = 0;
+
+	if (drm_pipe->force_brx_release)
+		dl_flags |= VSP1_DL_FRAME_END_INTERNAL;
 
 	dl = vsp1_dl_list_get(pipe->output->dlm);
 	dlb = vsp1_dl_list_get_body0(dl);
@@ -559,7 +563,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 		vsp1_entity_configure_partition(entity, pipe, dl, dlb);
 	}
 
-	vsp1_dl_list_commit(dl, drm_pipe->force_brx_release);
+	vsp1_dl_list_commit(dl, dl_flags);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index cfbab16c4820..8feaa8d89fe8 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -426,7 +426,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	}
 
 	/* Complete, and commit the head display list. */
-	vsp1_dl_list_commit(dl, false);
+	vsp1_dl_list_commit(dl, 0);
 	pipe->configured = true;
 
 	vsp1_pipeline_run(pipe);
-- 
Regards,

Laurent Pinchart

