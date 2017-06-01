Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42529 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751163AbdFAU7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:08 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 12/27] ALSA: sb: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:35 +0200
Message-Id: <20170601205850.24993-13-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
For avoiding the code redundancy, slightly hackish macros are
introduced.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/isa/sb/emu8000_pcm.c | 190 ++++++++++++++++++++++++++-------------------
 1 file changed, 109 insertions(+), 81 deletions(-)

diff --git a/sound/isa/sb/emu8000_pcm.c b/sound/isa/sb/emu8000_pcm.c
index c480024422af..2ee8d67871ec 100644
--- a/sound/isa/sb/emu8000_pcm.c
+++ b/sound/isa/sb/emu8000_pcm.c
@@ -422,121 +422,148 @@ do { \
 		return -EAGAIN;\
 } while (0)
 
+enum {
+	COPY_USER, COPY_KERNEL, FILL_SILENCE,
+};
+
+#define GET_VAL(sval, buf, mode)					\
+	do {								\
+		switch (mode) {						\
+		case FILL_SILENCE:					\
+			sval = 0;					\
+			break;						\
+		case COPY_KERNEL:					\
+			sval = *buf++;					\
+			break;						\
+		default:						\
+			if (get_user(sval, (unsigned short __user *)buf)) \
+				return -EFAULT;				\
+			buf++;						\
+			break;						\
+		}							\
+	} while (0)
 
 #ifdef USE_NONINTERLEAVE
-/* copy one channel block */
-static int emu8k_transfer_block(struct snd_emu8000 *emu, int offset, unsigned short *buf, int count)
-{
-	EMU8000_SMALW_WRITE(emu, offset);
-	while (count > 0) {
-		unsigned short sval;
-		CHECK_SCHEDULER();
-		if (get_user(sval, buf))
-			return -EFAULT;
-		EMU8000_SMLD_WRITE(emu, sval);
-		buf++;
-		count--;
-	}
-	return 0;
-}
 
+#define LOOP_WRITE(rec, offset, _buf, count, mode)		\
+	do {							\
+		struct snd_emu8000 *emu = (rec)->emu;		\
+		unsigned short *buf = (unsigned short *)(_buf); \
+		snd_emu8000_write_wait(emu, 1);			\
+		EMU8000_SMALW_WRITE(emu, offset);		\
+		while (count > 0) {				\
+			unsigned short sval;			\
+			CHECK_SCHEDULER();			\
+			GET_VAL(sval, buf, mode);		\
+			EMU8000_SMLD_WRITE(emu, sval);		\
+			count--;				\
+		}						\
+	} while (0)
+
+/* copy one channel block */
 static int emu8k_pcm_copy(struct snd_pcm_substream *subs,
-			  int voice,
-			  snd_pcm_uframes_t pos,
-			  void *src,
-			  snd_pcm_uframes_t count)
+			  int voice, unsigned long pos,
+			  void __user *src, unsigned long count)
 {
 	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
-	struct snd_emu8000 *emu = rec->emu;
 
-	snd_emu8000_write_wait(emu, 1);
-	return emu8k_transfer_block(emu, pos + rec->loop_start[voice], src,
-				    count);
+	/* convert to word unit */
+	pos = (pos << 1) + rec->loop_start[voice];
+	count <<= 1;
+	LOOP_WRITE(rec, pos, src, count, COPY_UESR);
+	return 0;
 }
 
-/* make a channel block silence */
-static int emu8k_silence_block(struct snd_emu8000 *emu, int offset, int count)
+static int emu8k_pcm_copy_kernel(struct snd_pcm_substream *subs,
+				 int voice, unsigned long pos,
+				 void *src, unsigned long count)
 {
-	EMU8000_SMALW_WRITE(emu, offset);
-	while (count > 0) {
-		CHECK_SCHEDULER();
-		EMU8000_SMLD_WRITE(emu, 0);
-		count--;
-	}
+	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
+
+	/* convert to word unit */
+	pos = (pos << 1) + rec->loop_start[voice];
+	count <<= 1;
+	LOOP_WRITE(rec, pos, src, count, COPY_KERNEL);
 	return 0;
 }
 
+/* make a channel block silence */
 static int emu8k_pcm_silence(struct snd_pcm_substream *subs,
-			     int voice,
-			     snd_pcm_uframes_t pos,
-			     snd_pcm_uframes_t count)
+			     int voice, unsigned long pos, unsigned long count)
 {
 	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
-	struct snd_emu8000 *emu = rec->emu;
 
-	snd_emu8000_write_wait(emu, 1);
-	return emu8k_silence_block(emu, pos + rec->loop_start[voice], count);
+	/* convert to word unit */
+	pos = (pos << 1) + rec->loop_start[voice];
+	count <<= 1;
+	LOOP_WRITE(rec, pos, NULL, count, FILL_SILENCE);
+	return 0;
 }
 
 #else /* interleave */
 
