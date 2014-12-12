Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:54634 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967664AbaLLN2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] cx25821: remove bogus btcx_risc dependency
Date: Fri, 12 Dec 2014 14:27:54 +0100
Message-Id: <1418390880-39009-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Those btcx_risc functions are meant for use with bttv, other drivers
should just allocate the memory themselves.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/Kconfig         |  1 -
 drivers/media/pci/cx25821/Makefile        |  1 -
 drivers/media/pci/cx25821/cx25821-alsa.c  |  6 ++++--
 drivers/media/pci/cx25821/cx25821-core.c  | 36 +++++++++++++++++++++++++------
 drivers/media/pci/cx25821/cx25821-video.c |  6 ++++--
 drivers/media/pci/cx25821/cx25821.h       | 21 ++++++++++++------
 6 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
index 6439a84..0e69cab 100644
--- a/drivers/media/pci/cx25821/Kconfig
+++ b/drivers/media/pci/cx25821/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
 	depends on VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
-	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a video4linux driver for Conexant 25821 based
diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
index fb76c3d..5872feb 100644
--- a/drivers/media/pci/cx25821/Makefile
+++ b/drivers/media/pci/cx25821/Makefile
@@ -6,4 +6,3 @@ obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
 ccflags-y += -Idrivers/media/i2c
-ccflags-y += -Idrivers/media/common
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 2dd5bca..27e6493 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -63,7 +63,7 @@ static int devno;
 
 struct cx25821_audio_buffer {
 	unsigned int bpl;
-	struct btcx_riscmem risc;
+	struct cx25821_riscmem risc;
 	struct videobuf_dmabuf dma;
 };
 
@@ -330,12 +330,14 @@ out:
 
 static int dsp_buffer_free(struct cx25821_audio_dev *chip)
 {
+	struct cx25821_riscmem *risc = &chip->buf->risc;
+
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2, "Freeing buffer\n");
 	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
 	videobuf_dma_free(chip->dma_risc);
-	btcx_riscmem_free(chip->pci, &chip->buf->risc);
+	pci_free_consistent(chip->pci, risc->size, risc->cpu, risc->dma);
 	kfree(chip->buf);
 
 	chip->dma_risc = NULL;
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 389fffd..c8c65b7 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -979,6 +979,27 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 }
 EXPORT_SYMBOL(cx25821_dev_unregister);
 
+int cx25821_riscmem_alloc(struct pci_dev *pci,
+		       struct cx25821_riscmem *risc,
+		       unsigned int size)
+{
+	__le32 *cpu;
+	dma_addr_t dma = 0;
+
+	if (NULL != risc->cpu && risc->size < size)
+		pci_free_consistent(pci, risc->size, risc->cpu, risc->dma);
+	if (NULL == risc->cpu) {
+		cpu = pci_zalloc_consistent(pci, size, &dma);
+		if (NULL == cpu)
+			return -ENOMEM;
+		risc->cpu  = cpu;
+		risc->dma  = dma;
+		risc->size = size;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(cx25821_riscmem_alloc);
+
 static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 				  unsigned int offset, u32 sync_line,
 				  unsigned int bpl, unsigned int padding,
@@ -1035,7 +1056,7 @@ static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 	return rp;
 }
 
-int cx25821_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+int cx25821_risc_buffer(struct pci_dev *pci, struct cx25821_riscmem *risc,
 			struct scatterlist *sglist, unsigned int top_offset,
 			unsigned int bottom_offset, unsigned int bpl,
 			unsigned int padding, unsigned int lines)
@@ -1059,7 +1080,7 @@ int cx25821_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	instructions = fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE +
 			lines);
 	instructions += 2;
-	rc = btcx_riscmem_alloc(pci, risc, instructions * 12);
+	rc = cx25821_riscmem_alloc(pci, risc, instructions * 12);
 
 	if (rc < 0)
 		return rc;
@@ -1146,7 +1167,7 @@ static __le32 *cx25821_risc_field_audio(__le32 * rp, struct scatterlist *sglist,
 }
 
 int cx25821_risc_databuffer_audio(struct pci_dev *pci,
-				  struct btcx_riscmem *risc,
+				  struct cx25821_riscmem *risc,
 				  struct scatterlist *sglist,
 				  unsigned int bpl,
 				  unsigned int lines, unsigned int lpi)
@@ -1163,7 +1184,7 @@ int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 	instructions = 1 + (bpl * lines) / PAGE_SIZE + lines;
 	instructions += 1;
 
