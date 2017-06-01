Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:47939 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751090AbdFADR2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 23:17:28 -0400
From: Jia-Ju Bai <baijiaju1990@163.com>
To: awalls@md.metrocast.net, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] cx18: Fix a sleep-in-atomic bug in snd_cx18_pcm_hw_free
Date: Thu,  1 Jun 2017 11:19:21 +0800
Message-Id: <1496287161-17959-1-git-send-email-baijiaju1990@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver may sleep under a spin lock, and the function call path is:
snd_cx18_pcm_hw_free (acquire the lock by spin_lock_irqsave)
  vfree --> may sleep

To fix it, the "substream->runtime->dma_area" is passed to a temporary 
value, and mark it NULL when holding the lock. The memory is freed by 
vfree through the temporary value outside the lock holding.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/media/pci/cx18/cx18-alsa-pcm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index 205a98d..ba83147 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -257,14 +257,16 @@ static int snd_cx18_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_cx18_card *cxsc = snd_pcm_substream_chip(substream);
 	unsigned long flags;
+	unsigned char *dma_area;
 
 	spin_lock_irqsave(&cxsc->slock, flags);
 	if (substream->runtime->dma_area) {
 		dprintk("freeing pcm capture region\n");
-		vfree(substream->runtime->dma_area);
+		dma_area = substream->runtime->dma_area;
 		substream->runtime->dma_area = NULL;
 	}
 	spin_unlock_irqrestore(&cxsc->slock, flags);
+	vfree(dma_area);
 
 	return 0;
 }
-- 
1.7.9.5
