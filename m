Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55250 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2AJJvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 04:51:03 -0500
Received: by iabz25 with SMTP id z25so657831iab.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 01:51:01 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH] [media] s5p-fimc: Fix incorrect control ID assignment
Date: Tue, 10 Jan 2012 15:16:57 +0530
Message-Id: <1326188817-12549-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the mismatch between control IDs (CID) and controls
for hflip, vflip and rotate.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 07c6254..170f791 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -811,11 +811,11 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
 	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
 
 	ctx->ctrl_rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
-				     V4L2_CID_HFLIP, 0, 1, 1, 0);
+					V4L2_CID_ROTATE, 0, 270, 90, 0);
 	ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
-				    V4L2_CID_VFLIP, 0, 1, 1, 0);
+					V4L2_CID_HFLIP, 0, 1, 1, 0);
 	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
-				    V4L2_CID_ROTATE, 0, 270, 90, 0);
+					V4L2_CID_VFLIP, 0, 1, 1, 0);
 	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
 
 	return ctx->ctrl_handler.error;
-- 
1.7.4.1

