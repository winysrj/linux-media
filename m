Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3321 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbaITMmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/16] cx88: remove dependency on btcx-risc
Date: Sat, 20 Sep 2014 14:41:43 +0200
Message-Id: <1411216911-7950-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

btcx-risc is for the bt8xx driver and other drivers shouldn't depend
on it. There is no benefit to use that module just to do a
pci_zalloc_consistent.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/Kconfig          |  1 -
 drivers/media/pci/cx88/Makefile         |  1 -
 drivers/media/pci/cx88/cx88-alsa.c      |  7 +++++--
 drivers/media/pci/cx88/cx88-blackbird.c |  5 ++++-
 drivers/media/pci/cx88/cx88-core.c      | 20 ++++++++++++--------
 drivers/media/pci/cx88/cx88-dvb.c       |  5 ++++-
 drivers/media/pci/cx88/cx88-mpeg.c      |  7 +++++--
 drivers/media/pci/cx88/cx88-vbi.c       |  5 ++++-
 drivers/media/pci/cx88/cx88-video.c     |  5 ++++-
 drivers/media/pci/cx88/cx88.h           | 16 +++++++++++-----
 10 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/cx88/Kconfig b/drivers/media/pci/cx88/Kconfig
index d5b125e..14b813d6 100644
--- a/drivers/media/pci/cx88/Kconfig
+++ b/drivers/media/pci/cx88/Kconfig
@@ -2,7 +2,6 @@ config VIDEO_CX88
 	tristate "Conexant 2388x (bt878 successor) support"
 	depends on VIDEO_DEV && PCI && I2C && RC_CORE
 	select I2C_ALGOBIT
-	select VIDEO_BTCX
 	select VIDEOBUF2_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
diff --git a/drivers/media/pci/cx88/Makefile b/drivers/media/pci/cx88/Makefile
index 8619c1b..d3679c3 100644
--- a/drivers/media/pci/cx88/Makefile
+++ b/drivers/media/pci/cx88/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
 obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
 
 ccflags-y += -Idrivers/media/i2c
-ccflags-y += -Idrivers/media/common
 ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 73021a2..7f8dc60 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -61,7 +61,7 @@
 
 struct cx88_audio_buffer {
 	unsigned int               bpl;
-	struct btcx_riscmem        risc;
+	struct cx88_riscmem        risc;
 	void			*vaddr;
 	struct scatterlist	*sglist;
 	int                     sglen;
@@ -370,12 +370,15 @@ static int cx88_alsa_dma_free(struct cx88_audio_buffer *buf)
 
 static int dsp_buffer_free(snd_cx88_card_t *chip)
 {
+	struct cx88_riscmem *risc = &chip->buf->risc;
+
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2,"Freeing buffer\n");
 	cx88_alsa_dma_unmap(chip);
 	cx88_alsa_dma_free(chip->buf);
-	btcx_riscmem_free(chip->pci, &chip->buf->risc);
+	if (risc->cpu)
+		pci_free_consistent(chip->pci, risc->size, risc->cpu, risc->dma);
 	kfree(chip->buf);
 
 	chip->buf = NULL;
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index b24266e..f27a3f1 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -666,8 +666,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	struct cx88_riscmem *risc = &buf->risc;
 
-	btcx_riscmem_free(dev->pci, &buf->risc);
+	if (risc->cpu)
+		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+	memset(risc, 0, sizeof(*risc));
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 902b662..bbdbb58 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -132,14 +132,13 @@ static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
 	return rp;
 }
 
-int cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+int cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 		     struct scatterlist *sglist,
 		     unsigned int top_offset, unsigned int bottom_offset,
 		     unsigned int bpl, unsigned int padding, unsigned int lines)
 {
 	u32 instructions,fields;
 	__le32 *rp;
-	int rc;
 
 	fields = 0;
 	if (UNSET != top_offset)
@@ -153,8 +152,11 @@ int cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	   region may be smaller than PAGE_SIZE */
 	instructions  = fields * (1 + ((bpl + padding) * lines) / PAGE_SIZE + lines);
 	instructions += 4;
-	if ((rc = btcx_riscmem_alloc(pci,risc,instructions*8)) < 0)
-		return rc;
+	risc->size = instructions * 8;
+	risc->dma = 0;
+	risc->cpu = pci_zalloc_consistent(pci, risc->size, &risc->dma);
+	if (NULL == risc->cpu)
+		return -ENOMEM;
 
 	/* write risc instructions */
 	rp = risc->cpu;
@@ -171,13 +173,12 @@ int cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	return 0;
 }
 
