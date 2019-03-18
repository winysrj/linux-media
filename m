Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DD1C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E4A20872
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="mB8fs4Ax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfCRObn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:43 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59216 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbfCRObm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:42 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 82E1B33A;
        Mon, 18 Mar 2019 15:31:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919496;
        bh=UBeIeR6S3P3OyNxuFYWr+Hz8e22y1qF3GwVWCjp+MKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mB8fs4AxN2nUmTPH5Dlu8QL07fuRdsOCD/Ke+/HjvtSTfkqtb2IHPnXxgtLYFZhz3
         xlWAy2LR23VzyfxVcN/a0GrNx4XRaSXHxl9KRfa2mmV0ySfpryg24Auk2ERoDA6mwd
         9KK3lVqJ96h59FR531sHg2ea0do2yhFb+TupaajU=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 08/18] media: vsp1: wpf: Add writeback support
Date:   Mon, 18 Mar 2019 16:31:11 +0200
Message-Id: <20190318143121.29561-9-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
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
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Changes since v6:

- Remove the vsp1_rwpf has_writeback field
---
 drivers/media/platform/vsp1/vsp1_rwpf.h |  1 +
 drivers/media/platform/vsp1/vsp1_wpf.c  | 66 +++++++++++++++++++++----
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 70742ecf766f..2f3582590618 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -61,6 +61,7 @@ struct vsp1_rwpf {
 	} flip;
 
 	struct vsp1_rwpf_memory mem;
+	bool writeback;
 
 	struct vsp1_dl_manager *dlm;
 };
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index fc5c1b0f6633..208498fa6ed7 100644
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
-- 
Regards,

Laurent Pinchart

