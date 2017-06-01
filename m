Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751215AbdFAU7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:09 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 20/27] ALSA: pcm: More unification of PCM transfer codes
Date: Thu,  1 Jun 2017 22:58:43 +0200
Message-Id: <20170601205850.24993-21-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch proceeds more abstraction of PCM read/write loop codes.

For both interleaved and non-interleaved transfers, the same copy or
silence transfer code (which is defined as pcm_transfer_f) is used
now.  This became possible since we switched to byte size to copy_*
and fill_silence ops argument instead of frames.

And, for both read and write, we can use the same copy function (which
is defined as pcm_copy_f), just depending on whether interleaved or
non-interleaved mode.

The transfer function is determined at the beginning of the loop,
depending on whether the driver gives the specific copy ops or it's
the standard read/write.

Another bonus by this change is that we now guarantee the silencing
behavior when NULL buffer is passed to write helpers.  It'll simplify
some codes later.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/pcm_lib.c | 254 +++++++++++++++++++++++++--------------------------
 1 file changed, 123 insertions(+), 131 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 1bd7244324d5..eb9cbc2d9d7b 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1991,77 +1991,100 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 	return err;
 }
 	
-typedef int (*transfer_f)(struct snd_pcm_substream *substream, unsigned int hwoff,
-			  void  *data, unsigned int off,
-			  snd_pcm_uframes_t size);
+typedef int (*pcm_transfer_f)(struct snd_pcm_substream *substream,
+			      int channel, unsigned long hwoff,
+			      void *buf, unsigned long bytes);
 
-static int snd_pcm_lib_write_transfer(struct snd_pcm_substream *substream,
-				      unsigned int hwoff,
-				      void *data, unsigned int off,
-				      snd_pcm_uframes_t frames)
+typedef int (*pcm_copy_f)(struct snd_pcm_substream *, snd_pcm_uframes_t, void *,
+			  snd_pcm_uframes_t, snd_pcm_uframes_t, pcm_transfer_f);
+
+/* calculate the target DMA-buffer position to be written/read */
+static void *get_dma_ptr(struct snd_pcm_runtime *runtime,
+			   int channel, unsigned long hwoff)
+{
+	return runtime->dma_area + hwoff +
+		channel * (runtime->dma_bytes / runtime->channels);
+}
+
+/* default copy_user ops for write */
+static int default_write_copy_user(struct snd_pcm_substream *substream,
+				   int channel, unsigned long hwoff,
+				   void __user *buf, unsigned long bytes)
+{
+	if (copy_from_user(get_dma_ptr(substream->runtime, channel, hwoff),
+			   buf, bytes))
+		return -EFAULT;
+	return 0;
+}
+
+/* fill silence instead of copy data; called as a transfer helper
+ * from __snd_pcm_lib_write() or directly from noninterleaved_copy() when
+ * a NULL buffer is passed
+ */
+static int fill_silence(struct snd_pcm_substream *substream, int channel,
+			unsigned long hwoff, void *buf, unsigned long bytes)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	int err;
-	char __user *buf = (char __user *) data + frames_to_bytes(runtime, off);
-	if (substream->ops->copy_user) {
-		hwoff = frames_to_bytes(runtime, hwoff);
-		frames = frames_to_bytes(runtime, frames);
-		err = substream->ops->copy_user(substream, 0, hwoff, buf, frames);
-		if (err < 0)
-			return err;
-	} else {
-		char *hwbuf = runtime->dma_area + frames_to_bytes(runtime, hwoff);
-		if (copy_from_user(hwbuf, buf, frames_to_bytes(runtime, frames)))
-			return -EFAULT;
-	}
+
+	if (substream->stream != SNDRV_PCM_STREAM_PLAYBACK)
+		return 0;
+	if (substream->ops->fill_silence)
+		return substream->ops->fill_silence(substream, channel,
+						    hwoff, bytes);
+
+	snd_pcm_format_set_silence(runtime->format,
+				   get_dma_ptr(runtime, channel, hwoff),
+				   bytes_to_samples(runtime, bytes));
 	return 0;
 }
- 
-static int snd_pcm_lib_writev_transfer(struct snd_pcm_substream *substream,
-				       unsigned int hwoff,
-				       void *data, unsigned int off,
-				       snd_pcm_uframes_t frames)
+
+/* call transfer function with the converted pointers and sizes;
+ * for interleaved mode, it's one shot for all samples
+ */
+static int interleaved_copy(struct snd_pcm_substream *substream,
+			    snd_pcm_uframes_t hwoff, void *data,
+			    snd_pcm_uframes_t off,
+			    snd_pcm_uframes_t frames,
+			    pcm_transfer_f transfer)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
+	/* convert to bytes */
+	hwoff = frames_to_bytes(runtime, hwoff);
+	off = frames_to_bytes(runtime, off);
+	frames = frames_to_bytes(runtime, frames);
+	return transfer(substream, 0, hwoff, data + off, frames);
+}
+
+/* call transfer function with the converted pointers and sizes for each
+ * non-interleaved channel; when buffer is NULL, silencing instead of copying
+ */
+static int noninterleaved_copy(struct snd_pcm_substream *substream,
+			       snd_pcm_uframes_t hwoff, void *data,
+			       snd_pcm_uframes_t off,
+			       snd_pcm_uframes_t frames,
+			       pcm_transfer_f transfer)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	int err;
-	void __user **bufs = (void __user **)data;
 	int channels = runtime->channels;
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
+	void **bufs = data;
+	int c, err;
+
+	/* convert to bytes; note that it's not frames_to_bytes() here.
+	 * in non-interleaved mode, we copy for each channel, thus
+	 * each copy is n_samples bytes x channels = whole frames.
+	 */
+	off = samples_to_bytes(runtime, off);
+	frames = samples_to_bytes(runtime, frames);
+	hwoff = samples_to_bytes(runtime, hwoff);
+	for (c = 0; c < channels; ++c, ++bufs) {
+		if (!data || !*bufs)
+			err = fill_silence(substream, c, hwoff, NULL, frames);
+		else
+			err = transfer(substream, c, hwoff, *bufs + off,
+				       frames);
+		if (err < 0)
+			return err;
 	}
 	return 0;
 }
