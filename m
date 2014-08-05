Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52212 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbaHERAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/15] [media] coda: remove unnecessary peek at next destination buffer from coda_finish_decode
Date: Tue,  5 Aug 2014 19:00:08 +0200
Message-Id: <1407258020-12078-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The return value of this call to v4l2_m2m_next_dst_buf() is never used.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 1d2716d..cc9afb7 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1580,8 +1580,6 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	u32 err_mb;
 	u32 val;
 
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-
 	/* Update kfifo out pointer from coda bitstream read pointer */
 	coda_kfifo_sync_from_device(ctx);
 
-- 
2.0.1

