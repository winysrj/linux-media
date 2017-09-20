Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35640 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdITJl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 05:41:57 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org, hans.verkuil@cisco.com,
        sean@mess.org, andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] [media] coda: Handle return value of kasprintf
Date: Wed, 20 Sep 2017 15:10:58 +0530
Message-Id: <5533660490db4a91bb25e3984c3d6bd20eb230f6.1505899966.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kasprintf() can fail here and we must check its return value.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2 :
	Calling coda_free_framebuffers to release already allocated buffers.

 drivers/media/platform/coda/coda-bit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 291c409..bfc4ecf 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -417,6 +417,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 		    dev->devtype->product != CODA_DX6)
 			size += ysize / 4;
 		name = kasprintf(GFP_KERNEL, "fb%d", i);
+		if (!name) {
+			coda_free_framebuffers(ctx);
+			return -ENOMEM;
+		}
 		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i],
 					     size, name);
 		kfree(name);
-- 
1.9.1
