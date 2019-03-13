Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25FDC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85DC0214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="klzlZvUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfCMAF7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:59 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42054 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfCMAF4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:56 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B348E9BC;
        Wed, 13 Mar 2019 01:05:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435551;
        bh=ziMbw09nIephwcEu3LLkJpB7A9XamwtENtlFfhCVA94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klzlZvUt1aCpt2O1JTk7NXjOeFVFq0VorYX0GEEnhIeMIq4fEtSpkZ6Liib6EvQar
         WuWoUEM93NSF9F+o0mU8E/YFr2zo0rWmDZJ8G/aLhBeWr+j9KFch12b0gg57TdS9EW
         +P7j6kaJLLEY+OppTdsuLISGffPGLq7Ku7tB37n4=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 11/18] media: vsp1: drm: Implement writeback support
Date:   Wed, 13 Mar 2019 02:05:25 +0200
Message-Id: <20190313000532.7087-12-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Extend the vsp1_du_atomic_flush() API with writeback support by adding
format, pitch and memory addresses of the writeback framebuffer.
Writeback completion is reported through the existing frame completion
callback with a new VSP1_DU_STATUS_WRITEBACK status flag.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c  | 14 ++++++++++++++
 drivers/media/platform/vsp1/vsp1_dl.h  |  3 ++-
 drivers/media/platform/vsp1/vsp1_drm.c | 25 ++++++++++++++++++++++++-
 include/media/vsp1.h                   | 15 +++++++++++++++
 4 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index ed7cda4130f2..104b6f514536 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -958,6 +958,9 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
  *
  * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the display list that just
  * became active had been queued with the internal notification flag.
+ *
+ * The VSP1_DL_FRAME_END_WRITEBACK flag indicates that the previously active
+ * display list had been queued with the writeback flag.
  */
 unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
@@ -995,6 +998,17 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	if (status & VI6_STATUS_FLD_STD(dlm->index))
 		goto done;
 
+	/*
+	 * If the active display list has the writeback flag set, the frame
+	 * completion marks the end of the writeback capture. Return the
+	 * VSP1_DL_FRAME_END_WRITEBACK flag and reset the display list's
+	 * writeback flag.
+	 */
+	if (dlm->active && (dlm->active->flags & VSP1_DL_FRAME_END_WRITEBACK)) {
+		flags |= VSP1_DL_FRAME_END_WRITEBACK;
+		dlm->active->flags &= ~VSP1_DL_FRAME_END_WRITEBACK;
+	}
+
 	/*
 	 * The device starts processing the queued display list right after the
 	 * frame end interrupt. The display list thus becomes active.
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index e0fdb145e6ed..4d7bcfdc9bd9 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -18,7 +18,8 @@ struct vsp1_dl_list;
 struct vsp1_dl_manager;
 
 #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
-#define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
+#define VSP1_DL_FRAME_END_WRITEBACK		BIT(1)
+#define VSP1_DL_FRAME_END_INTERNAL		BIT(2)
 
 /**
  * struct vsp1_dl_ext_cmd - Extended Display command
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 0367f88135bf..16826bf184c7 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -37,7 +37,9 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 
 	if (drm_pipe->du_complete) {
 		struct vsp1_entity *uif = drm_pipe->uif;
-		unsigned int status = completion & VSP1_DU_STATUS_COMPLETE;
+		unsigned int status = completion
+				    & (VSP1_DU_STATUS_COMPLETE |
+				       VSP1_DU_STATUS_WRITEBACK);
 		u32 crc;
 
 		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
@@ -541,6 +543,8 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 
 	if (drm_pipe->force_brx_release)
 		dl_flags |= VSP1_DL_FRAME_END_INTERNAL;
+	if (pipe->output->writeback)
+		dl_flags |= VSP1_DL_FRAME_END_WRITEBACK;
 
 	dl = vsp1_dl_list_get(pipe->output->dlm);
 	dlb = vsp1_dl_list_get_body0(dl);
@@ -870,12 +874,31 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
 	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
+	int ret;
 
 	drm_pipe->crc = cfg->crc;
 
 	mutex_lock(&vsp1->drm->lock);
+
+	if (pipe->output->has_writeback && cfg->writeback.pixelformat) {
+		const struct vsp1_du_writeback_config *wb_cfg = &cfg->writeback;
+
+		ret = vsp1_du_pipeline_set_rwpf_format(vsp1, pipe->output,
+						       wb_cfg->pixelformat,
+						       wb_cfg->pitch);
+		if (WARN_ON(ret < 0))
+			goto done;
+
+		pipe->output->mem.addr[0] = wb_cfg->mem[0];
+		pipe->output->mem.addr[1] = wb_cfg->mem[1];
+		pipe->output->mem.addr[2] = wb_cfg->mem[2];
+		pipe->output->writeback = true;
+	}
+
 	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	vsp1_du_pipeline_configure(pipe);
+
+done:
 	mutex_unlock(&vsp1->drm->lock);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 877496936487..cc1b0d42ce95 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -18,6 +18,7 @@ struct device;
 int vsp1_du_init(struct device *dev);
 
 #define VSP1_DU_STATUS_COMPLETE		BIT(0)
+#define VSP1_DU_STATUS_WRITEBACK	BIT(1)
 
 /**
  * struct vsp1_du_lif_config - VSP LIF configuration
@@ -83,12 +84,26 @@ struct vsp1_du_crc_config {
 	unsigned int index;
 };
 
+/**
+ * struct vsp1_du_writeback_config - VSP writeback configuration parameters
+ * @pixelformat: plane pixel format (V4L2 4CC)
+ * @pitch: line pitch in bytes for the first plane
+ * @mem: DMA memory address for each plane of the frame buffer
+ */
+struct vsp1_du_writeback_config {
+	u32 pixelformat;
+	unsigned int pitch;
+	dma_addr_t mem[3];
+};
+
 /**
  * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration parameters
  * @crc: CRC computation configuration
+ * @writeback: writeback configuration
  */
 struct vsp1_du_atomic_pipe_config {
 	struct vsp1_du_crc_config crc;
+	struct vsp1_du_writeback_config writeback;
 };
 
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
-- 
Regards,

Laurent Pinchart

