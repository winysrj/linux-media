Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756938AbdEUUKC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:02 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 15/16] [media] solo6x10: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:49 +0200
Message-Id: <20170521200950.4592-16-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
It's a capture stream, thus no silence is needed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/media/pci/solo6x10/solo6x10-g723.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 36e93540bb49..e21db3efb748 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -225,7 +225,7 @@ static snd_pcm_uframes_t snd_solo_pcm_pointer(struct snd_pcm_substream *ss)
 
 static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
 			     snd_pcm_uframes_t pos, void __user *dst,
-			     snd_pcm_uframes_t count)
+			     snd_pcm_uframes_t count, bool in_kernel)
 {
 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
 	struct solo_dev *solo_dev = solo_pcm->solo_dev;
@@ -242,10 +242,11 @@ static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
 		if (err)
 			return err;
 
-		err = copy_to_user(dst + (i * G723_PERIOD_BYTES),
-				   solo_pcm->g723_buf, G723_PERIOD_BYTES);
-
-		if (err)
+		if (in_kernel)
+			memcpy((void *)dst + (i * G723_PERIOD_BYTES),
+			       solo_pcm->g723_buf, G723_PERIOD_BYTES);
+		else if (copy_to_user(dst + (i * G723_PERIOD_BYTES),
+				      solo_pcm->g723_buf, G723_PERIOD_BYTES))
 			return -EFAULT;
 	}
 
@@ -261,7 +262,7 @@ static const struct snd_pcm_ops snd_solo_pcm_ops = {
 	.prepare = snd_solo_pcm_prepare,
 	.trigger = snd_solo_pcm_trigger,
 	.pointer = snd_solo_pcm_pointer,
-	.copy = snd_solo_pcm_copy,
+	.copy_silence = snd_solo_pcm_copy,
 };
 
 static int snd_solo_capture_volume_info(struct snd_kcontrol *kcontrol,
-- 
2.13.0
