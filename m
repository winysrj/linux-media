Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:56765 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdFAHMB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 03:12:01 -0400
From: Jia-Ju Bai <baijiaju1990@163.com>
To: awalls@md.metrocast.net, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH V2] ivtv: Fix a sleep-in-atomic bug in snd_ivtv_pcm_hw_free
Date: Thu,  1 Jun 2017 15:13:54 +0800
Message-Id: <1496301234-2590-1-git-send-email-baijiaju1990@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver may sleep under a spin lock, and the function call path is:
snd_ivtv_pcm_hw_free (acquire the lock by spin_lock_irqsave)
  vfree --> may sleep

To fix it, the "substream->runtime->dma_area" is passed to a temporary
value, and mark it NULL when holding the lock. The memory is freed by
vfree through the temporary value outside the lock holding.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 807ead2..a692554 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -262,14 +262,17 @@ static int snd_ivtv_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_ivtv_card *itvsc = snd_pcm_substream_chip(substream);
 	unsigned long flags;
+	unsigned char *dma_area = NULL;
 
 	spin_lock_irqsave(&itvsc->slock, flags);
 	if (substream->runtime->dma_area) {
 		dprintk("freeing pcm capture region\n");
-		vfree(substream->runtime->dma_area);
+		dma_area = substream->runtime->dma_area;
 		substream->runtime->dma_area = NULL;
 	}
 	spin_unlock_irqrestore(&itvsc->slock, flags);
+	if (dma_area)
+		vfree(dma_area);
 
 	return 0;
 }
-- 
1.7.9.5
