Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:14819 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbcKRXVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:11 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 16/35] media: ti-vpe: vpe: Setup srcdst parameters in start_streaming
Date: Fri, 18 Nov 2016 17:20:26 -0600
Message-ID: <20161118232045.24665-17-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index c79137b404ea..1ee7e611e41b 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -869,6 +869,7 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	}
 
 	free_vbs(ctx);
+	ctx->src_vbs[2] = ctx->src_vbs[1] = ctx->src_vbs[0] = NULL;
 
 	ret = realloc_mv_buffers(ctx, mv_buf_size);
 	if (ret)
@@ -1990,6 +1991,9 @@ static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ctx->deinterlacing)
 		config_edi_input_mode(ctx, 0x0);
 
+	if (ctx->sequence != 0)
+		set_srcdst_params(ctx);
+
 	return 0;
 }
 
-- 
2.9.0

