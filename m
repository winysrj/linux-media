Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9678DC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B2121741
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548694857;
	bh=f84h8/LmByp5Et5fqYap9RrmrW4aQMDXFkdwaDWZygM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BCm7Ry2Ri00PzW9jdUmCc7gU4IWitSOXmDQGSzjRI0vqLAk9dvTAKxMo8Kvy/lV8s
	 X9bL771wl6KTO0YaLwwUwqx7OBFh9hffpvAjWAWmpTVqKNB16P6MCrl9Qbjv8f/4uM
	 odVb9CTfTYoM4vDs8mPbhskW5FsNjyGTugBLdvyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387798AbfA1QP1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733292AbfA1QP0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:15:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72DB820879;
        Mon, 28 Jan 2019 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692125;
        bh=f84h8/LmByp5Et5fqYap9RrmrW4aQMDXFkdwaDWZygM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViJG5H8TCko9JHrXEp5Jysek7svftrDtNHEoZHHpJ1Uhi9NXt50CfELakHHlr7awj
         8umr+N4+oKsEBsrHRZJaCCPmKTEbEL6ZtItXuwyU7iVLl3LECmMJkT2d2vjQC1tvyO
         K27UkNhnJT3lETCaV8zBouf6H/Knl58mJHr0Alew=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 078/170] media: coda: fix H.264 deblocking filter controls
Date:   Mon, 28 Jan 2019 11:10:28 -0500
Message-Id: <20190128161200.55107-78-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128161200.55107-1-sashal@kernel.org>
References: <20190128161200.55107-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 75fa6e4f83a0923fe753827d354998d448b4fd6a ]

Add support for the third loop filter mode
V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY,
and fix V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA and
V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA controls.

The filter offset controls are signed values in the -6 to 6 range and
are stored into the slice header fields slice_alpha_c0_offset_div2 and
slice_beta_offset_div2. The actual filter offsets FilterOffsetA/B are
double their value, in range of -12 to 12.

Rename variables to more closely match the nomenclature in the H.264
specification.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c    | 19 +++++++++----------
 drivers/media/platform/coda/coda-common.c | 15 +++++++--------
 drivers/media/platform/coda/coda.h        |  6 +++---
 drivers/media/platform/coda/coda_regs.h   |  2 +-
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 291c40933935..3457a5f1c8a8 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -953,16 +953,15 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		else
 			coda_write(dev, CODA_STD_H264,
 				   CODA_CMD_ENC_SEQ_COD_STD);
-		if (ctx->params.h264_deblk_enabled) {
-			value = ((ctx->params.h264_deblk_alpha &
-				  CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) <<
-				 CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET) |
-				((ctx->params.h264_deblk_beta &
-				  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) <<
-				 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET);
-		} else {
-			value = 1 << CODA_264PARAM_DISABLEDEBLK_OFFSET;
-		}
+		value = ((ctx->params.h264_disable_deblocking_filter_idc &
+			  CODA_264PARAM_DISABLEDEBLK_MASK) <<
+			 CODA_264PARAM_DISABLEDEBLK_OFFSET) |
+			((ctx->params.h264_slice_alpha_c0_offset_div2 &
+			  CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) <<
+			 CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET) |
+			((ctx->params.h264_slice_beta_offset_div2 &
+			  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) <<
+			 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET);
 		coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
 	case V4L2_PIX_FMT_JPEG:
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 99d138d3f87f..2e1472fadc2c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1675,14 +1675,13 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->params.h264_max_qp = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:
-		ctx->params.h264_deblk_alpha = ctrl->val;
+		ctx->params.h264_slice_alpha_c0_offset_div2 = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:
-		ctx->params.h264_deblk_beta = ctrl->val;
+		ctx->params.h264_slice_beta_offset_div2 = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
-		ctx->params.h264_deblk_enabled = (ctrl->val ==
-				V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+		ctx->params.h264_disable_deblocking_filter_idc = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		/* TODO: switch between baseline and constrained baseline */
@@ -1764,13 +1763,13 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_MAX_QP, 0, 51, 1, 51);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA, 0, 15, 1, 0);
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA, -6, 6, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA, 0, 15, 1, 0);
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA, -6, 6, 1, 0);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
-		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED, 0x0,
-		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY,
+		0x0, V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index c5f504d8cf67..389a882cc3da 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -114,9 +114,9 @@ struct coda_params {
 	u8			h264_inter_qp;
 	u8			h264_min_qp;
 	u8			h264_max_qp;
-	u8			h264_deblk_enabled;
-	u8			h264_deblk_alpha;
-	u8			h264_deblk_beta;
+	u8			h264_disable_deblocking_filter_idc;
+	s8			h264_slice_alpha_c0_offset_div2;
+	s8			h264_slice_beta_offset_div2;
 	u8			h264_profile_idc;
 	u8			h264_level_idc;
 	u8			mpeg4_intra_qp;
diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 38df5fd9a2fa..546f5762357c 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -292,7 +292,7 @@
 #define		CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET	8
 #define		CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK	0x0f
 #define		CODA_264PARAM_DISABLEDEBLK_OFFSET		6
-#define		CODA_264PARAM_DISABLEDEBLK_MASK		0x01
+#define		CODA_264PARAM_DISABLEDEBLK_MASK		0x03
 #define		CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET	5
 #define		CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK	0x01
 #define		CODA_264PARAM_CHROMAQPOFFSET_OFFSET		0
-- 
2.19.1

