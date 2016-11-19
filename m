Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45733 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbcKSV1q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 16:27:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: [PATCH v2] [media] cx88: make checkpatch.pl happy
Date: Sat, 19 Nov 2016 19:27:30 -0200
Message-Id: <451cfbe8b2a968992c49edac0fad57a6425caad6.1479590802.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usually, I don't like fixing coding style issues on non-staging
drivers, as it could be a mess pretty easy, and could become like
a snow ball. That's the case of recent changes on two changesets:
they disalign some statements. Yet, a care a lot with cx88 driver,
as it was the first driver I touched at the Kernel, and I've been
maintaining it since 2005. So, several of the coding style issues
were due to my code.

Per Andrey's suggestion, I ran checkpatch.pl in strict mode, with
fixed several other issues, did some function alinments, but broke
other alinments.

So, I had to manually apply another round of manual fixes to make
sure that everything is ok, and to make checkpatch happy with
this patch.

With this patch, checkpatch.pl is now happy when called with:
	./scripts/checkpatch.pl -f --max-line-length=998 --ignore PREFER_PR_LEVEL

Also, the 80-cols violations that made sense were fixed.

Checkpatch would be happier if we convert it to use dev_foo(),
but this is a more complex change.

NOTE: there are some places with msleep(1). As this driver was
written at the time that the default was to sleep at least 10ms
on such calls (e. g. CONFIG_HZ=100), I replaced those calls by
usleep_range(10000, 20000), with should be safe to avoid breakages.

Suggested-by: Andrey Utkin <andrey_utkin@fastmail.com>
Fixes: 65bc2fe86e66 ("[media] cx88: convert it to use pr_foo() macros")
Fixes: 7b61ba8ff838 ("[media] cx88: make checkpatch happier")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx88/cx88-alsa.c       | 206 ++++++++++----------
 drivers/media/pci/cx88/cx88-blackbird.c  | 169 ++++++++++-------
 drivers/media/pci/cx88/cx88-cards.c      | 313 +++++++++++++++++--------------
 drivers/media/pci/cx88/cx88-core.c       | 205 ++++++++++----------
 drivers/media/pci/cx88/cx88-dsp.c        |  50 +++--
 drivers/media/pci/cx88/cx88-dvb.c        | 154 +++++++--------
 drivers/media/pci/cx88/cx88-i2c.c        |  25 ++-
 drivers/media/pci/cx88/cx88-input.c      |  45 +++--
 drivers/media/pci/cx88/cx88-mpeg.c       | 114 +++++------
 drivers/media/pci/cx88/cx88-reg.h        | 110 +++++------
 drivers/media/pci/cx88/cx88-tvaudio.c    |  63 ++++---
 drivers/media/pci/cx88/cx88-vbi.c        |  19 +-
 drivers/media/pci/cx88/cx88-video.c      | 155 ++++++++-------
 drivers/media/pci/cx88/cx88-vp3054-i2c.c |  10 +-
 drivers/media/pci/cx88/cx88-vp3054-i2c.h |  38 ++--
 drivers/media/pci/cx88/cx88.h            | 165 ++++++++--------
 16 files changed, 972 insertions(+), 869 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 56770e84b3d5..c81fe4681d14 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -24,6 +24,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
@@ -31,7 +32,6 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
-#include <asm/delay.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -46,9 +46,9 @@
 			chip->core->name, ##arg);			\
 } while (0)
 
-/****************************************************************************
-	Data type declarations - Can be moded to a header file later
- ****************************************************************************/
+/*
+ * Data type declarations - Can be moded to a header file later
+ */
 
 struct cx88_audio_buffer {
 	unsigned int               bpl;
@@ -82,13 +82,10 @@ struct cx88_audio_dev {
 
 	struct snd_pcm_substream   *substream;
 };
-typedef struct cx88_audio_dev snd_cx88_card_t;
 
-
-
-/****************************************************************************
-			Module global static vars
- ****************************************************************************/
+/*
+ * Module global static vars
+ */
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static const char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
@@ -100,10 +97,9 @@ MODULE_PARM_DESC(enable, "Enable cx88x soundcard. default enabled.");
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for cx88x capture interface(s).");
 
-
-/****************************************************************************
-				Module macros
- ****************************************************************************/
+/*
+ * Module macros
+ */
 
 MODULE_DESCRIPTION("ALSA driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Ricardo Cerqueira");
@@ -116,15 +112,15 @@ static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
-/****************************************************************************
-			Module specific funtions
- ****************************************************************************/
+/*
+ * Module specific functions
+ */
 
 /*
  * BOARD Specific: Sets audio DMA
  */
 
-static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
+static int _cx88_start_audio_dma(struct cx88_audio_dev *chip)
 {
 	struct cx88_audio_buffer *buf = chip->buf;
 	struct cx88_core *core = chip->core;
@@ -143,8 +139,9 @@ static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 	cx_write(MO_AUDD_GPCNTRL, GP_COUNT_CONTROL_RESET);
 	atomic_set(&chip->count, 0);
 
-	dprintk(1, "Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d byte buffer\n",
-		buf->bpl, cx_read(audio_ch->cmds_start + 8)>>1,
+	dprintk(1,
+		"Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d byte buffer\n",
+		buf->bpl, cx_read(audio_ch->cmds_start + 8) >> 1,
 		chip->num_periods, buf->bpl * chip->num_periods);
 
 	/* Enables corresponding bits at AUD_INT_STAT */
@@ -158,8 +155,11 @@ static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 	cx_set(MO_PCI_INTMSK, chip->core->pci_irqmask | PCI_INT_AUDINT);
 
 	/* start dma */
-	cx_set(MO_DEV_CNTRL2, (1<<5)); /* Enables Risc Processor */
-	cx_set(MO_AUD_DMACNTRL, 0x11); /* audio downstream FIFO and RISC enable */
+
+	/* Enables Risc Processor */
+	cx_set(MO_DEV_CNTRL2, (1 << 5));
+	/* audio downstream FIFO and RISC enable */
+	cx_set(MO_AUD_DMACNTRL, 0x11);
 
 	if (debug)
 		cx88_sram_channel_dump(chip->core, audio_ch);
@@ -170,7 +170,7 @@ static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 /*
  * BOARD Specific: Resets audio DMA
  */
-static int _cx88_stop_audio_dma(snd_cx88_card_t *chip)
+static int _cx88_stop_audio_dma(struct cx88_audio_dev *chip)
 {
 	struct cx88_core *core = chip->core;
 
@@ -185,7 +185,8 @@ static int _cx88_stop_audio_dma(snd_cx88_card_t *chip)
 				AUD_INT_DN_RISCI2 | AUD_INT_DN_RISCI1);
 
 	if (debug)
-		cx88_sram_channel_dump(chip->core, &cx88_sram_channels[SRAM_CH25]);
+		cx88_sram_channel_dump(chip->core,
+				       &cx88_sram_channels[SRAM_CH25]);
 
 	return 0;
 }
@@ -211,7 +212,7 @@ static const char *cx88_aud_irqs[32] = {
 /*
  * BOARD Specific: Threats IRQ audio specific calls
  */
-static void cx8801_aud_irq(snd_cx88_card_t *chip)
+static void cx8801_aud_irq(struct cx88_audio_dev *chip)
 {
 	struct cx88_core *core = chip->core;
 	u32 status, mask;
@@ -249,7 +250,7 @@ static void cx8801_aud_irq(snd_cx88_card_t *chip)
  */
 static irqreturn_t cx8801_irq(int irq, void *dev_id)
 {
-	snd_cx88_card_t *chip = dev_id;
+	struct cx88_audio_dev *chip = dev_id;
 	struct cx88_core *core = chip->core;
 	u32 status;
 	int loop, handled = 0;
@@ -286,26 +287,25 @@ static int cx88_alsa_dma_init(struct cx88_audio_dev *chip, int nr_pages)
 	int i;
 
 	buf->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
-	if (buf->vaddr == NULL) {
+	if (!buf->vaddr) {
 		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
 		return -ENOMEM;
 	}
 
 	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
-				(unsigned long)buf->vaddr,
-				nr_pages << PAGE_SHIFT);
+		(unsigned long)buf->vaddr, nr_pages << PAGE_SHIFT);
 
 	memset(buf->vaddr, 0, nr_pages << PAGE_SHIFT);
 	buf->nr_pages = nr_pages;
 
 	buf->sglist = vzalloc(buf->nr_pages * sizeof(*buf->sglist));
-	if (buf->sglist == NULL)
+	if (!buf->sglist)
 		goto vzalloc_err;
 
 	sg_init_table(buf->sglist, buf->nr_pages);
 	for (i = 0; i < buf->nr_pages; i++) {
 		pg = vmalloc_to_page(buf->vaddr + i * PAGE_SIZE);
-		if (pg == NULL)
+		if (!pg)
 			goto vmalloc_to_page_err;
 		sg_set_page(&buf->sglist[i], pg, PAGE_SIZE, 0);
 	}
@@ -341,7 +341,8 @@ static int cx88_alsa_dma_unmap(struct cx88_audio_dev *dev)
 	if (!buf->sglen)
 		return 0;
 
-	dma_unmap_sg(&dev->pci->dev, buf->sglist, buf->sglen, PCI_DMA_FROMDEVICE);
+	dma_unmap_sg(&dev->pci->dev, buf->sglist, buf->sglen,
+		     PCI_DMA_FROMDEVICE);
 	buf->sglen = 0;
 	return 0;
 }
@@ -355,18 +356,18 @@ static int cx88_alsa_dma_free(struct cx88_audio_buffer *buf)
 	return 0;
 }
 
-
-static int dsp_buffer_free(snd_cx88_card_t *chip)
+static int dsp_buffer_free(struct cx88_audio_dev *chip)
 {
 	struct cx88_riscmem *risc = &chip->buf->risc;
 
-	BUG_ON(!chip->dma_size);
+	WARN_ON(!chip->dma_size);
 
 	dprintk(2, "Freeing buffer\n");
 	cx88_alsa_dma_unmap(chip);
 	cx88_alsa_dma_free(chip->buf);
 	if (risc->cpu)
-		pci_free_consistent(chip->pci, risc->size, risc->cpu, risc->dma);
+		pci_free_consistent(chip->pci, risc->size,
+				    risc->cpu, risc->dma);
 	kfree(chip->buf);
 
 	chip->buf = NULL;
@@ -374,9 +375,9 @@ static int dsp_buffer_free(snd_cx88_card_t *chip)
 	return 0;
 }
 
-/****************************************************************************
-				ALSA PCM Interface
- ****************************************************************************/
+/*
+ * ALSA PCM Interface
+ */
 
 /*
  * Digital hardware definition
@@ -394,13 +395,15 @@ static const struct snd_pcm_hardware snd_cx88_digital_hw = {
 	.rate_max =		48000,
 	.channels_min = 2,
 	.channels_max = 2,
-	/* Analog audio output will be full of clicks and pops if there
-	   are not exactly four lines in the SRAM FIFO buffer.  */
-	.period_bytes_min = DEFAULT_FIFO_SIZE/4,
-	.period_bytes_max = DEFAULT_FIFO_SIZE/4,
+	/*
+	 * Analog audio output will be full of clicks and pops if there
+	 * are not exactly four lines in the SRAM FIFO buffer.
+	 */
+	.period_bytes_min = DEFAULT_FIFO_SIZE / 4,
+	.period_bytes_max = DEFAULT_FIFO_SIZE / 4,
 	.periods_min = 1,
 	.periods_max = 1024,
-	.buffer_bytes_max = (1024*1024),
+	.buffer_bytes_max = (1024 * 1024),
 };
 
 /*
@@ -408,7 +411,7 @@ static const struct snd_pcm_hardware snd_cx88_digital_hw = {
  */
 static int snd_cx88_pcm_open(struct snd_pcm_substream *substream)
 {
-	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx88_audio_dev *chip = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int err;
 
@@ -417,7 +420,8 @@ static int snd_cx88_pcm_open(struct snd_pcm_substream *substream)
 		return -ENODEV;
 	}
 
-	err = snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_PERIODS);
+	err = snd_pcm_hw_constraint_pow2(runtime, 0,
+					 SNDRV_PCM_HW_PARAM_PERIODS);
 	if (err < 0)
 		goto _error;
 
