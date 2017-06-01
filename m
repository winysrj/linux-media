Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42555 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751224AbdFAU7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:09 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 15/27] [media] solo6x10: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:38 +0200
Message-Id: <20170601205850.24993-16-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
The device supports only 1 channel and 8bit sample, so it's always
bytes=frames, and we need no conversion of unit in the callback.
Also, it's a capture stream, thus no silence is needed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/media/pci/solo6x10/solo6x10-g723.c | 32 ++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 36e93540bb49..3ca947092775 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -223,9 +223,9 @@ static snd_pcm_uframes_t snd_solo_pcm_pointer(struct snd_pcm_substream *ss)
 	return idx * G723_FRAMES_PER_PAGE;
 }
 
-static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
-			     snd_pcm_uframes_t pos, void __user *dst,
-			     snd_pcm_uframes_t count)
+static int __snd_solo_pcm_copy(struct snd_pcm_substream *ss,
+			       unsigned long pos, void *dst,
+			       unsigned long count, bool in_kernel)
 {
 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
 	struct solo_dev *solo_dev = solo_pcm->solo_dev;
@@ -242,16 +242,31 @@ static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
 		if (err)
 			return err;
 
-		err = copy_to_user(dst + (i * G723_PERIOD_BYTES),
-				   solo_pcm->g723_buf, G723_PERIOD_BYTES);
-
-		if (err)
+		if (in_kernel)
+			memcpy(dst, solo_pcm->g723_buf, G723_PERIOD_BYTES);
+		else if (copy_to_user((void __user *)dst,
+				      solo_pcm->g723_buf, G723_PERIOD_BYTES))
 			return -EFAULT;
+		dst += G723_PERIOD_BYTES;
 	}
 
 	return 0;
 }
 
+static int snd_solo_pcm_copy_user(struct snd_pcm_substream *ss, int channel,
+				  unsigned long pos, void __user *dst,
+				  unsigned long count)
+{
+	return __snd_solo_pcm_copy(ss, pos, (void *)dst, count, false);
+}
+
+static int snd_solo_pcm_copy_kernel(struct snd_pcm_substream *ss, int channel,
+				    unsigned long pos, void *dst,
+				    unsigned long count)
+{
+	return __snd_solo_pcm_copy(ss, pos, dst, count, true);
+}
+
 static const struct snd_pcm_ops snd_solo_pcm_ops = {
 	.open = snd_solo_pcm_open,
 	.close = snd_solo_pcm_close,
@@ -261,7 +276,8 @@ static const struct snd_pcm_ops snd_solo_pcm_ops = {
 	.prepare = snd_solo_pcm_prepare,
 	.trigger = snd_solo_pcm_trigger,
 	.pointer = snd_solo_pcm_pointer,
-	.copy = snd_solo_pcm_copy,
+	.copy_user = snd_solo_pcm_copy_user,
+	.copy_kernel = snd_solo_pcm_copy_kernel,
 };
 
 static int snd_solo_capture_volume_info(struct snd_kcontrol *kcontrol,
-- 
2.13.0
