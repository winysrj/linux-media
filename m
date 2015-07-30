Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33599 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbbG3LIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 07:08:47 -0400
Received: by wicmv11 with SMTP id mv11so16470192wic.0
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 04:08:46 -0700 (PDT)
Date: Thu, 30 Jul 2015 12:08:41 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 07/12] [media] tsin: c8sectpfe: STiH407/10 Linux DVB
 demux support
Message-ID: <20150730110841.GE488@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
 <1435158670-7195-8-git-send-email-peter.griffin@linaro.org>
 <20150722184653.2213154b@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150722184653.2213154b@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for reviewing.

On Wed, 22 Jul 2015, Mauro Carvalho Chehab wrote:

> Em Wed, 24 Jun 2015 16:11:05 +0100
> Peter Griffin <peter.griffin@linaro.org> escreveu:
> 
> > This patch adds support for the c8sectpfe input HW found on
> > STiH407/410 SoC's.
> > 
> > It currently supports the TS input block, memdma engine
> > and hw PID filtering blocks of the C8SECTPFE subsystem.
> > 
> > The driver creates one LinuxDVB adapter, and a
> > demux/dvr/frontend set of devices for each tsin channel
> > which is specificed in the DT. It has been tested with
> > multiple tsin channels tuned, locked, and grabbing TS
> > simultaneously.
> > 
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  drivers/media/tsin/c8sectpfe/c8sectpfe-core.c | 1105 +++++++++++++++++++++++++
> >  drivers/media/tsin/c8sectpfe/c8sectpfe-core.h |  288 +++++++
> >  2 files changed, 1393 insertions(+)
> >  create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-core.c
> >  create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-core.h
> > 
> > diff --git a/drivers/media/tsin/c8sectpfe/c8sectpfe-core.c b/drivers/media/tsin/c8sectpfe/c8sectpfe-core.c
> > new file mode 100644
> > index 0000000..fbbe323
> > --- /dev/null
> > +++ b/drivers/media/tsin/c8sectpfe/c8sectpfe-core.c
> > @@ -0,0 +1,1105 @@
> > +/*
> > + * c8sectpfe-core.c - C8SECTPFE STi DVB driver
> > + *
> > + * Copyright (c) STMicroelectronics 2015
> > + *
> > + *   Author:Peter Bennett <peter.bennett@st.com>
> > + *	    Peter Griffin <peter.griffin@linaro.org>
> > + *
> > + *	This program is free software; you can redistribute it and/or
> > + *	modify it under the terms of the GNU General Public License as
> > + *	published by the Free Software Foundation; either version 2 of
> > + *	the License, or (at your option) any later version.
> > + */
> > +#include <linux/clk.h>
> > +#include <linux/completion.h>
> > +#include <linux/delay.h>
> > +#include <linux/device.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/dvb/dmx.h>
> > +#include <linux/dvb/frontend.h>
> > +#include <linux/errno.h>
> > +#include <linux/firmware.h>
> > +#include <linux/init.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/of_gpio.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/usb.h>
> > +#include <linux/slab.h>
> > +#include <linux/time.h>
> > +#include <linux/version.h>
> > +#include <linux/wait.h>
> > +
> > +#include "c8sectpfe-core.h"
> > +#include "c8sectpfe-common.h"
> > +#include "c8sectpfe-debugfs.h"
> > +#include "dmxdev.h"
> > +#include "dvb_demux.h"
> > +#include "dvb_frontend.h"
> > +#include "dvb_net.h"
> > +
> > +#define FIRMWARE_MEMDMA "pti_memdma_h407.elf"
> > +MODULE_FIRMWARE(FIRMWARE_MEMDMA);
> > +
> > +#define PID_TABLE_SIZE 1024
> > +#define POLL_20_HZ_DIV 20 /* poll at 20 Hz */
> > +
> > +static int load_slim_core_fw(struct c8sectpfei *fei);
> > +
> > +#define TS_PKT_SIZE 188
> > +#define HEADER_SIZE (4)
> > +#define PACKET_SIZE (TS_PKT_SIZE+HEADER_SIZE)
> > +
> > +#define FEI_ALIGNMENT (32)
> > +/* hw requires minimum of 8*PACKET_SIZE and padded to 8byte boundary */
> > +#define FEI_BUFFER_SIZE (8*PACKET_SIZE*340)
> > +
> > +#define FIFO_LEN 1024
> > +
> > +static void c8sectpfe_timer_interrupt(unsigned long ac8sectpfei)
> > +{
> > +	struct c8sectpfei *fei = (struct c8sectpfei *)ac8sectpfei;
> > +	struct channel_info *channel;
> > +	int chan_num;
> > +
> > +	/* iterate through input block channels */
> > +	for (chan_num = 0; chan_num < fei->tsin_count; chan_num++) {
> > +		channel = fei->channel_data[chan_num];
> > +
> > +		/* is this descriptor initialised and TP enabled */
> > +		if (channel->irec && readl((void __iomem *)
> > +						&channel->irec->tp_enable))
> > +			tasklet_schedule(&channel->tsklet);
> > +	}
> > +
> > +	fei->timer.expires = jiffies + (HZ / POLL_20_HZ_DIV);
> 
> Please use the macros for jiffies conversions. In this case, I guess
> you want to use ms_to_jiffies(), right?

Fixed in V2.

> 
> > +	add_timer(&fei->timer);
> > +}
> > +
> > +static void channel_swdemux_tsklet(unsigned long data)
> > +{
> > +	struct channel_info *channel = (struct channel_info *)data;
> > +	struct c8sectpfei *fei = channel->fei;
> > +	struct tpentry *ptrblk;
> > +	unsigned long wp, rp;
> > +	int pos, num_packets, n, size;
> > +	u8 *buf;
> > +
> > +	BUG_ON(!channel);
> > +	BUG_ON(!channel->irec);
> 
> Please avoid using BUG_ON() except when the machine will be on some
> unstable state. In this case, I guess you could just do:
> 
> 	if (unlikely(!channel || !channel->irec)
> 		return;

Yes ok, I have removed the BUG_ON's in v2

> 
> > +
> > +	ptrblk = &channel->irec->ptr_data[0];
> > +
> > +	wp = readl((void __iomem *)&ptrblk->dma_bus_wp);
> > +	rp = readl((void __iomem *)&ptrblk->dma_bus_rp);
> 
> Why do you need those typecasts? We try to avoid typecasts in the Kernel,
> doing it only where really needed. Same for other usages. You should
> probably declare those DMA buffers as __iomem *, and avoid the casts.

Ok, I've fixed this in V2.

> 
> > +
> > +	pos = rp - channel->back_buffer_busaddr;
> > +
> > +	/* has it wrapped */
> > +	if (wp < rp)
> > +		wp = channel->back_buffer_busaddr + FEI_BUFFER_SIZE;
> > +
> > +	size = wp - rp;
> > +	num_packets = size / PACKET_SIZE;
> > +
> > +	/* manage cache so data is visible to CPU */
> > +	dma_sync_single_for_cpu(fei->dev,
> > +				rp,
> > +				size,
> > +				DMA_FROM_DEVICE);
> > +
> > +	buf = (u8 *) channel->back_buffer_aligned;
> > +
> > +	dev_dbg(fei->dev,
> > +		"chan=%d channel=%p num_packets = %d, buf = %p, pos = 0x%x\n\t"
> > +		"rp=0x%lx, wp=0x%lx\n",
> > +		channel->tsin_id, channel, num_packets, buf, pos, rp, wp);
> > +
> > +	for (n = 0; n < num_packets; n++) {
> > +		dvb_dmx_swfilter_packets(
> > +			&fei->c8sectpfe[0]->
> > +				demux[channel->demux_mapping].dvb_demux,
> > +			&buf[pos], 1);
> > +
> > +		pos += PACKET_SIZE;
> > +	}
> 
> Hmm... why not call it, instead, without the loop, e. g.:
> 
> 	dvb_dmx_swfilter_packets(
> 		&fei->c8sectpfe[0]->
> 				demux[channel->demux_mapping].dvb_demux,
> 			&buf[pos], num_packets);

The InputBlock hardware outputs in multiples of 8 bytes, so we are actually
incrementing by 192 bytes in this loop, for each 188 byte TS packet.

These additional bytes can be used for timestamping TS packets on arrival
and then using this for clock recovery, although that isn't enabled atm.

I notice in dvb_demux.c you have a dvb_dmx_swfilter_204 as well as
dvb_dmx_swfilter, so we could maybe add a dvb_dmx_swfilter_192?

Although I thought this was most likely a ST specific thing, so didn't
change the core code, and handled it within the driver.

> 
> 
> > +
> > +	/* advance the read pointer */
> > +	if (wp == (channel->back_buffer_busaddr + FEI_BUFFER_SIZE))
> > +		writel(channel->back_buffer_busaddr,
> > +			(void __iomem *)&ptrblk->dma_bus_rp);
> > +	else
> > +		writel(wp, (void __iomem *)&ptrblk->dma_bus_rp);
> > +}
> > +
> > +static int c8sectpfe_start_feed(struct dvb_demux_feed *dvbdmxfeed)
> > +{
> > +	struct dvb_demux *demux = dvbdmxfeed->demux;
> > +	struct stdemux *stdemux = (struct stdemux *)demux->priv;
> > +	struct c8sectpfei *fei = stdemux->c8sectpfei;
> > +	struct channel_info *channel;
> > +	struct tpentry *ptrblk;
> > +	u32 tmp;
> > +	unsigned long *bitmap;
> > +
> > +	switch (dvbdmxfeed->type) {
> > +	case DMX_TYPE_TS:
> > +		break;
> > +	case DMX_TYPE_SEC:
> > +		break;
> > +	default:
> > +		dev_err(fei->dev, "%s:%d Error bailing\n"
> > +			, __func__, __LINE__);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (dvbdmxfeed->type == DMX_TYPE_TS) {
> > +		switch (dvbdmxfeed->pes_type) {
> > +		case DMX_PES_VIDEO:
> > +		case DMX_PES_AUDIO:
> > +		case DMX_PES_TELETEXT:
> > +		case DMX_PES_PCR:
> > +		case DMX_PES_OTHER:
> > +			break;
> > +		default:
> > +			dev_err(fei->dev, "%s:%d Error bailing\n"
> > +				, __func__, __LINE__);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	mutex_lock(&fei->lock);
> > +
> > +	channel = fei->channel_data[stdemux->tsin_index];
> > +
> > +	bitmap = (unsigned long *) channel->pid_buffer_aligned;
> > +
> > +	bitmap_set(bitmap, dvbdmxfeed->pid, 1);
> > +
> > +	/* manage cache so PID bitmap is visible to HW */
> > +	dma_sync_single_for_device(fei->dev,
> > +					channel->pid_buffer_busaddr,
> > +					PID_TABLE_SIZE,
> > +					DMA_TO_DEVICE);
> > +
> > +	channel->active = 1;
> > +
> > +	if (fei->global_feed_count == 0) {
> > +		fei->timer.expires = jiffies + (HZ / POLL_20_HZ_DIV);
> 
> Please use ms_to_jiffies().

Fixed in v2.

> 
> > +		add_timer(&fei->timer);
> > +	}
> > +
> > +	if (stdemux->running_feed_count == 0) {
> > +
> > +		dev_dbg(fei->dev, "Starting channel=%p\n", channel);
> > +
> > +		tasklet_init(&channel->tsklet, channel_swdemux_tsklet,
> > +			     (unsigned long) channel);
> > +
> > +		/* Reset the internal inputblock sram pointers */
> > +		writel(channel->fifo,
> > +			fei->io + C8SECTPFE_IB_BUFF_STRT(channel->tsin_id));
> > +		writel(channel->fifo + FIFO_LEN - 1,
> > +			fei->io + C8SECTPFE_IB_BUFF_END(channel->tsin_id));
> > +
> > +		writel(channel->fifo,
> > +			fei->io + C8SECTPFE_IB_READ_PNT(channel->tsin_id));
> > +		writel(channel->fifo,
> > +			fei->io + C8SECTPFE_IB_WRT_PNT(channel->tsin_id));
> > +
> > +
> > +		/* reset read / write memdma ptrs for this channel */
> > +		ptrblk = &channel->irec->ptr_data[0];
> > +		writel(channel->back_buffer_busaddr,
> > +			(void __iomem *)&ptrblk->dma_busbase);
> > +
> > +		tmp = channel->back_buffer_busaddr + FEI_BUFFER_SIZE - 1;
> > +		writel(tmp, (void __iomem *)&ptrblk->dma_bustop);
> > +
> > +		writel(channel->back_buffer_busaddr,
> > +			(void __iomem *)&ptrblk->dma_bus_wp);
> > +
> > +		/* Issue a reset and enable InputBlock */
> > +		writel(C8SECTPFE_SYS_ENABLE | C8SECTPFE_SYS_RESET
> > +			, fei->io + C8SECTPFE_IB_SYS(channel->tsin_id));
> > +
> > +		/* and enable the tp */
> > +		writel(0x1, (void __iomem *)&channel->irec->tp_enable);
> > +
> > +		dev_dbg(fei->dev, "%s:%d Starting DMA feed on stdemux=%p\n"
> > +			, __func__, __LINE__, stdemux);
> > +	}
> > +
> > +	stdemux->running_feed_count++;
> > +	fei->global_feed_count++;
> > +
> > +	mutex_unlock(&fei->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static int c8sectpfe_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
> > +{
> > +
> > +	struct dvb_demux *demux = dvbdmxfeed->demux;
> > +	struct stdemux *stdemux = (struct stdemux *)demux->priv;
> > +	struct c8sectpfei *fei = stdemux->c8sectpfei;
> > +	struct channel_info *channel;
> > +	struct tpentry *ptrblk;
> > +	int idlereq;
> > +	u32 tmp;
> > +	int ret;
> > +	unsigned long *bitmap;
> > +
> > +	mutex_lock(&fei->lock);
> > +
> > +	channel = fei->channel_data[stdemux->tsin_index];
> > +
> > +	bitmap = (unsigned long *) channel->pid_buffer_aligned;
> > +	bitmap_clear(bitmap, dvbdmxfeed->pid, 1);
> > +
> > +	/* manage cache so data is visible to HW */
> > +	dma_sync_single_for_device(fei->dev,
> > +					channel->pid_buffer_busaddr,
> > +					PID_TABLE_SIZE,
> > +					DMA_TO_DEVICE);
> > +
> > +	if (--stdemux->running_feed_count == 0) {
> > +
> > +		channel = fei->channel_data[stdemux->tsin_index];
> > +		ptrblk = &channel->irec->ptr_data[0];
> > +
> > +		/* TP re-configuration on page 168 */
> 
> Page 168 of what?

functional spec. I've updated the comment in V2.

> 
> > +
> > +		/* disable IB (prevents more TS data going to memdma) */
> > +		writel(0, fei->io + C8SECTPFE_IB_SYS(channel->tsin_id));
> > +
> > +		/* disable this channels descriptor */
> > +		writel(0, (void __iomem *)&channel->irec->tp_enable);
> > +
> > +		tasklet_disable(&channel->tsklet);
> > +
> > +		/* now request memdma channel goes idle */
> > +		idlereq = (1 << channel->tsin_id) | IDLEREQ;
> > +		writel(idlereq, fei->io + DMA_IDLE_REQ);
> > +
> > +		/* wait for idle irq handler to signal completion */
> > +		ret = wait_for_completion_timeout(&channel->idle_completion,
> > +						msecs_to_jiffies(100));
> > +
> > +		if (ret == 0)
> > +			dev_warn(fei->dev,
> > +				"Timeout waiting for idle irq on tsin%d\n",
> > +				channel->tsin_id);
> > +
> > +		reinit_completion(&channel->idle_completion);
> > +
> > +		/* reset read / write ptrs for this channel */
> > +		writel(channel->back_buffer_busaddr,
> > +			(void __iomem *)&ptrblk->dma_busbase);
> > +
> > +		tmp = channel->back_buffer_busaddr + FEI_BUFFER_SIZE - 1;
> > +		writel(tmp, (void __iomem *)&ptrblk->dma_bustop);
> > +
> > +		writel(channel->back_buffer_busaddr,
> > +			(void __iomem *)&ptrblk->dma_bus_wp);
> > +
> > +		dev_dbg(fei->dev,
> > +			"%s:%d stopping DMA feed on stdemux=%p channel=%d\n",
> > +			__func__, __LINE__, stdemux, channel->tsin_id);
> > +
> > +		/* turn off all PIDS in the bitmap*/
> > +		memset((void *)channel->pid_buffer_aligned
> > +			, 0x00, PID_TABLE_SIZE);
> > +
> > +		/* manage cache so data is visible to HW */
> > +		dma_sync_single_for_device(fei->dev,
> > +					channel->pid_buffer_busaddr,
> > +					PID_TABLE_SIZE,
> > +					DMA_TO_DEVICE);
> > +
> > +		channel->active = 0;
> > +	}
> > +
> > +	if (--fei->global_feed_count == 0) {
> > +		dev_dbg(fei->dev, "%s:%d global_feed_count=%d\n"
> > +			, __func__, __LINE__, fei->global_feed_count);
> > +
> > +		del_timer(&fei->timer);
> > +	}
> > +
> > +	mutex_unlock(&fei->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct channel_info *find_channel(struct c8sectpfei *fei, int tsin_num)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < C8SECTPFE_MAXCHANNEL; i++) {
> > +		if (!fei->channel_data[i])
> > +			continue;
> > +
> > +		if (fei->channel_data[i]->tsin_id == tsin_num)
> > +			return fei->channel_data[i];
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void c8sectpfe_getconfig(struct c8sectpfei *fei)
> > +{
> > +	struct c8sectpfe_hw *hw = &fei->hw_stats;
> > +
> > +	hw->num_ib = readl(fei->io + SYS_CFG_NUM_IB);
> > +	hw->num_mib = readl(fei->io + SYS_CFG_NUM_MIB);
> > +	hw->num_swts = readl(fei->io + SYS_CFG_NUM_SWTS);
> > +	hw->num_tsout = readl(fei->io + SYS_CFG_NUM_TSOUT);
> > +	hw->num_ccsc = readl(fei->io + SYS_CFG_NUM_CCSC);
> > +	hw->num_ram = readl(fei->io + SYS_CFG_NUM_RAM);
> > +	hw->num_tp = readl(fei->io + SYS_CFG_NUM_TP);
> > +
> > +	dev_info(fei->dev, "C8SECTPFE hw supports the following:\n");
> > +	dev_info(fei->dev, "Input Blocks: %d\n", hw->num_ib);
> > +	dev_info(fei->dev, "Merged Input Blocks: %d\n", hw->num_mib);
> > +	dev_info(fei->dev, "Software Transport Stream Inputs: %d\n"
> > +				, hw->num_swts);
> > +	dev_info(fei->dev, "Transport Stream Output: %d\n", hw->num_tsout);
> > +	dev_info(fei->dev, "Cable Card Converter: %d\n", hw->num_ccsc);
> > +	dev_info(fei->dev, "RAMs supported by C8SECTPFE: %d\n", hw->num_ram);
> > +	dev_info(fei->dev, "Tango TPs supported by C8SECTPFE: %d\n"
> > +			, hw->num_tp);
> > +}
> > +
> > +static irqreturn_t c8sectpfe_idle_irq_handler(int irq, void *priv)
> > +{
> > +	struct c8sectpfei *fei = priv;
> > +	struct channel_info *chan;
> > +	int bit;
> > +	unsigned long tmp = readl(fei->io + DMA_IDLE_REQ);
> > +
> > +	/* page 168 of functional spec: Clear the idle request
> > +	   by writing 0 to the C8SECTPFE_DMA_IDLE_REQ register. */
> > +
> > +	/* signal idle completion */
> > +	for_each_set_bit(bit, &tmp, fei->hw_stats.num_ib) {
> > +
> > +		chan = find_channel(fei, bit);
> > +
> > +		if (chan)
> > +			complete(&chan->idle_completion);
> > +	}
> > +
> > +	writel(0, fei->io + DMA_IDLE_REQ);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +
> > +static void free_input_block(struct c8sectpfei *fei, struct channel_info *tsin)
> > +{
> > +	BUG_ON(!fei);
> > +	BUG_ON(!tsin);
> 
> Again, BUG_ON() don't make much sense here. Just return if those vars are
> NULL.

I've removed the BUG_ON in V2

> 
> > +
> > +	if (tsin->back_buffer_busaddr)
> > +		if (!dma_mapping_error(fei->dev, tsin->back_buffer_busaddr))
> > +			dma_unmap_single(fei->dev, tsin->back_buffer_busaddr,
> > +				FEI_BUFFER_SIZE, DMA_BIDIRECTIONAL);
> > +
> > +	kfree(tsin->back_buffer_start);
> > +
> > +	if (tsin->pid_buffer_busaddr)
> > +		if (!dma_mapping_error(fei->dev, tsin->pid_buffer_busaddr))
> > +			dma_unmap_single(fei->dev, tsin->pid_buffer_busaddr,
> > +				PID_TABLE_SIZE, DMA_BIDIRECTIONAL);
> > +
> > +	kfree(tsin->pid_buffer_start);
> > +}
> > +
> > +#define MAX_NAME 20
> > +
> > +static int configure_input_block(struct c8sectpfei *fei,
> > +				struct channel_info *tsin)
> > +{
> > +	int ret;
> > +	u32 tmp = 0;
> > +	struct tpentry *ptrblk;
> > +	char tsin_pin_name[MAX_NAME];
> > +
> > +	BUG_ON(!fei);
> > +	BUG_ON(!tsin);
> 
> Same here: BUG_ON() seems too severe.

Removed in V2.

> 
> > +
> > +	dev_dbg(fei->dev, "%s:%d Configuring channel=%p tsin=%d\n"
> > +		, __func__, __LINE__, tsin, tsin->tsin_id);
> > +
> > +	init_completion(&tsin->idle_completion);
> > +
> > +	tsin->back_buffer_start = kzalloc(FEI_BUFFER_SIZE +
> > +					FEI_ALIGNMENT, GFP_KERNEL);
> > +
> > +	if (!tsin->back_buffer_start) {
> > +		ret = -ENOMEM;
> > +		goto err_unmap;
> > +	}
> > +
> > +	/* Ensure backbuffer is 32byte aligned */
> > +	tsin->back_buffer_aligned = tsin->back_buffer_start
> > +		+ FEI_ALIGNMENT;
> > +
> > +	tsin->back_buffer_aligned = (void *)
> > +		(((uintptr_t) tsin->back_buffer_aligned) & ~0x1F);
> > +
> > +	tsin->back_buffer_busaddr = dma_map_single(fei->dev,
> > +					(void *)tsin->back_buffer_aligned,
> > +					FEI_BUFFER_SIZE,
> > +					DMA_BIDIRECTIONAL);
> > +
> > +	if (dma_mapping_error(fei->dev, tsin->back_buffer_busaddr)) {
> > +		dev_err(fei->dev, "failed to map back_buffer\n");
> > +		ret = -EFAULT;
> > +		goto err_unmap;
> > +	}
> > +
> > +	/*
> > +	 * The pid buffer can be configured (in hw) for byte or bit
> > +	 * per pid. By powers of deduction we conclude stih407 family
> > +	 * is configured (at SoC design stage) for bit per pid.
> > +	 */
> > +	tsin->pid_buffer_start = kzalloc(2048, GFP_KERNEL);
> > +
> > +	if (!tsin->pid_buffer_start) {
> > +		ret = -ENOMEM;
> > +		goto err_unmap;
> > +	}
> > +
> > +	/*
> > +	 * PID buffer needs to be aligned to size of the pid table
> > +	 * which at bit per pid is 1024 bytes (8192 pids / 8).
> > +	 * PIDF_BASE register enforces this alignment when writing
> > +	 * the register.
> > +	 */
> > +
> > +	tsin->pid_buffer_aligned = tsin->pid_buffer_start +
> > +		PID_TABLE_SIZE;
> > +
> > +	tsin->pid_buffer_aligned = (void *)
> > +		(((uintptr_t) tsin->pid_buffer_aligned) & ~0x3ff);
> > +
> > +	tsin->pid_buffer_busaddr = dma_map_single(fei->dev,
> > +						tsin->pid_buffer_aligned,
> > +						PID_TABLE_SIZE,
> > +						DMA_BIDIRECTIONAL);
> > +
> > +	if (dma_mapping_error(fei->dev, tsin->pid_buffer_busaddr)) {
> > +		dev_err(fei->dev, "failed to map pid_bitmap\n");
> > +		ret = -EFAULT;
> > +		goto err_unmap;
> > +	}
> > +
> > +	/* manage cache so pid bitmap is visible to HW */
> > +	dma_sync_single_for_device(fei->dev,
> > +				tsin->pid_buffer_busaddr,
> > +				PID_TABLE_SIZE,
> > +				DMA_TO_DEVICE);
> > +
> > +	snprintf(tsin_pin_name, MAX_NAME, "tsin%d-%s", tsin->tsin_id,
> > +		(tsin->serial_not_parallel ? "serial" : "parallel"));
> > +
> > +	tsin->pstate = pinctrl_lookup_state(fei->pinctrl, tsin_pin_name);
> > +	if (IS_ERR(tsin->pstate)) {
> > +		dev_err(fei->dev, "%s: pinctrl_lookup_state couldn't find %s state\n"
> > +			, __func__, tsin_pin_name);
> > +		ret = PTR_ERR(tsin->pstate);
> > +		goto err_unmap;
> > +	}
> > +
> > +	ret = pinctrl_select_state(fei->pinctrl, tsin->pstate);
> > +
> > +	if (ret) {
> > +		dev_err(fei->dev, "%s: pinctrl_select_state failed\n"
> > +			, __func__);
> > +		goto err_unmap;
> > +	}
> > +
> > +	/* Enable this input block */
> > +	tmp = readl(fei->io + SYS_INPUT_CLKEN);
> > +	tmp |= BIT(tsin->tsin_id);
> > +	writel(tmp, fei->io + SYS_INPUT_CLKEN);
> > +
> > +	if (tsin->serial_not_parallel)
> > +		tmp |= C8SECTPFE_SERIAL_NOT_PARALLEL;
> > +
> > +	if (tsin->invert_ts_clk)
> > +		tmp |= C8SECTPFE_INVERT_TSCLK;
> > +
> > +	if (tsin->async_not_sync)
> > +		tmp |= C8SECTPFE_ASYNC_NOT_SYNC;
> > +
> > +	tmp |= C8SECTPFE_ALIGN_BYTE_SOP | C8SECTPFE_BYTE_ENDIANNESS_MSB;
> > +
> > +	writel(tmp, fei->io + C8SECTPFE_IB_IP_FMT_CFG(tsin->tsin_id));
> > +
> > +	writel(C8SECTPFE_SYNC(0x9) |
> > +		C8SECTPFE_DROP(0x9) |
> > +		C8SECTPFE_TOKEN(0x47),
> > +		fei->io + C8SECTPFE_IB_SYNCLCKDRP_CFG(tsin->tsin_id));
> > +
> > +	writel(TS_PKT_SIZE, fei->io + C8SECTPFE_IB_PKT_LEN(tsin->tsin_id));
> > +
> > +	/* Place the FIFO's at the end of the irec descriptors */
> > +
> > +	tsin->fifo = (tsin->tsin_id * FIFO_LEN);
> > +
> > +	writel(tsin->fifo, fei->io + C8SECTPFE_IB_BUFF_STRT(tsin->tsin_id));
> > +	writel(tsin->fifo + FIFO_LEN - 1,
> > +		fei->io + C8SECTPFE_IB_BUFF_END(tsin->tsin_id));
> > +
> > +	writel(tsin->fifo, fei->io + C8SECTPFE_IB_READ_PNT(tsin->tsin_id));
> > +	writel(tsin->fifo, fei->io + C8SECTPFE_IB_WRT_PNT(tsin->tsin_id));
> > +
> > +	writel(tsin->pid_buffer_busaddr,
> > +		fei->io + PIDF_BASE(tsin->tsin_id));
> > +
> > +	dev_dbg(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=0x%x\n",
> > +		tsin->tsin_id, readl(fei->io + PIDF_BASE(tsin->tsin_id)),
> > +		tsin->pid_buffer_busaddr);
> > +
> > +	/* Configure and enable HW PID filtering */
> > +
> > +	/*
> > +	 * The PID value is created by assembling the first 8 bytes of
> > +	 * the TS packet into a 64-bit word in big-endian format. A
> > +	 * slice of that 64-bit word is taken from
> > +	 * (PID_OFFSET+PID_NUM_BITS-1) to PID_OFFSET.
> > +	 */
> > +	tmp = (C8SECTPFE_PID_ENABLE | C8SECTPFE_PID_NUMBITS(13)
> > +		| C8SECTPFE_PID_OFFSET(40));
> > +
> > +	writel(tmp, fei->io + C8SECTPFE_IB_PID_SET(tsin->tsin_id));
> > +
> > +	dev_dbg(fei->dev, "chan=%d setting wp: %d, rp: %d, buf: %d-%d\n",
> > +		tsin->tsin_id,
> > +		readl(fei->io + C8SECTPFE_IB_WRT_PNT(tsin->tsin_id)),
> > +		readl(fei->io + C8SECTPFE_IB_READ_PNT(tsin->tsin_id)),
> > +		readl(fei->io + C8SECTPFE_IB_BUFF_STRT(tsin->tsin_id)),
> > +		readl(fei->io + C8SECTPFE_IB_BUFF_END(tsin->tsin_id)));
> > +
> > +	/*
> > +	 * Base address of pointer record block relative to
> > +	 * base address of DMEM
> > +	 */
> > +	fei->irec = fei->io + DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET +
> > +			readl(fei->io + DMA_PTRREC_BASE);
> > +
> > +	tsin->irec = fei->irec += tsin->tsin_id;
> > +
> > +	ptrblk = &tsin->irec->ptr_data[0];
> > +
> > +	writel(tsin->fifo,
> > +		(void __iomem *)&tsin->irec->dma_membase);
> > +
> > +	writel(tsin->fifo + FIFO_LEN - 1,
> > +		(void __iomem *)&tsin->irec->dma_memtop);
> > +
> > +	writel((188 + 7)&~7,
> > +		(void __iomem *)&tsin->irec->dma_ts_pktsize);
> > +
> > +	writel(0x1, (void __iomem *)&tsin->irec->tp_enable);
> > +
> > +	/* read/write pointers with physical bus address */
> > +	writel(tsin->back_buffer_busaddr,
> > +		(void __iomem *)&ptrblk->dma_busbase);
> > +
> > +	tmp = tsin->back_buffer_busaddr + FEI_BUFFER_SIZE - 1;
> > +	writel(tmp, (void __iomem *)&ptrblk->dma_bustop);
> > +
> > +	writel(tsin->back_buffer_busaddr,
> > +		(void __iomem *)&ptrblk->dma_bus_wp);
> > +
> > +	writel(tsin->back_buffer_busaddr,
> > +		(void __iomem *)&ptrblk->dma_bus_rp);
> > +
> > +	/* initialize tasklet */
> > +	tasklet_init(&tsin->tsklet, channel_swdemux_tsklet,
> > +		(unsigned long) tsin);
> > +
> > +	return 0;
> > +
> > +err_unmap:
> > +	free_input_block(fei, tsin);
> > +	return ret;
> > +}
> > +
> > +static irqreturn_t c8sectpfe_error_irq_handler(int irq, void *priv)
> > +{
> > +	struct c8sectpfei *fei = priv;
> > +
> > +	dev_err(fei->dev, "%s: error handling not yet implemented\n"
> > +		, __func__);
> > +
> > +	/*
> > +	 * TODO FIXME we should detect some error conditions here
> > +	 * and ideally so something about them!
> > +	 */
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int c8sectpfe_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct device_node *child, *np = dev->of_node;
> > +	struct c8sectpfei *fei;
> > +	struct resource *res;
> > +	int ret, n;
> > +	struct channel_info *tsin;
> > +
> > +	/* Allocate the c8sectpfei structure */
> > +	fei = devm_kzalloc(dev, sizeof(struct c8sectpfei), GFP_KERNEL);
> > +	if (!fei)
> > +		return -ENOMEM;
> > +
> > +	fei->dev = dev;
> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "c8sectpfe");
> > +	fei->io = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(fei->io))
> > +		return PTR_ERR(fei->io);
> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> > +					"c8sectpfe-ram");
> > +	fei->sram = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(fei->sram))
> > +		return PTR_ERR(fei->sram);
> > +
> > +	fei->sram_size = res->end - res->start;
> > +
> > +	fei->idle_irq = platform_get_irq_byname(pdev, "c8sectpfe-idle-irq");
> > +	if (fei->idle_irq < 0) {
> > +		dev_err(dev, "Can't get c8sectpfe-idle-irq\n");
> > +		return fei->idle_irq;
> > +	}
> > +
> > +	fei->error_irq = platform_get_irq_byname(pdev, "c8sectpfe-error-irq");
> > +	if (fei->error_irq < 0) {
> > +		dev_err(dev, "Can't get c8sectpfe-error-irq\n");
> > +		return fei->error_irq;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, fei);
> > +
> > +	fei->c8sectpfeclk = devm_clk_get(dev, "c8sectpfe");
> > +	if (IS_ERR(fei->c8sectpfeclk)) {
> > +		dev_err(dev, "c8sectpfe clk not found\n");
> > +		return PTR_ERR(fei->c8sectpfeclk);
> > +	}
> > +
> > +	ret = clk_prepare_enable(fei->c8sectpfeclk);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to enable c8sectpfe clock\n");
> > +		return ret;
> > +	}
> > +
> > +	/* to save power disable all IP's (on by default) */
> > +	writel(0, fei->io + SYS_INPUT_CLKEN);
> > +
> > +	/* Enable memdma clock */
> > +	writel(MEMDMAENABLE, fei->io + SYS_OTHER_CLKEN);
> > +
> > +	/* clear internal sram */
> > +	memset_io(fei->sram, 0x0, fei->sram_size);
> > +
> > +	c8sectpfe_getconfig(fei);
> > +
> > +	ret = load_slim_core_fw(fei);
> > +	if (ret) {
> > +		dev_err(dev, "Couldn't load slim core firmware\n");
> > +		goto err_clk_disable;
> > +	}
> > +
> > +	ret = devm_request_irq(dev, fei->idle_irq, c8sectpfe_idle_irq_handler,
> > +			0, "c8sectpfe-idle-irq", fei);
> > +	if (ret) {
> > +		dev_err(dev, "Can't register c8sectpfe-idle-irq IRQ.\n");
> > +		goto err_clk_disable;
> > +	}
> > +
> > +	ret = devm_request_irq(dev, fei->error_irq,
> > +				c8sectpfe_error_irq_handler, 0,
> > +				"c8sectpfe-error-irq", fei);
> > +	if (ret) {
> > +		dev_err(dev, "Can't register c8sectpfe-error-irq IRQ.\n");
> > +		goto err_clk_disable;
> > +	}
> > +
> > +	fei->tsin_count = of_get_child_count(np);
> > +
> > +	if (fei->tsin_count > C8SECTPFE_MAX_TSIN_CHAN ||
> > +		fei->tsin_count > fei->hw_stats.num_ib) {
> > +
> > +		dev_err(dev, "More tsin declared than exist on SoC!\n");
> > +		ret = -EINVAL;
> > +		goto err_clk_disable;
> > +	}
> > +
> > +	fei->pinctrl = devm_pinctrl_get(dev);
> > +
> > +	if (IS_ERR(fei->pinctrl)) {
> > +		dev_err(dev, "Error getting tsin pins\n");
> > +		ret = PTR_ERR(fei->pinctrl);
> > +		goto err_clk_disable;
> > +	}
> > +
> > +	n = 0;
> > +	for_each_child_of_node(np, child) {
> > +		struct device_node *i2c_bus;
> > +
> > +		fei->channel_data[n] = devm_kzalloc(dev,
> > +						sizeof(struct channel_info),
> > +						GFP_KERNEL);
> > +
> > +		if (!fei->channel_data[n]) {
> > +			ret = -ENOMEM;
> > +			goto err_clk_disable;
> > +		}
> > +
> > +		tsin = fei->channel_data[n];
> > +
> > +		tsin->fei = fei;
> > +
> > +		ret = of_property_read_u32(child, "tsin-num", &tsin->tsin_id);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "No tsin_num found\n");
> > +			goto err_clk_disable;
> > +		}
> > +
> > +		/* sanity check value */
> > +		if (tsin->tsin_id > fei->hw_stats.num_ib) {
> > +			dev_err(&pdev->dev,
> > +				"tsin-num %d specified greater than number\n\t"
> > +				"of input block hw in SoC! (%d)",
> > +				tsin->tsin_id, fei->hw_stats.num_ib);
> > +			ret = -EINVAL;
> > +			goto err_clk_disable;
> > +		}
> > +
> > +		tsin->invert_ts_clk = of_property_read_bool(child,
> > +							"invert-ts-clk");
> > +
> > +		tsin->serial_not_parallel = of_property_read_bool(child,
> > +							"serial-not-parallel");
> > +
> > +		tsin->async_not_sync = of_property_read_bool(child,
> > +							"async-not-sync");
> > +
> > +		ret = of_property_read_u32(child, "dvb-card",
> > +					&tsin->dvb_card);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "No dvb-card found\n");
> > +			goto err_clk_disable;
> > +		}
> > +
> > +		i2c_bus = of_parse_phandle(child, "i2c-bus", 0);
> > +		if (!i2c_bus) {
> > +			dev_err(&pdev->dev, "No i2c-bus found\n");
> > +			goto err_clk_disable;
> > +		}
> > +		tsin->i2c_adapter =
> > +			of_find_i2c_adapter_by_node(i2c_bus);
> > +		if (!tsin->i2c_adapter) {
> > +			dev_err(&pdev->dev, "No i2c adapter found\n");
> > +			of_node_put(i2c_bus);
> > +			goto err_clk_disable;
> > +		}
> > +		of_node_put(i2c_bus);
> > +
> > +		tsin->rst_gpio = of_get_named_gpio(child, "rst-gpio", 0);
> > +
> > +		ret = gpio_is_valid(tsin->rst_gpio);
> > +		if (!ret) {
> > +			dev_err(dev,
> > +				"reset gpio for tsin%d not valid (gpio=%d)\n",
> > +				tsin->tsin_id, tsin->rst_gpio);
> > +			goto err_clk_disable;
> > +		}
> > +
> > +		ret = devm_gpio_request_one(dev, tsin->rst_gpio,
> > +					GPIOF_OUT_INIT_LOW, "NIM reset");
> > +		if (ret && ret != -EBUSY) {
> > +			dev_err(dev, "Can't request tsin%d reset gpio\n"
> > +				, fei->channel_data[n]->tsin_id);
> > +			goto err_clk_disable;
> > +		}
> > +
> > +		if (!ret) {
> > +			/* toggle reset lines */
> > +			gpio_direction_output(tsin->rst_gpio, 0);
> > +			msleep(1);
> > +			gpio_direction_output(tsin->rst_gpio, 1);
> > +			msleep(1);
> 
> WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
> 
> msleep(1) doesn't work nice, as it may sleep up to 20 ms, depending on
> how HZ is configured. Is that what you want?

Umm. ok I've updated it in v2 to use: -

usleep_range(3500, 5000);

This code is toggling the reset line to the demod. Checking the stv900 demod datasheet
it should be asserted for at least 3ms. The STV0367 demod doesn't specify any
timings in the datasheet.
> 
> > +		}
> > +
> > +		tsin->demux_mapping = n;
> > +
> > +		dev_dbg(fei->dev,
> > +			"channel=%p n=%d tsin_num=%d, invert-ts-clk=%d\n\t"
> > +			"serial-not-parallel=%d pkt-clk-valid=%d dvb-card=%d\n",
> > +			fei->channel_data[n], n,
> > +			tsin->tsin_id, tsin->invert_ts_clk,
> > +			tsin->serial_not_parallel, tsin->async_not_sync,
> > +			tsin->dvb_card);
> > +
> > +		ret = configure_input_block(fei, fei->channel_data[n]);
> > +
> > +		if (ret) {
> > +			dev_err(fei->dev,
> > +				"configure_input_block tsin=%d failed\n",
> > +				fei->channel_data[n]->tsin_id);
> > +			goto err_unmap;
> > +		}
> > +
> > +		n++;
> > +	}
> > +
> > +	/* Setup timer interrupt */
> > +	init_timer(&fei->timer);
> > +	fei->timer.function = c8sectpfe_timer_interrupt;
> > +	fei->timer.data = (unsigned long)fei;
> > +
> > +	mutex_init(&fei->lock);
> > +
> > +	/* Get the configuration information about the tuners */
> > +	ret = c8sectpfe_tuner_register_frontend(&fei->c8sectpfe[0],
> > +					(void *)fei,
> > +					c8sectpfe_start_feed,
> > +					c8sectpfe_stop_feed);
> > +	if (ret)
> > +		goto err_unmap;
> > +
> > +	/*
> > +	 * STBus target port can access IMEM and DMEM ports
> > +	 * without waiting for CPU
> > +	 */
> > +	writel(0x1, fei->io + DMA_PER_STBUS_SYNC);
> > +
> > +	dev_info(dev, "Boot the memdma SLIM core\n");
> > +	writel(0x1,  fei->io + DMA_CPU_RUN);
> > +
> > +	c8sectpfe_debugfs_init(fei);
> > +
> > +	return 0;
> > +
> > +err_unmap:
> > +	for (n = 0; n < fei->tsin_count; n++) {
> > +		tsin = fei->channel_data[n];
> > +
> > +		if (tsin)
> > +			free_input_block(fei, tsin);
> > +	}
> > +
> > +err_clk_disable:
> > +	/* TODO uncomment when upstream has taken a reference on this clk */
> > +	/*clk_disable_unprepare(fei->c8sectpfeclk);*/
> 
> Hmm... what's the above? Why is it commented?

The STFE clock has a peculiar property in that once it has been enabled,
it can't be turned off, otherwise it causes the stih407/10 SoC to hang.

Currently this platform is waiting for Lees critical clocks series here: -
https://lkml.org/lkml/2015/7/22/311
to be merged, so the STFE clock can be marked as critical. Once that is
in place, this clk_disable can be uncommented.

I consider this a silicon bug which will hopefully be fixed, so
wish to keep the knowledge of this clock bug away from the c8sectpfe driver
and have the driver issue balanced enable/disable calls. However this
can't happen until the above series is merged, as the system will hang
when you remove the module, or if probe fails.

Another temp workaround would be to issue clk_prepare_enable twice, and
uncomment the disables (if you prefer that to what I have currently).

> 
> > +	return ret;
> > +}
> > +
> > +static int c8sectpfe_remove(struct platform_device *pdev)
> > +{
> > +	struct c8sectpfei *fei = platform_get_drvdata(pdev);
> > +	struct channel_info *channel;
> > +	unsigned int n;
> > +
> > +	c8sectpfe_tuner_unregister_frontend(fei->c8sectpfe[0], fei);
> > +
> > +	/*
> > +	 * Now loop through and un-configure each of the InputBlock resources
> > +	 */
> > +	for (n = 0; n < fei->tsin_count; n++) {
> > +		channel = fei->channel_data[n];
> > +		if (channel)
> > +			free_input_block(fei, channel);
> > +	}
> > +
> > +	c8sectpfe_debugfs_exit(fei);
> > +
> > +	dev_info(fei->dev, "Stopping memdma SLIM core\n");
> > +	if (readl(fei->io + DMA_CPU_RUN))
> > +		writel(0x0,  fei->io + DMA_CPU_RUN);
> > +
> > +	/* unclock all internal IP's */
> > +	if (readl(fei->io + SYS_INPUT_CLKEN))
> > +		writel(0, fei->io + SYS_INPUT_CLKEN);
> > +	if (readl(fei->io + SYS_OTHER_CLKEN))
> > +		writel(0, fei->io + SYS_OTHER_CLKEN);
> > +
> > +	/* TODO uncomment when upstream has taken a reference on this clk */
> > +	/*
> > +	if (fei->c8sectpfeclk)
> > +		clk_disable_unprepare(fei->c8sectpfeclk);
> > +	*/
> 
> Hmm... what's the above? Why is it commented?

See comment above about this being a critical clock on stih407/10.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static int load_slim_core_fw(struct c8sectpfei *fei)
> > +{
> > +	const struct firmware *fw = NULL;
> > +	unsigned char *pImem = NULL;
> > +	unsigned char *pDmem = NULL;
> > +	Elf32_Ehdr *ehdr;
> > +	Elf32_Phdr *phdr;
> > +	int err = 0;
> > +	int i;
> > +
> > +	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
> > +
> > +	err = request_firmware(&fw, FIRMWARE_MEMDMA, fei->dev);
> > +	if (err) {
> > +		dev_err(fei->dev, "Failed to load %s, %d.\n",
> > +			FIRMWARE_MEMDMA, err);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Check ELF magic */
> > +	ehdr = (Elf32_Ehdr *)fw->data;
> > +	if (ehdr->e_ident[EI_MAG0] != ELFMAG0 ||
> > +	    ehdr->e_ident[EI_MAG1] != ELFMAG1 ||
> > +	    ehdr->e_ident[EI_MAG2] != ELFMAG2 ||
> > +	    ehdr->e_ident[EI_MAG3] != ELFMAG3) {
> > +		dev_err(fei->dev, "Invalid ELF magic\n");
> > +		err = -ENODEV;
> > +		goto done;
> > +	} else {
> > +		dev_dbg(fei->dev, "Valid ELF header found\n");
> > +	}
> > +
> > +	/* Check program headers are within firmware size */
> > +	if (ehdr->e_phoff + (ehdr->e_phnum * sizeof(Elf32_Phdr)) > fw->size) {
> > +		dev_err(fei->dev, "Program headers outside of firmware file\n");
> > +		err = -ENODEV;
> > +		goto done;
> > +	}
> > +
> > +	pImem = (unsigned char *) fei->io + DMA_MEMDMA_OFFSET + DMA_IMEM_OFFSET;
> > +	pDmem = (unsigned char *) fei->io + DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET;
> > +
> > +	phdr = (Elf32_Phdr *)(fw->data + ehdr->e_phoff);
> > +
> > +	/* go through the available ELF segments */
> > +	for (i = 0; i < ehdr->e_phnum && !err; i++, phdr++) {
> > +		unsigned char *dest;
> > +		int imem = 0;
> > +
> > +		/* Only consider LOAD segments */
> > +		if (phdr->p_type != PT_LOAD)
> > +			continue;
> > +
> > +		/*
> > +		 * Check segment is contained within the fw->data buffer
> > +		 */
> > +		if (phdr->p_offset + phdr->p_filesz > fw->size) {
> > +			dev_err(fei->dev,
> > +				"Segment %d is outside of firmware file\n", i);
> > +			err = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		/*
> > +		 * MEMDMA IMEM has executable flag set, otherwise load
> > +		 * this segment to DMEM.
> > +		 */
> > +
> > +		if (phdr->p_flags & PF_X) {
> > +			dest = pImem;
> > +			imem = 1;
> > +		} else {
> > +			dest = pDmem;
> > +		}
> > +
> > +		/*
> > +		 * The Slim ELF file uses 32-bit word addressing for
> > +		 * load offsets.
> > +		 */
> > +
> > +		dest += (phdr->p_paddr & 0xFFFFF) * sizeof(unsigned int);
> > +
> > +		/*
> > +		 * For DMEM segments copy the segment data from the ELF
> > +		 * file and pad segment with zeroes
> > +		 *
> > +		 * For IMEM segments, the segment contains 24-bit
> > +		 * instructions which must be padded to 32-bit
> > +		 * instructions before being written. The written
> > +		 * segment is padded with NOP instructions.
> > +		 */
> > +
> > +		if (!imem) {
> > +			dev_dbg(fei->dev,
> > +				"Loading DMEM segment %d 0x%08x\n\t"
> > +				"(0x%x bytes) -> 0x%08x (0x%x bytes)\n",
> > +				i, phdr->p_paddr, phdr->p_filesz,
> > +				(unsigned int)dest, phdr->p_memsz);
> > +
> > +			memcpy((void *)dest, (void *)fw->data + phdr->p_offset,
> > +				phdr->p_filesz);
> > +
> > +			memset((void *)dest + phdr->p_filesz, 0,
> > +				phdr->p_memsz - phdr->p_filesz);
> > +		} else {
> > +			const unsigned char *imem_src = fw->data
> > +				+ phdr->p_offset;
> > +			unsigned char *imem_dest = dest;
> > +			int j;
> > +
> > +			dev_dbg(fei->dev,
> > +				"Loading IMEM segment %d 0x%08x\n\t"
> > +				" (0x%x bytes) -> 0x%08x (0x%x bytes)\n", i,
> > +				phdr->p_paddr, phdr->p_filesz,
> > +				(unsigned int)dest,
> > +				phdr->p_memsz + phdr->p_memsz / 3);
> > +
> > +			for (j = 0; j < phdr->p_filesz; j++) {
> > +				*imem_dest = *imem_src;
> > +
> > +				/* Every 3 bytes, add an additional
> > +				 * padding zero in destination */
> > +				if (j % 3 == 2) {
> > +					imem_dest++;
> > +					*imem_dest = 0x00;
> > +				}
> > +				imem_dest++;
> > +				imem_src++;
> > +			}
> > +		}
> > +	}
> > +
> > +done:
> > +	release_firmware(fw);
> > +	return err;
> > +}
> > +
> > +static const struct of_device_id c8sectpfe_match[] = {
> > +	{ .compatible = "st,stih407-c8sectpfe" },
> > +	{ /* sentinel */ },
> > +};
> > +MODULE_DEVICE_TABLE(of, c8sectpfe_match);
> > +
> > +static struct platform_driver c8sectpfe_driver = {
> > +	.driver = {
> > +		.name = "c8sectpfe",
> > +		.of_match_table = of_match_ptr(c8sectpfe_match),
> > +	},
> > +	.probe	= c8sectpfe_probe,
> > +	.remove	= c8sectpfe_remove,
> > +};
> > +
> > +module_platform_driver(c8sectpfe_driver);
> > +
> > +MODULE_AUTHOR("Peter Bennett <peter.bennett@st.com>");
> > +MODULE_AUTHOR("Peter Griffin <peter.griffin@linaro.org>");
> > +MODULE_DESCRIPTION("C8SECTPFE STi DVB Driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/media/tsin/c8sectpfe/c8sectpfe-core.h b/drivers/media/tsin/c8sectpfe/c8sectpfe-core.h
> > new file mode 100644
> > index 0000000..3466303
> > --- /dev/null
> > +++ b/drivers/media/tsin/c8sectpfe/c8sectpfe-core.h
> > @@ -0,0 +1,288 @@
> > +/*
> > + * c8sectpfe-core.h - C8SECTPFE STi DVB driver
> > + *
> > + * Copyright (c) STMicroelectronics 2015
> > + *
> > + *   Author:Peter Bennett <peter.bennett@st.com>
> > + *	    Peter Griffin <peter.griffin@linaro.org>
> > + *
> > + *	This program is free software; you can redistribute it and/or
> > + *	modify it under the terms of the GNU General Public License as
> > + *	published by the Free Software Foundation; either version 2 of
> > + *	the License, or (at your option) any later version.
> > + */
> > +#ifndef _C8SECTPFE_CORE_H_
> > +#define _C8SECTPFE_CORE_H_
> > +
> > +#define C8SECTPFEI_MAXCHANNEL 16
> > +#define C8SECTPFEI_MAXADAPTER 3
> > +
> > +#define C8SECTPFE_MAX_TSIN_CHAN 8
> > +
> > +struct channel_info {
> > +
> > +	int tsin_id;
> > +	bool invert_ts_clk;
> > +	bool serial_not_parallel;
> > +	bool async_not_sync;
> > +	int i2c;
> > +	int dvb_card;
> > +
> > +	int rst_gpio;
> > +
> > +	struct i2c_adapter  *i2c_adapter;
> > +	struct i2c_adapter  *tuner_i2c;
> > +	struct i2c_adapter  *lnb_i2c;
> > +	struct i2c_client   *i2c_client;
> > +	struct dvb_frontend *frontend;
> > +
> > +	struct pinctrl_state *pstate;
> > +
> > +	int demux_mapping;
> > +	int active;
> > +
> > +	void *back_buffer_start;
> > +	void *back_buffer_aligned;
> > +	dma_addr_t back_buffer_busaddr;
> > +
> > +	void *pid_buffer_start;
> > +	void *pid_buffer_aligned;
> > +	dma_addr_t pid_buffer_busaddr;
> > +
> > +	unsigned long  fifo;
> > +
> > +	struct completion idle_completion;
> > +	struct tasklet_struct tsklet;
> > +
> > +	struct c8sectpfei *fei;
> > +	struct c8sectpfe_input_record *irec;
> > +
> > +};
> > +
> > +struct c8sectpfe_hw {
> > +	int num_ib;
> > +	int num_mib;
> > +	int num_swts;
> > +	int num_tsout;
> > +	int num_ccsc;
> > +	int num_ram;
> > +	int num_tp;
> > +};
> > +
> > +struct c8sectpfei {
> > +
> > +	struct device *dev;
> > +	struct pinctrl *pinctrl;
> > +
> > +	struct dentry *root;
> > +	struct debugfs_regset32	*regset;
> > +
> > +	int tsin_count;
> > +
> > +	struct c8sectpfe_hw hw_stats;
> > +
> > +	struct c8sectpfe *c8sectpfe[C8SECTPFEI_MAXADAPTER];
> > +
> > +	int mapping[C8SECTPFEI_MAXCHANNEL];
> > +
> > +	struct mutex lock;
> > +
> > +	struct timer_list timer;	/* timer interrupts for outputs */
> > +
> > +	void __iomem *io;
> > +	void __iomem *sram;
> > +
> > +	unsigned long sram_size;
> > +
> > +	struct channel_info *channel_data[C8SECTPFE_MAX_TSIN_CHAN];
> > +
> > +	struct clk *c8sectpfeclk;
> > +	int nima_rst_gpio;
> > +	int nimb_rst_gpio;
> > +
> > +	int idle_irq;
> > +	int error_irq;
> > +
> > +	int global_feed_count;
> > +
> > +	struct c8sectpfe_input_record *irec;
> > +};
> > +
> > +/* C8SECTPFE SYS Regs list */
> > +
> > +#define SYS_INPUT_ERR_STATUS	0x0
> > +#define SYS_OTHER_ERR_STATUS	0x8
> > +#define SYS_INPUT_ERR_MASK	0x10
> > +#define SYS_OTHER_ERR_MASK	0x18
> > +#define SYS_DMA_ROUTE		0x20
> > +#define SYS_INPUT_CLKEN		0x30
> > +#define IBENABLE_MASK			0x7F
> > +
> > +#define SYS_OTHER_CLKEN		0x38
> > +#define TSDMAENABLE			BIT(1)
> > +#define MEMDMAENABLE			BIT(0)
> > +
> > +#define SYS_CFG_NUM_IB		0x200
> > +#define SYS_CFG_NUM_MIB		0x204
> > +#define SYS_CFG_NUM_SWTS	0x208
> > +#define SYS_CFG_NUM_TSOUT	0x20C
> > +#define SYS_CFG_NUM_CCSC	0x210
> > +#define SYS_CFG_NUM_RAM		0x214
> > +#define SYS_CFG_NUM_TP		0x218
> > +
> > +/* Input Block Regs */
> > +
> > +#define C8SECTPFE_INPUTBLK_OFFSET	0x1000
> > +#define C8SECTPFE_CHANNEL_OFFSET(x)	((x*0x40) + C8SECTPFE_INPUTBLK_OFFSET)
> > +
> > +#define C8SECTPFE_IB_IP_FMT_CFG(x)      (C8SECTPFE_CHANNEL_OFFSET(x) + 0x00)
> > +#define C8SECTPFE_IGNORE_ERR_AT_SOP     BIT(7)
> > +#define C8SECTPFE_IGNORE_ERR_IN_PKT     BIT(6)
> > +#define C8SECTPFE_IGNORE_ERR_IN_BYTE    BIT(5)
> > +#define C8SECTPFE_INVERT_TSCLK          BIT(4)
> > +#define C8SECTPFE_ALIGN_BYTE_SOP        BIT(3)
> > +#define C8SECTPFE_ASYNC_NOT_SYNC        BIT(2)
> > +#define C8SECTPFE_BYTE_ENDIANNESS_MSB    BIT(1)
> > +#define C8SECTPFE_SERIAL_NOT_PARALLEL   BIT(0)
> > +
> > +#define C8SECTPFE_IB_SYNCLCKDRP_CFG(x)   (C8SECTPFE_CHANNEL_OFFSET(x) + 0x04)
> > +#define C8SECTPFE_SYNC(x)                (x & 0xf)
> > +#define C8SECTPFE_DROP(x)                ((x<<4) & 0xf)
> > +#define C8SECTPFE_TOKEN(x)               ((x<<8) & 0xff00)
> > +#define C8SECTPFE_SLDENDIANNESS          BIT(16)
> > +
> > +#define C8SECTPFE_IB_TAGBYTES_CFG(x)     (C8SECTPFE_CHANNEL_OFFSET(x) + 0x08)
> > +#define C8SECTPFE_TAG_HEADER(x)          (x << 16)
> > +#define C8SECTPFE_TAG_COUNTER(x)         ((x<<1) & 0x7fff)
> > +#define C8SECTPFE_TAG_ENABLE             BIT(0)
> > +
> > +#define C8SECTPFE_IB_PID_SET(x)          (C8SECTPFE_CHANNEL_OFFSET(x) + 0x0C)
> > +#define C8SECTPFE_PID_OFFSET(x)          (x & 0x3f)
> > +#define C8SECTPFE_PID_NUMBITS(x)         ((x << 6) & 0xfff)
> > +#define C8SECTPFE_PID_ENABLE             BIT(31)
> > +
> > +#define C8SECTPFE_IB_PKT_LEN(x)          (C8SECTPFE_CHANNEL_OFFSET(x) + 0x10)
> > +
> > +#define C8SECTPFE_IB_BUFF_STRT(x)        (C8SECTPFE_CHANNEL_OFFSET(x) + 0x14)
> > +#define C8SECTPFE_IB_BUFF_END(x)         (C8SECTPFE_CHANNEL_OFFSET(x) + 0x18)
> > +#define C8SECTPFE_IB_READ_PNT(x)         (C8SECTPFE_CHANNEL_OFFSET(x) + 0x1C)
> > +#define C8SECTPFE_IB_WRT_PNT(x)          (C8SECTPFE_CHANNEL_OFFSET(x) + 0x20)
> > +
> > +#define C8SECTPFE_IB_PRI_THRLD(x)        (C8SECTPFE_CHANNEL_OFFSET(x) + 0x24)
> > +#define C8SECTPFE_PRI_VALUE(x)           (x & 0x7fffff)
> > +#define C8SECTPFE_PRI_LOWPRI(x)          ((x & 0xf) << 24)
> > +#define C8SECTPFE_PRI_HIGHPRI(x)         ((x & 0xf) << 28)
> > +
> > +#define C8SECTPFE_IB_STAT(x)             (C8SECTPFE_CHANNEL_OFFSET(x) + 0x28)
> > +#define C8SECTPFE_STAT_FIFO_OVERFLOW(x)  (x & 0x1)
> > +#define C8SECTPFE_STAT_BUFFER_OVERFLOW(x) (x & 0x2)
> > +#define C8SECTPFE_STAT_OUTOFORDERRP(x)   (x & 0x4)
> > +#define C8SECTPFE_STAT_PID_OVERFLOW(x)   (x & 0x8)
> > +#define C8SECTPFE_STAT_PKT_OVERFLOW(x)   (x & 0x10)
> > +#define C8SECTPFE_STAT_ERROR_PACKETS(x)  ((x >> 8) & 0xf)
> > +#define C8SECTPFE_STAT_SHORT_PACKETS(x)  ((x >> 12) & 0xf)
> > +
> > +#define C8SECTPFE_IB_MASK(x)             (C8SECTPFE_CHANNEL_OFFSET(x) + 0x2C)
> > +#define C8SECTPFE_MASK_FIFO_OVERFLOW     BIT(0)
> > +#define C8SECTPFE_MASK_BUFFER_OVERFLOW   BIT(1)
> > +#define C8SECTPFE_MASK_OUTOFORDERRP(x)   BIT(2)
> > +#define C8SECTPFE_MASK_PID_OVERFLOW(x)   BIT(3)
> > +#define C8SECTPFE_MASK_PKT_OVERFLOW(x)   BIT(4)
> > +#define C8SECTPFE_MASK_ERROR_PACKETS(x)  ((x & 0xf) << 8)
> > +#define C8SECTPFE_MASK_SHORT_PACKETS(x)  ((x & 0xf) >> 12)
> > +
> > +#define C8SECTPFE_IB_SYS(x)              (C8SECTPFE_CHANNEL_OFFSET(x) + 0x30)
> > +#define C8SECTPFE_SYS_RESET              BIT(1)
> > +#define C8SECTPFE_SYS_ENABLE             BIT(0)
> > +
> > +/*
> > + * Ponter record data structure required for each input block
> > + * see Table 82 on page 167
> > + */
> > +
> > +struct tpentry {
> > +	/* The following entries are bus addresses for memdma */
> > +	unsigned long dma_busbase;
> > +	unsigned long dma_bustop;
> > +	unsigned long dma_bus_wp;
> > +	unsigned long dma_bus_rp;
> > +};
> > +
> > +struct c8sectpfe_input_record {
> > +	unsigned long dma_membase; /* Internal sram base address */
> > +	unsigned long dma_memtop;  /* Internal sram top address */
> > +
> > +	/*
> > +	 * TS packet size, including tag bytes added by input block,
> > +	 * rounded up to the next multiple of 8 bytes. The packet size,
> > +	 * including any tagging bytes and rounded up to the nearest
> > +	 * multiple of 8 bytes must be less than 255 bytes.
> > +	 */
> > +	unsigned long dma_ts_pktsize;
> > +	unsigned long tp_enable;
> > +	struct tpentry ptr_data[1];
> > +};
> > +
> > +#define DMA_MEMDMA_OFFSET	0x4000
> > +#define DMA_IMEM_OFFSET		0x0
> > +#define DMA_DMEM_OFFSET		0x4000
> > +#define DMA_CPU			0x8000
> > +#define DMA_PER_OFFSET		0xb000
> > +
> > +/* XP70 Slim core regs */
> > +#define DMA_CPU_ID	(DMA_MEMDMA_OFFSET + DMA_CPU + 0x0)
> > +#define DMA_CPU_VCR	(DMA_MEMDMA_OFFSET + DMA_CPU + 0x4)
> > +#define DMA_CPU_RUN	(DMA_MEMDMA_OFFSET + DMA_CPU + 0x8)
> > +#define DMA_CPU_CLOCKGATE	(DMA_MEMDMA_OFFSET + DMA_CPU + 0xc)
> > +#define DMA_CPU_PC	(DMA_MEMDMA_OFFSET + DMA_CPU + 0x20)
> > +
> > +/* Enable Interrupt for a IB */
> > +#define DMA_PER_TPn_DREQ_MASK	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xd00)
> > +/* Ack interrupt by setting corresponding bit */
> > +#define DMA_PER_TPn_DACK_SET	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xd80)
> > +#define DMA_PER_TPn_DREQ	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xe00)
> > +#define DMA_PER_TPn_DACK	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xe80)
> > +#define DMA_PER_DREQ_MODE	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xf80)
> > +#define DMA_PER_STBUS_SYNC	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xf88)
> > +#define DMA_PER_STBUS_ACCESS	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xf8c)
> > +#define DMA_PER_STBUS_ADDRESS	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xf90)
> > +#define DMA_PER_IDLE_INT	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfa8)
> > +#define DMA_PER_PRIORITY	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfac)
> > +#define DMA_PER_MAX_OPCODE	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfb0)
> > +#define DMA_PER_MAX_CHUNK	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfb4)
> > +#define DMA_PER_PAGE_SIZE	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfbc)
> > +#define DMA_PER_MBOX_STATUS	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfc0)
> > +#define DMA_PER_MBOX_SET	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfc8)
> > +#define DMA_PER_MBOX_CLEAR	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfd0)
> > +#define DMA_PER_MBOX_MASK	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfd8)
> > +#define DMA_PER_INJECT_PKT_SRC	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfe0)
> > +#define DMA_PER_INJECT_PKT_DEST	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfe4)
> > +#define DMA_PER_INJECT_PKT_ADDR	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfe8)
> > +#define DMA_PER_INJECT_PKT	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xfec)
> > +#define DMA_PER_PAT_PTR_INIT	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xff0)
> > +#define DMA_PER_PAT_PTR		(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xff4)
> > +#define DMA_PER_SLEEP_MASK	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xff8)
> > +#define DMA_PER_SLEEP_COUNTER	(DMA_MEMDMA_OFFSET + DMA_PER_OFFSET + 0xffc)
> > +/* #define DMA_RF_CPUREGn	DMA_RFBASEADDR n=0 to 15) slim regsa */
> > +
> > +/* The following are from DMA_DMEM_BaseAddress */
> > +#define DMA_FIRMWARE_VERSION	(DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET + 0x0)
> > +#define DMA_PTRREC_BASE		(DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET + 0x4)
> > +#define DMA_PTRREC_INPUT_OFFSET	(DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET + 0x8)
> > +#define DMA_ERRREC_BASE		(DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET + 0xc)
> > +#define DMA_ERROR_RECORD(n)	((n*4) + DMA_ERRREC_BASE + 0x4)
> > +#define DMA_IDLE_REQ		(DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET + 0x10)
> > +#define IDLEREQ			BIT(31)
> > +
> > +#define DMA_FIRMWARE_CONFIG	(DMA_MEMDMA_OFFSET + DMA_DMEM_OFFSET + 0x14)
> > +
> > +/* Regs for PID Filter */
> > +
> > +#define PIDF_OFFSET		0x2800
> > +#define PIDF_BASE(n)		((n*4) + PIDF_OFFSET)
> > +#define PIDF_LEAK_ENABLE	(PIDF_OFFSET + 0x100)
> > +#define PIDF_LEAK_STATUS	(PIDF_OFFSET + 0x108)
> > +#define PIDF_LEAK_COUNT_RESET	(PIDF_OFFSET + 0x110)
> > +#define PIDF_LEAK_COUNTER	(PIDF_OFFSET + 0x114)
> > +
> > +#endif /* _C8SECTPFE_CORE_H_ */

regards,

Peter.
