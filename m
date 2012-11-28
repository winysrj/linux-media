Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46809 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2K1TJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:43 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	stable@vger.kernel.org
Subject: [PATCH RFC 02/12] s5p-fimc: Fix horizontal/vertical image flip
Date: Wed, 28 Nov 2012 20:09:19 +0100
Message-id: <1354129766-2821-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting FIMC_REG_CITRGFMT_FLIP_X_MIRROR bit causes X-axis image
flip (vertical flip) and thus it corresponds to V4L2_CID_VFLIP.

Likewise, setting FIMC_REG_CITRGFMT_FLIP_Y_MIRROR bit causes Y-axis
image flip (horizontal flip) and thus it corresponds to V4L2_CID_HFLIP.

Currently the driver does X-axis flip when V4L2_CID_HFLIP is set and
Y-axis flip for V4L2_CID_VFLIP. Fix this incorrect assignment by setting
proper FIMC_REG_CITRGFMT register bits for ctx->hflip and ctx->vflip.

Cc: stable@vger.kernel.org
Reported-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-reg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 2c9d0c0..9c3c461 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -44,9 +44,9 @@ static u32 fimc_hw_get_in_flip(struct fimc_ctx *ctx)
 	u32 flip = FIMC_REG_MSCTRL_FLIP_NORMAL;
 
 	if (ctx->hflip)
-		flip = FIMC_REG_MSCTRL_FLIP_X_MIRROR;
-	if (ctx->vflip)
 		flip = FIMC_REG_MSCTRL_FLIP_Y_MIRROR;
+	if (ctx->vflip)
+		flip = FIMC_REG_MSCTRL_FLIP_X_MIRROR;
 
 	if (ctx->rotation <= 90)
 		return flip;
@@ -59,9 +59,9 @@ static u32 fimc_hw_get_target_flip(struct fimc_ctx *ctx)
 	u32 flip = FIMC_REG_CITRGFMT_FLIP_NORMAL;
 
 	if (ctx->hflip)
-		flip |= FIMC_REG_CITRGFMT_FLIP_X_MIRROR;
-	if (ctx->vflip)
 		flip |= FIMC_REG_CITRGFMT_FLIP_Y_MIRROR;
+	if (ctx->vflip)
+		flip |= FIMC_REG_CITRGFMT_FLIP_X_MIRROR;
 
 	if (ctx->rotation <= 90)
 		return flip;
-- 
1.7.9.5

