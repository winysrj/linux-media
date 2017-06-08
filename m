Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:45107 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750752AbdFHJVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 05:21:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: ctx->codec is not NULL in coda_alloc_framebuffers
Date: Thu,  8 Jun 2017 11:21:13 +0200
Message-Id: <20170608092113.16873-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a smatch warning:

    drivers/media/platform/coda/coda-bit.c:415 coda_alloc_framebuffers()
    error: we previously assumed 'ctx->codec' could be null (see line 396)

coda_alloc_framebuffers() is called from coda_start_encoding() and
__coda_start_decoding(). Both dereference ctx->codec before calling
coda_alloc_framebuffers() in lines 935 and 1649, so ctx->codec can not
be NULL.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 795b6d7584320..bba1eb43b5d83 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -393,8 +393,8 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	int ret;
 	int i;
 
-	if (ctx->codec && (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
-	     ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264)) {
+	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
+	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264) {
 		width = round_up(q_data->width, 16);
 		height = round_up(q_data->height, 16);
 	} else {
-- 
2.11.0
