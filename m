Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33771 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab1FWO6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 10:58:05 -0400
Received: by mail-gx0-f174.google.com with SMTP id 21so800751gxk.19
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 07:58:05 -0700 (PDT)
MIME-Version: 1.0
From: "Adam M. Dutko" <dutko.adam@gmail.com>
Date: Thu, 23 Jun 2011 10:57:45 -0400
Message-ID: <BANLkTin8z+bOS8HTbypCnrdPZ=hpNThoDw@mail.gmail.com>
Subject: [PATCH] [media] TM6000: alsa: Clean up kernel coding style errors.
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There were several coding style errors as reported by checkpatch.pl. This
patch should fix those errors with the single exception of the open square
bracket issue on line 45.

Signed-off-by: Adam M. Dutko <dutko.adam@gmail.com>
---
 drivers/staging/tm6000/tm6000-alsa.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c
b/drivers/staging/tm6000/tm6000-alsa.c
index 2b96047..679aa8f 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>

-#include <asm/delay.h>
+#include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -84,7 +84,6 @@ static int _tm6000_start_audio_dma(struct
snd_tm6000_card *chip)

 	tm6000_set_audio_bitrate(core, 48000);

-
 	return 0;
 }

@@ -123,6 +122,7 @@ static int dsp_buffer_alloc(struct
snd_pcm_substream *substream, int size)
 	if (substream->runtime->dma_area) {
 		if (substream->runtime->dma_bytes > size)
 			return 0;
+
 		dsp_buffer_free(substream);
 	}

@@ -152,9 +152,9 @@ static struct snd_pcm_hardware snd_tm6000_digital_hw = {
 		SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,

-	.rates =		SNDRV_PCM_RATE_CONTINUOUS,
-	.rate_min =		48000,
-	.rate_max =		48000,
+	.rates = SNDRV_PCM_RATE_CONTINUOUS,
+	.rate_min = 48000,
+	.rate_max = 48000,
 	.channels_min = 2,
 	.channels_max = 2,
 	.period_bytes_min = 64,
@@ -254,9 +254,9 @@ static int tm6000_fillbuf(struct tm6000_core
*core, char *buf, int size)
 		memcpy(runtime->dma_area + buf_pos * stride, buf,
 			length * stride);

-#ifndef NO_PCM_LOCK
-       snd_pcm_stream_lock(substream);
-#endif
+	#ifndef NO_PCM_LOCK
+	snd_pcm_stream_lock(substream);
+	#endif

 	chip->buf_pos += length;
 	if (chip->buf_pos >= runtime->buffer_size)
@@ -268,9 +268,9 @@ static int tm6000_fillbuf(struct tm6000_core
*core, char *buf, int size)
 		period_elapsed = 1;
 	}

-#ifndef NO_PCM_LOCK
-       snd_pcm_stream_unlock(substream);
-#endif
+	#ifndef NO_PCM_LOCK
+	snd_pcm_stream_unlock(substream);
+	#endif

 	if (period_elapsed)
 		snd_pcm_period_elapsed(substream);
@@ -461,7 +461,7 @@ int tm6000_audio_init(struct tm6000_core *dev)
 	if (rc < 0)
 		goto error_chip;

-	dprintk(1,"Registered audio driver for %s\n", card->longname);
+	dprintk(1, "Registered audio driver for %s\n", card->longname);

 	return 0;

-- 
1.7.1
