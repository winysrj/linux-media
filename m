Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756926AbdEUUKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:01 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 06/16] ALSA: nm256: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:40 +0200
Message-Id: <20170521200950.4592-7-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
The conversion is straightforward with standard helper functions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/nm256/nm256.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 103fe311e5a9..d8e765f7e758 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -694,31 +694,22 @@ snd_nm256_capture_pointer(struct snd_pcm_substream *substream)
  * silence / copy for playback
  */
 static int
-snd_nm256_playback_silence(struct snd_pcm_substream *substream,
-			   int channel, /* not used (interleaved data) */
-			   snd_pcm_uframes_t pos,
-			   snd_pcm_uframes_t count)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct nm256_stream *s = runtime->private_data;
-	count = frames_to_bytes(runtime, count);
-	pos = frames_to_bytes(runtime, pos);
-	memset_io(s->bufptr + pos, 0, count);
-	return 0;
-}
-
-static int
 snd_nm256_playback_copy(struct snd_pcm_substream *substream,
 			int channel, /* not used (interleaved data) */
 			snd_pcm_uframes_t pos,
 			void __user *src,
-			snd_pcm_uframes_t count)
+			snd_pcm_uframes_t count,
+			bool in_kernel)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct nm256_stream *s = runtime->private_data;
 	count = frames_to_bytes(runtime, count);
 	pos = frames_to_bytes(runtime, pos);
-	if (copy_from_user_toio(s->bufptr + pos, src, count))
+	if (!src)
+		memset_io(s->bufptr + pos, 0, count);
+	else if (in_kernel)
+		memcpy_toio(s->bufptr + pos, (void *)src, count);
+	else if (copy_from_user_toio(s->bufptr + pos, src, count))
 		return -EFAULT;
 	return 0;
 }
@@ -731,13 +722,16 @@ snd_nm256_capture_copy(struct snd_pcm_substream *substream,
 		       int channel, /* not used (interleaved data) */
 		       snd_pcm_uframes_t pos,
 		       void __user *dst,
-		       snd_pcm_uframes_t count)
+		       snd_pcm_uframes_t count,
+		       bool in_kernel)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct nm256_stream *s = runtime->private_data;
 	count = frames_to_bytes(runtime, count);
 	pos = frames_to_bytes(runtime, pos);
-	if (copy_to_user_fromio(dst, s->bufptr + pos, count))
+	if (in_kernel)
+		memcpy_fromio((void *)dst, s->bufptr + pos, count);
+	else if (copy_to_user_fromio(dst, s->bufptr + pos, count))
 		return -EFAULT;
 	return 0;
 }
@@ -911,8 +905,7 @@ static const struct snd_pcm_ops snd_nm256_playback_ops = {
 	.trigger =	snd_nm256_playback_trigger,
 	.pointer =	snd_nm256_playback_pointer,
 #ifndef __i386__
-	.copy =		snd_nm256_playback_copy,
-	.silence =	snd_nm256_playback_silence,
+	.copy_silence =	snd_nm256_playback_copy,
 #endif
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
@@ -926,7 +919,7 @@ static const struct snd_pcm_ops snd_nm256_capture_ops = {
 	.trigger =	snd_nm256_capture_trigger,
 	.pointer =	snd_nm256_capture_pointer,
 #ifndef __i386__
-	.copy =		snd_nm256_capture_copy,
+	.copy_silence =	snd_nm256_capture_copy,
 #endif
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
-- 
2.13.0