@@ -453,7 +457,7 @@ static int snd_cx88_close(struct snd_pcm_substream *substream)
 static int snd_cx88_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_pcm_hw_params *hw_params)
 {
-	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx88_audio_dev *chip = snd_pcm_substream_chip(substream);
 
 	struct cx88_audio_buffer *buf;
 	int ret;
@@ -467,18 +471,18 @@ static int snd_cx88_hw_params(struct snd_pcm_substream *substream,
 	chip->num_periods = params_periods(hw_params);
 	chip->dma_size = chip->period_size * params_periods(hw_params);
 
-	BUG_ON(!chip->dma_size);
-	BUG_ON(chip->num_periods & (chip->num_periods-1));
+	WARN_ON(!chip->dma_size);
+	WARN_ON(chip->num_periods & (chip->num_periods - 1));
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
-	if (buf == NULL)
+	if (!buf)
 		return -ENOMEM;
 
 	chip->buf = buf;
 	buf->bpl = chip->period_size;
 
 	ret = cx88_alsa_dma_init(chip,
-			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
+				 (PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
@@ -492,7 +496,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream *substream,
 		goto error;
 
 	/* Loop back to start of program */
-	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP|RISC_IRQ1|RISC_CNT_INC);
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
 	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 
 	substream->runtime->dma_area = chip->buf->vaddr;
@@ -510,8 +514,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream *substream,
  */
 static int snd_cx88_hw_free(struct snd_pcm_substream *substream)
 {
-
-	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx88_audio_dev *chip = snd_pcm_substream_chip(substream);
 
 	if (substream->runtime->dma_area) {
 		dsp_buffer_free(chip);
@@ -534,7 +537,7 @@ static int snd_cx88_prepare(struct snd_pcm_substream *substream)
  */
 static int snd_cx88_card_trigger(struct snd_pcm_substream *substream, int cmd)
 {
-	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx88_audio_dev *chip = snd_pcm_substream_chip(substream);
 	int err;
 
 	/* Local interrupts are already disabled by ALSA */
@@ -562,7 +565,7 @@ static int snd_cx88_card_trigger(struct snd_pcm_substream *substream, int cmd)
  */
 static snd_pcm_uframes_t snd_cx88_pointer(struct snd_pcm_substream *substream)
 {
-	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
+	struct cx88_audio_dev *chip = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	u16 count;
 
@@ -571,14 +574,14 @@ static snd_pcm_uframes_t snd_cx88_pointer(struct snd_pcm_substream *substream)
 //	dprintk(2, "%s - count %d (+%u), period %d, frame %lu\n", __func__,
 //		count, new, count & (runtime->periods-1),
 //		runtime->period_size * (count & (runtime->periods-1)));
-	return runtime->period_size * (count & (runtime->periods-1));
+	return runtime->period_size * (count & (runtime->periods - 1));
 }
 
 /*
  * page callback (needed for mmap)
  */
 static struct page *snd_cx88_page(struct snd_pcm_substream *substream,
-				unsigned long offset)
+				  unsigned long offset)
 {
 	void *pageptr = substream->runtime->dma_area + offset;
 
@@ -603,7 +606,8 @@ static const struct snd_pcm_ops snd_cx88_pcm_ops = {
 /*
  * create a PCM device
  */
-static int snd_cx88_pcm(snd_cx88_card_t *chip, int device, const char *name)
+static int snd_cx88_pcm(struct cx88_audio_dev *chip, int device,
+			const char *name)
 {
 	int err;
 	struct snd_pcm *pcm;
@@ -618,9 +622,9 @@ static int snd_cx88_pcm(snd_cx88_card_t *chip, int device, const char *name)
 	return 0;
 }
 
-/****************************************************************************
-				CONTROL INTERFACE
- ****************************************************************************/
+/*
+ * CONTROL INTERFACE
+ */
 static int snd_cx88_volume_info(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_info *info)
 {
@@ -635,7 +639,7 @@ static int snd_cx88_volume_info(struct snd_kcontrol *kcontrol,
 static int snd_cx88_volume_get(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 	int vol = 0x3f - (cx_read(AUD_VOL_CTL) & 0x3f),
 	    bal = cx_read(AUD_BAL_CTL);
@@ -648,9 +652,9 @@ static int snd_cx88_volume_get(struct snd_kcontrol *kcontrol,
 }
 
 static void snd_cx88_wm8775_volume_put(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_value *value)
+				       struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 	int left = value->value.integer.value[0];
 	int right = value->value.integer.value[1];
@@ -672,7 +676,7 @@ static void snd_cx88_wm8775_volume_put(struct snd_kcontrol *kcontrol,
 static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 	int left, right, v, b;
 	int changed = 0;
@@ -722,7 +726,7 @@ static const struct snd_kcontrol_new snd_cx88_volume = {
 static int snd_cx88_switch_get(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 	u32 bit = kcontrol->private_value;
 
@@ -731,9 +735,9 @@ static int snd_cx88_switch_get(struct snd_kcontrol *kcontrol,
 }
 
 static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
-				       struct snd_ctl_elem_value *value)
+			       struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 	u32 bit = kcontrol->private_value;
 	int ret = 0;
@@ -745,8 +749,9 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 		vol ^= bit;
 		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
 		/* Pass mute onto any WM8775 */
-		if (core->sd_wm8775 && ((1<<6) == bit))
-			wm8775_s_ctrl(core, V4L2_CID_AUDIO_MUTE, 0 != (vol & bit));
+		if (core->sd_wm8775 && ((1 << 6) == bit))
+			wm8775_s_ctrl(core,
+				      V4L2_CID_AUDIO_MUTE, 0 != (vol & bit));
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -759,7 +764,7 @@ static const struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
-	.private_value = (1<<8),
+	.private_value = (1 << 8),
 };
 
 static const struct snd_kcontrol_new snd_cx88_source_switch = {
@@ -768,13 +773,13 @@ static const struct snd_kcontrol_new snd_cx88_source_switch = {
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
-	.private_value = (1<<6),
+	.private_value = (1 << 6),
 };
 
 static int snd_cx88_alc_get(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_value *value)
+			    struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 	s32 val;
 
@@ -784,9 +789,9 @@ static int snd_cx88_alc_get(struct snd_kcontrol *kcontrol,
 }
 
 static int snd_cx88_alc_put(struct snd_kcontrol *kcontrol,
-				       struct snd_ctl_elem_value *value)
+			    struct snd_ctl_elem_value *value)
 {
-	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
 
 	wm8775_s_ctrl(core, V4L2_CID_AUDIO_LOUDNESS,
@@ -802,9 +807,9 @@ static struct snd_kcontrol_new snd_cx88_alc_switch = {
 	.put = snd_cx88_alc_put,
 };
 
-/****************************************************************************
-			Basic Flow for Sound Devices
- ****************************************************************************/
+/*
+ * Basic Flow for Sound Devices
+ */
 
 /*
  * PCI ID Table - 14f1:8801 and 14f1:8811 means function 1: Audio
@@ -822,9 +827,8 @@ MODULE_DEVICE_TABLE(pci, cx88_audio_pci_tbl);
  * Chip-specific destructor
  */
 
-static int snd_cx88_free(snd_cx88_card_t *chip)
+static int snd_cx88_free(struct cx88_audio_dev *chip)
 {
-
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 
@@ -839,25 +843,24 @@ static int snd_cx88_free(snd_cx88_card_t *chip)
  */
 static void snd_cx88_dev_free(struct snd_card *card)
 {
-	snd_cx88_card_t *chip = card->private_data;
+	struct cx88_audio_dev *chip = card->private_data;
 
 	snd_cx88_free(chip);
 }
 
-
 /*
  * Alsa Constructor - Component probe
  */
 
 static int devno;
 static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
-			   snd_cx88_card_t **rchip,
+			   struct cx88_audio_dev **rchip,
 			   struct cx88_core **core_ptr)
 {
-	snd_cx88_card_t   *chip;
-	struct cx88_core  *core;
-	int               err;
-	unsigned char     pci_lat;
+	struct cx88_audio_dev	*chip;
+	struct cx88_core	*core;
+	int			err;
+	unsigned char		pci_lat;
 
 	*rchip = NULL;
 
@@ -870,7 +873,7 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 	chip = card->private_data;
 
 	core = cx88_core_get(pci);
-	if (core == NULL) {
+	if (!core) {
 		err = -EINVAL;
 		return err;
 	}
@@ -882,7 +885,6 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 		return err;
 	}
 
-
 	/* pci init */
 	chip->card = card;
 	chip->pci = pci;
@@ -896,17 +898,18 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 			  IRQF_SHARED, chip->core->name, chip);
 	if (err < 0) {
 		dprintk(0, "%s: can't get IRQ %d\n",
-		       chip->core->name, chip->pci->irq);
+			chip->core->name, chip->pci->irq);
 		return err;
 	}
 
 	/* print pci info */
 	pci_read_config_byte(pci, PCI_LATENCY_TIMER, &pci_lat);
 
-	dprintk(1, "ALSA %s/%i: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+	dprintk(1,
+		"ALSA %s/%i: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
 		core->name, devno,
-	       pci_name(pci), pci->revision, pci->irq,
-	       pci_lat, (unsigned long long)pci_resource_start(pci, 0));
+		pci_name(pci), pci->revision, pci->irq,
+		pci_lat, (unsigned long long)pci_resource_start(pci, 0));
 
 	chip->irq = pci->irq;
 	synchronize_irq(chip->irq);
@@ -920,10 +923,10 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 static int cx88_audio_initdev(struct pci_dev *pci,
 			      const struct pci_device_id *pci_id)
 {
-	struct snd_card  *card;
-	snd_cx88_card_t  *chip;
-	struct cx88_core *core = NULL;
-	int              err;
+	struct snd_card		*card;
+	struct cx88_audio_dev	*chip;
+	struct cx88_core	*core = NULL;
+	int			err;
 
 	if (devno >= SNDRV_CARDS)
 		return (-ENODEV);
@@ -934,7 +937,7 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 	}
 
 	err = snd_card_new(&pci->dev, index[devno], id[devno], THIS_MODULE,
-			   sizeof(snd_cx88_card_t), &card);
+			   sizeof(struct cx88_audio_dev), &card);
 	if (err < 0)
 		return err;
 
@@ -970,7 +973,7 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 	strcpy(card->mixername, "CX88");
 
 	dprintk(0, "%s/%i: ALSA support for cx2388x boards\n",
-	       card->driver, devno);
+		card->driver, devno);
 
 	err = snd_card_register(card);
 	if (err < 0)
@@ -984,6 +987,7 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 	snd_card_free(card);
 	return err;
 }
+
 /*
  * ALSA destructor
  */
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index bffd064daff5..aa49c9597d9c 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -66,6 +66,7 @@ enum blackbird_capture_type {
 	BLACKBIRD_RAW_CAPTURE,
 	BLACKBIRD_RAW_PASSTHRU_CAPTURE
 };
+
 enum blackbird_capture_bits {
 	BLACKBIRD_RAW_BITS_NONE             = 0x00,
 	BLACKBIRD_RAW_BITS_YUV_CAPTURE      = 0x01,
@@ -74,33 +75,40 @@ enum blackbird_capture_bits {
 	BLACKBIRD_RAW_BITS_PASSTHRU_CAPTURE = 0x08,
 	BLACKBIRD_RAW_BITS_TO_HOST_CAPTURE  = 0x10
 };
+
 enum blackbird_capture_end {
 	BLACKBIRD_END_AT_GOP, /* stop at the end of gop, generate irq */
 	BLACKBIRD_END_NOW, /* stop immediately, no irq */
 };
+
 enum blackbird_framerate {
 	BLACKBIRD_FRAMERATE_NTSC_30, /* NTSC: 30fps */
 	BLACKBIRD_FRAMERATE_PAL_25   /* PAL: 25fps */
 };
+
 enum blackbird_stream_port {
 	BLACKBIRD_OUTPUT_PORT_MEMORY,
 	BLACKBIRD_OUTPUT_PORT_STREAMING,
 	BLACKBIRD_OUTPUT_PORT_SERIAL
 };
+
 enum blackbird_data_xfer_status {
 	BLACKBIRD_MORE_BUFFERS_FOLLOW,
 	BLACKBIRD_LAST_BUFFER,
 };
+
 enum blackbird_picture_mask {
 	BLACKBIRD_PICTURE_MASK_NONE,
 	BLACKBIRD_PICTURE_MASK_I_FRAMES,
 	BLACKBIRD_PICTURE_MASK_I_P_FRAMES = 0x3,
 	BLACKBIRD_PICTURE_MASK_ALL_FRAMES = 0x7,
 };
+
 enum blackbird_vbi_mode_bits {
 	BLACKBIRD_VBI_BITS_SLICED,
 	BLACKBIRD_VBI_BITS_RAW,
 };
+
 enum blackbird_vbi_insertion_bits {
 	BLACKBIRD_VBI_BITS_INSERT_IN_XTENSION_USR_DATA,
 	BLACKBIRD_VBI_BITS_INSERT_IN_PRIVATE_PACKETS = 0x1 << 1,
@@ -108,56 +116,69 @@ enum blackbird_vbi_insertion_bits {
 	BLACKBIRD_VBI_BITS_SEPARATE_STREAM_USR_DATA = 0x4 << 1,
 	BLACKBIRD_VBI_BITS_SEPARATE_STREAM_PRV_DATA = 0x5 << 1,
 };
+
 enum blackbird_dma_unit {
 	BLACKBIRD_DMA_BYTES,
 	BLACKBIRD_DMA_FRAMES,
 };
+
 enum blackbird_dma_transfer_status_bits {
 	BLACKBIRD_DMA_TRANSFER_BITS_DONE = 0x01,
 	BLACKBIRD_DMA_TRANSFER_BITS_ERROR = 0x04,
 	BLACKBIRD_DMA_TRANSFER_BITS_LL_ERROR = 0x10,
 };
+
 enum blackbird_pause {
 	BLACKBIRD_PAUSE_ENCODING,
 	BLACKBIRD_RESUME_ENCODING,
 };
+
 enum blackbird_copyright {
 	BLACKBIRD_COPYRIGHT_OFF,
 	BLACKBIRD_COPYRIGHT_ON,
 };
+
 enum blackbird_notification_type {
 	BLACKBIRD_NOTIFICATION_REFRESH,
 };
+
 enum blackbird_notification_status {
 	BLACKBIRD_NOTIFICATION_OFF,
 	BLACKBIRD_NOTIFICATION_ON,
 };
+
 enum blackbird_notification_mailbox {
 	BLACKBIRD_NOTIFICATION_NO_MAILBOX = -1,
 };
+
 enum blackbird_field1_lines {
 	BLACKBIRD_FIELD1_SAA7114 = 0x00EF, /* 239 */
 	BLACKBIRD_FIELD1_SAA7115 = 0x00F0, /* 240 */
 	BLACKBIRD_FIELD1_MICRONAS = 0x0105, /* 261 */
 };
+
 enum blackbird_field2_lines {
 	BLACKBIRD_FIELD2_SAA7114 = 0x00EF, /* 239 */
 	BLACKBIRD_FIELD2_SAA7115 = 0x00F0, /* 240 */
 	BLACKBIRD_FIELD2_MICRONAS = 0x0106, /* 262 */
 };
+
 enum blackbird_custom_data_type {
 	BLACKBIRD_CUSTOM_EXTENSION_USR_DATA,
 	BLACKBIRD_CUSTOM_PRIVATE_PACKET,
 };
+
 enum blackbird_mute {
 	BLACKBIRD_UNMUTE,
 	BLACKBIRD_MUTE,
 };
+
 enum blackbird_mute_video_mask {
 	BLACKBIRD_MUTE_VIDEO_V_MASK = 0x0000FF00,
 	BLACKBIRD_MUTE_VIDEO_U_MASK = 0x00FF0000,
 	BLACKBIRD_MUTE_VIDEO_Y_MASK = 0xFF000000,
 };
+
 enum blackbird_mute_video_shift {
 	BLACKBIRD_MUTE_VIDEO_V_SHIFT = 8,
 	BLACKBIRD_MUTE_VIDEO_U_SHIFT = 16,
@@ -281,7 +302,6 @@ static int register_write(struct cx88_core *core, u32 address, u32 value)
 	return wait_ready_gpio0_bit1(core, 1);
 }
 
-
 static int register_read(struct cx88_core *core, u32 address, u32 *value)
 {
 	int retval;
@@ -304,7 +324,8 @@ static int register_read(struct cx88_core *core, u32 address, u32 *value)
 
 /* ------------------------------------------------------------------ */
 
-static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 data[CX2341X_MBOX_MAX_DATA])
+static int blackbird_mbox_func(void *priv, u32 command, int in,
+			       int out, u32 data[CX2341X_MBOX_MAX_DATA])
 {
 	struct cx8802_dev *dev = priv;
 	unsigned long timeout;
@@ -313,11 +334,14 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 
 	dprintk(1, "%s: 0x%X\n", __func__, command);
 
-	/* this may not be 100% safe if we can't read any memory location
-	   without side effects */
+	/*
+	 * this may not be 100% safe if we can't read any memory location
+	 * without side effects
+	 */
 	memory_read(dev->core, dev->mailbox - 4, &value);
 	if (value != 0x12345678) {
-		dprintk(0, "Firmware and/or mailbox pointer not initialized or corrupted\n");
+		dprintk(0,
+			"Firmware and/or mailbox pointer not initialized or corrupted\n");
 		return -EIO;
 	}
 
@@ -332,7 +356,8 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 
 	/* write command + args + fill remaining with zeros */
 	memory_write(dev->core, dev->mailbox + 1, command); /* command code */
-	memory_write(dev->core, dev->mailbox + 3, IVTV_API_STD_TIMEOUT); /* timeout */
+	/* timeout */
+	memory_write(dev->core, dev->mailbox + 3, IVTV_API_STD_TIMEOUT);
 	for (i = 0; i < in; i++) {
 		memory_write(dev->core, dev->mailbox + 4 + i, data[i]);
 		dprintk(1, "API Input %d = %d\n", i, data[i]);
@@ -369,9 +394,13 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 	memory_write(dev->core, dev->mailbox, flag);
 	return retval;
 }
+
 /* ------------------------------------------------------------------ */
 
-/* We don't need to call the API often, so using just one mailbox will probably suffice */
+/*
+ * We don't need to call the API often, so using just one mailbox
+ * will probably suffice
+ */
 static int blackbird_api_cmd(struct cx8802_dev *dev, u32 command,
 			     u32 inputcnt, u32 outputcnt, ...)
 {
@@ -381,9 +410,9 @@ static int blackbird_api_cmd(struct cx8802_dev *dev, u32 command,
 
 	va_start(vargs, outputcnt);
 
-	for (i = 0; i < inputcnt; i++) {
+	for (i = 0; i < inputcnt; i++)
 		data[i] = va_arg(vargs, int);
-	}
+
 	err = blackbird_mbox_func(dev, command, inputcnt, outputcnt, data);
 	for (i = 0; i < outputcnt; i++) {
 		int *vptr = va_arg(vargs, int *);
@@ -408,7 +437,7 @@ static int blackbird_find_mailbox(struct cx8802_dev *dev)
 			signaturecnt = 0;
 		if (signaturecnt == 4) {
 			dprintk(1, "Mailbox signature found\n");
-			return i+1;
+			return i + 1;
 		}
 	}
 	dprintk(0, "Mailbox signature values not found!\n");
@@ -427,10 +456,13 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 	__le32 *dataptr;
 
 	retval  = register_write(dev->core, IVTV_REG_VPU, 0xFFFFFFED);
-	retval |= register_write(dev->core, IVTV_REG_HW_BLOCKS, IVTV_CMD_HW_BLOCKS_RST);
-	retval |= register_write(dev->core, IVTV_REG_ENC_SDRAM_REFRESH, 0x80000640);
-	retval |= register_write(dev->core, IVTV_REG_ENC_SDRAM_PRECHARGE, 0x1A);
-	msleep(1);
+	retval |= register_write(dev->core, IVTV_REG_HW_BLOCKS,
+				 IVTV_CMD_HW_BLOCKS_RST);
+	retval |= register_write(dev->core, IVTV_REG_ENC_SDRAM_REFRESH,
+				 0x80000640);
+	retval |= register_write(dev->core, IVTV_REG_ENC_SDRAM_PRECHARGE,
+				 0x1A);
+	usleep_range(10000, 20000);
 	retval |= register_write(dev->core, IVTV_REG_APU, 0);
 
 	if (retval < 0)
@@ -439,7 +471,6 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 	retval = request_firmware(&firmware, CX2341X_FIRM_ENC_FILENAME,
 				  &dev->pci->dev);
 
-
 	if (retval != 0) {
 		pr_err("Hotplug firmware request failed (%s).\n",
 		       CX2341X_FIRM_ENC_FILENAME);
@@ -482,10 +513,11 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 	}
 	dprintk(0, "Firmware upload successful.\n");
 
-	retval |= register_write(dev->core, IVTV_REG_HW_BLOCKS, IVTV_CMD_HW_BLOCKS_RST);
+	retval |= register_write(dev->core, IVTV_REG_HW_BLOCKS,
+				 IVTV_CMD_HW_BLOCKS_RST);
 	retval |= register_read(dev->core, IVTV_REG_SPU, &value);
 	retval |= register_write(dev->core, IVTV_REG_SPU, value & 0xFFFFFFFE);
-	msleep(1);
+	usleep_range(10000, 20000);
 
 	retval |= register_read(dev->core, IVTV_REG_VPU, &value);
 	retval |= register_write(dev->core, IVTV_REG_VPU, value & 0xFFFFFFE8);
@@ -495,19 +527,19 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 	return 0;
 }
 
-/**
- Settings used by the windows tv app for PVR2000:
-=================================================================================================================
-Profile | Codec | Resolution | CBR/VBR | Video Qlty   | V. Bitrate | Frmrate | Audio Codec | A. Bitrate | A. Mode
------------------------------------------------------------------------------------------------------------------
-MPEG-1  | MPEG1 | 352x288PAL | (CBR)   | 1000:Optimal | 2000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
-MPEG-2  | MPEG2 | 720x576PAL | VBR     | 600 :Good    | 4000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
-VCD     | MPEG1 | 352x288PAL | (CBR)   | 1000:Optimal | 1150 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
-DVD     | MPEG2 | 720x576PAL | VBR     | 600 :Good    | 6000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
-DB* DVD | MPEG2 | 720x576PAL | CBR     | 600 :Good    | 6000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
-=================================================================================================================
-*DB: "DirectBurn"
-*/
+/*
+ * Settings used by the windows tv app for PVR2000:
+ * =================================================================================================================
+ * Profile | Codec | Resolution | CBR/VBR | Video Qlty   | V. Bitrate | Frmrate | Audio Codec | A. Bitrate | A. Mode
+ * -----------------------------------------------------------------------------------------------------------------
+ * MPEG-1  | MPEG1 | 352x288PAL | (CBR)   | 1000:Optimal | 2000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
+ * MPEG-2  | MPEG2 | 720x576PAL | VBR     | 600 :Good    | 4000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
+ * VCD     | MPEG1 | 352x288PAL | (CBR)   | 1000:Optimal | 1150 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
+ * DVD     | MPEG2 | 720x576PAL | VBR     | 600 :Good    | 6000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
+ * DB* DVD | MPEG2 | 720x576PAL | CBR     | 600 :Good    | 6000 Kbps  | 25fps   | MPG1 Layer2 | 224kbps    | Stereo
+ * =================================================================================================================
+ * [*] DB: "DirectBurn"
+ */
 
 static void blackbird_codec_settings(struct cx8802_dev *dev)
 {
@@ -515,11 +547,12 @@ static void blackbird_codec_settings(struct cx8802_dev *dev)
 
 	/* assign frame size */
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
-				core->height, core->width);
+			  core->height, core->width);
 
 	dev->cxhdl.width = core->width;
 	dev->cxhdl.height = core->height;
-	cx2341x_handler_set_50hz(&dev->cxhdl, dev->core->tvnorm & V4L2_STD_625_50);
+	cx2341x_handler_set_50hz(&dev->cxhdl,
+				 dev->core->tvnorm & V4L2_STD_625_50);
 	cx2341x_handler_setup(&dev->cxhdl);
 }
 
@@ -545,15 +578,18 @@ static int blackbird_initialize_codec(struct cx8802_dev *dev)
 
 		dev->mailbox = retval;
 
-		retval = blackbird_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0); /* ping */
+		/* ping */
+		retval = blackbird_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
 			dprintk(0, "ERROR: Firmware ping failed!\n");
 			return -1;
 		}
 
-		retval = blackbird_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1, &version);
+		retval = blackbird_api_cmd(dev, CX2341X_ENC_GET_VERSION,
+					   0, 1, &version);
 		if (retval < 0) {
-			dprintk(0, "ERROR: Firmware get encoder version failed!\n");
+			dprintk(0,
+				"ERROR: Firmware get encoder version failed!\n");
 			return -1;
 		}
 		dprintk(0, "Firmware version is 0x%08x\n", version);
@@ -567,13 +603,11 @@ static int blackbird_initialize_codec(struct cx8802_dev *dev)
 	blackbird_codec_settings(dev);
 
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_NUM_VSYNC_LINES, 2, 0,
-			BLACKBIRD_FIELD1_SAA7115,
-			BLACKBIRD_FIELD2_SAA7115
-		);
+			  BLACKBIRD_FIELD1_SAA7115, BLACKBIRD_FIELD2_SAA7115);
 
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_PLACEHOLDER, 12, 0,
-			BLACKBIRD_CUSTOM_EXTENSION_USR_DATA,
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
+			  BLACKBIRD_CUSTOM_EXTENSION_USR_DATA,
+			  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
 
 	return 0;
 }
@@ -611,9 +645,7 @@ static int blackbird_start_codec(struct cx8802_dev *dev)
 
 	/* start capturing to the host interface */
 	blackbird_api_cmd(dev, CX2341X_ENC_START_CAPTURE, 2, 0,
-			BLACKBIRD_MPEG_CAPTURE,
-			BLACKBIRD_RAW_BITS_NONE
-		);
+			  BLACKBIRD_MPEG_CAPTURE, BLACKBIRD_RAW_BITS_NONE);
 
 	return 0;
 }
@@ -621,10 +653,9 @@ static int blackbird_start_codec(struct cx8802_dev *dev)
 static int blackbird_stop_codec(struct cx8802_dev *dev)
 {
 	blackbird_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
-			BLACKBIRD_END_NOW,
-			BLACKBIRD_MPEG_CAPTURE,
-			BLACKBIRD_RAW_BITS_NONE
-		);
+			  BLACKBIRD_END_NOW,
+			  BLACKBIRD_MPEG_CAPTURE,
+			  BLACKBIRD_RAW_BITS_NONE);
 
 	cx2341x_handler_set_busy(&dev->cxhdl, 0);
 
@@ -634,8 +665,8 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 /* ------------------------------------------------------------------ */
 
 static int queue_setup(struct vb2_queue *q,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], struct device *alloc_devs[])
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8802_dev *dev = q->drv_priv;
 
@@ -695,7 +726,8 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 
 	err = drv->request_acquire(drv);
 	if (err != 0) {
-		dprintk(1, "%s: Unable to acquire hardware, %d\n", __func__, err);
+		dprintk(1, "%s: Unable to acquire hardware, %d\n", __func__,
+			err);
 		goto fail;
 	}
 
@@ -766,7 +798,7 @@ static const struct vb2_ops blackbird_qops = {
 /* ------------------------------------------------------------------ */
 
 static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *cap)
+			   struct v4l2_capability *cap)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -778,7 +810,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 }
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
-					struct v4l2_fmtdesc *f)
+				   struct v4l2_fmtdesc *f)
 {
 	if (f->index != 0)
 		return -EINVAL;
@@ -790,7 +822,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 }
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-					struct v4l2_format *f)
+				struct v4l2_format *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -806,7 +838,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-			struct v4l2_format *f)
+				  struct v4l2_format *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -846,7 +878,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-					struct v4l2_format *f)
+				struct v4l2_format *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core  *core = dev->core;
@@ -860,14 +892,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	core->width = f->fmt.pix.width;
 	core->height = f->fmt.pix.height;
 	core->field = f->fmt.pix.field;
-	cx88_set_scale(core, f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
+	cx88_set_scale(core, f->fmt.pix.width, f->fmt.pix.height,
+		       f->fmt.pix.field);
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
-				f->fmt.pix.height, f->fmt.pix.width);
+			  f->fmt.pix.height, f->fmt.pix.width);
 	return 0;
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				const struct v4l2_frequency *f)
+			      const struct v4l2_frequency *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -883,8 +916,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	cx88_set_freq(core, f);
 	blackbird_initialize_codec(dev);
-	cx88_set_scale(core, core->width, core->height,
-			core->field);
+	cx88_set_scale(core, core->width, core->height, core->field);
 	if (streaming)
 		blackbird_start_codec(dev);
 	return 0;
@@ -903,7 +935,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 }
 
 static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *i)
+			     struct v4l2_input *i)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -912,7 +944,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+			      struct v4l2_frequency *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -944,7 +976,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 	if (i >= 4)
 		return -EINVAL;
-	if (0 == INPUT(i).type)
+	if (!INPUT(i).type)
 		return -EINVAL;
 
 	cx88_newstation(core);
@@ -953,7 +985,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+			  struct v4l2_tuner *t)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -971,12 +1003,12 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 	cx88_get_stereo(core, t);
 	reg = cx_read(MO_DEVICE_STATUS);
