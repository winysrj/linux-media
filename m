Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38195 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756916AbdEUUKA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:00 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 07/16] ALSA: rme32: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:41 +0200
Message-Id: <20170521200950.4592-8-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
The conversion is straightforward with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/rme32.c | 49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 96d15db65dfd..d2b4a3ef0bd3 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -253,41 +253,42 @@ static inline unsigned int snd_rme32_pcm_byteptr(struct rme32 * rme32)
 		& RME32_RCR_AUDIO_ADDR_MASK);
 }
 
-/* silence callback for halfduplex mode */
-static int snd_rme32_playback_silence(struct snd_pcm_substream *substream, int channel,	/* not used (interleaved data) */
-				      snd_pcm_uframes_t pos,
-				      snd_pcm_uframes_t count)
-{
-	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
-	count <<= rme32->playback_frlog;
-	pos <<= rme32->playback_frlog;
-	memset_io(rme32->iobase + RME32_IO_DATA_BUFFER + pos, 0, count);
-	return 0;
-}
-
 /* copy callback for halfduplex mode */
-static int snd_rme32_playback_copy(struct snd_pcm_substream *substream, int channel,	/* not used (interleaved data) */
+static int snd_rme32_playback_copy(struct snd_pcm_substream *substream,
+				   int channel,	/* not used (interleaved data) */
 				   snd_pcm_uframes_t pos,
-				   void __user *src, snd_pcm_uframes_t count)
+				   void __user *src, snd_pcm_uframes_t count,
+				   bool in_kernel)
 {
 	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
 	count <<= rme32->playback_frlog;
 	pos <<= rme32->playback_frlog;
-	if (copy_from_user_toio(rme32->iobase + RME32_IO_DATA_BUFFER + pos,
-			    src, count))
+	if (!src)
+		memset_io(rme32->iobase + RME32_IO_DATA_BUFFER + pos, 0, count);
+	else if (in_kernel)
+		memcpy_toio(rme32->iobase + RME32_IO_DATA_BUFFER + pos,
+			    (void *)src, count);
+	else if (copy_from_user_toio(rme32->iobase + RME32_IO_DATA_BUFFER + pos,
+				     src, count))
 		return -EFAULT;
 	return 0;
 }
 
 /* copy callback for halfduplex mode */
-static int snd_rme32_capture_copy(struct snd_pcm_substream *substream, int channel,	/* not used (interleaved data) */
+static int snd_rme32_capture_copy(struct snd_pcm_substream *substream,
+				  int channel,	/* not used (interleaved data) */
 				  snd_pcm_uframes_t pos,
-				  void __user *dst, snd_pcm_uframes_t count)
+				  void __user *dst, snd_pcm_uframes_t count,
+				  bool in_kernel)
 {
 	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
 	count <<= rme32->capture_frlog;
 	pos <<= rme32->capture_frlog;
-	if (copy_to_user_fromio(dst,
+	if (in_kernel)
+		memcpy_fromio((void *)dst,
+			      rme32->iobase + RME32_IO_DATA_BUFFER + pos,
+			      count);
+	else if (copy_to_user_fromio(dst,
 			    rme32->iobase + RME32_IO_DATA_BUFFER + pos,
 			    count))
 		return -EFAULT;
@@ -1205,8 +1206,7 @@ static const struct snd_pcm_ops snd_rme32_playback_spdif_ops = {
 	.prepare =	snd_rme32_playback_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_playback_pointer,
-	.copy =		snd_rme32_playback_copy,
-	.silence =	snd_rme32_playback_silence,
+	.copy_silence =	snd_rme32_playback_copy,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1219,7 +1219,7 @@ static const struct snd_pcm_ops snd_rme32_capture_spdif_ops = {
 	.prepare =	snd_rme32_capture_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_capture_pointer,
-	.copy =		snd_rme32_capture_copy,
+	.copy_silence =	snd_rme32_capture_copy,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1231,8 +1231,7 @@ static const struct snd_pcm_ops snd_rme32_playback_adat_ops = {
 	.prepare =	snd_rme32_playback_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_playback_pointer,
-	.copy =		snd_rme32_playback_copy,
-	.silence =	snd_rme32_playback_silence,
+	.copy_silence =	snd_rme32_playback_copy,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1244,7 +1243,7 @@ static const struct snd_pcm_ops snd_rme32_capture_adat_ops = {
 	.prepare =	snd_rme32_capture_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_capture_pointer,
-	.copy =		snd_rme32_capture_copy,
+	.copy_silence =	snd_rme32_capture_copy,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
-- 
2.13.0
