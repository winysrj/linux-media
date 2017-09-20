Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34133 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbdITHiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 03:38:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org, hans.verkuil@cisco.com,
        sean@mess.org, andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [media] coda: Handle return value of kasprintf
Date: Wed, 20 Sep 2017 13:07:12 +0530
Message-Id: <1505893033-7491-2-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1505893033-7491-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1505893033-7491-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kasprintf() can fail here and we must check its return value.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/platform/coda/coda-bit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 291c409..8d78183 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -417,6 +417,9 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 		    dev->devtype->product != CODA_DX6)
 			size += ysize / 4;
 		name = kasprintf(GFP_KERNEL, "fb%d", i);
+		if (!name)
+			return -ENOMEM;
+
 		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i],
 					     size, name);
 		kfree(name);
-- 
1.9.1