-	t->signal = (reg & (1<<5)) ? 0xffff : 0x0000;
+	t->signal = (reg & (1 << 5)) ? 0xffff : 0x0000;
 	return 0;
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				const struct v4l2_tuner *t)
+			  const struct v4l2_tuner *t)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -1008,7 +1040,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 }
 
 static const struct v4l2_file_operations mpeg_fops = {
-
 	.owner	       = THIS_MODULE,
 	.open	       = v4l2_fh_open,
 	.release       = vb2_fop_release,
@@ -1061,7 +1092,9 @@ static int cx8802_blackbird_advise_acquire(struct cx8802_driver *drv)
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
-		/* By default, core setup will leave the cx22702 out of reset, on the bus.
+		/*
+		 * By default, core setup will leave the cx22702 out of reset,
+		 * on the bus.
 		 * We left the hardware on power up with the cx22702 active.
 		 * We're being given access to re-arrange the GPIOs.
 		 * Take the bus off the cx22702 and put the cx23416 on it.
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 269179142cd8..cdfbde277b8b 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -51,7 +51,6 @@ MODULE_PARM_DESC(disable_ir, "Disable IR support");
 			__func__, ##arg);				\
 } while (0)
 
-
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
 
@@ -278,7 +277,6 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio2  = 0x0035e700,
 			.gpio3  = 0x02000000,
 		}, {
-
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x0035c700,
@@ -492,22 +490,22 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		/*
-		   GPIO[0] resets DT3302 DTV receiver
-		    0 - reset asserted
-		    1 - normal operation
-		   GPIO[1] mutes analog audio output connector
-		    0 - enable selected source
-		    1 - mute
-		   GPIO[2] selects source for analog audio output connector
-		    0 - analog audio input connector on tab
-		    1 - analog DAC output from CX23881 chip
-		   GPIO[3] selects RF input connector on tuner module
-		    0 - RF connector labeled CABLE
-		    1 - RF connector labeled ANT
-		   GPIO[4] selects high RF for QAM256 mode
-		    0 - normal RF
-		    1 - high RF
-		*/
+		 * GPIO[0] resets DT3302 DTV receiver
+		 *     0 - reset asserted
+		 *     1 - normal operation
+		 * GPIO[1] mutes analog audio output connector
+		 *     0 - enable selected source
+		 *     1 - mute
+		 * GPIO[2] selects source for analog audio output connector
+		 *     0 - analog audio input connector on tab
+		 *     1 - analog DAC output from CX23881 chip
+		 * GPIO[3] selects RF input connector on tuner module
+		 *     0 - RF connector labeled CABLE
+		 *     1 - RF connector labeled ANT
+		 * GPIO[4] selects high RF for QAM256 mode
+		 *     0 - normal RF
+		 *     1 - high RF
+		 */
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -730,7 +728,10 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		/* Some variants use a tda9874 and so need the tvaudio module. */
+		/*
+		 * Some variants use a tda9874 and so need the
+		 * tvaudio module.
+		 */
 		.audio_chip     = CX88_AUDIO_TVAUDIO,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
@@ -1196,8 +1197,10 @@ static const struct cx88_board cx88_boards[] = {
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_KWORLD_MCE200_DELUXE] = {
-		/* FIXME: tested TV input only, disabled composite,
-		   svideo and radio until they can be tested also. */
+		/*
+		 * FIXME: tested TV input only, disabled composite,
+		 * svideo and radio until they can be tested also.
+		 */
 		.name           = "Kworld MCE 200 Deluxe",
 		.tuner_type     = TUNER_TENA_9533_DI,
 		.radio_type     = UNSET,
@@ -1708,16 +1711,24 @@ static const struct cx88_board cx88_boards[] = {
 		},
 	},
 	[CX88_BOARD_POWERCOLOR_REAL_ANGEL] = {
-		.name           = "PowerColor RA330",	/* Long names may confuse LIRC. */
+		/* Long names may confuse LIRC. */
+		.name           = "PowerColor RA330",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
 		.input          = { {
+			/*
+			 * Due to the way the cx88 driver is written,
+			 * there is no way to deactivate audio pass-
+			 * through without this entry. Furthermore, if
+			 * the TV mux entry is first, you get audio
+			 * from the tuner on boot for a little while.
+			 */
 			.type   = CX88_VMUX_DEBUG,
-			.vmux   = 3,		/* Due to the way the cx88 driver is written,	*/
-			.gpio0 = 0x00ff,	/* there is no way to deactivate audio pass-	*/
-			.gpio1 = 0xf39d,	/* through without this entry. Furthermore, if	*/
-			.gpio3 = 0x0000,	/* the TV mux entry is first, you get audio	*/
-		}, {				/* from the tuner on boot for a little while.	*/
+			.vmux   = 3,
+			.gpio0 = 0x00ff,
+			.gpio1 = 0xf39d,
+			.gpio3 = 0x0000,
+		}, {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0 = 0x00ff,
@@ -1870,11 +1881,12 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio2 = 0x0cf7,
 		},
 	},
-	/* Both radio, analog and ATSC work with this board.
-	   However, for analog to work, s5h1409 gate should be open,
-	   otherwise, tuner-xc3028 won't be detected.
-	   A proper fix require using the newer i2c methods to add
-	   tuner-xc3028 without doing an i2c probe.
+	/*
+	 * Both radio, analog and ATSC work with this board.
+	 * However, for analog to work, s5h1409 gate should be open,
+	 * otherwise, tuner-xc3028 won't be detected.
+	 * A proper fix require using the newer i2c methods to add
+	 * tuner-xc3028 without doing an i2c probe.
 	 */
 	[CX88_BOARD_KWORLD_ATSC_120] = {
 		.name           = "Kworld PlusTV HD PCI 120 (ATSC 120)",
@@ -2808,9 +2820,9 @@ static const struct cx88_subid cx88_subids[] = {
 	},
 };
 
-/* ----------------------------------------------------------------------- */
-/* some leadtek specific stuff                                             */
-
+/*
+ * some leadtek specific stuff
+ */
 static void leadtek_eeprom(struct cx88_core *core, u8 *eeprom_data)
 {
 	if (eeprom_data[4] != 0x7d ||
@@ -2849,8 +2861,7 @@ static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
 	core->model = tv.model;
 
 	/* Make sure we support the board model */
-	switch (tv.model)
-	{
+	switch (tv.model) {
 	case 14009: /* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in) */
 	case 14019: /* WinTV-HVR3000 (Retail, IR Blaster, b/panel video, 3.5mm audio in) */
 	case 14029: /* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in - 880 bridge) */
@@ -2898,8 +2909,9 @@ static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
 	pr_info("hauppauge eeprom: model=%d\n", tv.model);
 }
 
-/* ----------------------------------------------------------------------- */
-/* some GDI (was: Modular Technology) specific stuff                       */
+/*
+ * some GDI (was: Modular Technology) specific stuff
+ */
 
 static const struct {
 	int  id;
@@ -2907,33 +2919,33 @@ static const struct {
 	const char *name;
 } gdi_tuner[] = {
 	[0x01] = { .id   = UNSET,
-		     .name = "NTSC_M" },
+		   .name = "NTSC_M" },
 	[0x02] = { .id   = UNSET,
-		     .name = "PAL_B" },
+		   .name = "PAL_B" },
 	[0x03] = { .id   = UNSET,
-		     .name = "PAL_I" },
+		   .name = "PAL_I" },
 	[0x04] = { .id   = UNSET,
-		     .name = "PAL_D" },
+		   .name = "PAL_D" },
 	[0x05] = { .id   = UNSET,
-		     .name = "SECAM" },
+		   .name = "SECAM" },
 
 	[0x10] = { .id   = UNSET,
-		     .fm   = 1,
-		     .name = "TEMIC_4049" },
+		   .fm   = 1,
+		   .name = "TEMIC_4049" },
 	[0x11] = { .id   = TUNER_TEMIC_4136FY5,
-		     .name = "TEMIC_4136" },
+		   .name = "TEMIC_4136" },
 	[0x12] = { .id   = UNSET,
-		     .name = "TEMIC_4146" },
+		   .name = "TEMIC_4146" },
 
 	[0x20] = { .id   = TUNER_PHILIPS_FQ1216ME,
-		     .fm   = 1,
-		     .name = "PHILIPS_FQ1216_MK3" },
+		   .fm   = 1,
+		   .name = "PHILIPS_FQ1216_MK3" },
 	[0x21] = { .id   = UNSET, .fm = 1,
-		     .name = "PHILIPS_FQ1236_MK3" },
+		   .name = "PHILIPS_FQ1236_MK3" },
 	[0x22] = { .id   = UNSET,
-		     .name = "PHILIPS_FI1236_MK3" },
+		   .name = "PHILIPS_FI1236_MK3" },
 	[0x23] = { .id   = UNSET,
-		     .name = "PHILIPS_FI1216_MK3" },
+		   .name = "PHILIPS_FI1216_MK3" },
 };
 
 static void gdi_eeprom(struct cx88_core *core, u8 *eeprom_data)
@@ -2942,15 +2954,16 @@ static void gdi_eeprom(struct cx88_core *core, u8 *eeprom_data)
 		? gdi_tuner[eeprom_data[0x0d]].name : NULL;
 
 	pr_info("GDI: tuner=%s\n", name ? name : "unknown");
-	if (name == NULL)
+	if (!name)
 		return;
 	core->board.tuner_type = gdi_tuner[eeprom_data[0x0d]].id;
 	core->board.radio.type = gdi_tuner[eeprom_data[0x0d]].fm ?
 		CX88_RADIO : 0;
 }
 
-/* ------------------------------------------------------------------- */
-/* some Divco specific stuff                                           */
+/*
+ * some Divco specific stuff
+ */
 static int cx88_dvico_xc2028_callback(struct cx88_core *core,
 				      int command, int arg)
 {
@@ -2979,9 +2992,9 @@ static int cx88_dvico_xc2028_callback(struct cx88_core *core,
 	return 0;
 }
 
-
-/* ----------------------------------------------------------------------- */
-/* some Geniatech specific stuff                                           */
+/*
+ * some Geniatech specific stuff
+ */
 
 static int cx88_xc3028_geniatech_tuner_callback(struct cx88_core *core,
 						int command, int mode)
@@ -3044,8 +3057,9 @@ static int cx88_xc4000_winfast2000h_plus_callback(struct cx88_core *core,
 	return -EINVAL;
 }
 
-/* ------------------------------------------------------------------- */
-/* some Divco specific stuff                                           */
+/*
+ * some Divco specific stuff
+ */
 static int cx88_pv_8000gt_callback(struct cx88_core *core,
 				   int command, int arg)
 {
@@ -3064,8 +3078,9 @@ static int cx88_pv_8000gt_callback(struct cx88_core *core,
 	return 0;
 }
 
-/* ----------------------------------------------------------------------- */
-/* some DViCO specific stuff                                               */
+/*
+ * some DViCO specific stuff
+ */
 
 static void dvico_fusionhdtv_hybrid_init(struct cx88_core *core)
 {
@@ -3161,11 +3176,11 @@ static int cx88_xc4000_tuner_callback(struct cx88_core *core,
 	return -EINVAL;
 }
 
-/* ----------------------------------------------------------------------- */
-/* Tuner callback function. Currently only needed for the Pinnacle	   *
- * PCTV HD 800i with an xc5000 sillicon tuner. This is used for both	   *
- * analog tuner attach (tuner-core.c) and dvb tuner attach (cx88-dvb.c)    */
-
+/*
+ * Tuner callback function. Currently only needed for the Pinnacle
+ * PCTV HD 800i with an xc5000 sillicon tuner. This is used for both
+ * analog tuner attach (tuner-core.c) and dvb tuner attach (cx88-dvb.c)
+ */
 static int cx88_xc5000_tuner_callback(struct cx88_core *core,
 				      int command, int arg)
 {
@@ -3173,38 +3188,38 @@ static int cx88_xc5000_tuner_callback(struct cx88_core *core,
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
 		if (command == 0) { /* This is the reset command from xc5000 */
 
-			/* djh - According to the engineer at PCTV Systems,
-			   the xc5000 reset pin is supposed to be on GPIO12.
-			   However, despite three nights of effort, pulling
-			   that GPIO low didn't reset the xc5000.  While
-			   pulling MO_SRST_IO low does reset the xc5000, this
-			   also resets in the s5h1409 being reset as well.
-			   This causes tuning to always fail since the internal
-			   state of the s5h1409 does not match the driver's
-			   state.  Given that the only two conditions in which
-			   the driver performs a reset is during firmware load
-			   and powering down the chip, I am taking out the
-			   reset.  We know that the chip is being reset
-			   when the cx88 comes online, and not being able to
-			   do power management for this board is worse than
-			   not having any tuning at all. */
+			/*
+			 * djh - According to the engineer at PCTV Systems,
+			 * the xc5000 reset pin is supposed to be on GPIO12.
+			 * However, despite three nights of effort, pulling
+			 * that GPIO low didn't reset the xc5000.  While
+			 * pulling MO_SRST_IO low does reset the xc5000, this
+			 * also resets in the s5h1409 being reset as well.
+			 * This causes tuning to always fail since the internal
+			 * state of the s5h1409 does not match the driver's
+			 * state.  Given that the only two conditions in which
+			 * the driver performs a reset is during firmware load
+			 * and powering down the chip, I am taking out the
+			 * reset.  We know that the chip is being reset
+			 * when the cx88 comes online, and not being able to
+			 * do power management for this board is worse than
+			 * not having any tuning at all.
+			 */
 			return 0;
-		} else {
-			dprintk(1, "xc5000: unknown tuner callback command.\n");
-			return -EINVAL;
 		}
-		break;
+
+		dprintk(1, "xc5000: unknown tuner callback command.\n");
+		return -EINVAL;
 	case CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD:
 		if (command == 0) { /* This is the reset command from xc5000 */
 			cx_clear(MO_GP0_IO, 0x00000010);
-			msleep(10);
+			usleep_range(10000, 20000);
 			cx_set(MO_GP0_IO, 0x00000010);
 			return 0;
-		} else {
-			dprintk(1, "xc5000: unknown tuner callback command.\n");
-			return -EINVAL;
 		}
-		break;
+
+		dprintk(1, "xc5000: unknown tuner callback command.\n");
+		return -EINVAL;
 	}
 	return 0; /* Should never be here */
 }
@@ -3230,15 +3245,15 @@ int cx88_tuner_callback(void *priv, int component, int command, int arg)
 		return -EINVAL;
 
 	switch (core->board.tuner_type) {
-		case TUNER_XC2028:
-			dprintk(1, "Calling XC2028/3028 callback\n");
-			return cx88_xc2028_tuner_callback(core, command, arg);
-		case TUNER_XC4000:
-			dprintk(1, "Calling XC4000 callback\n");
-			return cx88_xc4000_tuner_callback(core, command, arg);
-		case TUNER_XC5000:
-			dprintk(1, "Calling XC5000 callback\n");
-			return cx88_xc5000_tuner_callback(core, command, arg);
+	case TUNER_XC2028:
+		dprintk(1, "Calling XC2028/3028 callback\n");
+		return cx88_xc2028_tuner_callback(core, command, arg);
+	case TUNER_XC4000:
+		dprintk(1, "Calling XC4000 callback\n");
+		return cx88_xc4000_tuner_callback(core, command, arg);
+	case TUNER_XC5000:
+		dprintk(1, "Calling XC5000 callback\n");
+		return cx88_xc5000_tuner_callback(core, command, arg);
 	}
 	pr_err("Error: Calling callback for tuner %d\n",
 	       core->board.tuner_type);
@@ -3252,8 +3267,7 @@ static void cx88_card_list(struct cx88_core *core, struct pci_dev *pci)
 {
 	int i;
 
-	if (0 == pci->subsystem_vendor &&
-	    0 == pci->subsystem_device) {
+	if (!pci->subsystem_vendor && !pci->subsystem_device) {
 		pr_err("Your board has no valid PCI Subsystem ID and thus can't\n");
 		pr_err("be autodetected.  Please pass card=<n> insmod option to\n");
 		pr_err("workaround that.  Redirect complaints to the vendor of\n");
@@ -3274,7 +3288,9 @@ static void cx88_card_setup_pre_i2c(struct cx88_core *core)
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
 		/*
-		 * Bring the 702 demod up before i2c scanning/attach or devices are hidden
+		 * Bring the 702 demod up before i2c scanning/attach or
+		 * devices are hidden.
+		 *
 		 * We leave here with the 702 on the bus
 		 *
 		 * "reset the IR receiver on GPIO[3]"
@@ -3295,7 +3311,7 @@ static void cx88_card_setup_pre_i2c(struct cx88_core *core)
 		cx_write(MO_GP2_IO, 0xef5);
 		mdelay(50);
 		cx_write(MO_GP2_IO, 0xcf7);
-		msleep(10);
+		usleep_range(10000, 20000);
 		break;
 
 	case CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD:
@@ -3331,7 +3347,7 @@ static void cx88_card_setup_pre_i2c(struct cx88_core *core)
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		cx_write(MO_GP0_IO, 0x00003230);
 		cx_write(MO_GP0_IO, 0x00003210);
-		msleep(1);
+		usleep_range(10000, 20000);
 		cx_write(MO_GP0_IO, 0x00001230);
 		break;
 	}
@@ -3362,11 +3378,13 @@ void cx88_setup_xc3028(struct cx88_core *core, struct xc2028_ctrl *ctl)
 		ctl->demod = XC3028_FE_OREN538;
 		break;
 	case CX88_BOARD_GENIATECH_X8000_MT:
-		/* FIXME: For this board, the xc3028 never recovers after being
-		   powered down (the reset GPIO probably is not set properly).
-		   We don't have access to the hardware so we cannot determine
-		   which GPIO is used for xc3028, so just disable power xc3028
-		   power management for now */
+		/*
+		 * FIXME: For this board, the xc3028 never recovers after being
+		 * powered down (the reset GPIO probably is not set properly).
+		 * We don't have access to the hardware so we cannot determine
+		 * which GPIO is used for xc3028, so just disable power xc3028
+		 * power management for now
+		 */
 		ctl->disable_power_mgmt = 1;
 		break;
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
@@ -3396,7 +3414,7 @@ static void cx88_card_setup(struct cx88_core *core)
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
 
-	if (core->i2c_rc == 0) {
+	if (!core->i2c_rc) {
 		core->i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&core->i2c_client, eeprom, sizeof(eeprom));
 	}
@@ -3404,17 +3422,17 @@ static void cx88_card_setup(struct cx88_core *core)
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE:
 	case CX88_BOARD_HAUPPAUGE_ROSLYN:
-		if (core->i2c_rc == 0)
-			hauppauge_eeprom(core, eeprom+8);
+		if (!core->i2c_rc)
+			hauppauge_eeprom(core, eeprom + 8);
 		break;
 	case CX88_BOARD_GDI:
-		if (core->i2c_rc == 0)
+		if (!core->i2c_rc)
 			gdi_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_LEADTEK_PVR2000:
 	case CX88_BOARD_WINFAST_DV2000:
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
-		if (core->i2c_rc == 0)
+		if (!core->i2c_rc)
 			leadtek_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
@@ -3427,7 +3445,7 @@ static void cx88_card_setup(struct cx88_core *core)
 	case CX88_BOARD_HAUPPAUGE_HVR4000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		if (core->i2c_rc == 0)
+		if (!core->i2c_rc)
 			hauppauge_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_KWORLD_DVBS_100:
@@ -3438,7 +3456,7 @@ static void cx88_card_setup(struct cx88_core *core)
 		/* GPIO0:0 is hooked to demod reset */
 		/* GPIO0:4 is hooked to xc3028 reset */
 		cx_write(MO_GP0_IO, 0x00111100);
-		msleep(1);
+		usleep_range(10000, 20000);
 		cx_write(MO_GP0_IO, 0x00111111);
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL:
@@ -3454,9 +3472,9 @@ static void cx88_card_setup(struct cx88_core *core)
 		/* GPIO0:0 is hooked to mt352 reset pin */
 		cx_set(MO_GP0_IO, 0x00000101);
 		cx_clear(MO_GP0_IO, 0x00000001);
-		msleep(1);
+		usleep_range(10000, 20000);
 		cx_set(MO_GP0_IO, 0x00000101);
-		if (0 == core->i2c_rc &&
+		if (!core->i2c_rc &&
 		    core->boardnr == CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_HYBRID)
 			dvico_fusionhdtv_hybrid_init(core);
 		break;
@@ -3465,7 +3483,7 @@ static void cx88_card_setup(struct cx88_core *core)
 		cx_set(MO_GP0_IO, 0x00000707);
 		cx_set(MO_GP2_IO, 0x00000101);
 		cx_clear(MO_GP2_IO, 0x00000001);
-		msleep(1);
+		usleep_range(10000, 20000);
 		cx_clear(MO_GP0_IO, 0x00000007);
 		cx_set(MO_GP2_IO, 0x00000101);
 		break;
@@ -3473,7 +3491,7 @@ static void cx88_card_setup(struct cx88_core *core)
 		cx_write(MO_GP0_IO, 0x00080808);
 		break;
 	case CX88_BOARD_ATI_HDTVWONDER:
-		if (core->i2c_rc == 0) {
+		if (!core->i2c_rc) {
 			/* enable tuner */
 			int i;
 			static const u8 buffer[][2] = {
@@ -3486,8 +3504,8 @@ static void cx88_card_setup(struct cx88_core *core)
 			core->i2c_client.addr = 0x0a;
 
 			for (i = 0; i < ARRAY_SIZE(buffer); i++)
-				if (2 != i2c_master_send(&core->i2c_client,
-							buffer[i], 2))
+				if (i2c_master_send(&core->i2c_client,
+						    buffer[i], 2) != 2)
 					pr_warn("Unable to enable tuner(%i).\n",
 						i);
 		}
@@ -3523,7 +3541,7 @@ static void cx88_card_setup(struct cx88_core *core)
 		cx_write(MO_GP0_IO, 0x8000);
 		msleep(100);
 		cx_write(MO_SRST_IO, 0);
-		msleep(10);
+		usleep_range(10000, 20000);
 		cx_write(MO_GP0_IO, 0x8080);
 		msleep(100);
 		cx_write(MO_SRST_IO, 1);
@@ -3531,9 +3549,8 @@ static void cx88_card_setup(struct cx88_core *core)
 		break;
 	} /*end switch() */
 
-
 	/* Setup tuners */
-	if ((core->board.radio_type != UNSET)) {
+	if (core->board.radio_type != UNSET) {
 		tun_setup.mode_mask      = T_RADIO;
 		tun_setup.type           = core->board.radio_type;
 		tun_setup.addr           = core->board.radio_addr;
@@ -3621,8 +3638,7 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 		pci_write_config_byte(pci, CX88X_DEVCTRL, value);
 	}
 	if (lat != UNSET) {
-		pr_info("setting pci latency timer to %d\n",
-			latency);
+		pr_info("setting pci latency timer to %d\n", latency);
 		pci_write_config_byte(pci, PCI_LATENCY_TIMER, latency);
 	}
 	return 0;
@@ -3641,15 +3657,17 @@ int cx88_get_resources(const struct cx88_core *core, struct pci_dev *pci)
 	return -EBUSY;
 }
 
-/* Allocate and initialize the cx88 core struct.  One should hold the
- * devlist mutex before calling this.  */
+/*
+ * Allocate and initialize the cx88 core struct.  One should hold the
+ * devlist mutex before calling this.
+ */
 struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 {
 	struct cx88_core *core;
 	int i;
 
 	core = kzalloc(sizeof(*core), GFP_KERNEL);
-	if (core == NULL)
+	if (!core)
 		return NULL;
 
 	atomic_inc(&core->refcount);
@@ -3701,9 +3719,9 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 			      pci_resource_len(pci, 0));
 	core->bmmio = (u8 __iomem *)core->lmmio;
 
-	if (core->lmmio == NULL) {
+	if (!core->lmmio) {
 		release_mem_region(pci_resource_start(pci, 0),
-			   pci_resource_len(pci, 0));
+				   pci_resource_len(pci, 0));
 		v4l2_ctrl_handler_free(&core->video_hdl);
 		v4l2_ctrl_handler_free(&core->audio_hdl);
 		v4l2_device_unregister(&core->v4l2_dev);
@@ -3715,7 +3733,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->boardnr = UNSET;
 	if (card[core->nr] < ARRAY_SIZE(cx88_boards))
 		core->boardnr = card[core->nr];
-	for (i = 0; UNSET == core->boardnr && i < ARRAY_SIZE(cx88_subids); i++)
+	for (i = 0; core->boardnr == UNSET && i < ARRAY_SIZE(cx88_subids); i++)
 		if (pci->subsystem_vendor == cx88_subids[i].subvendor &&
 		    pci->subsystem_device == cx88_subids[i].subdevice)
 			core->boardnr = cx88_subids[i].card;
@@ -3750,9 +3768,11 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 
 	/* load tuner module, if needed */
 	if (core->board.tuner_type != UNSET) {
-		/* Ignore 0x6b and 0x6f on cx88 boards.
+		/*
+		 * Ignore 0x6b and 0x6f on cx88 boards.
 		 * FusionHDTV5 RT Gold has an ir receiver at 0x6b
-		 * and an RTC at 0x6f which can get corrupted if probed. */
+		 * and an RTC at 0x6f which can get corrupted if probed.
+		 */
 		static const unsigned short tv_addrs[] = {
 			0x42, 0x43, 0x4a, 0x4b,		/* tda8290 */
 			0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
@@ -3761,24 +3781,27 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		};
 		int has_demod = (core->board.tda9887_conf & TDA9887_PRESENT);
 
-		/* I don't trust the radio_type as is stored in the card
-		   definitions, so we just probe for it.
-		   The radio_type is sometimes missing, or set to UNSET but
-		   later code configures a tea5767.
+		/*
+		 * I don't trust the radio_type as is stored in the card
+		 * definitions, so we just probe for it.
+		 * The radio_type is sometimes missing, or set to UNSET but
+		 * later code configures a tea5767.
 		 */
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
+				    "tuner", 0,
+				    v4l2_i2c_tuner_addrs(ADDRS_RADIO));
 		if (has_demod)
 			v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap, "tuner",
+					    &core->i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (core->board.tuner_addr == ADDR_UNSET) {
 			v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap, "tuner",
+					    &core->i2c_adap, "tuner",
 				0, has_demod ? tv_addrs + 4 : tv_addrs);
 		} else {
 			v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"tuner", core->board.tuner_addr, NULL);
+					    "tuner", core->board.tuner_addr,
+					    NULL);
 		}
 	}
 
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 33719f0b06a5..973a9cd4c635 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -72,12 +72,14 @@ static DEFINE_MUTEX(devlist);
 
 #define NO_SYNC_LINE (-1U)
 
-/* @lpi: lines per IRQ, or 0 to not generate irqs. Note: IRQ to be
-	 generated _after_ lpi lines are transferred. */
+/*
+ * @lpi: lines per IRQ, or 0 to not generate irqs. Note: IRQ to be
+ * generated _after_ lpi lines are transferred.
+ */
 static __le32 *cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
-			    unsigned int offset, u32 sync_line,
-			    unsigned int bpl, unsigned int padding,
-			    unsigned int lines, unsigned int lpi, bool jump)
+			       unsigned int offset, u32 sync_line,
+			       unsigned int bpl, unsigned int padding,
+			       unsigned int lines, unsigned int lpi, bool jump)
 {
 	struct scatterlist *sg;
 	unsigned int line, todo, sol;
@@ -102,28 +104,29 @@ static __le32 *cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
 			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
 		else
 			sol = RISC_SOL;
-		if (bpl <= sg_dma_len(sg)-offset) {
+		if (bpl <= sg_dma_len(sg) - offset) {
 			/* fits into current chunk */
-			*(rp++) = cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
-			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
+			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
+					      RISC_EOL | bpl);
+			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
 			offset += bpl;
 		} else {
 			/* scanline needs to be split */
 			todo = bpl;
-			*(rp++) = cpu_to_le32(RISC_WRITE|sol|
-					    (sg_dma_len(sg)-offset));
-			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
-			todo -= (sg_dma_len(sg)-offset);
+			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
+					      (sg_dma_len(sg) - offset));
+			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
+			todo -= (sg_dma_len(sg) - offset);
 			offset = 0;
 			sg = sg_next(sg);
 			while (todo > sg_dma_len(sg)) {
-				*(rp++) = cpu_to_le32(RISC_WRITE|
-						    sg_dma_len(sg));
+				*(rp++) = cpu_to_le32(RISC_WRITE |
+						      sg_dma_len(sg));
 				*(rp++) = cpu_to_le32(sg_dma_address(sg));
 				todo -= sg_dma_len(sg);
 				sg = sg_next(sg);
 			}
-			*(rp++) = cpu_to_le32(RISC_WRITE|RISC_EOL|todo);
+			*(rp++) = cpu_to_le32(RISC_WRITE | RISC_EOL | todo);
 			*(rp++) = cpu_to_le32(sg_dma_address(sg));
 			offset += todo;
 		}
@@ -147,16 +150,19 @@ int cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 	if (bottom_offset != UNSET)
 		fields++;
 
-	/* estimate risc mem: worst case is one write per page border +
-	   one write per scan line + syncs + jump (all 2 dwords).  Padding
-	   can cause next bpl to start close to a page border.  First DMA
-	   region may be smaller than PAGE_SIZE */
-	instructions  = fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE + lines);
+	/*
+	 * estimate risc mem: worst case is one write per page border +
+	 * one write per scan line + syncs + jump (all 2 dwords).  Padding
+	 * can cause next bpl to start close to a page border.  First DMA
+	 * region may be smaller than PAGE_SIZE
+	 */
+	instructions  = fields * (1 + ((bpl + padding) * lines) /
+				  PAGE_SIZE + lines);
 	instructions += 4;
 	risc->size = instructions * 8;
 	risc->dma = 0;
 	risc->cpu = pci_zalloc_consistent(pci, risc->size, &risc->dma);
-	if (risc->cpu == NULL)
+	if (!risc->cpu)
 		return -ENOMEM;
 
 	/* write risc instructions */
@@ -166,13 +172,15 @@ int cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 				     bpl, padding, lines, 0, true);
 	if (bottom_offset != UNSET)
 		rp = cx88_risc_field(rp, sglist, bottom_offset, 0x200,
-				     bpl, padding, lines, 0, top_offset == UNSET);
+				     bpl, padding, lines, 0,
+				     top_offset == UNSET);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
 	WARN_ON((risc->jmp - risc->cpu + 2) * sizeof(*risc->cpu) > risc->size);
 	return 0;
 }
