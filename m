Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55396 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755153AbeDFOXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 17/21] media: ispstat: use %p to print the address of a buffer
Date: Fri,  6 Apr 2018 10:23:18 -0400
Message-Id: <76525da04eb7d8e5faaff7dc5173a05467b96965.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of converting to int, use %p. That prevents this
warning:
	drivers/media/platform/omap3isp/ispstat.c:451 isp_stat_bufs_alloc() warn: argument 7 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 47cbc7e3d825..eb1b589b0aeb 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -449,10 +449,10 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 		buf->empty = 1;
 
 		dev_dbg(stat->isp->dev,
-			"%s: buffer[%u] allocated. dma=0x%08lx virt=0x%08lx",
+			"%s: buffer[%u] allocated. dma=0x%08lx virt=%p",
 			stat->subdev.name, i,
 			(unsigned long)buf->dma_addr,
-			(unsigned long)buf->virt_addr);
+			buf->virt_addr);
 	}
 
 	return 0;
-- 
2.14.3
