Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756887AbdEUUJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:09:59 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 04/16] ALSA: es1938: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:38 +0200
Message-Id: <20170521200950.4592-5-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
It's used only for a capture stream (for some hardware workaround),
thus we need no silence operation but only to add the in_kernel
memcpy() handling.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/es1938.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index e8d943071a8c..d79ac13d6f70 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -842,7 +842,8 @@ static int snd_es1938_capture_copy(struct snd_pcm_substream *substream,
 				   int channel,
 				   snd_pcm_uframes_t pos,
 				   void __user *dst,
-				   snd_pcm_uframes_t count)
+				   snd_pcm_uframes_t count,
+				   bool in_kernel)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct es1938 *chip = snd_pcm_substream_chip(substream);
@@ -850,8 +851,10 @@ static int snd_es1938_capture_copy(struct snd_pcm_substream *substream,
 	count <<= chip->dma1_shift;
 	if (snd_BUG_ON(pos + count > chip->dma1_size))
 		return -EINVAL;
-	if (pos + count < chip->dma1_size) {
-		if (copy_to_user(dst, runtime->dma_area + pos + 1, count))
+	if (in_kernel || pos + count < chip->dma1_size) {
+		if (in_kernel)
+			memcpy((void *)dst, runtime->dma_area + pos + 1, count);
+		else if (copy_to_user(dst, runtime->dma_area + pos + 1, count))
 			return -EFAULT;
 	} else {
 		if (copy_to_user(dst, runtime->dma_area + pos + 1, count - 1))
@@ -1012,7 +1015,7 @@ static const struct snd_pcm_ops snd_es1938_capture_ops = {
 	.prepare =	snd_es1938_capture_prepare,
 	.trigger =	snd_es1938_capture_trigger,
 	.pointer =	snd_es1938_capture_pointer,
-	.copy =		snd_es1938_capture_copy,
+	.copy_silence =	snd_es1938_capture_copy,
 };
 
 static int snd_es1938_new_pcm(struct es1938 *chip, int device)
-- 
2.13.0
