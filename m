Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.majordomo.ru ([78.108.81.8]:55186 "EHLO
	webmail.majordomo.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0EFI6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 04:58:42 -0400
From: Boris Popov <popov@stdin.info>
To: linux-media@vger.kernel.org
Cc: Boris Popov <popov@stdin.info>
Subject: [PATCH 1/1] staging: cx25821: cx25821-alsa.c: cleanup
Date: Thu,  6 May 2010 12:29:50 +0400
Message-Id: <1273134590-4645-1-git-send-email-popov@stdin.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Boris Popov <popov@stdin.info>
---
 drivers/staging/cx25821/cx25821-alsa.c |   80 +++++++++++++++++---------------
 1 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index 061add3..c73061e 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -29,7 +29,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
-#include <asm/delay.h>
+#include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -42,10 +42,10 @@
 
 #define AUDIO_SRAM_CHANNEL	SRAM_CH08
 
-#define dprintk(level,fmt, arg...)	if (debug >= level) \
+#define dprintk(level, fmt, arg...)	if (debug >= level) \
 	printk(KERN_INFO "%s/1: " fmt, chip->dev->name , ## arg)
 
-#define dprintk_core(level,fmt, arg...)	if (debug >= level) \
+#define dprintk_core(level, fmt, arg...)	if (debug >= level) \
 	printk(KERN_DEBUG "%s/1: " fmt, chip->dev->name , ## arg)
 
 /****************************************************************************
@@ -90,8 +90,8 @@ typedef struct cx25821_audio_dev snd_cx25821_card_t;
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = { 1,[1 ... (SNDRV_CARDS - 1)] = 1 };
-
+static int enable[SNDRV_CARDS] = {1,[1...(SNDRV_CARDS - 1)] = 1};
+`
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable cx25821 soundcard. default enabled.");
 
@@ -105,7 +105,7 @@ MODULE_PARM_DESC(index, "Index value for cx25821 capture interface(s).");
 MODULE_DESCRIPTION("ALSA driver module for cx25821 based capture cards");
 MODULE_AUTHOR("Hiep Huynh");
 MODULE_LICENSE("GPL");
-MODULE_SUPPORTED_DEVICE("{{Conexant,25821}");	//"{{Conexant,23881},"
+MODULE_SUPPORTED_DEVICE("{{Conexant,25821}");	/* "{{Conexant,23881}, */
 
 static unsigned int debug;
 module_param(debug, int, 0644);
@@ -135,7 +135,7 @@ MODULE_PARM_DESC(debug, "enable debug messages");
  * BOARD Specific: Sets audio DMA
  */
 
-static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
+static int _cx25821_start_audio_dma(snd_cx25821_card_t *chip)
 {
 	struct cx25821_buffer *buf = chip->buf;
 	struct cx25821_dev *dev = chip->dev;
@@ -143,7 +143,7 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 	    &cx25821_sram_channels[AUDIO_SRAM_CHANNEL];
 	u32 tmp = 0;
 
-	// enable output on the GPIO 0 for the MCLK ADC (Audio)
+	/* enable output on the GPIO 0 for the MCLK ADC (Audio) */
 	cx25821_set_gpiopin_direction(chip->dev, 0, 0);
 
 	/* Make sure RISC/FIFO are off before changing FIFO/RISC settings */
@@ -158,18 +158,22 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 	cx_write(AUD_A_LNGTH, buf->bpl);
 
 	/* reset counter */
-	cx_write(AUD_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);	//GP_COUNT_CONTROL_RESET = 0x3
+	cx_write(AUD_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);
+	/* GP_COUNT_CONTROL_RESET = 0x3 */
 	atomic_set(&chip->count, 0);
 
-	//Set the input mode to 16-bit
+	/* Set the input mode to 16-bit */
 	tmp = cx_read(AUD_A_CFG);
 	cx_write(AUD_A_CFG,
 		 tmp | FLD_AUD_DST_PK_MODE | FLD_AUD_DST_ENABLE |
 		 FLD_AUD_CLK_ENABLE);
 
-	//printk(KERN_INFO "DEBUG: Start audio DMA, %d B/line, cmds_start(0x%x)= %d lines/FIFO, %d periods, %d "
-	//      "byte buffer\n", buf->bpl, audio_ch->cmds_start, cx_read(audio_ch->cmds_start + 12)>>1,
-	//      chip->num_periods, buf->bpl * chip->num_periods);
+	/*  printk(KERN_INFO "DEBUG: Start audio DMA, %d B/line,
+	 *  cmds_start(0x%x)= %d lines/FIFO, %d periods, %d "
+	 *  "byte buffer\n", buf->bpl, audio_ch->cmds_start,
+	 *  cx_read(audio_ch->cmds_start + 12)>>1,
+	 *  chip->num_periods, buf->bpl * chip->num_periods);
+	 */
 
 	/* Enables corresponding bits at AUD_INT_STAT */
 	cx_write(AUD_A_INT_MSK,
@@ -182,7 +186,7 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 	/* enable audio irqs */
 	cx_set(PCI_INT_MSK, chip->dev->pci_irqmask | PCI_MSK_AUD_INT);
 
-	// Turn on audio downstream fifo and risc enable 0x101
+	/* Turn on audio downstream fifo and risc enable 0x101 */
 	tmp = cx_read(AUD_INT_DMA_CTL);
 	cx_set(AUD_INT_DMA_CTL,
 	       tmp | (FLD_AUD_DST_A_RISC_EN | FLD_AUD_DST_A_FIFO_EN));
@@ -194,7 +198,7 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 /*
  * BOARD Specific: Resets audio DMA
  */
-static int _cx25821_stop_audio_dma(snd_cx25821_card_t * chip)
+static int _cx25821_stop_audio_dma(snd_cx25821_card_t *chip)
 {
 	struct cx25821_dev *dev = chip->dev;
 
@@ -232,13 +236,12 @@ static char *cx25821_aud_irqs[32] = {
 /*
  * BOARD Specific: Threats IRQ audio specific calls
  */
-static void cx25821_aud_irq(snd_cx25821_card_t * chip, u32 status, u32 mask)
+static void cx25821_aud_irq(snd_cx25821_card_t *chip, u32 status, u32 mask)
 {
 	struct cx25821_dev *dev = chip->dev;
 
-	if (0 == (status & mask)) {
+	if (0 == (status & mask))
 		return;
-	}
 
 	cx_write(AUD_A_INT_STAT, status);
 	if (debug > 1 || (status & mask & ~0xff))
@@ -318,11 +321,11 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 	if (handled)
 		cx_write(PCI_INT_STAT, pci_status);
 
-      out:
+out:
 	return IRQ_RETVAL(handled);
 }
 
-static int dsp_buffer_free(snd_cx25821_card_t * chip)
+static int dsp_buffer_free(snd_cx25821_card_t *chip)
 {
 	BUG_ON(!chip->dma_size);
 
@@ -363,7 +366,8 @@ static struct snd_pcm_hardware snd_cx25821_digital_hw = {
 	.period_bytes_max = DEFAULT_FIFO_SIZE / 3,
 	.periods_min = 1,
 	.periods_max = AUDIO_LINE_SIZE,
-	.buffer_bytes_max = (AUDIO_LINE_SIZE * AUDIO_LINE_SIZE),	//128*128 = 16384 = 1024 * 16
+	.buffer_bytes_max = (AUDIO_LINE_SIZE * AUDIO_LINE_SIZE),
+	/* 128*128 = 16384 = 1024 * 16 */
 };
 
 /*
@@ -393,18 +397,19 @@ static int snd_cx25821_pcm_open(struct snd_pcm_substream *substream)
 
 	if (cx25821_sram_channels[AUDIO_SRAM_CHANNEL].fifo_size !=
 	    DEFAULT_FIFO_SIZE) {
-		bpl = cx25821_sram_channels[AUDIO_SRAM_CHANNEL].fifo_size / 3;	//since there are 3 audio Clusters
+		bpl = cx25821_sram_channels[AUDIO_SRAM_CHANNEL].fifo_size / 3;
+		/*since there are 3 audio Clusters */
 		bpl &= ~7;	/* must be multiple of 8 */
 
-		if (bpl > AUDIO_LINE_SIZE) {
+		if (bpl > AUDIO_LINE_SIZE)
 			bpl = AUDIO_LINE_SIZE;
-		}
+
 		runtime->hw.period_bytes_min = bpl;
 		runtime->hw.period_bytes_max = bpl;
 	}
 
 	return 0;
-      _error:
+_error:
 	dprintk(1, "Error opening PCM!\n");
 	return err;
 }
@@ -445,9 +450,8 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	if (NULL == buf)
 		return -ENOMEM;
 
-	if (chip->period_size > AUDIO_LINE_SIZE) {
+	if (chip->period_size > AUDIO_LINE_SIZE)
 		chip->period_size = AUDIO_LINE_SIZE;
-	}
 
 	buf->vb.memory = V4L2_MEMORY_MMAP;
 	buf->vb.field = V4L2_FIELD_NONE;
@@ -473,8 +477,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	    cx25821_risc_databuffer_audio(chip->pci, &buf->risc, dma->sglist,
 					  buf->vb.width, buf->vb.height, 1);
 	if (ret < 0) {
-		printk(KERN_INFO
-		       "DEBUG: ERROR after cx25821_risc_databuffer_audio() \n");
+		printk(KERN_INFO "DEBUG: ERROR after cx25821_risc_databuffer_audio ()\n");
 		goto error;
 	}
 
@@ -494,7 +497,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 
 	return 0;
 
-      error:
+error:
 	kfree(buf);
 	return ret;
 }
@@ -593,10 +596,10 @@ static struct snd_pcm_ops snd_cx25821_pcm_ops = {
 };
 
 /*
- * ALSA create a PCM device:  Called when initializing the board. Sets up the name and hooks up
- *  the callbacks
+ * ALSA create a PCM device:  Called when initializing the board.
+ * Sets up the name and hooks up the callbacks
  */
-static int snd_cx25821_pcm(snd_cx25821_card_t * chip, int device, char *name)
+static int snd_cx25821_pcm(snd_cx25821_card_t *chip, int device, char *name)
 {
 	struct snd_pcm *pcm;
 	int err;
@@ -655,7 +658,7 @@ static void snd_cx25821_dev_free(struct snd_card *card)
 {
 	snd_cx25821_card_t *chip = card->private_data;
 
-	//snd_cx25821_free(chip);
+	/* snd_cx25821_free(chip); */
 	snd_card_free(chip->card);
 }
 
@@ -671,13 +674,13 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 	if (devno >= SNDRV_CARDS) {
 		printk(KERN_INFO "DEBUG ERROR: devno >= SNDRV_CARDS %s\n",
 		       __func__);
-		return (-ENODEV);
+		return -ENODEV;
 	}
 
 	if (!enable[devno]) {
 		++devno;
 		printk(KERN_INFO "DEBUG ERROR: !enable[devno] %s\n", __func__);
-		return (-ENOENT);
+		return -ENOENT;
 	}
 
 	err = snd_card_create(index[devno], id[devno], THIS_MODULE,
@@ -712,7 +715,8 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		goto error;
 	}
 
-	if ((err = snd_cx25821_pcm(chip, 0, "cx25821 Digital")) < 0) {
+	err = snd_cx25821_pcm(chip, 0, "cx25821 Digital");
+	if (err < 0) {
 		printk(KERN_INFO
 		       "DEBUG ERROR: cannot create snd_cx25821_pcm %s\n",
 		       __func__);
@@ -741,7 +745,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 	devno++;
 	return 0;
 
-      error:
+error:
 	snd_card_free(card);
 	return err;
 }
-- 
1.5.6.5

