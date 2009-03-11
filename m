Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48408 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCKTpN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 15:45:13 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903091023540.3992@axis700.grange>
	<87sklms9ni.fsf@free.fr>
	<Pine.LNX.4.64.0903092310510.5857@axis700.grange>
	<87r615hwzb.fsf@free.fr>
	<Pine.LNX.4.64.0903111313320.4818@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 11 Mar 2009 20:45:00 +0100
In-Reply-To: <Pine.LNX.4.64.0903111313320.4818@axis700.grange> (Guennadi Liakhovetski's message of "Wed\, 11 Mar 2009 19\:25\:53 +0100 \(CET\)")
Message-ID: <87k56vyhc3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Tue, 10 Mar 2009, Robert Jarzmik wrote:
>
>> The DMA transfers in pxa_camera showed some weaknesses in
>> multiple queued buffers context :
>>  - poll/select problem
>>    The order between list pcdev->capture and DMA chain was
>>    not the same. This creates a discrepancy between video
>>    buffers marked as "done" by the IRQ handler, and the
>>    really finished video buffer.
>
> Double-check. I still do not see how the order can be swapped. But don't 
> worry, this doesn't diminish the value of your work, I'm just trying to be 
> fair to the existing driver:-)
Yes :) I thought I had sent a mail to apologize for the remaining comment ... I
have fully removed the order issue, I only left the poll/select issue.
And yes, it's not fair to the previous code, you're perfectly right.

>> @@ -324,7 +324,7 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
>>   * Prepares the pxa dma descriptors to transfer one camera channel.
>>   * Beware sg_first and sg_first_ofs are both input and output parameters.
>>   *
>> - * Returns 0
>> + * Returns 0 or -ENOMEM si no coherent memory is available
>
> s/si/if/ s'il vous plait:-)
Argh. I was sure I had amended that ... urg.

> Nice, how about putting this in Documentation/video4linux/pxa_camera.txt 
> and a reference to it in the comment?
Yes, it will make the code lighter, won't it ? I'll need a bit of help to
correct my english here ...

>> +	for (i = 0; i < pcdev->channels; i++) {
>> +		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
>> +		pcdev->sg_tail[i]->ddadr = DDADR_STOP;

> This function is now called "live" with running DMA, and you first append 
> the chain, and only then terminate it... It should be ok because it is 
> done with switched off IRQs, and DMA must be still at tail - 1 to 
> automatically continue onto the appended chain, so, you should have enough 
> time in 100% of cases, still it would look better to first terminate the 
> chain and then append it.
Correct. I'll invert the 2 assignments.

>
>> +static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
>> +{
>> +	unsigned long cicr0, cifr;
>> +
>> +	dev_dbg(pcdev->dev, "%s\n", __func__);
>
> <quote>
> I originally had a "reset the FIFOs" comment here, wouldn't hurt to add it 
> now too.
> </quote>
Yes. I re-added it. I added also your "Enable End-Of-Frame Interrupt" back.

>> @@ -524,81 +659,19 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
>>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>  	struct pxa_camera_dev *pcdev = ici->priv;
>>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
>> -	struct pxa_buffer *active;
>>  	unsigned long flags;
>> -	int i;
>>  
>> -	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>> -		vb, vb->baddr, vb->bsize);
>> -	spin_lock_irqsave(&pcdev->lock, flags);
>> +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d active=%p\n", __func__,
>> +		vb, vb->baddr, vb->bsize, pcdev->active);
>>  
>> +	spin_lock_irqsave(&pcdev->lock, flags);
>>  	list_add_tail(&vb->queue, &pcdev->capture);
>
> I can understand adding an empty line between dev_dbg() and 
> spin_lock_irqsave(), but I do not understand why you removed one between 
> spin_lock_irqsave() and list_add_tail().
My bad. I had a mdelay() around to test the corner case :) I'll amend that.

Cheers.

--
Robert
