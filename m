Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751413AbZBRADL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 19:03:11 -0500
Date: Wed, 18 Feb 2009 01:03:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Agustin <gatoguan-os@yahoo.com>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness
 improvements
In-Reply-To: <alpine.DEB.2.00.0902180044120.6986@axis700.grange>
Message-ID: <alpine.DEB.2.00.0902180049580.6986@axis700.grange>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch> <alpine.DEB.2.00.0902180044120.6986@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <lg@denx.de>

General code clean-up: remove superfluous semicolons, update comments.
Robustness improvements: add DMA error handling to the ISR, move common code
fragments to functions, fix scatter-gather element queuing in the ISR, survive
channel freeing and re-allocation in a quick succession.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

As mentioned in PATCH 0/4 this one is only for completeness / testing 
here, will be submitted separately to the dmaengine queue. Dan, would be 
good if you could review it here to save time.

 drivers/dma/ipu/ipu_idmac.c |  300 ++++++++++++++++++++++++++++---------------
 1 files changed, 196 insertions(+), 104 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 1f154d0..91e6e4e 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -28,6 +28,9 @@
 #define FS_VF_IN_VALID	0x00000002
 #define FS_ENC_IN_VALID	0x00000001
 
+static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
+			       bool wait_for_stop);
+
 /*
  * There can be only one, we could allocate it dynamically, but then we'd have
  * to add an extra parameter to some functions, and use something as ugly as
@@ -107,7 +110,7 @@ static uint32_t bytes_per_pixel(enum pixel_fmt fmt)
 	}
 }
 
-/* Enable / disable direct write to memory by the Camera Sensor Interface */
+/* Enable direct write to memory by the Camera Sensor Interface */
 static void ipu_ic_enable_task(struct ipu *ipu, enum ipu_channel channel)
 {
 	uint32_t ic_conf, mask;
@@ -126,6 +129,7 @@ static void ipu_ic_enable_task(struct ipu *ipu, enum ipu_channel channel)
 	idmac_write_icreg(ipu, ic_conf, IC_CONF);
 }
 
+/* Called under spin_lock_irqsave(&ipu_data.lock) */
 static void ipu_ic_disable_task(struct ipu *ipu, enum ipu_channel channel)
 {
 	uint32_t ic_conf, mask;
@@ -422,7 +426,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
 		break;
 	default:
 		dev_err(ipu_data.dev,
-			"mxc ipu: unimplemented pixel format %d\n", pixel_fmt);
+			"mx3 ipu: unimplemented pixel format %d\n", pixel_fmt);
 		break;
 	}
 
@@ -433,20 +437,20 @@ static void ipu_ch_param_set_burst_size(union chan_param_mem *params,
 					uint16_t burst_pixels)
 {
 	params->pp.npb = burst_pixels - 1;
-};
+}
 
 static void ipu_ch_param_set_buffer(union chan_param_mem *params,
 				    dma_addr_t buf0, dma_addr_t buf1)
 {
 	params->pp.eba0 = buf0;
 	params->pp.eba1 = buf1;
-};
+}
 
 static void ipu_ch_param_set_rotation(union chan_param_mem *params,
 				      enum ipu_rotate_mode rotate)
 {
 	params->pp.bam = rotate;
-};
+}
 
 static void ipu_write_param_mem(uint32_t addr, uint32_t *data,
 				uint32_t num_words)
@@ -571,7 +575,7 @@ static uint32_t dma_param_addr(uint32_t dma_ch)
 {
 	/* Channel Parameter Memory */
 	return 0x10000 | (dma_ch << 4);
-};
+}
 
 static void ipu_channel_set_priority(struct ipu *ipu, enum ipu_channel channel,
 				     bool prio)
@@ -611,7 +615,8 @@ static uint32_t ipu_channel_conf_mask(enum ipu_channel channel)
 
 /**
  * ipu_enable_channel() - enable an IPU channel.
- * @channel:	channel ID.
+ * @idmac:	IPU DMAC context.
+ * @ichan:	IDMAC channel.
  * @return:	0 on success or negative error code on failure.
  */
 static int ipu_enable_channel(struct idmac *idmac, struct idmac_channel *ichan)
