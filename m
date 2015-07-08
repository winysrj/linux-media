Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:2087 "EHLO
	mail2.data-modul.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758652AbbGHNoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jul 2015 09:44:38 -0400
From: Zahari Doychev <zahari.doychev@linux.com>
To: linux-media@vger.kernel.org, p.zabel@pengutronix.de,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	hans.verkuil@cisco.com
Subject: [PATCH 1/2] [media] coda: fix sequence counter increment
Date: Wed,  8 Jul 2015 15:37:19 +0200
Message-Id: <22a947a9955de80579174ba9232a597283e330eb.1436361987.git.zahari.doychev@linux.com>
In-Reply-To: <cover.1436361987.git.zahari.doychev@linux.com>
References: <cover.1436361987.git.zahari.doychev@linux.com>
In-Reply-To: <cover.1436361987.git.zahari.doychev@linux.com>
References: <cover.1436361987.git.zahari.doychev@linux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda context queue sequence counter is incremented only if the vb2
source buffer payload is non zero. This makes possible to signal EOS
otherwise the condition in coda_buf_is_end_of_stream is never met or more
precisely buf->v4l2_buf.sequence == (ctx->qsequence - 1) never happens.

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 drivers/media/platform/coda/coda-bit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 109797b..d33f187 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -189,7 +189,8 @@ static int coda_bitstream_queue(struct coda_ctx *ctx,
 	if (n < src_size)
 		return -ENOSPC;
 
-	src_buf->v4l2_buf.sequence = ctx->qsequence++;
+	if (src_size)
+		src_buf->v4l2_buf.sequence = ctx->qsequence++;
 
 	return 0;
 }
-- 
2.4.5

