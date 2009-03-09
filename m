Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:41190 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZCIUux (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 16:50:53 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903091023540.3992@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 09 Mar 2009 21:50:41 +0100
In-Reply-To: <Pine.LNX.4.64.0903091023540.3992@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 9 Mar 2009 12\:35\:13 +0100 \(CET\)")
Message-ID: <87sklms9ni.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> + * Returns 0 or -ENOMEM si no coherent memory is available
>
> Let's stay with English for now:-) s/si/if/
Oups ... sorry ... the froggish touch is back :)

>
>>   */
>>  static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>>  				struct pxa_buffer *buf,
>> @@ -369,7 +369,8 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>>  		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
>>  		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
>>  		pxa_dma->sg_cpu[i].dcmd =
>> -			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
>> +			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len
>> +			| ((i == 0) ? DCMD_STARTIRQEN : 0);
>
> If DCMD_STARTIRQEN is still for debugging only, maybe put it under
>
> #ifdef DEBUG
> 		if (!i)
> 			pxa_dma->sg_cpu[i].dcmd |= DCMD_STARTIRQEN;
> #endif
OK. Will amend.
>> +static void pxa_dma_update_sg_tail(struct pxa_camera_dev *pcdev,
>> +				   struct pxa_buffer *buf)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < pcdev->channels; i++) {
>> +		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
>> +		pcdev->sg_tail[i]->ddadr = DDADR_STOP;
>
> Do I understand it right, assuming capture is running, i.e., active != 
> NULL:
>
> before your patch
>
> sg_tail points to the last real DMA descriptor
> the last real DMA descriptor has DDADR_STOP
> on queuing of the next buffer we
>  1. stop DMA
>  2. link the last real descriptor to the new first descriptor
>  3. allocate an additional dummy descriptor, fill it with DMA engine's 
> 	current state and use it to
>  4. re-start DMA
Yes, but you forget :
   5. link the last new buffer descriptor (the called dummy buffer) to the
   running chain.

I see it that way, after former pxa_video_queue() :

 +----------+-----------+------------+
 | First vb | Second vb | Third vb | |
 +----^-----+-----------+-----------|+
      |                             |      +----------------+
      |                             +----> | New vb | dummy |
      |                                    +------------|---+
      |                                                 |
      +-------------------------------------------------+

This is my understanding. The DMA is restarted at the dummy descriptor, which
re-reads the current DMA descriptor (is that correct, if 16 bytes were already
transfered ?), then comes back to the head of DMA chain.
Then first vb is finished, then second and third, and then new vb is re-filled.

Would you comment to see where I'm wrong please ?

> after your patch
>
> sg_tail points to the additional DMA descriptor
Which additional ? Do you mean "the last DMA descriptor of the last video buffer
queued which never transfers any data" ? (which is what I point it at, yes)

> the last valid DMA descriptor points to the additional descriptor
> the additional descriptor has DDADR_STOP
Yes.

> on queuing of the next buffer
>  1. stop DMA
>  2. the additional dummy descriptor at the tail of the current chain is 
> 	reconfigured to point to the new start
Yes.

>  3. pxa_dma_start_channels() is called, which drops the current partial 
> 	transfer and re-starts the frame?...
Yes, that is wrong.
The trick is, if I restart the DMA channel where it was, I remember having my
"select stalled" message.

I see it that way, after new pxa_video_queue() :

 +----------+-----------+------------+
 | First vb | Second vb | Third vb | |
 +----------+-----------+-----------|+
 ^                                  |      +----------------+
 |                                  +----> | New vb | dummy |
  \restart                                 +----------------+

> If I am right, this doesn't seem right. If I am wrong, please, explain and 
> add explanatory comments, so, the next one (or the same one 2 months 
> later) does not have to spend time trying to figure out.
Well, you've got a point. There is something to dig here. By experiment, it is
working. But I will search why, as my patch does restart the frame :(

I will investigate :
 - if stopping the DMA chain and restarting in the middle of a DMA transfer
   (ie. in the middle of the 4096 bytes, on byte 2040 for example) does work.
 - how my DMA chain does work.

As a matter of fact, before this patch, I had a pxa_dma_restart_channels()
called in pxa_videobuf_queue(), which just "restarted" the DMA channel without
touching the DADR() register. I will search why this wasn't working.

>> +static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
>> +{
>> +	unsigned long cicr0, cifr;
>> +
>> +	dev_dbg(pcdev->dev, "%s\n", __func__);
>
> I originally had a "reset the FIFOs" comment here, wouldn't hurt to add it 
> now too.
Sorry, I'll reput it there. Will amend.

>
>> +	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
>> +	__raw_writel(cifr, pcdev->base + CIFR);
>> +
>> +	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB | CISR_IFO_0
>> +		| CISR_IFO_1 | CISR_IFO_2;
>
> CISR_* flags have nothing to do with the CICR register.
Right, good catch. I'll remove all the CISR* stuff. I must have been confused,
it's the CIFR_RESET_F which was meant there (fifo flush).

> It is nice to synchronise on a frame start, but you're relying on being 
> "fast," i.e., on servicing the End of Frame interrupt between the two 
> frames and having enough time to configure DMA. With smaller frames with 
> short inter-frame times this can be difficult, I think. But, well, that's 
> the best we can do, I guess. And yes, I know, I'm already doing this in 
> the overrun case.
Yep. But you're right. I'll expand my testcases to 32x32 frames, and bombard my
PXA with interrupts, at low cpufreq. We'll see what happens then :)

>> @@ -666,19 +698,23 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>>  	unsigned long flags;
>>  	u32 status, camera_status, overrun;
>>  	struct videobuf_buffer *vb;
>> -	unsigned long cifr, cicr0;
>>  
>>  	spin_lock_irqsave(&pcdev->lock, flags);
>>  
>>  	status = DCSR(channel);
>> -	DCSR(channel) = status | DCSR_ENDINTR;
>> +	DCSR(channel) = status | DCSR_STARTINTR | DCSR_ENDINTR;
>
> Now as I look at it, actually, this is racy. If for whatever reason we 
> entered here without ENDINTR set, so status & DCSR_ENDINTR == 0, then it 
> got immediately set and we clear it, thus we lose it. I think, there's no 
> reason here not to use the standard
>
> 	irq_reason = read(IRQ_REASON_REG);
> 	write(irq_reason, IRQ_REASON_REG);
Right. It is racy. Will amend.

OK, I have work to do on that one. Would please just check my understanding of
the chain (the superb ascii-art I draw :)), so that we could speak on the same
ground. That will help me understand better.

Cheers.

--
Robert
