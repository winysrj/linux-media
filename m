Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49631 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753510AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: [PATCH 09/35] [media] cx88: make checkpatch happier
Date: Wed, 16 Nov 2016 14:42:41 -0200
Message-Id: <d2948045c2dee0ea4b0e5f20fdd8facdd99e37a2.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is old, and have lots of checkpatch violations.
As we're touching a lot on this driver due to the printk
conversions, let's run checkpatch --fix on it, in order to
solve some of those issues. Also, let's remove the FSF
address and use the usual coding style for the initial comments.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx88/cx88-alsa.c       |  78 ++++++-------
 drivers/media/pci/cx88/cx88-blackbird.c  |  94 +++++++--------
 drivers/media/pci/cx88/cx88-cards.c      |  85 +++++++-------
 drivers/media/pci/cx88/cx88-core.c       | 119 +++++++++----------
 drivers/media/pci/cx88/cx88-dsp.c        |  13 +--
 drivers/media/pci/cx88/cx88-dvb.c        | 112 +++++++++---------
 drivers/media/pci/cx88/cx88-i2c.c        |  91 +++++++--------
 drivers/media/pci/cx88/cx88-input.c      |  18 ++-
 drivers/media/pci/cx88/cx88-mpeg.c       |  63 +++++-----
 drivers/media/pci/cx88/cx88-reg.h        |   5 +-
 drivers/media/pci/cx88/cx88-tvaudio.c    |  87 +++++++-------
 drivers/media/pci/cx88/cx88-vbi.c        |  20 ++--
 drivers/media/pci/cx88/cx88-video.c      | 195 +++++++++++++++----------------
 drivers/media/pci/cx88/cx88-vp3054-i2c.c |  44 +++----
 drivers/media/pci/cx88/cx88.h            |  36 +++---
 15 files changed, 510 insertions(+), 550 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index d2f1880a157e..3b2471d08509 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -1,5 +1,4 @@
 /*
- *
  *  Support for audio capture
  *  PCI function #1 of the cx2388x.
  *
@@ -18,10 +17,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -118,8 +113,8 @@ MODULE_VERSION(CX88_VERSION);
 
 MODULE_SUPPORTED_DEVICE("{{Conexant,23881},{{Conexant,23882},{{Conexant,23883}");
 static unsigned int debug;
-module_param(debug,int,0644);
-MODULE_PARM_DESC(debug,"enable debug messages");
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable debug messages");
 
 /****************************************************************************
 			Module specific funtions
@@ -132,7 +127,7 @@ MODULE_PARM_DESC(debug,"enable debug messages");
 static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 {
 	struct cx88_audio_buffer *buf = chip->buf;
-	struct cx88_core *core=chip->core;
+	struct cx88_core *core = chip->core;
 	const struct sram_channel *audio_ch = &cx88_sram_channels[SRAM_CH25];
 
 	/* Make sure RISC/FIFO are off before changing FIFO/RISC settings */
