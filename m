Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42491 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751170AbdFAU7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:07 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 06/27] ALSA: korg1212: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:29 +0200
Message-Id: <20170601205850.24993-7-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
Although we can refactor this messy code, at this time, the changes
are kept as small as possible.  Let's clean up later.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/korg1212/korg1212.c | 112 ++++++++++++++++++++++++------------------
 1 file changed, 65 insertions(+), 47 deletions(-)

diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 1e25095fd144..b28fe4914d6b 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -1299,13 +1299,21 @@ static int snd_korg1212_silence(struct snd_korg1212 *korg1212, int pos, int coun
 	return 0;
 }
 
-static int snd_korg1212_copy_to(struct snd_korg1212 *korg1212, void __user *dst, int pos, int count, int offset, int size)
+static int snd_korg1212_copy_to(struct snd_pcm_substream *substream,
+				void __user *dst, int pos, int count,
+				bool in_kernel)
 {
-	struct KorgAudioFrame * src =  korg1212->recordDataBufsPtr[0].bufferData + pos;
-	int i, rc;
-
-	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_copy_to pos=%d offset=%d size=%d\n",
-				   pos, offset, size);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+        struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
+	struct KorgAudioFrame *src;
+	int i, size;
+
+	pos = bytes_to_frames(runtime, pos);
+	count = bytes_to_frames(runtime, count);
+	size = korg1212->channels * 2;
+	src = korg1212->recordDataBufsPtr[0].bufferData + pos;
+	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_copy_to pos=%d size=%d count=%d\n",
+				   pos, size, count);
 	if (snd_BUG_ON(pos + count > K1212_MAX_SAMPLES))
 		return -EINVAL;
 
@@ -1317,11 +1325,10 @@ static int snd_korg1212_copy_to(struct snd_korg1212 *korg1212, void __user *dst,
 			return -EFAULT;
 		}
 #endif
-		rc = copy_to_user(dst + offset, src, size);
-		if (rc) {
-			K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_copy_to USER EFAULT src=%p dst=%p iter=%d\n", src, dst, i);
+		if (in_kernel)
+			memcpy((void *)dst, src, size);
+		else if (copy_to_user(dst, src, size))
 			return -EFAULT;
-		}
 		src++;
 		dst += size;
 	}
@@ -1329,13 +1336,22 @@ static int snd_korg1212_copy_to(struct snd_korg1212 *korg1212, void __user *dst,
 	return 0;
 }
 
-static int snd_korg1212_copy_from(struct snd_korg1212 *korg1212, void __user *src, int pos, int count, int offset, int size)
+static int snd_korg1212_copy_from(struct snd_pcm_substream *substream,
+				  void __user *src, int pos, int count,
+				  bool in_kernel)
 {
-	struct KorgAudioFrame * dst =  korg1212->playDataBufsPtr[0].bufferData + pos;
-	int i, rc;
+        struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
+	struct KorgAudioFrame *dst;
+	int i, size;
 
-	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_copy_from pos=%d offset=%d size=%d count=%d\n",
-				   pos, offset, size, count);
+	pos = bytes_to_frames(runtime, pos);
+	count = bytes_to_frames(runtime, count);
+	size = korg1212->channels * 2;
+	dst = korg1212->playDataBufsPtr[0].bufferData + pos;
+
+	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_copy_from pos=%d size=%d count=%d\n",
+				   pos, size, count);
 
 	if (snd_BUG_ON(pos + count > K1212_MAX_SAMPLES))
 		return -EINVAL;
@@ -1348,11 +1364,10 @@ static int snd_korg1212_copy_from(struct snd_korg1212 *korg1212, void __user *sr
 			return -EFAULT;
 		}
 #endif
-		rc = copy_from_user((void*) dst + offset, src, size);
-		if (rc) {
-			K1212_DEBUG_PRINTK("K1212_DEBUG: snd_korg1212_copy_from USER EFAULT src=%p dst=%p iter=%d\n", src, dst, i);
+		if (in_kernel)
+			memcpy((void *)dst, src, size);
+		else if (copy_from_user(dst, src, size))
 			return -EFAULT;
-		}
 		dst++;
 		src += size;
 	}
