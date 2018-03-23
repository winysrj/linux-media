Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46822 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754062AbeCWL5f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 24/30] media: saa7134-alsa: don't use casts to print a buffer address
Date: Fri, 23 Mar 2018 07:57:10 -0400
Message-Id: <6062ba61567f8e08f1767ae6d1c3788247da81dc.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the logic there to avoid casting, solving this warning:
	drivers/media/pci/saa7134/saa7134-alsa.c:276 saa7134_alsa_dma_init() warn: argument 3 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/saa7134/saa7134-alsa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index c59b69f1af9d..72311445d13d 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -273,9 +273,8 @@ static int saa7134_alsa_dma_init(struct saa7134_dev *dev, int nr_pages)
 		return -ENOMEM;
 	}
 
-	pr_debug("vmalloc is at addr 0x%08lx, size=%d\n",
-				(unsigned long)dma->vaddr,
-				nr_pages << PAGE_SHIFT);
+	pr_debug("vmalloc is at addr %p, size=%d\n",
+		 dma->vaddr, nr_pages << PAGE_SHIFT);
 
 	memset(dma->vaddr, 0, nr_pages << PAGE_SHIFT);
 	dma->nr_pages = nr_pages;
-- 
2.14.3