@@ -2104,24 +2127,33 @@ snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t xfer = 0;
 	snd_pcm_uframes_t offset = 0;
 	snd_pcm_uframes_t avail;
-	transfer_f transfer;
+	pcm_copy_f writer;
+	pcm_transfer_f transfer;
 	bool nonblock;
 	int err;
 
 	err = pcm_sanity_check(substream);
 	if (err < 0)
 		return err;
-	runtime = substream->runtime;
 
 	if (interleaved) {
 		if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
 		    runtime->channels > 1)
 			return -EINVAL;
-		transfer = snd_pcm_lib_write_transfer;
+		writer = interleaved_copy;
 	} else {
 		if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
 			return -EINVAL;
-		transfer = snd_pcm_lib_writev_transfer;
+		writer = noninterleaved_copy;
+	}
+
+	if (!data) {
+		transfer = fill_silence;
+	} else {
+		if (substream->ops->copy_user)
+			transfer = (pcm_transfer_f)substream->ops->copy_user;
+		else
+			transfer = default_write_copy_user;
 	}
 
 	if (size == 0)
@@ -2164,7 +2196,8 @@ snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
 		appl_ptr = runtime->control->appl_ptr;
 		appl_ofs = appl_ptr % runtime->buffer_size;
 		snd_pcm_stream_unlock_irq(substream);
-		err = transfer(substream, appl_ofs, data, offset, frames);
+		err = writer(substream, appl_ofs, data, offset, frames,
+			     transfer);
 		snd_pcm_stream_lock_irq(substream);
 		if (err < 0)
 			goto _end_unlock;
@@ -2198,65 +2231,15 @@ snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
 }
 EXPORT_SYMBOL(__snd_pcm_lib_write);
 
-static int snd_pcm_lib_read_transfer(struct snd_pcm_substream *substream, 
-				     unsigned int hwoff,
-				     void *data, unsigned int off,
-				     snd_pcm_uframes_t frames)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	int err;
-	char __user *buf = (char __user *) data + frames_to_bytes(runtime, off);
-	if (substream->ops->copy_user) {
-		hwoff = frames_to_bytes(runtime, hwoff);
-		frames = frames_to_bytes(runtime, frames);
-		err = substream->ops->copy_user(substream, 0, hwoff, buf, frames);
-		if (err < 0)
-			return err;
-	} else {
-		char *hwbuf = runtime->dma_area + frames_to_bytes(runtime, hwoff);
-		if (copy_to_user(buf, hwbuf, frames_to_bytes(runtime, frames)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
-				      unsigned int hwoff,
-				      void *data, unsigned int off,
-				      snd_pcm_uframes_t frames)
+/* default copy_user ops for read */
+static int default_read_copy_user(struct snd_pcm_substream *substream,
+				  int channel, unsigned long hwoff,
+				  void *buf, unsigned long bytes)
 {
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
+	if (copy_to_user((void __user *)buf,
+			 get_dma_ptr(substream->runtime, channel, hwoff),
+			 bytes))
+		return -EFAULT;
 	return 0;
 }
 
@@ -2268,26 +2251,34 @@ snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t xfer = 0;
 	snd_pcm_uframes_t offset = 0;
 	snd_pcm_uframes_t avail;
-	transfer_f transfer;
+	pcm_copy_f reader;
+	pcm_transfer_f transfer;
 	bool nonblock;
 	int err;
 
 	err = pcm_sanity_check(substream);
 	if (err < 0)
 		return err;
-	runtime = substream->runtime;
+
+	if (!data)
+		return -EINVAL;
 
 	if (interleaved) {
 		if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
 		    runtime->channels > 1)
 			return -EINVAL;
-		transfer = snd_pcm_lib_read_transfer;
+		reader = interleaved_copy;
 	} else {
 		if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
 			return -EINVAL;
-		transfer = snd_pcm_lib_readv_transfer;
+		reader = noninterleaved_copy;
 	}
 
+	if (substream->ops->copy_user)
+		transfer = (pcm_transfer_f)substream->ops->copy_user;
+	else
+		transfer = default_read_copy_user;
+
 	if (size == 0)
 		return 0;
 
@@ -2341,7 +2332,8 @@ snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
 		appl_ptr = runtime->control->appl_ptr;
 		appl_ofs = appl_ptr % runtime->buffer_size;
 		snd_pcm_stream_unlock_irq(substream);
-		err = transfer(substream, appl_ofs, data, offset, frames);
+		err = reader(substream, appl_ofs, data, offset, frames,
+			     transfer);
 		snd_pcm_stream_lock_irq(substream);
 		if (err < 0)
 			goto _end_unlock;
-- 
2.13.0
