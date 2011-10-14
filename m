Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1JNTwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 15:52:15 -0400
Message-ID: <4E9892E7.9030602@infradead.org>
Date: Fri, 14 Oct 2011 16:52:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Mijhail Moreyra <mijhail.moreyra@gmail.com>,
	Abylai Ospan <aospan@netup.ru>
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
References: <201110101752.11536.liplianin@me.by>
In-Reply-To: <201110101752.11536.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-10-2011 11:52, Igor M. Liplianin escreveu:
> Hi Mauro and Steven,
> 
> It's been a long time since cx23885-alsa pull was requested.
> To speed things up I created a git branch where I put the patches.
> Some patches merged, like introduce then correct checkpatch compliance
> or convert spinlock to mutex and back to spinlock, insert printk then remove printk as well.
> Minor corrections from me was silently merged, for major I created additional patches.
> 
> Hope it helps.

This patchset breaks git bisect. I tried to change the order of the initial patches, but
I couldn't an order of applying therm without breaking compilation.

The solution is to merge the first 6 patches into one. 

Igor, Steven,

Could you both ack with this, please?

Thanks!
Mauro.


>From 9e44d63246a9c884900e56e2aa16fba94dee5f0c Mon Sep 17 00:00:00 2001
From: Mijhail Moreyra <mijhail.moreyra@gmail.com>
Date: Mon, 10 Oct 2011 11:09:52 -0300
Subject: [PATCH] [media] cx23885: Add ALSA support

[stoth@kernellabs.com: add it to the makefile and fix snd_card binding]
[liplianin@netup.ru: videobuf: Remove the videobuf_sg_dma_map/unmap functions]

Signed-off-by: Mijhail Moreyra <mijhail.moreyra@gmail.com>
Signed-off-by: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index 185cc01..f81f279 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -2,7 +2,7 @@ cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 		    cx23885-core.o cx23885-i2c.o cx23885-dvb.o cx23885-417.o \
 		    cx23885-ioctl.o cx23885-ir.o cx23885-av.o cx23885-input.o \
 		    cx23888-ir.o netup-init.o cimax2.o netup-eeprom.o \
