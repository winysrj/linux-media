Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2617 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaHJL60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 19/19] cx23885: remove btcx-risc dependency
Date: Sun, 10 Aug 2014 13:57:56 +0200
Message-Id: <1407671876-39386-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's just as easy to do it in the driver. This dependency only uses a
fraction of the btcx-risc module and doing it directly in the driver
adds only a few lines. The btcx-risc module is really meant for the
bttv driver, not for other drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/Kconfig        |  1 -
 drivers/media/pci/cx23885/Makefile       |  1 -
 drivers/media/pci/cx23885/cx23885-alsa.c |  5 ++++-
 drivers/media/pci/cx23885/cx23885-core.c | 36 +++++++++++++++++---------------
 drivers/media/pci/cx23885/cx23885.h      | 18 ++++++++++------
 5 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index 38c3b7b..a883ea4 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -3,7 +3,6 @@ config VIDEO_CX23885
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && SND
 	select SND_PCM
 	select I2C_ALGOBIT
-	select VIDEO_BTCX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	depends on RC_CORE
diff --git a/drivers/media/pci/cx23885/Makefile b/drivers/media/pci/cx23885/Makefile
index 2a2cafb..a2cbdcf 100644
--- a/drivers/media/pci/cx23885/Makefile
+++ b/drivers/media/pci/cx23885/Makefile
@@ -8,7 +8,6 @@ obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 
 ccflags-y += -Idrivers/media/i2c
-ccflags-y += -Idrivers/media/common
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index 1b162ee..ae7c2e8 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -270,12 +270,15 @@ int cx23885_audio_irq(struct cx23885_dev *dev, u32 status, u32 mask)
 
 static int dsp_buffer_free(struct cx23885_audio_dev *chip)
 {
+	struct cx23885_riscmem *risc;
+
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2, "Freeing buffer\n");
 	cx23885_alsa_dma_unmap(chip);
 	cx23885_alsa_dma_free(chip->buf);
-	btcx_riscmem_free(chip->pci, &chip->buf->risc);
+	risc = &chip->buf->risc;
+	pci_free_consistent(chip->pci, risc->size, risc->cpu, risc->dma);
 	kfree(chip->buf);
 
 	chip->buf = NULL;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 8663f7b..331edda 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -570,7 +570,7 @@ void cx23885_sram_channel_dump(struct cx23885_dev *dev,
 }
 
 static void cx23885_risc_disasm(struct cx23885_tsport *port,
-				struct btcx_riscmem *risc)
+				struct cx23885_riscmem *risc)
 {
 	struct cx23885_dev *dev = port->dev;
 	unsigned int i, j, n;
@@ -1121,14 +1121,13 @@ static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
 	return rp;
 }
 
