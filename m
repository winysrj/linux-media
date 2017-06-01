Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42397 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751153AbdFAU7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:05 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 02/27] ALSA: pcm: Introduce copy_user, copy_kernel and fill_silence ops
Date: Thu,  1 Jun 2017 22:58:25 +0200
Message-Id: <20170601205850.24993-3-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For supporting the explicit in-kernel copy of PCM buffer data, and
also for further code refactoring, three new PCM ops, copy_user,
copy_kernel and fill_silence, are introduced.  The old copy and
silence ops will be deprecated and removed later once when all callers
are converted.

The copy_kernel ops is the new one, and it's supposed to transfer the
PCM data from the given kernel buffer to the hardware ring-buffer (or
vice-versa depending on the stream direction), while the copy_user ops
is equivalent with the former copy ops, to transfer the data from the
user-space buffer.

The major difference of the new copy_* and fill_silence ops from the
previous ops is that the new ops take bytes instead of frames for size
and position arguments.  It has two merits: first, it allows the
callback implementation often simpler (just call directly memcpy() &
co), and second, it may unify the implementations of both interleaved
and non-interleaved cases, as we'll see in the later patch.

As of this stage, copy_kernel ops isn't referred yet, but only
copy_user is used.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 include/sound/pcm.h  |  7 +++++
 sound/core/pcm_lib.c | 89 +++++++++++++++++++++++++++++++++++++++++++---------
 sound/soc/soc-pcm.c  |  3 ++
 3 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index c609b891c4c2..a065415191d8 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -83,6 +83,13 @@ struct snd_pcm_ops {
 		    void __user *buf, snd_pcm_uframes_t count);
 	int (*silence)(struct snd_pcm_substream *substream, int channel, 
 		       snd_pcm_uframes_t pos, snd_pcm_uframes_t count);