-int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+int cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 			 struct scatterlist *sglist, unsigned int bpl,
 			 unsigned int lines, unsigned int lpi)
 {
 	u32 instructions;
 	__le32 *rp;
-	int rc;
 
 	/* estimate risc mem: worst case is one write per page border +
 	   one write per scan line + syncs + jump (all 2 dwords).  Here
@@ -185,8 +186,11 @@ int cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
 	   than PAGE_SIZE */
 	instructions  = 1 + (bpl * lines) / PAGE_SIZE + lines;
 	instructions += 3;
-	if ((rc = btcx_riscmem_alloc(pci,risc,instructions*8)) < 0)
-		return rc;
+	risc->size = instructions * 8;
+	risc->dma = 0;
+	risc->cpu = pci_zalloc_consistent(pci, risc->size, &risc->dma);
+	if (NULL == risc->cpu)
+		return -ENOMEM;
 
 	/* write risc instructions */
 	rp = risc->cpu;
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index b5b88a6..dd0deb1 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -109,8 +109,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	struct cx88_riscmem *risc = &buf->risc;
 
-	btcx_riscmem_free(dev->pci, &buf->risc);
+	if (risc->cpu)
+		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+	memset(risc, 0, sizeof(*risc));
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 0589dcc..746c0ea 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -228,6 +228,7 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 {
 	int size = dev->ts_packet_size * dev->ts_packet_count;
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
+	struct cx88_riscmem *risc = &buf->risc;
 	int rc;
 
 	if (vb2_plane_size(&buf->vb, 0) < size)
@@ -238,10 +239,12 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 	if (!rc)
 		return -EIO;
 
-	rc = cx88_risc_databuffer(dev->pci, &buf->risc, sgt->sgl,
+	rc = cx88_risc_databuffer(dev->pci, risc, sgt->sgl,
 			     dev->ts_packet_size, dev->ts_packet_count, 0);
 	if (rc) {
-		btcx_riscmem_free(dev->pci, &buf->risc);
+		if (risc->cpu)
+			pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+		memset(risc, 0, sizeof(*risc));
 		return rc;
 	}
 	return 0;
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 8f20612..4e0747a 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -146,8 +146,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	struct cx88_riscmem *risc = &buf->risc;
 
-	btcx_riscmem_free(dev->pci, &buf->risc);
+	if (risc->cpu)
+		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+	memset(risc, 0, sizeof(*risc));
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index c64f8f4..a74e21d 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -505,8 +505,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	struct cx88_riscmem *risc = &buf->risc;
 
-	btcx_riscmem_free(dev->pci, &buf->risc);
+	if (risc->cpu)
+		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+	memset(risc, 0, sizeof(*risc));
 
 	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 16965c8..dd50177 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -35,7 +35,6 @@
 #include <media/ir-kbd-i2c.h>
 #include <media/wm8775.h>
 
-#include "btcx-risc.h"
 #include "cx88-reg.h"
 #include "tuner-xc2028.h"
 
@@ -311,6 +310,13 @@ enum cx88_tvaudio {
 
 #define BUFFER_TIMEOUT     msecs_to_jiffies(2000)
 
+struct cx88_riscmem {
+	unsigned int   size;
+	__le32         *cpu;
+	__le32         *jmp;
+	dma_addr_t     dma;
+};
+
 /* buffer for one video frame */
 struct cx88_buffer {
 	/* common v4l buffer stuff -- must be first */
@@ -319,7 +325,7 @@ struct cx88_buffer {
 
 	/* cx88 specific */
 	unsigned int           bpl;
-	struct btcx_riscmem    risc;
+	struct cx88_riscmem    risc;
 	u32                    count;
 };
 
@@ -616,17 +622,17 @@ extern void cx88_shutdown(struct cx88_core *core);
 extern int cx88_reset(struct cx88_core *core);
 
 extern int
-cx88_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+cx88_risc_buffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 		 struct scatterlist *sglist,
 		 unsigned int top_offset, unsigned int bottom_offset,
 		 unsigned int bpl, unsigned int padding, unsigned int lines);
 extern int
-cx88_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
+cx88_risc_databuffer(struct pci_dev *pci, struct cx88_riscmem *risc,
 		     struct scatterlist *sglist, unsigned int bpl,
 		     unsigned int lines, unsigned int lpi);
 
 extern void cx88_risc_disasm(struct cx88_core *core,
-			     struct btcx_riscmem *risc);
+			     struct cx88_riscmem *risc);
 extern int cx88_sram_channel_setup(struct cx88_core *core,
 				   const struct sram_channel *ch,
 				   unsigned int bpl, u32 risc);
-- 
2.1.0

