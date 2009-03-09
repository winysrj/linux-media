Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59227 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZCITOA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 15:14:00 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903080115090.6783@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 09 Mar 2009 20:13:46 +0100
In-Reply-To: <Pine.LNX.4.64.0903080115090.6783@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 9 Mar 2009 11\:45\:08 +0100 \(CET\)")
Message-ID: <874oy2tsph.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
>> index e3e6b29..54df071 100644
>> --- a/drivers/media/video/pxa_camera.c
>> +++ b/drivers/media/video/pxa_camera.c
>> @@ -242,14 +242,13 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
>>  	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
>>  
>>  	/* planar capture requires Y, U and V buffers to be page aligned */
>> -	if (pcdev->channels == 3) {
>> -		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
>> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
>> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
>> -	} else {
>> -		*size = icd->width * icd->height *
>> -			((icd->current_fmt->depth + 7) >> 3);
>> -	}
>> +	if (pcdev->channels == 3)
>> +		*size = roundup(icd->width * icd->height, 8) /* Y pages */
>> +			+ roundup(icd->width * icd->height / 2, 8) /* U pages */
>> +			+ roundup(icd->width * icd->height / 2, 8); /* V pages */
>> +	else
>> +		*size = roundup(icd->width * icd->height *
>> +				((icd->current_fmt->depth + 7) >> 3), 8);
>>  
>>  	if (0 == *count)
>>  		*count = 32;
>
> Ok, this one will change I presume - new alignment calculations and 
> line-breaking. In fact, if you adjust width and height earlier in set_fmt, 
> maybe you'll just remove any rounding here completely.
Helas, not fully.
The problem is with passthrough and rgb formats, where I don't enforce
width/height. In the newest form of the patch I have this :
	if (pcdev->channels == 3)
		*size = icd->width * icd->height * 2;
	else
		*size = roundup(icd->width * icd->height *
				((icd->current_fmt->depth + 7) >> 3), 8);

>
>> @@ -289,19 +288,63 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>>  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>>  }
>>  
>> +static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
>> +			       int sg_first_ofs, int size)
>> +{
>> +	int i, offset, dma_len, xfer_len;
>> +	struct scatterlist *sg;
>> +
>> +	offset = sg_first_ofs;
>> +	for_each_sg(sglist, sg, sglen, i) {
>> +		dma_len = sg_dma_len(sg);
>> +
>> +		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
>> +		xfer_len = roundup(min(dma_len - offset, size), 8);
>
> Ok, let's see. dma_len is PAGE_SIZE. offset is for Y-plane 0, for further 
> planes it will be aligned after we recalculate width and height. size will 
> be aligned too, so, roundup will disappear, right?

No, I don't think so.

Consider the case of a RGB565 image which size is 223*33 = 7359 bytes. This
makes a transfer of 4096 bytes and another of 3263 bytes.

But the QIF fifo will give 4096 + 3264 bytes (the last one beeing 0), and this
last byte has to be read from the fifo. As I understand it, the QIF fifo works
with 8 bytes permutations, and that why it's giving always a multiple of 8
bytes. Please, cross-check PXA developper manual, paragraph 27.4.4.1 to see if
you understand the same as I did.

So the roundup() is to be kept :(

> You might want to just 
> just add a test for these. The calculation itself gives size >= xfer_len
>
>> +
>> +		size = max(0, size - xfer_len);
>
> So, max is useless here, just "size -= xfer_len."
And so the max() still hold I think.

>> +		size = max(0, size - xfer_len);
>
> Same here for roundup() and max().
Yes, same discussion.

>>  
>> -	pxa_dma->sg_cpu[sglen - 1].ddadr = DDADR_STOP;
>> -	pxa_dma->sg_cpu[sglen - 1].dcmd |= DCMD_ENDIRQEN;
>> +	pxa_dma->sg_cpu[sglen].ddadr = DDADR_STOP;
>> +	pxa_dma->sg_cpu[sglen].dcmd  = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_ENDIRQEN;
>
> Why are you now always using the n+1'th element? Even if it is right, it 
> rather belongs to the patch "2/4," not "1/4," right? In your earlier email 
> you wrote:
>
>>  - in the former pxa_videobuf_queue(), when a buffer was queued while another
>>  was already active, a dummy descriptor was added, and then the new buffer was
>>  chained with the actively running buffer. See code below :
>> 
>> -                       } else {
>> -                               buf_dma->sg_cpu[nents].ddadr =
>> -                                       DDADR(pcdev->dma_chans[i]);
>> -                       }
>> -
>> -                       /* The next descriptor is the dummy descriptor */
>> -                       DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
>> -                               sizeof(struct pxa_dma_desc);
>> 
>>    The fix is in the code refactoring, as now the buffer is always added at the
>>    tail of the queue through pxa_dma_add_tail_buf().
>
> I don't understand, what this is fixing. It would make a nice 
> simplification, if it worked, but see my review to patch "2/4."
Let's discuss it in patch 2/4 review, yes.

>> +
>> +	*sg_first_ofs = xfer_len;
>> +	/*
>> +	 * Handle 1 special case :
>> +	 *  - if we finish the DMA transfer in the last 7 bytes of a RAM page
>> +	 *    then we return the sg element pointing on the next page
>> +	 */
>> +	if (*sg_first_ofs >= dma_len) {
>> +		*sg_first_ofs -= dma_len;
>> +		*sg_first = sg_next(sg);
>> +	} else {
>> +		*sg_first = sg;
>> +	}
>
> As we will not be rounding up any more, this special case shouldn't be 
> needed either, right?
Same discussion as before. But here, as sg_first and sf_first_ofs only make
sense for 3 planes output, and the rounding takes care of the corner cases, this
part will be simplified, yes.

>
>>  
>>  	return 0;
>>  }
>> @@ -342,9 +409,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>>  	struct pxa_camera_dev *pcdev = ici->priv;
>>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
>>  	int ret;
>> -	int sglen_y,  sglen_yu = 0, sglen_u = 0, sglen_v = 0;
>> -	int size_y, size_u = 0, size_v = 0;
>> -
>> +	int size_y = 0, size_u = 0, size_v = 0;
>
> Isn't size_y always initialised?
Yes, I'll remove that.

Thanks for the review, let's keep that going on :)

Cheers.

--
Robert
