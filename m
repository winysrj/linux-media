Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 10/35] [media] atmel-isi: Fix a truncate warning
Date: Tue, 26 Aug 2014 18:54:46 -0300
Message-Id: <1409090111-8290-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   drivers/media/platform/soc_camera/atmel-isi.c: In function 'start_streaming':
   drivers/media/platform/soc_camera/atmel-isi.c:397:26: warning: large integer implicitly truncated to unsigned type [-Woverflow]
     isi_writel(isi, ISI_INTDIS, ~0UL);
                             ^

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f87012b15b28..96a4b112e1ca 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -394,7 +394,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 		return ret;
 	}
 	/* Disable all interrupts */
-	isi_writel(isi, ISI_INTDIS, ~0UL);
+	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
-- 
1.9.3