-		    cx23885-f300.o
+		    cx23885-f300.o cx23885-alsa.o
 
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
diff --git a/drivers/media/video/cx23885/cx23885-alsa.c b/drivers/media/video/cx23885/cx23885-alsa.c
new file mode 100644
index 0000000..31a89b3
--- /dev/null
+++ b/drivers/media/video/cx23885/cx23885-alsa.c
@@ -0,0 +1,535 @@
+/*
+ *
+ *  Support for CX23885 analog audio capture
+ *
+ *    (c) 2008 Mijhail Moreyra <mijhail.moreyra@gmail.com>
+ *    Adapted from cx88-alsa.c
+ *    (c) 2009 Steven Toth <stoth@kernellabs.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/vmalloc.h>
+#include <linux/dma-mapping.h>
+#include <linux/pci.h>
+
+#include <asm/delay.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/control.h>
+#include <sound/initval.h>
+
+#include <sound/tlv.h>
+
+
+#include "cx23885.h"
+#include "cx23885-reg.h"
+
+#define AUDIO_SRAM_CHANNEL	SRAM_CH07
+
+#define dprintk(level, fmt, arg...)	if (audio_debug >= level) \
+	printk(KERN_INFO "%s/1: " fmt, chip->dev->name , ## arg)
+
+#define dprintk_core(level, fmt, arg...)	if (audio_debug >= level) \
+	printk(KERN_DEBUG "%s/1: " fmt, chip->dev->name , ## arg)
+
+/****************************************************************************
+			Module global static vars
+ ****************************************************************************/
+
+static unsigned int disable_analog_audio;
+module_param(disable_analog_audio, int, 0644);
+MODULE_PARM_DESC(disable_analog_audio, "disable analog audio ALSA driver");
+
+static unsigned int audio_debug;
+module_param(audio_debug, int, 0644);
+MODULE_PARM_DESC(audio_debug, "enable debug messages [analog audio]");
+
+/****************************************************************************
+			Board specific funtions
+ ****************************************************************************/
+
+/* Constants taken from cx88-reg.h */
+#define AUD_INT_DN_RISCI1       (1 <<  0)
+#define AUD_INT_UP_RISCI1       (1 <<  1)
+#define AUD_INT_RDS_DN_RISCI1   (1 <<  2)
+#define AUD_INT_DN_RISCI2       (1 <<  4) /* yes, 3 is skipped */
+#define AUD_INT_UP_RISCI2       (1 <<  5)
+#define AUD_INT_RDS_DN_RISCI2   (1 <<  6)
+#define AUD_INT_DN_SYNC         (1 << 12)
+#define AUD_INT_UP_SYNC         (1 << 13)
+#define AUD_INT_RDS_DN_SYNC     (1 << 14)
+#define AUD_INT_OPC_ERR         (1 << 16)
+#define AUD_INT_BER_IRQ         (1 << 20)
+#define AUD_INT_MCHG_IRQ        (1 << 21)
+#define GP_COUNT_CONTROL_RESET	0x3
+
+/*
+ * BOARD Specific: Sets audio DMA
+ */
+
+static int cx23885_start_audio_dma(struct cx23885_audio_dev *chip)
+{
+	struct cx23885_audio_buffer *buf = chip->buf;
+	struct cx23885_dev *dev  = chip->dev;
+	struct sram_channel *audio_ch =
+		&dev->sram_channels[AUDIO_SRAM_CHANNEL];
+
+	dprintk(1, "%s()\n", __func__);
+
+	/* Make sure RISC/FIFO are off before changing FIFO/RISC settings */
+	cx_clear(AUD_INT_DMA_CTL, 0x11);
+
+	/* setup fifo + format - out channel */
+	cx23885_sram_channel_setup(chip->dev, audio_ch, buf->bpl,
+		buf->risc.dma);
+
+	/* sets bpl size */
+	cx_write(AUD_INT_A_LNGTH, buf->bpl);
+
+	/* This is required to get good audio (1 seems to be ok) */
+	cx_write(AUD_INT_A_MODE, 1);
+
+	/* reset counter */
+	cx_write(AUD_INT_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);
+	atomic_set(&chip->count, 0);
+
+	dprintk(1, "Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d "
+		"byte buffer\n", buf->bpl, cx_read(audio_ch->cmds_start+12)>>1,
+		chip->num_periods, buf->bpl * chip->num_periods);
+
+	/* Enables corresponding bits at AUD_INT_STAT */
+	cx_write(AUDIO_INT_INT_MSK, AUD_INT_OPC_ERR | AUD_INT_DN_SYNC |
+				    AUD_INT_DN_RISCI1);
+
+	/* Clean any pending interrupt bits already set */
+	cx_write(AUDIO_INT_INT_STAT, ~0);
+
+	/* enable audio irqs */
+	cx_set(PCI_INT_MSK, chip->dev->pci_irqmask | PCI_MSK_AUD_INT);
+
+	/* start dma */
+	cx_set(DEV_CNTRL2, (1<<5)); /* Enables Risc Processor */
+	cx_set(AUD_INT_DMA_CTL, 0x11); /* audio downstream FIFO and
+					  RISC enable */
+	if (audio_debug)
+		cx23885_sram_channel_dump(chip->dev, audio_ch);
+
+	return 0;
+}
+
+/*
+ * BOARD Specific: Resets audio DMA
+ */
+static int cx23885_stop_audio_dma(struct cx23885_audio_dev *chip)
+{
+	struct cx23885_dev *dev = chip->dev;
+	dprintk(1, "Stopping audio DMA\n");
+
+	/* stop dma */
+	cx_clear(AUD_INT_DMA_CTL, 0x11);
+
+	/* disable irqs */
+	cx_clear(PCI_INT_MSK, PCI_MSK_AUD_INT);
+	cx_clear(AUDIO_INT_INT_MSK, AUD_INT_OPC_ERR | AUD_INT_DN_SYNC |
+				    AUD_INT_DN_RISCI1);
+
+	if (audio_debug)
+		cx23885_sram_channel_dump(chip->dev,
+			&dev->sram_channels[AUDIO_SRAM_CHANNEL]);
+
+	return 0;
+}
+
+/*
+ * BOARD Specific: Handles audio IRQ
+ */
+int cx23885_audio_irq(struct cx23885_dev *dev, u32 status, u32 mask)
+{
+	struct cx23885_audio_dev *chip = dev->audio_dev;
+
+	if (0 == (status & mask))
+		return 0;
+
+	cx_write(AUDIO_INT_INT_STAT, status);
+
+	/* risc op code error */
+	if (status & AUD_INT_OPC_ERR) {
+		printk(KERN_WARNING "%s/1: Audio risc op code error\n",
+			dev->name);
+		cx_clear(AUD_INT_DMA_CTL, 0x11);
+		cx23885_sram_channel_dump(dev,
+			&dev->sram_channels[AUDIO_SRAM_CHANNEL]);
+	}
+	if (status & AUD_INT_DN_SYNC) {
+		dprintk(1, "Downstream sync error\n");
+		cx_write(AUD_INT_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);
+		return 1;
+	}
+	/* risc1 downstream */
+	if (status & AUD_INT_DN_RISCI1) {
+		atomic_set(&chip->count, cx_read(AUD_INT_A_GPCNT));
+		snd_pcm_period_elapsed(chip->substream);
+	}
+	/* FIXME: Any other status should deserve a special handling? */
+
+	return 1;
+}
+
+static int dsp_buffer_free(struct cx23885_audio_dev *chip)
+{
+	BUG_ON(!chip->dma_size);
+
+	dprintk(2, "Freeing buffer\n");
+	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
+	videobuf_dma_free(chip->dma_risc);
+	btcx_riscmem_free(chip->pci, &chip->buf->risc);
+	kfree(chip->buf);
+
+	chip->dma_risc = NULL;
+	chip->dma_size = 0;
+
+	return 0;
+}
+
+/****************************************************************************
+				ALSA PCM Interface
+ ****************************************************************************/
+
+/*
+ * Digital hardware definition
+ */
+#define DEFAULT_FIFO_SIZE	4096
+
+static struct snd_pcm_hardware snd_cx23885_digital_hw = {
+	.info = SNDRV_PCM_INFO_MMAP |
+		SNDRV_PCM_INFO_INTERLEAVED |
+		SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_MMAP_VALID,
+	.formats = SNDRV_PCM_FMTBIT_S16_LE,
+
+	.rates =		SNDRV_PCM_RATE_48000,
+	.rate_min =		48000,
+	.rate_max =		48000,
+	.channels_min = 2,
+	.channels_max = 2,
+	/* Analog audio output will be full of clicks and pops if there
+	   are not exactly four lines in the SRAM FIFO buffer.  */
+	.period_bytes_min = DEFAULT_FIFO_SIZE/4,
+	.period_bytes_max = DEFAULT_FIFO_SIZE/4,
+	.periods_min = 1,
+	.periods_max = 1024,
+	.buffer_bytes_max = (1024*1024),
+};
+
+/*
+ * audio pcm capture open callback
+ */
+static int snd_cx23885_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int err;
+
+	if (!chip) {
+		printk(KERN_ERR "BUG: cx23885 can't find device struct."
+				" Can't proceed with open\n");
+		return -ENODEV;
+	}
+
+	err = snd_pcm_hw_constraint_pow2(runtime, 0,
+		SNDRV_PCM_HW_PARAM_PERIODS);
+	if (err < 0)
+		goto _error;
+
+	chip->substream = substream;
+
+	runtime->hw = snd_cx23885_digital_hw;
+
+	if (chip->dev->sram_channels[AUDIO_SRAM_CHANNEL].fifo_size !=
+		DEFAULT_FIFO_SIZE) {
+		unsigned int bpl = chip->dev->
+			sram_channels[AUDIO_SRAM_CHANNEL].fifo_size / 4;
+		bpl &= ~7; /* must be multiple of 8 */
+		runtime->hw.period_bytes_min = bpl;
+		runtime->hw.period_bytes_max = bpl;
+	}
+
+	return 0;
+_error:
+	dprintk(1, "Error opening PCM!\n");
+	return err;
+}
+
+/*
+ * audio close callback
+ */
+static int snd_cx23885_close(struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+/*
+ * hw_params callback
+ */
+static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
+			      struct snd_pcm_hw_params *hw_params)
+{
+	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
+	struct videobuf_dmabuf *dma;
+
+	struct cx23885_audio_buffer *buf;
+	int ret;
+
+	if (substream->runtime->dma_area) {
+		dsp_buffer_free(chip);
+		substream->runtime->dma_area = NULL;
+	}
+
+	chip->period_size = params_period_bytes(hw_params);
+	chip->num_periods = params_periods(hw_params);
+	chip->dma_size = chip->period_size * params_periods(hw_params);
+
+	BUG_ON(!chip->dma_size);
+	BUG_ON(chip->num_periods & (chip->num_periods-1));
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (NULL == buf)
+		return -ENOMEM;
+
+	buf->bpl = chip->period_size;
+
+	dma = &buf->dma;
+	videobuf_dma_init(dma);
+	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
+			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
+	if (ret < 0)
+		goto error;
+
+	ret = videobuf_dma_map(&chip->pci->dev, dma);
+	if (ret < 0)
+		goto error;
+
+	ret = cx23885_risc_databuffer(chip->pci, &buf->risc, dma->sglist,
+				   chip->period_size, chip->num_periods, 1);
+	if (ret < 0)
+		goto error;
+
+	/* Loop back to start of program */
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP|RISC_IRQ1|RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
+	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
+
+	chip->buf = buf;
+	chip->dma_risc = dma;
+
+	substream->runtime->dma_area = chip->dma_risc->vaddr;
+	substream->runtime->dma_bytes = chip->dma_size;
+	substream->runtime->dma_addr = 0;
+
+	return 0;
+
+error:
+	kfree(buf);
+	return ret;
+}
+
+/*
+ * hw free callback
+ */
+static int snd_cx23885_hw_free(struct snd_pcm_substream *substream)
+{
+
+	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
+
+	if (substream->runtime->dma_area) {
+		dsp_buffer_free(chip);
+		substream->runtime->dma_area = NULL;
+	}
+
+	return 0;
+}
+
+/*
+ * prepare callback
+ */
+static int snd_cx23885_prepare(struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+/*
+ * trigger callback
+ */
+static int snd_cx23885_card_trigger(struct snd_pcm_substream *substream,
+	int cmd)
+{
+	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
+	int err;
+
+	/* Local interrupts are already disabled by ALSA */
+	spin_lock(&chip->lock);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		err = cx23885_start_audio_dma(chip);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+		err = cx23885_stop_audio_dma(chip);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	spin_unlock(&chip->lock);
+
+	return err;
+}
+
+/*
+ * pointer callback
+ */
+static snd_pcm_uframes_t snd_cx23885_pointer(
+	struct snd_pcm_substream *substream)
+{
+	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	u16 count;
+
+	count = atomic_read(&chip->count);
+
+	return runtime->period_size * (count & (runtime->periods-1));
+}
+
+/*
+ * page callback (needed for mmap)
+ */
+static struct page *snd_cx23885_page(struct snd_pcm_substream *substream,
+				unsigned long offset)
+{
+	void *pageptr = substream->runtime->dma_area + offset;
+	return vmalloc_to_page(pageptr);
+}
+
+/*
+ * operators
+ */
+static struct snd_pcm_ops snd_cx23885_pcm_ops = {
+	.open = snd_cx23885_pcm_open,
+	.close = snd_cx23885_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = snd_cx23885_hw_params,
+	.hw_free = snd_cx23885_hw_free,
+	.prepare = snd_cx23885_prepare,
+	.trigger = snd_cx23885_card_trigger,
+	.pointer = snd_cx23885_pointer,
+	.page = snd_cx23885_page,
+};
+
+/*
+ * create a PCM device
+ */
+static int snd_cx23885_pcm(struct cx23885_audio_dev *chip, int device,
+	char *name)
+{
+	int err;
+	struct snd_pcm *pcm;
+
+	err = snd_pcm_new(chip->card, name, device, 0, 1, &pcm);
+	if (err < 0)
+		return err;
+	pcm->private_data = chip;
+	strcpy(pcm->name, name);
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_cx23885_pcm_ops);
+
+	return 0;
+}
+
+/****************************************************************************
+			Basic Flow for Sound Devices
+ ****************************************************************************/
+
+/*
+ * Alsa Constructor - Component probe
+ */
+
+struct cx23885_audio_dev *cx23885_audio_initdev(struct cx23885_dev *dev)
+{
+	struct snd_card *card;
+	struct cx23885_audio_dev *chip;
+	int err;
+
+	if (disable_analog_audio)
+		return NULL;
+
+	if (dev->sram_channels[AUDIO_SRAM_CHANNEL].cmds_start == 0) {
+		printk(KERN_WARNING "%s(): Missing SRAM channel configuration "
+			"for analog TV Audio\n", __func__);
+		return NULL;
+	}
+
+	err = snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			THIS_MODULE, sizeof(struct cx23885_audio_dev), &card);
+	if (err < 0)
+		goto error;
+
+	chip = (struct cx23885_audio_dev *) card->private_data;
+	chip->dev = dev;
+	chip->pci = dev->pci;
+	chip->card = card;
+	spin_lock_init(&chip->lock);
+
+	snd_card_set_dev(card, &dev->pci->dev);
+
+	err = snd_cx23885_pcm(chip, 0, "CX23885 Digital");
+	if (err < 0)
+		goto error;
+
+	strcpy(card->driver, "CX23885");
+	sprintf(card->shortname, "Conexant CX23885");
+	sprintf(card->longname, "%s at %s", card->shortname, dev->name);
+
+	err = snd_card_register(card);
+	if (err < 0)
+		goto error;
+
+	dprintk(0, "registered ALSA audio device\n");
+
+	return chip;
+
+error:
+	snd_card_free(card);
+	printk(KERN_ERR "%s(): Failed to register analog "
+			"audio adapter\n", __func__);
+
+	return NULL;
+}
+
+/*
+ * ALSA destructor
+ */
+void cx23885_audio_finidev(struct cx23885_dev *dev)
+{
+	struct cx23885_audio_dev *chip = dev->audio_dev;
+
+	snd_card_free(chip->card);
+}
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index ee41a88..d8dfa40 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -156,11 +156,12 @@ static struct sram_channel cx23885_sram_channels[] = {
 	},
 	[SRAM_CH07] = {
 		.name		= "ch7",
-		.cmds_start	= 0x0,
-		.ctrl_start	= 0x0,
-		.cdt		= 0x0,
-		.fifo_start	= 0x0,
-		.fifo_size	= 0x0,
+		.name		= "TV Audio",
+		.cmds_start	= 0x10190,
+		.ctrl_start	= 0x10480,
+		.cdt		= 0x10a00,
+		.fifo_start	= 0x7000,
+		.fifo_size	= 0x1000,
 		.ptr1_reg	= DMA6_PTR1,
 		.ptr2_reg	= DMA6_PTR2,
 		.cnt1_reg	= DMA6_CNT1,
@@ -1082,10 +1083,10 @@ static void cx23885_dev_unregister(struct cx23885_dev *dev)
 static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
 			       unsigned int offset, u32 sync_line,
 			       unsigned int bpl, unsigned int padding,
-			       unsigned int lines)
+			       unsigned int lines,  unsigned int lpi)
 {
 	struct scatterlist *sg;
-	unsigned int line, todo;
+	unsigned int line, todo, sol;
 
 	/* sync instruction */
 	if (sync_line != NO_SYNC_LINE)
@@ -1098,16 +1099,22 @@ static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
 			offset -= sg_dma_len(sg);
 			sg++;
 		}