@@ -649,7 +654,7 @@ static int ipu_enable_channel(struct idmac *idmac, struct idmac_channel *ichan)
 
 /**
  * ipu_init_channel_buffer() - initialize a buffer for logical IPU channel.
- * @channel:	channel ID.
+ * @ichan:	IDMAC channel.
  * @pixel_fmt:	pixel format of buffer. Pixel format is a FOURCC ASCII code.
  * @width:	width of buffer in pixels.
  * @height:	height of buffer in pixels.
@@ -687,7 +692,7 @@ static int ipu_init_channel_buffer(struct idmac_channel *ichan,
 	}
 
 	/* IC channel's stride must be a multiple of 8 pixels */
-	if ((channel <= 13) && (stride % 8)) {
+	if ((channel <= IDMAC_IC_13) && (stride % 8)) {
 		dev_err(ipu->dev, "Stride must be 8 pixel multiple\n");
 		return -EINVAL;
 	}
@@ -752,7 +757,7 @@ static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
 
 /**
  * ipu_update_channel_buffer() - update physical address of a channel buffer.
- * @channel:	channel ID.
+ * @ichan:	IDMAC channel.
  * @buffer_n:	buffer number to update.
  *		0 or 1 are the only valid values.
  * @phyaddr:	buffer physical address.
@@ -760,9 +765,10 @@ static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
  *              function will fail if the buffer is set to ready.
  */
 /* Called under spin_lock(_irqsave)(&ichan->lock) */
-static int ipu_update_channel_buffer(enum ipu_channel channel,
+static int ipu_update_channel_buffer(struct idmac_channel *ichan,
 				     int buffer_n, dma_addr_t phyaddr)
 {
+	enum ipu_channel channel = ichan->dma_chan.chan_id;
 	uint32_t reg;
 	unsigned long flags;
 
@@ -771,8 +777,8 @@ static int ipu_update_channel_buffer(enum ipu_channel channel,
 	if (buffer_n == 0) {
 		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY);
 		if (reg & (1UL << channel)) {
-			spin_unlock_irqrestore(&ipu_data.lock, flags);
-			return -EACCES;
+			ipu_ic_disable_task(&ipu_data, channel);
+			ichan->status = IPU_CHANNEL_READY;
 		}
 
 		/* 44.3.3.1.9 - Row Number 1 (WORD1, offset 0) */
@@ -782,8 +788,8 @@ static int ipu_update_channel_buffer(enum ipu_channel channel,
 	} else {
 		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
 		if (reg & (1UL << channel)) {
-			spin_unlock_irqrestore(&ipu_data.lock, flags);
-			return -EACCES;
+			ipu_ic_disable_task(&ipu_data, channel);
+			ichan->status = IPU_CHANNEL_READY;
 		}
 
 		/* Check if double-buffering is already enabled */
@@ -805,6 +811,39 @@ static int ipu_update_channel_buffer(enum ipu_channel channel,
 }
 
 /* Called under spin_lock_irqsave(&ichan->lock) */
+static int ipu_submit_buffer(struct idmac_channel *ichan,
+	struct idmac_tx_desc *desc, struct scatterlist *sg, int buf_idx)
+{
+	unsigned int chan_id = ichan->dma_chan.chan_id;
+	struct device *dev = &ichan->dma_chan.dev->device;
+	int ret;
+
+	if (async_tx_test_ack(&desc->txd))
+		return -EINTR;
+
+	/*
+	 * On first invocation this shouldn't be necessary, the call to
+	 * ipu_init_channel_buffer() above will set addresses for us, so we
+	 * could make it conditional on status >= IPU_CHANNEL_ENABLED, but
+	 * doing it again shouldn't hurt either.
+	 */
+	ret = ipu_update_channel_buffer(ichan, buf_idx,
+					sg_dma_address(sg));
+
+	if (ret < 0) {
+		dev_err(dev, "Updating sg %p on channel 0x%x buffer %d failed!\n",
+			sg, chan_id, buf_idx);
+		return ret;
+	}
+
+	ipu_select_buffer(chan_id, buf_idx);
+	dev_dbg(dev, "Updated sg %p on channel 0x%x buffer %d\n",
+		sg, chan_id, buf_idx);
+
+	return 0;
+}
+
+/* Called under spin_lock_irqsave(&ichan->lock) */
 static int ipu_submit_channel_buffers(struct idmac_channel *ichan,
 				      struct idmac_tx_desc *desc)
 {
@@ -815,20 +854,10 @@ static int ipu_submit_channel_buffers(struct idmac_channel *ichan,
 		if (!ichan->sg[i]) {
 			ichan->sg[i] = sg;
 
-			/*
-			 * On first invocation this shouldn't be necessary, the
-			 * call to ipu_init_channel_buffer() above will set
-			 * addresses for us, so we could make it conditional
-			 * on status >= IPU_CHANNEL_ENABLED, but doing it again
-			 * shouldn't hurt either.
-			 */
-			ret = ipu_update_channel_buffer(ichan->dma_chan.chan_id, i,
-							sg_dma_address(sg));
+			ret = ipu_submit_buffer(ichan, desc, sg, i);
 			if (ret < 0)
 				return ret;
 
-			ipu_select_buffer(ichan->dma_chan.chan_id, i);
-
 			sg = sg_next(sg);
 		}
 	}
@@ -842,19 +871,22 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct idmac_channel *ichan = to_idmac_chan(tx->chan);
 	struct idmac *idmac = to_idmac(tx->chan->device);
 	struct ipu *ipu = to_ipu(idmac);
+	struct device *dev = &ichan->dma_chan.dev->device;
 	dma_cookie_t cookie;
 	unsigned long flags;
+	int ret;
 
 	/* Sanity check */
 	if (!list_empty(&desc->list)) {
 		/* The descriptor doesn't belong to client */
-		dev_err(&ichan->dma_chan.dev->device,
-			"Descriptor %p not prepared!\n", tx);
+		dev_err(dev, "Descriptor %p not prepared!\n", tx);
 		return -EBUSY;
 	}
 
 	mutex_lock(&ichan->chan_mutex);
 
+	async_tx_clear_ack(tx);
+
 	if (ichan->status < IPU_CHANNEL_READY) {
 		struct idmac_video_param *video = &ichan->params.video;
 		/*
@@ -878,16 +910,7 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 			goto out;
 	}
 
-	/* ipu->lock can be taken under ichan->lock, but not v.v. */
-	spin_lock_irqsave(&ichan->lock, flags);
-
-	/* submit_buffers() atomically verifies and fills empty sg slots */
-	cookie = ipu_submit_channel_buffers(ichan, desc);
-
-	spin_unlock_irqrestore(&ichan->lock, flags);
-
-	if (cookie < 0)
-		goto out;
+	dev_dbg(dev, "Submitting sg %p\n", &desc->sg[0]);
 
 	cookie = ichan->dma_chan.cookie;
 
@@ -897,24 +920,40 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* from dmaengine.h: "last cookie value returned to client" */
 	ichan->dma_chan.cookie = cookie;
 	tx->cookie = cookie;
+
+	/* ipu->lock can be taken under ichan->lock, but not v.v. */
 	spin_lock_irqsave(&ichan->lock, flags);
+
 	list_add_tail(&desc->list, &ichan->queue);
+	/* submit_buffers() atomically verifies and fills empty sg slots */
+	ret = ipu_submit_channel_buffers(ichan, desc);
+
 	spin_unlock_irqrestore(&ichan->lock, flags);
 
+	if (ret < 0) {
+		cookie = ret;
+		goto dequeue;
+	}
+
 	if (ichan->status < IPU_CHANNEL_ENABLED) {
-		int ret = ipu_enable_channel(idmac, ichan);
+		ret = ipu_enable_channel(idmac, ichan);
 		if (ret < 0) {
 			cookie = ret;
-			spin_lock_irqsave(&ichan->lock, flags);
-			list_del_init(&desc->list);
-			spin_unlock_irqrestore(&ichan->lock, flags);
-			tx->cookie = cookie;
-			ichan->dma_chan.cookie = cookie;
+			goto dequeue;
 		}
 	}
 
 	dump_idmac_reg(ipu);
 
+dequeue:
+	if (cookie < 0) {
+		spin_lock_irqsave(&ichan->lock, flags);
+		list_del_init(&desc->list);
+		spin_unlock_irqrestore(&ichan->lock, flags);
+		tx->cookie = cookie;
+		ichan->dma_chan.cookie = cookie;
+	}
+
 out:
 	mutex_unlock(&ichan->chan_mutex);
 
@@ -1161,6 +1200,24 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
 	return 0;
 }
 
+static struct scatterlist *idmac_sg_next(struct idmac_channel *ichan,
+	struct idmac_tx_desc **desc, struct scatterlist *sg)
+{
+	struct scatterlist *sgnew = sg ? sg_next(sg) : NULL;
+
+	if (sgnew)
+		/* next sg-element in this list */
+		return sgnew;
+
+	if ((*desc)->list.next == &ichan->queue)
+		/* No more descriptors on the queue */
+		return NULL;
+
+	/* Fetch next descriptor */
+	*desc = list_entry((*desc)->list.next, struct idmac_tx_desc, list);
+	return (*desc)->sg;
+}
+
 /*
  * We have several possibilities here:
  * current BUF		next BUF
@@ -1176,23 +1233,46 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
 static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 {
 	struct idmac_channel *ichan = dev_id;
+	struct device *dev = &ichan->dma_chan.dev->device;
 	unsigned int chan_id = ichan->dma_chan.chan_id;
 	struct scatterlist **sg, *sgnext, *sgnew = NULL;
 	/* Next transfer descriptor */
-	struct idmac_tx_desc *desc = NULL, *descnew;
+	struct idmac_tx_desc *desc, *descnew;
 	dma_async_tx_callback callback;
 	void *callback_param;
 	bool done = false;
-	u32	ready0 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY),
-		ready1 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY),
-		curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
+	u32 ready0, ready1, curbuf, err;
+	unsigned long flags;
 
 	/* IDMAC has cleared the respective BUFx_RDY bit, we manage the buffer */
 
-	pr_debug("IDMAC irq %d\n", irq);
+	dev_dbg(dev, "IDMAC irq %d, buf %d\n", irq, ichan->active_buffer);
+
+	spin_lock_irqsave(&ipu_data.lock, flags);
+
+	ready0	= idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY);
+	ready1	= idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
+	curbuf	= idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
+	err	= idmac_read_ipureg(&ipu_data, IPU_INT_STAT_4);
+
+	if (err & (1 << chan_id)) {
+		idmac_write_ipureg(&ipu_data, 1 << chan_id, IPU_INT_STAT_4);
+		spin_unlock_irqrestore(&ipu_data.lock, flags);
+		/*
+		 * Doing this
+		 * ichan->sg[0] = ichan->sg[1] = NULL;
+		 * you can force channel re-enable on the next tx_submit(), but
+		 * this is dirty - think about descriptors with multiple
+		 * sg elements.
+		 */
+		dev_warn(dev, "NFB4EOF on channel %d, ready %x, %x, cur %x\n",
+			 chan_id, ready0, ready1, curbuf);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&ipu_data.lock, flags);
+
 	/* Other interrupts do not interfere with this channel */
 	spin_lock(&ichan->lock);
-
 	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
 		     ((curbuf >> chan_id) & 1) == ichan->active_buffer)) {
 		int i = 100;
@@ -1207,19 +1287,23 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 		if (!i) {
 			spin_unlock(&ichan->lock);
-			dev_dbg(ichan->dma_chan.device->dev,
+			dev_dbg(dev,
 				"IRQ on active buffer on channel %x, active "
 				"%d, ready %x, %x, current %x!\n", chan_id,
 				ichan->active_buffer, ready0, ready1, curbuf);
 			return IRQ_NONE;
-		}
+		} else
+			dev_dbg(dev,
+				"Buffer deactivated on channel %x, active "
+				"%d, ready %x, %x, current %x, rest %d!\n", chan_id,
+				ichan->active_buffer, ready0, ready1, curbuf, i);
 	}
 
 	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
 		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
 		     )) {
 		spin_unlock(&ichan->lock);
-		dev_dbg(ichan->dma_chan.device->dev,
+		dev_dbg(dev,
 			"IRQ with active buffer still ready on channel %x, "
 			"active %d, ready %x, %x!\n", chan_id,
 			ichan->active_buffer, ready0, ready1);
@@ -1227,8 +1311,9 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	}
 
 	if (unlikely(list_empty(&ichan->queue))) {
+		ichan->sg[ichan->active_buffer] = NULL;
 		spin_unlock(&ichan->lock);
-		dev_err(ichan->dma_chan.device->dev,
+		dev_err(dev,
 			"IRQ without queued buffers on channel %x, active %d, "
 			"ready %x, %x!\n", chan_id,
 			ichan->active_buffer, ready0, ready1);
@@ -1243,40 +1328,44 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	sg = &ichan->sg[ichan->active_buffer];
 	sgnext = ichan->sg[!ichan->active_buffer];
 
+	if (!*sg) {
+		spin_unlock(&ichan->lock);
+		return IRQ_HANDLED;
+	}
+
+	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
+	descnew = desc;
+
+	dev_dbg(dev, "IDMAC irq %d, dma 0x%08x, next dma 0x%08x, current %d, curbuf 0x%08x\n",
+		irq, sg_dma_address(*sg), sgnext ? sg_dma_address(sgnext) : 0, ichan->active_buffer, curbuf);
+
+	/* Find the descriptor of sgnext */
+	sgnew = idmac_sg_next(ichan, &descnew, *sg);
+	if (sgnext != sgnew)
+		dev_err(dev, "Submitted buffer %p, next buffer %p\n", sgnext, sgnew);
+
 	/*
 	 * if sgnext == NULL sg must be the last element in a scatterlist and
 	 * queue must be empty
 	 */
 	if (unlikely(!sgnext)) {
-		if (unlikely(sg_next(*sg))) {
-			dev_err(ichan->dma_chan.device->dev,
-				"Broken buffer-update locking on channel %x!\n",
-				chan_id);
-			/* We'll let the user catch up */
+		if (!WARN_ON(sg_next(*sg)))
+			dev_dbg(dev, "Underrun on channel %x\n", chan_id);
+		ichan->sg[!ichan->active_buffer] = sgnew;
+
+		if (unlikely(sgnew)) {
+			ipu_submit_buffer(ichan, descnew, sgnew, !ichan->active_buffer);
 		} else {
-			/* Underrun */
+			spin_lock_irqsave(&ipu_data.lock, flags);
 			ipu_ic_disable_task(&ipu_data, chan_id);
-			dev_dbg(ichan->dma_chan.device->dev,
-				"Underrun on channel %x\n", chan_id);
+			spin_unlock_irqrestore(&ipu_data.lock, flags);
 			ichan->status = IPU_CHANNEL_READY;
 			/* Continue to check for complete descriptor */
 		}
 	}
 
-	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
-
-	/* First calculate and submit the next sg element */
-	if (likely(sgnext))
-		sgnew = sg_next(sgnext);
-
-	if (unlikely(!sgnew)) {
-		/* Start a new scatterlist, if any queued */
-		if (likely(desc->list.next != &ichan->queue)) {
-			descnew = list_entry(desc->list.next,
-					     struct idmac_tx_desc, list);
-			sgnew = &descnew->sg[0];
-		}
-	}
+	/* Calculate and submit the next sg element */
+	sgnew = idmac_sg_next(ichan, &descnew, sgnew);
 
 	if (unlikely(!sg_next(*sg)) || !sgnext) {
 		/*
@@ -1289,17 +1378,13 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 
 	*sg = sgnew;
 
-	if (likely(sgnew)) {
-		int ret;
-
-		ret = ipu_update_channel_buffer(chan_id, ichan->active_buffer,
-						sg_dma_address(*sg));
-		if (ret < 0)
-			dev_err(ichan->dma_chan.device->dev,
-				"Failed to update buffer on channel %x buffer %d!\n",
-				chan_id, ichan->active_buffer);
-		else
-			ipu_select_buffer(chan_id, ichan->active_buffer);
+	if (likely(sgnew) &&
+	    ipu_submit_buffer(ichan, descnew, sgnew, ichan->active_buffer) < 0) {
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
+		spin_unlock(&ichan->lock);
+		callback(callback_param);
+		spin_lock(&ichan->lock);
 	}
 
 	/* Flip the active buffer - even if update above failed */
@@ -1327,13 +1412,20 @@ static void ipu_gc_tasklet(unsigned long arg)
 		struct idmac_channel *ichan = ipu->channel + i;
 		struct idmac_tx_desc *desc;
 		unsigned long flags;
-		int j;
+		struct scatterlist *sg;
+		int j, k;
 
 		for (j = 0; j < ichan->n_tx_desc; j++) {
 			desc = ichan->desc + j;
 			spin_lock_irqsave(&ichan->lock, flags);
 			if (async_tx_test_ack(&desc->txd)) {
 				list_move(&desc->list, &ichan->free_list);
+				for_each_sg(desc->sg, sg, desc->sg_len, k) {
+					if (ichan->sg[0] == sg)
+						ichan->sg[0] = NULL;
+					else if (ichan->sg[1] == sg)
+						ichan->sg[1] = NULL;
+				}
 				async_tx_clear_ack(&desc->txd);
 			}
 			spin_unlock_irqrestore(&ichan->lock, flags);
@@ -1341,13 +1433,7 @@ static void ipu_gc_tasklet(unsigned long arg)
 	}
 }
 
-/*
- * At the time .device_alloc_chan_resources() method is called, we cannot know,
- * whether the client will accept the channel. Thus we must only check, if we
- * can satisfy client's request but the only real criterion to verify, whether
- * the client has accepted our offer is the client_count. That's why we have to
- * perform the rest of our allocation tasks on the first call to this function.
- */
+/* Just allocate and initialise a transfer descriptor. */
 static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan,
 		struct scatterlist *sgl, unsigned int sg_len,
 		enum dma_data_direction direction, unsigned long tx_flags)
@@ -1432,8 +1518,7 @@ static void __idmac_terminate_all(struct dma_chan *chan)
 			struct idmac_tx_desc *desc = ichan->desc + i;
 			if (list_empty(&desc->list))
 				/* Descriptor was prepared, but not submitted */
-				list_add(&desc->list,
-					 &ichan->free_list);
+				list_add(&desc->list, &ichan->free_list);
 
 			async_tx_clear_ack(&desc->txd);
 		}
@@ -1476,15 +1561,22 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 		goto eimap;
 
 	ichan->eof_irq = ret;
-	ret = request_irq(ichan->eof_irq, idmac_interrupt, 0,
-			  ichan->eof_name, ichan);
-	if (ret < 0)
-		goto erirq;
+
+	/*
+	 * Important to first disable the channel, because maybe someone
+	 * used it before us, e.g., the bootloader
+	 */
+	ipu_disable_channel(idmac, ichan, true);
 
 	ret = ipu_init_channel(idmac, ichan);
 	if (ret < 0)
 		goto eichan;
 
+	ret = request_irq(ichan->eof_irq, idmac_interrupt, 0,
+			  ichan->eof_name, ichan);
+	if (ret < 0)
+		goto erirq;
+
 	ichan->status = IPU_CHANNEL_INITIALIZED;
 
 	dev_dbg(&ichan->dma_chan.dev->device, "Found channel 0x%x, irq %d\n",
@@ -1492,9 +1584,9 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 
 	return ret;
 
-eichan:
-	free_irq(ichan->eof_irq, ichan);
 erirq:
+	ipu_uninit_channel(idmac, ichan);
+eichan:
 	ipu_irq_unmap(ichan->dma_chan.chan_id);
 eimap:
 	return ret;
@@ -1600,7 +1692,7 @@ static void ipu_idmac_exit(struct ipu *ipu)
  * IPU common probe / remove
  */
 
-static int ipu_probe(struct platform_device *pdev)
+static int __init ipu_probe(struct platform_device *pdev)
 {
 	struct ipu_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *mem_ipu, *mem_ic;
-- 
1.5.4