+EXPORT_SYMBOL(cx88_risc_buffer);
 
 int cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 			 struct scatterlist *sglist, unsigned int bpl,
@@ -181,32 +189,38 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 	u32 instructions;
 	__le32 *rp;
 
-	/* estimate risc mem: worst case is one write per page border +
-	   one write per scan line + syncs + jump (all 2 dwords).  Here
-	   there is no padding and no sync.  First DMA region may be smaller
-	   than PAGE_SIZE */
+	/*
+	 * estimate risc mem: worst case is one write per page border +
+	 * one write per scan line + syncs + jump (all 2 dwords).  Here
+	 * there is no padding and no sync.  First DMA region may be smaller
+	 * than PAGE_SIZE
+	 */
 	instructions  = 1 + (bpl * lines) / PAGE_SIZE + lines;
 	instructions += 3;
 	risc->size = instructions * 8;
 	risc->dma = 0;
 	risc->cpu = pci_zalloc_consistent(pci, risc->size, &risc->dma);
-	if (risc->cpu == NULL)
+	if (!risc->cpu)
 		return -ENOMEM;
 
 	/* write risc instructions */
 	rp = risc->cpu;
-	rp = cx88_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0, lines, lpi, !lpi);
+	rp = cx88_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0,
+			     lines, lpi, !lpi);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
 	WARN_ON((risc->jmp - risc->cpu + 2) * sizeof(*risc->cpu) > risc->size);
 	return 0;
 }
+EXPORT_SYMBOL(cx88_risc_databuffer);
 
-/* ------------------------------------------------------------------ */
-/* our SRAM memory layout                                             */
+/*
+ * our SRAM memory layout
+ */
 
-/* we are going to put all thr risc programs into host memory, so we
+/*
+ * we are going to put all thr risc programs into host memory, so we
  * can use the whole SDRAM for the DMA fifos.  To simplify things, we
  * use a static memory layout.  That surely will waste memory in case
  * we don't use all DMA channels at the same time (which will be the
@@ -330,6 +344,7 @@ const struct sram_channel cx88_sram_channels[] = {
 		.cnt2_reg   = MO_DMA27_CNT2,
 	},
 };
+EXPORT_SYMBOL(cx88_sram_channels);
 
 int cx88_sram_channel_setup(struct cx88_core *core,
 			    const struct sram_channel *ch,
@@ -347,12 +362,12 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 
 	/* write CDT */
 	for (i = 0; i < lines; i++)
-		cx_write(cdt + 16*i, ch->fifo_start + bpl*i);
+		cx_write(cdt + 16 * i, ch->fifo_start + bpl * i);
 
 	/* write CMDS */
 	cx_write(ch->cmds_start +  0, risc);
 	cx_write(ch->cmds_start +  4, cdt);
-	cx_write(ch->cmds_start +  8, (lines*16) >> 3);
+	cx_write(ch->cmds_start +  8, (lines * 16) >> 3);
 	cx_write(ch->cmds_start + 12, ch->ctrl_start);
 	cx_write(ch->cmds_start + 16, 64 >> 2);
 	for (i = 20; i < 64; i += 4)
@@ -362,11 +377,12 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 	cx_write(ch->ptr1_reg, ch->fifo_start);
 	cx_write(ch->ptr2_reg, cdt);
 	cx_write(ch->cnt1_reg, (bpl >> 3) - 1);
-	cx_write(ch->cnt2_reg, (lines*16) >> 3);
+	cx_write(ch->cnt2_reg, (lines * 16) >> 3);
 
 	dprintk(2, "sram setup %s: bpl=%d lines=%d\n", ch->name, bpl, lines);
 	return 0;
 }
+EXPORT_SYMBOL(cx88_sram_channel_setup);
 
 /* ------------------------------------------------------------------ */
 /* debug helper code                                                  */
@@ -401,15 +417,14 @@ static int cx88_risc_decode(u32 risc)
 	int i;
 
 	dprintk0("0x%08x [ %s", risc,
-	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
-	for (i = ARRAY_SIZE(bits)-1; i >= 0; i--)
+		 instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
+	for (i = ARRAY_SIZE(bits) - 1; i >= 0; i--)
 		if (risc & (1 << (i + 12)))
 			pr_cont(" %s", bits[i]);
 	pr_cont(" count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
-
 void cx88_sram_channel_dump(struct cx88_core *core,
 			    const struct sram_channel *ch)
 {
@@ -429,14 +444,12 @@ void cx88_sram_channel_dump(struct cx88_core *core,
 	u32 risc;
 	unsigned int i, j, n;
 
-	dprintk0("%s - dma channel status dump\n",
-		ch->name);
+	dprintk0("%s - dma channel status dump\n", ch->name);
 	for (i = 0; i < ARRAY_SIZE(name); i++)
 		dprintk0("   cmds: %-12s: 0x%08x\n",
-			name[i],
-			cx_read(ch->cmds_start + 4*i));
+			 name[i], cx_read(ch->cmds_start + 4 * i));
 	for (n = 1, i = 0; i < 4; i++) {
-		risc = cx_read(ch->cmds_start + 4 * (i+11));
+		risc = cx_read(ch->cmds_start + 4 * (i + 11));
 		pr_cont("  risc%d: ", i);
 		if (--n)
 			pr_cont("0x%08x [ arg #%d ]\n", risc, n);
@@ -448,21 +461,22 @@ void cx88_sram_channel_dump(struct cx88_core *core,
 		dprintk0("  iq %x: ", i);
 		n = cx88_risc_decode(risc);
 		for (j = 1; j < n; j++) {
-			risc = cx_read(ch->ctrl_start + 4 * (i+j));
+			risc = cx_read(ch->ctrl_start + 4 * (i + j));
 			pr_cont("  iq %x: 0x%08x [ arg #%d ]\n",
 				i + j, risc, j);
 		}
 	}
 
 	dprintk0("fifo: 0x%08x -> 0x%x\n",
-	       ch->fifo_start, ch->fifo_start+ch->fifo_size);
+		 ch->fifo_start, ch->fifo_start + ch->fifo_size);
 	dprintk0("ctrl: 0x%08x -> 0x%x\n",
-	       ch->ctrl_start, ch->ctrl_start + 6 * 16);
+		 ch->ctrl_start, ch->ctrl_start + 6 * 16);
 	dprintk0("  ptr1_reg: 0x%08x\n", cx_read(ch->ptr1_reg));
 	dprintk0("  ptr2_reg: 0x%08x\n", cx_read(ch->ptr2_reg));
 	dprintk0("  cnt1_reg: 0x%08x\n", cx_read(ch->cnt1_reg));
 	dprintk0("  cnt2_reg: 0x%08x\n", cx_read(ch->cnt2_reg));
 }
+EXPORT_SYMBOL(cx88_sram_channel_dump);
 
 static const char *cx88_pci_irqs[32] = {
 	"vid", "aud", "ts", "vip", "hst", "5", "6", "tm1",
@@ -490,6 +504,7 @@ void cx88_print_irqbits(const char *tag, const char *strings[],
 	}
 	pr_cont("\n");
 }
+EXPORT_SYMBOL(cx88_print_irqbits);
 
 /* ------------------------------------------------------------------ */
 
@@ -507,6 +522,7 @@ int cx88_core_irq(struct cx88_core *core, u32 status)
 				   status, core->pci_irqmask);
 	return handled;
 }
+EXPORT_SYMBOL(cx88_core_irq);
 
 void cx88_wakeup(struct cx88_core *core,
 		 struct cx88_dmaqueue *q, u32 count)
@@ -521,6 +537,7 @@ void cx88_wakeup(struct cx88_core *core,
 	list_del(&buf->list);
 	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
+EXPORT_SYMBOL(cx88_wakeup);
 
 void cx88_shutdown(struct cx88_core *core)
 {
@@ -545,6 +562,7 @@ void cx88_shutdown(struct cx88_core *core)
 	/* stop capturing */
 	cx_write(VID_CAPTURE_CONTROL, 0);
 }
+EXPORT_SYMBOL(cx88_shutdown);
 
 int cx88_reset(struct cx88_core *core)
 {
@@ -560,13 +578,15 @@ int cx88_reset(struct cx88_core *core)
 	msleep(100);
 
 	/* init sram */
-	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH21], 720*4, 0);
+	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH21],
+				720 * 4, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH22], 128, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH23], 128, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH24], 128, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH25], 128, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH26], 128, 0);
-	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH28], 188*4, 0);
+	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH28],
+				188 * 4, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH27], 128, 0);
 
 	/* misc init ... */
@@ -594,11 +614,12 @@ int cx88_reset(struct cx88_core *core)
 
 	/* Reset on-board parts */
 	cx_write(MO_SRST_IO, 0);
-	msleep(10);
+	usleep_range(10000, 20000);
 	cx_write(MO_SRST_IO, 1);
 
 	return 0;
 }
+EXPORT_SYMBOL(cx88_reset);
 
 /* ------------------------------------------------------------------ */
 
@@ -628,10 +649,11 @@ static inline unsigned int norm_fsc8(v4l2_std_id norm)
 	if (norm & V4L2_STD_NTSC) // All NTSC/M and variants
 		return 28636360;      // 3.57954545 MHz +/- 10 Hz
 
-	/* SECAM have also different sub carrier for chroma,
-	   but step_db and step_dr, at cx88_set_tvnorm already handles that.
-
-	   The same FSC applies to PAL/BGDKIH, PAL/60, NTSC/4.43 and PAL/N
+	/*
+	 * SECAM have also different sub carrier for chroma,
+	 * but step_db and step_dr, at cx88_set_tvnorm already handles that.
+	 *
+	 * The same FSC applies to PAL/BGDKIH, PAL/60, NTSC/4.43 and PAL/N
 	 */
 
 	return 35468950;      // 4.43361875 MHz +/- 5 Hz
@@ -639,13 +661,12 @@ static inline unsigned int norm_fsc8(v4l2_std_id norm)
 
 static inline unsigned int norm_htotal(v4l2_std_id norm)
 {
-
-	unsigned int fsc4 = norm_fsc8(norm)/2;
+	unsigned int fsc4 = norm_fsc8(norm) / 2;
 
 	/* returns 4*FSC / vtotal / frames per seconds */
 	return (norm & V4L2_STD_625_50) ?
-				((fsc4+312)/625+12)/25 :
-				((fsc4+262)/525*1001+15000)/30000;
+				((fsc4 + 312) / 625 + 12) / 25 :
+				((fsc4 + 262) / 525 * 1001 + 15000) / 30000;
 }
 
 static inline unsigned int norm_vbipack(v4l2_std_id norm)
@@ -653,8 +674,8 @@ static inline unsigned int norm_vbipack(v4l2_std_id norm)
 	return (norm & V4L2_STD_625_50) ? 511 : 400;
 }
 
