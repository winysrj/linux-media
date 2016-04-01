Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35242 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbcDAWix (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 18:38:53 -0400
Received: by mail-qg0-f43.google.com with SMTP id y89so108330466qge.2
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 15:38:53 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 6/7] tw686x: audio: Allow to configure the period size
Date: Fri,  1 Apr 2016 19:38:26 -0300
Message-Id: <1459550307-688-7-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the driver has a fixed period size of 4096 bytes
(2048 frames). Since this hardware can configure the audio
capture size, this commit allows a period size range of [512-4096].

This is very useful to reduce the audio latency.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/tw686x-audio.c | 48 ++++++++++++++++++---------------
 drivers/media/pci/tw686x/tw686x-regs.h  |  4 +++
 drivers/media/pci/tw686x/tw686x.h       |  5 ++--
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
index a14d1b07edec..987a22663525 100644
--- a/drivers/media/pci/tw686x/tw686x-audio.c
+++ b/drivers/media/pci/tw686x/tw686x-audio.c
@@ -71,7 +71,7 @@ void tw686x_audio_irq(struct tw686x_dev *dev, unsigned long requests,
 		desc = &ac->dma_descs[pb];
 		if (desc->virt) {
 			memcpy(done->virt, desc->virt,
-			       desc->size);
+			       dev->period_size);
 		} else {
 			u32 reg = pb ? ADMA_B_ADDR[ch] : ADMA_P_ADDR[ch];
 			reg_write(dev, reg, next->dma);
@@ -93,10 +93,11 @@ static int tw686x_pcm_hw_free(struct snd_pcm_substream *ss)
 }
 
 /*
- * The audio device rate is global and shared among all
+ * Audio parameters are global and shared among all
  * capture channels. The driver makes no effort to prevent
- * rate modifications. User is free change the rate, but it
- * means changing the rate for all capture sub-devices.
+ * any modifications. User is free change the audio rate,
+ * or period size, thus changing parameters for all capture
+ * sub-devices.
  */
 static const struct snd_pcm_hardware tw686x_capture_hw = {
 	.info			= (SNDRV_PCM_INFO_MMAP |
@@ -109,9 +110,9 @@ static const struct snd_pcm_hardware tw686x_capture_hw = {
 	.rate_max		= 48000,
 	.channels_min		= 1,
 	.channels_max		= 1,
-	.buffer_bytes_max	= TW686X_AUDIO_PAGE_MAX * TW686X_AUDIO_PAGE_SZ,
-	.period_bytes_min	= TW686X_AUDIO_PAGE_SZ,
-	.period_bytes_max	= TW686X_AUDIO_PAGE_SZ,
+	.buffer_bytes_max	= TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX,
+	.period_bytes_min	= AUDIO_DMA_SIZE_MIN,
+	.period_bytes_max	= AUDIO_DMA_SIZE_MAX,
 	.periods_min		= TW686X_AUDIO_PERIODS_MIN,
 	.periods_max		= TW686X_AUDIO_PERIODS_MAX,
 };
@@ -166,12 +167,21 @@ static int tw686x_pcm_prepare(struct snd_pcm_substream *ss)
 		reg_write(dev, AUDIO_CONTROL2, reg);
 	}
 
-	if (period_size != TW686X_AUDIO_PAGE_SZ ||
-	    rt->periods < TW686X_AUDIO_PERIODS_MIN ||
-	    rt->periods > TW686X_AUDIO_PERIODS_MAX) {
-		return -EINVAL;
+	if (dev->period_size != period_size) {
+		u32 reg;
+
+		dev->period_size = period_size;
+		reg = reg_read(dev, AUDIO_CONTROL1);
+		reg &= ~(AUDIO_DMA_SIZE_MASK << AUDIO_DMA_SIZE_SHIFT);
+		reg |= period_size << AUDIO_DMA_SIZE_SHIFT;
+
+		reg_write(dev, AUDIO_CONTROL1, reg);
 	}
 
+	if (rt->periods < TW686X_AUDIO_PERIODS_MIN ||
+	    rt->periods > TW686X_AUDIO_PERIODS_MAX)
+		return -EINVAL;
+
 	spin_lock_irqsave(&ac->lock, flags);
 	INIT_LIST_HEAD(&ac->buf_list);
 
@@ -282,8 +292,8 @@ static int tw686x_snd_pcm_init(struct tw686x_dev *dev)
 	return snd_pcm_lib_preallocate_pages_for_all(pcm,
 				SNDRV_DMA_TYPE_DEV,
 				snd_dma_pci_data(dev->pci_dev),
-				TW686X_AUDIO_PAGE_MAX * TW686X_AUDIO_PAGE_SZ,
-				TW686X_AUDIO_PAGE_MAX * TW686X_AUDIO_PAGE_SZ);
+				TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX,
+				TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX);
 }
 
 static void tw686x_audio_dma_free(struct tw686x_dev *dev,
@@ -318,7 +328,7 @@ static int tw686x_audio_dma_alloc(struct tw686x_dev *dev,
 		u32 reg = pb ? ADMA_B_ADDR[ac->ch] : ADMA_P_ADDR[ac->ch];
 		void *virt;
 
-		virt = pci_alloc_consistent(dev->pci_dev, TW686X_AUDIO_PAGE_SZ,
+		virt = pci_alloc_consistent(dev->pci_dev, AUDIO_DMA_SIZE_MAX,
 					    &ac->dma_descs[pb].phys);
 		if (!virt) {
 			dev_err(&dev->pci_dev->dev,
@@ -327,7 +337,7 @@ static int tw686x_audio_dma_alloc(struct tw686x_dev *dev,
 			return -ENOMEM;
 		}
 		ac->dma_descs[pb].virt = virt;
-		ac->dma_descs[pb].size = TW686X_AUDIO_PAGE_SZ;
+		ac->dma_descs[pb].size = AUDIO_DMA_SIZE_MAX;
 		reg_write(dev, reg, ac->dma_descs[pb].phys);
 	}
 	return 0;
@@ -358,12 +368,8 @@ int tw686x_audio_init(struct tw686x_dev *dev)
 	struct snd_card *card;
 	int err, ch;
 
-	/*
-	 * AUDIO_CONTROL1
-	 * DMA byte length [31:19] = 4096 (i.e. ALSA period)
-	 * External audio enable [0] = enabled
-	 */
-	reg_write(dev, AUDIO_CONTROL1, 0x80000001);
+	/* Enable external audio */
+	reg_write(dev, AUDIO_CONTROL1, BIT(0));
 
 	err = snd_card_new(&pci_dev->dev, SNDRV_DEFAULT_IDX1,
 			   SNDRV_DEFAULT_STR1,
diff --git a/drivers/media/pci/tw686x/tw686x-regs.h b/drivers/media/pci/tw686x/tw686x-regs.h
index 37c39bcd7572..15a956642ef4 100644
--- a/drivers/media/pci/tw686x/tw686x-regs.h
+++ b/drivers/media/pci/tw686x/tw686x-regs.h
@@ -105,6 +105,10 @@
 						  0x2d0, 0x2d1, 0x2d2, 0x2d3 })
 
 #define SYS_MODE_DMA_SHIFT	13
+#define AUDIO_DMA_SIZE_SHIFT	19
+#define AUDIO_DMA_SIZE_MIN	SZ_512
+#define AUDIO_DMA_SIZE_MAX	SZ_4K
+#define AUDIO_DMA_SIZE_MASK	(SZ_8K - 1)
 
 #define DMA_CMD_ENABLE		BIT(31)
 #define INT_STATUS_DMA_TOUT	BIT(17)
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index fe848a40f9d0..a5e94e0454d0 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -27,7 +27,6 @@
 #define TYPE_SECOND_GEN		0x10
 #define TW686X_DEF_PHASE_REF	0x1518
 
-#define TW686X_AUDIO_PAGE_SZ		4096
 #define TW686X_AUDIO_PAGE_MAX		16
 #define TW686X_AUDIO_PERIODS_MIN	2
 #define TW686X_AUDIO_PERIODS_MAX	TW686X_AUDIO_PAGE_MAX
@@ -139,7 +138,9 @@ struct tw686x_dev {
 	struct tw686x_video_channel *video_channels;
 	struct tw686x_audio_channel *audio_channels;
 
-	int audio_rate; /* per-device value */
+	/* Per-device audio parameters */
+	int audio_rate;
+	int period_size;
 
 	struct timer_list dma_delay_timer;
 	u32 pending_dma_en; /* must be protected by lock */
-- 
2.7.0

