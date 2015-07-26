Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:39459 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbbGZMg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2015 08:36:59 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] media: pxa_camera: conversion to dmaengine
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
	<1436120872-24484-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1507121859030.32193@axis700.grange>
	<87y4iljn6y.fsf@belgarion.home> <87a8utgjfc.fsf@belgarion.home>
	<Pine.LNX.4.64.1507261235250.32754@axis700.grange>
Date: Sun, 26 Jul 2015 14:33:38 +0200
In-Reply-To: <Pine.LNX.4.64.1507261235250.32754@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 26 Jul 2015 13:36:58 +0200 (CEST)")
Message-ID: <878ua3drod.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> On Sun, 19 Jul 2015, Robert Jarzmik wrote:
> In principle, yes, it doesn't look all that horrible to me. You first 
> split the global SG list into up to 3 per-channel ones, then you 
> initialise your channels, what's wrong with that? Just have to add some 
> polish to it here and there... This is a preliminary review, I'll do a 
> proper one, once you fix these and send me anew version, not based on top 
> of patch 4/4.
Ok.
>> +struct sg_splitter {
>> +	struct scatterlist *in_sg0;
>> +	int nents;
>> +	off_t skip_sg0;
>> +	size_t len_last_sg;
>> +	struct scatterlist *out_sg;
>> +};
>> +
>> +static struct sg_splitter *
>> +sg_calculate_split(struct scatterlist *in, off_t skip,
>
> You don't need "skip," you only call this function once with skip == 0.
In the specific pxa_camera case, that's true.

But I made this code for the broader case, where :
 - skip != 0 is possible
 - the sum of sizes is smaller that total sg span

My goal is after this submission to try to move this code to the more generic
lib/sglist.c, hence the genericity.

> Besides I usually prefer all the keywords before the function name, the 
> function name, the opening parenthesis and at least the first argument on 
> the same line. So far pxa_camera.c follows this, let's keep it this way. 
> It makes grepping for functions easier. And no, I don't care about 80 
> chars...
As you wish.

>> +	int i, nents;
>> +	size_t size, len;
>> +	struct sg_splitter *splitters, *curr;
>> +	struct scatterlist *sg;
>> +
>> +	splitters = kcalloc(nb_splits, sizeof(*splitters), gfp_mask);
>
> This is an array of at most 3 elements, 20 bytes each. I'd just allocate 
> it on stack in the calling function and avoid this kcalloc(). Then you can 
> make this function return the total number of sg elements, which is 
> actually at most original number of elements + 2, right? Then you can use 
> that total number to allocate all new sg elements in one go to reduce the 
> number of allocations.

You think pxa_camera specific, I think sglist generic. I think I should try to
submit the generic sglist code first, if I get turned down, specialize the code
for pxa_camera, don't you think ?

> I would put these in initialisation:
>
> +	int i, nents = 0;
> +	size_t size = sizes[0], len;
Ok.
>> +	size = *sizes;
>> +	curr = splitters;
>> +	for_each_sg(in, sg, sg_nents(in), i) {
>> +		if (skip > sg_dma_len(sg)) {
>> +			skip -= sg_dma_len(sg);
>> +			continue;
>> +		}
>> +		len = min_t(size_t, size, sg_dma_len(sg) - skip);
>> +		if (!curr->in_sg0) {
>> +			curr->in_sg0 = sg;
>> +			curr->skip_sg0 = sg_dma_len(sg) - len;
>>  		}
>> -		if (xfer_len > 0) {
>> -			(*new_sg_len)++;
>> -			remain -= xfer_len;
>> +		size -= len;
>> +		nents++;
>> +		if (!size) {
>> +			curr->nents = nents;
>> +			curr->len_last_sg = len;
>> +			nents = 0;
>> +			size = *(++sizes);
>> +
>> +			if (!--nb_splits)
>> +				break;
>
> This break won't be needed, because:
It is needed (in the generic case) if I choose to split in 3 4k pages an sg of
4 pages. In that case, without this break, the for_each_sg() loop will continue,
and curr will be out of bounds.
>
>> +
>> +			if (len < curr->len_last_sg) {
>
> How is this possible? You just did
>
> +			curr->len_last_sg = len;
Ah yes, it's indeed wrong.
This test was to take care of the case when an sg is split as :
 - partly as the last sg entry of splitters[n]->in_sg0
 - partly as the first sg entry of splitter[n+1]->in_sg0
I must rework that condition to :
 - if (len < dma_sg_len(sg))

> In general I like pointer arithmetics and use it always when I need a 
> _pointer_, but in such cases I'd normally just write splitters[1].in_sg0, 
> don't you think that would look better? Ditto everywhere below.
Ok.

>
>> +				(splitters + 1)->skip_sg0 = 0;
>> +			}
>> +			curr++;
>>  		}
>> -		if (remain <= 0)
>> -			break;
>>  	}
>> -	WARN_ON(nfirst >= sglen);
>>  
>> -	sg0 = kmalloc_array(*new_sg_len, sizeof(struct scatterlist),
>> -			    GFP_KERNEL);
>> -	if (!sg0)
>> -		return NULL;
>> +	return splitters;
>> +}
>>  
>> -	remain = size;
>> -	for_each_sg(sg_first, sg, *new_sg_len, i) {
>> -		dma_len = sg_dma_len(sg);
>> -		sg0[i] = *sg;
>> +	for (i = 0; i < nb_splits; i++) {
>
> Maybe
>
> +	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
Yes.

>
>> +		split = splitters + i;
>> +		in_sg = split->in_sg0;
>> +		out_sg = split->out_sg;
>> +		out[i] = out_sg;
>> +		for (j = 0; j < split->nents; j++) {
>
> +		for (j = 0; j < split->nents; j++, out_sg++) {
Yes.

>> @@ -458,6 +500,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
>>  	int ret;
>>  	int size_y, size_u = 0, size_v = 0;
>> +	size_t sizes[3];
>>  
>>  	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>>  		vb, vb->baddr, vb->bsize);
>> @@ -513,6 +556,16 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>>  			size_y = size;
>>  		}
>>  
>> +		sizes[0] = size_y;
>> +		sizes[1] = size_u;
>> +		sizes[2] = size_v;
>> +		ret = sg_split(dma->sglist, pcdev->channels, sizes, buf->sg,
>> +			       GFP_KERNEL);
>> +		if (ret) {
>
> In most places pxa_camera.c checks for (ret < 0), but no longer in all 
> anyway.
Oh you're right, and I like things to remain homogenous, so I'll fix that.

Cheers.

-- 
Robert
