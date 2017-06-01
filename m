Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42529 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751159AbdFAU7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:10 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 18/27] ALSA: pcm: Shuffle codes
Date: Thu,  1 Jun 2017 22:58:41 +0200
Message-Id: <20170601205850.24993-19-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just shuffle the codes, without any change otherwise.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/pcm_lib.c | 212 +++++++++++++++++++++++++--------------------------
 1 file changed, 106 insertions(+), 106 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index e4f5c43b6448..1f5251cca607 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1991,6 +1991,10 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 	return err;
 }
 	
+typedef int (*transfer_f)(struct snd_pcm_substream *substream, unsigned int hwoff,
+			  unsigned long data, unsigned int off,
+			  snd_pcm_uframes_t size);
+
 static int snd_pcm_lib_write_transfer(struct snd_pcm_substream *substream,
 				      unsigned int hwoff,
 				      unsigned long data, unsigned int off,
@@ -2013,9 +2017,68 @@ static int snd_pcm_lib_write_transfer(struct snd_pcm_substream *substream,
 	return 0;
 }
  
-typedef int (*transfer_f)(struct snd_pcm_substream *substream, unsigned int hwoff,
-			  unsigned long data, unsigned int off,
-			  snd_pcm_uframes_t size);
+static int snd_pcm_lib_writev_transfer(struct snd_pcm_substream *substream,
+				       unsigned int hwoff,
+				       unsigned long data, unsigned int off,
+				       snd_pcm_uframes_t frames)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int err;
+	void __user **bufs = (void __user **)data;
+	int channels = runtime->channels;
+	char __user *buf;
+	int c;
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
+	} else {
+		/* default transfer behaviour */
+		size_t dma_csize = runtime->dma_bytes / channels;
+		for (c = 0; c < channels; ++c, ++bufs) {
+			char *hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, hwoff);
+			if (*bufs == NULL) {
+				snd_pcm_format_set_silence(runtime->format, hwbuf, frames);
+			} else {
+				char __user *buf = *bufs + samples_to_bytes(runtime, off);
+				if (copy_from_user(hwbuf, buf, samples_to_bytes(runtime, frames)))
+					return -EFAULT;
+			}
+		}
+	}
+	return 0;
+}
+
+/* sanity-check for read/write methods */
+static int pcm_sanity_check(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime;
+	if (PCM_RUNTIME_CHECK(substream))
+		return -ENXIO;
+	runtime = substream->runtime;
+	if (snd_BUG_ON(!substream->ops->copy_user && !runtime->dma_area))
+		return -EINVAL;
+	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
+		return -EBADFD;
+	return 0;
+}
 
 static int pcm_accessible_state(struct snd_pcm_runtime *runtime)
 {
@@ -2116,20 +2179,6 @@ static snd_pcm_sframes_t snd_pcm_lib_write1(struct snd_pcm_substream *substream,
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 
-/* sanity-check for read/write methods */
-static int pcm_sanity_check(struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime;
-	if (PCM_RUNTIME_CHECK(substream))
-		return -ENXIO;
-	runtime = substream->runtime;
-	if (snd_BUG_ON(!substream->ops->copy_user && !runtime->dma_area))
-		return -EINVAL;
-	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
-		return -EBADFD;
-	return 0;
-}
-
 snd_pcm_sframes_t snd_pcm_lib_write(struct snd_pcm_substream *substream, const void __user *buf, snd_pcm_uframes_t size)
 {
 	struct snd_pcm_runtime *runtime;
@@ -2151,55 +2200,6 @@ snd_pcm_sframes_t snd_pcm_lib_write(struct snd_pcm_substream *substream, const v
 
 EXPORT_SYMBOL(snd_pcm_lib_write);
 
-static int snd_pcm_lib_writev_transfer(struct snd_pcm_substream *substream,
-				       unsigned int hwoff,
-				       unsigned long data, unsigned int off,
-				       snd_pcm_uframes_t frames)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	int err;
-	void __user **bufs = (void __user **)data;
-	int channels = runtime->channels;
-	char __user *buf;
-	int c;
-
-	if (substream->ops->copy_user) {
-		hwoff = samples_to_bytes(runtime, hwoff);
-		off = samples_to_bytes(runtime, off);
-		frames = samples_to_bytes(runtime, frames);
-		for (c = 0; c < channels; ++c, ++bufs) {
-			buf = *bufs + off;
-			if (!*bufs) {
-				if (snd_BUG_ON(!substream->ops->fill_silence))
-					return -EINVAL;
-				err = substream->ops->fill_silence(substream, c,
-								   hwoff,
-								   frames);
-			} else {
-				err = substream->ops->copy_user(substream, c,
-								hwoff, buf,
-								frames);
-			}
-			if (err < 0)
-				return err;
-		}
-	} else {
-		/* default transfer behaviour */
-		size_t dma_csize = runtime->dma_bytes / channels;
-		for (c = 0; c < channels; ++c, ++bufs) {
-			char *hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, hwoff);
-			if (*bufs == NULL) {
-				snd_pcm_format_set_silence(runtime->format, hwbuf, frames);
-			} else {
-				char __user *buf = *bufs + samples_to_bytes(runtime, off);
-				if (copy_from_user(hwbuf, buf, samples_to_bytes(runtime, frames)))
-					return -EFAULT;
-			}
-		}
-	}
-	return 0;
-}
- 
 snd_pcm_sframes_t snd_pcm_lib_writev(struct snd_pcm_substream *substream,
 				     void __user **bufs,
 				     snd_pcm_uframes_t frames)
@@ -2244,6 +2244,46 @@ static int snd_pcm_lib_read_transfer(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
+				      unsigned int hwoff,
+				      unsigned long data, unsigned int off,
+				      snd_pcm_uframes_t frames)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int err;
+	void __user **bufs = (void __user **)data;
+	int channels = runtime->channels;
+	char __user *buf;
+	char *hwbuf;
+	int c;
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
+	} else {
+		snd_pcm_uframes_t dma_csize = runtime->dma_bytes / channels;
+		for (c = 0; c < channels; ++c, ++bufs) {
+			if (*bufs == NULL)
+				continue;
+
+			hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, hwoff);
+			buf = *bufs + samples_to_bytes(runtime, off);
+			if (copy_to_user(buf, hwbuf, samples_to_bytes(runtime, frames)))
+				return -EFAULT;
+		}
+	}
+	return 0;
+}
+
 static snd_pcm_sframes_t snd_pcm_lib_read1(struct snd_pcm_substream *substream,
 					   unsigned long data,
 					   snd_pcm_uframes_t size,
@@ -2352,46 +2392,6 @@ snd_pcm_sframes_t snd_pcm_lib_read(struct snd_pcm_substream *substream, void __u
 
 EXPORT_SYMBOL(snd_pcm_lib_read);
 
-static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
-				      unsigned int hwoff,
-				      unsigned long data, unsigned int off,
-				      snd_pcm_uframes_t frames)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	int err;
-	void __user **bufs = (void __user **)data;
-	int channels = runtime->channels;
-	char __user *buf;
-	char *hwbuf;
-	int c;
-
-	if (substream->ops->copy_user) {
-		hwoff = samples_to_bytes(runtime, hwoff);
-		off = samples_to_bytes(runtime, off);
-		frames = samples_to_bytes(runtime, frames);
-		for (c = 0; c < channels; ++c, ++bufs) {
-			if (!*bufs)
-				continue;
-			err = substream->ops->copy_user(substream, c, hwoff,
-							*bufs + off, frames);
-			if (err < 0)
-				return err;
-		}
-	} else {
-		snd_pcm_uframes_t dma_csize = runtime->dma_bytes / channels;
-		for (c = 0; c < channels; ++c, ++bufs) {
-			if (*bufs == NULL)
-				continue;
-
-			hwbuf = runtime->dma_area + (c * dma_csize) + samples_to_bytes(runtime, hwoff);
-			buf = *bufs + samples_to_bytes(runtime, off);
-			if (copy_to_user(buf, hwbuf, samples_to_bytes(runtime, frames)))
-				return -EFAULT;
-		}
-	}
-	return 0;
-}
- 
 snd_pcm_sframes_t snd_pcm_lib_readv(struct snd_pcm_substream *substream,
 				    void __user **bufs,
 				    snd_pcm_uframes_t frames)
-- 
2.13.0
