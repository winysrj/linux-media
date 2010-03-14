Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.rdslink.ro ([81.196.12.70]:46971 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751262Ab0CNQUA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 12:20:00 -0400
Subject: 0844-Staging-cx25821-fix-coding-style-issues-in-cx25821-a.patch
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com,
	palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 14 Mar 2010 18:13:16 +0200
Message-ID: <1268583196.7043.8.camel@tuxtm-linux>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 9473816c446a6ca91905fc49a73732f70b5223b4 Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 14 Mar 2010 17:44:37 +0200
Subject: [PATCH 844/844] Staging: cx25821: fix coding style issues in cx25821-alsa.c
 This is a patch to the cx25821-alsa.c file that fixes up errors and warnings found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/cx25821/cx25821-alsa.c |  104 +++++++++++++++++---------------
 1 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index e0eef12..bb297ca 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -28,7 +28,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>

-#include <asm/delay.h>
+#include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -41,10 +41,10 @@

 #define AUDIO_SRAM_CHANNEL	SRAM_CH08

-#define dprintk(level,fmt, arg...)	if (debug >= level) \
+#define dprintk(level, fmt, arg...)	if (debug >= level) \
 	printk(KERN_INFO "%s/1: " fmt, chip->dev->name , ## arg)

-#define dprintk_core(level,fmt, arg...)	if (debug >= level) \
+#define dprintk_core(level, fmt, arg...)	if (debug >= level) \
 	printk(KERN_DEBUG "%s/1: " fmt, chip->dev->name , ## arg)

 /****************************************************************************
@@ -80,7 +80,6 @@ struct cx25821_audio_dev {

 	struct snd_pcm_substream *substream;
 };
-typedef struct cx25821_audio_dev snd_cx25821_card_t;


 /****************************************************************************
@@ -89,7 +88,7 @@ typedef struct cx25821_audio_dev snd_cx25821_card_t;

 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = { 1,[1 ... (SNDRV_CARDS - 1)] = 1 };
+static int enable[SNDRV_CARDS] = { 1, [1 ... (SNDRV_CARDS - 1)] = 1 };

 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable cx25821 soundcard. default enabled.");
@@ -104,7 +103,7 @@ MODULE_PARM_DESC(index, "Index value for cx25821 capture interface(s).");
 MODULE_DESCRIPTION("ALSA driver module for cx25821 based capture cards");
 MODULE_AUTHOR("Hiep Huynh");
 MODULE_LICENSE("GPL");
-MODULE_SUPPORTED_DEVICE("{{Conexant,25821}");	//"{{Conexant,23881},"
+MODULE_SUPPORTED_DEVICE("{{Conexant,25821}");	/* "{{Conexant,23881}," */

 static unsigned int debug;
 module_param(debug, int, 0644);
@@ -134,7 +133,7 @@ MODULE_PARM_DESC(debug, "enable debug messages");
  * BOARD Specific: Sets audio DMA
  */

-static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
+static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 {
 	struct cx25821_buffer *buf = chip->buf;
 	struct cx25821_dev *dev = chip->dev;
@@ -142,7 +141,7 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 	    &cx25821_sram_channels[AUDIO_SRAM_CHANNEL];
 	u32 tmp = 0;

-	// enable output on the GPIO 0 for the MCLK ADC (Audio)
+	/* enable output on the GPIO 0 for the MCLK ADC (Audio)*/
 	cx25821_set_gpiopin_direction(chip->dev, 0, 0);

 	/* Make sure RISC/FIFO are off before changing FIFO/RISC settings */
@@ -156,19 +155,24 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 	/* sets bpl size */
 	cx_write(AUD_A_LNGTH, buf->bpl);

-	/* reset counter */
-	cx_write(AUD_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);	//GP_COUNT_CONTROL_RESET = 0x3
+	/* reset counter
+	GP_COUNT_CONTROL_RESET = 0x3*/
+	cx_write(AUD_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);
 	atomic_set(&chip->count, 0);

-	//Set the input mode to 16-bit
+	/*Set the input mode to 16-bit*/
 	tmp = cx_read(AUD_A_CFG);
 	cx_write(AUD_A_CFG,
 		 tmp | FLD_AUD_DST_PK_MODE | FLD_AUD_DST_ENABLE |
 		 FLD_AUD_CLK_ENABLE);

-	//printk(KERN_INFO "DEBUG: Start audio DMA, %d B/line, cmds_start(0x%x)= %d lines/FIFO, %d periods, %d "
-	//      "byte buffer\n", buf->bpl, audio_ch->cmds_start, cx_read(audio_ch->cmds_start + 12)>>1,
-	//      chip->num_periods, buf->bpl * chip->num_periods);
+	/*printk(KERN_INFO "DEBUG: Start audio DMA, %d B/line,"
+				"cmds_start(0x%x)= %d lines/FIFO, %d periods, "
+				"%d byte buffer\n", buf->bpl,
+				audio_ch->cmds_start,
+				cx_read(audio_ch->cmds_start + 12)>>1,
+				chip->num_periods, buf->bpl *chip->num_periods);
+	*/

 	/* Enables corresponding bits at AUD_INT_STAT */
 	cx_write(AUD_A_INT_MSK,
@@ -181,7 +185,7 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 	/* enable audio irqs */
 	cx_set(PCI_INT_MSK, chip->dev->pci_irqmask | PCI_MSK_AUD_INT);

-	// Turn on audio downstream fifo and risc enable 0x101
+	/* Turn on audio downstream fifo and risc enable 0x101*/
 	tmp = cx_read(AUD_INT_DMA_CTL);
 	cx_set(AUD_INT_DMA_CTL,
 	       tmp | (FLD_AUD_DST_A_RISC_EN | FLD_AUD_DST_A_FIFO_EN));
@@ -193,7 +197,7 @@ static int _cx25821_start_audio_dma(snd_cx25821_card_t * chip)
 /*
  * BOARD Specific: Resets audio DMA
  */
-static int _cx25821_stop_audio_dma(snd_cx25821_card_t * chip)
+static int _cx25821_stop_audio_dma(struct cx25821_audio_dev *chip)
 {
 	struct cx25821_dev *dev = chip->dev;

@@ -231,13 +235,13 @@ static char *cx25821_aud_irqs[32] = {
 /*
  * BOARD Specific: Threats IRQ audio specific calls
  */
-static void cx25821_aud_irq(snd_cx25821_card_t * chip, u32 status, u32 mask)
+static void cx25821_aud_irq(struct cx25821_audio_dev *chip, u32 status,
+			    u32 mask)
 {
 	struct cx25821_dev *dev = chip->dev;

-	if (0 == (status & mask)) {
+	if (0 == (status & mask))
 		return;
-	}

 	cx_write(AUD_A_INT_STAT, status);
 	if (debug > 1 || (status & mask & ~0xff))
@@ -276,7 +280,7 @@ static void cx25821_aud_irq(snd_cx25821_card_t * chip, u32 status, u32 mask)
  */
 static irqreturn_t cx25821_irq(int irq, void *dev_id)
 {
-	snd_cx25821_card_t *chip = dev_id;
+	struct cx25821_audio_dev *chip = dev_id;
 	struct cx25821_dev *dev = chip->dev;
 	u32 status, pci_status;
 	u32 audint_status, audint_mask;
@@ -317,11 +321,11 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 	if (handled)
 		cx_write(PCI_INT_STAT, pci_status);

-      out:
+out:
 	return IRQ_RETVAL(handled);
 }

-static int dsp_buffer_free(snd_cx25821_card_t * chip)
+static int dsp_buffer_free(struct cx25821_audio_dev *chip)
 {
 	BUG_ON(!chip->dma_size);

@@ -362,7 +366,8 @@ static struct snd_pcm_hardware snd_cx25821_digital_hw = {
 	.period_bytes_max = DEFAULT_FIFO_SIZE / 3,
 	.periods_min = 1,
 	.periods_max = AUDIO_LINE_SIZE,
-	.buffer_bytes_max = (AUDIO_LINE_SIZE * AUDIO_LINE_SIZE),	//128*128 = 16384 = 1024 * 16
+	/*128*128 = 16384 = 1024 * 16*/
+	.buffer_bytes_max = (AUDIO_LINE_SIZE * AUDIO_LINE_SIZE),
 };

 /*
@@ -370,7 +375,7 @@ static struct snd_pcm_hardware snd_cx25821_digital_hw = {
  */
 static int snd_cx25821_pcm_open(struct snd_pcm_substream *substream)
 {
-	snd_cx25821_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int err;
 	unsigned int bpl = 0;
@@ -392,18 +397,19 @@ static int snd_cx25821_pcm_open(struct snd_pcm_substream *substream)

 	if (cx25821_sram_channels[AUDIO_SRAM_CHANNEL].fifo_size !=
 	    DEFAULT_FIFO_SIZE) {
-		bpl = cx25821_sram_channels[AUDIO_SRAM_CHANNEL].fifo_size / 3;	//since there are 3 audio Clusters
+		/*since there are 3 audio Clusters*/
+		bpl = cx25821_sram_channels[AUDIO_SRAM_CHANNEL].fifo_size / 3;
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
@@ -422,7 +428,7 @@ static int snd_cx25821_close(struct snd_pcm_substream *substream)
 static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *hw_params)
 {
-	snd_cx25821_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);
 	struct videobuf_dmabuf *dma;

 	struct cx25821_buffer *buf;
@@ -444,9 +450,8 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	if (NULL == buf)
 		return -ENOMEM;

-	if (chip->period_size > AUDIO_LINE_SIZE) {
+	if (chip->period_size > AUDIO_LINE_SIZE)
 		chip->period_size = AUDIO_LINE_SIZE;
-	}

 	buf->vb.memory = V4L2_MEMORY_MMAP;
 	buf->vb.field = V4L2_FIELD_NONE;
@@ -473,7 +478,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 					  buf->vb.width, buf->vb.height, 1);
 	if (ret < 0) {
 		printk(KERN_INFO
-		       "DEBUG: ERROR after cx25821_risc_databuffer_audio() \n");
+			"DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
 		goto error;
 	}

@@ -493,7 +498,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,

 	return 0;

-      error:
+error:
 	kfree(buf);
 	return ret;
 }
@@ -503,7 +508,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
  */
 static int snd_cx25821_hw_free(struct snd_pcm_substream *substream)
 {
-	snd_cx25821_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);

 	if (substream->runtime->dma_area) {
 		dsp_buffer_free(chip);
@@ -527,7 +532,7 @@ static int snd_cx25821_prepare(struct snd_pcm_substream *substream)
 static int snd_cx25821_card_trigger(struct snd_pcm_substream *substream,
 				    int cmd)
 {
-	snd_cx25821_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);
 	int err = 0;

 	/* Local interrupts are already disabled by ALSA */
@@ -556,7 +561,7 @@ static int snd_cx25821_card_trigger(struct snd_pcm_substream *substream,
 static snd_pcm_uframes_t snd_cx25821_pointer(struct snd_pcm_substream
 					     *substream)
 {
-	snd_cx25821_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	u16 count;

@@ -592,10 +597,11 @@ static struct snd_pcm_ops snd_cx25821_pcm_ops = {
 };

 /*
- * ALSA create a PCM device:  Called when initializing the board. Sets up the name and hooks up
- *  the callbacks
+ * ALSA create a PCM device:  Called when initializing the board.
+ * Sets up the name and hooks up the callbacks
  */
-static int snd_cx25821_pcm(snd_cx25821_card_t * chip, int device, char *name)
+static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
+			   char *name)
 {
 	struct snd_pcm *pcm;
 	int err;
@@ -635,7 +641,7 @@ MODULE_DEVICE_TABLE(pci, cx25821_audio_pci_tbl);
  * from the file.
  */
 /*
-static int snd_cx25821_free(snd_cx25821_card_t *chip)
+static int snd_cx25821_free(struct cx25821_audio_dev *chip)
 {
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
@@ -652,9 +658,9 @@ static int snd_cx25821_free(snd_cx25821_card_t *chip)
  */
 static void snd_cx25821_dev_free(struct snd_card *card)
 {
-	snd_cx25821_card_t *chip = card->private_data;
+	struct cx25821_audio_dev *chip = card->private_data;

-	//snd_cx25821_free(chip);
+	/*snd_cx25821_free(chip);*/
 	snd_card_free(chip->card);
 }

@@ -664,23 +670,23 @@ static void snd_cx25821_dev_free(struct snd_card *card)
 static int cx25821_audio_initdev(struct cx25821_dev *dev)
 {
 	struct snd_card *card;
-	snd_cx25821_card_t *chip;
+	struct cx25821_audio_dev *chip;
 	int err;

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
-			 sizeof(snd_cx25821_card_t), &card);
+			 sizeof(struct cx25821_audio_dev), &card);
 	if (err < 0) {
 		printk(KERN_INFO
 		       "DEBUG ERROR: cannot create snd_card_new in %s\n",
@@ -692,7 +698,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)

 	/* Card "creation" */
 	card->private_free = snd_cx25821_dev_free;
-	chip = (snd_cx25821_card_t *) card->private_data;
+	chip = (struct cx25821_audio_dev *) card->private_data;
 	spin_lock_init(&chip->reg_lock);

 	chip->dev = dev;
@@ -711,7 +717,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		goto error;
 	}

-	if ((err = snd_cx25821_pcm(chip, 0, "cx25821 Digital")) < 0) {
+	if ((err == snd_cx25821_pcm(chip, 0, "cx25821 Digital")) < 0) {
 		printk(KERN_INFO
 		       "DEBUG ERROR: cannot create snd_cx25821_pcm %s\n",
 		       __func__);
@@ -740,7 +746,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 	devno++;
 	return 0;

-      error:
+error:
 	snd_card_free(card);
 	return err;
 }
--
1.7.0

