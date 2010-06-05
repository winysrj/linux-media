Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab0FEAVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:22 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LM3P011183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:22 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7k015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:21 -0400
Date: Fri, 4 Jun 2010 21:21:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] tm6000-alsa: rework audio buffer
 allocation/deallocation
Message-ID: <20100604212107.3b9e8a1b@pedra>
In-Reply-To: <cover.1275696910.git.mchehab@redhat.com>
References: <cover.1275696910.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 8520434..ca9aec5 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/usb.h>
+#include <linux/vmalloc.h>
 
 #include <asm/delay.h>
 #include <sound/core.h>
@@ -105,19 +106,39 @@ static int _tm6000_stop_audio_dma(struct snd_tm6000_card *chip)
 	return 0;
 }
 
-static int dsp_buffer_free(struct snd_tm6000_card *chip)
+static void dsp_buffer_free(struct snd_pcm_substream *substream)
 {
-	BUG_ON(!chip->bufsize);
+	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
 
 	dprintk(2, "Freeing buffer\n");
 
-	/* FIXME: Frees buffer */
+	vfree(substream->runtime->dma_area);
+	substream->runtime->dma_area = NULL;
+	substream->runtime->dma_bytes = 0;
+}
+
+static int dsp_buffer_alloc(struct snd_pcm_substream *substream, int size)
+{
+	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
+
+	dprintk(2, "Allocating buffer\n");
 
-	chip->bufsize = 0;
+	if (substream->runtime->dma_area) {
+		if (substream->runtime->dma_bytes > size)
+			return 0;
+		dsp_buffer_free(substream);
+	}
 
-       return 0;
+	substream->runtime->dma_area = vmalloc(size);
+	if (!substream->runtime->dma_area)
+		return -ENOMEM;
+
+	substream->runtime->dma_bytes = size;
+
+	return 0;
 }
 
+
 /****************************************************************************
 				ALSA PCM Interface
  ****************************************************************************/
@@ -184,23 +205,13 @@ static int snd_tm6000_close(struct snd_pcm_substream *substream)
 static int snd_tm6000_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_pcm_hw_params *hw_params)
 {
-	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
+	int size, rc;
 
-	if (substream->runtime->dma_area) {
-		dsp_buffer_free(chip);
-		substream->runtime->dma_area = NULL;
-	}
-
-	chip->period_size = params_period_bytes(hw_params);
-	chip->num_periods = params_periods(hw_params);
-	chip->bufsize = chip->period_size * params_periods(hw_params);
-
-	BUG_ON(!chip->bufsize);
-
-	dprintk(1, "Setting buffer\n");
-
-	/* FIXME: Allocate buffer for audio */
+	size = params_period_bytes(hw_params) * params_periods(hw_params);
 
+	rc = dsp_buffer_alloc(substream, size);
+	if (rc < 0)
+		return rc;
 
 	return 0;
 }
@@ -210,13 +221,7 @@ static int snd_tm6000_hw_params(struct snd_pcm_substream *substream,
  */
 static int snd_tm6000_hw_free(struct snd_pcm_substream *substream)
 {
-
-	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
-
-	if (substream->runtime->dma_area) {
-		dsp_buffer_free(chip);
-		substream->runtime->dma_area = NULL;
-	}
+	dsp_buffer_free(substream);
 
 	return 0;
 }
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 18d1e51..a1d96d6 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -136,11 +136,7 @@ struct snd_tm6000_card {
 	struct snd_card			*card;
 	spinlock_t			reg_lock;
 	atomic_t			count;
-	unsigned int			period_size;
-	unsigned int			num_periods;
 	struct tm6000_core		*core;
-	struct tm6000_buffer		*buf;
-	int				bufsize;
 	struct snd_pcm_substream	*substream;
 };
 
-- 
1.7.1


