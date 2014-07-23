Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:38815
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752986AbaGWJ5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 05:57:03 -0400
From: Sonic Zhang <sonic.adi@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
CC: <linux-media@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/3] v4l2: bfin: Ensure delete and reinit list entry on NOMMU architecture
Date: Wed, 23 Jul 2014 17:57:15 +0800
Message-ID: <1406109436-23922-2-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
References: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

On NOMMU architecture page fault is not triggered if a deleted list entry is
accessed without reinit.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 2759cb6..4a8c4f0 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -446,7 +446,7 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 	while (!list_empty(&bcap_dev->dma_queue)) {
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
-		list_del(&bcap_dev->cur_frm->list);
+		list_del_init(&bcap_dev->cur_frm->list);
 		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
 	}
 }
@@ -533,7 +533,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 		}
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 				struct bcap_buffer, list);
-		list_del(&bcap_dev->cur_frm->list);
+		list_del_init(&bcap_dev->cur_frm->list);
 	} else {
 		/* clear error flag, we will get a new frame */
 		if (ppi->err)
@@ -583,7 +583,7 @@ static int bcap_streamon(struct file *file, void *priv,
 	bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 					struct bcap_buffer, list);
 	/* remove buffer from the dma queue */
-	list_del(&bcap_dev->cur_frm->list);
+	list_del_init(&bcap_dev->cur_frm->list);
 	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
 	/* update DMA address */
 	ppi->ops->update_addr(ppi, (unsigned long)addr);
-- 
1.8.2.3

