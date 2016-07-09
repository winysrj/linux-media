Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43584 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbcGIHdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jul 2016 03:33:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] mtk-vcodec: fix two compiler warnings
Date: Sat,  9 Jul 2016 09:32:57 +0200
Message-Id: <1468049578-10039-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

mtk-vcodec/mtk_vcodec_enc.c: In function 'mtk_venc_worker':
mtk-vcodec/mtk_vcodec_enc.c:1030:43: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'size_t {aka unsigned int}' [-Wformat=]
mtk-vcodec/mtk_vcodec_enc.c:1030:43: warning: format '%lx' expects argument of type 'long unsigned int', but argument 10 has type 'size_t {aka unsigned int}' [-Wformat=]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 6dcae0a..907a6d1 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -1028,7 +1028,7 @@ static void mtk_venc_worker(struct work_struct *work)
 	bs_buf.size = (size_t)dst_buf->planes[0].length;
 
 	mtk_v4l2_debug(2,
-			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=%zu",
+			"Framebuf VA=%p PA=%llx Size=0x%zx;VA=%p PA=0x%llx Size=0x%zx;VA=%p PA=0x%llx Size=%zu",
 			frm_buf.fb_addr[0].va,
 			(u64)frm_buf.fb_addr[0].dma_addr,
 			frm_buf.fb_addr[0].size,
-- 
2.8.1

