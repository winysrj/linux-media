Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35164 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbdDIBe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:34:58 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] [media] netup_unidvb: use setup_timer
Date: Sun,  9 Apr 2017 09:34:02 +0800
Message-Id: <e7144ce822e4c235cfd6c41e11b64b638bc11fa7.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 191bd82..9444483 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -663,9 +663,8 @@ static int netup_unidvb_dma_init(struct netup_unidvb_dev *ndev, int num)
 	spin_lock_init(&dma->lock);
 	INIT_WORK(&dma->work, netup_unidvb_dma_worker);
 	INIT_LIST_HEAD(&dma->free_buffers);
-	dma->timeout.function = netup_unidvb_dma_timeout;
-	dma->timeout.data = (unsigned long)dma;
-	init_timer(&dma->timeout);
+	setup_timer(&dma->timeout, netup_unidvb_dma_timeout,
+		    (unsigned long)dma);
 	dma->ring_buffer_size = ndev->dma_size / 2;
 	dma->addr_virt = ndev->dma_virt + dma->ring_buffer_size * num;
 	dma->addr_phys = (dma_addr_t)((u64)ndev->dma_phys +
-- 
2.9.3
