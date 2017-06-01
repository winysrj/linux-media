Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751185AbdFAU7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:08 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 14/27] ASoC: blackfin: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:37 +0200
Message-Id: <20170601205850.24993-15-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
In AC97 and I2S-TDM mode, we need to convert back to frames, but
otherwise the conversion is pretty straightforward.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/soc/blackfin/bf5xx-ac97-pcm.c | 27 +++++++++++++++++++--------
 sound/soc/blackfin/bf5xx-i2s-pcm.c  | 36 ++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
index 02ad2606fa19..913e29275f4e 100644
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -279,23 +279,33 @@ static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
 	return 0 ;
 }
 #else
-static	int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
-		    snd_pcm_uframes_t pos,
-		    void __user *buf, snd_pcm_uframes_t count)
+static	int bf5xx_pcm_copy(struct snd_pcm_substream *substream,
+			   int channel, unsigned long pos,
+			   void *buf, unsigned long count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	unsigned int chan_mask = ac97_chan_mask[runtime->channels - 1];
+	struct ac97_frame *dst;
+
 	pr_debug("%s copy pos:0x%lx count:0x%lx\n",
 			substream->stream ? "Capture" : "Playback", pos, count);
+	dst = (struct ac97_frame *)runtime->dma_area +
+		bytes_to_frames(runtime, pos);
+	count = bytes_to_frames(runtime, count);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		bf5xx_pcm_to_ac97((struct ac97_frame *)runtime->dma_area + pos,
-			(__u16 *)buf, count, chan_mask);
+		bf5xx_pcm_to_ac97(dst, buf, count, chan_mask);
 	else
-		bf5xx_ac97_to_pcm((struct ac97_frame *)runtime->dma_area + pos,
-			(__u16 *)buf, count);
+		bf5xx_ac97_to_pcm(dst, buf, count);
 	return 0;
 }
+
+static	int bf5xx_pcm_copy_user(struct snd_pcm_substream *substream,
+				int channel, unsigned long pos,
+				void __user *buf, unsigned long count)
+{
+	return bf5xx_pcm_copy(substream, channel, pos, (void *)buf, count);
+}
 #endif
 
 static struct snd_pcm_ops bf5xx_pcm_ac97_ops = {
@@ -309,7 +319,8 @@ static struct snd_pcm_ops bf5xx_pcm_ac97_ops = {
 #if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	.mmap		= bf5xx_pcm_mmap,
 #else
-	.copy		= bf5xx_pcm_copy,
+	.copy_user	= bf5xx_pcm_copy_user,
+	.copy_kernel	= bf5xx_pcm_copy,
 #endif
 };
 
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 6cba211da32e..470d99abf6f6 100644
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -225,8 +225,9 @@ static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
 	return 0 ;
 }
 
-static int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
-	snd_pcm_uframes_t pos, void *buf, snd_pcm_uframes_t count)
+static int bf5xx_pcm_copy(struct snd_pcm_substream *substream,
+			  int channel, unsigned long pos,
+			  void *buf, unsigned long count)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -238,6 +239,8 @@ static int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
 	if (dma_data->tdm_mode) {
+		pos = bytes_to_frames(runtime, pos);
+		count = bytes_to_frames(runtime, count);
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			src = buf;
 			dst = runtime->dma_area;
@@ -269,21 +272,29 @@ static int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			src = buf;
 			dst = runtime->dma_area;
-			dst += frames_to_bytes(runtime, pos);
+			dst += pos;
 		} else {
 			src = runtime->dma_area;
-			src += frames_to_bytes(runtime, pos);
+			src += pos;
 			dst = buf;
 		}
 
-		memcpy(dst, src, frames_to_bytes(runtime, count));
+		memcpy(dst, src, count);
 	}
 
 	return 0;
 }
 
+static int bf5xx_pcm_copy_user(struct snd_pcm_substream *substream,
+			       int channel, unsigned long pos,
+			       void __user *buf, unsigned long count)
+{
+	return bf5xx_pcm_copy(substream, channel, pos, (void *)buf, count);
+}
+
 static int bf5xx_pcm_silence(struct snd_pcm_substream *substream,
-	int channel, snd_pcm_uframes_t pos, snd_pcm_uframes_t count)
+			     int channel, unsigned long pos,
+			     unsigned long count)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -295,11 +306,11 @@ static int bf5xx_pcm_silence(struct snd_pcm_substream *substream,
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
 	if (dma_data->tdm_mode) {
-		offset = pos * 8 * sample_size;
-		samples = count * 8;
+		offset = bytes_to_frames(runtime, pos) * 8 * sample_size;
+		samples = bytes_to_frames(runtime, count) * 8;
 	} else {
-		offset = frames_to_bytes(runtime, pos);
-		samples = count * runtime->channels;
+		offset = pos;
+		samples = bytes_to_samples(runtime, count);
 	}
 
 	snd_pcm_format_set_silence(runtime->format, buf + offset, samples);
@@ -316,8 +327,9 @@ static struct snd_pcm_ops bf5xx_pcm_i2s_ops = {
 	.trigger	= bf5xx_pcm_trigger,
 	.pointer	= bf5xx_pcm_pointer,
 	.mmap		= bf5xx_pcm_mmap,
-	.copy		= bf5xx_pcm_copy,
-	.silence	= bf5xx_pcm_silence,
+	.copy_user	= bf5xx_pcm_copy_user,
+	.copy_kernel	= bf5xx_pcm_copy,
+	.fill_silence	= bf5xx_pcm_silence,
 };
 
 static int bf5xx_pcm_i2s_new(struct snd_soc_pcm_runtime *rtd)
-- 
2.13.0