-int cx88_set_scale(struct cx88_core *core, unsigned int width, unsigned int height,
-		   enum v4l2_field field)
+int cx88_set_scale(struct cx88_core *core, unsigned int width,
+		   unsigned int height, enum v4l2_field field)
 {
 	unsigned int swidth  = norm_swidth(core->tvnorm);
 	unsigned int sheight = norm_maxh(core->tvnorm);
@@ -721,6 +742,7 @@ int cx88_set_scale(struct cx88_core *core, unsigned int width, unsigned int heig
 
 	return 0;
 }
+EXPORT_SYMBOL(cx88_set_scale);
 
 static const u32 xtal = 28636363;
 
@@ -749,13 +771,13 @@ static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 	cx_write(MO_PLL_REG, reg);
 	for (i = 0; i < 100; i++) {
 		reg = cx_read(MO_DEVICE_STATUS);
-		if (reg & (1<<2)) {
+		if (reg & (1 << 2)) {
 			dprintk(1, "pll locked [pre=%d,ofreq=%d]\n",
 				prescale, ofreq);
 			return 0;
 		}
 		dprintk(1, "pll not locked yet, waiting ...\n");
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 	dprintk(1, "pll NOT locked [pre=%d,ofreq=%d]\n", prescale, ofreq);
 	return -1;
@@ -764,9 +786,9 @@ static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 int cx88_start_audio_dma(struct cx88_core *core)
 {
 	/* constant 128 made buzz in analog Nicam-stereo for bigger fifo_size */
-	int bpl = cx88_sram_channels[SRAM_CH25].fifo_size/4;
+	int bpl = cx88_sram_channels[SRAM_CH25].fifo_size / 4;
 
-	int rds_bpl = cx88_sram_channels[SRAM_CH27].fifo_size/AUD_RDS_LINES;
+	int rds_bpl = cx88_sram_channels[SRAM_CH27].fifo_size / AUD_RDS_LINES;
 
 	/* If downstream RISC is enabled, bail out; ALSA is managing DMA */
 	if (cx_read(MO_AUD_DMACNTRL) & 0x10)
@@ -803,8 +825,8 @@ static int set_tvaudio(struct cx88_core *core)
 {
 	v4l2_std_id norm = core->tvnorm;
 
-	if (CX88_VMUX_TELEVISION != INPUT(core->input).type &&
-	    CX88_VMUX_CABLE != INPUT(core->input).type)
+	if (INPUT(core->input).type != CX88_VMUX_TELEVISION &&
+	    INPUT(core->input).type != CX88_VMUX_CABLE)
 		return 0;
 
 	if (V4L2_STD_PAL_BG & norm) {
@@ -819,7 +841,8 @@ static int set_tvaudio(struct cx88_core *core)
 	} else if (V4L2_STD_SECAM_L & norm) {
 		core->tvaudio = WW_L;
 
-	} else if ((V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H) & norm) {
+	} else if ((V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H) &
+		   norm) {
 		core->tvaudio = WW_BG;
 
 	} else if (V4L2_STD_SECAM_DK & norm) {
@@ -844,15 +867,13 @@ static int set_tvaudio(struct cx88_core *core)
 	/* cx88_set_stereo(dev,V4L2_TUNER_MODE_STEREO); */
 
 /*
-   This should be needed only on cx88-alsa. It seems that some cx88 chips have
-   bugs and does require DMA enabled for it to work.
+ * This should be needed only on cx88-alsa. It seems that some cx88 chips have
+ * bugs and does require DMA enabled for it to work.
  */
 	cx88_start_audio_dma(core);
 	return 0;
 }
 
-
-
 int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 {
 	u32 fsc8;
@@ -916,8 +937,10 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 
 	dprintk(1, "set_tvnorm: MO_INPUT_FORMAT  0x%08x [old=0x%08x]\n",
 		cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
-	/* Chroma AGC must be disabled if SECAM is used, we enable it
-	   by default on PAL and NTSC */
+	/*
+	 * Chroma AGC must be disabled if SECAM is used, we enable it
+	 * by default on PAL and NTSC
+	 */
 	cx_andor(MO_INPUT_FORMAT, 0x40f,
 		 norm & V4L2_STD_SECAM ? cxiformat : cxiformat | 0x400);
 
@@ -952,7 +975,8 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	agcdelay = vdec_clock * 68 / 20000000 + 15;
 	dprintk(1,
 		"set_tvnorm: MO_AGC_BURST     0x%08x [old=0x%08x,bdelay=%d,agcdelay=%d]\n",
-		(bdelay << 8) | agcdelay, cx_read(MO_AGC_BURST), bdelay, agcdelay);
+		(bdelay << 8) | agcdelay, cx_read(MO_AGC_BURST),
+		bdelay, agcdelay);
 	cx_write(MO_AGC_BURST, (bdelay << 8) | agcdelay);
 
 	// htotal
@@ -966,7 +990,7 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 
 	// vbi stuff, set vbi offset to 10 (for 20 Clk*2 pixels), this makes
 	// the effective vbi offset ~244 samples, the same as the Bt8x8
-	cx_write(MO_VBI_PACKET, (10<<11) | norm_vbipack(norm));
+	cx_write(MO_VBI_PACKET, (10 << 11) | norm_vbipack(norm));
 
 	// this is needed as well to set all tvnorm parameter
 	cx88_set_scale(core, 320, 240, V4L2_FIELD_INTERLACED);
@@ -977,12 +1001,16 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	// tell i2c chips
 	call_all(core, video, s_std, norm);
 
-	/* The chroma_agc control should be inaccessible if the video format is SECAM */
+	/*
+	 * The chroma_agc control should be inaccessible
+	 * if the video format is SECAM
+	 */
 	v4l2_ctrl_grab(core->chroma_agc, cxiformat == VideoFormatSECAM);
 
 	// done
 	return 0;
 }
+EXPORT_SYMBOL(cx88_set_tvnorm);
 
 /* ------------------------------------------------------------------ */
 
@@ -1007,6 +1035,7 @@ void cx88_vdev_init(struct cx88_core *core,
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
 }
+EXPORT_SYMBOL(cx88_vdev_init);
 
 struct cx88_core *cx88_core_get(struct pci_dev *pci)
 {
@@ -1029,7 +1058,7 @@ struct cx88_core *cx88_core_get(struct pci_dev *pci)
 	}
 
 	core = cx88_core_create(pci, cx88_devcount);
-	if (core != NULL) {
+	if (core) {
 		cx88_devcount++;
 		list_add_tail(&core->devlist, &cx88_devlist);
 	}
@@ -1037,6 +1066,7 @@ struct cx88_core *cx88_core_get(struct pci_dev *pci)
 	mutex_unlock(&devlist);
 	return core;
 }
+EXPORT_SYMBOL(cx88_core_get);
 
 void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 {
@@ -1062,29 +1092,4 @@ void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 	v4l2_device_unregister(&core->v4l2_dev);
 	kfree(core);
 }
-
-/* ------------------------------------------------------------------ */
-
-EXPORT_SYMBOL(cx88_print_irqbits);
-
-EXPORT_SYMBOL(cx88_core_irq);
-EXPORT_SYMBOL(cx88_wakeup);
-EXPORT_SYMBOL(cx88_reset);
-EXPORT_SYMBOL(cx88_shutdown);
-
-EXPORT_SYMBOL(cx88_risc_buffer);
-EXPORT_SYMBOL(cx88_risc_databuffer);
-
-EXPORT_SYMBOL(cx88_sram_channels);
-EXPORT_SYMBOL(cx88_sram_channel_setup);
-EXPORT_SYMBOL(cx88_sram_channel_dump);
-
-EXPORT_SYMBOL(cx88_set_tvnorm);
-EXPORT_SYMBOL(cx88_set_scale);
-
-EXPORT_SYMBOL(cx88_vdev_init);
-EXPORT_SYMBOL(cx88_core_get);
 EXPORT_SYMBOL(cx88_core_put);
-
-EXPORT_SYMBOL(cx88_ir_start);
-EXPORT_SYMBOL(cx88_ir_stop);
diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index 235124e2a763..105029088120 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -31,18 +31,22 @@
 #define baseband_freq(carrier, srate, tone) ((s32)( \
 	 (compat_remainder(carrier + tone, srate)) / srate * 2 * INT_PI))
 
-/* We calculate the baseband frequencies of the carrier and the pilot tones
- * based on the the sampling rate of the audio rds fifo. */
+/*
+ * We calculate the baseband frequencies of the carrier and the pilot tones
+ * based on the the sampling rate of the audio rds fifo.
+ */
 
 #define FREQ_A2_CARRIER         baseband_freq(54687.5, 2689.36, 0.0)
 #define FREQ_A2_DUAL            baseband_freq(54687.5, 2689.36, 274.1)
 #define FREQ_A2_STEREO          baseband_freq(54687.5, 2689.36, 117.5)
 
-/* The frequencies below are from the reference driver. They probably need
+/*
+ * The frequencies below are from the reference driver. They probably need
  * further adjustments, because they are not tested at all. You may even need
  * to play a bit with the registers of the chip to select the proper signal
  * for the input of the audio rds fifo, and measure it's sampling rate to
- * calculate the proper baseband frequencies... */
+ * calculate the proper baseband frequencies...
+ */
 
 #define FREQ_A2M_CARRIER	((s32)(2.114516 * 32768.0))
 #define FREQ_A2M_DUAL		((s32)(2.754916 * 32768.0))
@@ -83,8 +87,10 @@ static s32 int_cos(u32 x)
 	x = x % INT_PI;
 	if (x > INT_PI / 2)
 		return -int_cos(INT_PI / 2 - (x % (INT_PI / 2)));
-	/* Now x is between 0 and INT_PI/2.
-	 * To calculate cos(x) we use it's Taylor polinom. */
+	/*
+	 * Now x is between 0 and INT_PI/2.
+	 * To calculate cos(x) we use it's Taylor polinom.
+	 */
 	t2 = x * x / 32768 / 2;
 	t4 = t2 * x / 32768 * x / 32768 / 3 / 4;
 	t6 = t4 * x / 32768 * x / 32768 / 5 / 6;
@@ -95,8 +101,10 @@ static s32 int_cos(u32 x)
 
 static u32 int_goertzel(s16 x[], u32 N, u32 freq)
 {
-	/* We use the Goertzel algorithm to determine the power of the
-	 * given frequency in the signal */
+	/*
+	 * We use the Goertzel algorithm to determine the power of the
+	 * given frequency in the signal
+	 */
 	s32 s_prev = 0;
 	s32 s_prev2 = 0;
 	s32 coeff = 2 * int_cos(freq);
@@ -115,12 +123,14 @@ static u32 int_goertzel(s16 x[], u32 N, u32 freq)
 	tmp = (s64)s_prev2 * s_prev2 + (s64)s_prev * s_prev -
 		      (s64)coeff * s_prev2 * s_prev / 32768;
 
-	/* XXX: N must be low enough so that N*N fits in s32.
-	 * Else we need two divisions. */
+	/*
+	 * XXX: N must be low enough so that N*N fits in s32.
+	 * Else we need two divisions.
+	 */
 	divisor = N * N;
 	do_div(tmp, divisor);
 
-	return (u32) tmp;
+	return (u32)tmp;
 }
 
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
@@ -187,7 +197,8 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 	dual    = freq_magnitude(x, N, dual_freq);
 	noise   = noise_magnitude(x, N, FREQ_NOISE_START, FREQ_NOISE_END);
 
-	dprintk(1, "detect a2/a2m/eiaj: carrier=%d, stereo=%d, dual=%d, noise=%d\n",
+	dprintk(1,
+		"detect a2/a2m/eiaj: carrier=%d, stereo=%d, dual=%d, noise=%d\n",
 		carrier, stereo, dual, noise);
 
 	if (stereo > dual)
@@ -201,8 +212,10 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 		    (carrier < max(stereo, dual) * 6) &&
 		    (carrier > 20 && carrier < 200) &&
 		    (max(stereo, dual) > min(stereo, dual))) {
-			/* For EIAJ the carrier is always present,
-			   so we probably don't need noise detection */
+			/*
+			 * For EIAJ the carrier is always present,
+			 * so we probably don't need noise detection
+			 */
 			return ret;
 		}
 	} else {
@@ -243,7 +256,8 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 	u32 current_address = cx_read(srch->ptr1_reg);
 	u32 offset = (current_address - srch->fifo_start + bpl);
 
-	dprintk(1, "read RDS samples: current_address=%08x (offset=%08x), sample_count=%d, aud_intstat=%08x\n",
+	dprintk(1,
+		"read RDS samples: current_address=%08x (offset=%08x), sample_count=%d, aud_intstat=%08x\n",
 		current_address,
 		current_address - srch->fifo_start, sample_count,
 		cx_read(MO_AUD_INTSTAT));
@@ -308,9 +322,9 @@ s32 cx88_dsp_detect_stereo_sap(struct cx88_core *core)
 
 	if (ret != UNSET)
 		dprintk(1, "stereo/sap detection result:%s%s%s\n",
-			   (ret & V4L2_TUNER_SUB_MONO) ? " mono" : "",
-			   (ret & V4L2_TUNER_SUB_STEREO) ? " stereo" : "",
-			   (ret & V4L2_TUNER_SUB_LANG2) ? " dual" : "");
+			(ret & V4L2_TUNER_SUB_MONO) ? " mono" : "",
+			(ret & V4L2_TUNER_SUB_STEREO) ? " stereo" : "",
+			(ret & V4L2_TUNER_SUB_LANG2) ? " dual" : "");
 
 	return ret;
 }
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 5188f8f2d6dd..ddf90678df34 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -82,8 +82,8 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 /* ------------------------------------------------------------------ */
 
 static int queue_setup(struct vb2_queue *q,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], struct device *alloc_devs[])
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8802_dev *dev = q->drv_priv;
 
@@ -445,7 +445,7 @@ static const struct nxt200x_config ati_hdtvwonder = {
 };
 
 static int cx24123_set_ts_param(struct dvb_frontend *fe,
-	int is_punctured)
+				int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
 
@@ -684,7 +684,7 @@ static int attach_xc4000(struct cx8802_dev *dev, struct xc4000_config *cfg)
 }
 
 static int cx24116_set_ts_param(struct dvb_frontend *fe,
-	int is_punctured)
+				int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
 
@@ -694,7 +694,7 @@ static int cx24116_set_ts_param(struct dvb_frontend *fe,
 }
 
 static int stv0900_set_ts_param(struct dvb_frontend *fe,
-	int is_punctured)
+				int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
 
@@ -711,10 +711,10 @@ static int cx24116_reset_device(struct dvb_frontend *fe)
 	/* Reset the part */
 	/* Put the cx24116 into reset */
 	cx_write(MO_SRST_IO, 0);
-	msleep(10);
+	usleep_range(10000, 20000);
 	/* Take the cx24116 out of reset */
 	cx_write(MO_SRST_IO, 1);
-	msleep(10);
+	usleep_range(10000, 20000);
 
 	return 0;
 }
@@ -732,7 +732,7 @@ static const struct cx24116_config tevii_s460_config = {
 };
 
 static int ds3000_set_ts_param(struct dvb_frontend *fe,
-	int is_punctured)
+			       int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
 
@@ -812,8 +812,6 @@ static int cx8802_alloc_frontends(struct cx8802_dev *dev)
 	return 0;
 }
 
-
-
 static const u8 samsung_smt_7020_inittab[] = {
 	     0x01, 0x15,
 	     0x02, 0x00,
@@ -865,7 +863,6 @@ static const u8 samsung_smt_7020_inittab[] = {
 	     0xff, 0xff,
 };
 
-
 static int samsung_smt_7020_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -898,7 +895,7 @@ static int samsung_smt_7020_tuner_set_params(struct dvb_frontend *fe)
 }
 
 static int samsung_smt_7020_set_tone(struct dvb_frontend *fe,
-	enum fe_sec_tone_mode tone)
+				     enum fe_sec_tone_mode tone)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
@@ -953,7 +950,7 @@ static int samsung_smt_7020_set_voltage(struct dvb_frontend *fe,
 }
 
 static int samsung_smt_7020_stv0299_set_symbol_rate(struct dvb_frontend *fe,
-	u32 srate, u32 ratio)
+						    u32 srate, u32 ratio)
 {
 	u8 aclk = 0;
 	u8 bclk = 0;
@@ -987,7 +984,6 @@ static int samsung_smt_7020_stv0299_set_symbol_rate(struct dvb_frontend *fe,
 	return 0;
 }
 
-
 static const struct stv0299_config samsung_stv0299_config = {
 	.demod_address = 0x68,
 	.inittab = samsung_smt_7020_inittab,
@@ -1029,7 +1025,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &connexant_refboard_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, &core->i2c_adap,
 					DVB_PLL_THOMSON_DTT759X))
@@ -1043,7 +1039,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &connexant_refboard_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x60, &core->i2c_adap,
 					DVB_PLL_THOMSON_DTT7579))
@@ -1057,10 +1053,10 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &hauppauge_hvr_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
-				   &core->i2c_adap, 0x61,
-				   TUNER_PHILIPS_FMD1216ME_MK3))
+					&core->i2c_adap, 0x61,
+					TUNER_PHILIPS_FMD1216ME_MK3))
 				goto frontend_detach;
 		}
 		break;
@@ -1068,10 +1064,10 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(cx22702_attach,
 					       &hauppauge_hvr_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
-				   &core->i2c_adap, 0x61,
-				   TUNER_PHILIPS_FMD1216MEX_MK3))
+					&core->i2c_adap, 0x61,
+					TUNER_PHILIPS_FMD1216MEX_MK3))
 				goto frontend_detach;
 		}
 		break;
@@ -1081,8 +1077,8 @@ static int dvb_register(struct cx8802_dev *dev)
 		dev->frontends.gate = 2;
 		/* DVB-S init */
 		fe0->dvb.frontend = dvb_attach(cx24123_attach,
-					&hauppauge_novas_config,
-					&dev->core->i2c_adap);
+					       &hauppauge_novas_config,
+					       &dev->core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(isl6421_attach,
 					fe0->dvb.frontend,
@@ -1096,8 +1092,8 @@ static int dvb_register(struct cx8802_dev *dev)
 			goto frontend_detach;
 		/* DVB-T init */
 		fe1->dvb.frontend = dvb_attach(cx22702_attach,
-					&hauppauge_hvr_config,
-					&dev->core->i2c_adap);
+					       &hauppauge_hvr_config,
+					       &dev->core->i2c_adap);
 		if (fe1->dvb.frontend) {
 			fe1->dvb.frontend->id = 1;
 			if (!dvb_attach(simple_tuner_attach,
@@ -1111,7 +1107,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dvico_fusionhdtv,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x60, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
@@ -1121,19 +1117,21 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_plus_v1_1,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x60, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
 		}
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL:
-		/* The tin box says DEE1601, but it seems to be DTT7579
-		 * compatible, with a slightly different MT352 AGC gain. */
+		/*
+		 * The tin box says DEE1601, but it seems to be DTT7579
+		 * compatible, with a slightly different MT352 AGC gain.
+		 */
 		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dvico_fusionhdtv_dual,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
@@ -1143,7 +1141,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_plus_v1_1,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_THOMSON_DTT7579))
 				goto frontend_detach;
@@ -1153,7 +1151,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dvico_fusionhdtv,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_LG_Z201))
 				goto frontend_detach;
@@ -1165,7 +1163,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(mt352_attach,
 					       &dntv_live_dvbt_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
 					0x61, NULL, DVB_PLL_UNKNOWN_1))
 				goto frontend_detach;
@@ -1174,9 +1172,10 @@ static int dvb_register(struct cx8802_dev *dev)
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
 #if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
 		/* MT352 is on a secondary I2C bus made from some GPIO lines */
-		fe0->dvb.frontend = dvb_attach(mt352_attach, &dntv_live_dvbt_pro_config,
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
+					       &dntv_live_dvbt_pro_config,
 					       &dev->vp3054->adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_PHILIPS_FMD1216ME_MK3))
@@ -1190,10 +1189,10 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_hybrid,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
-				   &core->i2c_adap, 0x61,
-				   TUNER_THOMSON_FE6600))
+					&core->i2c_adap, 0x61,
+					TUNER_THOMSON_FE6600))
 				goto frontend_detach;
 		}
 		break;
@@ -1201,7 +1200,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &dvico_fusionhdtv_xc3028,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend == NULL)
+		if (!fe0->dvb.frontend)
 			fe0->dvb.frontend = dvb_attach(mt352_attach,
 						&dvico_fusionhdtv_mt352_xc3028,
 						&core->i2c_adap);
@@ -1218,7 +1217,7 @@ static int dvb_register(struct cx8802_dev *dev)
 	case CX88_BOARD_PCHDTV_HD3000:
 		fe0->dvb.frontend = dvb_attach(or51132_attach, &pchdtv_hd3000,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_THOMSON_DTT761X))
@@ -1239,7 +1238,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_MICROTUNE_4042FI5))
@@ -1257,7 +1256,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_THOMSON_DTT761X))
@@ -1275,13 +1274,13 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_5_gold,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_LG_TDVS_H06XF))
 				goto frontend_detach;
 			if (!dvb_attach(tda9887_attach, fe0->dvb.frontend,
-				   &core->i2c_adap, 0x43))
+					&core->i2c_adap, 0x43))
 				goto frontend_detach;
 		}
 		break;
@@ -1296,13 +1295,13 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &pchdtv_hd5500,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_LG_TDVS_H06XF))
 				goto frontend_detach;
 			if (!dvb_attach(tda9887_attach, fe0->dvb.frontend,
-				   &core->i2c_adap, 0x43))
+					&core->i2c_adap, 0x43))
 				goto frontend_detach;
 		}
 		break;
@@ -1310,7 +1309,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(nxt200x_attach,
 					       &ati_hdtvwonder,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
 					TUNER_PHILIPS_TUV1236D))
@@ -1331,8 +1330,8 @@ static int dvb_register(struct cx8802_dev *dev)
 				override_tone = false;
 
 			if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
-					&core->i2c_adap, 0x08, ISL6421_DCL, 0x00,
-					override_tone))
+					&core->i2c_adap, 0x08, ISL6421_DCL,
+					0x00, override_tone))
 				goto frontend_detach;
 		}
 		break;
@@ -1358,7 +1357,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 					       &pinnacle_pctv_hd_800i_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
 					&core->i2c_adap,
 					&pinnacle_pctv_hd_800i_tuner_config))
@@ -1367,9 +1366,9 @@ static int dvb_register(struct cx8802_dev *dev)
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
-						&dvico_hdtv5_pci_nano_config,
-						&core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+					       &dvico_hdtv5_pci_nano_config,
+					       &core->i2c_adap);
+		if (fe0->dvb.frontend) {
 			struct dvb_frontend *fe;
 			struct xc2028_config cfg = {
 				.i2c_adap  = &core->i2c_adap,
@@ -1383,7 +1382,7 @@ static int dvb_register(struct cx8802_dev *dev)
 
 			fe = dvb_attach(xc2028_attach,
 					fe0->dvb.frontend, &cfg);
-			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
+			if (fe && fe->ops.tuner_ops.set_config)
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
 		break;
@@ -1436,7 +1435,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
 					       &dvico_fusionhdtv7_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
 					&core->i2c_adap,
 					&dvico_fusionhdtv7_tuner_config))