-int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+int cx23885_risc_buffer(struct pci_dev *pci, struct cx23885_riscmem *risc,
 			struct scatterlist *sglist, unsigned int top_offset,
 			unsigned int bottom_offset, unsigned int bpl,
 			unsigned int padding, unsigned int lines)
 {
 	u32 instructions, fields;
 	__le32 *rp;
-	int rc;
 
 	fields = 0;
 	if (UNSET != top_offset)
@@ -1144,9 +1143,10 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	instructions  = fields * (1 + ((bpl + padding) * lines)
 		/ PAGE_SIZE + lines);
 	instructions += 5;
-	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
-	if (rc < 0)
-		return rc;
+	risc->size = instructions * 12;
+	risc->cpu = pci_alloc_consistent(pci, risc->size, &risc->dma);
+	if (risc->cpu == NULL)
+		return -ENOMEM;
 
 	/* write risc instructions */
 	rp = risc->cpu;
@@ -1164,14 +1164,13 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 }
 
 int cx23885_risc_databuffer(struct pci_dev *pci,
-				   struct btcx_riscmem *risc,
+				   struct cx23885_riscmem *risc,
 				   struct scatterlist *sglist,
 				   unsigned int bpl,
 				   unsigned int lines, unsigned int lpi)
 {
 	u32 instructions;
 	__le32 *rp;
-	int rc;
 
 	/* estimate risc mem: worst case is one write per page border +
 	   one write per scan line + syncs + jump (all 2 dwords).  Here
@@ -1181,9 +1180,10 @@ int cx23885_risc_databuffer(struct pci_dev *pci,
 	instructions  = 1 + (bpl * lines) / PAGE_SIZE + lines;
 	instructions += 4;
 
-	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
-	if (rc < 0)
-		return rc;
+	risc->size = instructions * 12;
+	risc->cpu = pci_alloc_consistent(pci, risc->size, &risc->dma);
+	if (risc->cpu == NULL)
+		return -ENOMEM;
 
 	/* write risc instructions */
 	rp = risc->cpu;
@@ -1196,14 +1196,13 @@ int cx23885_risc_databuffer(struct pci_dev *pci,
 	return 0;
 }
 
-int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+int cx23885_risc_vbibuffer(struct pci_dev *pci, struct cx23885_riscmem *risc,
 			struct scatterlist *sglist, unsigned int top_offset,
 			unsigned int bottom_offset, unsigned int bpl,
 			unsigned int padding, unsigned int lines)
 {
 	u32 instructions, fields;
 	__le32 *rp;
-	int rc;
 
 	fields = 0;
 	if (UNSET != top_offset)
@@ -1219,9 +1218,10 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	instructions  = fields * (1 + ((bpl + padding) * lines)
 		/ PAGE_SIZE + lines);
 	instructions += 5;
-	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
-	if (rc < 0)
-		return rc;
+	risc->size = instructions * 12;
+	risc->cpu = pci_alloc_consistent(pci, risc->size, &risc->dma);
+	if (risc->cpu == NULL)
+		return -ENOMEM;
 	/* write risc instructions */
 	rp = risc->cpu;
 
@@ -1246,8 +1246,10 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 
 void cx23885_free_buffer(struct cx23885_dev *dev, struct cx23885_buffer *buf)
 {
+	struct cx23885_riscmem *risc = &buf->risc;
+
 	BUG_ON(in_interrupt());
-	btcx_riscmem_free(dev->pci, &buf->risc);
+	pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
 }
 
 static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index c306aa3..1ff86ba 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -29,7 +29,6 @@
 #include <media/videobuf2-dvb.h>
 #include <media/rc-core.h>
 
-#include "btcx-risc.h"
 #include "cx23885-reg.h"
 #include "media/cx2341x.h"
 
@@ -152,6 +151,13 @@ enum cx23885_src_sel_type {
 	CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO
 };
 
+struct cx23885_riscmem {
+	unsigned int   size;
+	__le32         *cpu;
+	__le32         *jmp;
+	dma_addr_t     dma;
+};
+
 /* buffer for one video frame */
 struct cx23885_buffer {
 	/* common v4l buffer stuff -- must be first */
@@ -160,7 +166,7 @@ struct cx23885_buffer {
 
 	/* cx23885 specific */
 	unsigned int           bpl;
-	struct btcx_riscmem    risc;
+	struct cx23885_riscmem risc;
 	struct cx23885_fmt     *fmt;
 	u32                    count;
 };
@@ -300,7 +306,7 @@ struct cx23885_kernel_ir {
 
 struct cx23885_audio_buffer {
 	unsigned int		bpl;
-	struct btcx_riscmem	risc;
+	struct cx23885_riscmem	risc;
 	void			*vaddr;
 	struct scatterlist	*sglist;
 	int                     sglen;
@@ -489,13 +495,13 @@ extern int cx23885_sram_channel_setup(struct cx23885_dev *dev,
 extern void cx23885_sram_channel_dump(struct cx23885_dev *dev,
 	struct sram_channel *ch);
 
-extern int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+extern int cx23885_risc_buffer(struct pci_dev *pci, struct cx23885_riscmem *risc,
 	struct scatterlist *sglist,
 	unsigned int top_offset, unsigned int bottom_offset,
 	unsigned int bpl, unsigned int padding, unsigned int lines);
 
 extern int cx23885_risc_vbibuffer(struct pci_dev *pci,
-	struct btcx_riscmem *risc, struct scatterlist *sglist,
+	struct cx23885_riscmem *risc, struct scatterlist *sglist,
 	unsigned int top_offset, unsigned int bottom_offset,
 	unsigned int bpl, unsigned int padding, unsigned int lines);
 
@@ -595,7 +601,7 @@ extern struct cx23885_audio_dev *cx23885_audio_register(
 extern void cx23885_audio_unregister(struct cx23885_dev *dev);
 extern int cx23885_audio_irq(struct cx23885_dev *dev, u32 status, u32 mask);
 extern int cx23885_risc_databuffer(struct pci_dev *pci,
-				   struct btcx_riscmem *risc,
+				   struct cx23885_riscmem *risc,
 				   struct scatterlist *sglist,
 				   unsigned int bpl,
 				   unsigned int lines,
-- 
2.0.1

