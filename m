Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36575 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbcARMxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:53:35 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so11712061pfn.3
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:53:34 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 08/13] atmel-isi: remove the function set_dma_ctrl() as it just use once
Date: Mon, 18 Jan 2016 20:52:19 +0800
Message-Id: <1453121545-27528-3-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ed4d04b..e1ad18f 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -46,11 +46,6 @@ struct fbd {
 	u32 next_fbd_address;
 };
 
-static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
-{
-	fb_desc->dma_ctrl = ctrl;
-}
-
 struct isi_dma_desc {
 	struct list_head list;
 	struct fbd *p_fbd;
@@ -385,7 +380,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 			desc->p_fbd->fb_address =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 			desc->p_fbd->next_fbd_address = 0;
-			set_dma_ctrl(desc->p_fbd, ISI_DMA_CTRL_WB);
+			desc->p_fbd->dma_ctrl = ISI_DMA_CTRL_WB;
 
 			buf->p_dma_desc = desc;
 		}
-- 
1.9.1