@@ -1449,8 +1448,8 @@ static int dvb_register(struct cx8802_dev *dev)
 		dev->frontends.gate = 2;
 		/* DVB-S/S2 Init */
 		fe0->dvb.frontend = dvb_attach(cx24116_attach,
-					&hauppauge_hvr4000_config,
-					&dev->core->i2c_adap);
+					       &hauppauge_hvr4000_config,
+					       &dev->core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(isl6421_attach,
 					fe0->dvb.frontend,
@@ -1464,8 +1463,8 @@ static int dvb_register(struct cx8802_dev *dev)
 			goto frontend_detach;
 		/* DVB-T Init */
 		fe1->dvb.frontend = dvb_attach(cx22702_attach,
-					&hauppauge_hvr_config,
-					&dev->core->i2c_adap);
+					       &hauppauge_hvr_config,
+					       &dev->core->i2c_adap);
 		if (fe1->dvb.frontend) {
 			fe1->dvb.frontend->id = 1;
 			if (!dvb_attach(simple_tuner_attach,
@@ -1477,8 +1476,8 @@ static int dvb_register(struct cx8802_dev *dev)
 		break;
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
 		fe0->dvb.frontend = dvb_attach(cx24116_attach,
-					&hauppauge_hvr4000_config,
-					&dev->core->i2c_adap);
+					       &hauppauge_hvr4000_config,
+					       &dev->core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(isl6421_attach,
 					fe0->dvb.frontend,
@@ -1493,7 +1492,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(stv0299_attach,
 						&tevii_tuner_sharp_config,
 						&core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
 					&core->i2c_adap, DVB_PLL_OPERA1))
 				goto frontend_detach;
@@ -1504,8 +1503,9 @@ static int dvb_register(struct cx8802_dev *dev)
 			fe0->dvb.frontend = dvb_attach(stv0288_attach,
 							    &tevii_tuner_earda_config,
 							    &core->i2c_adap);
-			if (fe0->dvb.frontend != NULL) {
-				if (!dvb_attach(stb6000_attach, fe0->dvb.frontend, 0x61,
+			if (fe0->dvb.frontend) {
+				if (!dvb_attach(stb6000_attach,
+						fe0->dvb.frontend, 0x61,
 						&core->i2c_adap))
 					goto frontend_detach;
 				core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
@@ -1517,16 +1517,16 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(cx24116_attach,
 					       &tevii_s460_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL)
+		if (fe0->dvb.frontend)
 			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
 		break;
 	case CX88_BOARD_TEVII_S464:
 		fe0->dvb.frontend = dvb_attach(ds3000_attach,
 						&tevii_ds3000_config,
 						&core->i2c_adap);
-		if (fe0->dvb.frontend != NULL) {
+		if (fe0->dvb.frontend) {
 			dvb_attach(ts2020_attach, fe0->dvb.frontend,
-				&tevii_ts2020_config, &core->i2c_adap);
+				   &tevii_ts2020_config, &core->i2c_adap);
 			fe0->dvb.frontend->ops.set_voltage =
 							tevii_dvbs_set_voltage;
 		}
@@ -1538,7 +1538,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe0->dvb.frontend = dvb_attach(cx24116_attach,
 					       &hauppauge_hvr4000_config,
 					       &core->i2c_adap);
-		if (fe0->dvb.frontend != NULL)
+		if (fe0->dvb.frontend)
 			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII:
@@ -1555,9 +1555,9 @@ static int dvb_register(struct cx8802_dev *dev)
 		struct dvb_tuner_ops *tuner_ops = NULL;
 
 		fe0->dvb.frontend = dvb_attach(stv0900_attach,
-						&prof_7301_stv0900_config,
-						&core->i2c_adap, 0);
-		if (fe0->dvb.frontend != NULL) {
+					       &prof_7301_stv0900_config,
+					       &core->i2c_adap, 0);
+		if (fe0->dvb.frontend) {
 			if (!dvb_attach(stb6100_attach, fe0->dvb.frontend,
 					&prof_7301_stb6100_config,
 					&core->i2c_adap))
@@ -1587,8 +1587,8 @@ static int dvb_register(struct cx8802_dev *dev)
 		mdelay(200);
 
 		fe0->dvb.frontend = dvb_attach(stv0299_attach,
-					&samsung_stv0299_config,
-					&dev->core->i2c_adap);
+					       &samsung_stv0299_config,
+					       &dev->core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			fe0->dvb.frontend->ops.tuner_ops.set_params =
 				samsung_smt_7020_tuner_set_params;
@@ -1604,8 +1604,8 @@ static int dvb_register(struct cx8802_dev *dev)
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		dev->ts_gen_cntrl = 0x00;
 		fe0->dvb.frontend = dvb_attach(mb86a16_attach,
-						&twinhan_vp1027,
-						&core->i2c_adap);
+					       &twinhan_vp1027,
+					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			core->prev_set_voltage =
 					fe0->dvb.frontend->ops.set_voltage;
@@ -1772,7 +1772,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 		struct vb2_queue *q;
 
 		fe = vb2_dvb_get_frontend(&core->dvbdev->frontends, i);
-		if (fe == NULL) {
+		if (!fe) {
 			pr_err("%s() failed to get frontend(%d)\n",
 			       __func__, i);
 			err = -ENODEV;
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index 99596fe56cd2..f7692775fb5a 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -24,10 +24,9 @@
 
 #include "cx88.h"
 
-#include <linux/module.h>
 #include <linux/init.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
+#include <linux/module.h>
 
 #include <media/v4l2-common.h>
 
@@ -41,7 +40,8 @@ MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
 static unsigned int i2c_udelay = 5;
 module_param(i2c_udelay, int, 0644);
-MODULE_PARM_DESC(i2c_udelay, "i2c delay at insmod time, in usecs (should be 5 or higher). Lower value means higher bus speed.");
+MODULE_PARM_DESC(i2c_udelay,
+		 "i2c delay at insmod time, in usecs (should be 5 or higher). Lower value means higher bus speed.");
 
 #define dprintk(level, fmt, arg...) do {				\
 	if (i2c_debug >= level)						\
@@ -139,7 +139,6 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 
 	core->i2c_algo = cx8800_i2c_algo_template;
 
-
 	core->i2c_adap.dev.parent = &pci->dev;
 	strlcpy(core->i2c_adap.name, core->name, sizeof(core->i2c_adap.name));
 	core->i2c_adap.owner = THIS_MODULE;
@@ -166,14 +165,14 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 
 		dprintk(1, "i2c register ok\n");
 		switch (core->boardnr) {
-			case CX88_BOARD_HAUPPAUGE_HVR1300:
-			case CX88_BOARD_HAUPPAUGE_HVR3000:
-			case CX88_BOARD_HAUPPAUGE_HVR4000:
-				pr_info("i2c init: enabling analog demod on HVR1300/3000/4000 tuner\n");
-				i2c_transfer(core->i2c_client.adapter, &tuner_msg, 1);
-				break;
-			default:
-				break;
+		case CX88_BOARD_HAUPPAUGE_HVR1300:
+		case CX88_BOARD_HAUPPAUGE_HVR3000:
+		case CX88_BOARD_HAUPPAUGE_HVR4000:
+			pr_info("i2c init: enabling analog demod on HVR1300/3000/4000 tuner\n");
+			i2c_transfer(core->i2c_client.adapter, &tuner_msg, 1);
+			break;
+		default:
+			break;
 		}
 		if (i2c_scan)
 			do_i2c_scan(core->name, &core->i2c_client);
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index c072b7ecc8d6..dcfea3502e42 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -62,11 +62,15 @@ static int ir_debug;
 module_param(ir_debug, int, 0644);	/* debug level [IR] */
 MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
-#define ir_dprintk(fmt, arg...)	if (ir_debug) \
-	printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg)
+#define ir_dprintk(fmt, arg...)	do {					\
+	if (ir_debug)							\
+		printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg);\
+} while (0)
 
-#define dprintk(fmt, arg...)	if (ir_debug) \
-	printk(KERN_DEBUG "cx88 IR: " fmt, ##arg)
+#define dprintk(fmt, arg...) do {					\
+	if (ir_debug)							\
+		printk(KERN_DEBUG "cx88 IR: " fmt, ##arg);		\
+} while (0)
 
 /* ---------------------------------------------------------------------- */
 
@@ -79,16 +83,17 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 	gpio = cx_read(ir->gpio_addr);
 	switch (core->boardnr) {
 	case CX88_BOARD_NPGTECH_REALTV_TOP10FM:
-		/* This board apparently uses a combination of 2 GPIO
-		   to represent the keys. Additionally, the second GPIO
-		   can be used for parity.
-
-		   Example:
-
-		   for key "5"
-			gpio = 0x758, auxgpio = 0xe5 or 0xf5
-		   for key "Power"
-			gpio = 0x758, auxgpio = 0xed or 0xfd
+		/*
+		 * This board apparently uses a combination of 2 GPIO
+		 * to represent the keys. Additionally, the second GPIO
+		 * can be used for parity.
+		 *
+		 * Example:
+		 *
+		 * for key "5"
+		 *	gpio = 0x758, auxgpio = 0xe5 or 0xf5
+		 * for key "Power"
+		 *	gpio = 0x758, auxgpio = 0xed or 0xfd
 		 */
 
 		auxgpio = cx_read(MO_GP1_IO);
@@ -142,7 +147,7 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		if (0 == (gpio & ir->mask_keyup))
 			rc_keydown_notimeout(ir->dev, RC_TYPE_NECX, scancode,
-									0);
+					     0);
 		else
 			rc_keyup(ir->dev);
 
@@ -231,12 +236,14 @@ int cx88_ir_start(struct cx88_core *core)
 
 	return 0;
 }
+EXPORT_SYMBOL(cx88_ir_start);
 
 void cx88_ir_stop(struct cx88_core *core)
 {
 	if (core->ir->users)
 		__cx88_ir_stop(core);
 }
+EXPORT_SYMBOL(cx88_ir_stop);
 
 static int cx88_ir_open(struct rc_dev *rc)
 {
@@ -508,7 +515,7 @@ int cx88_ir_fini(struct cx88_core *core)
 	struct cx88_IR *ir = core->ir;
 
 	/* skip detach on non attached boards */
-	if (ir == NULL)
+	if (!ir)
 		return 0;
 
 	cx88_ir_stop(core);
@@ -576,7 +583,7 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_type *protocol,
 	}
 
 	dprintk("IR Key/Flags: (0x%02x/0x%02x)\n",
-		   code & 0xff, flags & 0xff);
+		code & 0xff, flags & 0xff);
 
 	*protocol = RC_TYPE_UNKNOWN;
 	*scancode = code & 0xff;
@@ -636,8 +643,8 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			info.platform_data = &core->init_data;
 		}
 		if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
-					I2C_SMBUS_READ, 0,
-					I2C_SMBUS_QUICK, NULL) >= 0) {
+				   I2C_SMBUS_READ, 0,
+				   I2C_SMBUS_QUICK, NULL) >= 0) {
 			info.addr = *addrp;
 			i2c_new_device(&core->i2c_adap, &info);
 			break;
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 4533e2c6cb9f..52ff00ebd4bd 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -16,10 +16,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -30,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
-#include <asm/delay.h>
+#include <linux/delay.h>
 
 /* ------------------------------------------------------------------ */
 
@@ -54,7 +50,8 @@ MODULE_PARM_DESC(debug, "enable debug messages [mpeg]");
 #if defined(CONFIG_MODULES) && defined(MODULE)
 static void request_module_async(struct work_struct *work)
 {
-	struct cx8802_dev *dev = container_of(work, struct cx8802_dev, request_module_wk);
+	struct cx8802_dev *dev = container_of(work, struct cx8802_dev,
+					      request_module_wk);
 
 	if (dev->core->board.mpeg & CX88_MPEG_DVB)
 		request_module("cx88-dvb");
@@ -77,14 +74,13 @@ static void flush_request_modules(struct cx8802_dev *dev)
 #define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
-
 static LIST_HEAD(cx8802_devlist);
 static DEFINE_MUTEX(cx8802_mutex);
 /* ------------------------------------------------------------------ */
 
 int cx8802_start_dma(struct cx8802_dev    *dev,
-			    struct cx88_dmaqueue *q,
-			    struct cx88_buffer   *buf)
+		     struct cx88_dmaqueue *q,
+		     struct cx88_buffer   *buf)
 {
 	struct cx88_core *core = dev->core;
 
@@ -98,33 +94,35 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	/* write TS length to chip */
 	cx_write(MO_TS_LNGTH, dev->ts_packet_size);
 
-	/* FIXME: this needs a review.
-	 * also: move to cx88-blackbird + cx88-dvb source files? */
+	/*
+	 * FIXME: this needs a review.
+	 * also: move to cx88-blackbird + cx88-dvb source files?
+	 */
 
 	dprintk(1, "core->active_type_id = 0x%08x\n", core->active_type_id);
 
 	if ((core->active_type_id == CX88_MPEG_DVB) &&
-		(core->board.mpeg & CX88_MPEG_DVB)) {
-
+	    (core->board.mpeg & CX88_MPEG_DVB)) {
 		dprintk(1, "cx8802_start_dma doing .dvb\n");
 		/* negedge driven & software reset */
 		cx_write(TS_GEN_CNTRL, 0x0040 | dev->ts_gen_cntrl);
 		udelay(100);
 		cx_write(MO_PINMUX_IO, 0x00);
-		cx_write(TS_HW_SOP_CNTRL, 0x47<<16|188<<4|0x01);
+		cx_write(TS_HW_SOP_CNTRL, 0x47 << 16 | 188 << 4 | 0x01);
 		switch (core->boardnr) {
 		case CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q:
 		case CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_T:
 		case CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD:
 		case CX88_BOARD_PCHDTV_HD5500:
-			cx_write(TS_SOP_STAT, 1<<13);
+			cx_write(TS_SOP_STAT, 1 << 13);
 			break;
 		case CX88_BOARD_SAMSUNG_SMT_7020:
 			cx_write(TS_SOP_STAT, 0x00);
 			break;
 		case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
 		case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
-			cx_write(MO_PINMUX_IO, 0x88); /* Enable MPEG parallel IO and video signal pins */
+			/* Enable MPEG parallel IO and video signal pins */
+			cx_write(MO_PINMUX_IO, 0x88);
 			udelay(100);
 			break;
 		case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -153,13 +151,15 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 		dprintk(1, "cx8802_start_dma doing .blackbird\n");
 		cx_write(MO_PINMUX_IO, 0x88); /* enable MPEG parallel IO */
 
-		cx_write(TS_GEN_CNTRL, 0x46); /* punctured clock TS & posedge driven & software reset */
+		/* punctured clock TS & posedge driven & software reset */
+		cx_write(TS_GEN_CNTRL, 0x46);
 		udelay(100);
 
 		cx_write(TS_HW_SOP_CNTRL, 0x408); /* mpeg start byte */
 		cx_write(TS_VALERR_CNTRL, 0x2000);
 
-		cx_write(TS_GEN_CNTRL, 0x06); /* punctured clock TS & posedge driven */
+		/* punctured clock TS & posedge driven */
+		cx_write(TS_GEN_CNTRL, 0x06);
 		udelay(100);
 	} else {
 		pr_err("%s() Failed. Unsupported value in .mpeg (0x%08x)\n",
@@ -177,10 +177,11 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	cx_set(MO_TS_INTMSK,  0x1f0011);
 
 	/* start dma */
-	cx_set(MO_DEV_CNTRL2, (1<<5));
+	cx_set(MO_DEV_CNTRL2, (1 << 5));
 	cx_set(MO_TS_DMACNTRL, 0x11);
 	return 0;
 }
+EXPORT_SYMBOL(cx8802_start_dma);
 
 static int cx8802_stop_dma(struct cx8802_dev *dev)
 {
@@ -219,7 +220,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 /* ------------------------------------------------------------------ */
 
 int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
-			struct cx88_buffer *buf)
+		       struct cx88_buffer *buf)
 {
 	int size = dev->ts_packet_size * dev->ts_packet_count;
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
@@ -231,15 +232,17 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	rc = cx88_risc_databuffer(dev->pci, risc, sgt->sgl,
-			     dev->ts_packet_size, dev->ts_packet_count, 0);
+				  dev->ts_packet_size, dev->ts_packet_count, 0);
 	if (rc) {
 		if (risc->cpu)
-			pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+			pci_free_consistent(dev->pci, risc->size,
+					    risc->cpu, risc->dma);
 		memset(risc, 0, sizeof(*risc));
 		return rc;
 	}
 	return 0;
 }
+EXPORT_SYMBOL(cx8802_buf_prepare);
 
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 {
@@ -268,6 +271,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 			buf, buf->vb.vb2_buf.index, __func__);
 	}
 }
+EXPORT_SYMBOL(cx8802_buf_queue);
 
 /* ----------------------------------------------------------- */
 
@@ -292,6 +296,7 @@ void cx8802_cancel_buffers(struct cx8802_dev *dev)
 	cx8802_stop_dma(dev);
 	do_cancel_buffers(dev);
 }
+EXPORT_SYMBOL(cx8802_cancel_buffers);
 
 static const char *cx88_mpeg_irqs[32] = {
 	"ts_risci1", NULL, NULL, NULL,
@@ -324,7 +329,8 @@ static void cx8802_mpeg_irq(struct cx8802_dev *dev)
 	if (status & (1 << 16)) {
 		pr_warn("mpeg risc op code error\n");
 		cx_clear(MO_TS_DMACNTRL, 0x11);
-		cx88_sram_channel_dump(dev->core, &cx88_sram_channels[SRAM_CH28]);
+		cx88_sram_channel_dump(dev->core,
+				       &cx88_sram_channels[SRAM_CH28]);
 	}
 
 	/* risc1 y */
@@ -452,7 +458,8 @@ static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 	cx88_shutdown(dev->core);
 
 	pci_save_state(pci_dev);
-	if (pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state)) != 0) {
+	if (pci_set_power_state(pci_dev,
+				pci_choose_state(pci_dev, state)) != 0) {
 		pci_disable_device(pci_dev);
 		dev->state.disabled = 1;
 	}
@@ -497,7 +504,8 @@ static int cx8802_resume_common(struct pci_dev *pci_dev)
 	return 0;
 }
 
-struct cx8802_driver *cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype)
+struct cx8802_driver *cx8802_get_driver(struct cx8802_dev *dev,
+					enum cx88_board_type btype)
 {
 	struct cx8802_driver *d;
 
@@ -507,6 +515,7 @@ struct cx8802_driver *cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_
 
 	return NULL;
 }
+EXPORT_SYMBOL(cx8802_get_driver);
 
 /* Driver asked for hardware access. */
 static int cx8802_request_acquire(struct cx8802_driver *drv)
@@ -524,7 +533,8 @@ static int cx8802_request_acquire(struct cx8802_driver *drv)
 		core->last_analog_input = core->input;
 		core->input = 0;
 		for (i = 0;
-		     i < (sizeof(core->board.input) / sizeof(struct cx88_input));
+		     i < (sizeof(core->board.input) /
+			  sizeof(struct cx88_input));
 		     i++) {
 			if (core->board.input[i].type == CX88_VMUX_DVB) {
 				core->input = i;
@@ -533,8 +543,7 @@ static int cx8802_request_acquire(struct cx8802_driver *drv)
 		}
 	}
 
