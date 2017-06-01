Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751174AbdFAU7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:08 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 07/27] ALSA: rme32: Convert to the new PCM copy ops
Date: Thu,  1 Jun 2017 22:58:30 +0200
Message-Id: <20170601205850.24993-8-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new ops.
The conversion is straightforward with standard helper functions, and
now we can drop the bytes <-> frames conversions in callbacks.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/rme32.c | 65 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 96d15db65dfd..ce438c62b0b3 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -254,39 +254,46 @@ static inline unsigned int snd_rme32_pcm_byteptr(struct rme32 * rme32)
 }
 
 /* silence callback for halfduplex mode */
-static int snd_rme32_playback_silence(struct snd_pcm_substream *substream, int channel,	/* not used (interleaved data) */
-				      snd_pcm_uframes_t pos,
-				      snd_pcm_uframes_t count)
+static int snd_rme32_playback_silence(struct snd_pcm_substream *substream,
+				      int channel, unsigned long pos,
+				      unsigned long count)
 {
 	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
-	count <<= rme32->playback_frlog;
-	pos <<= rme32->playback_frlog;
+
 	memset_io(rme32->iobase + RME32_IO_DATA_BUFFER + pos, 0, count);
 	return 0;
 }
 
 /* copy callback for halfduplex mode */
-static int snd_rme32_playback_copy(struct snd_pcm_substream *substream, int channel,	/* not used (interleaved data) */
-				   snd_pcm_uframes_t pos,
-				   void __user *src, snd_pcm_uframes_t count)
+static int snd_rme32_playback_copy(struct snd_pcm_substream *substream,
+				   int channel, unsigned long pos,
+				   void __user *src, unsigned long count)
 {
 	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
-	count <<= rme32->playback_frlog;
-	pos <<= rme32->playback_frlog;
+
 	if (copy_from_user_toio(rme32->iobase + RME32_IO_DATA_BUFFER + pos,
-			    src, count))
+				src, count))
 		return -EFAULT;
 	return 0;
 }
 
+static int snd_rme32_playback_copy_kernel(struct snd_pcm_substream *substream,
+					  int channel, unsigned long pos,
+					  void *src, unsigned long count)
+{
+	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
+
+	memcpy_toio(rme32->iobase + RME32_IO_DATA_BUFFER + pos, src, count);
+	return 0;
+}
+
 /* copy callback for halfduplex mode */
-static int snd_rme32_capture_copy(struct snd_pcm_substream *substream, int channel,	/* not used (interleaved data) */
-				  snd_pcm_uframes_t pos,
-				  void __user *dst, snd_pcm_uframes_t count)
+static int snd_rme32_capture_copy(struct snd_pcm_substream *substream,
+				  int channel, unsigned long pos,
+				  void __user *dst, unsigned long count)
 {
 	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
-	count <<= rme32->capture_frlog;
-	pos <<= rme32->capture_frlog;
+
 	if (copy_to_user_fromio(dst,
 			    rme32->iobase + RME32_IO_DATA_BUFFER + pos,
 			    count))
@@ -294,6 +301,16 @@ static int snd_rme32_capture_copy(struct snd_pcm_substream *substream, int chann
 	return 0;
 }
 
+static int snd_rme32_capture_copy_kernel(struct snd_pcm_substream *substream,
+					 int channel, unsigned long pos,
+					 void *dst, unsigned long count)
+{
+	struct rme32 *rme32 = snd_pcm_substream_chip(substream);
+
+	memcpy_fromio(dst, rme32->iobase + RME32_IO_DATA_BUFFER + pos, count);
+	return 0;
+}
+
 /*
  * SPDIF I/O capabilities (half-duplex mode)
  */
@@ -1205,8 +1222,9 @@ static const struct snd_pcm_ops snd_rme32_playback_spdif_ops = {
 	.prepare =	snd_rme32_playback_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_playback_pointer,
-	.copy =		snd_rme32_playback_copy,
-	.silence =	snd_rme32_playback_silence,
+	.copy_user =	snd_rme32_playback_copy,
+	.copy_kernel =	snd_rme32_playback_copy_kernel,
+	.fill_silence =	snd_rme32_playback_silence,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1219,7 +1237,8 @@ static const struct snd_pcm_ops snd_rme32_capture_spdif_ops = {
 	.prepare =	snd_rme32_capture_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_capture_pointer,
-	.copy =		snd_rme32_capture_copy,
+	.copy_user =	snd_rme32_capture_copy,
+	.copy_kernel =	snd_rme32_capture_copy_kernel,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1231,8 +1250,9 @@ static const struct snd_pcm_ops snd_rme32_playback_adat_ops = {
 	.prepare =	snd_rme32_playback_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_playback_pointer,
-	.copy =		snd_rme32_playback_copy,
-	.silence =	snd_rme32_playback_silence,
+	.copy_user =	snd_rme32_playback_copy,
+	.copy_kernel =	snd_rme32_playback_copy_kernel,
+	.fill_silence =	snd_rme32_playback_silence,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1244,7 +1264,8 @@ static const struct snd_pcm_ops snd_rme32_capture_adat_ops = {
 	.prepare =	snd_rme32_capture_prepare,
 	.trigger =	snd_rme32_pcm_trigger,
 	.pointer =	snd_rme32_capture_pointer,
-	.copy =		snd_rme32_capture_copy,
+	.copy_user =	snd_rme32_capture_copy,
+	.copy_kernel =	snd_rme32_capture_copy_kernel,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
-- 
2.13.0
