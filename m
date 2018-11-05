Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52695 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 13/15] media: coda: improve queue busy error message
Date: Mon,  5 Nov 2018 16:25:11 +0100
Message-Id: <20181105152513.26345-13-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_type_names to indicate which of the two queues is busy.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index fd9bc19cd79b..b3d73965614a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -703,7 +703,8 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 		return -EINVAL;
 
 	if (vb2_is_busy(vq)) {
-		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		v4l2_err(&ctx->dev->v4l2_dev, "%s: %s queue busy: %d\n",
+			 __func__, v4l2_type_names[f->type], vq->num_buffers);
 		return -EBUSY;
 	}
 
-- 
2.19.1