-	if (drv->advise_acquire)
-	{
+	if (drv->advise_acquire) {
 		core->active_ref++;
 		if (core->active_type_id == CX88_BOARD_NONE) {
 			core->active_type_id = drv->type_id;
@@ -552,11 +561,12 @@ static int cx8802_request_release(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 
-	if (drv->advise_release && --core->active_ref == 0)
-	{
+	if (drv->advise_release && --core->active_ref == 0) {
 		if (drv->type_id == CX88_MPEG_DVB) {
-			/* If the DVB driver is releasing, reset the input
-			   state to the last configured analog input */
+			/*
+			 * If the DVB driver is releasing, reset the input
+			 * state to the last configured analog input
+			 */
 			core->input = core->last_analog_input;
 		}
 
@@ -570,21 +580,21 @@ static int cx8802_request_release(struct cx8802_driver *drv)
 
 static int cx8802_check_driver(struct cx8802_driver *drv)
 {
-	if (drv == NULL)
+	if (!drv)
 		return -ENODEV;
 
 	if ((drv->type_id != CX88_MPEG_DVB) &&
-		(drv->type_id != CX88_MPEG_BLACKBIRD))
+	    (drv->type_id != CX88_MPEG_BLACKBIRD))
 		return -EINVAL;
 
 	if ((drv->hw_access != CX8802_DRVCTL_SHARED) &&
-		(drv->hw_access != CX8802_DRVCTL_EXCLUSIVE))
+	    (drv->hw_access != CX8802_DRVCTL_EXCLUSIVE))
 		return -EINVAL;
 
-	if ((drv->probe == NULL) ||
-		(drv->remove == NULL) ||
-		(drv->advise_acquire == NULL) ||
-		(drv->advise_release == NULL))
+	if ((!drv->probe) ||
+	    (!drv->remove) ||
+	    (!drv->advise_acquire) ||
+	    (!drv->advise_release))
 		return -EINVAL;
 
 	return 0;
@@ -598,9 +608,11 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 
 	pr_info("registering cx8802 driver, type: %s access: %s\n",
 		drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
-		drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
+		drv->hw_access == CX8802_DRVCTL_SHARED ?
+				  "shared" : "exclusive");
 
-	if ((err = cx8802_check_driver(drv)) != 0) {
+	err = cx8802_check_driver(drv);
+	if (err) {
 		pr_err("cx8802_driver is invalid\n");
 		return err;
 	}
@@ -615,7 +627,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 
 		/* Bring up a new struct for each driver instance */
 		driver = kzalloc(sizeof(*drv), GFP_KERNEL);
-		if (driver == NULL) {
+		if (!driver) {
 			err = -ENOMEM;
 			goto out;
 		}
@@ -644,6 +656,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 	mutex_unlock(&cx8802_mutex);
 	return err;
 }
+EXPORT_SYMBOL(cx8802_register_driver);
 
 int cx8802_unregister_driver(struct cx8802_driver *drv)
 {
@@ -653,7 +666,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 
 	pr_info("unregistering cx8802 driver, type: %s access: %s\n",
 		drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
-		drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
+		drv->hw_access == CX8802_DRVCTL_SHARED ?
+				  "shared" : "exclusive");
 
 	mutex_lock(&cx8802_mutex);
 
@@ -686,6 +700,7 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 
 	return err;
 }
+EXPORT_SYMBOL(cx8802_unregister_driver);
 
 /* ----------------------------------------------------------- */
 static int cx8802_probe(struct pci_dev *pci_dev,
@@ -697,7 +712,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
 	/* general setup */
 	core = cx88_core_get(pci_dev);
-	if (core == NULL)
+	if (!core)
 		return -EINVAL;
 
 	pr_info("cx2388x 8802 Driver Manager\n");
@@ -708,7 +723,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
 	err = -ENOMEM;
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL)
+	if (!dev)
 		goto fail_core;
 	dev->pci = pci_dev;
 	dev->core = core;
@@ -797,12 +812,3 @@ static struct pci_driver cx8802_pci_driver = {
 };
 
 module_pci_driver(cx8802_pci_driver);
-
-EXPORT_SYMBOL(cx8802_buf_prepare);
-EXPORT_SYMBOL(cx8802_buf_queue);
-EXPORT_SYMBOL(cx8802_cancel_buffers);
-EXPORT_SYMBOL(cx8802_start_dma);
-
-EXPORT_SYMBOL(cx8802_register_driver);
-EXPORT_SYMBOL(cx8802_unregister_driver);
-EXPORT_SYMBOL(cx8802_get_driver);
diff --git a/drivers/media/pci/cx88/cx88-reg.h b/drivers/media/pci/cx88/cx88-reg.h
index 88ed8a2e4ee1..f1e1dd634a72 100644
--- a/drivers/media/pci/cx88/cx88-reg.h
+++ b/drivers/media/pci/cx88/cx88-reg.h
@@ -1,32 +1,28 @@
 /*
-
-    cx88x-hw.h - CX2388x register offsets
-
-    Copyright (C) 1996,97,98 Ralph Metzler (rjkm@thp.uni-koeln.de)
-		  2001 Michael Eskin
-		  2002 Yurij Sysoev <yurij@naturesoft.net>
-		  2003 Gerd Knorr <kraxel@bytesex.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+ * cx88x-hw.h - CX2388x register offsets
+ *
+ * Copyright (C) 1996,97,98 Ralph Metzler (rjkm@thp.uni-koeln.de)
+ *		  2001 Michael Eskin
+ *		  2002 Yurij Sysoev <yurij@naturesoft.net>
+ *		  2003 Gerd Knorr <kraxel@bytesex.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
 
 #ifndef _CX88_REG_H_
 #define _CX88_REG_H_
 
-/* ---------------------------------------------------------------------- */
-/* PCI IDs and config space                                               */
+/*
+ * PCI IDs and config space
+ */
 
 #ifndef PCI_VENDOR_ID_CONEXANT
 # define PCI_VENDOR_ID_CONEXANT		0x14F1
@@ -39,8 +35,9 @@
 #define CX88X_EN_TBFX 0x02
 #define CX88X_EN_VSFX 0x04
 
-/* ---------------------------------------------------------------------- */
-/* PCI controller registers                                               */
+/*
+ * PCI controller registers
+ */
 
 /* Command and Status Register */
 #define F0_CMD_STAT_MM      0x2f0004
@@ -63,8 +60,9 @@
 #define F3_BAR0_MM          0x2f0310
 #define F4_BAR0_MM          0x2f0410
 
-/* ---------------------------------------------------------------------- */
-/* DMA Controller registers                                               */
+/*
+ * DMA Controller registers
+ */
 
 #define MO_PDMA_STHRSH      0x200000 // Source threshold
 #define MO_PDMA_STADRS      0x200004 // Source target address
@@ -157,9 +155,9 @@
 #define MO_DMA31_CNT2       0x300168 // {11}RW* DMA Table Size : Ch#31
 #define MO_DMA32_CNT2       0x30016C // {11}RW* DMA Table Size : Ch#32
 
-
-/* ---------------------------------------------------------------------- */
-/* Video registers                                                        */
+/*
+ * Video registers
+ */
 
 #define MO_VIDY_DMA         0x310000 // {64}RWp Video Y
 #define MO_VIDU_DMA         0x310008 // {64}RWp Video U
@@ -217,9 +215,9 @@
 #define MO_VID_DMACNTRL     0x31C040 // {8}RW Video DMA control
 #define MO_VID_XFR_STAT     0x31C044 // {1}RO Video transfer status
 
-
-/* ---------------------------------------------------------------------- */
-/* audio registers                                                        */
+/*
+ * audio registers
+ */
 
 #define MO_AUDD_DMA         0x320000 // {64}RWp Audio downstream
 #define MO_AUDU_DMA         0x320008 // {64}RWp Audio upstream
@@ -437,9 +435,9 @@
 #define AUD_PHACC_FREQ_8LSB      0x320d2b
 #define AUD_QAM_MODE             0x320d04
 
-
-/* ---------------------------------------------------------------------- */
-/* transport stream registers                                             */
+/*
+ * transport stream registers
+ */
 
 #define MO_TS_DMA           0x330000 // {64}RWp Transport stream downstream
 #define MO_TS_GPCNT         0x33C020 // {16}RO TS general purpose counter
@@ -455,9 +453,9 @@
 #define TS_FIFO_OVFL_STAT   0x33C05C
 #define TS_VALERR_CNTRL     0x33C060
 
-
-/* ---------------------------------------------------------------------- */
-/* VIP registers                                                          */
+/*
+ * VIP registers
+ */
 
 #define MO_VIPD_DMA         0x340000 // {64}RWp VIP downstream
 #define MO_VIPU_DMA         0x340008 // {64}RWp VIP upstream
@@ -475,9 +473,9 @@
 #define MO_VIP_INTCNTRL     0x34C05C // VIP Interrupt Control
 #define MO_VIP_XFTERM       0x340060 // VIP transfer terminate
 
-
-/* ---------------------------------------------------------------------- */
-/* misc registers                                                         */
+/*
+ * misc registers
+ */
 
 #define MO_M2M_DMA          0x350000 // {64}RWp Mem2Mem DMA Bfr
 #define MO_GP0_IO           0x350010 // {32}RW* GPIOoutput enablesdata I/O
@@ -509,9 +507,9 @@
 #define MO_INT1_STAT        0x35C064 // DMA RISC interrupt status
 #define MO_INT1_MSTAT       0x35C068 // DMA RISC interrupt masked status
 
-
-/* ---------------------------------------------------------------------- */
-/* i2c bus registers                                                      */
+/*
+ * i2c bus registers
+ */
 
 #define MO_I2C              0x368000 // I2C data/control
 #define MO_I2C_DIV          (0xf<<4)
@@ -521,9 +519,11 @@
 #define MO_I2C_SDA          (1<<0)
 
 
-/* ---------------------------------------------------------------------- */
-/* general purpose host registers                                         */
-/* FIXME: tyops?  s/0x35/0x38/ ??                                         */
+/*
+ * general purpose host registers
+ *
+ * FIXME: tyops?  s/0x35/0x38/ ??
+ */
 
 #define MO_GPHSTD_DMA       0x350000 // {64}RWp Host downstream
 #define MO_GPHSTU_DMA       0x350008 // {64}RWp Host upstream
@@ -545,9 +545,9 @@
 #define MO_GPHST_XFR_STAT   0x38C044 // Host transfer status
 #define MO_GPHST_SOFT_RST   0x38C06C // Host software reset
 
-
-/* ---------------------------------------------------------------------- */
-/* RISC instructions                                                      */
+/*
+ * RISC instructions
+ */
 
 #define RISC_SYNC		 0x80000000
 #define RISC_SYNC_ODD		 0x80000000
@@ -578,9 +578,9 @@
 #define RISC_CNT_RESET		 0x00030000
 #define RISC_JMP_SRP		 0x01
 
-
-/* ---------------------------------------------------------------------- */
-/* various constants                                                      */
+/*
+ * various constants
+ */
 
 // DMA
 /* Interrupt mask/status */
diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
index 20f6924abe35..545ad4c4d1c7 100644
--- a/drivers/media/pci/cx88/cx88-tvaudio.c
+++ b/drivers/media/pci/cx88/cx88-tvaudio.c
@@ -57,7 +57,8 @@ MODULE_PARM_DESC(always_analog, "force analog audio out");
 
 static unsigned int radio_deemphasis;
 module_param(radio_deemphasis, int, 0644);
-MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, 0=None, 1=50us (elsewhere), 2=75us (USA)");
+MODULE_PARM_DESC(radio_deemphasis,
+		 "Radio deemphasis time constant, 0=None, 1=50us (elsewhere), 2=75us (USA)");
 
 #define dprintk(fmt, arg...) do {				\
 	if (audio_debug)						\
@@ -141,7 +142,10 @@ static void set_audio_finish(struct cx88_core *core, u32 ctl)
 	if (core->board.mpeg & CX88_MPEG_BLACKBIRD) {
 		cx_write(AUD_I2SINPUTCNTL, 4);
 		cx_write(AUD_BAUDRATE, 1);
-		/* 'pass-thru mode': this enables the i2s output to the mpeg encoder */
+		/*
+		 * 'pass-thru mode': this enables the i2s
+		 * output to the mpeg encoder
+		 */
 		cx_set(AUD_CTL, EN_I2SOUT_ENABLE);
 		cx_write(AUD_I2SOUTPUTCNTL, 1);
 		cx_write(AUD_I2SCNTL, 0);
@@ -634,7 +638,6 @@ static void set_audio_standard_A2(struct cx88_core *core, u32 mode)
 	case WW_M:
 		dprintk("%s Warning: wrong value\n", __func__);
 		return;
-		break;
 	}
 
 	mode |= EN_FMRADIO_EN_RDS | EN_DMTRX_SUMDIFF;
@@ -691,13 +694,15 @@ static void set_audio_standard_FM(struct cx88_core *core,
 		{ /* end of list */ },
 	};
 
-	/* It is enough to leave default values? */
-	/* No, it's not!  The deemphasis registers are reset to the 75us
+	/*
+	 * It is enough to leave default values?
+	 *
+	 * No, it's not!  The deemphasis registers are reset to the 75us
 	 * values by default.  Analyzing the spectrum of the decoded audio
 	 * reveals that "no deemphasis" is the same as 75 us, while the 50 us
-	 * setting results in less deemphasis.  */
+	 * setting results in less deemphasis.
+	 */
 	static const struct rlist fm_no_deemph[] = {
-
 		{AUD_POLYPH80SCALEFAC, 0x0003},
 		{ /* end of list */ },
 	};
@@ -741,7 +746,7 @@ static int cx88_detect_nicam(struct cx88_core *core)
 		}
 
 		/* wait a little bit for next reading status */
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 
 	dprintk("nicam is not detected.\n");
@@ -762,8 +767,10 @@ void cx88_set_tvaudio(struct cx88_core *core)
 		/* prepare all dsp registers */
 		set_audio_standard_A2(core, EN_A2_FORCE_MONO1);
 
-		/* set nicam mode - otherwise
-		   AUD_NICAM_STATUS2 contains wrong values */
+		/*
+		 * set nicam mode - otherwise
+		 * AUD_NICAM_STATUS2 contains wrong values
+		 */
 		set_audio_standard_NICAM(core, EN_NICAM_AUTO_STEREO);
 		if (cx88_detect_nicam(core) == 0) {
 			/* fall back to fm / am mono */
@@ -797,19 +804,22 @@ void cx88_set_tvaudio(struct cx88_core *core)
 		pr_info("unknown tv audio mode [%d]\n", core->tvaudio);
 		break;
 	}
-	return;
 }
+EXPORT_SYMBOL(cx88_set_tvaudio);
 
 void cx88_newstation(struct cx88_core *core)
 {
 	core->audiomode_manual = UNSET;
 	core->last_change = jiffies;
 }
+EXPORT_SYMBOL(cx88_newstation);
 
 void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
 {
-	static const char * const m[] = { "stereo", "dual mono", "mono", "sap" };
-	static const char * const p[] = { "no pilot", "pilot c1", "pilot c2", "?" };
+	static const char * const m[] = { "stereo", "dual mono",
+					  "mono",   "sap" };
+	static const char * const p[] = { "no pilot", "pilot c1",
+					  "pilot c2", "?" };
 	u32 reg, mode, pilot;
 
 	reg = cx_read(AUD_STATUS);
@@ -866,13 +876,16 @@ void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
 	/* If software stereo detection is not supported... */
 	if (t->rxsubchans == UNSET) {
 		t->rxsubchans = V4L2_TUNER_SUB_MONO;
-		/* If the hardware itself detected stereo, also return
-		   stereo as an available subchannel */
+		/*
+		 * If the hardware itself detected stereo, also return
+		 * stereo as an available subchannel
+		 */
 		if (t->audmode == V4L2_TUNER_MODE_STEREO)
 			t->rxsubchans |= V4L2_TUNER_SUB_STEREO;
 	}
-	return;
 }
+EXPORT_SYMBOL(cx88_get_stereo);
+
 
 void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 {
@@ -928,7 +941,8 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 				break;
 			}
 		} else {
-			if ((core->tvaudio == WW_I) || (core->tvaudio == WW_L)) {
+			if ((core->tvaudio == WW_I) ||
+			    (core->tvaudio == WW_L)) {
 				/* fall back to fm / am mono */
 				set_audio_standard_A2(core, EN_A2_FORCE_MONO1);
 			} else {
@@ -976,8 +990,8 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 			cx_read(AUD_CTL), cx_sread(SHADOW_AUD_VOL_CTL));
 		cx_andor(AUD_CTL, mask, ctl);
 	}
-	return;
 }
+EXPORT_SYMBOL(cx88_set_stereo);
 
 int cx88_audio_thread(void *data)
 {
@@ -1027,8 +1041,10 @@ int cx88_audio_thread(void *data)
 		case WW_FM:
 		case WW_I2SADC:
 hw_autodetect:
-			/* stereo autodetection is supported by hardware so
-			   we don't need to do it manually. Do nothing. */
+			/*
+			 * stereo autodetection is supported by hardware so
+			 * we don't need to do it manually. Do nothing.
+			 */
 			break;
 		}
 	}
@@ -1036,11 +1052,4 @@ int cx88_audio_thread(void *data)
 	dprintk("cx88: tvaudio thread exiting\n");
 	return 0;
 }
-
-/* ----------------------------------------------------------- */
-
-EXPORT_SYMBOL(cx88_set_tvaudio);
-EXPORT_SYMBOL(cx88_newstation);
-EXPORT_SYMBOL(cx88_set_stereo);
-EXPORT_SYMBOL(cx88_get_stereo);
 EXPORT_SYMBOL(cx88_audio_thread);
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 9028822f507e..2d0ef19e6d65 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -20,7 +20,7 @@ MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
 /* ------------------------------------------------------------------ */
 
 int cx8800_vbi_fmt(struct file *file, void *priv,
-					struct v4l2_format *f)
+		   struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 
@@ -48,8 +48,8 @@ int cx8800_vbi_fmt(struct file *file, void *priv,
 }
 
 static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
-			 struct cx88_dmaqueue *q,
-			 struct cx88_buffer   *buf)
+				struct cx88_dmaqueue *q,
+				struct cx88_buffer   *buf)
 {
 	struct cx88_core *core = dev->core;
 
@@ -57,9 +57,9 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 	cx88_sram_channel_setup(dev->core, &cx88_sram_channels[SRAM_CH24],
 				VBI_LINE_LENGTH, buf->risc.dma);
 
-	cx_write(MO_VBOS_CONTROL, ((1 << 18) |  // comb filter delay fixup
-				    (1 << 15) |  // enable vbi capture
-				    (1 << 11)));
+	cx_write(MO_VBOS_CONTROL, (1 << 18) |  /* comb filter delay fixup */
+				  (1 << 15) |  /* enable vbi capture */
+				  (1 << 11));
 
 	/* reset counter */
 	cx_write(MO_VBI_GPCNTRL, GP_COUNT_CONTROL_RESET);
@@ -73,7 +73,7 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 	cx_set(VID_CAPTURE_CONTROL, 0x18);
 
 	/* start dma */
-	cx_set(MO_DEV_CNTRL2, (1<<5));
+	cx_set(MO_DEV_CNTRL2, (1 << 5));
 	cx_set(MO_VID_DMACNTRL, 0x88);
 
 	return 0;
@@ -112,8 +112,8 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 /* ------------------------------------------------------------------ */
 
 static int queue_setup(struct vb2_queue *q,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], struct device *alloc_devs[])
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
 
@@ -125,7 +125,6 @@ static int queue_setup(struct vb2_queue *q,
 	return 0;
 }
 
-
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 797d5d0a4060..c7d4e87ccb64 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -73,7 +73,6 @@ MODULE_PARM_DESC(irq_debug, "enable debug messages [IRQ handler]");
 			__func__, ##arg);			\
 } while (0)
 
-
 /* ------------------------------------------------------------------- */
 /* static data                                                         */
 
@@ -123,7 +122,8 @@ static const struct cx8800_fmt formats[] = {
 	}, {
 		.name     = "32 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB32,
-		.cxformat = ColorFormatRGB32 | ColorFormatBSWAP | ColorFormatWSWAP,
+		.cxformat = ColorFormatRGB32 | ColorFormatBSWAP |
+			    ColorFormatWSWAP,
 		.depth    = 32,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
@@ -147,7 +147,7 @@ static const struct cx8800_fmt *format_by_fourcc(unsigned int fourcc)
 
 	for (i = 0; i < ARRAY_SIZE(formats); i++)
 		if (formats[i].fourcc == fourcc)
-			return formats+i;
+			return formats + i;
 	return NULL;
 }
 
@@ -221,8 +221,10 @@ static const struct cx88_ctrl cx8800_vid_ctls[] = {
 		.step          = 1,
 		.default_value = 0x0,
 		.off           = 0,
-		/* NOTE: the value is converted and written to both even
-		   and odd registers in the code */
+		/*
+		 * NOTE: the value is converted and written to both even
+		 * and odd registers in the code
+		 */
 		.reg           = MO_FILTER_ODD,
 		.mask          = 7 << 7,
 		.shift         = 7,
@@ -326,19 +328,25 @@ int cx88_video_mux(struct cx88_core *core, unsigned int input)
 		break;
 	}
 
-	/* if there are audioroutes defined, we have an external
-	   ADC to deal with audio */
+	/*
+	 * if there are audioroutes defined, we have an external
+	 * ADC to deal with audio
+	 */
 	if (INPUT(input).audioroute) {
-		/* The wm8775 module has the "2" route hardwired into
-		   the initialization. Some boards may use different
-		   routes for different inputs. HVR-1300 surely does */
+		/*
+		 * The wm8775 module has the "2" route hardwired into
+		 * the initialization. Some boards may use different
+		 * routes for different inputs. HVR-1300 surely does
+		 */
 		if (core->sd_wm8775) {
 			call_all(core, audio, s_routing,
 				 INPUT(input).audioroute, 0, 0);
 		}
-		/* cx2388's C-ADC is connected to the tuner only.
-		   When used with S-Video, that ADC is busy dealing with
-		   chroma, so an external must be used for baseband audio */
+		/*
+		 * cx2388's C-ADC is connected to the tuner only.
+		 * When used with S-Video, that ADC is busy dealing with
+		 * chroma, so an external must be used for baseband audio
+		 */
 		if (INPUT(input).type != CX88_VMUX_TELEVISION &&
 		    INPUT(input).type != CX88_VMUX_CABLE) {
 			/* "I2S ADC mode" */
@@ -376,12 +384,13 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	/* enable irqs */
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask | PCI_INT_VIDINT);
 
-	/* Enables corresponding bits at PCI_INT_STAT:
-		bits 0 to 4: video, audio, transport stream, VIP, Host
-		bit 7: timer
-		bits 8 and 9: DMA complete for: SRC, DST
-		bits 10 and 11: BERR signal asserted for RISC: RD, WR
-		bits 12 to 15: BERR signal asserted for: BRDG, SRC, DST, IPB
+	/*
+	 * Enables corresponding bits at PCI_INT_STAT:
+	 *	bits 0 to 4: video, audio, transport stream, VIP, Host
+	 *	bit 7: timer
+	 *	bits 8 and 9: DMA complete for: SRC, DST
+	 *	bits 10 and 11: BERR signal asserted for RISC: RD, WR
+	 *	bits 12 to 15: BERR signal asserted for: BRDG, SRC, DST, IPB
 	 */
 	cx_set(MO_VID_INTMSK, 0x0f0011);
 
@@ -389,7 +398,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	cx_set(VID_CAPTURE_CONTROL, 0x06);
 
 	/* start dma */
-	cx_set(MO_DEV_CNTRL2, (1<<5));
+	cx_set(MO_DEV_CNTRL2, (1 << 5));
 	cx_set(MO_VID_DMACNTRL, 0x11); /* Planar Y and packed FIFO and RISC enable */
 
 	return 0;
@@ -430,8 +439,8 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 /* ------------------------------------------------------------------ */
 
 static int queue_setup(struct vb2_queue *q,
-			   unsigned int *num_buffers, unsigned int *num_planes,
-			   unsigned int sizes[], struct device *alloc_devs[])
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct cx8800_dev *dev = q->drv_priv;
 	struct cx88_core *core = dev->core;
@@ -488,7 +497,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 				 core->height >> 1);
 		break;
 	}
-	dprintk(2, "[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
+	dprintk(2,
+		"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.vb2_buf.index,
 		core->width, core->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
@@ -595,7 +605,7 @@ static int radio_open(struct file *file)
 	if (core->board.radio.audioroute) {
 		if (core->sd_wm8775) {
 			call_all(core, audio, s_routing,
-					core->board.radio.audioroute, 0, 0);
+				 core->board.radio.audioroute, 0, 0);
 		}
 		/* "I2S ADC mode" */
 		core->tvaudio = WW_I2SADC;
@@ -649,9 +659,10 @@ static int cx8800_s_vid_ctrl(struct v4l2_ctrl *ctrl)
 		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
 		break;
 	}
-	dprintk(1, "set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
-				ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
-				mask, cc->sreg ? " [shadowed]" : "");
+	dprintk(1,
+		"set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
+		ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
+		mask, cc->sreg ? " [shadowed]" : "");
 	if (cc->sreg)
 		cx_sandor(cc->sreg, cc->reg, mask, value);
 	else
@@ -687,7 +698,8 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 	mask = cc->mask;
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_BALANCE:
-		value = (ctrl->val < 0x40) ? (0x7f - ctrl->val) : (ctrl->val - 0x40);
+		value = (ctrl->val < 0x40) ?
+			(0x7f - ctrl->val) : (ctrl->val - 0x40);
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
 		value = 0x3f - (ctrl->val & 0x3f);
@@ -696,9 +708,10 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
 		break;
 	}
-	dprintk(1, "set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
-				ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
-				mask, cc->sreg ? " [shadowed]" : "");
+	dprintk(1,
+		"set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
+		ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
+		mask, cc->sreg ? " [shadowed]" : "");
 	if (cc->sreg)
 		cx_sandor(cc->sreg, cc->reg, mask, value);
 	else
