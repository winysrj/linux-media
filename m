Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42491 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751192AbdFAU7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:09 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 19/27] ALSA: pcm: Call directly the common read/write helpers
Date: Thu,  1 Jun 2017 22:58:42 +0200
Message-Id: <20170601205850.24993-20-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make snd_pcm_lib_read() and *_write() static inline functions that
call the common helper functions directly.  This reduces a slight
amount of codes, and at the same time, it's a preparation for the
further cleanups / fixes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 include/sound/pcm.h  |  43 +++++++++++---
 sound/core/pcm_lib.c | 156 ++++++++++++++++++---------------------------------
 2 files changed, 89 insertions(+), 110 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 953ebfc83184..cb4eff8ffd2e 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1088,15 +1088,40 @@ int snd_pcm_update_state(struct snd_pcm_substream *substream,
 int snd_pcm_update_hw_ptr(struct snd_pcm_substream *substream);
 void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_uframes_t new_hw_ptr);
 void snd_pcm_period_elapsed(struct snd_pcm_substream *substream);
-snd_pcm_sframes_t snd_pcm_lib_write(struct snd_pcm_substream *substream,
-				    const void __user *buf,
-				    snd_pcm_uframes_t frames);
-snd_pcm_sframes_t snd_pcm_lib_read(struct snd_pcm_substream *substream,
-				   void __user *buf, snd_pcm_uframes_t frames);
-snd_pcm_sframes_t snd_pcm_lib_writev(struct snd_pcm_substream *substream,
-				     void __user **bufs, snd_pcm_uframes_t frames);
-snd_pcm_sframes_t snd_pcm_lib_readv(struct snd_pcm_substream *substream,
-				    void __user **bufs, snd_pcm_uframes_t frames);
+snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
+				      void *buf, bool interleaved,
+				      snd_pcm_uframes_t frames);
+snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
+				     void *buf, bool interleaved,
+				     snd_pcm_uframes_t frames);
+
+static inline snd_pcm_sframes_t
+snd_pcm_lib_write(struct snd_pcm_substream *substream,
+		  const void __user *buf, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_write(substream, (void *)buf, true, frames);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_lib_read(struct snd_pcm_substream *substream,
+		 void __user *buf, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_read(substream, (void *)buf, true, frames);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_lib_writev(struct snd_pcm_substream *substream,
+		   void __user **bufs, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_write(substream, (void *)bufs, false, frames);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_lib_readv(struct snd_pcm_substream *substream,
+		  void __user **bufs, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_read(substream, (void *)bufs, false, frames);
+}
 
 extern const struct snd_pcm_hw_constraint_list snd_pcm_known_rates;
 
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 1f5251cca607..1bd7244324d5 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1992,12 +1992,12 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 }
 	
 typedef int (*transfer_f)(struct snd_pcm_substream *substream, unsigned int hwoff,
-			  unsigned long data, unsigned int off,
+			  void  *data, unsigned int off,
 			  snd_pcm_uframes_t size);
 
 static int snd_pcm_lib_write_transfer(struct snd_pcm_substream *substream,
 				      unsigned int hwoff,
-				      unsigned long data, unsigned int off,
+				      void *data, unsigned int off,
 				      snd_pcm_uframes_t frames)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -2019,7 +2019,7 @@ static int snd_pcm_lib_write_transfer(struct snd_pcm_substream *substream,
  
 static int snd_pcm_lib_writev_transfer(struct snd_pcm_substream *substream,
 				       unsigned int hwoff,
-				       unsigned long data, unsigned int off,
+				       void *data, unsigned int off,
 				       snd_pcm_uframes_t frames)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -2096,21 +2096,39 @@ static int pcm_accessible_state(struct snd_pcm_runtime *runtime)
 	}
 }
 
-static snd_pcm_sframes_t snd_pcm_lib_write1(struct snd_pcm_substream *substream, 
-					    unsigned long data,
-					    snd_pcm_uframes_t size,
-					    int nonblock,
-					    transfer_f transfer)
+snd_pcm_sframes_t __snd_pcm_lib_write(struct snd_pcm_substream *substream,
+				      void *data, bool interleaved,
+				      snd_pcm_uframes_t size)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t xfer = 0;
 	snd_pcm_uframes_t offset = 0;
 	snd_pcm_uframes_t avail;
-	int err = 0;
+	transfer_f transfer;
+	bool nonblock;
+	int err;
+
+	err = pcm_sanity_check(substream);
+	if (err < 0)
+		return err;
+	runtime = substream->runtime;
+
+	if (interleaved) {
+		if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
+		    runtime->channels > 1)
+			return -EINVAL;
+		transfer = snd_pcm_lib_write_transfer;
+	} else {
+		if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
+			return -EINVAL;
+		transfer = snd_pcm_lib_writev_transfer;
+	}
 
 	if (size == 0)
 		return 0;
 
