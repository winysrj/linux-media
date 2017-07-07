Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57215 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751862AbdGGJ6p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:58:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/5] [media] coda: set field of destination buffers
Date: Fri,  7 Jul 2017 11:58:28 +0200
Message-Id: <20170707095831.9852-2-p.zabel@pengutronix.de>
In-Reply-To: <20170707095831.9852-1-p.zabel@pengutronix.de>
References: <20170707095831.9852-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the field of destination buffers properly.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 50eed636830f8..a4abeabfa5377 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1412,6 +1412,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	}
 
 	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
+	dst_buf->field = src_buf->field;
 	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_buf->flags |=
 		src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
@@ -2154,6 +2155,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		dst_buf->sequence = ctx->osequence++;
 
+		dst_buf->field = V4L2_FIELD_NONE;
 		dst_buf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME |
 					     V4L2_BUF_FLAG_PFRAME |
 					     V4L2_BUF_FLAG_BFRAME);
-- 
2.11.0
