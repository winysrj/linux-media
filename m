Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36203 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbcDAWiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 18:38:51 -0400
Received: by mail-qg0-f50.google.com with SMTP id f52so11796939qga.3
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 15:38:51 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 5/7] tw686x: audio: Implement non-memcpy capture
Date: Fri,  1 Apr 2016 19:38:25 -0300
Message-Id: <1459550307-688-6-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we've introduced the dma_mode parameter to pick the
DMA operation, let's use it to also select the audio DMA
operation.

When dma_mode != memcpy, the driver will avoid using memcpy
in the audio capture path, and the DMA hardware operation
will act directly on the ALSA buffers.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/tw686x-audio.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
index 91459ab715b2..a14d1b07edec 100644
--- a/drivers/media/pci/tw686x/tw686x-audio.c
+++ b/drivers/media/pci/tw686x/tw686x-audio.c
@@ -62,12 +62,22 @@ void tw686x_audio_irq(struct tw686x_dev *dev, unsigned long requests,
 		}
 		spin_unlock_irqrestore(&ac->lock, flags);
 
+		if (!done || !next)
+			continue;
+		/*
+		 * Checking for a non-nil dma_desc[pb]->virt buffer is
+		 * the same as checking for memcpy DMA mode.
+		 */
 		desc = &ac->dma_descs[pb];
-		if (done && next && desc->virt) {
-			memcpy(done->virt, desc->virt, desc->size);
-			ac->ptr = done->dma - ac->buf[0].dma;
-			snd_pcm_period_elapsed(ac->ss);
+		if (desc->virt) {
+			memcpy(done->virt, desc->virt,
+			       desc->size);
+		} else {
+			u32 reg = pb ? ADMA_B_ADDR[ch] : ADMA_P_ADDR[ch];
+			reg_write(dev, reg, next->dma);
 		}
+		ac->ptr = done->dma - ac->buf[0].dma;
+		snd_pcm_period_elapsed(ac->ss);
 	}
 }
 
@@ -181,6 +191,12 @@ static int tw686x_pcm_prepare(struct snd_pcm_substream *ss)
 	ac->curr_bufs[0] = p_buf;
 	ac->curr_bufs[1] = b_buf;
 	ac->ptr = 0;
+
+	if (dev->dma_mode != TW686X_DMA_MODE_MEMCPY) {
+		reg_write(dev, ADMA_P_ADDR[ac->ch], p_buf->dma);
+		reg_write(dev, ADMA_B_ADDR[ac->ch], b_buf->dma);
+	}
+
 	spin_unlock_irqrestore(&ac->lock, flags);
 
 	return 0;
@@ -290,6 +306,14 @@ static int tw686x_audio_dma_alloc(struct tw686x_dev *dev,
 {
 	int pb;
 
+	/*
+	 * In the memcpy DMA mode we allocate a consistent buffer
+	 * and use it for the DMA capture. Otherwise, DMA
+	 * acts on the ALSA buffers as received in pcm_prepare.
+	 */
+	if (dev->dma_mode != TW686X_DMA_MODE_MEMCPY)
+		return 0;
+
 	for (pb = 0; pb < 2; pb++) {
 		u32 reg = pb ? ADMA_B_ADDR[ac->ch] : ADMA_P_ADDR[ac->ch];
 		void *virt;
-- 
2.7.0

