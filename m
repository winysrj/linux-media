Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33709 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935703AbdCXONS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 10:13:18 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ivtv: use for_each_sg
Date: Fri, 24 Mar 2017 22:12:24 +0800
Message-Id: <ae06036ff3f082b326194df27d5933d786d82619.1490326469.git.geliangtang@gmail.com>
In-Reply-To: <e9923f7ea2c0fd866efb48be52ffe91d25dd0290.1490326970.git.geliangtang@gmail.com>
References: <e9923f7ea2c0fd866efb48be52ffe91d25dd0290.1490326970.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use for_each_sg() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/ivtv/ivtv-udma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
index 2c9232e..3b33e87 100644
--- a/drivers/media/pci/ivtv/ivtv-udma.c
+++ b/drivers/media/pci/ivtv/ivtv-udma.c
@@ -76,7 +76,7 @@ void ivtv_udma_fill_sg_array (struct ivtv_user_dma *dma, u32 buffer_offset, u32
 	int i;
 	struct scatterlist *sg;
 
-	for (i = 0, sg = dma->SGlist; i < dma->SG_length; i++, sg = sg_next(sg)) {
+	for_each_sg(dma->SGlist, sg, dma->SG_length, i) {
 		dma->SGarray[i].size = cpu_to_le32(sg_dma_len(sg));
 		dma->SGarray[i].src = cpu_to_le32(sg_dma_address(sg));
 		dma->SGarray[i].dst = cpu_to_le32(buffer_offset);
-- 
2.9.3
