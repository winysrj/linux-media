Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751173AbdFAU7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:11 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 21/27] ALSA: pcm: Unify read/write loop
Date: Thu,  1 Jun 2017 22:58:44 +0200
Message-Id: <20170601205850.24993-22-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both __snd_pcm_lib_read() and __snd_pcm_write() functions have almost
the same code to loop over samples.  For simplification, this patch
unifies both as the single helper, __snd_pcm_lib_xfer().

Other than that, there should be no functional change by this patch.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 include/sound/pcm.h  |  13 ++--
 sound/core/pcm_lib.c | 184 +++++++++++++--------------------------------------
 2 files changed, 51 insertions(+), 146 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index cb4eff8ffd2e..173c6a6ebf35 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1088,10 +1088,7 @@ int snd_pcm_update_state(struct snd_pcm_substream *substream,
 int snd_pcm_update_hw_ptr(struct snd_pcm_substream *substream);
 void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_uframes_t new_hw_ptr);
 void snd_pcm_period_elapsed(struct snd_pcm_substream *substream);
-snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
-				      void *buf, bool interleaved,
-				      snd_pcm_uframes_t frames);
-snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
+snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 				     void *buf, bool interleaved,
 				     snd_pcm_uframes_t frames);
 
@@ -1099,28 +1096,28 @@ static inline snd_pcm_sframes_t
 snd_pcm_lib_write(struct snd_pcm_substream *substream,
 		  const void __user *buf, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_write(substream, (void *)buf, true, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames);
 }
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_read(struct snd_pcm_substream *substream,
 		 void __user *buf, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_read(substream, (void *)buf, true, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames);
 }
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_writev(struct snd_pcm_substream *substream,
 		   void __user **bufs, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_write(substream, (void *)bufs, false, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)bufs, false, frames);
 }
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_readv(struct snd_pcm_substream *substream,
 		  void __user **bufs, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_read(substream, (void *)bufs, false, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)bufs, false, frames);
 }
 
 extern const struct snd_pcm_hw_constraint_list snd_pcm_known_rates;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index eb9cbc2d9d7b..f15460eaf8b5 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2006,13 +2006,13 @@ static void *get_dma_ptr(struct snd_pcm_runtime *runtime,
 		channel * (runtime->dma_bytes / runtime->channels);
 }
 
-/* default copy_user ops for write */
-static int default_write_copy_user(struct snd_pcm_substream *substream,
-				   int channel, unsigned long hwoff,
-				   void __user *buf, unsigned long bytes)
+/* default copy_user ops for write; used for both interleaved and non- modes */
+static int default_write_copy(struct snd_pcm_substream *substream,
+			      int channel, unsigned long hwoff,
+			      void *buf, unsigned long bytes)
 {
 	if (copy_from_user(get_dma_ptr(substream->runtime, channel, hwoff),
-			   buf, bytes))
+			   (void __user *)buf, bytes))
 		return -EFAULT;
 	return 0;
 }
@@ -2038,6 +2038,18 @@ static int fill_silence(struct snd_pcm_substream *substream, int channel,
 	return 0;
 }
 
+/* default copy_user ops for read; used for both interleaved and non- modes */
+static int default_read_copy(struct snd_pcm_substream *substream,
+			     int channel, unsigned long hwoff,
+			     void *buf, unsigned long bytes)
+{
+	if (copy_to_user((void __user *)buf,
+			 get_dma_ptr(substream->runtime, channel, hwoff),
+			 bytes))
+		return -EFAULT;
+	return 0;
+}
+
 /* call transfer function with the converted pointers and sizes;
  * for interleaved mode, it's one shot for all samples
  */
@@ -2119,9 +2131,10 @@ static int pcm_accessible_state(struct snd_pcm_runtime *runtime)
 	}
 }
 
-snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
-				      void *data, bool interleaved,
-				      snd_pcm_uframes_t size)
+/* the common loop for read/write data */
+snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
+				     void *data, bool interleaved,
+				     snd_pcm_uframes_t size)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t xfer = 0;
@@ -2130,12 +2143,14 @@ snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
 	pcm_copy_f writer;
 	pcm_transfer_f transfer;
 	bool nonblock;
+	bool is_playback;
 	int err;
 
 	err = pcm_sanity_check(substream);
 	if (err < 0)
 		return err;
 
+	is_playback = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	if (interleaved) {
 		if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
 		    runtime->channels > 1)
@@ -2148,12 +2163,16 @@ snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
 	}
 
 	if (!data) {
-		transfer = fill_silence;
+		if (is_playback)
+			transfer = fill_silence;
+		else
+			return -EINVAL;
 	} else {
 		if (substream->ops->copy_user)
 			transfer = (pcm_transfer_f)substream->ops->copy_user;
 		else
-			transfer = default_write_copy_user;
+			transfer = is_playback ?
+				default_write_copy : default_read_copy;
 	}
 
 	if (size == 0)
@@ -2166,129 +2185,8 @@ snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
 	if (err < 0)
 		goto _end_unlock;
 
-	runtime->twake = runtime->control->avail_min ? : 1;
-	if (runtime->status->state == SNDRV_PCM_STATE_RUNNING)
-		snd_pcm_update_hw_ptr(substream);
-	avail = snd_pcm_playback_avail(runtime);
-	while (size > 0) {
-		snd_pcm_uframes_t frames, appl_ptr, appl_ofs;
-		snd_pcm_uframes_t cont;
-		if (!avail) {
-			if (nonblock) {
-				err = -EAGAIN;
-				goto _end_unlock;
-			}
-			runtime->twake = min_t(snd_pcm_uframes_t, size,
-					runtime->control->avail_min ? : 1);
-			err = wait_for_avail(substream, &avail);
-			if (err < 0)
-				goto _end_unlock;
-		}
-		frames = size > avail ? avail : size;
-		cont = runtime->buffer_size - runtime->control->appl_ptr % runtime->buffer_size;
-		if (frames > cont)
-			frames = cont;
-		if (snd_BUG_ON(!frames)) {
-			runtime->twake = 0;
-			snd_pcm_stream_unlock_irq(substream);
-			return -EINVAL;
-		}
-		appl_ptr = runtime->control->appl_ptr;
-		appl_ofs = appl_ptr % runtime->buffer_size;
-		snd_pcm_stream_unlock_irq(substream);
-		err = writer(substream, appl_ofs, data, offset, frames,
-			     transfer);
-		snd_pcm_stream_lock_irq(substream);
-		if (err < 0)
-			goto _end_unlock;
-		err = pcm_accessible_state(runtime);
-		if (err < 0)
-			goto _end_unlock;
-		appl_ptr += frames;
-		if (appl_ptr >= runtime->boundary)
-			appl_ptr -= runtime->boundary;
-		runtime->control->appl_ptr = appl_ptr;
-		if (substream->ops->ack)
-			substream->ops->ack(substream);
-
-		offset += frames;
-		size -= frames;
-		xfer += frames;
-		avail -= frames;
-		if (runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
-		    snd_pcm_playback_hw_avail(runtime) >= (snd_pcm_sframes_t)runtime->start_threshold) {
-			err = snd_pcm_start(substream);
-			if (err < 0)
-				goto _end_unlock;
-		}
-	}
- _end_unlock:
-	runtime->twake = 0;
-	if (xfer > 0 && err >= 0)
-		snd_pcm_update_state(substream, runtime);
-	snd_pcm_stream_unlock_irq(substream);
-	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
-}
-EXPORT_SYMBOL(__snd_pcm_lib_write);
-
-/* default copy_user ops for read */
-static int default_read_copy_user(struct snd_pcm_substream *substream,
-				  int channel, unsigned long hwoff,
-				  void *buf, unsigned long bytes)
-{
-	if (copy_to_user((void __user *)buf,
-			 get_dma_ptr(substream->runtime, channel, hwoff),
-			 bytes))
-		return -EFAULT;
-	return 0;
-}
-
-snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
-				     void *data, bool interleaved,
-				     snd_pcm_uframes_t size)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	snd_pcm_uframes_t xfer = 0;
-	snd_pcm_uframes_t offset = 0;
-	snd_pcm_uframes_t avail;
-	pcm_copy_f reader;
-	pcm_transfer_f transfer;
-	bool nonblock;
-	int err;
-
-	err = pcm_sanity_check(substream);
-	if (err < 0)
-		return err;
-
-	if (!data)
-		return -EINVAL;
-
-	if (interleaved) {
-		if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
-		    runtime->channels > 1)
-			return -EINVAL;
-		reader = interleaved_copy;
-	} else {
-		if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
-			return -EINVAL;
-		reader = noninterleaved_copy;
-	}
-
-	if (substream->ops->copy_user)
-		transfer = (pcm_transfer_f)substream->ops->copy_user;
-	else
-		transfer = default_read_copy_user;
-
-	if (size == 0)
-		return 0;
-
-	nonblock = !!(substream->f_flags & O_NONBLOCK);
-
-	snd_pcm_stream_lock_irq(substream);
-	err = pcm_accessible_state(runtime);
-	if (err < 0)
-		goto _end_unlock;
-	if (runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
+	if (!is_playback &&
+	    runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
 	    size >= runtime->start_threshold) {
 		err = snd_pcm_start(substream);
 		if (err < 0)
@@ -2298,13 +2196,16 @@ snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
 	runtime->twake = runtime->control->avail_min ? : 1;
 	if (runtime->status->state == SNDRV_PCM_STATE_RUNNING)
 		snd_pcm_update_hw_ptr(substream);
-	avail = snd_pcm_capture_avail(runtime);
+	if (is_playback)
+		avail = snd_pcm_playback_avail(runtime);
+	else
+		avail = snd_pcm_capture_avail(runtime);
 	while (size > 0) {
 		snd_pcm_uframes_t frames, appl_ptr, appl_ofs;
 		snd_pcm_uframes_t cont;
 		if (!avail) {
-			if (runtime->status->state ==
-			    SNDRV_PCM_STATE_DRAINING) {
+			if (!is_playback &&
+			    runtime->status->state == SNDRV_PCM_STATE_DRAINING) {
 				snd_pcm_stop(substream, SNDRV_PCM_STATE_SETUP);
 				goto _end_unlock;
 			}
@@ -2332,7 +2233,7 @@ snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
 		appl_ptr = runtime->control->appl_ptr;
 		appl_ofs = appl_ptr % runtime->buffer_size;
 		snd_pcm_stream_unlock_irq(substream);
-		err = reader(substream, appl_ofs, data, offset, frames,
+		err = writer(substream, appl_ofs, data, offset, frames,
 			     transfer);
 		snd_pcm_stream_lock_irq(substream);
 		if (err < 0)
@@ -2351,6 +2252,13 @@ snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
 		size -= frames;
 		xfer += frames;
 		avail -= frames;
+		if (is_playback &&
+		    runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
+		    snd_pcm_playback_hw_avail(runtime) >= (snd_pcm_sframes_t)runtime->start_threshold) {
+			err = snd_pcm_start(substream);
+			if (err < 0)
+				goto _end_unlock;
+		}
 	}
  _end_unlock:
 	runtime->twake = 0;
@@ -2359,7 +2267,7 @@ snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
 	snd_pcm_stream_unlock_irq(substream);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
-EXPORT_SYMBOL(__snd_pcm_lib_read);
+EXPORT_SYMBOL(__snd_pcm_lib_xfer);
 
 /*
  * standard channel mapping helpers
-- 
2.13.0
