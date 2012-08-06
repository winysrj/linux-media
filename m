Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab2HFMH5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:07:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] [media] m2m-deinterlace: fix two warnings
Date: Mon,  6 Aug 2012 09:07:46 -0300
Message-Id: <1344254866-20417-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/m2m-deinterlace.c: In function ‘deinterlace_issue_dma’:
drivers/media/video/m2m-deinterlace.c:363:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has type ‘dma_addr_t’ [-Wformat]
drivers/media/video/m2m-deinterlace.c:363:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat]

Cc: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/m2m-deinterlace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/m2m-deinterlace.c b/drivers/media/video/m2m-deinterlace.c
index 1107167..a38c152 100644
--- a/drivers/media/video/m2m-deinterlace.c
+++ b/drivers/media/video/m2m-deinterlace.c
@@ -362,7 +362,8 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	if (dma_submit_error(ctx->cookie)) {
 		v4l2_warn(&pcdev->v4l2_dev,
 			  "DMA submit error %d with src=0x%x dst=0x%x len=0x%x\n",
-			  ctx->cookie, p_in, p_out, s_size * 3/2);
+			  ctx->cookie, (unsigned)p_in, (unsigned)p_out,
+			  s_size * 3/2);
 		return;
 	}
 
-- 
1.7.11.2

