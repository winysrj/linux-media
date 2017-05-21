Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38219 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756927AbdEUUKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:01 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 13/16] ALSA: sh: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:47 +0200
Message-Id: <20170521200950.4592-14-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
A straightforward conversion with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/sh/sh_dac_audio.c | 40 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/sound/sh/sh_dac_audio.c b/sound/sh/sh_dac_audio.c
index 461b310c7872..a4014a4548d0 100644
--- a/sound/sh/sh_dac_audio.c
+++ b/sound/sh/sh_dac_audio.c
@@ -185,7 +185,8 @@ static int snd_sh_dac_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 }
 
 static int snd_sh_dac_pcm_copy(struct snd_pcm_substream *substream, int channel,
-	snd_pcm_uframes_t pos, void __user *src, snd_pcm_uframes_t count)
+			       snd_pcm_uframes_t pos, void __user *src,
+			       snd_pcm_uframes_t count, bool in_kernel)
 {
 	/* channel is not used (interleaved data) */
 	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
@@ -199,34 +200,12 @@ static int snd_sh_dac_pcm_copy(struct snd_pcm_substream *substream, int channel,
 	if (!count)
 		return 0;
 
-	memcpy_toio(chip->data_buffer + b_pos, src, b_count);
-	chip->buffer_end = chip->data_buffer + b_pos + b_count;
-
-	if (chip->empty) {
-		chip->empty = 0;
-		dac_audio_start_timer(chip);
-	}
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_silence(struct snd_pcm_substream *substream,
-				  int channel, snd_pcm_uframes_t pos,
-				  snd_pcm_uframes_t count)
-{
-	/* channel is not used (interleaved data) */
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	ssize_t b_count = frames_to_bytes(runtime , count);
-	ssize_t b_pos = frames_to_bytes(runtime , pos);
-
-	if (count < 0)
-		return -EINVAL;
-
-	if (!count)
-		return 0;
-
-	memset_io(chip->data_buffer + b_pos, 0, b_count);
+	if (!src)
+		memset_io(chip->data_buffer + b_pos, 0, b_count);
+	else if (in_kernel)
+		memcpy_toio(chip->data_buffer + b_pos, (void *)src, b_count);
+	else if (copy_from_user_toio(chip->data_buffer + b_pos, src, b_count))
+		return -EFAULT;
 	chip->buffer_end = chip->data_buffer + b_pos + b_count;
 
 	if (chip->empty) {
@@ -256,8 +235,7 @@ static struct snd_pcm_ops snd_sh_dac_pcm_ops = {
 	.prepare	= snd_sh_dac_pcm_prepare,
 	.trigger	= snd_sh_dac_pcm_trigger,
 	.pointer	= snd_sh_dac_pcm_pointer,
-	.copy		= snd_sh_dac_pcm_copy,
-	.silence	= snd_sh_dac_pcm_silence,
+	.copy_silence	= snd_sh_dac_pcm_copy,
 	.mmap		= snd_pcm_lib_mmap_iomem,
 };
 
-- 
2.13.0
