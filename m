Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:62790 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab1BCKKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 05:10:04 -0500
Date: Thu, 3 Feb 2011 11:09:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
In-Reply-To: <1296476549-10421-1-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1102031104090.21719@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
 <1296476549-10421-1-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Anatolij

On Mon, 31 Jan 2011, Anatolij Gustschin wrote:

I'm afraid there seems to be a problem with your patch. I have no idea 
what is causing it, but I'm just observing some wrong behaviour, that is 
not there without it. Namely, I added a debug print to the IDMAC interrupt 
handler

 	curbuf	= idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
 	err	= idmac_read_ipureg(&ipu_data, IPU_INT_STAT_4);
 
+	printk(KERN_DEBUG "%s(): IDMAC irq %d, buf %d, current %d\n", __func__,
+	       irq, ichan->active_buffer, (curbuf >> chan_id) & 1);
 
 	if (err & (1 << chan_id)) {
 		idmac_write_ipureg(&ipu_data, 1 << chan_id, IPU_INT_STAT_4);

and without your patch I see buffer numbers correctly toggling all the 
time like

idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 1
idmac_interrupt(): IDMAC irq 177, buf 1, current 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 1
idmac_interrupt(): IDMAC irq 177, buf 1, current 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 1
...

Yes, the first interrupt is different, that's where I'm dropping / 
postponing it. With your patch only N (equal to the number of buffers 
used, I think) first interrupts toggle, then always only one buffer is 
used:

idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 1, current 1
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
idmac_interrupt(): IDMAC irq 177, buf 0, current 0
...

Verified with both capture.c and mplayer. Could you, please, verify 
whether you get the same behaviour and what the problem could be?

Thanks
Guennadi

> Currently when two or more buffers are queued by the camera driver
> and so the double buffering is enabled in the idmac, we lose one
> frame comming from CSI since the reporting of arrival of the first
> frame is deferred by the DMAIC_7_EOF interrupt handler and reporting
> of the arrival of the last frame is not done at all. So when requesting
> N frames from the image sensor we actually receive N - 1 frames in
> user space.
> 
> The reason for this behaviour is that the DMAIC_7_EOF interrupt
> handler misleadingly assumes that the CUR_BUF flag is pointing to the
> buffer used by the IDMAC. Actually it is not the case since the
> CUR_BUF flag will be flipped by the FSU when the FSU is sending the
> <TASK>_NEW_FRM_RDY signal when new frame data is delivered by the CSI.
> When sending this singal, FSU updates the DMA_CUR_BUF and the
> DMA_BUFx_RDY flags: the DMA_CUR_BUF is flipped, the DMA_BUFx_RDY
> is cleared, indicating that the frame data is beeing written by
> the IDMAC to the pointed buffer. DMA_BUFx_RDY is supposed to be
> set to the ready state again by the MCU, when it has handled the
> received data. DMAIC_7_CUR_BUF flag won't be flipped here by the
> IPU, so waiting for this event in the EOF interrupt handler is wrong.
> Actually there is no spurious interrupt as described in the comments,
> this is the valid DMAIC_7_EOF interrupt indicating reception of the
> frame from CSI.
> 
> The patch removes code that waits for flipping of the DMAIC_7_CUR_BUF
> flag in the DMAIC_7_EOF interrupt handler. As the comment in the
> current code denotes, this waiting doesn't help anyway. As a result
> of this removal the reporting of the first arrived frame is not
> deferred to the time of arrival of the next frame and the drivers
> software flag 'ichan->active_buffer' is in sync with DMAIC_7_CUR_BUF
> flag, so the reception of all requested frames works.
> 
> This has been verified on the hardware which is triggering the
> image sensor by the programmable state machine, allowing to
> obtain exact number of frames. On this hardware we do not tolerate
> losing frames.
> 
> This patch also removes resetting the DMA_BUFx_RDY flags of
> all channels in ipu_disable_channel() since transfers on other
> DMA channels might be triggered by other running tasks and the
> buffers should always be ready for data sending or reception.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
> v2:
>     Revise the commit message to provide more and correct
>     information about the observed problem and proposed fix
> 
>  drivers/dma/ipu/ipu_idmac.c |   50 -------------------------------------------
>  1 files changed, 0 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index cb26ee9..c1a125e 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1145,29 +1145,6 @@ static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel *ichan,
>  	reg = idmac_read_icreg(ipu, IDMAC_CHA_EN);
>  	idmac_write_icreg(ipu, reg & ~chan_mask, IDMAC_CHA_EN);
>  
> -	/*
> -	 * Problem (observed with channel DMAIC_7): after enabling the channel
> -	 * and initialising buffers, there comes an interrupt with current still
> -	 * pointing at buffer 0, whereas it should use buffer 0 first and only
> -	 * generate an interrupt when it is done, then current should already
> -	 * point to buffer 1. This spurious interrupt also comes on channel
> -	 * DMASDC_0. With DMAIC_7 normally, is we just leave the ISR after the
> -	 * first interrupt, there comes the second with current correctly
> -	 * pointing to buffer 1 this time. But sometimes this second interrupt
> -	 * doesn't come and the channel hangs. Clearing BUFx_RDY when disabling
> -	 * the channel seems to prevent the channel from hanging, but it doesn't
> -	 * prevent the spurious interrupt. This might also be unsafe. Think
> -	 * about the IDMAC controller trying to switch to a buffer, when we
> -	 * clear the ready bit, and re-enable it a moment later.
> -	 */
> -	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY);
> -	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF0_RDY);
> -	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF0_RDY);
> -
> -	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY);
> -	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF1_RDY);
> -	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF1_RDY);
> -
>  	spin_unlock_irqrestore(&ipu->lock, flags);
>  
>  	return 0;
> @@ -1246,33 +1223,6 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
>  
>  	/* Other interrupts do not interfere with this channel */
>  	spin_lock(&ichan->lock);
> -	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
> -		     ((curbuf >> chan_id) & 1) == ichan->active_buffer &&
> -		     !list_is_last(ichan->queue.next, &ichan->queue))) {
> -		int i = 100;
> -
> -		/* This doesn't help. See comment in ipu_disable_channel() */
> -		while (--i) {
> -			curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
> -			if (((curbuf >> chan_id) & 1) != ichan->active_buffer)
> -				break;
> -			cpu_relax();
> -		}
> -
> -		if (!i) {
> -			spin_unlock(&ichan->lock);
> -			dev_dbg(dev,
> -				"IRQ on active buffer on channel %x, active "
> -				"%d, ready %x, %x, current %x!\n", chan_id,
> -				ichan->active_buffer, ready0, ready1, curbuf);
> -			return IRQ_NONE;
> -		} else
> -			dev_dbg(dev,
> -				"Buffer deactivated on channel %x, active "
> -				"%d, ready %x, %x, current %x, rest %d!\n", chan_id,
> -				ichan->active_buffer, ready0, ready1, curbuf, i);
> -	}
> -
>  	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
>  		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
>  		     )) {
> -- 
> 1.7.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
