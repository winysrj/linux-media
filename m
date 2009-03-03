Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:55766 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZCCSsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 13:48:39 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id E1C42786E60
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2009 19:48:32 +0100 (CET)
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: ospite@studenti.unina.it, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	robert.jarzmik@free.fr
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
References: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903030929160.5059@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 03 Mar 2009 19:47:41 +0100
In-Reply-To: <Pine.LNX.4.64.0903030929160.5059@axis700.grange> (Guennadi Liakhovetski's message of "Tue\, 3 Mar 2009 16\:49\:51 +0100 \(CET\)")
Message-ID: <87zlg2e94i.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> (moved to the new v4l list)
Wow, I missed a couple of mail I see ... :) I really should subscribe to that
one ...

> On Mon, 2 Mar 2009, Robert Jarzmik wrote:
>
>> The DMA transfers in pxa_camera showed some weaknesses in
>> multiple queued buffers context :
>>  - poll/select problem
>>    The order between list pcdev->capture and DMA chain was
>>    not the same. This creates a discrepancy between video
>>    buffers marked as "done" by the IRQ handler, and the
>>    really finished video buffer.
>
> Could you please describe where and how the order could get wrong?
>
>>  - multiple buffers DMA starting
>>    When multiple buffers were queued, the DMA channels were
>
> You mean multiple scatter-gather elements?
>
>>    always started right away. This is not optimal, as a
>>    special case appears when the first EOM was not yet
>>    reached, and the DMA channels were prematurely started.
>
> What is EOM? I see End of Line, End of Frame, End of Active Video, End of 
> Transfer. I only see End of Message on the PXA MSL interface, which 
> doesn't seem to be related. TBH, I do not quite understand what you mean 
> here. What do we have to wait for before starting DMA channels?
>
> Ok, after working through the whole patch, I think, you meant starting DMA 
> in the middle of a frame and thus getting an incomplete frame, which you 
> changed using the capture (not DMA) End of Frame interrupt, right?
Right. And EOM should have been EOF (End of Frame as you guessed).

>
>>  - YUV planar formats hole
>>    All planes were PAGE aligned (ie. 4096 bytes
>>    aligned). This is not consistent with YUV422 format,
>>    which requires Y, U and V planes glued together.
>>    The new implementation forces the alignement on 8 bytes
>>    (DMA requirement), which is almost always the case
>>    (granted by width x height being a multiple of 8).
>

> Then we shall adjust frame sizes to produce a multiple of 8.

Well, not necessarily, at the moment you can use a size of 111x111 and it is
working (even if that kind of size is a bit crazy :))
This point is at your choice. If you tell me you want to force it to multiples
of 8, I'll go for it. It will _really_ simplify the whole roundup() gymnastic.

>
>>  - Maintainability
>>    DMA code was a bit ofsuscated. Rationalize the code to be
>
> s/ofsuscated/obfuscated/:-)
Yes.

>>    easily maintainable by anyone.
>
> Nice. Well, you'd really do me a favour, if you could split it at least 
> into two patches: maintainability improvements (split out functions, 
> whatever else), and then fixes. Splitting off planar alignment fix should 
> also be pretty straightforward, especially worth splitting off, when you 
> add size rounding up. Mike suggested another split, you may decide which 
> one you hold for more meaningful, or maybe both.

Maintainability and fixes are intermixed, as the whole DMA usage was
rewritten. It's not that easy. Splitting off planar alignment is easy, but fixes
come from the new architecture after the rewrite.

Even if I try, I don't think I'll succeed. One example for demonstration :
 - in the former pxa_videobuf_queue(), when a buffer was queued while another
 was already active, a dummy descriptor was added, and then the new buffer was
 chained with the actively running buffer. See code below :

-                       } else {
-                               buf_dma->sg_cpu[nents].ddadr =
-                                       DDADR(pcdev->dma_chans[i]);
-                       }
-
-                       /* The next descriptor is the dummy descriptor */
-                       DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
-                               sizeof(struct pxa_dma_desc);

   The fix is in the code refactoring, as now the buffer is always added at the
   tail of the queue through pxa_dma_add_tail_buf().

