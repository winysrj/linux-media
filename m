Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33625 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbcARMxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:53:54 -0500
Received: by mail-pa0-f68.google.com with SMTP id pv5so33614422pac.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:53:53 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 12/13] atmel-isi: use union for the fbd (frame buffer descriptor)
Date: Mon, 18 Jan 2016 20:52:24 +0800
Message-Id: <1453121545-27528-8-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

This way, we can easy to add other type of fbd for new hardware.

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 33 ++++++++++++++++++---------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 7d2e952..b4c1f38 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -37,7 +37,7 @@
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
 
 /* Frame buffer descriptor */
-struct fbd {
+struct fbd_isi_v2 {
 	/* Physical address of the frame buffer */
 	u32 fb_address;
 	/* DMA Control Register(only in HISI2) */
@@ -46,9 +46,13 @@ struct fbd {
 	u32 next_fbd_address;
 };
 
+union fbd {
+	struct fbd_isi_v2 fbd_isi;
+};
+
 struct isi_dma_desc {
 	struct list_head list;
-	struct fbd *p_fbd;
+	union fbd *p_fbd;
 	dma_addr_t fbd_phys;
 };
 
@@ -69,7 +73,7 @@ struct atmel_isi {
 	struct vb2_alloc_ctx		*alloc_ctx;
 
 	/* Allocate descriptors for dma buffer use */
-	struct fbd			*p_fb_descriptors;
+	union fbd			*p_fb_descriptors;
 	dma_addr_t			fb_descriptors_phys;
 	struct				list_head dma_desc_head;
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
@@ -396,6 +400,16 @@ static int buffer_init(struct vb2_buffer *vb)
 	return 0;
 }
 
+static void isi_hw_init_dma_desc(union fbd *p_fdb, u32 fb_addr,
+				 u32 next_fbd_addr)
+{
+	struct fbd_isi_v2 *p = &(p_fdb->fbd_isi);
+
+	p->fb_address = fb_addr;
+	p->next_fbd_address = next_fbd_addr;
+	p->dma_ctrl = ISI_DMA_CTRL_WB;
+}
+
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -428,10 +442,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 			list_del_init(&desc->list);
 
 			/* Initialize the dma descriptor */
-			desc->p_fbd->fb_address =
-					vb2_dma_contig_plane_dma_addr(vb, 0);
-			desc->p_fbd->next_fbd_address = 0;
-			desc->p_fbd->dma_ctrl = ISI_DMA_CTRL_WB;
+			isi_hw_init_dma_desc(desc->p_fbd, vb2_dma_contig_plane_dma_addr(vb, 0), 0);
 
 			buf->p_dma_desc = desc;
 		}
@@ -923,7 +934,7 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	soc_camera_host_unregister(soc_host);
 	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
 	dma_free_coherent(&pdev->dev,
-			sizeof(struct fbd) * MAX_BUFFER_NUM,
+			sizeof(union fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
 	pm_runtime_disable(&pdev->dev);
@@ -1010,7 +1021,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
-				sizeof(struct fbd) * MAX_BUFFER_NUM,
+				sizeof(union fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
 				GFP_KERNEL);
 	if (!isi->p_fb_descriptors) {
@@ -1021,7 +1032,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
 		isi->dma_desc[i].p_fbd = isi->p_fb_descriptors + i;
 		isi->dma_desc[i].fbd_phys = isi->fb_descriptors_phys +
-					i * sizeof(struct fbd);
+					i * sizeof(union fbd);
 		list_add(&isi->dma_desc[i].list, &isi->dma_desc_head);
 	}
 
@@ -1080,7 +1091,7 @@ err_ioremap:
 	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
 err_alloc_ctx:
 	dma_free_coherent(&pdev->dev,
-			sizeof(struct fbd) * MAX_BUFFER_NUM,
+			sizeof(union fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
 
-- 
1.9.1

