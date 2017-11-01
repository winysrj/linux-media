Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45754 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933333AbdKAVGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 09/26] media: cx25821-alsa: fix usage of a pointer printk
Date: Wed,  1 Nov 2017 17:05:46 -0400
Message-Id: <c3e209a8eea5b2f37312f3bc4073995778a740e5.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/cx25821/cx25821-alsa.c:155 cx25821_alsa_dma_init() warn: argument 3 to %08lx specifier is cast from pointer

Use the standard %p to print a pointer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx25821/cx25821-alsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 2b34990e86f2..a45bf0331eeb 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -152,8 +152,8 @@ static int cx25821_alsa_dma_init(struct cx25821_audio_dev *chip, int nr_pages)
 		return -ENOMEM;
 	}
 
-	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
-				(unsigned long)buf->vaddr,
+	dprintk(1, "vmalloc is at addr 0x%p, size=%d\n",
+				buf->vaddr,
 				nr_pages << PAGE_SHIFT);
 
 	memset(buf->vaddr, 0, nr_pages << PAGE_SHIFT);
-- 
2.13.6
