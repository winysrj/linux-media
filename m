Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:32020 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbG3Vmf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 17:42:35 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] lib: scatterlist: add sg splitting function
References: <1438282935-3448-1-git-send-email-robert.jarzmik@free.fr>
	<20150730203138.GT7557@n2100.arm.linux.org.uk>
Date: Thu, 30 Jul 2015 23:38:53 +0200
Message-ID: <87wpxhmiky.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Thu, Jul 30, 2015 at 09:02:15PM +0200, Robert Jarzmik wrote:
> Hmm.
>
> What happens if...
>
> 	n = dma_map_sg(dev, sg, nents, dir);
>
> where n < nents (which can happen if you have an IOMMU and it coalesces
> the entries)?
That's something I have not thought of.

My first guess is that if the input scatter list is mapped and entries are
coallesced, then :
 - there are sg entries where the sg_dma_length(sg) is the result of
   coallescing, ie. the sum of sg->length, sg_next(sg)->length, ...
 - the entries sg_next(sg)->length and next coallesced have sg_dma_length() of
   0, or are transformed to sg_chain entries, I don't really know.

I must check how this code resists to these cases, and cross-check in
drivers/iommu if my understanding of coallescing is correct.

> This also means that sg_dma_len(sg) may not be equal to sg->length, nor
> may sg_dma_address(sg) correspond with sg_phys() etc.
Yes, I understand that I think, the length being a consequence of coallescing,
the address being a consequence of a dma bus master offsetting physical addresses.

>> +	for_each_sg(in, sg, sg_nents(in), i) {
>> +		if (skip > sg_dma_len(sg)) {
>> +			skip -= sg_dma_len(sg);
>
> sg_dma_len() is undefined before the scatterlist is mapped.  Above, you
> say that dma map should not happen on both the initial or the subsequently
> split scatterlists, but this requires the original to be DMA-mapped.
Ah that means that the mapping has to be done on the original list the way the
current code is designed. That's actually how this code is exercised in the next
version of pxa_camera.c I'm working on.

It's a bit a pity, I thought I had managed a generic splitter to both mapped and
unmapped scatterlists ... I was obviously wrong.

> Also, as I mention above, the number of scatterlist entries to process
> is given by 'n' above, not 'nents'.
Ah yes. So if I add the requirement that the input scatterlist is mapped, I must
also add a parameter to sg_split() with the number of entries.

> I'm not sure that there's any requirement for dma_map_sg() to mark the new end
> of the scatterlist as that'd result in information loss when subsequently
> unmapping.
If it appears that the only viable way is having the input scatterlist mapped,
this sentence is not applicable, right ?

>> +	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
>> +		in_sg = split->in_sg0;
>> +		out_sg = split->out_sg;
>> +		out[i] = out_sg;
>> +		for (j = 0; j < split->nents; j++, out_sg++) {
>> +			*out_sg = *in_sg;
>> +			if (!j) {
>> +				out_sg->offset = split->skip_sg0;
>> +				sg_dma_len(out_sg) -= split->skip_sg0;
>> +			} else {
>> +				out_sg->offset = 0;
>> +			}
>> +			in_sg = sg_next(in_sg);
>> +		}
>> +		sg_dma_len(--out_sg) = split->len_last_sg;
>
> Hmm, I'm not sure this is good enough.  If we're talking about a mapped
> scatterlist, this won't touch the value returned by sg_dma_address() at
> all, which will end up being incorrect.
Indeed. That means that in all of my tests, I had probably skip_sg0 == 0,
because otherwise the result would be incorrect.

>> If this is the state of the code in the media subsystem, then it's very
>> buggy, and in need of fixing.

This is the state of the code I submitted to a single media driver,
pxa_camera. It's a consequence of the pxa shift to dmaengine. And I thought it
would be worth exposing it to more users ... or not, that will depend on this
RFC.

And in the specific case of this pxa driver, it kinda works by luck so far. I
felt it when submitting it here.

Thanks for the review Russell, I have enough to think of and good inputs to
submit an RFCv2 in a couple of days. Even if this patch is dropped in the end,
because it's either too restrictive to force to map the input scatterlist, or
because it won't be that usefull, I will have a cleaner code in pxa_camera :)

Cheers.

-- 
Robert
