Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42515 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751195AbdFAU7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:09 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 23/27] ALSA: pcm: Direct in-kernel read/write support
Date: Thu,  1 Jun 2017 22:58:46 +0200
Message-Id: <20170601205850.24993-24-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now all materials are ready, let's allow the direct in-kernel
read/write, i.e. a kernel-space buffer is passed for read or write,
instead of the normal user-space buffer.  This feature is used by OSS
layer and UAC1 driver, for example.

The __snd_pcm_lib_xfer() takes in_kernel argument that indicates the
in-kernel buffer copy.  When this flag is set, another transfer code
is used.  It's either via copy_kernel PCM ops or the normal memcpy(),
depending on the driver setup.

As external API, snd_pcm_kernel_read(), *_write() and other variants
are provided.

That's all.  This support is really simple because of the code
refactoring until now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 include/sound/pcm.h  | 38 +++++++++++++++++++++++++++++++++-----
 sound/core/pcm_lib.c | 26 +++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 173c6a6ebf35..e3a7269824c7 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1090,34 +1090,62 @@ void snd_pcm_playback_silence(struct snd_pcm_substream *substream, snd_pcm_ufram
 void snd_pcm_period_elapsed(struct snd_pcm_substream *substream);
 snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 				     void *buf, bool interleaved,
-				     snd_pcm_uframes_t frames);
+				     snd_pcm_uframes_t frames, bool in_kernel);
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_write(struct snd_pcm_substream *substream,
 		  const void __user *buf, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames, false);
 }
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_read(struct snd_pcm_substream *substream,
 		 void __user *buf, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames, false);
 }
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_writev(struct snd_pcm_substream *substream,
 		   void __user **bufs, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_xfer(substream, (void *)bufs, false, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)bufs, false, frames, false);
 }
 
 static inline snd_pcm_sframes_t
 snd_pcm_lib_readv(struct snd_pcm_substream *substream,
 		  void __user **bufs, snd_pcm_uframes_t frames)
 {
-	return __snd_pcm_lib_xfer(substream, (void *)bufs, false, frames);
+	return __snd_pcm_lib_xfer(substream, (void *)bufs, false, frames, false);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_kernel_write(struct snd_pcm_substream *substream,
+		     const void *buf, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_xfer(substream, (void *)buf, true, frames, true);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_kernel_read(struct snd_pcm_substream *substream,
+		    void *buf, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_xfer(substream, buf, true, frames, true);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_kernel_writev(struct snd_pcm_substream *substream,
+		      void **bufs, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_xfer(substream, bufs, false, frames, true);
+}
+
+static inline snd_pcm_sframes_t
+snd_pcm_kernel_readv(struct snd_pcm_substream *substream,
+		     void **bufs, snd_pcm_uframes_t frames)
+{
+	return __snd_pcm_lib_xfer(substream, bufs, false, frames, true);
 }
 
 extern const struct snd_pcm_hw_constraint_list snd_pcm_known_rates;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index a592d3308474..ba08b246d153 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1992,6 +1992,15 @@ static int default_write_copy(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+/* default copy_kernel ops for write */
+static int default_write_copy_kernel(struct snd_pcm_substream *substream,
+				     int channel, unsigned long hwoff,
+				     void *buf, unsigned long bytes)
+{
+	memcpy(get_dma_ptr(substream->runtime, channel, hwoff), buf, bytes);
+	return 0;
+}
+
 /* fill silence instead of copy data; called as a transfer helper
  * from __snd_pcm_lib_write() or directly from noninterleaved_copy() when
  * a NULL buffer is passed
@@ -2025,6 +2034,15 @@ static int default_read_copy(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+/* default copy_kernel ops for read */
+static int default_read_copy_kernel(struct snd_pcm_substream *substream,
+				    int channel, unsigned long hwoff,
+				    void *buf, unsigned long bytes)
+{
+	memcpy(buf, get_dma_ptr(substream->runtime, channel, hwoff), bytes);
+	return 0;
+}
+
 /* call transfer function with the converted pointers and sizes;
  * for interleaved mode, it's one shot for all samples
  */
@@ -2124,7 +2142,7 @@ static int pcm_accessible_state(struct snd_pcm_runtime *runtime)
 /* the common loop for read/write data */
 snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 				     void *data, bool interleaved,
-				     snd_pcm_uframes_t size)
+				     snd_pcm_uframes_t size, bool in_kernel)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t xfer = 0;
@@ -2157,6 +2175,12 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 			transfer = fill_silence;
 		else
 			return -EINVAL;
+	} else if (in_kernel) {
+		if (substream->ops->copy_kernel)
+			transfer = substream->ops->copy_kernel;
+		else
+			transfer = is_playback ?
+				default_write_copy_kernel : default_read_copy_kernel;
 	} else {
 		if (substream->ops->copy_user)
 			transfer = (pcm_transfer_f)substream->ops->copy_user;
-- 
2.13.0