@@ -1640,45 +1655,46 @@ static snd_pcm_uframes_t snd_korg1212_capture_pointer(struct snd_pcm_substream *
 }
 
 static int snd_korg1212_playback_copy(struct snd_pcm_substream *substream,
-                        int channel, /* not used (interleaved data) */
-                        snd_pcm_uframes_t pos,
-                        void __user *src,
-                        snd_pcm_uframes_t count)
+				      int channel, unsigned long pos,
+				      void __user *src, unsigned long count)
 {
-        struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
-
-	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_playback_copy [%s] %ld %ld\n",
-				   stateName[korg1212->cardState], pos, count);
- 
-	return snd_korg1212_copy_from(korg1212, src, pos, count, 0, korg1212->channels * 2);
+	return snd_korg1212_copy_from(substream, src, pos, count, false);
+}
 
+static int snd_korg1212_playback_copy_kernel(struct snd_pcm_substream *substream,
+				      int channel, unsigned long pos,
+				      void *src, unsigned long count)
+{
+	return snd_korg1212_copy_from(substream, (void __user *)src,
+				      pos, count, true);
 }
 
 static int snd_korg1212_playback_silence(struct snd_pcm_substream *substream,
                            int channel, /* not used (interleaved data) */
-                           snd_pcm_uframes_t pos,
-                           snd_pcm_uframes_t count)
+                           unsigned long pos,
+                           unsigned long count)
 {
+	struct snd_pcm_runtime *runtime = substream->runtime;
         struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
 
-	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_playback_silence [%s]\n",
-				   stateName[korg1212->cardState]);
-
-	return snd_korg1212_silence(korg1212, pos, count, 0, korg1212->channels * 2);
+	return snd_korg1212_silence(korg1212, bytes_to_frames(runtime, pos),
+				    bytes_to_frames(runtime, count),
+				    0, korg1212->channels * 2);
 }
 
 static int snd_korg1212_capture_copy(struct snd_pcm_substream *substream,
-                        int channel, /* not used (interleaved data) */
-                        snd_pcm_uframes_t pos,
-                        void __user *dst,
-                        snd_pcm_uframes_t count)
+				     int channel, unsigned long pos,
+				     void __user *dst, unsigned long count)
 {
-        struct snd_korg1212 *korg1212 = snd_pcm_substream_chip(substream);
-
-	K1212_DEBUG_PRINTK_VERBOSE("K1212_DEBUG: snd_korg1212_capture_copy [%s] %ld %ld\n",
-				   stateName[korg1212->cardState], pos, count);
+	return snd_korg1212_copy_to(substream, dst, pos, count, false);
+}
 
-	return snd_korg1212_copy_to(korg1212, dst, pos, count, 0, korg1212->channels * 2);
+static int snd_korg1212_capture_copy_kernel(struct snd_pcm_substream *substream,
+				     int channel, unsigned long pos,
+				     void *dst, unsigned long count)
+{
+	return snd_korg1212_copy_to(substream, (void __user *)dst,
+				    pos, count, true);
 }
 
 static const struct snd_pcm_ops snd_korg1212_playback_ops = {
@@ -1689,8 +1705,9 @@ static const struct snd_pcm_ops snd_korg1212_playback_ops = {
         .prepare =	snd_korg1212_prepare,
         .trigger =	snd_korg1212_trigger,
         .pointer =	snd_korg1212_playback_pointer,
-        .copy =		snd_korg1212_playback_copy,
-        .silence =	snd_korg1212_playback_silence,
+	.copy_user =	snd_korg1212_playback_copy,
+	.copy_kernel =	snd_korg1212_playback_copy_kernel,
+	.fill_silence =	snd_korg1212_playback_silence,
 };
 
 static const struct snd_pcm_ops snd_korg1212_capture_ops = {
@@ -1701,7 +1718,8 @@ static const struct snd_pcm_ops snd_korg1212_capture_ops = {
 	.prepare =	snd_korg1212_prepare,
 	.trigger =	snd_korg1212_trigger,
 	.pointer =	snd_korg1212_capture_pointer,
-	.copy =		snd_korg1212_capture_copy,
+	.copy_user =	snd_korg1212_capture_copy,
+	.copy_kernel =	snd_korg1212_capture_copy_kernel,
 };
 
 /*
-- 
2.13.0
