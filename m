Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:45797 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1AZIta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 03:49:30 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>,
	Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 2/2] dma: ipu_idmac: do not lose valid received data in the irq handler
Date: Wed, 26 Jan 2011 09:49:49 +0100
Message-Id: <1296031789-1721-3-git-send-email-agust@denx.de>
In-Reply-To: <1296031789-1721-1-git-send-email-agust@denx.de>
References: <1296031789-1721-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently when two or more buffers are queued by the camera driver
and so the double buffering is enabled in the idmac, we lose the
first frame comming from CSI since it is just dropped by the
interrupt handler. The reason for this dropping is that the interrupt
handler misleadingly assumes that the cur_buf flag is pointing to the
buffer used by the IDMAC. Actually it is not the case since the
CUR_BUF flag will be flipped by the FSU when the FSU is sending the
<TASK>_NEW_FRM_RDY signal when new frame data is delivered by the CSI.
When sending this singal, FSU updates the DMA_CUR_BUF and the
DMA_BUFx_RDY flags: the DMA_CUR_BUF is flipped, the DMA_BUFx_RDY
is cleared, indicating that the frame data is beeing written by
the IDMAC to the pointed buffer. DMA_BUFx_RDY is supposed to be
set to the ready state again by the MCU, when it has handled the
received data. DMA_BUFx_RDY won't be set by the IPU, so waiting
for this event in the interrupt handler is wrong. Actually there
is no spurious interrupt as described in the comments, this
is the valid DMAIC_7_EOF interrupt indicating reception of the
frame from CSI.

This has been verified on the hardware which is triggering the
image sensor by the programmable state machine, allowing to
obtain exact number of frames. On this hardware we do not tolerate
losing frames.

This patch also removes resetting the DMA_BUFx_RDY flags of
all channels in ipu_disable_channel() since transfers on other
DMA channels might be triggered by other running tasks and the
buffers should always be ready for data sending or reception.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/dma/ipu/ipu_idmac.c |   50 -------------------------------------------
 1 files changed, 0 insertions(+), 50 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb26ee9..c1a125e 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1145,29 +1145,6 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
 	reg = idmac_read_icreg(ipu, IDMAC_CHA_EN);
 	idmac_write_icreg(ipu, reg & ~chan_mask, IDMAC_CHA_EN);
 
-	/*
-	 * Problem (observed with channel DMAIC_7): after enabling the channel
-	 * and initialising buffers, there comes an interrupt with current still
-	 * pointing at buffer 0, whereas it should use buffer 0 first and only
-	 * generate an interrupt when it is done, then current should already
-	 * point to buffer 1. This spurious interrupt also comes on channel
-	 * DMASDC_0. With DMAIC_7 normally, is we just leave the ISR after the
-	 * first interrupt, there comes the second with current correctly
-	 * pointing to buffer 1 this time. But sometimes this second interrupt
-	 * doesn't come and the channel hangs. Clearing BUFx_RDY when disabling
-	 * the channel seems to prevent the channel from hanging, but it doesn't
-	 * prevent the spurious interrupt. This might also be unsafe. Think
-	 * about the IDMAC controller trying to switch to a buffer, when we
-	 * clear the ready bit, and re-enable it a moment later.
-	 */
-	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY);
-	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF0_RDY);
-	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF0_RDY);
-
-	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY);
-	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF1_RDY);
-	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF1_RDY);
-
 	spin_unlock_irqrestore(&ipu->lock, flags);
 
 	return 0;
@@ -1246,33 +1223,6 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 	/* Other interrupts do not interfere with this channel */
 	spin_lock(&ichan->lock);
-	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
-		     ((curbuf >> chan_id) & 1) == ichan->active_buffer &&
-		     !list_is_last(ichan->queue.next, &ichan->queue))) {
-		int i = 100;
-
-		/* This doesn't help. See comment in ipu_disable_channel() */
-		while (--i) {
-			curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
-			if (((curbuf >> chan_id) & 1) != ichan->active_buffer)
-				break;
-			cpu_relax();
-		}
-
-		if (!i) {
-			spin_unlock(&ichan->lock);
-			dev_dbg(dev,
-				"IRQ on active buffer on channel %x, active "
-				"%d, ready %x, %x, current %x!\n", chan_id,
-				ichan->active_buffer, ready0, ready1, curbuf);
-			return IRQ_NONE;
-		} else
-			dev_dbg(dev,
-				"Buffer deactivated on channel %x, active "
-				"%d, ready %x, %x, current %x, rest %d!\n", chan_id,
-				ichan->active_buffer, ready0, ready1, curbuf, i);
-	}
-
 	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
 		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
 		     )) {
-- 
1.7.1