+
+		if (lpi && line > 0 && !(line % lpi))
+			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
+		else
+			sol = RISC_SOL;
+
 		if (bpl <= sg_dma_len(sg)-offset) {
 			/* fits into current chunk */
-			*(rp++) = cpu_to_le32(RISC_WRITE|RISC_SOL|RISC_EOL|bpl);
+			*(rp++) = cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
 			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
 			*(rp++) = cpu_to_le32(0); /* bits 63-32 */
 			offset += bpl;
 		} else {
 			/* scanline needs to be split */
 			todo = bpl;
-			*(rp++) = cpu_to_le32(RISC_WRITE|RISC_SOL|
+			*(rp++) = cpu_to_le32(RISC_WRITE|sol|
 					    (sg_dma_len(sg)-offset));
 			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
 			*(rp++) = cpu_to_le32(0); /* bits 63-32 */
@@ -1164,10 +1171,10 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	rp = risc->cpu;
 	if (UNSET != top_offset)
 		rp = cx23885_risc_field(rp, sglist, top_offset, 0,
-					bpl, padding, lines);
+					bpl, padding, lines, 0);
 	if (UNSET != bottom_offset)
 		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x200,
-					bpl, padding, lines);
+					bpl, padding, lines, 0);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
@@ -1175,11 +1182,11 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	return 0;
 }
 
