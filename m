Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751050AbdFAU7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:05 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 04/27] ALSA: es1938: Convert to the new PCM copy ops
Date: Thu,  1 Jun 2017 22:58:27 +0200
Message-Id: <20170601205850.24993-5-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy ops with the new copy_user and copy_kernel ops.
It's used only for a capture stream (for some hardware workaround),
thus we need no silence operation.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/es1938.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index e8d943071a8c..a544cd52f73a 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -839,15 +839,12 @@ static snd_pcm_uframes_t snd_es1938_playback_pointer(struct snd_pcm_substream *s
 }
 
 static int snd_es1938_capture_copy(struct snd_pcm_substream *substream,
-				   int channel,
-				   snd_pcm_uframes_t pos,
-				   void __user *dst,
-				   snd_pcm_uframes_t count)
+				   int channel, unsigned long pos,
+				   void __user *dst, unsigned long count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct es1938 *chip = snd_pcm_substream_chip(substream);
-	pos <<= chip->dma1_shift;
-	count <<= chip->dma1_shift;
+
 	if (snd_BUG_ON(pos + count > chip->dma1_size))
 		return -EINVAL;
 	if (pos + count < chip->dma1_size) {
@@ -856,12 +853,31 @@ static int snd_es1938_capture_copy(struct snd_pcm_substream *substream,
 	} else {
 		if (copy_to_user(dst, runtime->dma_area + pos + 1, count - 1))
 			return -EFAULT;
-		if (put_user(runtime->dma_area[0], ((unsigned char __user *)dst) + count - 1))
+		if (put_user(runtime->dma_area[0],
+			     ((unsigned char __user *)dst) + count - 1))
 			return -EFAULT;
 	}
 	return 0;
 }
 
+static int snd_es1938_capture_copy_kernel(struct snd_pcm_substream *substream,
+					  int channel, unsigned long pos,
+					  void *dst, unsigned long count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct es1938 *chip = snd_pcm_substream_chip(substream);
+
+	if (snd_BUG_ON(pos + count > chip->dma1_size))
+		return -EINVAL;
+	if (pos + count < chip->dma1_size) {
+		memcpy(dst, runtime->dma_area + pos + 1, count);
+	} else {
+		memcpy(dst, runtime->dma_area + pos + 1, count - 1);
+		runtime->dma_area[0] = *((unsigned char *)dst + count - 1);
+	}
+	return 0;
+}
+
 /*
  * buffer management
  */
@@ -1012,7 +1028,8 @@ static const struct snd_pcm_ops snd_es1938_capture_ops = {
 	.prepare =	snd_es1938_capture_prepare,
 	.trigger =	snd_es1938_capture_trigger,
 	.pointer =	snd_es1938_capture_pointer,
-	.copy =		snd_es1938_capture_copy,
+	.copy_user =	snd_es1938_capture_copy,
+	.copy_kernel =	snd_es1938_capture_copy_kernel,
 };
 
 static int snd_es1938_new_pcm(struct es1938 *chip, int device)
-- 
2.13.0
