Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59184 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbbEVN74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 09:59:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/11] cobalt: fix irqs used for the adv7511 transmitter
Date: Fri, 22 May 2015 15:59:34 +0200
Message-Id: <1432303184-8594-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The interrupt bit assignments use for the adv7511 were off by one.
This means that the current scheme (bit << (4 * stream_index)) can
no longer be used.

Fix this by precalculating and storing the correct masks in the
cobalt_stream struct.

This wasn't noticed before because the adv7511 interrupts are very
rare. But for CEC support these interrupts are essential, so this made
me realize that it wasn't working correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 14 ++++++++++++--
 drivers/media/pci/cobalt/cobalt-driver.h |  8 +++++---
 drivers/media/pci/cobalt/cobalt-irq.c    |  7 +++----
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 0f2549a..0534d71 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -451,20 +451,30 @@ static void cobalt_stream_struct_init(struct cobalt *cobalt)
 		if (i <= COBALT_HSMA_IN_NODE) {
 			s->dma_channel = i + cobalt->first_fifo_channel;
 			s->video_channel = i;
+			s->dma_fifo_mask =
+				COBALT_SYSSTAT_VI0_LOST_DATA_MSK << (4 * i);
+			s->adv_irq_mask =
+				COBALT_SYSSTAT_VI0_INT1_MSK << (4 * i);
 		} else if (i >= COBALT_AUDIO_IN_STREAM &&
 			   i <= COBALT_AUDIO_IN_STREAM + 4) {
-			s->dma_channel = 6 + i - COBALT_AUDIO_IN_STREAM;
+			unsigned idx = i - COBALT_AUDIO_IN_STREAM;
+
+			s->dma_channel = 6 + idx;
 			s->is_audio = true;
-			s->video_channel = i - COBALT_AUDIO_IN_STREAM;
+			s->video_channel = idx;
+			s->dma_fifo_mask = COBALT_SYSSTAT_AUD_IN_LOST_DATA_MSK;
 		} else if (i == COBALT_HSMA_OUT_NODE) {
 			s->dma_channel = 11;
 			s->is_output = true;
 			s->video_channel = 5;
+			s->dma_fifo_mask = COBALT_SYSSTAT_VOHSMA_LOST_DATA_MSK;
+			s->adv_irq_mask = COBALT_SYSSTAT_VOHSMA_INT1_MSK;
 		} else if (i == COBALT_AUDIO_OUT_STREAM) {
 			s->dma_channel = 12;
 			s->is_audio = true;
 			s->is_output = true;
 			s->video_channel = 5;
+			s->dma_fifo_mask = COBALT_SYSSTAT_AUD_OUT_LOST_DATA_MSK;
 		} else {
 			/* FIXME: Memory DMA for debug purpose */
 			s->dma_channel = i - COBALT_NUM_NODES;
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index 082bf82..bb062ff 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -96,9 +96,9 @@
 #define COBALT_SYSSTAT_VIHSMA_INT1_MSK		(1 << 21)
 #define COBALT_SYSSTAT_VIHSMA_INT2_MSK		(1 << 22)
 #define COBALT_SYSSTAT_VIHSMA_LOST_DATA_MSK	(1 << 23)
-#define COBALT_SYSSTAT_VOHSMA_INT1_MSK		(1 << 25)
-#define COBALT_SYSSTAT_VOHSMA_PLL_LOCKED_MSK	(1 << 26)
-#define COBALT_SYSSTAT_VOHSMA_LOST_DATA_MSK	(1 << 27)
+#define COBALT_SYSSTAT_VOHSMA_INT1_MSK		(1 << 24)
+#define COBALT_SYSSTAT_VOHSMA_PLL_LOCKED_MSK	(1 << 25)
+#define COBALT_SYSSTAT_VOHSMA_LOST_DATA_MSK	(1 << 26)
 #define COBALT_SYSSTAT_AUD_PLL_LOCKED_MSK	(1 << 28)
 #define COBALT_SYSSTAT_AUD_IN_LOST_DATA_MSK	(1 << 29)
 #define COBALT_SYSSTAT_AUD_OUT_LOST_DATA_MSK	(1 << 30)
@@ -236,6 +236,8 @@ struct cobalt_stream {
 
 	u8 dma_channel;
 	int video_channel;
+	unsigned dma_fifo_mask;
+	unsigned adv_irq_mask;
 	struct sg_dma_desc_info dma_desc_info[NR_BUFS];
 	unsigned long flags;
 	bool unstable_frame;
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index e18f49e..a133dfc 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -153,8 +153,7 @@ irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
 
 	for (i = 0; i < COBALT_NUM_STREAMS; i++) {
 		struct cobalt_stream *s = &cobalt->streams[i];
-		unsigned dma_fifo_mask =
-		    COBALT_SYSSTAT_VI0_LOST_DATA_MSK << (4 * s->video_channel);
+		unsigned dma_fifo_mask = s->dma_fifo_mask;
 
 		if (dma_interrupt & (1 << s->dma_channel)) {
 			cobalt->irq_dma[i]++;
@@ -169,7 +168,7 @@ irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
 		}
 		if (s->is_audio)
 			continue;
-		if (edge & (0x20 << (4 * s->video_channel)))
+		if (edge & s->adv_irq_mask)
 			set_bit(COBALT_STREAM_FL_ADV_IRQ, &s->flags);
 		if ((edge & mask & dma_fifo_mask) && vb2_is_streaming(&s->q)) {
 			cobalt_info("full rx FIFO %d\n", i);
@@ -219,7 +218,7 @@ void cobalt_irq_work_handler(struct work_struct *work)
 					interrupt_service_routine, 0, NULL);
 			mask = cobalt_read_bar1(cobalt, COBALT_SYS_STAT_MASK);
 			cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK,
-				mask | (0x20 << (4 * s->video_channel)));
+				mask | s->adv_irq_mask);
 		}
 	}
 }
-- 
2.1.4

