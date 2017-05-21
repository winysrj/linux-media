Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38225 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756936AbdEUUKC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 16:10:02 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 12/16] ALSA: sb: Convert to copy_silence ops
Date: Sun, 21 May 2017 22:09:46 +0200
Message-Id: <20170521200950.4592-13-tiwai@suse.de>
In-Reply-To: <20170521200950.4592-1-tiwai@suse.de>
References: <20170521200950.4592-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new merged ops.
We could reduce the redundant silence code by that.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/isa/sb/emu8000_pcm.c | 99 ++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 69 deletions(-)

diff --git a/sound/isa/sb/emu8000_pcm.c b/sound/isa/sb/emu8000_pcm.c
index 32f234f494e5..fd42ae2f73b8 100644
--- a/sound/isa/sb/emu8000_pcm.c
+++ b/sound/isa/sb/emu8000_pcm.c
@@ -422,16 +422,28 @@ do { \
 		return -EAGAIN;\
 } while (0)
 
+static inline int get_val(unsigned short *sval, unsigned short __user *buf,
+			  bool in_kernel)
+{
+	if (!buf)
+		*sval = 0;
+	else if (in_kernel)
+		*sval = *(unsigned short *)buf;
+	else if (get_user(*sval, buf))
+		return -EFAULT;
+	return 0;
+}
 
 #ifdef USE_NONINTERLEAVE
 /* copy one channel block */
-static int emu8k_transfer_block(struct snd_emu8000 *emu, int offset, unsigned short *buf, int count)
+static int emu8k_transfer_block(struct snd_emu8000 *emu, int offset,
+				unsigned short *buf, int count, bool in_kernel)
 {
 	EMU8000_SMALW_WRITE(emu, offset);
 	while (count > 0) {
 		unsigned short sval;
 		CHECK_SCHEDULER();
-		if (get_user(sval, buf))
+		if (get_val(&sval, buf, in_kernel))
 			return -EFAULT;
 		EMU8000_SMLD_WRITE(emu, sval);
 		buf++;
@@ -455,48 +467,18 @@ static int emu8k_pcm_copy(struct snd_pcm_substream *subs,
 		int i, err;
 		count /= rec->voices;
 		for (i = 0; i < rec->voices; i++) {
-			err = emu8k_transfer_block(emu, pos + rec->loop_start[i], buf, count);
+			err = emu8k_transfer_block(emu,
+						   pos + rec->loop_start[i],
+						   buf, count, in_kernel);
 			if (err < 0)
 				return err;
-			buf += count;
+			if (buf)
+				buf += count;
 		}
 		return 0;
 	} else {
-		return emu8k_transfer_block(emu, pos + rec->loop_start[voice], src, count);
-	}
-}
-
-/* make a channel block silence */
-static int emu8k_silence_block(struct snd_emu8000 *emu, int offset, int count)
-{
-	EMU8000_SMALW_WRITE(emu, offset);
-	while (count > 0) {
-		CHECK_SCHEDULER();
-		EMU8000_SMLD_WRITE(emu, 0);
-		count--;
-	}
-	return 0;
-}
-
-static int emu8k_pcm_silence(struct snd_pcm_substream *subs,
-			     int voice,
-			     snd_pcm_uframes_t pos,
-			     snd_pcm_uframes_t count)
-{
-	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
-	struct snd_emu8000 *emu = rec->emu;
-
-	snd_emu8000_write_wait(emu, 1);
-	if (voice == -1 && rec->voices == 1)
-		voice = 0;
-	if (voice == -1) {
-		int err;
-		err = emu8k_silence_block(emu, pos + rec->loop_start[0], count / 2);
-		if (err < 0)
-			return err;
-		return emu8k_silence_block(emu, pos + rec->loop_start[1], count / 2);
-	} else {
-		return emu8k_silence_block(emu, pos + rec->loop_start[voice], count);
+		return emu8k_transfer_block(emu, pos + rec->loop_start[voice],
+					    src, count, in_kernel);
 	}
 }
 
@@ -510,7 +492,8 @@ static int emu8k_pcm_copy(struct snd_pcm_substream *subs,
 			  int voice,
 			  snd_pcm_uframes_t pos,
 			  void __user *src,
-			  snd_pcm_uframes_t count)
+			  snd_pcm_uframes_t count,
+			  bool in_kernel)
 {
 	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
 	struct snd_emu8000 *emu = rec->emu;
@@ -524,39 +507,18 @@ static int emu8k_pcm_copy(struct snd_pcm_substream *subs,
 	while (count-- > 0) {
 		unsigned short sval;
 		CHECK_SCHEDULER();
-		if (get_user(sval, buf))
+		if (get_val(&sval, buf, in_kernel))
 			return -EFAULT;
 		EMU8000_SMLD_WRITE(emu, sval);
-		buf++;
+		if (buf)
+			buf++;
 		if (rec->voices > 1) {
 			CHECK_SCHEDULER();
-			if (get_user(sval, buf))
+			if (get_val(&sval, buf, in_kernel))
 				return -EFAULT;
 			EMU8000_SMRD_WRITE(emu, sval);
-			buf++;
-		}
-	}
-	return 0;
-}
-
-static int emu8k_pcm_silence(struct snd_pcm_substream *subs,
-			     int voice,
-			     snd_pcm_uframes_t pos,
-			     snd_pcm_uframes_t count)
-{
-	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
-	struct snd_emu8000 *emu = rec->emu;
-
-	snd_emu8000_write_wait(emu, 1);
-	EMU8000_SMALW_WRITE(emu, rec->loop_start[0] + pos);
-	if (rec->voices > 1)
-		EMU8000_SMARW_WRITE(emu, rec->loop_start[1] + pos);
-	while (count-- > 0) {
-		CHECK_SCHEDULER();
-		EMU8000_SMLD_WRITE(emu, 0);
-		if (rec->voices > 1) {
-			CHECK_SCHEDULER();
-			EMU8000_SMRD_WRITE(emu, 0);
+			if (buf)
+				buf++;
 		}
 	}
 	return 0;
@@ -674,8 +636,7 @@ static struct snd_pcm_ops emu8k_pcm_ops = {
 	.prepare =	emu8k_pcm_prepare,
 	.trigger =	emu8k_pcm_trigger,
 	.pointer =	emu8k_pcm_pointer,
-	.copy =		emu8k_pcm_copy,
-	.silence =	emu8k_pcm_silence,
+	.copy_silence =	emu8k_pcm_copy,
 };
 
 
-- 
2.13.0
