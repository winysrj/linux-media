Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:57571 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbFURSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 13:18:20 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH 4/4] media: pxa_camera: conversion to dmaengine
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
	<1426980085-12281-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1506201424090.31977@axis700.grange>
Date: Sun, 21 Jun 2015 19:16:09 +0200
In-Reply-To: <Pine.LNX.4.64.1506201424090.31977@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 21 Jun 2015 18:02:14 +0200 (CEST)")
Message-ID: <87si9l7zja.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> On Sun, 22 Mar 2015, Robert Jarzmik wrote:
>
>> From: Robert Jarzmik <robert.jarzmik@intel.com>
>> 
>> Convert pxa_camera to dmaengine. This removes all DMA registers
>> manipulation in favor of the more generic dmaengine API.
>> 
>> The functional level should be the same as before. The biggest change is
>> in the videobuf_sg_splice() function, which splits a videobuf-dma into
>
> As also commented below, I'm not sure "splice" is a good word for 
> splitting.
Ok. I'm all ears for your best candidate :)

>> several scatterlists for 3 planes captures (Y, U, V).
>
> "Several" is actually exactly 3, isn't it?
Yup, it's 3, definitely. I can amend the commit message accordingly.

>> +static struct scatterlist *videobuf_sg_splice(struct scatterlist *sglist,
>> +					      int sglen, int offset, int size,
>> +					      int *new_sg_len)
>>  {
>> -	int i, offset, dma_len, xfer_len;
>> -	struct scatterlist *sg;
>> +	struct scatterlist *sg0, *sg, *sg_first = NULL;
>> +	int i, dma_len, dropped_xfer_len, dropped_remain, remain;
>> +	int nfirst = -1, nfirst_offset = 0, xfer_len;
>>  
>> -	offset = sg_first_ofs;
>> +	*new_sg_len = 0;
>> +	dropped_remain = offset;
>> +	remain = size;
>>  	for_each_sg(sglist, sg, sglen, i) {
>
> Ok, after something-that-felt-like-hours of looking at this code, I think, 
> I understand now, that first you calculate what sg elements have been used 
> for offset bytes, which is either 0, or the size of the Y plain, or size 
> of Y + U plains.
You can say it that way. I'd say that I calculate how to "malloc and fill" a new
scatter-gather to represent [offset, offset + size [ interval of the original
sglist.

>
>>  		dma_len = sg_dma_len(sg);
>> -
>>  		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
>> -		xfer_len = roundup(min(dma_len - offset, size), 8);
>> +		dropped_xfer_len = roundup(min(dma_len, dropped_remain), 8);
>> +		if (dropped_remain)
>> +			dropped_remain -= dropped_xfer_len;
>> +		xfer_len = dma_len - dropped_xfer_len;
>> +
>> +		if ((nfirst < 0) && (xfer_len > 0)) {
>
> Superfluous parentheses
Got it.

>
>> +			sg_first = sg;
>> +			nfirst = i;
>> +			nfirst_offset = dropped_xfer_len;
>> +		}
>> +		if (xfer_len > 0) {
>> +			*new_sg_len = *new_sg_len + 1;
>
> make it
> +			(*new_sg_len)++;
Got it.

>>  static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
>>  			       enum pxa_camera_active_dma act_dma);
>>  
>> @@ -343,93 +379,59 @@ static void pxa_camera_dma_irq_v(void *data)
>>   * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
>>   * @cibr: camera Receive Buffer Register
>>   * @size: bytes to transfer
>> - * @sg_first: first element of sg_list
>> - * @sg_first_ofs: offset in first element of sg_list
>> + * @offset: offset in videobuffer of the first byte to transfer
>>   *
>>   * Prepares the pxa dma descriptors to transfer one camera channel.
>> - * Beware sg_first and sg_first_ofs are both input and output parameters.
>>   *
>> - * Returns 0 or -ENOMEM if no coherent memory is available
>> + * Returns 0 if success or -ENOMEM if no memory is available
>>   */
>>  static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>>  				struct pxa_buffer *buf,
>>  				struct videobuf_dmabuf *dma, int channel,
>> -				int cibr, int size,
>> -				struct scatterlist **sg_first, int *sg_first_ofs)
>> +				int cibr, int size, int offset)
>>  {
>
> Hmm, ok, can you, please, explain, why you have to change this so much? 
> IIUC, the functionality, that you're implementing now is rather similar to 
> the present one - you split the global videobuf SG list into 3 SG lists 
> for YUV formats. Of course, details are different, you don't use 
> pxa_dma_desc and all the low-level values directly, you prepare a standard 
> SG list for your dmaengine driver. But the splitting is the same, isn't 
> it?
The overall splitting is the same, yes : split one global SG list into 3 SG
lists.

> And the current one seems rather good to me, because it preserves and 
> re-uses partially consumed pointers instead of recalculating them every 
> time, like you do it in your new version. What's the reason for that? Is 
> the current version buggy or the current approach unsuitable for your new 
> version?

Let's say "unsuitable", or to be more correct, let's say that I didn't found any
better idea yet. As I find that piece of code a bit complicated too, I'll tell
you what was my need for doing it, and maybe you'll/we'll come up with a better
idea.

The previous version had the good fortune to rely on a _single_ scatter-gather
list. Only the DMA descriptors list was computed to be 3 lists
(dma[channe].sg_cpu[0..n]).

The new version must have 3 separated SG lists, each one fed to a different
dmaengine channel.

So the big goal here is to compute the 3 SGs lists, which was not done
previously. That's the purpose of all that, and I couldn't find any easier
method. Would a "new_sg = sg_extract(sglist, offset, len)" have existed, this code
would have been a breeze ...

>> +	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
>> +	struct scatterlist *sg = NULL;
>
> Superfluous initialisation
Got it.

>> +	int sglen;
>> +	struct dma_async_tx_descriptor *tx;
>> +
>> +	sg = videobuf_sg_splice(dma->sglist, dma->sglen, offset, size, &sglen);
>
> Isn't it rather a cut, than a splice function?
Yeah, actually I meant "slice", but wrote "splice" ...

>> @@ -550,11 +548,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>>  	return 0;
>>  
>>  fail_v:
>> -	dma_free_coherent(dev, buf->dmas[1].sg_size,
>> -			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
>>  fail_u:
>> -	dma_free_coherent(dev, buf->dmas[0].sg_size,
>> -			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
>>  fail:
>
> You don't need 3 exit labels any more.
Yes, I still need "fail:" I think, the other 2 will be done in next iteration.

>> @@ -741,50 +723,41 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>>   *
>>   * Context: should only be called within the dma irq handler
>>   */
>> -static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
>> +static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
>> +				       dma_cookie_t last_submitted,
>> +				       dma_cookie_t last_issued)
>>  {
>> -	int i, is_dma_stopped = 1;
>> +	int is_dma_stopped;
>>  
>> -	for (i = 0; i < pcdev->channels; i++)
>> -		if (DDADR(pcdev->dma_chans[i]) != DDADR_STOP)
>> -			is_dma_stopped = 0;
>> +	is_dma_stopped = last_submitted > last_issued;
>
> IIUC, actually last_issued should be == last_submitted, right?
No.
last_issued == last_submitted is only true if the last descriptor "hot-chaining"
succeeded. If it didn't succeed, and the dma stopped, last_submitted >
last_issued, for as long as dma_async_issue_pending() is not called.

> And your dmaengine driver's .device_tx_status() method returns the last
> "really" submitted cookie,
If you mean the last tx cookie for which tx->submit() was called, then yes.

> so, if that situation occurs, that you submit a transfer when DMA is off, your
> last_buf->cookie[chan] will contain it, as returned by dmaengine_submit(), but
> .device_tx_status() will not return it?
Here I'm a bit lost, but I feel the first hypothesis "last_issued ==
last_submitted" blurs the discussion, so I'll let you first read my comment
about it, and then you'll tell me if you feel there is still a concern.

> Then, this comparison "last_submitted
> > last_issued" isn't a good test, cookies can overrun. Maybe just check for
> unequal? Otherwise I think you'd have to find a way to use
> dma_async_is_complete().
Yes, agreed, I'll try unequal, I just need a couple of days to think about it if
another corner case doesn't arise.

>> +	if (camera_status & overrun &&
>> +	    last_status != DMA_COMPLETE) {
>
> Isn't the compiler suggesting parentheses here?
Not mine at least. As the "&&" has the lowest precedence, my understanding is
that the expression is correct. But I can add parenthesis for maintainability.

>> @@ -1012,10 +996,7 @@ static void pxa_camera_clock_stop(struct soc_camera_host *ici)
>>  	__raw_writel(0x3ff, pcdev->base + CICR0);
>>  
>>  	/* Stop DMA engine */
>> -	DCSR(pcdev->dma_chans[0]) = 0;
>> -	DCSR(pcdev->dma_chans[1]) = 0;
>> -	DCSR(pcdev->dma_chans[2]) = 0;
>> -
>> +	pxa_dma_stop_channels(pcdev);
>
> Isn't calling pxa_dma_stop_channels() in pxa_camera_stop_capture() enough? 
> .clock_stop() should only be called after streaming has been stopped. But 
> it has been here since forever, so...

I don't think so, because the buffers are not released, ie. acked. The effect of
pxa_dma_stop_channels() is to call dmaengine_terminate_all(). But this last call
is only entitled to free the dma txs if they are acked, which happens when
free_buffer() is called.

So in pxa_camera_stop_capture(), as the buffers were not released, the dmaengine
txs were not released as well. In pxa_camera_clock_stop(), I think they have
been released, so dmaengine_terminate_all() will actually free the resources of
these txs, which it couldn't do sooner.

>> -	DRCMR(68) = pcdev->dma_chans[0] | DRCMR_MAPVLD;
>> -	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
>> -	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
>> -
>
> Will resume still work after this? Because of dmaengine resume?
I must admit I haven't tried. And I fear I have not implemented suspend/resume
in pxa_dma dmaengine driver. I'd say it's a dmaengine problem now, and that this
chunk is correct. Yet your point is correct, pxa_dma driver has to handle
suspend/resume.

>>  	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
>>  	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
>>  	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
>> @@ -1738,8 +1715,11 @@ static int pxa_camera_probe(struct platform_device *pdev)
>>  	struct pxa_camera_dev *pcdev;
>>  	struct resource *res;
>>  	void __iomem *base;
>> +	struct dma_slave_config config;
>
> I would do
>
> +	struct dma_slave_config config = {
> +		.direction = DMA_DEV_TO_MEM,
> +		.src_maxburst = 8,
> +	};
>
> and have all other fields initialised to 0 automatically.
Euh and what would do the "to 0 automatically" initialization ? It's an
automatic variable, not a static one.

>> +	dma_cap_zero(mask);
>> +	dma_cap_set(DMA_SLAVE, mask);
>
> Also DMA_PRIVATE?
Most certainly.

So thanks for the very detailed review, and I think we'll iterate a couple of
mails to converge. I especially have high hopes about the "slice" thing, two
minds are better than a single coffee broken one :)

Cheers.

-- 
Robert
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