>> This patch attemps to address these issues.
>> 
>> The test cases include tests in both YUV422 and RGB565 :
>>  - a picture of size 111 x 111 (cross RAM pages example)
>>  - a picture of size 1023 x 4 in (under 1 RAM page)
>>  - a picture of size 1024 x 4 in (exactly 1 RAM page)
>>  - a picture of size 1025 x 4 in (over 1 RAM page)
>>  - a picture of size 1280 x 1024 (many RAM pages)
>
> What exactly was the problem before your patch? How do I reproduce it? I 
> guess, it should also be visible with monochrome or Bayer formats.
The problem can be reproduced with the capture_example.c taken from v4l2 test
utilities. I can reproduce it from time to time if I force my cpufreq to the
lowest value (powersave), and queue 4 buffers of a size 1280x1024.

Sometimes, the process just "stalls" on a "select timeout".

> makes me wonder why not just write
>
> 	x = u +		/* need u */
> 	    v +		/* and v */
> 	    w;		/* and w */
Ah, didn't wan't to break authorship ... Will amend.

>> +static int calculate_dma_sglen(struct scatterlist *sg, int sg_first,
>> +			       int sg_first_ofs, int size)
>> +{
>> +	int sg_i, offset;
>> +	int dma_len, xfer_len;
>> +
>> +	offset = sg_first_ofs;
>> +	for (sg_i = sg_first; size > 0; sg_i++) {
>> +		dma_len = sg_dma_len(&sg[sg_i]);
>
> I think, you should not use direct access into an sg-list. Please, pass 
> not an index into the array, but a pointer to an sg-element, and use 
> sg_next() to walk to the next one. This way instead of passing beginning 
> of the list and index, you just pass a pointer to the current element.
OK. Will amend.

> You should be fine with your size calculations, but I would still test 
> against dma->sglen to make sure we don't access beyond the array.
With a BUG_ON() for example ?

>> +
>> +		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
>> +		xfer_len = roundup(min(dma_len - offset, size), 8);
>
> I think it is too late to round up here. You should adjust window sizes in 
> pxa_camera_set_fmt() so, that your Y, U, and V buffer sizes are a multiple 
> of 8, at least for the V4L2_PIX_FMT_YUV422P case.
See comment above. It's your choice.

> ...and pxa_camera_set_crop() is just plain broken (when capture is 
> running). You might want to fix that just as well. However, after all 
> problems I had with S_CROP in mx3_camera, I'm asking myself if it makes 
> any sense at all to crop during a running capture to a different window 
> size?...
Don't think so. I'd rather enforce all buffer out of danger before allowing a
change in image format.

>> + * Returns 0
>
> ... or error, e.g., -ENOMEM
Argh. Will amend.

>> +	for (i = 0; size > 0; i++) {
>> +		sg_i = *sg_first + i;
>> +		dma_len = sg_dma_len(&sg[sg_i]);
>
> Same here - please, fiix sg-list indexing. Yes, I see it was like this 
> before, but I think it was wrong.
OK as before.

>
>>  
>>  		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
>> -		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]);
>> +		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]) + offset;
>
> ...and more
>
>>  
>>  		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
>> -		xfer_len = (min(dma_len, size) + 7) & ~7;
>> +		xfer_len = roundup(min(dma_len - offset, size), 8);
>
> Again, too late to align.
See comment above. It's your choice.

>>  
>>  		pxa_dma->sg_cpu[i].dcmd =
>> -			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
>> -		size -= dma_len;
>> +			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len
>> +			| ((i == 0) ? DCMD_STARTIRQEN : 0);
>
> Why do you need the start interrupt? You don't seem to be doing anything 
> useful in it. If you preserve it, can you please change this and other 
> occurrences of
For debugging only. I could remove it, but it really helps for debug purpose. 

>
> 	x = y
> 		| z;
>
> to
>
> 	x = y |
> 		z;
>
> just to make consistent with the rest of the driver.
May I do it the other way (change all other occurences) ? I was corrected on
other drivers to use the first form as the coding style, so can I reformat
pxa_camera to abide by this rule ?

