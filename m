Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B292C43444
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E6A218A1
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfAHRN0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:13:26 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50901 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbfAHRN0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 12:13:26 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gguwN-0004Yr-VG; Tue, 08 Jan 2019 18:13:24 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/4] media: coda: Add control for h.264 chroma qp index offset
Date:   Tue,  8 Jan 2019 18:13:13 +0100
Message-Id: <20190108171313.1750-4-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190108171313.1750-1-p.zabel@pengutronix.de>
References: <20190108171313.1750-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Allow to set a fixed quantization parameter offset between luma and
chroma in the h.264 encoder.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 4 +++-
 drivers/media/platform/coda/coda-common.c | 5 +++++
 drivers/media/platform/coda/coda.h        | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 5e5accc3ae62..5ec70ab9f1b2 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1012,7 +1012,9 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) <<
 			 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET) |
 			(!!ctx->params.h264_constrained_intra_pred_flag <<
-			 CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET);
+			 CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET) |
+			(ctx->params.h264_chroma_qp_index_offset &
+			 CODA_264PARAM_CHROMAQPOFFSET_MASK);
 		coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
 	case V4L2_PIX_FMT_JPEG:
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f6c9273805bb..390d1ce6ab32 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1842,6 +1842,9 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
 		ctx->params.h264_constrained_intra_pred_flag = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET:
+		ctx->params.h264_chroma_qp_index_offset = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		/* TODO: switch between baseline and constrained baseline */
 		if (ctx->inst_type == CODA_INST_ENCODER)
@@ -1931,6 +1934,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION, 0, 1, 1,
 		0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET, -12, 12, 1, 0);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index f3d0cff4ef3a..31c80bda2c0b 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -119,6 +119,7 @@ struct coda_params {
 	s8			h264_slice_alpha_c0_offset_div2;
 	s8			h264_slice_beta_offset_div2;
 	bool			h264_constrained_intra_pred_flag;
+	s8			h264_chroma_qp_index_offset;
 	u8			h264_profile_idc;
 	u8			h264_level_idc;
 	u8			mpeg4_intra_qp;
-- 
2.20.1

