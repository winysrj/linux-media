Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033Ab0FFOxk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:40 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o56EreKn025687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 6 Jun 2010 10:53:40 -0400
Received: from pedra (vpn-11-208.rdu.redhat.com [10.11.11.208])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o56EraZB031853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 6 Jun 2010 10:53:39 -0400
Date: Sun, 6 Jun 2010 11:53:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] tm6000-alsa: Implement a routine to store data received
 from URB
Message-ID: <20100606115311.398acc2a@pedra>
In-Reply-To: <cover.1275835609.git.mchehab@redhat.com>
References: <cover.1275835609.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implements the fillbuf callback to store data received via URB
data transfers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index fa19a41..d31b525 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -157,16 +157,16 @@ static struct snd_pcm_hardware snd_tm6000_digital_hw = {
 		SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
-	.rates =		SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000,
-	.rate_min =		44100,
+	.rates =		SNDRV_PCM_RATE_48000,
+	.rate_min =		48000,
 	.rate_max =		48000,
 	.channels_min = 2,
 	.channels_max = 2,
-	.period_bytes_min = DEFAULT_FIFO_SIZE/4,
-	.period_bytes_max = DEFAULT_FIFO_SIZE/4,
+	.period_bytes_min = 62720,
+	.period_bytes_max = 62720,
 	.periods_min = 1,
 	.periods_max = 1024,
-	.buffer_bytes_max = (1024*1024),
+	.buffer_bytes_max = 62720 * 8,
 };
 
 /*
@@ -203,15 +203,45 @@ static int snd_tm6000_close(struct snd_pcm_substream *substream)
 
 static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
 {
-	int i;
+	struct snd_tm6000_card *chip = core->adev;
+	struct snd_pcm_substream *substream = chip->substream;
+	struct snd_pcm_runtime *runtime;
+	int period_elapsed = 0;
+	unsigned int stride, buf_pos;
 
-	/* Need to add a real code to copy audio buffer */
-	printk("Audio (%i bytes): ", size);
-	for (i = 0; i < size - 3; i +=4)
-		printk("(0x%04x, 0x%04x), ",
-			*(u16 *)(buf + i), *(u16 *)(buf + i + 2));
+	if (!size || !substream)
+		return -EINVAL;
 
-	printk("\n");
+	runtime = substream->runtime;
+	if (!runtime || !runtime->dma_area)
+		return -EINVAL;
+
+	buf_pos = chip->buf_pos;
+	stride = runtime->frame_bits >> 3;
+
+	dprintk(1, "Copying %d bytes at %p[%d] - buf size=%d x %d\n", size,
+		runtime->dma_area, buf_pos,
+		(unsigned int)runtime->buffer_size, stride);
+
+	if (buf_pos + size >= runtime->buffer_size * stride) {
+		unsigned int cnt = runtime->buffer_size * stride - buf_pos;
+		memcpy(runtime->dma_area + buf_pos, buf, cnt);
+		memcpy(runtime->dma_area, buf + cnt, size - cnt);
+	} else
+		memcpy(runtime->dma_area + buf_pos, buf, size);
+
+	chip->buf_pos += size;
+	if (chip->buf_pos >= runtime->buffer_size * stride)
+		chip->buf_pos -= runtime->buffer_size * stride;
+
+	chip->period_pos += size;
+	if (chip->period_pos >= runtime->period_size) {
+		chip->period_pos -= runtime->period_size;
+		period_elapsed = 1;
+	}
+
+	if (period_elapsed)
+		snd_pcm_period_elapsed(substream);
 
 	return 0;
 }
-- 
1.7.1