>> +	/*
>> +	 * Handle 2 special cases :
>> +	 *  - if we finish the DMA transfer in the middle of a RAM page
>> +	 *  - if we finish the DMA transfer in the last 7 bytes of a RAM page
>> +	 */
>> +	if (*sg_first_ofs != 0)
>> +		*sg_first -= 1;
>> +	if (*sg_first_ofs >= dma_len) {
>> +		*sg_first_ofs -= dma_len;
>> +		*sg_first += 1;
>> +	}
>
> This whole calculation looks suspicious. But I won't verify it now, 
> because it anyway will change as you switch to sg-pointers instead of 
> indices, but, please, keep in mind to double-check this.
OK. It was checked by all the tests passed before (remember all the test cases
in the commit message), but it will have to go through another volley when I'll
switch to sg-pointers.

> Why this change? I don't see any need for it.
Because of the "for" loops which decrement the remaining size (in
calculate_dma_sglen). The condition "size > 0" as only sense if size is
signed. Moreover, signed int is enough for the QIF capabilities, isn't it ?
Well, after sg-pointers, maybe that will change too ...

>>  		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
>>  
>>  		ret = videobuf_iolock(vq, vb, NULL);
>>  		if (ret)
>>  			goto fail;
>>  
>> -		if (pcdev->channels == 3) {
>> -			/* FIXME the calculations should be more precise */
>> -			sglen_y = dma->sglen / 2;
>> -			sglen_u = sglen_v = dma->sglen / 4 + 1;
>> -			sglen_yu = sglen_y + sglen_u;
>> +		switch (pcdev->channels) {
>> +		case 1:
>> +			size_y = size;
>> +			break;
>> +		case 3:
>>  			size_y = size / 2;
>>  			size_u = size_v = size / 4;
>> -		} else {
>> -			sglen_y = dma->sglen;
>> -			size_y = size;
>> +			break;
>>  		}
>
> Here you changed an "if" to a "switch," later on you do an "if (channels 
> == 3)" again. Please, choose one. I think, since we only have two 
> possibilities, and since it has already been implemented that way, we can 
> leave it with "if"s.
OK. Will amend.
>
>>  
>>  		/* init DMA for Y channel */
>> -		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, sglen_y,
>> -					   0, 0x28, size_y);
>> -
>> +		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
>> +					   &sg_next, &next_ofs);
>
> These calls will change parameters
Are you thinking of the "sg-pointers" impact here ?

>> +/**
>> + * pxa_camera_start_capture - start video capturing
>> + * @pcdev: camera device
>> + *
>> + * Launch capturing. DMA channels should not be active yet. They should get
>> + * activated at the end of frame interrupt, to capture only whole frames, and
>> + * never begin the capture of a partial frame.
>
> I like this!
Thanks. I didn't have courage enough to put it everywhere ...

>> -	if (!active) {
>> -		unsigned long cifr, cicr0;
>> +	pxa_dma_stop_channels(pcdev);
>>  
>> -		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
>> -		__raw_writel(cifr, pcdev->base + CIFR);
>> +	pxa_dma_add_tail_buf(pcdev, buf);
>
> Do you really have to call pxa_dma_stop_channels() if (!active)? Looks 
> like after your modifications DMA is not running yet anyway.
Not really. I didn't want to put another condition, and stopping stopped
channels ... doesn't do anything.
The other way would duplicate the call to pxa_dma_add_tail_buf() in both the
(!active) and (active) parts of the if statement, so I prefer the code to be
that way. I could add a comment, though ...

>> +	if (!active)
>
> You don't need "active" now at all, just use pcdev->active directly.
True. Will amend.

>> -	DCSR(channel) = status | DCSR_ENDINTR;
>> +	DCSR(channel) = status | DCSR_STARTINTR | DCSR_ENDINTR;
>
> Again - I don't think you need the STARTINTR.
Same as above.

> Overall - very nice! Now, I think, it also would be easier for you, if you 
> split it into several patches. We can then review small patches again, 
> then probably some of them won't need a third revision (counting this as 
> the first,) if any will need one, it shoule be easier for you to update a 
> couple of small patches rather then the whole big one. And easier for 
> everyone to compare what has changed.
As I said, I'll try to split a bit. But the fixed and DMA refactoring cannot be
split up as stated above.

Cheers.

--
Robert
