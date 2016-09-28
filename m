Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58194 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933372AbcI1VV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:59 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 16/35] media: ti-vpe: vpe: Setup srcdst parameters in start_streaming
Date: Wed, 28 Sep 2016 16:21:52 -0500
Message-ID: <20160928212152.27040-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

For deinterlacing operation, each operation needs 2 fields in the
history. This is achieved by holding three buffers in
ctx->src_vbs[0,1,2] (f,f-1,f-2)

This is achieved by using the ctx->sequence which gets reset via the
s_fmt ioctl.

These buffers are dequeued in stream OFF by calling free_vbs()
But the corresponding references aren't removed anywhere.

When application tries to stream ON and OFF continuously, s_fmt ioctl
won't be called and it won't setup the srcdst parameters.

Setting source/destination parameters in stream ON ioctl would make
sure that the context is re-initialized before it is being used by
the driver.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ab677f34a627..08b363feb4fc 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -869,6 +869,7 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	}
 
 	free_vbs(ctx);
+	ctx->src_vbs[2] = ctx->src_vbs[1] = ctx->src_vbs[0] = NULL;
 
 	ret = realloc_mv_buffers(ctx, mv_buf_size);
 	if (ret)
@@ -1991,6 +1992,9 @@ static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ctx->deinterlacing)
 		config_edi_input_mode(ctx, 0x0);
 
+	if (ctx->sequence != 0)
+		set_srcdst_params(ctx);
+
 	return 0;
 }
 
-- 
2.9.0