+	int (*fill_silence)(struct snd_pcm_substream *substream, int channel,
+			    unsigned long pos, unsigned long bytes);
+	int (*copy_user)(struct snd_pcm_substream *substream, int channel,
+			 unsigned long pos, void __user *buf,
+			 unsigned long bytes);
+	int (*copy_kernel)(struct snd_pcm_substream *substream, int channel,
+			   unsigned long pos, void *buf, unsigned long bytes);
 	struct page *(*page)(struct snd_pcm_substream *substream,
 			     unsigned long offset);
 	int (*mmap)(struct snd_pcm_substream *substream, struct vm_area_struct *vma);
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index ab4b1d1e44ee..9334fc2c20c8 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -55,6 +55,8 @@ void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_ufram
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t frames, ofs, transfer;
+	char *hwbuf;
+	int err;
 
 	if (runtime->silence_size < runtime->boundary) {
 		snd_pcm_sframes_t noise_dist, n;
@@ -109,27 +111,37 @@ void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_ufram
 		transfer = ofs + frames > runtime->buffer_size ? runtime->buffer_size - ofs : frames;
 		if (runtime->access == SNDRV_PCM_ACCESS_RW_INTERLEAVED ||
 		    runtime->access == SNDRV_PCM_ACCESS_MMAP_INTERLEAVED) {
-			if (substream->ops->silence) {
-				int err;
+			if (substream->ops->fill_silence) {
+				err = substream->ops->fill_silence(substream, 0,
+								   frames_to_bytes(runtime, ofs),
+								   frames_to_bytes(runtime, transfer));
+				snd_BUG_ON(err < 0);
+			} else if (substream->ops->silence) {
 				err = substream->ops->silence(substream, -1, ofs, transfer);
 				snd_BUG_ON(err < 0);
 			} else {
-				char *hwbuf = runtime->dma_area + frames_to_bytes(runtime, ofs);
+				hwbuf = runtime->dma_area + frames_to_bytes(runtime, ofs);
 				snd_pcm_format_set_silence(runtime->format, hwbuf, transfer * runtime->channels);
 			}
 		} else {
 			unsigned int c;
 			unsigned int channels = runtime->channels;
-			if (substream->ops->silence) {
+			if (substream->ops->fill_silence) {
+				for (c = 0; c < channels; ++c) {
+					err = substream->ops->fill_silence(substream, c,
+									   samples_to_bytes(runtime, ofs),
+									   samples_to_bytes(runtime, transfer));
+					snd_BUG_ON(err < 0);
+				}
+			} else if (substream->ops->silence) {
 				for (c = 0; c < channels; ++c) {
-					int err;
 					err = substream->ops->silence(substream, c, ofs, transfer);
 					snd_BUG_ON(err < 0);
 				}
 			} else {
 				size_t dma_csize = runtime->dma_bytes / channels;
 				for (c = 0; c < channels; ++c) {
-					char *hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, ofs);
+					hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, ofs);
 					snd_pcm_format_set_silence(runtime->format, hwbuf, transfer);
 				}
 			}
@@ -1995,7 +2007,13 @@ static int snd_pcm_lib_write_transfer(struct snd_pcm_substream *substream,
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int err;
 	char __user *buf = (char __user *) data + frames_to_bytes(runtime, off);
-	if (substream->ops->copy) {
+	if (substream->ops->copy_user) {
+		hwoff = frames_to_bytes(runtime, hwoff);
+		frames = frames_to_bytes(runtime, frames);
+		err = substream->ops->copy_user(substream, 0, hwoff, buf, frames);
+		if (err < 0)
+			return err;
+	} else if (substream->ops->copy) {
 		if ((err = substream->ops->copy(substream, -1, hwoff, buf, frames)) < 0)
 			return err;
 	} else {
@@ -2119,7 +2137,8 @@ static int pcm_sanity_check(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	if (snd_BUG_ON(!substream->ops->copy && !runtime->dma_area))
+	if (snd_BUG_ON(!substream->ops->copy_user && !substream->ops->copy
+		       && !runtime->dma_area))
 		return -EINVAL;
 	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
 		return -EBADFD;
@@ -2156,8 +2175,30 @@ static int snd_pcm_lib_writev_transfer(struct snd_pcm_substream *substream,
 	int err;
 	void __user **bufs = (void __user **)data;
 	int channels = runtime->channels;
+	char __user *buf;
 	int c;
-	if (substream->ops->copy) {
+
+	if (substream->ops->copy_user) {
+		hwoff = samples_to_bytes(runtime, hwoff);
+		off = samples_to_bytes(runtime, off);
+		frames = samples_to_bytes(runtime, frames);
+		for (c = 0; c < channels; ++c, ++bufs) {
+			buf = *bufs + off;
+			if (!*bufs) {
+				if (snd_BUG_ON(!substream->ops->fill_silence))
+					return -EINVAL;
+				err = substream->ops->fill_silence(substream, c,
+								   hwoff,
+								   frames);
+			} else {
+				err = substream->ops->copy_user(substream, c,
+								hwoff, buf,
+								frames);
+			}
+			if (err < 0)
+				return err;
+		}
+	} else if (substream->ops->copy) {
 		if (snd_BUG_ON(!substream->ops->silence))
 			return -EINVAL;
 		for (c = 0; c < channels; ++c, ++bufs) {
@@ -2165,7 +2206,7 @@ static int snd_pcm_lib_writev_transfer(struct snd_pcm_substream *substream,
 				if ((err = substream->ops->silence(substream, c, hwoff, frames)) < 0)
 					return err;
 			} else {
-				char __user *buf = *bufs + samples_to_bytes(runtime, off);
+				buf = *bufs + samples_to_bytes(runtime, off);
 				if ((err = substream->ops->copy(substream, c, hwoff, buf, frames)) < 0)
 					return err;
 			}
@@ -2217,7 +2258,13 @@ static int snd_pcm_lib_read_transfer(struct snd_pcm_substream *substream,
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int err;
 	char __user *buf = (char __user *) data + frames_to_bytes(runtime, off);
-	if (substream->ops->copy) {
+	if (substream->ops->copy_user) {
+		hwoff = frames_to_bytes(runtime, hwoff);
+		frames = frames_to_bytes(runtime, frames);
+		err = substream->ops->copy_user(substream, 0, hwoff, buf, frames);
+		if (err < 0)
+			return err;
+	} else if (substream->ops->copy) {
 		if ((err = substream->ops->copy(substream, -1, hwoff, buf, frames)) < 0)
 			return err;
 	} else {
@@ -2365,10 +2412,24 @@ static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
 	int err;
 	void __user **bufs = (void __user **)data;
 	int channels = runtime->channels;
+	char __user *buf;
+	char *hwbuf;
 	int c;
-	if (substream->ops->copy) {
+
+	if (substream->ops->copy_user) {
+		hwoff = samples_to_bytes(runtime, hwoff);
+		off = samples_to_bytes(runtime, off);
+		frames = samples_to_bytes(runtime, frames);
+		for (c = 0; c < channels; ++c, ++bufs) {
+			if (!*bufs)
+				continue;
+			err = substream->ops->copy_user(substream, c, hwoff,
+							*bufs + off, frames);
+			if (err < 0)
+				return err;
+		}
+	} else if (substream->ops->copy) {
 		for (c = 0; c < channels; ++c, ++bufs) {
-			char __user *buf;
 			if (*bufs == NULL)
 				continue;
 			buf = *bufs + samples_to_bytes(runtime, off);
@@ -2378,8 +2439,6 @@ static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
 	} else {
 		snd_pcm_uframes_t dma_csize = runtime->dma_bytes / channels;
 		for (c = 0; c < channels; ++c, ++bufs) {
-			char *hwbuf;
-			char __user *buf;
 			if (*bufs == NULL)
 				continue;
 
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index efc5831f205d..8867ed9e5f56 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2743,6 +2743,9 @@ int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 
 	if (platform->driver->ops) {
 		rtd->ops.ack		= platform->driver->ops->ack;
+		rtd->ops.copy_user	= platform->driver->ops->copy_user;
+		rtd->ops.copy_kernel	= platform->driver->ops->copy_kernel;
+		rtd->ops.fill_silence	= platform->driver->ops->fill_silence;
 		rtd->ops.copy		= platform->driver->ops->copy;
 		rtd->ops.silence	= platform->driver->ops->silence;
 		rtd->ops.page		= platform->driver->ops->page;
-- 
2.13.0
