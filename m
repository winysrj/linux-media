Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43075 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab0EKNfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 4/7] v4l: Remove videobuf_sg_alloc abuse
Date: Tue, 11 May 2010 15:36:31 +0200
Message-Id: <1273584994-14211-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx88 and cx25821 drivers abuse videobuf_buffer to handle audio data.
Remove the abuse by creating private audio buffer structures with a
videobuf_dmabuf field.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/cx88/cx88-alsa.c   |   29 ++++++++++++++---------------
 drivers/staging/cx25821/cx25821-alsa.c |   29 ++++++++++++++---------------
 2 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 5ddd45d..ebeb9a6 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -53,6 +53,12 @@
 	Data type declarations - Can be moded to a header file later
  ****************************************************************************/
 
+struct cx88_audio_buffer {
+	unsigned int               bpl;
+	struct btcx_riscmem        risc;
+	struct videobuf_dmabuf     dma;
+};
+
 struct cx88_audio_dev {
 	struct cx88_core           *core;
 	struct cx88_dmaqueue       q;
@@ -74,7 +80,7 @@ struct cx88_audio_dev {
 
 	struct videobuf_dmabuf     *dma_risc;
 
-	struct cx88_buffer	   *buf;
+	struct cx88_audio_buffer   *buf;
 
 	struct snd_pcm_substream   *substream;
 };
@@ -122,7 +128,7 @@ MODULE_PARM_DESC(debug,"enable debug messages");
 
 static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 {
-	struct cx88_buffer   *buf = chip->buf;
+	struct cx88_audio_buffer *buf = chip->buf;
 	struct cx88_core *core=chip->core;
 	struct sram_channel *audio_ch = &cx88_sram_channels[SRAM_CH25];
 
@@ -375,7 +381,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
 	struct videobuf_dmabuf *dma;
 
-	struct cx88_buffer *buf;
+	struct cx88_audio_buffer *buf;
 	int ret;
 
 	if (substream->runtime->dma_area) {
@@ -390,21 +396,16 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	BUG_ON(!chip->dma_size);
 	BUG_ON(chip->num_periods & (chip->num_periods-1));
 
-	buf = videobuf_sg_alloc(sizeof(*buf));
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (NULL == buf)
 		return -ENOMEM;
 
-	buf->vb.memory = V4L2_MEMORY_MMAP;
-	buf->vb.field  = V4L2_FIELD_NONE;
-	buf->vb.width  = chip->period_size;
-	buf->bpl       = chip->period_size;
-	buf->vb.height = chip->num_periods;
-	buf->vb.size   = chip->dma_size;
+	buf->bpl = chip->period_size;
 
-	dma = videobuf_to_dma(&buf->vb);
+	dma = &buf->dma;
 	videobuf_dma_init(dma);
 	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
-			(PAGE_ALIGN(buf->vb.size) >> PAGE_SHIFT));
+			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
@@ -413,7 +414,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 		goto error;
 
 	ret = cx88_risc_databuffer(chip->pci, &buf->risc, dma->sglist,
-				   buf->vb.width, buf->vb.height, 1);
+				   chip->period_size, chip->num_periods, 1);
 	if (ret < 0)
 		goto error;
 
@@ -421,8 +422,6 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP|RISC_IRQ1|RISC_CNT_INC);
 	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 
-	buf->vb.state = VIDEOBUF_PREPARED;
-
 	chip->buf = buf;
 	chip->dma_risc = dma;
 
diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index f3407fd..14fd3cb 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -54,6 +54,12 @@
 static struct snd_card *snd_cx25821_cards[SNDRV_CARDS];
 static int devno;
 
+struct cx25821_audio_buffer {
+	unsigned int bpl;
+	struct btcx_riscmem risc;
+	struct videobuf_dmabuf dma;
+};
+
 struct cx25821_audio_dev {
 	struct cx25821_dev *dev;
 	struct cx25821_dmaqueue q;
@@ -76,7 +82,7 @@ struct cx25821_audio_dev {
 
 	struct videobuf_dmabuf *dma_risc;
 
-	struct cx25821_buffer *buf;
+	struct cx25821_audio_buffer *buf;
 
 	struct snd_pcm_substream *substream;
 };
@@ -135,7 +141,7 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 
 static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 {
-	struct cx25821_buffer *buf = chip->buf;
+	struct cx25821_audio_buffer *buf = chip->buf;
 	struct cx25821_dev *dev = chip->dev;
 	struct sram_channel *audio_ch =
 	    &cx25821_sram_channels[AUDIO_SRAM_CHANNEL];
@@ -431,7 +437,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);
 	struct videobuf_dmabuf *dma;
 
-	struct cx25821_buffer *buf;
+	struct cx25821_audio_buffer *buf;
 	int ret;
 
 	if (substream->runtime->dma_area) {
@@ -446,25 +452,19 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	BUG_ON(!chip->dma_size);
 	BUG_ON(chip->num_periods & (chip->num_periods - 1));
 
-	buf = videobuf_sg_alloc(sizeof(*buf));
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (NULL == buf)
 		return -ENOMEM;
 
 	if (chip->period_size > AUDIO_LINE_SIZE)
 		chip->period_size = AUDIO_LINE_SIZE;
 
-	buf->vb.memory = V4L2_MEMORY_MMAP;
-	buf->vb.field = V4L2_FIELD_NONE;
-	buf->vb.width = chip->period_size;
 	buf->bpl = chip->period_size;
-	buf->vb.height = chip->num_periods;
-	buf->vb.size = chip->dma_size;
 
-	dma = videobuf_to_dma(&buf->vb);
+	dma = &buf->dma;
 	videobuf_dma_init(dma);
-
 	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
-				       (PAGE_ALIGN(buf->vb.size) >>
+				       (PAGE_ALIGN(chip->dma_size) >>
 					PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
@@ -475,7 +475,8 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 
 	ret =
 	    cx25821_risc_databuffer_audio(chip->pci, &buf->risc, dma->sglist,
-					  buf->vb.width, buf->vb.height, 1);
+					  chip->period_size, chip->num_periods,
+					  1);
 	if (ret < 0) {
 		printk(KERN_INFO
 			"DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
@@ -487,8 +488,6 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 	buf->risc.jmp[2] = cpu_to_le32(0);	/* bits 63-32 */
 
-	buf->vb.state = VIDEOBUF_PREPARED;
-
 	chip->buf = buf;
 	chip->dma_risc = dma;
 
-- 
1.6.4.4