-static int cx23885_risc_databuffer(struct pci_dev *pci,
+int cx23885_risc_databuffer(struct pci_dev *pci,
 				   struct btcx_riscmem *risc,
 				   struct scatterlist *sglist,
 				   unsigned int bpl,
-				   unsigned int lines)
+				   unsigned int lines, unsigned int lpi)
 {
 	u32 instructions;
 	__le32 *rp;
@@ -1199,7 +1206,8 @@ static int cx23885_risc_databuffer(struct pci_dev *pci,
 
 	/* write risc instructions */
 	rp = risc->cpu;
-	rp = cx23885_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0, lines);
+	rp = cx23885_risc_field(rp, sglist, 0, NO_SYNC_LINE,
+				bpl, 0, lines, lpi);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
@@ -1517,7 +1525,7 @@ int cx23885_buf_prepare(struct videobuf_queue *q, struct cx23885_tsport *port,
 			goto fail;
 		cx23885_risc_databuffer(dev->pci, &buf->risc,
 					videobuf_to_dma(&buf->vb)->sglist,
-					buf->vb.width, buf->vb.height);
+					buf->vb.width, buf->vb.height, 0);
 	}
 	buf->vb.state = VIDEOBUF_PREPARED;
 	return 0;
@@ -1741,15 +1749,19 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 	struct cx23885_tsport *ts2 = &dev->ts2;
 	u32 pci_status, pci_mask;
 	u32 vida_status, vida_mask;
