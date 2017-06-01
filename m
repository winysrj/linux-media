Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751229AbdFAU7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 22/27] ALSA: pcm: Simplify snd_pcm_playback_silence()
Date: Thu,  1 Jun 2017 22:58:45 +0200
Message-Id: <20170601205850.24993-23-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the existing silence helper codes for simplification.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/pcm_lib.c | 50 ++++++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index f15460eaf8b5..a592d3308474 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -42,6 +42,9 @@
 #define trace_hw_ptr_error(substream, reason)
 #endif
 
+static int fill_silence_frames(struct snd_pcm_substream *substream,
+			       snd_pcm_uframes_t off, snd_pcm_uframes_t frames);
+
 /*
  * fill ring buffer with silence
  * runtime->silence_start: starting pointer to silence area
@@ -55,7 +58,6 @@ void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_ufram
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t frames, ofs, transfer;
-	char *hwbuf;
 	int err;
 
 	if (runtime->silence_size < runtime->boundary) {
@@ -109,35 +111,8 @@ void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_ufram
 	ofs = runtime->silence_start % runtime->buffer_size;
 	while (frames > 0) {
 		transfer = ofs + frames > runtime->buffer_size ? runtime->buffer_size - ofs : frames;
-		if (runtime->access == SNDRV_PCM_ACCESS_RW_INTERLEAVED ||
-		    runtime->access == SNDRV_PCM_ACCESS_MMAP_INTERLEAVED) {
-			if (substream->ops->fill_silence) {
-				err = substream->ops->fill_silence(substream, 0,
-								   frames_to_bytes(runtime, ofs),
-								   frames_to_bytes(runtime, transfer));
-				snd_BUG_ON(err < 0);
-			} else {
-				hwbuf = runtime->dma_area + frames_to_bytes(runtime, ofs);
-				snd_pcm_format_set_silence(runtime->format, hwbuf, transfer * runtime->channels);
-			}
-		} else {
-			unsigned int c;
-			unsigned int channels = runtime->channels;
-			if (substream->ops->fill_silence) {
-				for (c = 0; c < channels; ++c) {
-					err = substream->ops->fill_silence(substream, c,
-									   samples_to_bytes(runtime, ofs),
-									   samples_to_bytes(runtime, transfer));
-					snd_BUG_ON(err < 0);
-				}
-			} else {
-				size_t dma_csize = runtime->dma_bytes / channels;
-				for (c = 0; c < channels; ++c) {
-					hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, ofs);
-					snd_pcm_format_set_silence(runtime->format, hwbuf, transfer);
-				}
-			}
-		}
+		err = fill_silence_frames(substream, ofs, transfer);
+		snd_BUG_ON(err < 0);
 		runtime->silence_filled += transfer;
 		frames -= transfer;
 		ofs = 0;
@@ -2101,6 +2076,21 @@ static int noninterleaved_copy(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+/* fill silence on the given buffer position;
+ * called from snd_pcm_playback_silence()
+ */
+static int fill_silence_frames(struct snd_pcm_substream *substream,
+			       snd_pcm_uframes_t off, snd_pcm_uframes_t frames)
+{
+	if (substream->runtime->access == SNDRV_PCM_ACCESS_RW_INTERLEAVED ||
+	    substream->runtime->access == SNDRV_PCM_ACCESS_MMAP_INTERLEAVED)
+		return interleaved_copy(substream, off, NULL, 0, frames,
+					fill_silence);
+	else
+		return noninterleaved_copy(substream, off, NULL, 0, frames,
+					   fill_silence);
+}
+
 /* sanity-check for read/write methods */
 static int pcm_sanity_check(struct snd_pcm_substream *substream)
 {
-- 
2.13.0
