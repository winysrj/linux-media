Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mijhail.moreyra@gmail.com>) id 1KY5EQ-0004KB-CB
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 22:33:39 +0200
Received: by ey-out-2122.google.com with SMTP id 25so372857eya.17
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 13:33:34 -0700 (PDT)
Message-ID: <48B4687D.8070205@gmail.com>
Date: Tue, 26 Aug 2008 15:33:01 -0500
From: Mijhail Moreyra <mijhail.moreyra@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] cx23885 analog TV and audio support for HVR-1500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

This patch adds analog TV support for the HVR-1500 which has a cx23885 
bridge and a xc3028 tuner but no MPEG encoder. It also adds support for 
ALSA audio capture.

There isn't digital TV in my country so I didn't test if it breaks 
digital mode.

Hope it will be useful for anyone interested.

Regards.
Mijhail Moreyra

-----------------------------------------------------------------------

diff -uprN old/linux/drivers/media/video/cx23885/cx23885-alsa.c 
new/linux/drivers/media/video/cx23885/cx23885-alsa.c
--- old/linux/drivers/media/video/cx23885/cx23885-alsa.c	1969-12-31 
19:00:00.000000000 -0500
+++ new/linux/drivers/media/video/cx23885/cx23885-alsa.c	2008-08-26 
15:00:38.386185324 -0500
@@ -0,0 +1,533 @@
+/*
+ *
+ *  Support for CX23885 analog audio capture
+ *
+ *    (c) 2008 Mijhail Moreyra <mijhail.moreyra@gmail.com>
+ *    Adapted from cx88-alsa.c
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
+#include "compat.h"
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/control.h>
+#include <sound/initval.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)
+#include <sound/tlv.h>
+#endif
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
+ 
****************************************************************************/
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
+ 
****************************************************************************/
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
+	struct cx23885_buffer *buf = chip->buf;
+	struct cx23885_dev *dev  = chip->dev;
+	struct sram_channel *audio_ch = &dev->sram_channels[AUDIO_SRAM_CHANNEL];
+
+	dprintk(1, "%s()\n", __func__);
+
+	/* Make sure RISC/FIFO are off before changing FIFO/RISC settings */
+	cx_clear(AUD_INT_DMA_CTL, 0x11);
+
+	/* setup fifo + format - out channel */
+	cx23885_sram_channel_setup(chip->dev, audio_ch, buf->bpl, buf->risc.dma);
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
+		printk(KERN_WARNING "%s/1: Audio risc op code error\n",	dev->name);
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
+	videobuf_sg_dma_unmap(&chip->pci->dev, chip->dma_risc);
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
+ 
****************************************************************************/
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
+	err = snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_PERIODS);
+	if (err < 0)
+		goto _error;
+
+	chip->substream = substream;
+
+	runtime->hw = snd_cx23885_digital_hw;
+
+	if (chip->dev->sram_channels[AUDIO_SRAM_CHANNEL].fifo_size != 
DEFAULT_FIFO_SIZE) {
+		unsigned int bpl = 
chip->dev->sram_channels[AUDIO_SRAM_CHANNEL].fifo_size / 4;
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
+	struct cx23885_buffer *buf;
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
+	buf = videobuf_sg_alloc(sizeof(*buf));
+	if (NULL == buf)
+		return -ENOMEM;
+
+	buf->vb.memory = V4L2_MEMORY_MMAP;
+	buf->vb.field  = V4L2_FIELD_NONE;
+	buf->vb.width  = chip->period_size;
+	buf->bpl       = chip->period_size;
+	buf->vb.height = chip->num_periods;
+	buf->vb.size   = chip->dma_size;
+
+	dma = videobuf_to_dma(&buf->vb);
+	videobuf_dma_init(dma);
+	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
+			(PAGE_ALIGN(buf->vb.size) >> PAGE_SHIFT));
+	if (ret < 0)
+		goto error;
+
+	ret = videobuf_sg_dma_map(&chip->pci->dev, dma);
+	if (ret < 0)
+		goto error;
+
+	ret = cx23885_risc_databuffer(chip->pci, &buf->risc, dma->sglist,
+				   buf->vb.width, buf->vb.height, 1);
+	if (ret < 0)
+		goto error;
+
+	/* Loop back to start of program */
+	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP|RISC_IRQ1|RISC_CNT_INC);
+	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
+	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
+
+	buf->vb.state = VIDEOBUF_PREPARED;
+
+	chip->buf = buf;
+	chip->dma_risc = dma;
+
+	substream->runtime->dma_area = chip->dma_risc->vmalloc;
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
+static int snd_cx23885_card_trigger(struct snd_pcm_substream 
*substream, int cmd)
+{
+	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
+	int err;
+
+	/* Local interrupts are already disabled by ALSA */
+	spin_lock(&chip->reg_lock);
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
+	spin_unlock(&chip->reg_lock);
+
+	return err;
+}
+
+/*
+ * pointer callback
+ */
+static snd_pcm_uframes_t snd_cx23885_pointer(struct snd_pcm_substream 
*substream)
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
char *name)
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
+ 
****************************************************************************/
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
+	card = snd_card_new(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			    THIS_MODULE, sizeof(struct cx23885_audio_dev));
+	if (!card)
+		goto error;
+
+	chip = (struct cx23885_audio_dev *) card->private_data;
+	chip->dev = dev;
+	chip->pci = dev->pci;
+	chip->card = card;
+	spin_lock_init(&chip->reg_lock);
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
+
diff -uprN old/linux/drivers/media/video/cx23885/cx23885-cards.c 
new/linux/drivers/media/video/cx23885/cx23885-cards.c
--- old/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-09 
07:21:15.000000000 -0500
+++ new/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-26 
14:40:47.316185717 -0500
@@ -131,7 +131,30 @@ struct cx23885_board cx23885_boards[] =
  	},
  	[CX23885_BOARD_HAUPPAUGE_HVR1500] = {
  		.name		= "Hauppauge WinTV-HVR1500",
+		.porta		= CX23885_ANALOG_VIDEO,
  		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_XC2028,
+		.tuner_addr	= 0x61, /* 0xc2 >> 1 */
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH2 |
+					CX25840_VIN2_CH1,
+			.gpio0  = 0,
+		},{
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN6_CH1,
+			.gpio0  = 0,
+		},{
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN4_CH2 |
+					CX25840_VIN8_CH1 |
+					CX25840_SVIDEO_ON,
+			.gpio0  = 0,
+		}},
  	},
  	[CX23885_BOARD_HAUPPAUGE_HVR1200] = {
  		.name		= "Hauppauge WinTV-HVR1200",
@@ -592,6 +615,7 @@ void cx23885_card_setup(struct cx23885_d
  	case CX23885_BOARD_HAUPPAUGE_HVR1800:
  	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
  	case CX23885_BOARD_HAUPPAUGE_HVR1700:
+	case CX23885_BOARD_HAUPPAUGE_HVR1500:
  		request_module("cx25840");
  		break;
  	}
diff -uprN old/linux/drivers/media/video/cx23885/cx23885-core.c 
new/linux/drivers/media/video/cx23885/cx23885-core.c
--- old/linux/drivers/media/video/cx23885/cx23885-core.c	2008-08-09 
07:21:15.000000000 -0500
+++ new/linux/drivers/media/video/cx23885/cx23885-core.c	2008-08-26 
15:03:38.149188305 -0500
@@ -151,12 +151,12 @@ static struct sram_channel cx23885_sram_
  		.cnt2_reg	= DMA5_CNT2,
  	},
  	[SRAM_CH07] = {
-		.name		= "ch7",
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
@@ -940,10 +940,10 @@ static void cx23885_dev_unregister(struc
  static __le32* cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
  			       unsigned int offset, u32 sync_line,
  			       unsigned int bpl, unsigned int padding,
-			       unsigned int lines)
+			       unsigned int lines, unsigned int lpi)
  {
  	struct scatterlist *sg;
-	unsigned int line, todo;
+	unsigned int line, todo, sol;

  	/* sync instruction */
  	if (sync_line != NO_SYNC_LINE)
@@ -956,16 +956,22 @@ static __le32* cx23885_risc_field(__le32
  			offset -= sg_dma_len(sg);
  			sg++;
  		}
+
+		if (lpi && line>0 && !(line % lpi))
+			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
+		else
+			sol = RISC_SOL;
+
  		if (bpl <= sg_dma_len(sg)-offset) {
  			/* fits into current chunk */
-			*(rp++)=cpu_to_le32(RISC_WRITE|RISC_SOL|RISC_EOL|bpl);
+			*(rp++)=cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
  			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
  			*(rp++)=cpu_to_le32(0); /* bits 63-32 */
  			offset+=bpl;
  		} else {
  			/* scanline needs to be split */
  			todo = bpl;
-			*(rp++)=cpu_to_le32(RISC_WRITE|RISC_SOL|
+			*(rp++)=cpu_to_le32(RISC_WRITE|sol|
  					    (sg_dma_len(sg)-offset));
  			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
  			*(rp++)=cpu_to_le32(0); /* bits 63-32 */
@@ -1020,10 +1026,10 @@ int cx23885_risc_buffer(struct pci_dev *
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
@@ -1031,11 +1037,12 @@ int cx23885_risc_buffer(struct pci_dev *
  	return 0;
  }

-static int cx23885_risc_databuffer(struct pci_dev *pci,
+int cx23885_risc_databuffer(struct pci_dev *pci,
  				   struct btcx_riscmem *risc,
  				   struct scatterlist *sglist,
  				   unsigned int bpl,
-				   unsigned int lines)
+				   unsigned int lines,
+				   unsigned int lpi)
  {
  	u32 instructions;
  	__le32 *rp;
@@ -1054,7 +1061,7 @@ static int cx23885_risc_databuffer(struc

  	/* write risc instructions */
  	rp = risc->cpu;
-	rp = cx23885_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0, lines);
+	rp = cx23885_risc_field(rp, sglist, 0, NO_SYNC_LINE, bpl, 0, lines, lpi);

  	/* save pointer to jmp instruction address */
  	risc->jmp = rp;
@@ -1373,7 +1380,7 @@ int cx23885_buf_prepare(struct videobuf_
  			goto fail;
  		cx23885_risc_databuffer(dev->pci, &buf->risc,
  					videobuf_to_dma(&buf->vb)->sglist,
-					buf->vb.width, buf->vb.height);
+					buf->vb.width, buf->vb.height, 0);
  	}
  	buf->vb.state = VIDEOBUF_PREPARED;
  	return 0;
@@ -1593,14 +1600,17 @@ static irqreturn_t cx23885_irq(int irq,
  	struct cx23885_tsport *ts2 = &dev->ts2;
  	u32 pci_status, pci_mask;
  	u32 vida_status, vida_mask;
+	u32 audint_status, audint_mask;
  	u32 ts1_status, ts1_mask;
  	u32 ts2_status, ts2_mask;
-	int vida_count = 0, ts1_count = 0, ts2_count = 0, handled = 0;
+	int vida_count = 0, audint_count = 0, ts1_count = 0, ts2_count = 0, 
handled = 0;

  	pci_status = cx_read(PCI_INT_STAT);
  	pci_mask = cx_read(PCI_INT_MSK);
  	vida_status = cx_read(VID_A_INT_STAT);
  	vida_mask = cx_read(VID_A_INT_MSK);
+	audint_status = cx_read(AUDIO_INT_INT_STAT);
+	audint_mask = cx_read(AUDIO_INT_INT_MSK);
  	ts1_status = cx_read(VID_B_INT_STAT);
  	ts1_mask = cx_read(VID_B_INT_MSK);
  	ts2_status = cx_read(VID_C_INT_STAT);
@@ -1610,12 +1620,15 @@ static irqreturn_t cx23885_irq(int irq,
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
@@ -1675,6 +1688,9 @@ static irqreturn_t cx23885_irq(int irq,
  	if (vida_status)
  		handled += cx23885_video_irq(dev, vida_status);

+	if (audint_status)
+		handled += cx23885_audio_irq(dev, audint_status, audint_mask);
+
  	if (handled)
  		cx_write(PCI_INT_STAT, pci_status);
  out:
diff -uprN old/linux/drivers/media/video/cx23885/cx23885.h 
new/linux/drivers/media/video/cx23885/cx23885.h
--- old/linux/drivers/media/video/cx23885/cx23885.h	2008-08-09 
07:21:15.000000000 -0500
+++ new/linux/drivers/media/video/cx23885/cx23885.h	2008-08-26 
14:40:47.318185412 -0500
@@ -264,6 +264,27 @@ struct cx23885_tsport {
  	u32                        hw_sop_ctrl_val;
  };

+struct cx23885_audio_dev {
+	struct cx23885_dev            *dev;
+
+	struct pci_dev             *pci;
+
+	struct snd_card            *card;
+
+	spinlock_t                 reg_lock;
+	atomic_t                   count;
+
+	unsigned int               dma_size;
+	unsigned int               period_size;
+	unsigned int               num_periods;
+
+	struct videobuf_dmabuf     *dma_risc;
+
+	struct cx23885_buffer      *buf;
+
+	struct snd_pcm_substream   *substream;
+};
+
  struct cx23885_dev {
  	struct list_head           devlist;
  	atomic_t                   refcount;
@@ -313,6 +334,9 @@ struct cx23885_dev {
  	unsigned char              radio_addr;
  	unsigned int               has_radio;

+	/* Analog audio */
+	struct cx23885_audio_dev   *audio_dev;
+
  	/* V4l */
  	u32                        freq;
  	struct video_device        *video_dev;
@@ -394,6 +418,13 @@ extern int cx23885_risc_buffer(struct pc
  	unsigned int top_offset, unsigned int bottom_offset,
  	unsigned int bpl, unsigned int padding, unsigned int lines);

+extern int cx23885_risc_databuffer(struct pci_dev *pci,
+				   struct btcx_riscmem *risc,
+				   struct scatterlist *sglist,
+				   unsigned int bpl,
+				   unsigned int lines,
+				   unsigned int lpi);
+
  void cx23885_cancel_buffers(struct cx23885_tsport *port);

  extern int cx23885_restart_queue(struct cx23885_tsport *port,
@@ -438,6 +469,13 @@ extern void cx23885_video_unregister(str
  extern int cx23885_video_irq(struct cx23885_dev *dev, u32 status);

  /* ----------------------------------------------------------- */
+/* cx23885-alsa.c                                             */
+/* Analog audio */
+extern struct cx23885_audio_dev *cx23885_audio_initdev(struct 
cx23885_dev *dev);
+extern void cx23885_audio_finidev(struct cx23885_dev *dev);
+extern int cx23885_audio_irq(struct cx23885_dev *dev, u32 status, u32 
mask);
+
+/* ----------------------------------------------------------- */
  /* cx23885-vbi.c                                               */
  extern int cx23885_vbi_fmt(struct file *file, void *priv,
  	struct v4l2_format *f);
diff -uprN old/linux/drivers/media/video/cx23885/cx23885-video.c 
new/linux/drivers/media/video/cx23885/cx23885-video.c
--- old/linux/drivers/media/video/cx23885/cx23885-video.c	2008-08-09 
07:21:15.000000000 -0500
+++ new/linux/drivers/media/video/cx23885/cx23885-video.c	2008-08-26 
14:40:47.319185469 -0500
@@ -36,6 +36,9 @@
  #include <media/v4l2-common.h>
  #include <media/v4l2-ioctl.h>

+#include "tuner-xc2028.h"
+#include <media/cx25840.h>
+
  #ifdef CONFIG_VIDEO_V4L1_COMPAT
  /* Include V4L1 specific functions. Should be removed soon */
  #include <linux/videodev.h>
@@ -206,7 +209,7 @@ static struct cx23885_ctrl cx23885_ctls[
  			.id            = V4L2_CID_CONTRAST,
  			.name          = "Contrast",
  			.minimum       = 0,
-			.maximum       = 0xff,
+			.maximum       = 0x7f,
  			.step          = 1,
  			.default_value = 0x3f,
  			.type          = V4L2_CTRL_TYPE_INTEGER,
@@ -219,10 +222,10 @@ static struct cx23885_ctrl cx23885_ctls[
  		.v = {
  			.id            = V4L2_CID_HUE,
  			.name          = "Hue",
-			.minimum       = 0,
-			.maximum       = 0xff,
+			.minimum       = -127,
+			.maximum       = 127,
  			.step          = 1,
-			.default_value = 0x7f,
+			.default_value = 0,
  			.type          = V4L2_CTRL_TYPE_INTEGER,
  		},
  		.off                   = 128,
@@ -237,9 +240,9 @@ static struct cx23885_ctrl cx23885_ctls[
  			.id            = V4L2_CID_SATURATION,
  			.name          = "Saturation",
  			.minimum       = 0,
-			.maximum       = 0xff,
+			.maximum       = 0x7f,
  			.step          = 1,
-			.default_value = 0x7f,
+			.default_value = 0x3f,
  			.type          = V4L2_CTRL_TYPE_INTEGER,
  		},
  		.off                   = 0,
@@ -977,11 +980,8 @@ EXPORT_SYMBOL(cx23885_get_control);

  int cx23885_set_control(struct cx23885_dev *dev, struct v4l2_control *ctl)
  {
-	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)"
-		" (disabled - no action)\n", __func__);
-#if 0
+	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)\n", __func__);
  	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_S_CTRL, ctl);
-#endif
  	return 0;
  }
  EXPORT_SYMBOL(cx23885_set_control);
@@ -1339,14 +1339,13 @@ static int vidioc_g_tuner(struct file *f
  	if (0 != t->index)
  		return -EINVAL;

+	memset(t, 0, sizeof(*t));
  	strcpy(t->name, "Television");
-	t->type       = V4L2_TUNER_ANALOG_TV;
-	t->capability = V4L2_TUNER_CAP_NORM;
-	t->rangehigh  = 0xffffffffUL;
-#if 0
-	cx23885_get_stereo(dev, t);
-#endif
-	t->signal = 0xffff ; /* LOCKED */
+	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_G_TUNER, t);
+	cx23885_call_i2c_clients(&dev->i2c_bus[1], VIDIOC_G_TUNER, t);
+
+	dprintk(1, "VIDIOC_G_TUNER: tuner type %d\n", t->type);
+
  	return 0;
  }

@@ -1362,6 +1361,9 @@ static int vidioc_s_tuner(struct file *f
  #if 0
  	cx23885_set_stereo(dev, t->audmode, 1);
  #endif
+	/* Update the A/V core */
+	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_S_TUNER, t);
+
  	return 0;
  }

@@ -1757,6 +1759,40 @@ void cx23885_video_unregister(struct cx2

  		btcx_riscmem_free(dev->pci, &dev->vidq.stopper);
  	}
+
+	if (dev->audio_dev)
+		cx23885_audio_finidev(dev);
+}
+
+static void config_analog_tuner(struct cx23885_dev *dev)
+{
+	struct tuner_setup	tun_setup;
+
+	if (dev->tuner_type == TUNER_ABSENT)
+		return;
+
+	request_module("tuner");
+
+	memset(&tun_setup, 0, sizeof(tun_setup));
+	tun_setup.mode_mask = T_ANALOG_TV;
+	tun_setup.type = dev->tuner_type;
+	tun_setup.addr = dev->tuner_addr;
+	tun_setup.tuner_callback = cx23885_tuner_callback;	/* Is this ok ??? */
+
+	cx23885_call_i2c_clients(&dev->i2c_bus[1], TUNER_SET_TYPE_ADDR, 
&tun_setup);
+
+	if (dev->tuner_type == TUNER_XC2028) {
+		struct xc2028_ctrl ctl = {
+			.fname 	 	= XC2028_DEFAULT_FIRMWARE,
+			.max_len 	= 64,
+		};
+		struct v4l2_priv_tun_config xc2028_cfg = {
+			.tuner 		= TUNER_XC2028,
+			.priv  		= &ctl,
+		};
+
+		cx23885_call_i2c_clients(&dev->i2c_bus[1], TUNER_SET_CONFIG, 
&xc2028_cfg);
+	}
  }

  int cx23885_video_register(struct cx23885_dev *dev)
@@ -1805,6 +1841,9 @@ int cx23885_video_register(struct cx2388
  		request_module("wm8775");
  #endif

+	/* Configure Analog Tuner */
+	config_analog_tuner(dev);
+
  	/* register v4l devices */
  	dev->video_dev = cx23885_vdev_init(dev, dev->pci,
  		&cx23885_video_template, "video");
@@ -1844,6 +1883,9 @@ int cx23885_video_register(struct cx2388
  		       dev->name, dev->radio_dev->minor & 0x1f);
  	}
  #endif
+	/* Register ALSA audio device */
+	dev->audio_dev = cx23885_audio_initdev(dev);
+
  	/* initial device configuration */
  	mutex_lock(&dev->lock);
  	cx23885_set_tvnorm(dev, dev->tvnorm);
diff -uprN old/linux/drivers/media/video/cx23885/Makefile 
new/linux/drivers/media/video/cx23885/Makefile
--- old/linux/drivers/media/video/cx23885/Makefile	2008-08-09 
07:21:15.000000000 -0500
+++ new/linux/drivers/media/video/cx23885/Makefile	2008-08-26 
14:40:47.319185469 -0500
@@ -1,4 +1,4 @@
-cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o 
cx23885-core.o cx23885-i2c.o cx23885-dvb.o cx23885-417.o
+cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o 
cx23885-core.o cx23885-i2c.o cx23885-dvb.o cx23885-417.o cx23885-alsa.o

  obj-$(CONFIG_VIDEO_CX23885) += cx23885.o

diff -uprN old/linux/drivers/media/video/cx25840/cx25840-core.c 
new/linux/drivers/media/video/cx25840/cx25840-core.c
--- old/linux/drivers/media/video/cx25840/cx25840-core.c	2008-08-09 
07:21:15.000000000 -0500
+++ new/linux/drivers/media/video/cx25840/cx25840-core.c	2008-08-26 
14:40:47.320185527 -0500
@@ -285,7 +285,9 @@ static void cx23885_initialize(struct i2

  	/* Trust the default xtal, no division */
  	/* This changes for the cx23888 products */
-	cx25840_write(client, 0x2, 0x76);
+	if (state->rev != 0x0000) /* FIXME: How to detect the bridge type ??? */
+		/* This causes image distortion on a true cx23885 board */
+		cx25840_write(client, 0x2, 0x76);

  	/* Bring down the regulator for AUX clk */
  	cx25840_write(client, 0x1, 0x40);

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