+	u32 audint_status, audint_mask;
 	u32 ts1_status, ts1_mask;
 	u32 ts2_status, ts2_mask;
 	int vida_count = 0, ts1_count = 0, ts2_count = 0, handled = 0;
+	int audint_count = 0;
 	bool subdev_handled;
 
 	pci_status = cx_read(PCI_INT_STAT);
 	pci_mask = cx23885_irq_get_mask(dev);
 	vida_status = cx_read(VID_A_INT_STAT);
 	vida_mask = cx_read(VID_A_INT_MSK);
+	audint_status = cx_read(AUDIO_INT_INT_STAT);
+	audint_mask = cx_read(AUDIO_INT_INT_MSK);
 	ts1_status = cx_read(VID_B_INT_STAT);
 	ts1_mask = cx_read(VID_B_INT_MSK);
 	ts2_status = cx_read(VID_C_INT_STAT);
@@ -1759,12 +1771,15 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 		goto out;
 
 	vida_count = cx_read(VID_A_GPCNT);
+	audint_count = cx_read(AUD_INT_A_GPCNT);
 	ts1_count = cx_read(ts1->reg_gpcnt);
 	ts2_count = cx_read(ts2->reg_gpcnt);
 	dprintk(7, "pci_status: 0x%08x  pci_mask: 0x%08x\n",
 		pci_status, pci_mask);
 	dprintk(7, "vida_status: 0x%08x vida_mask: 0x%08x count: 0x%x\n",
 		vida_status, vida_mask, vida_count);
