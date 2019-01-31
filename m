Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE12C282D7
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46F320870
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfAaDOC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 22:14:02 -0500
Received: from kozue.soulik.info ([108.61.200.231]:36664 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfAaDOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 22:14:02 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:91f])
        by kozue.soulik.info (Postfix) with ESMTPA id 5D2DB1018B9;
        Thu, 31 Jan 2019 12:15:10 +0900 (JST)
From:   ayaka <ayaka@soulik.info>
To:     linux-media@vger.kernel.org
Cc:     ayaka <ayaka@soulik.info>, acourbot@chromium.org,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        randy.li@rock-chips.com, jernej.skrabec@gmail.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        maxime.ripard@bootlin.com, hverkuil@xs4all.nl,
        ezequiel@collabora.com, thomas.petazzoni@bootlin.com,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 3/4] [TEST]: rockchip: mpp: support qtable
Date:   Thu, 31 Jan 2019 11:13:32 +0800
Message-Id: <20190131031333.11905-4-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131031333.11905-1-ayaka@soulik.info>
References: <20190131031333.11905-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Yes, the buffer won't be freed.
I don't want to store buffers for a session.
I just want to use it to verify the FFmpeg.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/staging/rockchip-mpp/mpp_dev_common.h |  3 ++
 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c  |  3 ++
 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c    | 42 +++++++++++++++----
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rockchip-mpp/mpp_dev_common.h b/drivers/staging/rockchip-mpp/mpp_dev_common.h
index 36770af53a95..33d7725be67b 100644
--- a/drivers/staging/rockchip-mpp/mpp_dev_common.h
+++ b/drivers/staging/rockchip-mpp/mpp_dev_common.h
@@ -100,6 +100,9 @@ struct mpp_session {
 	struct v4l2_ctrl_handler ctrl_handler;
 	/* TODO: FIXME: slower than helper function ? */
 	struct v4l2_ctrl **ctrls;
+
+	dma_addr_t qtable_addr;
+	void *qtable_vaddr;
 };
 
 /* The context for the a task */
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
index 03ed080bb35c..9e00501c3577 100644
--- a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
@@ -402,6 +402,9 @@ static int rkvdpu_open(struct file *filp)
 		return error;
 	}
 
+	session->qtable_vaddr = dmam_alloc_coherent(mpp_dev->dev, 64 * 4,
+						    &session->qtable_addr,
+						    GFP_KERNEL);
 	filp->private_data = &session->fh;
 
 	mpp_debug_leave();
diff --git a/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
index a16f7629a811..416348630779 100644
--- a/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
+++ b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
@@ -27,6 +27,34 @@
 
 #define DEC_LITTLE_ENDIAN	(1)
 
+static const u8 zigzag[64] = {
+	0,   1,  8, 16,  9,  2,  3, 10,
+	17, 24, 32, 25, 18, 11,  4,  5,
+	12, 19, 26, 33, 40, 48, 41, 34,
+	27, 20, 13,  6,  7, 14, 21, 28,
+	35, 42, 49, 56, 57, 50, 43, 36,
+	29, 22, 15, 23, 30, 37, 44, 51,
+	58, 59, 52, 45, 38, 31, 39, 46,
+	53, 60, 61, 54, 47, 55, 62, 63
+};
+
+static void mpeg2_dec_copy_qtable(u8 *qtable,
+	const struct v4l2_ctrl_mpeg2_quantization *ctrl)
+{
+	int i, n;
+
+	if (!qtable || !ctrl)
+		return;
+
+	for (i = 0; i < 64; i++) {
+		n = zigzag[i];
+		qtable[n + 0] = ctrl->intra_quantiser_matrix[i];
+		qtable[n + 64] = ctrl->non_intra_quantiser_matrix[i];
+		qtable[n + 128] = ctrl->chroma_intra_quantiser_matrix[i];
+		qtable[n + 192] = ctrl->chroma_non_intra_quantiser_matrix[i];
+	}
+}
+
 static void init_hw_cfg(struct vdpu2_regs *p_regs)
 {
     p_regs->sw54.dec_strm_wordsp = 1;
@@ -61,7 +89,6 @@ int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
 			 struct vb2_v4l2_buffer *src_buf)
 {
 	const struct v4l2_ctrl_mpeg2_slice_params *params;
-	const struct v4l2_ctrl_mpeg2_quantization *quantization;
 	const struct v4l2_mpeg2_sequence *sequence;
 	const struct v4l2_mpeg2_picture *picture;
 	struct sg_table *sgt;
@@ -69,9 +96,6 @@ int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
 
 	params = rockchip_mpp_get_cur_ctrl(session,
 			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
-	quantization = rockchip_mpp_get_cur_ctrl(session,
-			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
-
 	if (!params)
 		return -EINVAL;
 	
@@ -164,6 +188,7 @@ int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs)
 {
 	const struct v4l2_ctrl_mpeg2_slice_params *params;
 	const struct v4l2_mpeg2_sequence *sequence;
+	const struct v4l2_ctrl_mpeg2_quantization *quantization;
 	const struct v4l2_mpeg2_picture *picture;
 	struct vb2_v4l2_buffer *dst_buf;
 	dma_addr_t cur_addr, fwd_addr, bwd_addr;
@@ -177,6 +202,9 @@ int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs)
 	picture = &params->picture;
 	sequence = &params->sequence;
 
+	quantization = rockchip_mpp_get_cur_ctrl(session,
+			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
+
 	dst_buf = v4l2_m2m_next_dst_buf(session->fh.m2m_ctx);
 
 	sgt = vb2_dma_sg_plane_desc(&dst_buf->vb2_buf, 0);
@@ -219,9 +247,7 @@ int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs)
 	p_regs->sw134.refer2_base = bwd_addr >> 2;
 	p_regs->sw135.refer3_base = bwd_addr >> 2;
 
-#if 0
-        //ref & qtable config
-        p_regs->sw61.qtable_base = mpp_buffer_get_fd(ctx->qp_table);
-#endif
+	mpeg2_dec_copy_qtable(session->qtable_vaddr, quantization);
+        p_regs->sw61.qtable_base = session->qtable_addr;
 	return 0;
 }
-- 
2.20.1