-	rc = btcx_riscmem_alloc(pci, risc, instructions * 12);
+	rc = cx25821_riscmem_alloc(pci, risc, instructions * 12);
 	if (rc < 0)
 		return rc;
 
@@ -1179,13 +1200,13 @@ int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 }
 EXPORT_SYMBOL(cx25821_risc_databuffer_audio);
 
-int cx25821_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
+int cx25821_risc_stopper(struct pci_dev *pci, struct cx25821_riscmem *risc,
 			 u32 reg, u32 mask, u32 value)
 {
 	__le32 *rp;
 	int rc;
 
-	rc = btcx_riscmem_alloc(pci, risc, 4 * 16);
+	rc = cx25821_riscmem_alloc(pci, risc, 4 * 16);
 
 	if (rc < 0)
 		return rc;
@@ -1211,7 +1232,8 @@ void cx25821_free_buffer(struct videobuf_queue *q, struct cx25821_buffer *buf)
 	videobuf_waiton(q, &buf->vb, 0, 0);
 	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
-	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
+	pci_free_consistent(to_pci_dev(q->dev),
+			buf->risc.size, buf->risc.cpu, buf->risc.dma);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 3a419f1..3eda1a1 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1017,11 +1017,13 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 	cx_clear(PCI_INT_MSK, 1);
 
 	if (video_is_registered(&dev->channels[chan_num].vdev)) {
+		struct cx25821_riscmem *risc =
+			&dev->channels[chan_num].dma_vidq.stopper;
+
 		video_unregister_device(&dev->channels[chan_num].vdev);
 		v4l2_ctrl_handler_free(&dev->channels[chan_num].hdl);
 
-		btcx_riscmem_free(dev->pci,
-				&dev->channels[chan_num].dma_vidq.stopper);
+		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
 	}
 }
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 90bdc19..38beec2 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -36,7 +36,6 @@
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf-dma-sg.h>
 
-#include "btcx-risc.h"
 #include "cx25821-reg.h"
 #include "cx25821-medusa-reg.h"
 #include "cx25821-sram.h"
@@ -111,6 +110,13 @@ enum cx25821_src_sel_type {
 	CX25821_SRC_SEL_PARALLEL_MPEG_VIDEO
 };
 
+struct cx25821_riscmem {
+	unsigned int   size;
+	__le32         *cpu;
+	__le32         *jmp;
+	dma_addr_t     dma;
+};
+
 /* buffer for one video frame */
 struct cx25821_buffer {
 	/* common v4l buffer stuff -- must be first */
@@ -118,7 +124,7 @@ struct cx25821_buffer {
 
 	/* cx25821 specific */
 	unsigned int bpl;
-	struct btcx_riscmem risc;
+	struct cx25821_riscmem risc;
 	const struct cx25821_fmt *fmt;
 	u32 count;
 };
@@ -161,7 +167,7 @@ struct cx25821_dmaqueue {
 	struct list_head active;
 	struct list_head queued;
 	struct timer_list timeout;
-	struct btcx_riscmem stopper;
+	struct cx25821_riscmem stopper;
 	u32 count;
 };
 
@@ -405,20 +411,23 @@ extern int cx25821_sram_channel_setup(struct cx25821_dev *dev,
 				      const struct sram_channel *ch, unsigned int bpl,
 				      u32 risc);
 
-extern int cx25821_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+extern int cx25821_riscmem_alloc(struct pci_dev *pci,
+				 struct cx25821_riscmem *risc,
+				 unsigned int size);
+extern int cx25821_risc_buffer(struct pci_dev *pci, struct cx25821_riscmem *risc,
 			       struct scatterlist *sglist,
 			       unsigned int top_offset,
 			       unsigned int bottom_offset,
 			       unsigned int bpl,
 			       unsigned int padding, unsigned int lines);
 extern int cx25821_risc_databuffer_audio(struct pci_dev *pci,
-					 struct btcx_riscmem *risc,
+					 struct cx25821_riscmem *risc,
 					 struct scatterlist *sglist,
 					 unsigned int bpl,
 					 unsigned int lines, unsigned int lpi);
 extern void cx25821_free_buffer(struct videobuf_queue *q,
 				struct cx25821_buffer *buf);
-extern int cx25821_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
+extern int cx25821_risc_stopper(struct pci_dev *pci, struct cx25821_riscmem *risc,
 				u32 reg, u32 mask, u32 value);
 extern void cx25821_sram_channel_dump(struct cx25821_dev *dev,
 				      const struct sram_channel *ch);
-- 
2.1.3

