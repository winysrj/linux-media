Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54575 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLRQuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 11:50:13 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Sureau?=
	<frederic.sureau@vodalys.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] coda: bitrate can only be set in kbps steps
Date: Thu, 18 Dec 2014 17:50:00 +0100
Message-Id: <1418921400-724-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1418921400-724-1-git-send-email-p.zabel@pengutronix.de>
References: <1418921400-724-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 42b4630..74261d9 100644
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
2.1.3

