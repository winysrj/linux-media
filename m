Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756931AbdEUUKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:01 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 11/16] ALSA: gus: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:45 +0200
Message-Id: <20170521200950.4592-12-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
The conversion is straightforward with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/isa/gus/gus_pcm.c | 43 +++++++++----------------------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

diff --git a/sound/isa/gus/gus_pcm.c b/sound/isa/gus/gus_pcm.c
index 33c1891f469a..c541370d3d76 100644
--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -359,7 +359,8 @@ static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
 				     int voice,
 				     snd_pcm_uframes_t pos,
 				     void __user *src,
-				     snd_pcm_uframes_t count)
+				     snd_pcm_uframes_t count,
+				     bool in_kernel)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct gus_pcm_private *pcmp = runtime->private_data;
@@ -371,7 +372,12 @@ static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
 		return -EIO;
 	if (snd_BUG_ON(bpos + len > pcmp->dma_size))
 		return -EIO;
-	if (copy_from_user(runtime->dma_area + bpos, src, len))
+	if (!src)
+		snd_pcm_format_set_silence(runtime->format,
+					   runtime->dma_area + bpos, count);
+	else if (in_kernel)
+		memcpy(runtime->dma_area + bpos, (void *)src, len);
+	else if (copy_from_user(runtime->dma_area + bpos, src, len))
 		return -EFAULT;
 	if (snd_gf1_pcm_use_dma && len > 32) {
 		return snd_gf1_pcm_block_change(substream, bpos, pcmp->memory + bpos, len);
@@ -387,36 +393,6 @@ static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int snd_gf1_pcm_playback_silence(struct snd_pcm_substream *substream,
-					int voice,
-					snd_pcm_uframes_t pos,
-					snd_pcm_uframes_t count)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct gus_pcm_private *pcmp = runtime->private_data;
-	unsigned int bpos, len;
-	
-	bpos = samples_to_bytes(runtime, pos) + (voice * (pcmp->dma_size / 2));
-	len = samples_to_bytes(runtime, count);
-	if (snd_BUG_ON(bpos > pcmp->dma_size))
-		return -EIO;
-	if (snd_BUG_ON(bpos + len > pcmp->dma_size))
-		return -EIO;
-	snd_pcm_format_set_silence(runtime->format, runtime->dma_area + bpos, count);
-	if (snd_gf1_pcm_use_dma && len > 32) {
-		return snd_gf1_pcm_block_change(substream, bpos, pcmp->memory + bpos, len);
-	} else {
-		struct snd_gus_card *gus = pcmp->gus;
-		int err, w16, invert;
-
-		w16 = (snd_pcm_format_width(runtime->format) == 16);
-		invert = snd_pcm_format_unsigned(runtime->format);
-		if ((err = snd_gf1_pcm_poke_block(gus, runtime->dma_area + bpos, pcmp->memory + bpos, len, w16, invert)) < 0)
-			return err;
-	}
-	return 0;
-}
-
 static int snd_gf1_pcm_playback_hw_params(struct snd_pcm_substream *substream,
 					  struct snd_pcm_hw_params *hw_params)
 {
@@ -836,8 +812,7 @@ static struct snd_pcm_ops snd_gf1_pcm_playback_ops = {
 	.prepare =	snd_gf1_pcm_playback_prepare,
 	.trigger =	snd_gf1_pcm_playback_trigger,
 	.pointer =	snd_gf1_pcm_playback_pointer,
-	.copy =		snd_gf1_pcm_playback_copy,
-	.silence =	snd_gf1_pcm_playback_silence,
+	.copy_silence =	snd_gf1_pcm_playback_copy,
 };
 
 static struct snd_pcm_ops snd_gf1_pcm_capture_ops = {
-- 
2.13.0