@@ -710,7 +723,7 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 /* VIDEO IOCTLS                                                       */
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-					struct v4l2_format *f)
+				struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -728,7 +741,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-			struct v4l2_format *f)
+				  struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -737,7 +750,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	unsigned int      maxw, maxh;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-	if (fmt == NULL)
+	if (!fmt)
 		return -EINVAL;
 
 	maxw = norm_maxw(core->tvnorm);
@@ -774,7 +787,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-					struct v4l2_format *f)
+				struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -794,7 +807,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 }
 
 void cx88_querycap(struct file *file, struct cx88_core *core,
-		struct v4l2_capability *cap)
+		   struct v4l2_capability *cap)
 {
 	struct video_device *vdev = video_devdata(file);
 
@@ -821,7 +834,7 @@ void cx88_querycap(struct file *file, struct cx88_core *core,
 EXPORT_SYMBOL(cx88_querycap);
 
 static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *cap)
+			   struct v4l2_capability *cap)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -833,7 +846,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 }
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
-					struct v4l2_fmtdesc *f)
+				   struct v4l2_fmtdesc *f)
 {
 	if (unlikely(f->index >= ARRAY_SIZE(formats)))
 		return -EINVAL;
@@ -879,21 +892,21 @@ int cx88_enum_input(struct cx88_core  *core, struct v4l2_input *i)
 
 	if (n >= 4)
 		return -EINVAL;
-	if (0 == INPUT(n).type)
+	if (!INPUT(n).type)
 		return -EINVAL;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n).type]);
-	if ((CX88_VMUX_TELEVISION == INPUT(n).type) ||
-	    (CX88_VMUX_CABLE      == INPUT(n).type)) {
+	if ((INPUT(n).type == CX88_VMUX_TELEVISION) ||
+	    (INPUT(n).type == CX88_VMUX_CABLE))
 		i->type = V4L2_INPUT_TYPE_TUNER;
-	}
+
 	i->std = CX88_NORMS;
 	return 0;
 }
 EXPORT_SYMBOL(cx88_enum_input);
 
 static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *i)
+			     struct v4l2_input *i)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -917,7 +930,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 	if (i >= 4)
 		return -EINVAL;
-	if (0 == INPUT(i).type)
+	if (!INPUT(i).type)
 		return -EINVAL;
 
 	cx88_newstation(core);
@@ -926,7 +939,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+			  struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -944,12 +957,12 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 	cx88_get_stereo(core, t);
 	reg = cx_read(MO_DEVICE_STATUS);
-	t->signal = (reg & (1<<5)) ? 0xffff : 0x0000;
+	t->signal = (reg & (1 << 5)) ? 0xffff : 0x0000;
 	return 0;
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				const struct v4l2_tuner *t)
+			  const struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -964,7 +977,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+			      struct v4l2_frequency *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -982,7 +995,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 int cx88_set_freq(struct cx88_core  *core,
-				const struct v4l2_frequency *f)
+		  const struct v4l2_frequency *f)
 {
 	struct v4l2_frequency new_freq = *f;
 
@@ -1005,7 +1018,7 @@ int cx88_set_freq(struct cx88_core  *core,
 EXPORT_SYMBOL(cx88_set_freq);
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				const struct v4l2_frequency *f)
+			      const struct v4l2_frequency *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -1015,7 +1028,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register(struct file *file, void *fh,
-				struct v4l2_dbg_register *reg)
+			     struct v4l2_dbg_register *reg)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -1027,7 +1040,7 @@ static int vidioc_g_register(struct file *file, void *fh,
 }
 
 static int vidioc_s_register(struct file *file, void *fh,
-				const struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -1042,7 +1055,7 @@ static int vidioc_s_register(struct file *file, void *fh,
 /* ----------------------------------------------------------- */
 
 static int radio_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+			 struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -1057,7 +1070,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 }
 
 static int radio_s_tuner(struct file *file, void *priv,
-				const struct v4l2_tuner *t)
+			 const struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -1152,7 +1165,6 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
 /* exported stuff                                              */
 
 static const struct v4l2_file_operations video_fops = {
-
 	.owner	       = THIS_MODULE,
 	.open	       = v4l2_fh_open,
 	.release       = vb2_fop_release,
@@ -1232,7 +1244,6 @@ static const struct video_device cx8800_vbi_template = {
 };
 
 static const struct v4l2_file_operations radio_fops = {
-
 	.owner         = THIS_MODULE,
 	.open          = radio_open,
 	.poll          = v4l2_ctrl_poll,
@@ -1287,7 +1298,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	int i;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL)
+	if (!dev)
 		return -ENOMEM;
 
 	/* pci init */
@@ -1297,7 +1308,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		goto fail_free;
 	}
 	core = cx88_core_get(dev->pci);
-	if (core == NULL) {
+	if (!core) {
 		err = -EINVAL;
 		goto fail_free;
 	}
@@ -1341,8 +1352,9 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		struct v4l2_ctrl *vc;
 
 		vc = v4l2_ctrl_new_std(&core->audio_hdl, &cx8800_ctrl_aud_ops,
-			cc->id, cc->minimum, cc->maximum, cc->step, cc->default_value);
-		if (vc == NULL) {
+				       cc->id, cc->minimum, cc->maximum,
+				       cc->step, cc->default_value);
+		if (!vc) {
 			err = core->audio_hdl.error;
 			goto fail_core;
 		}
@@ -1354,8 +1366,9 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		struct v4l2_ctrl *vc;
 
 		vc = v4l2_ctrl_new_std(&core->video_hdl, &cx8800_ctrl_vid_ops,
-			cc->id, cc->minimum, cc->maximum, cc->step, cc->default_value);
-		if (vc == NULL) {
+				       cc->id, cc->minimum, cc->maximum,
+				       cc->step, cc->default_value);
+		if (!vc) {
 			err = core->video_hdl.error;
 			goto fail_core;
 		}
@@ -1381,18 +1394,20 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 			core->wm8775_data.is_nova_s = false;
 
 		sd = v4l2_i2c_new_subdev_board(&core->v4l2_dev, &core->i2c_adap,
-				&wm8775_info, NULL);
-		if (sd != NULL) {
+					       &wm8775_info, NULL);
+		if (sd) {
 			core->sd_wm8775 = sd;
 			sd->grp_id = WM8775_GID;
 		}
 	}
 
 	if (core->board.audio_chip == CX88_AUDIO_TVAUDIO) {
-		/* This probes for a tda9874 as is used on some
-		   Pixelview Ultra boards. */
+		/*
+		 * This probes for a tda9874 as is used on some
+		 * Pixelview Ultra boards.
+		 */
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"tvaudio", 0, I2C_ADDRS(0xb0 >> 1));
+				    "tvaudio", 0, I2C_ADDRS(0xb0 >> 1));
 	}
 
 	switch (core->boardnr) {
@@ -1504,7 +1519,8 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* start tvaudio thread */
 	if (core->board.tuner_type != UNSET) {
-		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
+		core->kthread = kthread_run(cx88_audio_thread,
+					    core, "cx88 tvaudio");
 		if (IS_ERR(core->kthread)) {
 			err = PTR_ERR(core->kthread);
 			pr_err("failed to create cx88 audio thread, err=%d\n",
@@ -1581,7 +1597,8 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	cx88_shutdown(core);
 
 	pci_save_state(pci_dev);
-	if (pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state)) != 0) {
+	if (pci_set_power_state(pci_dev,
+				pci_choose_state(pci_dev, state)) != 0) {
 		pci_disable_device(pci_dev);
 		dev->state.disabled = 1;
 	}
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
index eea56ae9071e..92876de3841c 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
@@ -22,8 +22,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 MODULE_DESCRIPTION("driver for cx2388x VP3054 design");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -108,7 +107,7 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 		return 0;
 
 	vp3054_i2c = kzalloc(sizeof(*vp3054_i2c), GFP_KERNEL);
-	if (vp3054_i2c == NULL)
+	if (!vp3054_i2c)
 		return -ENOMEM;
 	dev->vp3054 = vp3054_i2c;
 
@@ -135,18 +134,17 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 
 	return rc;
 }
+EXPORT_SYMBOL(vp3054_i2c_probe);
 
 void vp3054_i2c_remove(struct cx8802_dev *dev)
 {
 	struct vp3054_i2c_state *vp3054_i2c = dev->vp3054;
 
-	if (vp3054_i2c == NULL ||
+	if (!vp3054_i2c ||
 	    dev->core->boardnr != CX88_BOARD_DNTV_LIVE_DVB_T_PRO)
 		return;
 
 	i2c_del_adapter(&vp3054_i2c->adap);
 	kfree(vp3054_i2c);
 }
-
-EXPORT_SYMBOL(vp3054_i2c_probe);
 EXPORT_SYMBOL(vp3054_i2c_remove);
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.h b/drivers/media/pci/cx88/cx88-vp3054-i2c.h
index 95d0c60a35e1..ec19bea8f1e2 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.h
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.h
@@ -1,26 +1,20 @@
 /*
-
-    cx88-vp3054-i2c.h  --  support for the secondary I2C bus of the
-			   DNTV Live! DVB-T Pro (VP-3054), wired as:
-			   GPIO[0] -> SCL, GPIO[1] -> SDA
-
-    (c) 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-*/
+ * cx88-vp3054-i2c.h  --  support for the secondary I2C bus of the
+ *			  DNTV Live! DVB-T Pro (VP-3054), wired as:
+ *			  GPIO[0] -> SCL, GPIO[1] -> SDA
+ *
+ * (c) 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
 
 /* ----------------------------------------------------------------------- */
 struct vp3054_i2c_state {
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index ac1fb9fb340e..115414cf520f 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -1,5 +1,4 @@
 /*
- *
  * v4l2 device driver for cx2388x based TV cards
  *
  * (c) 2003,04 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
@@ -99,7 +98,6 @@ static inline unsigned int norm_maxw(v4l2_std_id norm)
 	return 720;
 }
 
-
 static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_525_60) ? 480 : 576;
@@ -141,6 +139,7 @@ struct sram_channel {
 	u32  cnt1_reg;
 	u32  cnt2_reg;
 };
+
 extern const struct sram_channel cx88_sram_channels[];
 
 /* ----------------------------------------------------------- */
@@ -384,8 +383,8 @@ struct cx88_core {
 	/* state info */
 	struct task_struct         *kthread;
 	v4l2_std_id                tvnorm;
-	unsigned int width, height;
-	unsigned int field;
+	unsigned int		   width, height;
+	unsigned int		   field;
 	enum cx88_tvaudio          tvaudio;
 	u32                        audiomode_manual;
 	u32                        audiomode_current;
@@ -428,7 +427,8 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 		if (!core->i2c_rc) {				\
 			if (core->gate_ctrl)			\
 				core->gate_ctrl(core, 1);	\
-			v4l2_device_call_all(&core->v4l2_dev, grpid, o, f, ##args); \
+			v4l2_device_call_all(&core->v4l2_dev,	\
+					     grpid, o, f, ##args); \
 			if (core->gate_ctrl)			\
 				core->gate_ctrl(core, 0);	\
 		}						\
@@ -439,31 +439,31 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 #define WM8775_GID      (1 << 0)
 
 #define wm8775_s_ctrl(core, id, val) \
-	do {									\
-		struct v4l2_ctrl *ctrl_ =					\
-			v4l2_ctrl_find(core->sd_wm8775->ctrl_handler, id);	\
-		if (ctrl_ && !core->i2c_rc) {					\
-			if (core->gate_ctrl)					\
-				core->gate_ctrl(core, 1);			\
-			v4l2_ctrl_s_ctrl(ctrl_, val);				\
-			if (core->gate_ctrl)					\
-				core->gate_ctrl(core, 0);			\
-		}								\
+	do {								\
+		struct v4l2_ctrl *ctrl_ =				\
+			v4l2_ctrl_find(core->sd_wm8775->ctrl_handler, id);\
+		if (ctrl_ && !core->i2c_rc) {				\
+			if (core->gate_ctrl)				\
+				core->gate_ctrl(core, 1);		\
+			v4l2_ctrl_s_ctrl(ctrl_, val);			\
+			if (core->gate_ctrl)				\
+				core->gate_ctrl(core, 0);		\
+		}							\
 	} while (0)
 
 #define wm8775_g_ctrl(core, id) \
-	({									\
-		struct v4l2_ctrl *ctrl_ =					\
-			v4l2_ctrl_find(core->sd_wm8775->ctrl_handler, id);	\
-		s32 val = 0;							\
-		if (ctrl_ && !core->i2c_rc) {					\
-			if (core->gate_ctrl)					\
-				core->gate_ctrl(core, 1);			\
-			val = v4l2_ctrl_g_ctrl(ctrl_);				\
-			if (core->gate_ctrl)					\
-				core->gate_ctrl(core, 0);			\
-		}								\
-		val;								\
+	({								\
+		struct v4l2_ctrl *ctrl_ =				\
+			v4l2_ctrl_find(core->sd_wm8775->ctrl_handler, id);\
+		s32 val = 0;						\
+		if (ctrl_ && !core->i2c_rc) {				\
+			if (core->gate_ctrl)				\
+				core->gate_ctrl(core, 1);		\
+			val = v4l2_ctrl_g_ctrl(ctrl_);			\
+			if (core->gate_ctrl)				\
+				core->gate_ctrl(core, 0);		\
+		}							\
+		val;							\
 	})
 
 /* ----------------------------------------------------------- */
@@ -505,7 +505,6 @@ struct cx8800_dev {
 /* function 1: audio/alsa stuff                                */
 /* =============> moved to cx88-alsa.c <====================== */
 
-
 /* ----------------------------------------------------------- */
 /* function 2: mpeg stuff                                      */
 
@@ -567,6 +566,7 @@ struct cx8802_dev {
 
 	/* mpeg params */
 	struct cx2341x_handler     cxhdl;
+
 #endif
 
 #if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
@@ -589,40 +589,42 @@ struct cx8802_dev {
 
 /* ----------------------------------------------------------- */
 
-#define cx_read(reg)             readl(core->lmmio + ((reg)>>2))
-#define cx_write(reg, value)      writel((value), core->lmmio + ((reg)>>2))
-#define cx_writeb(reg, value)     writeb((value), core->bmmio + (reg))
+#define cx_read(reg)             readl(core->lmmio + ((reg) >> 2))
+#define cx_write(reg, value)     writel((value), core->lmmio + ((reg) >> 2))
+#define cx_writeb(reg, value)    writeb((value), core->bmmio + (reg))
 
 #define cx_andor(reg, mask, value) \
-  writel((readl(core->lmmio+((reg)>>2)) & ~(mask)) |\
-  ((value) & (mask)), core->lmmio+((reg)>>2))
-#define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
-#define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)
+	writel((readl(core->lmmio + ((reg) >> 2)) & ~(mask)) |\
+	((value) & (mask)), core->lmmio + ((reg) >> 2))
+#define cx_set(reg, bit)         cx_andor((reg), (bit), (bit))
+#define cx_clear(reg, bit)       cx_andor((reg), (bit), 0)
 
 #define cx_wait(d) { if (need_resched()) schedule(); else udelay(d); }
 
 /* shadow registers */
 #define cx_sread(sreg)		    (core->shadow[sreg])
 #define cx_swrite(sreg, reg, value) \
-  (core->shadow[sreg] = value, \
-   writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
+	(core->shadow[sreg] = value, \
+	writel(core->shadow[sreg], core->lmmio + ((reg) >> 2)))
 #define cx_sandor(sreg, reg, mask, value) \
-  (core->shadow[sreg] = (core->shadow[sreg] & ~(mask)) | ((value) & (mask)), \
-   writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
+	(core->shadow[sreg] = (core->shadow[sreg] & ~(mask)) | \
+			       ((value) & (mask)), \
+				writel(core->shadow[sreg], \
+				       core->lmmio + ((reg) >> 2)))
 
 /* ----------------------------------------------------------- */
 /* cx88-core.c                                                 */
 
 extern unsigned int cx88_core_debug;
 
-extern void cx88_print_irqbits(const char *tag, const char *strings[],
-			       int len, u32 bits, u32 mask);
+void cx88_print_irqbits(const char *tag, const char *strings[],
+			int len, u32 bits, u32 mask);
 
-extern int cx88_core_irq(struct cx88_core *core, u32 status);
-extern void cx88_wakeup(struct cx88_core *core,
-			struct cx88_dmaqueue *q, u32 count);
-extern void cx88_shutdown(struct cx88_core *core);
-extern int cx88_reset(struct cx88_core *core);
+int cx88_core_irq(struct cx88_core *core, u32 status);
+void cx88_wakeup(struct cx88_core *core,
+		 struct cx88_dmaqueue *q, u32 count);
+void cx88_shutdown(struct cx88_core *core);
+int cx88_reset(struct cx88_core *core);
 
 extern int
 cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
@@ -634,43 +636,37 @@ cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 		     struct scatterlist *sglist, unsigned int bpl,
 		     unsigned int lines, unsigned int lpi);
 
-extern void cx88_risc_disasm(struct cx88_core *core,
-			     struct cx88_riscmem *risc);
-extern int cx88_sram_channel_setup(struct cx88_core *core,
-				   const struct sram_channel *ch,
-				   unsigned int bpl, u32 risc);
-extern void cx88_sram_channel_dump(struct cx88_core *core,
-				   const struct sram_channel *ch);
+void cx88_risc_disasm(struct cx88_core *core,
+		      struct cx88_riscmem *risc);
+int cx88_sram_channel_setup(struct cx88_core *core,
+			    const struct sram_channel *ch,
+			    unsigned int bpl, u32 risc);
+void cx88_sram_channel_dump(struct cx88_core *core,
+			    const struct sram_channel *ch);
 
-extern int cx88_set_scale(struct cx88_core *core, unsigned int width,
-			  unsigned int height, enum v4l2_field field);
-extern int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm);
+int cx88_set_scale(struct cx88_core *core, unsigned int width,
+		   unsigned int height, enum v4l2_field field);
+int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm);
 
-extern void cx88_vdev_init(struct cx88_core *core,
-			   struct pci_dev *pci,
-			   struct video_device *vfd,
-			   const struct video_device *template_,
-			   const char *type);
-extern struct cx88_core *cx88_core_get(struct pci_dev *pci);
-extern void cx88_core_put(struct cx88_core *core,
-			  struct pci_dev *pci);
-
-extern int cx88_start_audio_dma(struct cx88_core *core);
-extern int cx88_stop_audio_dma(struct cx88_core *core);
+void cx88_vdev_init(struct cx88_core *core,
+		    struct pci_dev *pci,
+		    struct video_device *vfd,
+		    const struct video_device *template_,
+		    const char *type);
+struct cx88_core *cx88_core_get(struct pci_dev *pci);
+void cx88_core_put(struct cx88_core *core,
+		   struct pci_dev *pci);
 
+int cx88_start_audio_dma(struct cx88_core *core);
+int cx88_stop_audio_dma(struct cx88_core *core);
 
 /* ----------------------------------------------------------- */
 /* cx88-vbi.c                                                  */
 
 /* Can be used as g_vbi_fmt, try_vbi_fmt and s_vbi_fmt */
 int cx8800_vbi_fmt(struct file *file, void *priv,
-					struct v4l2_format *f);
+		   struct v4l2_format *f);
 
-/*
-int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
-			 struct cx88_dmaqueue *q,
-			 struct cx88_buffer   *buf);
-*/
 void cx8800_stop_vbi_dma(struct cx8800_dev *dev);
 int cx8800_restart_vbi_queue(struct cx8800_dev *dev, struct cx88_dmaqueue *q);
 
@@ -679,17 +675,16 @@ extern const struct vb2_ops cx8800_vbi_qops;
 /* ----------------------------------------------------------- */
 /* cx88-i2c.c                                                  */
 
-extern int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci);
-
+int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci);
 
 /* ----------------------------------------------------------- */
 /* cx88-cards.c                                                */
 
-extern int cx88_tuner_callback(void *dev, int component, int command, int arg);
-extern int cx88_get_resources(const struct cx88_core *core,
-			      struct pci_dev *pci);
-extern struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr);
-extern void cx88_setup_xc3028(struct cx88_core *core, struct xc2028_ctrl *ctl);
+int cx88_tuner_callback(void *dev, int component, int command, int arg);
+int cx88_get_resources(const struct cx88_core *core,
+		       struct pci_dev *pci);
+struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr);
+void cx88_setup_xc3028(struct cx88_core *core, struct xc2028_ctrl *ctl);
 
 /* ----------------------------------------------------------- */
 /* cx88-tvaudio.c                                              */
@@ -720,18 +715,18 @@ int cx88_ir_fini(struct cx88_core *core);
 void cx88_ir_irq(struct cx88_core *core);
 int cx88_ir_start(struct cx88_core *core);
 void cx88_ir_stop(struct cx88_core *core);
-extern void cx88_i2c_init_ir(struct cx88_core *core);
+void cx88_i2c_init_ir(struct cx88_core *core);
 
 /* ----------------------------------------------------------- */
 /* cx88-mpeg.c                                                 */
 
 int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
-			struct cx88_buffer *buf);
+		       struct cx88_buffer *buf);
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf);
 void cx8802_cancel_buffers(struct cx8802_dev *dev);
 int cx8802_start_dma(struct cx8802_dev    *dev,
-			    struct cx88_dmaqueue *q,
-			    struct cx88_buffer   *buf);
+		     struct cx88_dmaqueue *q,
+		     struct cx88_buffer   *buf);
 
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
@@ -739,6 +734,6 @@ int cx88_enum_input(struct cx88_core *core, struct v4l2_input *i);
 int cx88_set_freq(struct cx88_core  *core, const struct v4l2_frequency *f);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
 void cx88_querycap(struct file *file, struct cx88_core *core,
-		struct v4l2_capability *cap);
+		   struct v4l2_capability *cap);
 
 #endif
-- 
2.7.4