+	dprintk(7, "audint_status: 0x%08x audint_mask: 0x%08x count: 0x%x\n",
+		audint_status, audint_mask, audint_count);
 	dprintk(7, "ts1_status: 0x%08x  ts1_mask: 0x%08x count: 0x%x\n",
 		ts1_status, ts1_mask, ts1_count);
 	dprintk(7, "ts2_status: 0x%08x  ts2_mask: 0x%08x count: 0x%x\n",
@@ -1861,6 +1876,9 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 	if (vida_status)
 		handled += cx23885_video_irq(dev, vida_status);
 
+	if (audint_status)
+		handled += cx23885_audio_irq(dev, audint_status, audint_mask);
+
 	if (pci_status & PCI_MSK_IR) {
 		subdev_handled = false;
 		v4l2_subdev_call(dev->sd_ir, core, interrupt_service_routine,
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index d86bc0b..abeba7a 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -318,6 +318,34 @@ struct cx23885_kernel_ir {
 	struct rc_dev		*rc;
 };
 
+struct cx23885_audio_buffer {
+	unsigned int		bpl;
+	struct btcx_riscmem	risc;
+	struct videobuf_dmabuf	dma;
+};
+
+struct cx23885_audio_dev {
+	struct cx23885_dev	*dev;
+
+	struct pci_dev		*pci;
+
+	struct snd_card		*card;
+
+	spinlock_t		lock;
+
+	atomic_t		count;
+
+	unsigned int		dma_size;
+	unsigned int		period_size;
+	unsigned int		num_periods;
+
+	struct videobuf_dmabuf	*dma_risc;
+
+	struct cx23885_audio_buffer   *buf;
+
+	struct snd_pcm_substream *substream;
+};
+
 struct cx23885_dev {
 	atomic_t                   refcount;
 	struct v4l2_device 	   v4l2_dev;
@@ -400,6 +428,9 @@ struct cx23885_dev {
 	atomic_t                   v4l_reader_count;
 	struct cx23885_tvnorm      encodernorm;
 
+	/* Analog raw audio */
+	struct cx23885_audio_dev   *audio_dev;
+
 };
 
 static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)
@@ -563,6 +594,17 @@ extern void mc417_gpio_set(struct cx23885_dev *dev, u32 mask);
 extern void mc417_gpio_clear(struct cx23885_dev *dev, u32 mask);
 extern void mc417_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput);
 
+/* ----------------------------------------------------------- */
+/* cx23885-alsa.c                                             */
+extern struct cx23885_audio_dev *cx23885_audio_initdev(struct cx23885_dev *dev);
+extern void cx23885_audio_finidev(struct cx23885_dev *dev);
+extern int cx23885_audio_irq(struct cx23885_dev *dev, u32 status, u32 mask);
+extern int cx23885_risc_databuffer(struct pci_dev *pci,
+				   struct btcx_riscmem *risc,
+				   struct scatterlist *sglist,
+				   unsigned int bpl,
+				   unsigned int lines,
+				   unsigned int lpi);
 
 /* ----------------------------------------------------------- */
 /* tv norms                                                    */
