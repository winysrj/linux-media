Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D203C43612
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF280218A3
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfAHRNZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:13:25 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35417 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbfAHRNY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 12:13:24 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gguwM-0004Yr-P2; Tue, 08 Jan 2019 18:13:22 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/4] media: coda: Add control for h.264 constrained intra prediction
Date:   Tue,  8 Jan 2019 18:13:12 +0100
Message-Id: <20190108171313.1750-3-p.zabel@pengutronix.de>
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

Allow to enable constrained intra prediction in the h.264 encoder.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 4 +++-
 drivers/media/platform/coda/coda-common.c | 6 ++++++
 drivers/media/platform/coda/coda.h        | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 8e0194993a52..5e5accc3ae62 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1010,7 +1010,9 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			 CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET) |
 			((ctx->params.h264_slice_beta_offset_div2 &
 			  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) <<
-			 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET);
+			 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET) |
+			(!!ctx->params.h264_constrained_intra_pred_flag <<
+			 CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET);
 		coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
 	case V4L2_PIX_FMT_JPEG:
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7518f01c48f7..f6c9273805bb 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1839,6 +1839,9 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
 		ctx->params.h264_disable_deblocking_filter_idc = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
+		ctx->params.h264_constrained_intra_pred_flag = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		/* TODO: switch between baseline and constrained baseline */
 		if (ctx->inst_type == CODA_INST_ENCODER)
@@ -1925,6 +1928,9 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
 		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY,
 		0x0, V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION, 0, 1, 1,
+		0);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 31cea72f5b2a..f3d0cff4ef3a 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -118,6 +118,7 @@ struct coda_params {
 	u8			h264_disable_deblocking_filter_idc;
 	s8			h264_slice_alpha_c0_offset_div2;
 	s8			h264_slice_beta_offset_div2;
+	bool			h264_constrained_intra_pred_flag;
 	u8			h264_profile_idc;
 	u8			h264_level_idc;
 	u8			mpeg4_intra_qp;
-- 
2.20.1

