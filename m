Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751173AbdFAU7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:07 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 05/27] ALSA: nm256: Convert to new PCM copy ops
Date: Thu,  1 Jun 2017 22:58:28 +0200
Message-Id: <20170601205850.24993-6-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new ops.
The conversion is straightforward with standard helper functions, and
now we can drop the bytes <-> frames conversions in callbacks.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/nm256/nm256.c | 57 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 103fe311e5a9..63f0985dae27 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -695,53 +695,68 @@ snd_nm256_capture_pointer(struct snd_pcm_substream *substream)
  */
 static int
 snd_nm256_playback_silence(struct snd_pcm_substream *substream,
-			   int channel, /* not used (interleaved data) */
-			   snd_pcm_uframes_t pos,
-			   snd_pcm_uframes_t count)
+			   int channel, unsigned long pos, unsigned long count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct nm256_stream *s = runtime->private_data;
-	count = frames_to_bytes(runtime, count);
-	pos = frames_to_bytes(runtime, pos);
+
 	memset_io(s->bufptr + pos, 0, count);
 	return 0;
 }
 
 static int
 snd_nm256_playback_copy(struct snd_pcm_substream *substream,
-			int channel, /* not used (interleaved data) */
-			snd_pcm_uframes_t pos,
-			void __user *src,
-			snd_pcm_uframes_t count)
+			int channel, unsigned long pos,
+			void __user *src, unsigned long count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct nm256_stream *s = runtime->private_data;
-	count = frames_to_bytes(runtime, count);
-	pos = frames_to_bytes(runtime, pos);
+
 	if (copy_from_user_toio(s->bufptr + pos, src, count))
 		return -EFAULT;
 	return 0;
 }
 
+static int
+snd_nm256_playback_copy_kernel(struct snd_pcm_substream *substream,
+			       int channel, unsigned long pos,
+			       void *src, unsigned long count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct nm256_stream *s = runtime->private_data;
+
+	memcpy_toio(s->bufptr + pos, src, count);
+	return 0;
+}
+
 /*
  * copy to user
  */
 static int
 snd_nm256_capture_copy(struct snd_pcm_substream *substream,
-		       int channel, /* not used (interleaved data) */
-		       snd_pcm_uframes_t pos,
-		       void __user *dst,
-		       snd_pcm_uframes_t count)
+		       int channel, unsigned long pos,
+		       void __user *dst, unsigned long count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct nm256_stream *s = runtime->private_data;
-	count = frames_to_bytes(runtime, count);
-	pos = frames_to_bytes(runtime, pos);
+
 	if (copy_to_user_fromio(dst, s->bufptr + pos, count))
 		return -EFAULT;
 	return 0;
 }
 
+static int
+snd_nm256_capture_copy_kernel(struct snd_pcm_substream *substream,
+			      int channel, unsigned long pos,
+			      void *dst, unsigned long count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct nm256_stream *s = runtime->private_data;
+
+	memcpy_fromio(dst, s->bufptr + pos, count);
+	return 0;
+}
+
 #endif /* !__i386__ */
 
 
@@ -911,8 +926,9 @@ static const struct snd_pcm_ops snd_nm256_playback_ops = {
 	.trigger =	snd_nm256_playback_trigger,
 	.pointer =	snd_nm256_playback_pointer,
 #ifndef __i386__
-	.copy =		snd_nm256_playback_copy,
-	.silence =	snd_nm256_playback_silence,
+	.copy_user =	snd_nm256_playback_copy,
+	.copy_kernel =	snd_nm256_playback_copy_kernel,
+	.fill_silence =	snd_nm256_playback_silence,
 #endif
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
@@ -926,7 +942,8 @@ static const struct snd_pcm_ops snd_nm256_capture_ops = {
 	.trigger =	snd_nm256_capture_trigger,
 	.pointer =	snd_nm256_capture_pointer,
 #ifndef __i386__
-	.copy =		snd_nm256_capture_copy,
+	.copy_user =	snd_nm256_capture_copy,
+	.copy_kernel =	snd_nm256_capture_copy_kernel,
 #endif
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
-- 
2.13.0