@@ -177,7 +172,8 @@ static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
  */
 static int _cx88_stop_audio_dma(snd_cx88_card_t *chip)
 {
-	struct cx88_core *core=chip->core;
+	struct cx88_core *core = chip->core;
+
 	dprintk(1, "Stopping audio DMA\n");
 
 	/* stop dma */
@@ -261,7 +257,7 @@ static irqreturn_t cx8801_irq(int irq, void *dev_id)
 	for (loop = 0; loop < MAX_IRQ_LOOP; loop++) {
 		status = cx_read(MO_PCI_INTSTAT) &
 			(core->pci_irqmask | PCI_INT_AUDINT);
-		if (0 == status)
+		if (status == 0)
 			goto out;
 		dprintk(3, "cx8801_irq loop %d/%d, status %x\n",
 			loop, MAX_IRQ_LOOP, status);
@@ -274,7 +270,7 @@ static irqreturn_t cx8801_irq(int irq, void *dev_id)
 			cx8801_aud_irq(chip);
 	}
 
-	if (MAX_IRQ_LOOP == loop) {
+	if (loop == MAX_IRQ_LOOP) {
 		pr_err("IRQ loop detected, disabling interrupts\n");
 		cx_clear(MO_PCI_INTMSK, PCI_INT_AUDINT);
 	}
@@ -290,7 +286,7 @@ static int cx88_alsa_dma_init(struct cx88_audio_dev *chip, int nr_pages)
 	int i;
 
 	buf->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
-	if (NULL == buf->vaddr) {
+	if (buf->vaddr == NULL) {
 		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
 		return -ENOMEM;
 	}
@@ -303,13 +299,13 @@ static int cx88_alsa_dma_init(struct cx88_audio_dev *chip, int nr_pages)
 	buf->nr_pages = nr_pages;
 
 	buf->sglist = vzalloc(buf->nr_pages * sizeof(*buf->sglist));
-	if (NULL == buf->sglist)
+	if (buf->sglist == NULL)
 		goto vzalloc_err;
 
 	sg_init_table(buf->sglist, buf->nr_pages);
 	for (i = 0; i < buf->nr_pages; i++) {
 		pg = vmalloc_to_page(buf->vaddr + i * PAGE_SIZE);
-		if (NULL == pg)
+		if (pg == NULL)
 			goto vmalloc_to_page_err;
 		sg_set_page(&buf->sglist[i], pg, PAGE_SIZE, 0);
 	}
@@ -331,7 +327,7 @@ static int cx88_alsa_dma_map(struct cx88_audio_dev *dev)
 	buf->sglen = dma_map_sg(&dev->pci->dev, buf->sglist,
 			buf->nr_pages, PCI_DMA_FROMDEVICE);
 
-	if (0 == buf->sglen) {
+	if (buf->sglen == 0) {
 		pr_warn("%s: cx88_alsa_map_sg failed\n", __func__);
 		return -ENOMEM;
 	}
@@ -366,7 +362,7 @@ static int dsp_buffer_free(snd_cx88_card_t *chip)
 
 	BUG_ON(!chip->dma_size);
 
-	dprintk(2,"Freeing buffer\n");
+	dprintk(2, "Freeing buffer\n");
 	cx88_alsa_dma_unmap(chip);
 	cx88_alsa_dma_free(chip->buf);
 	if (risc->cpu)
@@ -431,6 +427,7 @@ static int snd_cx88_pcm_open(struct snd_pcm_substream *substream)
 
 	if (cx88_sram_channels[SRAM_CH25].fifo_size != DEFAULT_FIFO_SIZE) {
 		unsigned int bpl = cx88_sram_channels[SRAM_CH25].fifo_size / 4;
+
 		bpl &= ~7; /* must be multiple of 8 */
 		runtime->hw.period_bytes_min = bpl;
 		runtime->hw.period_bytes_max = bpl;
@@ -438,7 +435,7 @@ static int snd_cx88_pcm_open(struct snd_pcm_substream *substream)
 
 	return 0;
 _error:
-	dprintk(1,"Error opening PCM!\n");
+	dprintk(1, "Error opening PCM!\n");
 	return err;
 }
 
@@ -453,8 +450,8 @@ static int snd_cx88_close(struct snd_pcm_substream *substream)
 /*
  * hw_params callback
  */
-static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
-			      struct snd_pcm_hw_params * hw_params)
+static int snd_cx88_hw_params(struct snd_pcm_substream *substream,
+			      struct snd_pcm_hw_params *hw_params)
 {
 	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
 
@@ -474,7 +471,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	BUG_ON(chip->num_periods & (chip->num_periods-1));
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
-	if (NULL == buf)
+	if (buf == NULL)
 		return -ENOMEM;
 
 	chip->buf = buf;
@@ -511,7 +508,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 /*
  * hw free callback
  */
-static int snd_cx88_hw_free(struct snd_pcm_substream * substream)
+static int snd_cx88_hw_free(struct snd_pcm_substream *substream)
 {
 
 	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
@@ -545,13 +542,13 @@ static int snd_cx88_card_trigger(struct snd_pcm_substream *substream, int cmd)
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		err=_cx88_start_audio_dma(chip);
+		err = _cx88_start_audio_dma(chip);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		err=_cx88_stop_audio_dma(chip);
+		err = _cx88_stop_audio_dma(chip);
 		break;
 	default:
-		err=-EINVAL;
+		err =  -EINVAL;
 		break;
 	}
 
@@ -584,6 +581,7 @@ static struct page *snd_cx88_page(struct snd_pcm_substream *substream,
 				unsigned long offset)
 {
 	void *pageptr = substream->runtime->dma_area + offset;
+
 	return vmalloc_to_page(pageptr);
 }
 
@@ -638,7 +636,7 @@ static int snd_cx88_volume_get(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
 	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
-	struct cx88_core *core=chip->core;
+	struct cx88_core *core = chip->core;
 	int vol = 0x3f - (cx_read(AUD_VOL_CTL) & 0x3f),
 	    bal = cx_read(AUD_BAL_CTL);
 
@@ -675,7 +673,7 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
 {
 	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
-	struct cx88_core *core=chip->core;
+	struct cx88_core *core = chip->core;
 	int left, right, v, b;
 	int changed = 0;
 	u32 old;
@@ -814,8 +812,8 @@ static struct snd_kcontrol_new snd_cx88_alc_switch = {
  */
 
 static const struct pci_device_id cx88_audio_pci_tbl[] = {
-	{0x14f1,0x8801,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
-	{0x14f1,0x8811,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
+	{0x14f1, 0x8801, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0x14f1, 0x8811, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, cx88_audio_pci_tbl);
@@ -830,7 +828,7 @@ static int snd_cx88_free(snd_cx88_card_t *chip)
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 
-	cx88_core_put(chip->core,chip->pci);
+	cx88_core_put(chip->core, chip->pci);
 
 	pci_disable_device(chip->pci);
 	return 0;
@@ -839,7 +837,7 @@ static int snd_cx88_free(snd_cx88_card_t *chip)
 /*
  * Component Destructor
  */
-static void snd_cx88_dev_free(struct snd_card * card)
+static void snd_cx88_dev_free(struct snd_card *card)
 {
 	snd_cx88_card_t *chip = card->private_data;
 
@@ -872,14 +870,14 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 	chip = card->private_data;
 
 	core = cx88_core_get(pci);
-	if (NULL == core) {
+	if (core == NULL) {
 		err = -EINVAL;
 		return err;
 	}
 
-	err = pci_set_dma_mask(pci,DMA_BIT_MASK(32));
+	err = pci_set_dma_mask(pci, DMA_BIT_MASK(32));
 	if (err) {
-		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
+		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n", core->name);
 		cx88_core_put(core, pci);
 		return err;
 	}
@@ -908,7 +906,7 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 	dprintk(1, "ALSA %s/%i: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
 		core->name, devno,
 	       pci_name(pci), pci->revision, pci->irq,
-	       pci_lat, (unsigned long long)pci_resource_start(pci,0));
+	       pci_lat, (unsigned long long)pci_resource_start(pci, 0));
 
 	chip->irq = pci->irq;
 	synchronize_irq(chip->irq);
@@ -964,19 +962,19 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 	if (core->sd_wm8775)
 		snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
 
-	strcpy (card->driver, "CX88x");
+	strcpy(card->driver, "CX88x");
 	sprintf(card->shortname, "Conexant CX%x", pci->device);
 	sprintf(card->longname, "%s at %#llx",
-		card->shortname,(unsigned long long)pci_resource_start(pci, 0));
-	strcpy (card->mixername, "CX88");
+		card->shortname, (unsigned long long)pci_resource_start(pci, 0));
+	strcpy(card->mixername, "CX88");
 
-	dprintk (0, "%s/%i: ALSA support for cx2388x boards\n",
-	       card->driver,devno);
+	dprintk(0, "%s/%i: ALSA support for cx2388x boards\n",
+	       card->driver, devno);
 
 	err = snd_card_register(card);
 	if (err < 0)
 		goto error;
-	pci_set_drvdata(pci,card);
+	pci_set_drvdata(pci, card);
 
 	devno++;
 	return 0;
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 4163e777825d..bffd064daff5 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1,5 +1,4 @@
 /*
- *
  *  Support for a cx23416 mpeg encoder via cx2388x host port.
  *  "blackbird" reference design.
  *
@@ -20,10 +19,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -46,8 +41,8 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(CX88_VERSION);
 
 static unsigned int debug;
-module_param(debug,int,0644);
-MODULE_PARM_DESC(debug,"enable debug messages [blackbird]");
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable debug messages [blackbird]");
 
 #define dprintk(level, fmt, arg...) do {				\
 	if (debug + 1 > level)						\
@@ -216,14 +211,14 @@ static void host_setup(struct cx88_core *core)
 static int wait_ready_gpio0_bit1(struct cx88_core *core, u32 state)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(1);
-	u32 gpio0,need;
+	u32 gpio0, need;
 
 	need = state ? 2 : 0;
 	for (;;) {
 		gpio0 = cx_read(MO_GP0_IO) & 2;
 		if (need == gpio0)
 			return 0;
-		if (time_after(jiffies,timeout))
+		if (time_after(jiffies, timeout))
 			return -1;
 		udelay(1);
 	}
@@ -242,7 +237,7 @@ static int memory_write(struct cx88_core *core, u32 address, u32 value)
 	cx_read(P1_MDATA0);
 	cx_read(P1_MADDR0);
 
-	return wait_ready_gpio0_bit1(core,1);
+	return wait_ready_gpio0_bit1(core, 1);
 }
 
 static int memory_read(struct cx88_core *core, u32 address, u32 *value)
@@ -256,7 +251,7 @@ static int memory_read(struct cx88_core *core, u32 address, u32 *value)
 	cx_writeb(P1_MADDR0, (unsigned int)address);
 	cx_read(P1_MADDR0);
 
-	retval = wait_ready_gpio0_bit1(core,1);
+	retval = wait_ready_gpio0_bit1(core, 1);
 
 	cx_writeb(P1_MDATA3, 0);
 	val     = (unsigned char)cx_read(P1_MDATA3) << 24;
@@ -283,7 +278,7 @@ static int register_write(struct cx88_core *core, u32 address, u32 value)
 	cx_read(P1_RDATA0);
 	cx_read(P1_RADDR0);
 
-	return wait_ready_gpio0_bit1(core,1);
+	return wait_ready_gpio0_bit1(core, 1);
 }
 
 
@@ -297,7 +292,7 @@ static int register_read(struct cx88_core *core, u32 address, u32 *value)
 	cx_writeb(P1_RRDWR, 0);
 	cx_read(P1_RADDR0);
 
-	retval  = wait_ready_gpio0_bit1(core,1);
+	retval  = wait_ready_gpio0_bit1(core, 1);
 	val     = (unsigned char)cx_read(P1_RDATA0);
 	val    |= (unsigned char)cx_read(P1_RDATA1) << 8;
 	val    |= (unsigned char)cx_read(P1_RDATA2) << 16;
@@ -316,7 +311,7 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 	u32 value, flag, retval;
 	int i;
 
-	dprintk(1,"%s: 0x%X\n", __func__, command);
+	dprintk(1, "%s: 0x%X\n", __func__, command);
 
 	/* this may not be 100% safe if we can't read any memory location
 	   without side effects */
@@ -354,7 +349,7 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 		memory_read(dev->core, dev->mailbox, &flag);
 		if (0 != (flag & 4))
 			break;
-		if (time_after(jiffies,timeout)) {
+		if (time_after(jiffies, timeout)) {
 			dprintk(0, "ERROR: API Mailbox timeout %x\n", command);
 			return -EIO;
 		}
@@ -368,7 +363,7 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 	}
 
 	memory_read(dev->core, dev->mailbox + 2, &retval);
-	dprintk(1, "API result = %d\n",retval);
+	dprintk(1, "API result = %d\n", retval);
 
 	flag = 0;
 	memory_write(dev->core, dev->mailbox, flag);
@@ -400,8 +395,8 @@ static int blackbird_api_cmd(struct cx8802_dev *dev, u32 command,
 
 static int blackbird_find_mailbox(struct cx8802_dev *dev)
 {
-	u32 signature[4]={0x12345678, 0x34567812, 0x56781234, 0x78123456};
-	int signaturecnt=0;
+	u32 signature[4] = {0x12345678, 0x34567812, 0x56781234, 0x78123456};
+	int signaturecnt = 0;
 	u32 value;
 	int i;
 
@@ -411,7 +406,7 @@ static int blackbird_find_mailbox(struct cx8802_dev *dev)
 			signaturecnt++;
 		else
 			signaturecnt = 0;
-		if (4 == signaturecnt) {
+		if (signaturecnt == 4) {
 			dprintk(1, "Mailbox signature found\n");
 			return i+1;
 		}
@@ -459,14 +454,14 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 		return -EINVAL;
 	}
 
-	if (0 != memcmp(firmware->data, magic, 8)) {
+	if (memcmp(firmware->data, magic, 8) != 0) {
 		pr_err("Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
 		return -EINVAL;
 	}
 
 	/* transfer to the chip */
-	dprintk(1,"Loading firmware ...\n");
+	dprintk(1, "Loading firmware ...\n");
 	dataptr = (__le32 *)firmware->data;
 	for (i = 0; i < (firmware->size >> 2); i++) {
 		value = le32_to_cpu(*dataptr);
@@ -534,7 +529,7 @@ static int blackbird_initialize_codec(struct cx8802_dev *dev)
 	int version;
 	int retval;
 
-	dprintk(1,"Initialize codec\n");
+	dprintk(1, "Initialize codec\n");
 	retval = blackbird_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0); /* ping */
 	if (retval < 0) {
 		/* ping was not successful, reset and upload firmware */
@@ -782,7 +777,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
+static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
 	if (f->index != 0)
@@ -815,7 +810,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
-	unsigned maxw, maxh;
+	unsigned int maxw, maxh;
 	enum v4l2_field field;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
@@ -871,14 +866,14 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_frequency (struct file *file, void *priv,
+static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 	bool streaming;
 
-	if (unlikely(UNSET == core->board.tuner_type))
+	if (unlikely(core->board.tuner_type == UNSET))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
@@ -886,7 +881,7 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	if (streaming)
 		blackbird_stop_codec(dev);
 
-	cx88_set_freq (core,f);
+	cx88_set_freq(core, f);
 	blackbird_initialize_codec(dev);
 	cx88_set_scale(core, core->width, core->height,
 			core->field);
@@ -895,7 +890,7 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_log_status (struct file *file, void *priv)
+static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -907,21 +902,22 @@ static int vidioc_log_status (struct file *file, void *priv)
 	return 0;
 }
 
-static int vidioc_enum_input (struct file *file, void *priv,
+static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
-	return cx88_enum_input (core,i);
+
+	return cx88_enum_input(core, i);
 }
 
-static int vidioc_g_frequency (struct file *file, void *priv,
+static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	if (unlikely(UNSET == core->board.tuner_type))
+	if (unlikely(core->board.tuner_type == UNSET))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
@@ -932,7 +928,7 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -941,7 +937,7 @@ static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -952,20 +948,20 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 		return -EINVAL;
 
 	cx88_newstation(core);
-	cx88_video_mux(core,i);
+	cx88_video_mux(core, i);
 	return 0;
 }
 
-static int vidioc_g_tuner (struct file *file, void *priv,
+static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 	u32 reg;
 
-	if (unlikely(UNSET == core->board.tuner_type))
+	if (unlikely(core->board.tuner_type == UNSET))
 		return -EINVAL;
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	strcpy(t->name, "Television");
@@ -973,21 +969,21 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 	t->rangehigh  = 0xffffffffUL;
 	call_all(core, tuner, g_tuner, t);
 
-	cx88_get_stereo(core ,t);
+	cx88_get_stereo(core, t);
 	reg = cx_read(MO_DEVICE_STATUS);
 	t->signal = (reg & (1<<5)) ? 0xffff : 0x0000;
 	return 0;
 }
 
-static int vidioc_s_tuner (struct file *file, void *priv,
+static int vidioc_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	if (UNSET == core->board.tuner_type)
+	if (core->board.tuner_type == UNSET)
 		return -EINVAL;
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	cx88_set_stereo(core, t->audmode, 1);
@@ -1011,8 +1007,8 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	return cx88_set_tvnorm(core, id);
 }
 
-static const struct v4l2_file_operations mpeg_fops =
-{
+static const struct v4l2_file_operations mpeg_fops = {
+
 	.owner	       = THIS_MODULE,
 	.open	       = v4l2_fh_open,
 	.release       = vb2_fop_release,
@@ -1051,7 +1047,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 static struct video_device cx8802_mpeg_template = {
 	.name                 = "cx8802",
 	.fops                 = &mpeg_fops,
-	.ioctl_ops 	      = &mpeg_ioctl_ops,
+	.ioctl_ops	      = &mpeg_ioctl_ops,
 	.tvnorms              = CX88_NORMS,
 };
 
@@ -1136,8 +1132,8 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	struct vb2_queue *q;
 	int err;
 
-	dprintk( 1, "%s\n", __func__);
-	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
+	dprintk(1, "%s\n", __func__);
+	dprintk(1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
 		core->pci_bus,
@@ -1165,8 +1161,8 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 
 	/* initial device configuration: needed ? */
 //	init_controls(core);
-	cx88_set_tvnorm(core,core->tvnorm);
-	cx88_video_mux(core,0);
+	cx88_set_tvnorm(core, core->tvnorm);
+	cx88_video_mux(core, 0);
 	cx2341x_handler_set_50hz(&dev->cxhdl, core->height == 576);
 	cx2341x_handler_setup(&dev->cxhdl);
 
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 1a65db957dcb..269179142cd8 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -1,5 +1,4 @@
 /*
- *
  * device driver for Conexant 2388x based TV cards
  * card-specific stuff.
  *
@@ -14,10 +13,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -38,19 +33,19 @@ module_param_array(tuner, int, NULL, 0444);
 module_param_array(radio, int, NULL, 0444);
 module_param_array(card,  int, NULL, 0444);
 
-MODULE_PARM_DESC(tuner,"tuner type");
-MODULE_PARM_DESC(radio,"radio tuner type");
-MODULE_PARM_DESC(card,"card type");
+MODULE_PARM_DESC(tuner, "tuner type");
+MODULE_PARM_DESC(radio, "radio tuner type");
+MODULE_PARM_DESC(card, "card type");
 
 static unsigned int latency = UNSET;
-module_param(latency,int,0444);
-MODULE_PARM_DESC(latency,"pci latency timer");
+module_param(latency, int, 0444);
+MODULE_PARM_DESC(latency, "pci latency timer");
 
 static int disable_ir;
 module_param(disable_ir, int, 0444);
 MODULE_PARM_DESC(disable_ir, "Disable IR support");
 
-#define dprintk(level,fmt, arg...)	do {				\
+#define dprintk(level, fmt, arg...)	do {				\
 	if (cx88_core_debug >= level)					\
 		printk(KERN_DEBUG pr_fmt("%s: core:" fmt),		\
 			__func__, ##arg);				\
@@ -2911,33 +2906,33 @@ static const struct {
 	int  fm;
 	const char *name;
 } gdi_tuner[] = {
-	[ 0x01 ] = { .id   = UNSET,
+	[0x01] = { .id   = UNSET,
 		     .name = "NTSC_M" },
-	[ 0x02 ] = { .id   = UNSET,
+	[0x02] = { .id   = UNSET,
 		     .name = "PAL_B" },
-	[ 0x03 ] = { .id   = UNSET,
+	[0x03] = { .id   = UNSET,
 		     .name = "PAL_I" },
-	[ 0x04 ] = { .id   = UNSET,
+	[0x04] = { .id   = UNSET,
 		     .name = "PAL_D" },
-	[ 0x05 ] = { .id   = UNSET,
+	[0x05] = { .id   = UNSET,
 		     .name = "SECAM" },
 
-	[ 0x10 ] = { .id   = UNSET,
+	[0x10] = { .id   = UNSET,
 		     .fm   = 1,
 		     .name = "TEMIC_4049" },
-	[ 0x11 ] = { .id   = TUNER_TEMIC_4136FY5,
+	[0x11] = { .id   = TUNER_TEMIC_4136FY5,
 		     .name = "TEMIC_4136" },
-	[ 0x12 ] = { .id   = UNSET,
+	[0x12] = { .id   = UNSET,
 		     .name = "TEMIC_4146" },
 
-	[ 0x20 ] = { .id   = TUNER_PHILIPS_FQ1216ME,
+	[0x20] = { .id   = TUNER_PHILIPS_FQ1216ME,
 		     .fm   = 1,
 		     .name = "PHILIPS_FQ1216_MK3" },
-	[ 0x21 ] = { .id   = UNSET, .fm = 1,
+	[0x21] = { .id   = UNSET, .fm = 1,
 		     .name = "PHILIPS_FQ1236_MK3" },
-	[ 0x22 ] = { .id   = UNSET,
+	[0x22] = { .id   = UNSET,
 		     .name = "PHILIPS_FI1236_MK3" },
-	[ 0x23 ] = { .id   = UNSET,
+	[0x23] = { .id   = UNSET,
 		     .name = "PHILIPS_FI1216_MK3" },
 };
 
@@ -2947,7 +2942,7 @@ static void gdi_eeprom(struct cx88_core *core, u8 *eeprom_data)
 		? gdi_tuner[eeprom_data[0x0d]].name : NULL;
 
 	pr_info("GDI: tuner=%s\n", name ? name : "unknown");
-	if (NULL == name)
+	if (name == NULL)
 		return;
 	core->board.tuner_type = gdi_tuner[eeprom_data[0x0d]].id;
 	core->board.radio.type = gdi_tuner[eeprom_data[0x0d]].fm ?
@@ -3167,7 +3162,7 @@ static int cx88_xc4000_tuner_callback(struct cx88_core *core,
 }
 
 /* ----------------------------------------------------------------------- */
-/* Tuner callback function. Currently only needed for the Pinnacle 	   *
+/* Tuner callback function. Currently only needed for the Pinnacle	   *
  * PCTV HD 800i with an xc5000 sillicon tuner. This is used for both	   *
  * analog tuner attach (tuner-core.c) and dvb tuner attach (cx88-dvb.c)    */
 
@@ -3401,7 +3396,7 @@ static void cx88_card_setup(struct cx88_core *core)
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
 
-	if (0 == core->i2c_rc) {
+	if (core->i2c_rc == 0) {
 		core->i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&core->i2c_client, eeprom, sizeof(eeprom));
 	}
@@ -3409,17 +3404,17 @@ static void cx88_card_setup(struct cx88_core *core)
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE:
 	case CX88_BOARD_HAUPPAUGE_ROSLYN:
-		if (0 == core->i2c_rc)
+		if (core->i2c_rc == 0)
 			hauppauge_eeprom(core, eeprom+8);
 		break;
 	case CX88_BOARD_GDI:
-		if (0 == core->i2c_rc)
+		if (core->i2c_rc == 0)
 			gdi_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_LEADTEK_PVR2000:
 	case CX88_BOARD_WINFAST_DV2000:
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
-		if (0 == core->i2c_rc)
+		if (core->i2c_rc == 0)
 			leadtek_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
@@ -3432,7 +3427,7 @@ static void cx88_card_setup(struct cx88_core *core)
 	case CX88_BOARD_HAUPPAUGE_HVR4000:
 	case CX88_BOARD_HAUPPAUGE_HVR4000LITE:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		if (0 == core->i2c_rc)
+		if (core->i2c_rc == 0)
 			hauppauge_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_KWORLD_DVBS_100:
@@ -3478,21 +3473,21 @@ static void cx88_card_setup(struct cx88_core *core)
 		cx_write(MO_GP0_IO, 0x00080808);
 		break;
 	case CX88_BOARD_ATI_HDTVWONDER:
-		if (0 == core->i2c_rc) {
+		if (core->i2c_rc == 0) {
 			/* enable tuner */
 			int i;
-			static const u8 buffer [][2] = {
-				{0x10,0x12},
-				{0x13,0x04},
-				{0x16,0x00},
-				{0x14,0x04},
-				{0x17,0x00}
+			static const u8 buffer[][2] = {
+				{0x10, 0x12},
+				{0x13, 0x04},
+				{0x16, 0x00},
+				{0x14, 0x04},
+				{0x17, 0x00}
 			};
 			core->i2c_client.addr = 0x0a;
 
 			for (i = 0; i < ARRAY_SIZE(buffer); i++)
 				if (2 != i2c_master_send(&core->i2c_client,
-							buffer[i],2))
+							buffer[i], 2))
 					pr_warn("Unable to enable tuner(%i).\n",
 						i);
 		}
@@ -3616,7 +3611,7 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 #endif
 
 	/* check insmod options */
-	if (UNSET != latency)
+	if (latency != UNSET)
 		lat = latency;
 
 	/* apply stuff */
@@ -3625,7 +3620,7 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 		value |= ctrl;
 		pci_write_config_byte(pci, CX88X_DEVCTRL, value);
 	}
-	if (UNSET != lat) {
+	if (lat != UNSET) {
 		pr_info("setting pci latency timer to %d\n",
 			latency);
 		pci_write_config_byte(pci, PCI_LATENCY_TIMER, latency);
@@ -3635,8 +3630,8 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 
 int cx88_get_resources(const struct cx88_core *core, struct pci_dev *pci)
 {
-	if (request_mem_region(pci_resource_start(pci,0),
-			       pci_resource_len(pci,0),
+	if (request_mem_region(pci_resource_start(pci, 0),
+			       pci_resource_len(pci, 0),
 			       core->name))
 		return 0;
 	pr_err("func %d: Can't get MMIO memory @ 0x%llx, subsystem: %04x:%04x\n",
@@ -3692,7 +3687,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		return NULL;
 	}
 
-	if (0 != cx88_get_resources(core, pci)) {
+	if (cx88_get_resources(core, pci) != 0) {
 		v4l2_ctrl_handler_free(&core->video_hdl);
 		v4l2_ctrl_handler_free(&core->audio_hdl);
 		v4l2_device_unregister(&core->v4l2_dev);
@@ -3724,7 +3719,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		if (pci->subsystem_vendor == cx88_subids[i].subvendor &&
 		    pci->subsystem_device == cx88_subids[i].subdevice)
 			core->boardnr = cx88_subids[i].card;
-	if (UNSET == core->boardnr) {
+	if (core->boardnr == UNSET) {
 		core->boardnr = CX88_BOARD_UNKNOWN;
 		cx88_card_list(core, pci);
 	}
@@ -3754,7 +3749,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	cx88_i2c_init(core, pci);
 
 	/* load tuner module, if needed */
-	if (UNSET != core->board.tuner_type) {
+	if (core->board.tuner_type != UNSET) {
 		/* Ignore 0x6b and 0x6f on cx88 boards.
 		 * FusionHDTV5 RT Gold has an ir receiver at 0x6b
 		 * and an RTC at 0x6f which can get corrupted if probed. */
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 27203e094655..6c710c54307f 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -1,5 +1,4 @@
 /*
- *
  * device driver for Conexant 2388x based TV cards
  * driver core
  *
@@ -19,10 +18,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -54,12 +49,12 @@ module_param_named(core_debug, cx88_core_debug, int, 0644);
 MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
 static unsigned int nicam;
-module_param(nicam,int,0644);
-MODULE_PARM_DESC(nicam,"tv audio is nicam");
+module_param(nicam, int, 0644);
+MODULE_PARM_DESC(nicam, "tv audio is nicam");
 
 static unsigned int nocomb;
-module_param(nocomb,int,0644);
-MODULE_PARM_DESC(nocomb,"disable comb filter");
+module_param(nocomb, int, 0644);
+MODULE_PARM_DESC(nocomb, "disable comb filter");
 
 #define dprintk0(fmt, arg...)				\
 	printk(KERN_DEBUG pr_fmt("%s: core:" fmt),	\
@@ -79,13 +74,13 @@ static DEFINE_MUTEX(devlist);
 
 /* @lpi: lines per IRQ, or 0 to not generate irqs. Note: IRQ to be
 	 generated _after_ lpi lines are transferred. */
-static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
+static __le32 *cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
 			    unsigned int offset, u32 sync_line,
 			    unsigned int bpl, unsigned int padding,
 			    unsigned int lines, unsigned int lpi, bool jump)
 {
 	struct scatterlist *sg;
-	unsigned int line,todo,sol;
+	unsigned int line, todo, sol;
 
 	if (jump) {
 		(*rp++) = cpu_to_le32(RISC_JUMP);
@@ -103,33 +98,33 @@ static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
 			offset -= sg_dma_len(sg);
 			sg = sg_next(sg);
 		}
-		if (lpi && line>0 && !(line % lpi))
+		if (lpi && line > 0 && !(line % lpi))
 			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
 		else
 			sol = RISC_SOL;
 		if (bpl <= sg_dma_len(sg)-offset) {
 			/* fits into current chunk */
-			*(rp++)=cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
-			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
-			offset+=bpl;
+			*(rp++) = cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
+			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
+			offset += bpl;
 		} else {
 			/* scanline needs to be split */
 			todo = bpl;
-			*(rp++)=cpu_to_le32(RISC_WRITE|sol|
+			*(rp++) = cpu_to_le32(RISC_WRITE|sol|
 					    (sg_dma_len(sg)-offset));
-			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
+			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
 			todo -= (sg_dma_len(sg)-offset);
 			offset = 0;
 			sg = sg_next(sg);
 			while (todo > sg_dma_len(sg)) {
-				*(rp++)=cpu_to_le32(RISC_WRITE|
+				*(rp++) = cpu_to_le32(RISC_WRITE|
 						    sg_dma_len(sg));
-				*(rp++)=cpu_to_le32(sg_dma_address(sg));
+				*(rp++) = cpu_to_le32(sg_dma_address(sg));
 				todo -= sg_dma_len(sg);
 				sg = sg_next(sg);
 			}
-			*(rp++)=cpu_to_le32(RISC_WRITE|RISC_EOL|todo);
-			*(rp++)=cpu_to_le32(sg_dma_address(sg));
+			*(rp++) = cpu_to_le32(RISC_WRITE|RISC_EOL|todo);
+			*(rp++) = cpu_to_le32(sg_dma_address(sg));
 			offset += todo;
 		}
 		offset += padding;
@@ -143,13 +138,13 @@ int cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 		     unsigned int top_offset, unsigned int bottom_offset,
 		     unsigned int bpl, unsigned int padding, unsigned int lines)
 {
-	u32 instructions,fields;
+	u32 instructions, fields;
 	__le32 *rp;
 
 	fields = 0;
-	if (UNSET != top_offset)
+	if (top_offset != UNSET)
 		fields++;
-	if (UNSET != bottom_offset)
+	if (bottom_offset != UNSET)
 		fields++;
 
 	/* estimate risc mem: worst case is one write per page border +
@@ -161,21 +156,21 @@ int cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 	risc->size = instructions * 8;
 	risc->dma = 0;
 	risc->cpu = pci_zalloc_consistent(pci, risc->size, &risc->dma);
-	if (NULL == risc->cpu)
+	if (risc->cpu == NULL)
 		return -ENOMEM;
 
 	/* write risc instructions */
 	rp = risc->cpu;
-	if (UNSET != top_offset)
+	if (top_offset != UNSET)
 		rp = cx88_risc_field(rp, sglist, top_offset, 0,
 				     bpl, padding, lines, 0, true);
-	if (UNSET != bottom_offset)
+	if (bottom_offset != UNSET)
 		rp = cx88_risc_field(rp, sglist, bottom_offset, 0x200,
 				     bpl, padding, lines, 0, top_offset == UNSET);
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
-	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof (*risc->cpu) > risc->size);
+	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof(*risc->cpu) > risc->size);
 	return 0;
 }
 
@@ -195,7 +190,7 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 	risc->size = instructions * 8;
 	risc->dma = 0;
 	risc->cpu = pci_zalloc_consistent(pci, risc->size, &risc->dma);
-	if (NULL == risc->cpu)
+	if (risc->cpu == NULL)
 		return -ENOMEM;
 
 	/* write risc instructions */
@@ -204,7 +199,7 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 
 	/* save pointer to jmp instruction address */
 	risc->jmp = rp;
-	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof (*risc->cpu) > risc->size);
+	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof(*risc->cpu) > risc->size);
 	return 0;
 }
 
@@ -340,7 +335,7 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 			    const struct sram_channel *ch,
 			    unsigned int bpl, u32 risc)
 {
-	unsigned int i,lines;
+	unsigned int i, lines;
 	u32 cdt;
 
 	bpl   = (bpl + 7) & ~7; /* alignment */
@@ -366,7 +361,7 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 	/* fill registers */
 	cx_write(ch->ptr1_reg, ch->fifo_start);
 	cx_write(ch->ptr2_reg, cdt);
-	cx_write(ch->cnt1_reg, (bpl >> 3) -1);
+	cx_write(ch->cnt1_reg, (bpl >> 3) - 1);
 	cx_write(ch->cnt2_reg, (lines*16) >> 3);
 
 	dprintk(2, "sram setup %s: bpl=%d lines=%d\n", ch->name, bpl, lines);
@@ -379,23 +374,23 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 static int cx88_risc_decode(u32 risc)
 {
 	static const char * const instr[16] = {
-		[ RISC_SYNC    >> 28 ] = "sync",
-		[ RISC_WRITE   >> 28 ] = "write",
-		[ RISC_WRITEC  >> 28 ] = "writec",
-		[ RISC_READ    >> 28 ] = "read",
-		[ RISC_READC   >> 28 ] = "readc",
-		[ RISC_JUMP    >> 28 ] = "jump",
-		[ RISC_SKIP    >> 28 ] = "skip",
-		[ RISC_WRITERM >> 28 ] = "writerm",
-		[ RISC_WRITECM >> 28 ] = "writecm",
-		[ RISC_WRITECR >> 28 ] = "writecr",
+		[RISC_SYNC    >> 28] = "sync",
+		[RISC_WRITE   >> 28] = "write",
+		[RISC_WRITEC  >> 28] = "writec",
+		[RISC_READ    >> 28] = "read",
+		[RISC_READC   >> 28] = "readc",
+		[RISC_JUMP    >> 28] = "jump",
+		[RISC_SKIP    >> 28] = "skip",
+		[RISC_WRITERM >> 28] = "writerm",
+		[RISC_WRITECM >> 28] = "writecm",
+		[RISC_WRITECR >> 28] = "writecr",
 	};
 	static int const incr[16] = {
-		[ RISC_WRITE   >> 28 ] = 2,
-		[ RISC_JUMP    >> 28 ] = 2,
-		[ RISC_WRITERM >> 28 ] = 3,
-		[ RISC_WRITECM >> 28 ] = 3,
-		[ RISC_WRITECR >> 28 ] = 4,
+		[RISC_WRITE   >> 28] = 2,
+		[RISC_JUMP    >> 28] = 2,
+		[RISC_WRITERM >> 28] = 3,
+		[RISC_WRITECM >> 28] = 3,
+		[RISC_WRITECR >> 28] = 4,
 	};
 	static const char * const bits[] = {
 		"12",   "13",   "14",   "resync",
@@ -432,7 +427,7 @@ void cx88_sram_channel_dump(struct cx88_core *core,
 		"line / byte",
 	};
 	u32 risc;
-	unsigned int i,j,n;
+	unsigned int i, j, n;
 
 	dprintk0("%s - dma channel status dump\n",
 		ch->name);
@@ -645,7 +640,7 @@ static inline unsigned int norm_fsc8(v4l2_std_id norm)
 static inline unsigned int norm_htotal(v4l2_std_id norm)
 {
 
-	unsigned int fsc4=norm_fsc8(norm)/2;
+	unsigned int fsc4 = norm_fsc8(norm)/2;
 
 	/* returns 4*FSC / vtotal / frames per seconds */
 	return (norm & V4L2_STD_625_50) ?
@@ -711,7 +706,7 @@ int cx88_set_scale(struct cx88_core *core, unsigned int width, unsigned int heig
 	}
 	if (INPUT(core->input).type == CX88_VMUX_SVIDEO)
 		value |= (1 << 13) | (1 << 5);
-	if (V4L2_FIELD_INTERLACED == field)
+	if (field == V4L2_FIELD_INTERLACED)
 		value |= (1 << 3); // VINT (interlaced vertical scaling)
 	if (width < 385)
 		value |= (1 << 0); // 3-tap interpolation
@@ -742,7 +737,7 @@ static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 		prescale = 5;
 
 	pll = ofreq * 8 * prescale * (u64)(1 << 20);
-	do_div(pll,xtal);
+	do_div(pll, xtal);
 	reg = (pll & 0x3ffffff) | (pre[prescale] << 26);
 	if (((reg >> 20) & 0x3f) < 14) {
 		pr_err("pll out of range\n");
@@ -755,8 +750,8 @@ static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 	for (i = 0; i < 100; i++) {
 		reg = cx_read(MO_DEVICE_STATUS);
 		if (reg & (1<<2)) {
-			dprintk(1,"pll locked [pre=%d,ofreq=%d]\n",
-				prescale,ofreq);
+			dprintk(1, "pll locked [pre=%d,ofreq=%d]\n",
+				prescale, ofreq);
 			return 0;
 		}
 		dprintk(1, "pll not locked yet, waiting ...\n");
@@ -863,9 +858,9 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	u32 fsc8;
 	u32 adc_clock;
 	u32 vdec_clock;
-	u32 step_db,step_dr;
+	u32 step_db, step_dr;
 	u64 tmp64;
-	u32 bdelay,agcdelay,htotal;
+	u32 bdelay, agcdelay, htotal;
 	u32 cxiformat, cxoformat;
 
 	if (norm == core->tvnorm)
@@ -917,7 +912,7 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	dprintk(1, "set_tvnorm: \"%s\" fsc8=%d adc=%d vdec=%d db/dr=%d/%d\n",
 		v4l2_norm_to_name(core->tvnorm), fsc8, adc_clock, vdec_clock,
 		step_db, step_dr);
-	set_pll(core,2,vdec_clock);
+	set_pll(core, 2, vdec_clock);
 
 	dprintk(1, "set_tvnorm: MO_INPUT_FORMAT  0x%08x [old=0x%08x]\n",
 		cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
@@ -1013,7 +1008,7 @@ void cx88_vdev_init(struct cx88_core *core,
 		 core->name, type, core->board.name);
 }
 
-struct cx88_core* cx88_core_get(struct pci_dev *pci)
+struct cx88_core *cx88_core_get(struct pci_dev *pci)
 {
 	struct cx88_core *core;
 
@@ -1024,7 +1019,7 @@ struct cx88_core* cx88_core_get(struct pci_dev *pci)
 		if (PCI_SLOT(pci->devfn) != core->pci_slot)
 			continue;
 
-		if (0 != cx88_get_resources(core, pci)) {
+		if (cx88_get_resources(core, pci) != 0) {
 			mutex_unlock(&devlist);
 			return NULL;
 		}
@@ -1034,7 +1029,7 @@ struct cx88_core* cx88_core_get(struct pci_dev *pci)
 	}
 
 	core = cx88_core_create(pci, cx88_devcount);
-	if (NULL != core) {
+	if (core != NULL) {
 		cx88_devcount++;
 		list_add_tail(&core->devlist, &cx88_devlist);
 	}
@@ -1045,15 +1040,15 @@ struct cx88_core* cx88_core_get(struct pci_dev *pci)
 
 void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 {
-	release_mem_region(pci_resource_start(pci,0),
-			   pci_resource_len(pci,0));
+	release_mem_region(pci_resource_start(pci, 0),
+			   pci_resource_len(pci, 0));
 
 	if (!atomic_dec_and_test(&core->refcount))
 		return;
 
 	mutex_lock(&devlist);
 	cx88_ir_fini(core);
-	if (0 == core->i2c_rc) {
+	if (core->i2c_rc == 0) {
 		if (core->i2c_rtc)
 			i2c_unregister_device(core->i2c_rtc);
 		i2c_del_adapter(&core->i2c_adap);
diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index eb502f8a290b..6521002f3050 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -1,5 +1,4 @@
 /*
- *
  *  Stereo and SAP detection for cx88
  *
  *  Copyright (c) 2009 Marton Balint <cus@fazekas.hu>
@@ -13,10 +12,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -82,6 +77,7 @@ static s32 int_cos(u32 x)
 	u32 t2, t4, t6, t8;
 	s32 ret;
 	u16 period = x / INT_PI;
+
 	if (period % 2)
 		return -int_cos(x - INT_PI);
 	x = x % INT_PI;
@@ -111,6 +107,7 @@ static u32 int_goertzel(s16 x[], u32 N, u32 freq)
 
 	for (i = 0; i < N; i++) {
 		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
+
 		s_prev2 = s_prev;
 		s_prev = s;
 	}
@@ -129,6 +126,7 @@ static u32 int_goertzel(s16 x[], u32 N, u32 freq)
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
 {
 	u32 sum = int_goertzel(x, N, freq);
+
 	return (u32)int_sqrt(sum);
 }
 
@@ -225,6 +223,7 @@ static s32 detect_btsc(struct cx88_core *core, s16 x[], u32 N)
 	s32 sap = freq_magnitude(x, N, FREQ_BTSC_SAP);
 	s32 dual_ref = freq_magnitude(x, N, FREQ_BTSC_DUAL_REF);
 	s32 dual = freq_magnitude(x, N, FREQ_BTSC_DUAL);
+
 	dprintk(1, "detect btsc: dual_ref=%d, dual=%d, sap_ref=%d, sap=%d\n",
 		dual_ref, dual, sap_ref, sap);
 	/* FIXME: Currently not supported */
@@ -249,7 +248,7 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 		current_address - srch->fifo_start, sample_count,
 		cx_read(MO_AUD_INTSTAT));
 
-	samples = kmalloc(sizeof(s16)*sample_count, GFP_KERNEL);
+	samples = kmalloc_array(sample_count, sizeof(s16), GFP_KERNEL);
 	if (!samples)
 		return NULL;
 
@@ -308,7 +307,7 @@ s32 cx88_dsp_detect_stereo_sap(struct cx88_core *core)
 
 	kfree(samples);
 
-	if (UNSET != ret)
+	if (ret != UNSET)
 		dprintk(1, "stereo/sap detection result:%s%s%s\n",
 			   (ret & V4L2_TUNER_SUB_MONO) ? " mono" : "",
 			   (ret & V4L2_TUNER_SUB_STEREO) ? " stereo" : "",
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 378135ddb6fb..5188f8f2d6dd 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1,5 +1,4 @@
 /*
- *
  * device driver for Conexant 2388x based TV cards
  * MPEG Transport Stream (DVB) routines
  *
@@ -15,10 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -70,7 +65,7 @@ MODULE_VERSION(CX88_VERSION);
 
 static unsigned int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages [dvb]");
+MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
 
 static unsigned int dvb_buf_tscnt = 32;
 module_param(dvb_buf_tscnt, int, 0644);
@@ -173,9 +168,9 @@ static const struct vb2_ops dvb_qops = {
 
 /* ------------------------------------------------------------------ */
 
-static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
+static int cx88_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx8802_driver *drv = NULL;
 	int ret = 0;
 	int fe_id;
@@ -189,7 +184,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
 	if (drv) {
-		if (acquire){
+		if (acquire) {
 			dev->frontends.active_fe_id = fe_id;
 			ret = drv->request_acquire(drv);
 		} else {
@@ -226,13 +221,13 @@ static void cx88_dvb_gate_ctrl(struct cx88_core  *core, int open)
 
 /* ------------------------------------------------------------------ */
 
-static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
+static int dvico_fusionhdtv_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { CLOCK_CTL,  0x38, 0x39 };
-	static const u8 reset []         = { RESET,      0x80 };
-	static const u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static const u8 agc_cfg []       = { AGC_TARGET, 0x24, 0x20 };
-	static const u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static const u8 clock_config[]  = { CLOCK_CTL,  0x38, 0x39 };
+	static const u8 reset[]         = { RESET,      0x80 };
+	static const u8 adc_ctl_1_cfg[] = { ADC_CTL_1,  0x40 };
+	static const u8 agc_cfg[]       = { AGC_TARGET, 0x24, 0x20 };
+	static const u8 gpp_ctl_cfg[]   = { GPP_CTL,    0x33 };
 	static const u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
@@ -248,11 +243,11 @@ static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
 
 static int dvico_dual_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { CLOCK_CTL,  0x38, 0x38 };
-	static const u8 reset []         = { RESET,      0x80 };
-	static const u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static const u8 agc_cfg []       = { AGC_TARGET, 0x28, 0x20 };
-	static const u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static const u8 clock_config[]  = { CLOCK_CTL,  0x38, 0x38 };
+	static const u8 reset[]         = { RESET,      0x80 };
+	static const u8 adc_ctl_1_cfg[] = { ADC_CTL_1,  0x40 };
+	static const u8 agc_cfg[]       = { AGC_TARGET, 0x28, 0x20 };
+	static const u8 gpp_ctl_cfg[]   = { GPP_CTL,    0x33 };
 	static const u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
@@ -267,12 +262,12 @@ static int dvico_dual_demod_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int dntv_live_dvbt_demod_init(struct dvb_frontend* fe)
+static int dntv_live_dvbt_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { 0x89, 0x38, 0x39 };
-	static const u8 reset []         = { 0x50, 0x80 };
-	static const u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
-	static const u8 agc_cfg []       = { 0x67, 0x10, 0x23, 0x00, 0xFF, 0xFF,
+	static const u8 clock_config[]  = { 0x89, 0x38, 0x39 };
+	static const u8 reset[]         = { 0x50, 0x80 };
+	static const u8 adc_ctl_1_cfg[] = { 0x8E, 0x40 };
+	static const u8 agc_cfg[]       = { 0x67, 0x10, 0x23, 0x00, 0xFF, 0xFF,
 				       0x00, 0xFF, 0x00, 0x40, 0x40 };
 	static const u8 dntv_extra[]     = { 0xB5, 0x7A };
 	static const u8 capt_range_cfg[] = { 0x75, 0x32 };
@@ -316,12 +311,12 @@ static struct mb86a16_config twinhan_vp1027 = {
 };
 
 #if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
-static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
+static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { 0x89, 0x38, 0x38 };
-	static const u8 reset []         = { 0x50, 0x80 };
-	static const u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
-	static const u8 agc_cfg []       = { 0x67, 0x10, 0x20, 0x00, 0xFF, 0xFF,
+	static const u8 clock_config[]  = { 0x89, 0x38, 0x38 };
+	static const u8 reset[]         = { 0x50, 0x80 };
+	static const u8 adc_ctl_1_cfg[] = { 0x8E, 0x40 };
+	static const u8 agc_cfg[]       = { 0x67, 0x10, 0x20, 0x00, 0xFF, 0xFF,
 				       0x00, 0xFF, 0x00, 0x40, 0x40 };
 	static const u8 dntv_extra[]     = { 0xB5, 0x7A };
 	static const u8 capt_range_cfg[] = { 0x75, 0x32 };
@@ -378,9 +373,10 @@ static const struct cx22702_config hauppauge_hvr_config = {
 	.output_mode   = CX22702_SERIAL_OUTPUT,
 };
 
-static int or51132_set_ts_param(struct dvb_frontend* fe, int is_punctured)
+static int or51132_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
+
 	dev->ts_gen_cntrl = is_punctured ? 0x04 : 0x00;
 	return 0;
 }
@@ -390,9 +386,9 @@ static const struct or51132_config pchdtv_hd3000 = {
 	.set_ts_params = or51132_set_ts_param,
 };
 
-static int lgdt330x_pll_rf_set(struct dvb_frontend* fe, int index)
+static int lgdt330x_pll_rf_set(struct dvb_frontend *fe, int index)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	dprintk(1, "%s: index = %d\n", __func__, index);
@@ -403,9 +399,10 @@ static int lgdt330x_pll_rf_set(struct dvb_frontend* fe, int index)
 	return 0;
 }
 
-static int lgdt330x_set_ts_param(struct dvb_frontend* fe, int is_punctured)
+static int lgdt330x_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
+
 	if (is_punctured)
 		dev->ts_gen_cntrl |= 0x04;
 	else
@@ -434,9 +431,10 @@ static const struct lgdt330x_config pchdtv_hd5500 = {
 	.set_ts_params = lgdt330x_set_ts_param,
 };
 
-static int nxt200x_set_ts_param(struct dvb_frontend* fe, int is_punctured)
+static int nxt200x_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
+
 	dev->ts_gen_cntrl = is_punctured ? 0x04 : 0x00;
 	return 0;
 }
@@ -446,18 +444,19 @@ static const struct nxt200x_config ati_hdtvwonder = {
 	.set_ts_params = nxt200x_set_ts_param,
 };
 
-static int cx24123_set_ts_param(struct dvb_frontend* fe,
+static int cx24123_set_ts_param(struct dvb_frontend *fe,
 	int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
+
 	dev->ts_gen_cntrl = 0x02;
 	return 0;
 }
 
-static int kworld_dvbs_100_set_voltage(struct dvb_frontend* fe,
+static int kworld_dvbs_100_set_voltage(struct dvb_frontend *fe,
 				       enum fe_sec_voltage voltage)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	if (voltage == SEC_VOLTAGE_OFF)
@@ -473,11 +472,11 @@ static int kworld_dvbs_100_set_voltage(struct dvb_frontend* fe,
 static int geniatech_dvbs_set_voltage(struct dvb_frontend *fe,
 				      enum fe_sec_voltage voltage)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	if (voltage == SEC_VOLTAGE_OFF) {
-		dprintk(1,"LNB Voltage OFF\n");
+		dprintk(1, "LNB Voltage OFF\n");
 		cx_write(MO_GP0_IO, 0x0000efff);
 	}
 
@@ -489,7 +488,7 @@ static int geniatech_dvbs_set_voltage(struct dvb_frontend *fe,
 static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,
 				  enum fe_sec_voltage voltage)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	cx_set(MO_GP0_IO, 0x6040);
@@ -688,6 +687,7 @@ static int cx24116_set_ts_param(struct dvb_frontend *fe,
 	int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
+
 	dev->ts_gen_cntrl = 0x2;
 
 	return 0;
@@ -697,6 +697,7 @@ static int stv0900_set_ts_param(struct dvb_frontend *fe,
 	int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
+
 	dev->ts_gen_cntrl = 0;
 
 	return 0;
@@ -734,6 +735,7 @@ static int ds3000_set_ts_param(struct dvb_frontend *fe,
 	int is_punctured)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
+
 	dev->ts_gen_cntrl = 4;
 
 	return 0;
@@ -1005,7 +1007,7 @@ static int dvb_register(struct cx8802_dev *dev)
 	int mfe_shared = 0; /* bus not shared by default */
 	int res = -EINVAL;
 
-	if (0 != core->i2c_rc) {
+	if (core->i2c_rc != 0) {
 		pr_err("no i2c-bus available, cannot attach dvb drivers\n");
 		goto frontend_detach;
 	}
@@ -1423,7 +1425,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		if (attach_xc3028(0x61, dev) < 0)
 			goto frontend_detach;
 		break;
-	 case CX88_BOARD_KWORLD_ATSC_120:
+	case CX88_BOARD_KWORLD_ATSC_120:
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 					       &kworld_atsc_120_config,
 					       &core->i2c_adap);
@@ -1617,7 +1619,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		break;
 	}
 
-	if ( (NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend) ) {
+	if ((NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend)) {
 		pr_err("frontend initialization failed\n");
 		goto frontend_detach;
 	}
@@ -1653,7 +1655,8 @@ static int cx8802_dvb_advise_acquire(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __func__);
+
+	dprintk(1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -1717,7 +1720,8 @@ static int cx8802_dvb_advise_release(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __func__);
+
+	dprintk(1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -1740,8 +1744,8 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 	struct vb2_dvb_frontend *fe;
 	int i;
 
-	dprintk( 1, "%s\n", __func__);
-	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
+	dprintk(1, "%s\n", __func__);
+	dprintk(1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
 		core->pci_bus,
@@ -1753,7 +1757,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 
 	/* If vp3054 isn't enabled, a stub will just return 0 */
 	err = vp3054_i2c_probe(dev);
-	if (0 != err)
+	if (err != 0)
 		goto fail_core;
 
 	/* dvb stuff */
@@ -1811,7 +1815,7 @@ static int cx8802_dvb_remove(struct cx8802_driver *drv)
 	struct cx88_core *core = drv->core;
 	struct cx8802_dev *dev = drv->core->dvbdev;
 
-	dprintk( 1, "%s\n", __func__);
+	dprintk(1, "%s\n", __func__);
 
 	vb2_dvb_unregister_bus(&dev->frontends);
 
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index 831f8db5150e..fe9ad1f8237a 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -1,31 +1,26 @@
 
 /*
-
-    cx88-i2c.c  --  all the i2c code is here
-
-    Copyright (C) 1996,97,98 Ralph  Metzler (rjkm@thp.uni-koeln.de)
-			   & Marcus Metzler (mocm@thp.uni-koeln.de)
-    (c) 2002 Yurij Sysoev <yurij@naturesoft.net>
-    (c) 1999-2003 Gerd Knorr <kraxel@bytesex.org>
-
-    (c) 2005 Mauro Carvalho Chehab <mchehab@infradead.org>
-	- Multituner support and i2c address binding
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
+ *
+ * cx88-i2c.c  --  all the i2c code is here
+ *
+ * Copyright (C) 1996,97,98 Ralph  Metzler (rjkm@thp.uni-koeln.de)
+ *			   & Marcus Metzler (mocm@thp.uni-koeln.de)
+ * (c) 2002 Yurij Sysoev <yurij@naturesoft.net>
+ * (c) 1999-2003 Gerd Knorr <kraxel@bytesex.org>
+ *
+ * (c) 2005 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *	- Multituner support and i2c address binding
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
 
 #include "cx88.h"
 
@@ -38,11 +33,11 @@
 
 static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
-MODULE_PARM_DESC(i2c_debug,"enable debug messages [i2c]");
+MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
 static unsigned int i2c_scan;
 module_param(i2c_scan, int, 0444);
-MODULE_PARM_DESC(i2c_scan,"scan i2c bus at insmod time");
+MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
 static unsigned int i2c_udelay = 5;
 module_param(i2c_udelay, int, 0644);
@@ -112,22 +107,22 @@ static const struct i2c_algo_bit_data cx8800_i2c_algo_template = {
 /* ----------------------------------------------------------------------- */
 
 static const char * const i2c_devs[128] = {
-	[ 0x1c >> 1 ] = "lgdt330x",
-	[ 0x86 >> 1 ] = "tda9887/cx22702",
-	[ 0xa0 >> 1 ] = "eeprom",
-	[ 0xc0 >> 1 ] = "tuner (analog)",
-	[ 0xc2 >> 1 ] = "tuner (analog/dvb)",
-	[ 0xc8 >> 1 ] = "xc5000",
+	[0x1c >> 1] = "lgdt330x",
+	[0x86 >> 1] = "tda9887/cx22702",
+	[0xa0 >> 1] = "eeprom",
+	[0xc0 >> 1] = "tuner (analog)",
+	[0xc2 >> 1] = "tuner (analog/dvb)",
+	[0xc8 >> 1] = "xc5000",
 };
 
 static void do_i2c_scan(const char *name, struct i2c_client *c)
 {
 	unsigned char buf;
-	int i,rc;
+	int i, rc;
 
 	for (i = 0; i < ARRAY_SIZE(i2c_devs); i++) {
 		c->addr = i;
-		rc = i2c_master_recv(c,&buf,0);
+		rc = i2c_master_recv(c, &buf, 0);
 		if (rc < 0)
 			continue;
 		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
@@ -139,14 +134,14 @@ static void do_i2c_scan(const char *name, struct i2c_client *c)
 int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 {
 	/* Prevents usage of invalid delay values */
-	if (i2c_udelay<5)
-		i2c_udelay=5;
+	if (i2c_udelay < 5)
+		i2c_udelay = 5;
 
 	core->i2c_algo = cx8800_i2c_algo_template;
 
 
 	core->i2c_adap.dev.parent = &pci->dev;
-	strlcpy(core->i2c_adap.name,core->name,sizeof(core->i2c_adap.name));
+	strlcpy(core->i2c_adap.name, core->name, sizeof(core->i2c_adap.name));
 	core->i2c_adap.owner = THIS_MODULE;
 	core->i2c_algo.udelay = i2c_udelay;
 	core->i2c_algo.data = core;
@@ -155,18 +150,18 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 	core->i2c_client.adapter = &core->i2c_adap;
 	strlcpy(core->i2c_client.name, "cx88xx internal", I2C_NAME_SIZE);
 
-	cx8800_bit_setscl(core,1);
-	cx8800_bit_setsda(core,1);
+	cx8800_bit_setscl(core, 1);
+	cx8800_bit_setsda(core, 1);
 
 	core->i2c_rc = i2c_bit_add_bus(&core->i2c_adap);
-	if (0 == core->i2c_rc) {
-		static u8 tuner_data[] =
-			{ 0x0b, 0xdc, 0x86, 0x52 };
-		static struct i2c_msg tuner_msg =
-			{ .flags = 0, .addr = 0xc2 >> 1, .buf = tuner_data, .len = 4 };
+	if (core->i2c_rc == 0) {
+		static u8 tuner_data[] = {
+			0x0b, 0xdc, 0x86, 0x52 };
+		static struct i2c_msg tuner_msg = {
+			.flags = 0, .addr = 0xc2 >> 1, .buf = tuner_data, .len = 4 };
 
 		dprintk(1, "i2c register ok\n");
-		switch( core->boardnr ) {
+		switch (core->boardnr) {
 			case CX88_BOARD_HAUPPAUGE_HVR1300:
 			case CX88_BOARD_HAUPPAUGE_HVR3000:
 			case CX88_BOARD_HAUPPAUGE_HVR4000:
@@ -177,7 +172,7 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 				break;
 		}
 		if (i2c_scan)
-			do_i2c_scan(core->name,&core->i2c_client);
+			do_i2c_scan(core->name, &core->i2c_client);
 	} else
 		pr_err("i2c register FAILED\n");
 
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 3a05629ba6e4..c072b7ecc8d6 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
 #include "cx88.h"
@@ -58,7 +54,7 @@ struct cx88_IR {
 	u32 mask_keyup;
 };
 
-static unsigned ir_samplerate = 4;
+static unsigned int ir_samplerate = 4;
 module_param(ir_samplerate, uint, 0444);
 MODULE_PARM_DESC(ir_samplerate, "IR samplerate in kHz, 1 - 20, default 4");
 
@@ -67,10 +63,10 @@ module_param(ir_debug, int, 0644);	/* debug level [IR] */
 MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
 #define ir_dprintk(fmt, arg...)	if (ir_debug) \
-	printk(KERN_DEBUG "%s IR: " fmt , ir->core->name , ##arg)
+	printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg)
 
 #define dprintk(fmt, arg...)	if (ir_debug) \
-	printk(KERN_DEBUG "cx88 IR: " fmt , ##arg)
+	printk(KERN_DEBUG "cx88 IR: " fmt, ##arg)
 
 /* ---------------------------------------------------------------------- */
 
@@ -97,7 +93,7 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		auxgpio = cx_read(MO_GP1_IO);
 		/* Take out the parity part */
-		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
+		gpio = (gpio & 0x7fd) + (auxgpio & 0xef);
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_DTV1800H:
@@ -512,7 +508,7 @@ int cx88_ir_fini(struct cx88_core *core)
 	struct cx88_IR *ir = core->ir;
 
 	/* skip detach on non attached boards */
-	if (NULL == ir)
+	if (ir == NULL)
 		return 0;
 
 	cx88_ir_stop(core);
@@ -530,7 +526,7 @@ void cx88_ir_irq(struct cx88_core *core)
 {
 	struct cx88_IR *ir = core->ir;
 	u32 samples;
-	unsigned todo, bits;
+	unsigned int todo, bits;
 	struct ir_raw_event ev;
 
 	if (!ir || !ir->sampling)
@@ -602,7 +598,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 	const unsigned short *addr_list = default_addr_list;
 	const unsigned short *addrp;
 	/* Instantiate the IR receiver device, if present */
-	if (0 != core->i2c_rc)
+	if (core->i2c_rc != 0)
 		return;
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index ed3fcc8149bd..4533e2c6cb9f 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -42,8 +42,8 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(CX88_VERSION);
 
 static unsigned int debug;
-module_param(debug,int,0644);
-MODULE_PARM_DESC(debug,"enable debug messages [mpeg]");
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable debug messages [mpeg]");
 
 #define dprintk(level, fmt, arg...) do {				\
 	if (debug + 1 > level)						\
@@ -54,7 +54,7 @@ MODULE_PARM_DESC(debug,"enable debug messages [mpeg]");
 #if defined(CONFIG_MODULES) && defined(MODULE)
 static void request_module_async(struct work_struct *work)
 {
-	struct cx8802_dev *dev=container_of(work, struct cx8802_dev, request_module_wk);
+	struct cx8802_dev *dev = container_of(work, struct cx8802_dev, request_module_wk);
 
 	if (dev->core->board.mpeg & CX88_MPEG_DVB)
 		request_module("cx88-dvb");
@@ -103,8 +103,8 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 
 	dprintk(1, "core->active_type_id = 0x%08x\n", core->active_type_id);
 
-	if ( (core->active_type_id == CX88_MPEG_DVB) &&
-		(core->board.mpeg & CX88_MPEG_DVB) ) {
+	if ((core->active_type_id == CX88_MPEG_DVB) &&
+		(core->board.mpeg & CX88_MPEG_DVB)) {
 
 		dprintk(1, "cx8802_start_dma doing .dvb\n");
 		/* negedge driven & software reset */
@@ -148,8 +148,8 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 		}
 		cx_write(TS_GEN_CNTRL, dev->ts_gen_cntrl);
 		udelay(100);
-	} else if ( (core->active_type_id == CX88_MPEG_BLACKBIRD) &&
-		(core->board.mpeg & CX88_MPEG_BLACKBIRD) ) {
+	} else if ((core->active_type_id == CX88_MPEG_BLACKBIRD) &&
+		(core->board.mpeg & CX88_MPEG_BLACKBIRD)) {
 		dprintk(1, "cx8802_start_dma doing .blackbird\n");
 		cx_write(MO_PINMUX_IO, 0x88); /* enable MPEG parallel IO */
 
@@ -185,6 +185,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 static int cx8802_stop_dma(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
+
 	dprintk(1, "\n");
 
 	/* stop dma */
@@ -209,7 +210,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 		return 0;
 
 	buf = list_entry(q->active.next, struct cx88_buffer, list);
-	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
+	dprintk(2, "restart_queue [%p/%d]: restart dma\n",
 		buf, buf->vb.vb2_buf.index);
 	cx8802_start_dma(dev, q, buf);
 	return 0;
@@ -254,7 +255,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 	if (list_empty(&cx88q->active)) {
 		dprintk(1, "queue is empty - first active\n");
 		list_add_tail(&buf->list, &cx88q->active);
-		dprintk(1,"[%p/%d] %s - first active\n",
+		dprintk(1, "[%p/%d] %s - first active\n",
 			buf, buf->vb.vb2_buf.index, __func__);
 
 	} else {
@@ -276,13 +277,13 @@ static void do_cancel_buffers(struct cx8802_dev *dev)
 	struct cx88_buffer *buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->slock,flags);
+	spin_lock_irqsave(&dev->slock, flags);
 	while (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx88_buffer, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
-	spin_unlock_irqrestore(&dev->slock,flags);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
 void cx8802_cancel_buffers(struct cx8802_dev *dev)
@@ -292,7 +293,7 @@ void cx8802_cancel_buffers(struct cx8802_dev *dev)
 	do_cancel_buffers(dev);
 }
 
-static const char * cx88_mpeg_irqs[32] = {
+static const char *cx88_mpeg_irqs[32] = {
 	"ts_risci1", NULL, NULL, NULL,
 	"ts_risci2", NULL, NULL, NULL,
 	"ts_oflow",  NULL, NULL, NULL,
@@ -356,7 +357,7 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
 	for (loop = 0; loop < MAX_IRQ_LOOP; loop++) {
 		status = cx_read(MO_PCI_INTSTAT) &
 			(core->pci_irqmask | PCI_INT_TSINT);
-		if (0 == status)
+		if (status == 0)
 			goto out;
 		dprintk(1, "cx8802_irq\n");
 		dprintk(1, "    loop: %d/%d\n", loop, MAX_IRQ_LOOP);
@@ -365,14 +366,14 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
 		cx_write(MO_PCI_INTSTAT, status);
 
 		if (status & core->pci_irqmask)
-			cx88_core_irq(core,status);
+			cx88_core_irq(core, status);
 		if (status & PCI_INT_TSINT)
 			cx8802_mpeg_irq(dev);
 	}
-	if (MAX_IRQ_LOOP == loop) {
+	if (loop == MAX_IRQ_LOOP) {
 		dprintk(0, "clearing mask\n");
 		pr_warn("irq loop -- clearing mask\n");
-		cx_write(MO_PCI_INTMSK,0);
+		cx_write(MO_PCI_INTMSK, 0);
 	}
 
  out:
@@ -388,7 +389,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 	if (pci_enable_device(dev->pci))
 		return -EIO;
 	pci_set_master(dev->pci);
-	err = pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32));
+	err = pci_set_dma_mask(dev->pci, DMA_BIT_MASK(32));
 	if (err) {
 		pr_err("Oops: no 32bit PCI DMA ???\n");
 		return -EIO;
@@ -417,7 +418,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
 
 	/* everything worked */
-	pci_set_drvdata(dev->pci,dev);
+	pci_set_drvdata(dev->pci, dev);
 	return 0;
 }
 
@@ -451,7 +452,7 @@ static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 	cx88_shutdown(dev->core);
 
 	pci_save_state(pci_dev);
-	if (0 != pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state))) {
+	if (pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state)) != 0) {
 		pci_disable_device(pci_dev);
 		dev->state.disabled = 1;
 	}
@@ -465,14 +466,14 @@ static int cx8802_resume_common(struct pci_dev *pci_dev)
 	int err;
 
 	if (dev->state.disabled) {
-		err=pci_enable_device(pci_dev);
+		err = pci_enable_device(pci_dev);
 		if (err) {
 			pr_err("can't enable device\n");
 			return err;
 		}
 		dev->state.disabled = 0;
 	}
-	err=pci_set_power_state(pci_dev, PCI_D0);
+	err = pci_set_power_state(pci_dev, PCI_D0);
 	if (err) {
 		pr_err("can't enable device\n");
 		pci_disable_device(pci_dev);
@@ -489,14 +490,14 @@ static int cx8802_resume_common(struct pci_dev *pci_dev)
 	spin_lock_irqsave(&dev->slock, flags);
 	if (!list_empty(&dev->mpegq.active)) {
 		pr_info("resume mpeg\n");
-		cx8802_restart_queue(dev,&dev->mpegq);
+		cx8802_restart_queue(dev, &dev->mpegq);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
 	return 0;
 }
 
-struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype)
+struct cx8802_driver *cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype)
 {
 	struct cx8802_driver *d;
 
@@ -613,7 +614,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 			dev->core->boardnr);
 
 		/* Bring up a new struct for each driver instance */
-		driver = kzalloc(sizeof(*drv),GFP_KERNEL);
+		driver = kzalloc(sizeof(*drv), GFP_KERNEL);
 		if (driver == NULL) {
 			err = -ENOMEM;
 			goto out;
@@ -696,7 +697,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
 	/* general setup */
 	core = cx88_core_get(pci_dev);
-	if (NULL == core)
+	if (core == NULL)
 		return -EINVAL;
 
 	pr_info("cx2388x 8802 Driver Manager\n");
@@ -706,8 +707,8 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 		goto fail_core;
 
 	err = -ENOMEM;
-	dev = kzalloc(sizeof(*dev),GFP_KERNEL);
-	if (NULL == dev)
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
 		goto fail_core;
 	dev->pci = pci_dev;
 	dev->core = core;
@@ -721,7 +722,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
 	INIT_LIST_HEAD(&dev->drvlist);
 	mutex_lock(&cx8802_mutex);
-	list_add_tail(&dev->devlist,&cx8802_devlist);
+	list_add_tail(&dev->devlist, &cx8802_devlist);
 	mutex_unlock(&cx8802_mutex);
 
 	/* now autoload cx88-dvb or cx88-blackbird */
@@ -732,7 +733,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	kfree(dev);
  fail_core:
 	core->dvbdev = NULL;
-	cx88_core_put(core,pci_dev);
+	cx88_core_put(core, pci_dev);
 	return err;
 }
 
@@ -772,7 +773,7 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 
 	/* common */
 	cx8802_fini_common(dev);
-	cx88_core_put(dev->core,dev->pci);
+	cx88_core_put(dev->core, dev->pci);
 	kfree(dev);
 }
 
@@ -782,7 +783,7 @@ static const struct pci_device_id cx8802_pci_tbl[] = {
 		.device       = 0x8802,
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
-	},{
+	}, {
 		/* --- end of list --- */
 	}
 };
diff --git a/drivers/media/pci/cx88/cx88-reg.h b/drivers/media/pci/cx88/cx88-reg.h
index 2ec52d1cdea0..3ea29151b6a7 100644
--- a/drivers/media/pci/cx88/cx88-reg.h
+++ b/drivers/media/pci/cx88/cx88-reg.h
@@ -576,7 +576,7 @@
 #define RISC_CNT_INC		 0x00010000
 #define RISC_CNT_RSVR		 0x00020000
 #define RISC_CNT_RESET		 0x00030000
-#define RISC_JMP_SRP         	 0x01
+#define RISC_JMP_SRP		 0x01
 
 
 /* ---------------------------------------------------------------------- */
@@ -822,8 +822,7 @@
 #define DEFAULT_SAT_U_NTSC			0x7F
 #define DEFAULT_SAT_V_NTSC			0x5A
 
-typedef enum
-{
+typedef enum {
 	SOURCE_TUNER = 0,
 	SOURCE_COMPOSITE,
 	SOURCE_SVIDEO,
diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
index b1d8680235e6..20f6924abe35 100644
--- a/drivers/media/pci/cx88/cx88-tvaudio.c
+++ b/drivers/media/pci/cx88/cx88-tvaudio.c
@@ -1,39 +1,34 @@
 /*
-
-    cx88x-audio.c - Conexant CX23880/23881 audio downstream driver driver
-
-     (c) 2001 Michael Eskin, Tom Zakrajsek [Windows version]
-     (c) 2002 Yurij Sysoev <yurij@naturesoft.net>
-     (c) 2003 Gerd Knorr <kraxel@bytesex.org>
-
-    -----------------------------------------------------------------------
-
-    Lot of voodoo here.  Even the data sheet doesn't help to
-    understand what is going on here, the documentation for the audio
-    part of the cx2388x chip is *very* bad.
-
-    Some of this comes from party done linux driver sources I got from
-    [undocumented].
-
-    Some comes from the dscaler sources, one of the dscaler driver guy works
-    for Conexant ...
-
-    -----------------------------------------------------------------------
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
+ * cx88x-audio.c - Conexant CX23880/23881 audio downstream driver driver
+ *
+ *  (c) 2001 Michael Eskin, Tom Zakrajsek [Windows version]
+ *  (c) 2002 Yurij Sysoev <yurij@naturesoft.net>
+ *  (c) 2003 Gerd Knorr <kraxel@bytesex.org>
+ *
+ * -----------------------------------------------------------------------
+ *
+ * Lot of voodoo here.  Even the data sheet doesn't help to
+ * understand what is going on here, the documentation for the audio
+ * part of the cx2388x chip is *very* bad.
+ *
+ * Some of this comes from party done linux driver sources I got from
+ * [undocumented].
+ *
+ * Some comes from the dscaler sources, one of the dscaler driver guy works
+ * for Conexant ...
+ *
+ * -----------------------------------------------------------------------
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
 
 #include "cx88.h"
 
@@ -57,11 +52,11 @@ module_param(audio_debug, int, 0644);
 MODULE_PARM_DESC(audio_debug, "enable debug messages [audio]");
 
 static unsigned int always_analog;
-module_param(always_analog,int,0644);
-MODULE_PARM_DESC(always_analog,"force analog audio out");
+module_param(always_analog, int, 0644);
+MODULE_PARM_DESC(always_analog, "force analog audio out");
 
 static unsigned int radio_deemphasis;
-module_param(radio_deemphasis,int,0644);
+module_param(radio_deemphasis, int, 0644);
 MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, 0=None, 1=50us (elsewhere), 2=75us (USA)");
 
 #define dprintk(fmt, arg...) do {				\
@@ -350,7 +345,7 @@ static void set_audio_standard_NICAM(struct cx88_core *core, u32 mode)
 		{ /* end of list */ },
 	};
 
-	set_audio_start(core,SEL_NICAM);
+	set_audio_start(core, SEL_NICAM);
 	switch (core->tvaudio) {
 	case WW_L:
 		dprintk("%s SECAM-L NICAM (status: devel)\n", __func__);
@@ -770,7 +765,7 @@ void cx88_set_tvaudio(struct cx88_core *core)
 		/* set nicam mode - otherwise
 		   AUD_NICAM_STATUS2 contains wrong values */
 		set_audio_standard_NICAM(core, EN_NICAM_AUTO_STEREO);
-		if (0 == cx88_detect_nicam(core)) {
+		if (cx88_detect_nicam(core) == 0) {
 			/* fall back to fm / am mono */
 			set_audio_standard_A2(core, EN_A2_FORCE_MONO1);
 			core->audiomode_current = V4L2_TUNER_MODE_MONO;
@@ -869,11 +864,11 @@ void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
 	}
 
 	/* If software stereo detection is not supported... */
-	if (UNSET == t->rxsubchans) {
+	if (t->rxsubchans == UNSET) {
 		t->rxsubchans = V4L2_TUNER_SUB_MONO;
 		/* If the hardware itself detected stereo, also return
 		   stereo as an available subchannel */
-		if (V4L2_TUNER_MODE_STEREO == t->audmode)
+		if (t->audmode == V4L2_TUNER_MODE_STEREO)
 			t->rxsubchans |= V4L2_TUNER_SUB_STEREO;
 	}
 	return;
@@ -887,7 +882,7 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 	if (manual) {
 		core->audiomode_manual = mode;
 	} else {
-		if (UNSET != core->audiomode_manual)
+		if (core->audiomode_manual != UNSET)
 			return;
 	}
 	core->audiomode_current = mode;
@@ -915,7 +910,7 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 	case WW_M:
 	case WW_I:
 	case WW_L:
-		if (1 == core->use_nicam) {
+		if (core->use_nicam == 1) {
 			switch (mode) {
 			case V4L2_TUNER_MODE_MONO:
 			case V4L2_TUNER_MODE_LANG1:
@@ -975,7 +970,7 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 		break;
 	}
 
-	if (UNSET != ctl) {
+	if (ctl != UNSET) {
 		dprintk("cx88_set_stereo: mask 0x%x, ctl 0x%x [status=0x%x,ctl=0x%x,vol=0x%x]\n",
 			mask, ctl, cx_read(AUD_STATUS),
 			cx_read(AUD_CTL), cx_sread(SHADOW_AUD_VOL_CTL));
@@ -1011,7 +1006,7 @@ int cx88_audio_thread(void *data)
 			memset(&t, 0, sizeof(t));
 			cx88_get_stereo(core, &t);
 
-			if (UNSET != core->audiomode_manual)
+			if (core->audiomode_manual != UNSET)
 				/* manually set, don't do anything. */
 				continue;
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 227f0f66e015..9028822f507e 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -8,8 +8,8 @@
 #include <linux/init.h>
 
 static unsigned int vbi_debug;
-module_param(vbi_debug,int,0644);
-MODULE_PARM_DESC(vbi_debug,"enable debug messages [vbi]");
+module_param(vbi_debug, int, 0644);
+MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
 
 #define dprintk(level, fmt, arg...) do {			\
 	if (vbi_debug >= level)					\
@@ -19,7 +19,7 @@ MODULE_PARM_DESC(vbi_debug,"enable debug messages [vbi]");
 
 /* ------------------------------------------------------------------ */
 
-int cx8800_vbi_fmt (struct file *file, void *priv,
+int cx8800_vbi_fmt(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
@@ -57,9 +57,9 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 	cx88_sram_channel_setup(dev->core, &cx88_sram_channels[SRAM_CH24],
 				VBI_LINE_LENGTH, buf->risc.dma);
 
-	cx_write(MO_VBOS_CONTROL, ( (1 << 18) |  // comb filter delay fixup
+	cx_write(MO_VBOS_CONTROL, ((1 << 18) |  // comb filter delay fixup
 				    (1 << 15) |  // enable vbi capture
-				    (1 << 11) ));
+				    (1 << 11)));
 
 	/* reset counter */
 	cx_write(MO_VBI_GPCNTRL, GP_COUNT_CONTROL_RESET);
@@ -70,7 +70,7 @@ static int cx8800_start_vbi_dma(struct cx8800_dev    *dev,
 	cx_set(MO_VID_INTMSK, 0x0f0088);
 
 	/* enable capture */
-	cx_set(VID_CAPTURE_CONTROL,0x18);
+	cx_set(VID_CAPTURE_CONTROL, 0x18);
 
 	/* start dma */
 	cx_set(MO_DEV_CNTRL2, (1<<5));
@@ -87,7 +87,7 @@ void cx8800_stop_vbi_dma(struct cx8800_dev *dev)
 	cx_clear(MO_VID_DMACNTRL, 0x88);
 
 	/* disable capture */
-	cx_clear(VID_CAPTURE_CONTROL,0x18);
+	cx_clear(VID_CAPTURE_CONTROL, 0x18);
 
 	/* disable irqs */
 	cx_clear(MO_PCI_INTMSK, PCI_INT_VIDINT);
@@ -103,7 +103,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 		return 0;
 
 	buf = list_entry(q->active.next, struct cx88_buffer, list);
-	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
+	dprintk(2, "restart_queue [%p/%d]: restart dma\n",
 		buf, buf->vb.vb2_buf.index);
 	cx8800_start_vbi_dma(dev, q, buf);
 	return 0;
@@ -179,7 +179,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
 		cx8800_start_vbi_dma(dev, q, buf);
-		dprintk(2,"[%p/%d] vbi_queue - first active\n",
+		dprintk(2, "[%p/%d] vbi_queue - first active\n",
 			buf, buf->vb.vb2_buf.index);
 
 	} else {
@@ -187,7 +187,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		prev = list_entry(q->active.prev, struct cx88_buffer, list);
 		list_add_tail(&buf->list, &q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-		dprintk(2,"[%p/%d] buffer_queue - append to active\n",
+		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
 			buf, buf->vb.vb2_buf.index);
 	}
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 3d349dfb23ff..a4dda109da03 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -19,10 +19,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx88.h"
@@ -59,17 +55,17 @@ module_param_array(video_nr, int, NULL, 0444);
 module_param_array(vbi_nr,   int, NULL, 0444);
 module_param_array(radio_nr, int, NULL, 0444);
 
-MODULE_PARM_DESC(video_nr,"video device numbers");
-MODULE_PARM_DESC(vbi_nr,"vbi device numbers");
-MODULE_PARM_DESC(radio_nr,"radio device numbers");
+MODULE_PARM_DESC(video_nr, "video device numbers");
+MODULE_PARM_DESC(vbi_nr, "vbi device numbers");
+MODULE_PARM_DESC(radio_nr, "radio device numbers");
 
 static unsigned int video_debug;
-module_param(video_debug,int,0644);
-MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
+module_param(video_debug, int, 0644);
+MODULE_PARM_DESC(video_debug, "enable debug messages [video]");
 
 static unsigned int irq_debug;
-module_param(irq_debug,int,0644);
-MODULE_PARM_DESC(irq_debug,"enable debug messages [IRQ handler]");
+module_param(irq_debug, int, 0644);
+MODULE_PARM_DESC(irq_debug, "enable debug messages [IRQ handler]");
 
 #define dprintk(level, fmt, arg...) do {			\
 	if (video_debug >= level)				\
@@ -88,55 +84,55 @@ static const struct cx8800_fmt formats[] = {
 		.cxformat = ColorFormatY8,
 		.depth    = 8,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "15 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_RGB555,
 		.cxformat = ColorFormatRGB15,
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "15 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB555X,
 		.cxformat = ColorFormatRGB15 | ColorFormatBSWAP,
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "16 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_RGB565,
 		.cxformat = ColorFormatRGB16,
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "16 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB565X,
 		.cxformat = ColorFormatRGB16 | ColorFormatBSWAP,
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "24 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_BGR24,
 		.cxformat = ColorFormatRGB24,
 		.depth    = 24,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "32 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_BGR32,
 		.cxformat = ColorFormatRGB32,
 		.depth    = 32,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "32 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB32,
 		.cxformat = ColorFormatRGB32 | ColorFormatBSWAP | ColorFormatWSWAP,
 		.depth    = 32,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "4:2:2, packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.cxformat = ColorFormatYUY2,
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
-	},{
+	}, {
 		.name     = "4:2:2, packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.cxformat = ColorFormatYUY2 | ColorFormatBSWAP,
@@ -145,7 +141,7 @@ static const struct cx8800_fmt formats[] = {
 	},
 };
 
-static const struct cx8800_fmt* format_by_fourcc(unsigned int fourcc)
+static const struct cx8800_fmt *format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -185,7 +181,7 @@ static const struct cx88_ctrl cx8800_vid_ctls[] = {
 		.reg           = MO_CONTR_BRIGHT,
 		.mask          = 0x00ff,
 		.shift         = 0,
-	},{
+	}, {
 		.id            = V4L2_CID_CONTRAST,
 		.minimum       = 0,
 		.maximum       = 0xff,
@@ -195,7 +191,7 @@ static const struct cx88_ctrl cx8800_vid_ctls[] = {
 		.reg           = MO_CONTR_BRIGHT,
 		.mask          = 0xff00,
 		.shift         = 8,
-	},{
+	}, {
 		.id            = V4L2_CID_HUE,
 		.minimum       = 0,
 		.maximum       = 0xff,
@@ -205,7 +201,7 @@ static const struct cx88_ctrl cx8800_vid_ctls[] = {
 		.reg           = MO_HUE,
 		.mask          = 0x00ff,
 		.shift         = 0,
-	},{
+	}, {
 		/* strictly, this only describes only U saturation.
 		 * V saturation is handled specially through code.
 		 */
@@ -270,7 +266,7 @@ static const struct cx88_ctrl cx8800_aud_ctls[] = {
 		.sreg          = SHADOW_AUD_VOL_CTL,
 		.mask          = (1 << 6),
 		.shift         = 6,
-	},{
+	}, {
 		.id            = V4L2_CID_AUDIO_VOLUME,
 		.minimum       = 0,
 		.maximum       = 0x3f,
@@ -280,7 +276,7 @@ static const struct cx88_ctrl cx8800_aud_ctls[] = {
 		.sreg          = SHADOW_AUD_VOL_CTL,
 		.mask          = 0x3f,
 		.shift         = 0,
-	},{
+	}, {
 		.id            = V4L2_CID_AUDIO_BALANCE,
 		.minimum       = 0,
 		.maximum       = 0x7f,
@@ -304,10 +300,10 @@ int cx88_video_mux(struct cx88_core *core, unsigned int input)
 {
 	/* struct cx88_core *core = dev->core; */
 
-	dprintk(1,"video_mux: %d [vmux=%d,gpio=0x%x,0x%x,0x%x,0x%x]\n",
+	dprintk(1, "video_mux: %d [vmux=%d,gpio=0x%x,0x%x,0x%x,0x%x]\n",
 		input, INPUT(input).vmux,
-		INPUT(input).gpio0,INPUT(input).gpio1,
-		INPUT(input).gpio2,INPUT(input).gpio3);
+		INPUT(input).gpio0, INPUT(input).gpio1,
+		INPUT(input).gpio2, INPUT(input).gpio3);
 	core->input = input;
 	cx_andor(MO_INPUT_FORMAT, 0x03 << 14, INPUT(input).vmux << 14);
 	cx_write(MO_GP3_IO, INPUT(input).gpio3);
@@ -374,7 +370,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	cx_write(MO_COLOR_CTRL, dev->fmt->cxformat | ColorFormatGamma);
 
 	/* reset counter */
-	cx_write(MO_VIDY_GPCNTRL,GP_COUNT_CONTROL_RESET);
+	cx_write(MO_VIDY_GPCNTRL, GP_COUNT_CONTROL_RESET);
 	q->count = 0;
 
 	/* enable irqs */
@@ -390,7 +386,7 @@ static int start_video_dma(struct cx8800_dev    *dev,
 	cx_set(MO_VID_INTMSK, 0x0f0011);
 
 	/* enable capture */
-	cx_set(VID_CAPTURE_CONTROL,0x06);
+	cx_set(VID_CAPTURE_CONTROL, 0x06);
 
 	/* start dma */
 	cx_set(MO_DEV_CNTRL2, (1<<5));
@@ -408,7 +404,7 @@ static int stop_video_dma(struct cx8800_dev    *dev)
 	cx_clear(MO_VID_DMACNTRL, 0x11);
 
 	/* disable capture */
-	cx_clear(VID_CAPTURE_CONTROL,0x06);
+	cx_clear(VID_CAPTURE_CONTROL, 0x06);
 
 	/* disable irqs */
 	cx_clear(MO_PCI_INTMSK, PCI_INT_VIDINT);
@@ -423,7 +419,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 
 	if (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx88_buffer, list);
-		dprintk(2,"restart_queue [%p/%d]: restart dma\n",
+		dprintk(2, "restart_queue [%p/%d]: restart dma\n",
 			buf, buf->vb.vb2_buf.index);
 		start_video_dma(dev, q, buf);
 	}
@@ -492,7 +488,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 				 core->height >> 1);
 		break;
 	}
-	dprintk(2,"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
+	dprintk(2, "[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.vb2_buf.index,
 		core->width, core->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
@@ -526,7 +522,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
-		dprintk(2,"[%p/%d] buffer_queue - first active\n",
+		dprintk(2, "[%p/%d] buffer_queue - first active\n",
 			buf, buf->vb.vb2_buf.index);
 
 	} else {
@@ -668,7 +664,7 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 	struct cx88_core *core =
 		container_of(ctrl->handler, struct cx88_core, audio_hdl);
 	const struct cx88_ctrl *cc = ctrl->priv;
-	u32 value,mask;
+	u32 value, mask;
 
 	/* Pass changes onto any WM8775 */
 	if (core->sd_wm8775) {
@@ -700,7 +696,7 @@ static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
 		break;
 	}
-	dprintk(1,"set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
+	dprintk(1, "set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
 				ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
 				mask, cc->sreg ? " [shadowed]" : "");
 	if (cc->sreg)
@@ -741,7 +737,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	unsigned int      maxw, maxh;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-	if (NULL == fmt)
+	if (fmt == NULL)
 		return -EINVAL;
 
 	maxw = norm_maxw(core->tvnorm);
@@ -782,9 +778,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
-	int err = vidioc_try_fmt_vid_cap (file,priv,f);
+	int err = vidioc_try_fmt_vid_cap(file, priv, f);
 
-	if (0 != err)
+	if (err != 0)
 		return err;
 	if (vb2_is_busy(&dev->vb2_vidq) || vb2_is_busy(&dev->vb2_vbiq))
 		return -EBUSY;
@@ -804,7 +800,7 @@ void cx88_querycap(struct file *file, struct cx88_core *core,
 
 	strlcpy(cap->card, core->board.name, sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-	if (UNSET != core->board.tuner_type)
+	if (core->board.tuner_type != UNSET)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_RADIO:
@@ -836,13 +832,13 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
+static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
 	if (unlikely(f->index >= ARRAY_SIZE(formats)))
 		return -EINVAL;
 
-	strlcpy(f->description,formats[f->index].name,sizeof(f->description));
+	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].fourcc;
 
 	return 0;
@@ -866,18 +862,18 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 }
 
 /* only one input in this sample driver */
-int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i)
+int cx88_enum_input(struct cx88_core  *core, struct v4l2_input *i)
 {
 	static const char * const iname[] = {
-		[ CX88_VMUX_COMPOSITE1 ] = "Composite1",
-		[ CX88_VMUX_COMPOSITE2 ] = "Composite2",
-		[ CX88_VMUX_COMPOSITE3 ] = "Composite3",
-		[ CX88_VMUX_COMPOSITE4 ] = "Composite4",
-		[ CX88_VMUX_SVIDEO     ] = "S-Video",
-		[ CX88_VMUX_TELEVISION ] = "Television",
-		[ CX88_VMUX_CABLE      ] = "Cable TV",
-		[ CX88_VMUX_DVB        ] = "DVB",
-		[ CX88_VMUX_DEBUG      ] = "for debug only",
+		[CX88_VMUX_COMPOSITE1] = "Composite1",
+		[CX88_VMUX_COMPOSITE2] = "Composite2",
+		[CX88_VMUX_COMPOSITE3] = "Composite3",
+		[CX88_VMUX_COMPOSITE4] = "Composite4",
+		[CX88_VMUX_SVIDEO] = "S-Video",
+		[CX88_VMUX_TELEVISION] = "Television",
+		[CX88_VMUX_CABLE] = "Cable TV",
+		[CX88_VMUX_DVB] = "DVB",
+		[CX88_VMUX_DEBUG] = "for debug only",
 	};
 	unsigned int n = i->index;
 
@@ -886,7 +882,7 @@ int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i)
 	if (0 == INPUT(n).type)
 		return -EINVAL;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(i->name,iname[INPUT(n).type]);
+	strcpy(i->name, iname[INPUT(n).type]);
 	if ((CX88_VMUX_TELEVISION == INPUT(n).type) ||
 	    (CX88_VMUX_CABLE      == INPUT(n).type)) {
 		i->type = V4L2_INPUT_TYPE_TUNER;
@@ -896,15 +892,16 @@ int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i)
 }
 EXPORT_SYMBOL(cx88_enum_input);
 
-static int vidioc_enum_input (struct file *file, void *priv,
+static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
-	return cx88_enum_input (core,i);
+
+	return cx88_enum_input(core, i);
 }
 
-static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -913,7 +910,7 @@ static int vidioc_g_input (struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
@@ -924,20 +921,20 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 		return -EINVAL;
 
 	cx88_newstation(core);
-	cx88_video_mux(core,i);
+	cx88_video_mux(core, i);
 	return 0;
 }
 
-static int vidioc_g_tuner (struct file *file, void *priv,
+static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 	u32 reg;
 
-	if (unlikely(UNSET == core->board.tuner_type))
+	if (unlikely(core->board.tuner_type == UNSET))
 		return -EINVAL;
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	strcpy(t->name, "Television");
@@ -945,34 +942,34 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 	t->rangehigh  = 0xffffffffUL;
 	call_all(core, tuner, g_tuner, t);
 
-	cx88_get_stereo(core ,t);
+	cx88_get_stereo(core, t);
 	reg = cx_read(MO_DEVICE_STATUS);
 	t->signal = (reg & (1<<5)) ? 0xffff : 0x0000;
 	return 0;
 }
 
-static int vidioc_s_tuner (struct file *file, void *priv,
+static int vidioc_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	if (UNSET == core->board.tuner_type)
+	if (core->board.tuner_type == UNSET)
 		return -EINVAL;
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	cx88_set_stereo(core, t->audmode, 1);
 	return 0;
 }
 
-static int vidioc_g_frequency (struct file *file, void *priv,
+static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	if (unlikely(UNSET == core->board.tuner_type))
+	if (unlikely(core->board.tuner_type == UNSET))
 		return -EINVAL;
 	if (f->tuner)
 		return -EINVAL;
@@ -984,12 +981,12 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 	return 0;
 }
 
-int cx88_set_freq (struct cx88_core  *core,
+int cx88_set_freq(struct cx88_core  *core,
 				const struct v4l2_frequency *f)
 {
 	struct v4l2_frequency new_freq = *f;
 
-	if (unlikely(UNSET == core->board.tuner_type))
+	if (unlikely(core->board.tuner_type == UNSET))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
@@ -1000,14 +997,14 @@ int cx88_set_freq (struct cx88_core  *core,
 	core->freq = new_freq.frequency;
 
 	/* When changing channels it is required to reset TVAUDIO */
-	msleep (10);
+	msleep(10);
 	cx88_set_tvaudio(core);
 
 	return 0;
 }
 EXPORT_SYMBOL(cx88_set_freq);
 
-static int vidioc_s_frequency (struct file *file, void *priv,
+static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
@@ -1017,7 +1014,7 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vidioc_g_register (struct file *file, void *fh,
+static int vidioc_g_register(struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
@@ -1029,7 +1026,7 @@ static int vidioc_g_register (struct file *file, void *fh,
 	return 0;
 }
 
-static int vidioc_s_register (struct file *file, void *fh,
+static int vidioc_s_register(struct file *file, void *fh,
 				const struct v4l2_dbg_register *reg)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
@@ -1044,7 +1041,7 @@ static int vidioc_s_register (struct file *file, void *fh,
 /* RADIO ESPECIFIC IOCTLS                                      */
 /* ----------------------------------------------------------- */
 
-static int radio_g_tuner (struct file *file, void *priv,
+static int radio_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
@@ -1059,13 +1056,13 @@ static int radio_g_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_s_tuner (struct file *file, void *priv,
+static int radio_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	call_all(core, tuner, s_tuner, t);
@@ -1132,19 +1129,19 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
 	for (loop = 0; loop < 10; loop++) {
 		status = cx_read(MO_PCI_INTSTAT) &
 			(core->pci_irqmask | PCI_INT_VIDINT);
-		if (0 == status)
+		if (status == 0)
 			goto out;
 		cx_write(MO_PCI_INTSTAT, status);
 		handled = 1;
 
 		if (status & core->pci_irqmask)
-			cx88_core_irq(core,status);
+			cx88_core_irq(core, status);
 		if (status & PCI_INT_VIDINT)
 			cx8800_vid_irq(dev);
 	}
-	if (10 == loop) {
+	if (loop == 10) {
 		pr_warn("irq loop -- clearing mask\n");
-		cx_write(MO_PCI_INTMSK,0);
+		cx_write(MO_PCI_INTMSK, 0);
 	}
 
  out:
@@ -1154,8 +1151,8 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
 /* ----------------------------------------------------------- */
 /* exported stuff                                              */
 
-static const struct v4l2_file_operations video_fops =
-{
+static const struct v4l2_file_operations video_fops = {
+
 	.owner	       = THIS_MODULE,
 	.open	       = v4l2_fh_open,
 	.release       = vb2_fop_release,
@@ -1197,7 +1194,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 static const struct video_device cx8800_video_template = {
 	.name                 = "cx8800-video",
 	.fops                 = &video_fops,
-	.ioctl_ops 	      = &video_ioctl_ops,
+	.ioctl_ops	      = &video_ioctl_ops,
 	.tvnorms              = CX88_NORMS,
 };
 
@@ -1234,8 +1231,8 @@ static const struct video_device cx8800_vbi_template = {
 	.tvnorms              = CX88_NORMS,
 };
 
-static const struct v4l2_file_operations radio_fops =
-{
+static const struct v4l2_file_operations radio_fops = {
+
 	.owner         = THIS_MODULE,
 	.open          = radio_open,
 	.poll          = v4l2_ctrl_poll,
@@ -1260,7 +1257,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 static const struct video_device cx8800_radio_template = {
 	.name                 = "cx8800-radio",
 	.fops                 = &radio_fops,
-	.ioctl_ops 	      = &radio_ioctl_ops,
+	.ioctl_ops	      = &radio_ioctl_ops,
 };
 
 static const struct v4l2_ctrl_ops cx8800_ctrl_vid_ops = {
@@ -1289,8 +1286,8 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	int err;
 	int i;
 
-	dev = kzalloc(sizeof(*dev),GFP_KERNEL);
-	if (NULL == dev)
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
 		return -ENOMEM;
 
 	/* pci init */
@@ -1300,7 +1297,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		goto fail_free;
 	}
 	core = cx88_core_get(dev->pci);
-	if (NULL == core) {
+	if (core == NULL) {
 		err = -EINVAL;
 		goto fail_free;
 	}
@@ -1315,7 +1312,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		(unsigned long long)pci_resource_start(pci_dev, 0));
 
 	pci_set_master(pci_dev);
-	err = pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32));
+	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
 	if (err) {
 		pr_err("Oops: no 32bit PCI DMA ???\n");
 		goto fail_core;
@@ -1524,7 +1521,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	mutex_unlock(&core->lock);
 fail_core:
 	core->v4ldev = NULL;
-	cx88_core_put(core,dev->pci);
+	cx88_core_put(core, dev->pci);
 fail_free:
 	kfree(dev);
 	return err;
@@ -1555,7 +1552,7 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 	core->v4ldev = NULL;
 
 	/* free memory */
-	cx88_core_put(core,dev->pci);
+	cx88_core_put(core, dev->pci);
 	kfree(dev);
 }
 
@@ -1584,7 +1581,7 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	cx88_shutdown(core);
 
 	pci_save_state(pci_dev);
-	if (0 != pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state))) {
+	if (pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state)) != 0) {
 		pci_disable_device(pci_dev);
 		dev->state.disabled = 1;
 	}
@@ -1599,7 +1596,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	int err;
 
 	if (dev->state.disabled) {
-		err=pci_enable_device(pci_dev);
+		err = pci_enable_device(pci_dev);
 		if (err) {
 			pr_err("can't enable device\n");
 			return err;
@@ -1607,7 +1604,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 
 		dev->state.disabled = 0;
 	}
-	err= pci_set_power_state(pci_dev, PCI_D0);
+	err = pci_set_power_state(pci_dev, PCI_D0);
 	if (err) {
 		pr_err("can't set power state\n");
 		pci_disable_device(pci_dev);
@@ -1628,11 +1625,11 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	spin_lock_irqsave(&dev->slock, flags);
 	if (!list_empty(&dev->vidq.active)) {
 		pr_info("resume video\n");
-		restart_video_queue(dev,&dev->vidq);
+		restart_video_queue(dev, &dev->vidq);
 	}
 	if (!list_empty(&dev->vbiq.active)) {
 		pr_info("resume vbi\n");
-		cx8800_restart_vbi_queue(dev,&dev->vbiq);
+		cx8800_restart_vbi_queue(dev, &dev->vbiq);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
@@ -1648,7 +1645,7 @@ static const struct pci_device_id cx8800_pci_tbl[] = {
 		.device       = 0x8800,
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
-	},{
+	}, {
 		/* --- end of list --- */
 	}
 };
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
index 4f47ea2ae344..eea56ae9071e 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
@@ -1,26 +1,20 @@
 /*
-
-    cx88-vp3054-i2c.c  --  support for the secondary I2C bus of the
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
+ * cx88-vp3054-i2c.c -- support for the secondary I2C bus of the
+ *			DNTV Live! DVB-T Pro (VP-3054), wired as:
+ *			GPIO[0] -> SCL, GPIO[1] -> SDA
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
 
 #include "cx88.h"
 #include "cx88-vp3054-i2c.h"
@@ -128,11 +122,11 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 	i2c_set_adapdata(&vp3054_i2c->adap, dev);
 	vp3054_i2c->adap.algo_data = &vp3054_i2c->algo;
 
-	vp3054_bit_setscl(dev,1);
-	vp3054_bit_setsda(dev,1);
+	vp3054_bit_setscl(dev, 1);
+	vp3054_bit_setsda(dev, 1);
 
 	rc = i2c_bit_add_bus(&vp3054_i2c->adap);
-	if (0 != rc) {
+	if (rc != 0) {
 		pr_err("vp3054_i2c register FAILED\n");
 
 		kfree(dev->vp3054);
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 72af83ea405a..0dcd84bd804f 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -13,10 +13,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -55,7 +51,7 @@
 /* defines and enums                                           */
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM/LC */
-#define CX88_NORMS (V4L2_STD_ALL 		\
+#define CX88_NORMS (V4L2_STD_ALL		\
 		    & ~V4L2_STD_PAL_H		\
 		    & ~V4L2_STD_NTSC_M_KR	\
 		    & ~V4L2_STD_SECAM_LC)
@@ -363,12 +359,12 @@ struct cx88_core {
 	u32                        i2c_state, i2c_rc;
 
 	/* config info -- analog */
-	struct v4l2_device 	   v4l2_dev;
+	struct v4l2_device	   v4l2_dev;
 	struct v4l2_ctrl_handler   video_hdl;
 	struct v4l2_ctrl	   *chroma_agc;
 	struct v4l2_ctrl_handler   audio_hdl;
 	struct v4l2_subdev	   *sd_wm8775;
-	struct i2c_client 	   *i2c_rtc;
+	struct i2c_client	   *i2c_rtc;
 	unsigned int               boardnr;
 	struct cx88_board	   board;
 
@@ -385,8 +381,8 @@ struct cx88_core {
 	/* state info */
 	struct task_struct         *kthread;
 	v4l2_std_id                tvnorm;
-	unsigned		   width, height;
-	unsigned		   field;
+	unsigned int width, height;
+	unsigned int field;
 	enum cx88_tvaudio          tvaudio;
 	u32                        audiomode_manual;
 	u32                        audiomode_current;
@@ -486,7 +482,7 @@ struct cx8800_dev {
 
 	/* pci i/o */
 	struct pci_dev             *pci;
-	unsigned char              pci_rev,pci_lat;
+	unsigned char              pci_rev, pci_lat;
 
 	const struct cx8800_fmt    *fmt;
 
@@ -549,7 +545,7 @@ struct cx8802_dev {
 
 	/* pci i/o */
 	struct pci_dev             *pci;
-	unsigned char              pci_rev,pci_lat;
+	unsigned char              pci_rev, pci_lat;
 
 	/* dma queues */
 	struct cx88_dmaqueue       mpegq;
@@ -591,23 +587,23 @@ struct cx8802_dev {
 /* ----------------------------------------------------------- */
 
 #define cx_read(reg)             readl(core->lmmio + ((reg)>>2))
-#define cx_write(reg,value)      writel((value), core->lmmio + ((reg)>>2))
-#define cx_writeb(reg,value)     writeb((value), core->bmmio + (reg))
+#define cx_write(reg, value)      writel((value), core->lmmio + ((reg)>>2))
+#define cx_writeb(reg, value)     writeb((value), core->bmmio + (reg))
 
-#define cx_andor(reg,mask,value) \
+#define cx_andor(reg, mask, value) \
   writel((readl(core->lmmio+((reg)>>2)) & ~(mask)) |\
   ((value) & (mask)), core->lmmio+((reg)>>2))
-#define cx_set(reg,bit)          cx_andor((reg),(bit),(bit))
-#define cx_clear(reg,bit)        cx_andor((reg),(bit),0)
+#define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
+#define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)
 
 #define cx_wait(d) { if (need_resched()) schedule(); else udelay(d); }
 
 /* shadow registers */
 #define cx_sread(sreg)		    (core->shadow[sreg])
-#define cx_swrite(sreg,reg,value) \
+#define cx_swrite(sreg, reg, value) \
   (core->shadow[sreg] = value, \
    writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
-#define cx_sandor(sreg,reg,mask,value) \
+#define cx_sandor(sreg, reg, mask, value) \
   (core->shadow[sreg] = (core->shadow[sreg] & ~(mask)) | ((value) & (mask)), \
    writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
 
@@ -664,7 +660,7 @@ extern int cx88_stop_audio_dma(struct cx88_core *core);
 /* cx88-vbi.c                                                  */
 
 /* Can be used as g_vbi_fmt, try_vbi_fmt and s_vbi_fmt */
-int cx8800_vbi_fmt (struct file *file, void *priv,
+int cx8800_vbi_fmt(struct file *file, void *priv,
 					struct v4l2_format *f);
 
 /*
@@ -705,7 +701,7 @@ int cx8802_register_driver(struct cx8802_driver *drv);
 int cx8802_unregister_driver(struct cx8802_driver *drv);
 
 /* Caller must hold core->lock */
-struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
+struct cx8802_driver *cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
 
 /* ----------------------------------------------------------- */
 /* cx88-dsp.c                                                  */
-- 
2.7.4


