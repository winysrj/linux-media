Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60796 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 02/21] [media] coda: bitrate can only be set in kbps steps
Date: Fri, 23 Jan 2015 17:51:16 +0100
Message-Id: <1422031895-7740-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 39330a7..1cc4e90 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1407,7 +1407,7 @@ static const struct v4l2_ctrl_ops coda_ctrl_ops = {
 static void coda_encode_ctrls(struct coda_ctx *ctx)
 {
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
+		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1000, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-- 
2.1.4

