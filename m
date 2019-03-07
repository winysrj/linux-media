Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62EBC10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E81C20835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfCGKKH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:10:07 -0500
Received: from regular1.263xmail.com ([211.150.99.136]:48100 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfCGKKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 05:10:05 -0500
Received: from randy.li?rock-chips.com (unknown [192.168.167.139])
        by regular1.263xmail.com (Postfix) with ESMTP id 635AD484;
        Thu,  7 Mar 2019 18:03:36 +0800 (CST)
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
Received: from randy-pc.lan (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P17008T140071111993088S1551952999924990_;
        Thu, 07 Mar 2019 18:03:36 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <daa0b414b043c0309fe2383c8ebb87b6>
X-RL-SENDER: randy.li@rock-chips.com
X-SENDER: randy.li@rock-chips.com
X-LOGIN-NAME: randy.li@rock-chips.com
X-FST-TO: linux-media@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Randy Li <randy.li@rock-chips.com>
To:     linux-media@vger.kernel.org
Cc:     Randy Li <randy.li@rock-chips.com>, ayaka@soulik.info,
        hverkuil@xs4all.nl, maxime.ripard@bootlin.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, jernej.skrabec@gmail.com,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        linux-rockchip@lists.infradead.org, thomas.petazzoni@bootlin.com,
        mchehab@kernel.org, ezequiel@collabora.com,
        linux-arm-kernel@lists.infradead.org, posciak@chromium.org,
        groeck@chromium.org
Subject: [PATCH v2 3/6] [TEST]: rockchip: mpp: support qptable
Date:   Thu,  7 Mar 2019 18:03:13 +0800
Message-Id: <20190307100316.925-4-randy.li@rock-chips.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190307100316.925-1-randy.li@rock-chips.com>
References: <20190307100316.925-1-randy.li@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

I don't care, I don't want to store buffers for a session.
I just want to use it to verify the FFmpeg.

I want the memory region !!!
It can save more time if those data are prepared in userspace.

Signed-off-by: Randy Li <randy.li@rock-chips.com>
---
 drivers/staging/rockchip-mpp/mpp_dev_common.c |  3 +--
 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c  |  3 +++
 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c    | 19 +++++++++++++------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rockchip-mpp/mpp_dev_common.c b/drivers/staging/rockchip-mpp/mpp_dev_common.c
index c43304c3e7b8..1291b642179e 100644
--- a/drivers/staging/rockchip-mpp/mpp_dev_common.c
+++ b/drivers/staging/rockchip-mpp/mpp_dev_common.c
@@ -1193,8 +1193,7 @@ static int rockchip_mpp_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
 	src_vq->drv_priv = session;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
-	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
-			    DMA_ATTR_NO_KERNEL_MAPPING;
+	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->min_buffers_needed = 1;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
index ce98aa15025e..00413936623e 100644
--- a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
@@ -147,6 +147,9 @@ static int rkvdpu_s_fmt_vid_out_mplane(struct file *filp, void *priv,
 	if (sizes >= SZ_16M)
 		return -EINVAL;
 
+	/* For those slice header data */
+	pix_mp->plane_fmt[pix_mp->num_planes - 1].sizeimage += SZ_1M;
+
 	session->fmt_out = *pix_mp;
 
 	/* Copy the pixel format information from OUTPUT to CAPUTRE */
diff --git a/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
index d32958c4cb20..c12d1a8ef2da 100644
--- a/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
+++ b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
@@ -52,7 +52,7 @@ static const u8 intra_default_q_matrix[64] = {
 static void mpeg2_dec_copy_qtable(u8 * qtable, const struct v4l2_ctrl_mpeg2_quantization
 				  *ctrl)
 {
-	int i, n;
+	int i;
 
 	if (!qtable || !ctrl)
 		return;
@@ -111,21 +111,22 @@ int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
 			 struct vb2_v4l2_buffer *src_buf)
 {
 	const struct v4l2_ctrl_mpeg2_slice_params *params;
-	const struct v4l2_ctrl_mpeg2_quantization *quantization;
 	const struct v4l2_mpeg2_sequence *sequence;
 	const struct v4l2_mpeg2_picture *picture;
+	const struct v4l2_ctrl_mpeg2_quantization *quantization;
 	struct vdpu2_regs *p_regs = regs;
+	void *qtable = NULL;
+	size_t stream_len = 0;
 
 	params = rockchip_mpp_get_cur_ctrl(session,
 					   V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
-	quantization = rockchip_mpp_get_cur_ctrl(session,
-						 V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
-
 	if (!params)
 		return -EINVAL;
 
 	sequence = &params->sequence;
 	picture = &params->picture;
+	quantization = rockchip_mpp_get_cur_ctrl(session,
+			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
 
 	init_hw_cfg(p_regs);
 
@@ -202,7 +203,13 @@ int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
 	p_regs->sw64.rlc_vlc_base =
 	    vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
 	p_regs->sw122.strm_start_bit = params->data_bit_offset;
-	p_regs->sw51.stream_len = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
+	stream_len = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
+	p_regs->sw51.stream_len = stream_len;
+
+	qtable = vb2_plane_vaddr(&src_buf->vb2_buf, 0) + ALIGN(stream_len, 8);
+	mpeg2_dec_copy_qtable(qtable, quantization);
+        p_regs->sw61.qtable_base = p_regs->sw64.rlc_vlc_base
+		+ ALIGN(stream_len, 8);
 
 	return 0;
 }
-- 
2.20.1



