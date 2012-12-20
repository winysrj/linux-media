Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2LTQ4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Dec 2012 11:56:02 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] [media] sh_veu.c: fix two compilation warnings
Date: Thu, 20 Dec 2012 14:55:38 -0200
Message-Id: <1356022538-19636-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/sh_veu.c:269:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat]
drivers/media/platform/sh_veu.c:276:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat]

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/sh_veu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 7365fb5..a018676 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -266,15 +266,17 @@ static void sh_veu_process(struct sh_veu_dev *veu,
 	sh_veu_reg_write(veu, VEU_DAYR, addr + veu->vfmt_out.offset_y);
 	sh_veu_reg_write(veu, VEU_DACR, veu->vfmt_out.offset_c ?
 			 addr + veu->vfmt_out.offset_c : 0);
-	dev_dbg(veu->dev, "%s(): dst base %x, y: %x, c: %x\n", __func__,
-		addr, veu->vfmt_out.offset_y, veu->vfmt_out.offset_c);
+	dev_dbg(veu->dev, "%s(): dst base %lx, y: %x, c: %x\n", __func__,
+		(unsigned long)addr,
+		veu->vfmt_out.offset_y, veu->vfmt_out.offset_c);
 
 	addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
 	sh_veu_reg_write(veu, VEU_SAYR, addr + veu->vfmt_in.offset_y);
 	sh_veu_reg_write(veu, VEU_SACR, veu->vfmt_in.offset_c ?
 			 addr + veu->vfmt_in.offset_c : 0);
-	dev_dbg(veu->dev, "%s(): src base %x, y: %x, c: %x\n", __func__,
-		addr, veu->vfmt_in.offset_y, veu->vfmt_in.offset_c);
+	dev_dbg(veu->dev, "%s(): src base %lx, y: %x, c: %x\n", __func__,
+		(unsigned long)addr,
+		veu->vfmt_in.offset_y, veu->vfmt_in.offset_c);
 
 	sh_veu_reg_write(veu, VEU_STR, 1);
 
-- 
1.7.11.7

