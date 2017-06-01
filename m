Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42515 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751159AbdFAU7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 16:59:08 -0400
From: Takashi Iwai <tiwai@suse.de>
To: alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 08/27] ALSA: rme96: Convert to the new PCM ops
Date: Thu,  1 Jun 2017 22:58:31 +0200
Message-Id: <20170601205850.24993-9-tiwai@suse.de>
In-Reply-To: <20170601205850.24993-1-tiwai@suse.de>
References: <20170601205850.24993-1-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the copy and the silence ops with the new PCM ops.
The conversion is straightforward with standard helper functions, and
now we can drop the bytes <-> frames conversions in callbacks.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/rme96.c | 70 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 05b9da30990d..24f1349a8e1b 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -327,13 +327,10 @@ snd_rme96_capture_ptr(struct rme96 *rme96)
 
 static int
 snd_rme96_playback_silence(struct snd_pcm_substream *substream,
-			   int channel, /* not used (interleaved data) */
-			   snd_pcm_uframes_t pos,
-			   snd_pcm_uframes_t count)
+			   int channel, unsigned long pos, unsigned long count)
 {
 	struct rme96 *rme96 = snd_pcm_substream_chip(substream);
-	count <<= rme96->playback_frlog;
-	pos <<= rme96->playback_frlog;
+
 	memset_io(rme96->iobase + RME96_IO_PLAY_BUFFER + pos,
 		  0, count);
 	return 0;
@@ -341,32 +338,49 @@ snd_rme96_playback_silence(struct snd_pcm_substream *substream,
 
 static int
 snd_rme96_playback_copy(struct snd_pcm_substream *substream,
-			int channel, /* not used (interleaved data) */
-			snd_pcm_uframes_t pos,
-			void __user *src,
-			snd_pcm_uframes_t count)
+			int channel, unsigned long pos,
+			void __user *src, unsigned long count)
 {
 	struct rme96 *rme96 = snd_pcm_substream_chip(substream);
-	count <<= rme96->playback_frlog;
-	pos <<= rme96->playback_frlog;
-	return copy_from_user_toio(rme96->iobase + RME96_IO_PLAY_BUFFER + pos, src,
-				   count);
+
+	return copy_from_user_toio(rme96->iobase + RME96_IO_PLAY_BUFFER + pos,
+				   src, count);
+}
+
+static int
+snd_rme96_playback_copy_kernel(struct snd_pcm_substream *substream,
+			       int channel, unsigned long pos,
+			       void *src, unsigned long count)
+{
+	struct rme96 *rme96 = snd_pcm_substream_chip(substream);
+
+	memcpy_toio(rme96->iobase + RME96_IO_PLAY_BUFFER + pos, src, count);
+	return 0;
 }
 
 static int
 snd_rme96_capture_copy(struct snd_pcm_substream *substream,
-		       int channel, /* not used (interleaved data) */
-		       snd_pcm_uframes_t pos,
-		       void __user *dst,
-		       snd_pcm_uframes_t count)
+		       int channel, unsigned long pos,
+		       void __user *dst, unsigned long count)
 {
 	struct rme96 *rme96 = snd_pcm_substream_chip(substream);
-	count <<= rme96->capture_frlog;
-	pos <<= rme96->capture_frlog;
-	return copy_to_user_fromio(dst, rme96->iobase + RME96_IO_REC_BUFFER + pos,
+
+	return copy_to_user_fromio(dst,
+				   rme96->iobase + RME96_IO_REC_BUFFER + pos,
 				   count);
 }
 
+static int
+snd_rme96_capture_copy_kernel(struct snd_pcm_substream *substream,
+			      int channel, unsigned long pos,
+			      void *dst, unsigned long count)
+{
+	struct rme96 *rme96 = snd_pcm_substream_chip(substream);
+
+	memcpy_fromio(dst, rme96->iobase + RME96_IO_REC_BUFFER + pos, count);
+	return 0;
+}
+
 /*
  * Digital output capabilities (S/PDIF)
  */
@@ -1513,8 +1527,9 @@ static const struct snd_pcm_ops snd_rme96_playback_spdif_ops = {
 	.prepare =	snd_rme96_playback_prepare,
 	.trigger =	snd_rme96_playback_trigger,
 	.pointer =	snd_rme96_playback_pointer,
-	.copy =		snd_rme96_playback_copy,
-	.silence =	snd_rme96_playback_silence,
+	.copy_user =	snd_rme96_playback_copy,
+	.copy_kernel =	snd_rme96_playback_copy_kernel,
+	.fill_silence =	snd_rme96_playback_silence,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1526,7 +1541,8 @@ static const struct snd_pcm_ops snd_rme96_capture_spdif_ops = {
 	.prepare =	snd_rme96_capture_prepare,
 	.trigger =	snd_rme96_capture_trigger,
 	.pointer =	snd_rme96_capture_pointer,
-	.copy =		snd_rme96_capture_copy,
+	.copy_user =	snd_rme96_capture_copy,
+	.copy_kernel =	snd_rme96_capture_copy_kernel,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1538,8 +1554,9 @@ static const struct snd_pcm_ops snd_rme96_playback_adat_ops = {
 	.prepare =	snd_rme96_playback_prepare,
 	.trigger =	snd_rme96_playback_trigger,
 	.pointer =	snd_rme96_playback_pointer,
-	.copy =		snd_rme96_playback_copy,
-	.silence =	snd_rme96_playback_silence,
+	.copy_user =	snd_rme96_playback_copy,
+	.copy_kernel =	snd_rme96_playback_copy_kernel,
+	.fill_silence =	snd_rme96_playback_silence,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
@@ -1551,7 +1568,8 @@ static const struct snd_pcm_ops snd_rme96_capture_adat_ops = {
 	.prepare =	snd_rme96_capture_prepare,
 	.trigger =	snd_rme96_capture_trigger,
 	.pointer =	snd_rme96_capture_pointer,
-	.copy =		snd_rme96_capture_copy,
+	.copy_user =	snd_rme96_capture_copy,
+	.copy_kernel =	snd_rme96_capture_copy_kernel,
 	.mmap =		snd_pcm_lib_mmap_iomem,
 };
 
-- 
2.13.0
