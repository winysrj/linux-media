Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751130AbdFAU7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:09 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 11/27] ALSA: gus: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:34 +0200
Message-Id: <20170601205850.24993-12-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
For simplifying the code a bit, two local helpers are introduced here:
get_bpos() and playback_copy_ack().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/isa/gus/gus_pcm.c | 97 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 38 deletions(-)

diff --git a/sound/isa/gus/gus_pcm.c b/sound/isa/gus/gus_pcm.c
index 0cc3f272edf1..b9f6dcbef889 100644
--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -353,26 +353,25 @@ static int snd_gf1_pcm_poke_block(struct snd_gus_card *gus, unsigned char *buf,
 	return 0;
 }
 
-static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
-				     int voice,
-				     snd_pcm_uframes_t pos,
-				     void __user *src,
-				     snd_pcm_uframes_t count)
+static int get_bpos(struct gus_pcm_private *pcmp, int voice, unsigned int pos,
+		    unsigned int len)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct gus_pcm_private *pcmp = runtime->private_data;
-	struct snd_gus_card *gus = pcmp->gus;
-	unsigned int bpos, len;
-	int w16, invert;
-	
-	bpos = samples_to_bytes(runtime, pos) + (voice * (pcmp->dma_size / 2));
-	len = samples_to_bytes(runtime, count);
+	unsigned int bpos = pos + (voice * (pcmp->dma_size / 2));
 	if (snd_BUG_ON(bpos > pcmp->dma_size))
 		return -EIO;
 	if (snd_BUG_ON(bpos + len > pcmp->dma_size))
 		return -EIO;
-	if (copy_from_user(runtime->dma_area + bpos, src, len))
-		return -EFAULT;
+	return bpos;
+}
+
+static int playback_copy_ack(struct snd_pcm_substream *substream,
+			     unsigned int bpos, unsigned int len)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct gus_pcm_private *pcmp = runtime->private_data;
+	struct snd_gus_card *gus = pcmp->gus;
+	int w16, invert;
+
 	if (len > 32)
 		return snd_gf1_pcm_block_change(substream, bpos,
 						pcmp->memory + bpos, len);
@@ -383,33 +382,54 @@ static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
 				      pcmp->memory + bpos, len, w16, invert);
 }
 
+static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
+				     int voice, unsigned long pos,
+				     void __user *src, unsigned long count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct gus_pcm_private *pcmp = runtime->private_data;
+	unsigned int len = count;
+	int bpos;
+
+	bpos = get_bpos(pcmp, voice, pos, len);
+	if (bpos < 0)
+		return pos;
+	if (copy_from_user(runtime->dma_area + bpos, src, len))
+		return -EFAULT;
+	return playback_copy_ack(substream, bpos, len);
+}
+
+static int snd_gf1_pcm_playback_copy_kernel(struct snd_pcm_substream *substream,
+					    int voice, unsigned long pos,
+					    void *src, unsigned long count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct gus_pcm_private *pcmp = runtime->private_data;
+	unsigned int len = count;
+	int bpos;
+
+	bpos = get_bpos(pcmp, voice, pos, len);
+	if (bpos < 0)
+		return pos;
+	memcpy(runtime->dma_area + bpos, src, len);
+	return playback_copy_ack(substream, bpos, len);
+}
+
 static int snd_gf1_pcm_playback_silence(struct snd_pcm_substream *substream,
-					int voice,
-					snd_pcm_uframes_t pos,
-					snd_pcm_uframes_t count)
+					int voice, unsigned long pos,
+					unsigned long count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct gus_pcm_private *pcmp = runtime->private_data;
-	struct snd_gus_card *gus = pcmp->gus;
-	unsigned int bpos, len;
-	int w16, invert;
+	unsigned int len = count;
+	int bpos;
 	
-	bpos = samples_to_bytes(runtime, pos) + (voice * (pcmp->dma_size / 2));
-	len = samples_to_bytes(runtime, count);
-	if (snd_BUG_ON(bpos > pcmp->dma_size))
-		return -EIO;
-	if (snd_BUG_ON(bpos + len > pcmp->dma_size))
-		return -EIO;
+	bpos = get_bpos(pcmp, voice, pos, len);
+	if (bpos < 0)
+		return pos;
 	snd_pcm_format_set_silence(runtime->format, runtime->dma_area + bpos,
-				   count);
-	if (len > 32)
-		return snd_gf1_pcm_block_change(substream, bpos,
-						pcmp->memory + bpos, len);
-
-	w16 = (snd_pcm_format_width(runtime->format) == 16);
-	invert = snd_pcm_format_unsigned(runtime->format);
-	return snd_gf1_pcm_poke_block(gus, runtime->dma_area + bpos,
-				      pcmp->memory + bpos, len, w16, invert);
+				   bytes_to_samples(runtime, count));
+	return playback_copy_ack(substream, bpos, len);
 }
 
 static int snd_gf1_pcm_playback_hw_params(struct snd_pcm_substream *substream,
@@ -831,8 +851,9 @@ static struct snd_pcm_ops snd_gf1_pcm_playback_ops = {
 	.prepare =	snd_gf1_pcm_playback_prepare,
 	.trigger =	snd_gf1_pcm_playback_trigger,
 	.pointer =	snd_gf1_pcm_playback_pointer,
-	.copy =		snd_gf1_pcm_playback_copy,
-	.silence =	snd_gf1_pcm_playback_silence,
+	.copy_user =	snd_gf1_pcm_playback_copy,
+	.copy_kernel =	snd_gf1_pcm_playback_copy_kernel,
+	.fill_silence =	snd_gf1_pcm_playback_silence,
 };
 
 static struct snd_pcm_ops snd_gf1_pcm_capture_ops = {
-- 
2.13.0
