Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42139 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933453AbcLIQ7Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 11:59:25 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v2 5/7] [media] coda: fix frame index to returned error
Date: Fri,  9 Dec 2016 17:59:01 +0100
Message-Id: <20161209165903.1293-6-m.tretter@pengutronix.de>
In-Reply-To: <20161209165903.1293-1-m.tretter@pengutronix.de>
References: <20161209165903.1293-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

display_idx refers to the frame that will be returned in the next round.
The currently processed frame is ctx->display_idx and errors should be
reported for this frame.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index b662504..309eb4e 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2057,7 +2057,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		}
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
 
-		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[display_idx] ?
+		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[ctx->display_idx] ?
 				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-- 
2.10.2