+#define LOOP_WRITE(rec, pos, _buf, count, mode)				\
+	do {								\
+		struct snd_emu8000 *emu = rec->emu;			\
+		unsigned short *buf = (unsigned short *)(_buf);		\
+		snd_emu8000_write_wait(emu, 1);				\
+		EMU8000_SMALW_WRITE(emu, pos + rec->loop_start[0]);	\
+		if (rec->voices > 1)					\
+			EMU8000_SMARW_WRITE(emu, pos + rec->loop_start[1]); \
+		while (count > 0) {					\
+			unsigned short sval;				\
+			CHECK_SCHEDULER();				\
+			GET_VAL(sval, buf, mode);			\
+			EMU8000_SMLD_WRITE(emu, sval);			\
+			if (rec->voices > 1) {				\
+				CHECK_SCHEDULER();			\
+				GET_VAL(sval, buf, mode);		\
+				EMU8000_SMRD_WRITE(emu, sval);		\
+			}						\
+			count--;					\
+		}							\
+	} while (0)
+
+
 /*
  * copy the interleaved data can be done easily by using
  * DMA "left" and "right" channels on emu8k engine.
  */
 static int emu8k_pcm_copy(struct snd_pcm_substream *subs,
-			  int voice,
-			  snd_pcm_uframes_t pos,
-			  void __user *src,
-			  snd_pcm_uframes_t count)
+			  int voice, unsigned long pos,
+			  void __user *src, unsigned long count)
 {
 	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
-	struct snd_emu8000 *emu = rec->emu;
-	unsigned short __user *buf = src;
 
-	snd_emu8000_write_wait(emu, 1);
-	EMU8000_SMALW_WRITE(emu, pos + rec->loop_start[0]);
-	if (rec->voices > 1)
-		EMU8000_SMARW_WRITE(emu, pos + rec->loop_start[1]);
-
-	while (count-- > 0) {
-		unsigned short sval;
-		CHECK_SCHEDULER();
-		if (get_user(sval, buf))
-			return -EFAULT;
-		EMU8000_SMLD_WRITE(emu, sval);
-		buf++;
-		if (rec->voices > 1) {
-			CHECK_SCHEDULER();
-			if (get_user(sval, buf))
-				return -EFAULT;
-			EMU8000_SMRD_WRITE(emu, sval);
-			buf++;
-		}
-	}
+	/* convert to frames */
+	pos = bytes_to_frames(subs->runtime, pos);
+	count = bytes_to_frames(subs->runtime, count);
+	LOOP_WRITE(rec, pos, src, count, COPY_USER);
+	return 0;
+}
+
+static int emu8k_pcm_copy_kernel(struct snd_pcm_substream *subs,
+				 int voice, unsigned long pos,
+				 void *src, unsigned long count)
+{
+	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
+
+	/* convert to frames */
+	pos = bytes_to_frames(subs->runtime, pos);
+	count = bytes_to_frames(subs->runtime, count);
+	LOOP_WRITE(rec, pos, src, count, COPY_KERNEL);
 	return 0;
 }
 
 static int emu8k_pcm_silence(struct snd_pcm_substream *subs,
-			     int voice,
-			     snd_pcm_uframes_t pos,
-			     snd_pcm_uframes_t count)
+			     int voice, unsigned long pos, unsigned long count)
 {
 	struct snd_emu8k_pcm *rec = subs->runtime->private_data;
-	struct snd_emu8000 *emu = rec->emu;
 
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
-		}
-	}
+	/* convert to frames */
+	pos = bytes_to_frames(subs->runtime, pos);
+	count = bytes_to_frames(subs->runtime, count);
+	LOOP_WRITE(rec, pos, NULL, count, FILL_SILENCE);
 	return 0;
 }
 #endif
@@ -652,8 +679,9 @@ static struct snd_pcm_ops emu8k_pcm_ops = {
 	.prepare =	emu8k_pcm_prepare,
 	.trigger =	emu8k_pcm_trigger,
 	.pointer =	emu8k_pcm_pointer,
-	.copy =		emu8k_pcm_copy,
-	.silence =	emu8k_pcm_silence,
+	.copy_user =	emu8k_pcm_copy,
+	.copy_kernel =	emu8k_pcm_copy_kernel,
+	.fill_silence =	emu8k_pcm_silence,
 };
 
 
-- 
2.13.0
