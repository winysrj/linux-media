Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaHZVzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:20 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 26/35] [media] atmel-isi: get rid of a warning
Date: Tue, 26 Aug 2014 18:55:02 -0300
Message-Id: <1409090111-8290-27-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/soc_camera/atmel-isi.c: In function 'start_streaming':
drivers/media/platform/soc_camera/atmel-isi.c:387:6: warning: variable 'sr' set but not used [-Wunused-but-set-variable]
  u32 sr = 0;
      ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 96a4b112e1ca..c5291b001057 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -384,7 +384,6 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	u32 sr = 0;
 	int ret;
 
 	/* Reset ISI */
@@ -398,7 +397,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
-	sr = isi_readl(isi, ISI_STATUS);
+	isi_readl(isi, ISI_STATUS);
 
 	if (count)
 		start_dma(isi, isi->active);
-- 
1.9.3

