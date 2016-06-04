Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35099 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbcFDXrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2016 19:47:47 -0400
Received: by mail-qk0-f177.google.com with SMTP id p22so10179343qka.2
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2016 16:47:47 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [RESEND/PATCH 6/6] tw686x: audio: Prevent hw param changes while busy
Date: Sat,  4 Jun 2016 20:47:20 -0300
Message-Id: <1465084040-6112-7-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1465084040-6112-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1465084040-6112-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Audio hw params are shared across all DMA channels,
so if the user changes any of these while any DMA channel is
enabled, it will impact the enabled channels, potentially causing
serious instability issues.

This commit avoids such situation, by preventing any hw param
change (on any DMA channel) if any other DMA audio channel is capturing.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/tw686x-audio.c | 20 ++++++++++++++++----
 drivers/media/pci/tw686x/tw686x.h       |  1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
index 987a22663525..96e444c49173 100644
--- a/drivers/media/pci/tw686x/tw686x-audio.c
+++ b/drivers/media/pci/tw686x/tw686x-audio.c
@@ -94,10 +94,8 @@ static int tw686x_pcm_hw_free(struct snd_pcm_substream *ss)
 
 /*
  * Audio parameters are global and shared among all
- * capture channels. The driver makes no effort to prevent
- * any modifications. User is free change the audio rate,
- * or period size, thus changing parameters for all capture
- * sub-devices.
+ * capture channels. The driver prevents changes to
+ * the parameters if any audio channel is capturing.
  */
 static const struct snd_pcm_hardware tw686x_capture_hw = {
 	.info			= (SNDRV_PCM_INFO_MMAP |
@@ -154,6 +152,14 @@ static int tw686x_pcm_prepare(struct snd_pcm_substream *ss)
 	int i;
 
 	spin_lock_irqsave(&dev->lock, flags);
+	/*
+	 * Given the audio parameters are global (i.e. shared across
+	 * DMA channels), we need to check new params are allowed.
+	 */
+	if (((dev->audio_rate != rt->rate) ||
+	     (dev->period_size != period_size)) && dev->audio_enabled)
+		goto err_audio_busy;
+
 	tw686x_disable_channel(dev, AUDIO_CHANNEL_OFFSET + ac->ch);
 	spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -210,6 +216,10 @@ static int tw686x_pcm_prepare(struct snd_pcm_substream *ss)
 	spin_unlock_irqrestore(&ac->lock, flags);
 
 	return 0;
+
+err_audio_busy:
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return -EBUSY;
 }
 
 static int tw686x_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
@@ -223,6 +233,7 @@ static int tw686x_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
 	case SNDRV_PCM_TRIGGER_START:
 		if (ac->curr_bufs[0] && ac->curr_bufs[1]) {
 			spin_lock_irqsave(&dev->lock, flags);
+			dev->audio_enabled = 1;
 			tw686x_enable_channel(dev,
 				AUDIO_CHANNEL_OFFSET + ac->ch);
 			spin_unlock_irqrestore(&dev->lock, flags);
@@ -235,6 +246,7 @@ static int tw686x_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 		spin_lock_irqsave(&dev->lock, flags);
+		dev->audio_enabled = 0;
 		tw686x_disable_channel(dev, AUDIO_CHANNEL_OFFSET + ac->ch);
 		spin_unlock_irqrestore(&dev->lock, flags);
 
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index 4acb90543174..35d7bc94f78f 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -141,6 +141,7 @@ struct tw686x_dev {
 	/* Per-device audio parameters */
 	int audio_rate;
 	int period_size;
+	int audio_enabled;
 
 	struct timer_list dma_delay_timer;
 	u32 pending_dma_en; /* must be protected by lock */
-- 
2.7.0

