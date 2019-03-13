Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE99EC10F00
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F80E214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="aLC/uqoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfCMAFz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:55 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfCMAFx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:53 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7060297F;
        Wed, 13 Mar 2019 01:05:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435548;
        bh=1mNvDw6C9ubiIrKUcYBKO0aCvMX2gtD9ckCJOfWuzc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLC/uqoNGZnvGBAJa69AvhewpKB1P19OoB2mcAYZCPJvy39ER2acJ9MeQPIZrXx5q
         bCL8axz3+cm1Pkj1gAgu1nCn0XsjTubCsF2eYNpy/C4zovG4k+bk/73zN8IXqsfa7C
         yEzGjLsjD/raH5niRAqbqA57ZtkgxYairN1t3fBw=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 08/18] media: vsp1: wpf: Add writeback support
Date:   Wed, 13 Mar 2019 02:05:22 +0200
Message-Id: <20190313000532.7087-9-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for the writeback feature of the WPF, to enable capturing
frames at the WPF output for display pipelines. To enable writeback the
vsp1_rwpf structure mem field must be set to the address of the
writeback buffer and the writeback field set to true before the WPF
.configure_stream() and .configure_partition() are called. The WPF will
enable writeback in the display list for a single frame, and writeback
will then be automatically disabled.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rwpf.h |  2 +
 drivers/media/platform/vsp1/vsp1_wpf.c  | 73 ++++++++++++++++++++++---
 2 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 70742ecf766f..910990b27617 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -35,6 +35,7 @@ struct vsp1_rwpf {
 	struct v4l2_ctrl_handler ctrls;
 
 	struct vsp1_video *video;
+	bool has_writeback;
 
 	unsigned int max_width;
 	unsigned int max_height;
@@ -61,6 +62,7 @@ struct vsp1_rwpf {
 	} flip;
 
 	struct vsp1_rwpf_memory mem;
+	bool writeback;
 
 	struct vsp1_dl_manager *dlm;
 };
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index fc5c1b0f6633..390ac478336d 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -232,6 +232,27 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 	vsp1_dlm_destroy(wpf->dlm);
 }
 
+static int wpf_configure_writeback_chain(struct vsp1_rwpf *wpf,
+					 struct vsp1_dl_list *dl)
+{
+	unsigned int index = wpf->entity.index;
+	struct vsp1_dl_list *dl_next;
+	struct vsp1_dl_body *dlb;
+
+	dl_next = vsp1_dl_list_get(wpf->dlm);
+	if (!dl_next) {
+		dev_err(wpf->entity.vsp1->dev,
+			"Failed to obtain a dl list, disabling writeback\n");
+		return -ENOMEM;
+	}
+
+	dlb = vsp1_dl_list_get_body0(dl_next);
+	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index), 0);
+	vsp1_dl_list_add_chain(dl, dl_next);
+
+	return 0;
+}
+
 static void wpf_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
 				 struct vsp1_dl_list *dl,
@@ -241,9 +262,11 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
+	unsigned int index = wpf->entity.index;
 	unsigned int i;
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
+	int ret;
 
 	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
 						 wpf->entity.config,
@@ -251,8 +274,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 	source_format = vsp1_entity_get_pad_format(&wpf->entity,
 						   wpf->entity.config,
 						   RWPF_PAD_SOURCE);
+
 	/* Format */
-	if (!pipe->lif) {
+	if (!pipe->lif || wpf->writeback) {
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
@@ -277,8 +301,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 
 		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
 
-		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) &&
-		    wpf->entity.index == 0)
+		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) && index == 0)
 			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
 				       VI6_WPF_ROT_CTRL_LN16 |
 				       (256 << VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT));
@@ -289,11 +312,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 
 	wpf->outfmt = outfmt;
 
-	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(index),
 			   VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(wpf->entity.index), 0);
-
 	/*
 	 * Sources. If the pipeline has a single input and BRx is not used,
 	 * configure it as the master layer. Otherwise configure all
@@ -319,9 +340,26 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
 
 	/* Enable interrupts. */
-	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
+	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(index), 0);
+	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(index),
 			   VI6_WFP_IRQ_ENB_DFEE);
+
+	/*
+	 * Configure writeback for display pipelines (the wpf writeback flag is
+	 * never set for memory-to-memory pipelines). Start by adding a chained
+	 * display list to disable writeback after a single frame, and process
+	 * to enable writeback. If the display list allocation fails don't
+	 * enable writeback as we wouldn't be able to safely disable it,
+	 * resulting in possible memory corruption.
+	 */
+	if (wpf->writeback) {
+		ret = wpf_configure_writeback_chain(wpf, dl);
+		if (ret < 0)
+			wpf->writeback = false;
+	}
+
+	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index),
+			   wpf->writeback ? VI6_WPF_WRBCK_CTRL_WBMD : 0);
 }
 
 static void wpf_configure_frame(struct vsp1_entity *entity,
@@ -391,7 +429,11 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
-	if (pipe->lif)
+	/*
+	 * For display pipelines without writeback enabled there's no memory
+	 * address to configure, return now.
+	 */
+	if (pipe->lif && !wpf->writeback)
 		return;
 
 	/*
@@ -480,6 +522,12 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
+
+	/*
+	 * Writeback operates in single-shot mode and lasts for a single frame,
+	 * reset the writeback flag to false for the next frame.
+	 */
+	wpf->writeback = false;
 }
 
 static unsigned int wpf_max_width(struct vsp1_entity *entity,
@@ -530,6 +578,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 		wpf->max_height = WPF_GEN3_MAX_HEIGHT;
 	}
 
+	/*
+	 * On Gen3 WPFs with a LIF output can also write to memory for display
+	 * writeback.
+	 */
+	if (vsp1->info->gen > 2 && index < vsp1->info->lif_count)
+		wpf->has_writeback = true;
+
 	wpf->entity.ops = &wpf_entity_ops;
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
-- 
Regards,

Laurent Pinchart