+	nonblock = !!(substream->f_flags & O_NONBLOCK);
+
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2178,53 +2196,11 @@ static snd_pcm_sframes_t snd_pcm_lib_write1(struct snd_pcm_substream *substream,
 	snd_pcm_stream_unlock_irq(substream);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
-
-snd_pcm_sframes_t snd_pcm_lib_write(struct snd_pcm_substream *substream, const void __user *buf, snd_pcm_uframes_t size)
-{
-	struct snd_pcm_runtime *runtime;
-	int nonblock;
-	int err;
-
-	err = pcm_sanity_check(substream);
-	if (err < 0)
-		return err;
-	runtime = substream->runtime;
-	nonblock = !!(substream->f_flags & O_NONBLOCK);
-
-	if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
-	    runtime->channels > 1)
-		return -EINVAL;
-	return snd_pcm_lib_write1(substream, (unsigned long)buf, size, nonblock,
-				  snd_pcm_lib_write_transfer);
-}
-
-EXPORT_SYMBOL(snd_pcm_lib_write);
-
-snd_pcm_sframes_t snd_pcm_lib_writev(struct snd_pcm_substream *substream,
-				     void __user **bufs,
-				     snd_pcm_uframes_t frames)
-{
-	struct snd_pcm_runtime *runtime;
-	int nonblock;
-	int err;
-
-	err = pcm_sanity_check(substream);
-	if (err < 0)
-		return err;
-	runtime = substream->runtime;
-	nonblock = !!(substream->f_flags & O_NONBLOCK);
-
-	if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
-		return -EINVAL;
-	return snd_pcm_lib_write1(substream, (unsigned long)bufs, frames,
-				  nonblock, snd_pcm_lib_writev_transfer);
-}
-
-EXPORT_SYMBOL(snd_pcm_lib_writev);
+EXPORT_SYMBOL(__snd_pcm_lib_write);
 
 static int snd_pcm_lib_read_transfer(struct snd_pcm_substream *substream, 
 				     unsigned int hwoff,
-				     unsigned long data, unsigned int off,
+				     void *data, unsigned int off,
 				     snd_pcm_uframes_t frames)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -2246,7 +2222,7 @@ static int snd_pcm_lib_read_transfer(struct snd_pcm_substream *substream,
 
 static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
 				      unsigned int hwoff,
-				      unsigned long data, unsigned int off,
+				      void *data, unsigned int off,
 				      snd_pcm_uframes_t frames)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -2284,21 +2260,39 @@ static int snd_pcm_lib_readv_transfer(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static snd_pcm_sframes_t snd_pcm_lib_read1(struct snd_pcm_substream *substream,
-					   unsigned long data,
-					   snd_pcm_uframes_t size,
-					   int nonblock,
-					   transfer_f transfer)
+snd_pcm_sframes_t __snd_pcm_lib_read(struct snd_pcm_substream *substream,
+				     void *data, bool interleaved,
+				     snd_pcm_uframes_t size)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t xfer = 0;
 	snd_pcm_uframes_t offset = 0;
 	snd_pcm_uframes_t avail;
-	int err = 0;
+	transfer_f transfer;
+	bool nonblock;
+	int err;
+
+	err = pcm_sanity_check(substream);
+	if (err < 0)
+		return err;
+	runtime = substream->runtime;
+
+	if (interleaved) {
+		if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED &&
+		    runtime->channels > 1)
+			return -EINVAL;
+		transfer = snd_pcm_lib_read_transfer;
+	} else {
+		if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
+			return -EINVAL;
+		transfer = snd_pcm_lib_readv_transfer;
+	}
 
 	if (size == 0)
 		return 0;
 
+	nonblock = !!(substream->f_flags & O_NONBLOCK);
+
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2373,47 +2367,7 @@ static snd_pcm_sframes_t snd_pcm_lib_read1(struct snd_pcm_substream *substream,
 	snd_pcm_stream_unlock_irq(substream);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
-
-snd_pcm_sframes_t snd_pcm_lib_read(struct snd_pcm_substream *substream, void __user *buf, snd_pcm_uframes_t size)
-{
-	struct snd_pcm_runtime *runtime;
-	int nonblock;
-	int err;
-	
-	err = pcm_sanity_check(substream);
-	if (err < 0)
-		return err;
-	runtime = substream->runtime;
-	nonblock = !!(substream->f_flags & O_NONBLOCK);
-	if (runtime->access != SNDRV_PCM_ACCESS_RW_INTERLEAVED)
-		return -EINVAL;
-	return snd_pcm_lib_read1(substream, (unsigned long)buf, size, nonblock, snd_pcm_lib_read_transfer);
-}
-
-EXPORT_SYMBOL(snd_pcm_lib_read);
-
-snd_pcm_sframes_t snd_pcm_lib_readv(struct snd_pcm_substream *substream,
-				    void __user **bufs,
-				    snd_pcm_uframes_t frames)
-{
-	struct snd_pcm_runtime *runtime;
-	int nonblock;
-	int err;
-
-	err = pcm_sanity_check(substream);
-	if (err < 0)
-		return err;
-	runtime = substream->runtime;
-	if (runtime->status->state == SNDRV_PCM_STATE_OPEN)
-		return -EBADFD;
-
-	nonblock = !!(substream->f_flags & O_NONBLOCK);
-	if (runtime->access != SNDRV_PCM_ACCESS_RW_NONINTERLEAVED)
-		return -EINVAL;
-	return snd_pcm_lib_read1(substream, (unsigned long)bufs, frames, nonblock, snd_pcm_lib_readv_transfer);
-}
-
-EXPORT_SYMBOL(snd_pcm_lib_readv);
+EXPORT_SYMBOL(__snd_pcm_lib_read);
 
 /*
  * standard channel mapping helpers
-- 
2.13.0
