Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1K1XXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 18:23:37 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pASNNb8G031071
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 18:23:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] tm6000: Add a few missing bits to alsa
Date: Mon, 28 Nov 2011 21:23:30 -0200
Message-Id: <1322522611-26392-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some properties found on em28xx, but not on tm6000. Add
them, in order to be more consistent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-alsa.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-alsa.c b/drivers/media/video/tm6000/tm6000-alsa.c
index 7d675c7..ddffd67 100644
--- a/drivers/media/video/tm6000/tm6000-alsa.c
+++ b/drivers/media/video/tm6000/tm6000-alsa.c
@@ -146,20 +146,21 @@ static int dsp_buffer_alloc(struct snd_pcm_substream *substream, int size)
 #define DEFAULT_FIFO_SIZE	4096
 
 static struct snd_pcm_hardware snd_tm6000_digital_hw = {
-	.info = SNDRV_PCM_INFO_MMAP |
+	.info = SNDRV_PCM_INFO_BATCH |
+		SNDRV_PCM_INFO_MMAP |
 		SNDRV_PCM_INFO_INTERLEAVED |
 		SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		SNDRV_PCM_INFO_MMAP_VALID,
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 
-	.rates = SNDRV_PCM_RATE_CONTINUOUS,
+	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,
 	.rate_min = 48000,
 	.rate_max = 48000,
 	.channels_min = 2,
 	.channels_max = 2,
 	.period_bytes_min = 64,
 	.period_bytes_max = 12544,
-	.periods_min = 1,
+	.periods_min = 2,
 	.periods_max = 98,
 	.buffer_bytes_max = 62720 * 8,
 };
@@ -181,6 +182,7 @@ static int snd_tm6000_pcm_open(struct snd_pcm_substream *substream)
 	chip->substream = substream;
 
 	runtime->hw = snd_tm6000_digital_hw;
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 
 	return 0;
 _error:
@@ -347,9 +349,13 @@ static int snd_tm6000_card_trigger(struct snd_pcm_substream *substream, int cmd)
 	int err = 0;
 
 	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE: /* fall through */
+	case SNDRV_PCM_TRIGGER_RESUME: /* fall through */
 	case SNDRV_PCM_TRIGGER_START:
 		atomic_set(&core->stream_started, 1);
 		break;
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH: /* fall through */
+	case SNDRV_PCM_TRIGGER_SUSPEND: /* fall through */
 	case SNDRV_PCM_TRIGGER_STOP:
 		atomic_set(&core->stream_started, 0);
 		break;
@@ -371,6 +377,14 @@ static snd_pcm_uframes_t snd_tm6000_pointer(struct snd_pcm_substream *substream)
 	return chip->buf_pos;
 }
 
+static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
+					     unsigned long offset)
+{
+	void *pageptr = subs->runtime->dma_area + offset;
+
+	return vmalloc_to_page(pageptr);
+}
+
 /*
  * operators
  */
@@ -383,6 +397,7 @@ static struct snd_pcm_ops snd_tm6000_pcm_ops = {
 	.prepare = snd_tm6000_prepare,
 	.trigger = snd_tm6000_card_trigger,
 	.pointer = snd_tm6000_pointer,
+	.page = snd_pcm_get_vmalloc_page,
 };
 
 /*
-- 
1.7.7.3

