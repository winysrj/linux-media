Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Archit Taneja <archit@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 19/46] [media] ti-vpe: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:51 -0300
Message-Id: <6b444344a55146d71be1e62ae7ca4e67442d3950.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 773b1fbf3269..febeca70211b 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -835,10 +835,10 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 					VPDMA_STRIDE_ALIGN);
 		mv_buf_size = bytes_per_line * s_q_data->height;
 
-		ctx->deinterlacing = 1;
+		ctx->deinterlacing = true;
 		src_h <<= 1;
 	} else {
-		ctx->deinterlacing = 0;
+		ctx->deinterlacing = false;
 		mv_buf_size = 0;
 	}
 
-- 
1.9.3

