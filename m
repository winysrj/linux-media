Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4436 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaIWGKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 02:10:44 -0400
Message-ID: <54210EC5.5080606@xs4all.nl>
Date: Tue, 23 Sep 2014 08:10:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "chen.fang@freescale.com" <chen.fang@freescale.com>,
	"m.chehab@samsung.com" <m.chehab@samsung.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
CC: Shengchao Guo <Shawn.Guo@freescale.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
References: <1410326937-31140-1-git-send-email-chen.fang@freescale.com> <540FF70E.9050203@xs4all.nl> <566c6b8349ba4c2ead8f76ff04b52e65@BY2PR03MB556.namprd03.prod.outlook.com> <540FFBF1.6060702@xs4all.nl> <ba228f83093b46d9a6e594a037236198@BY2PR03MB556.namprd03.prod.outlook.com>
In-Reply-To: <ba228f83093b46d9a6e594a037236198@BY2PR03MB556.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fancy Fang,

I do have a few comments:

1) One reason why the switch to vm_iomap_memory() was made originally was that
that function did a bunch of sanity checks. Since this patch moves back to
remap_pfn_range() those sanity checks are lost and should be reinstated.

2) You need Marek's Ack as well since he understands the memory code much
better than I do.

3) There are efforts underway to make a modern i.mx6 video driver based on
vb2 and all the other modern V4L2 APIs, wouldn't it be much better if freescale
jumps on board and starts working on that code as well? See e.g. this mail
thread: http://www.spinics.net/lists/linux-media/msg79078.html

I assume this refers to the same hardware. The official freescale driver
for that hardware is horrendous.

If you are writing code for unrelated hardware, then you should move over to
vb2 yourself. videobuf should not be used anymore for new drivers.

4) I still do not entirely understand the control flow and I will have to take
another look. I'll see if I can do that tomorrow.

Regards,

	Hans

On 09/23/2014 05:11 AM, chen.fang@freescale.com wrote:
> Hans,
> Do you have any more comment on this patch?
> 
> Best regards,
> Fancy Fang
> 
> -----Original Message-----
> From: Fang Chen-B47543 
> Sent: Wednesday, September 10, 2014 3:29 PM
> To: 'Hans Verkuil'; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
> Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Marek Szyprowski
> Subject: RE: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
> 
> On the Freescale imx6 platform which belongs to ARM architecture. The driver is our local v4l2 output driver which is not upstream yet unfortunately.
> 
> Best regards,
> Fancy Fang
> 
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Wednesday, September 10, 2014 3:21 PM
> To: Fang Chen-B47543; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
> Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Marek Szyprowski
> Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
> 
> On 09/10/14 09:14, chen.fang@freescale.com wrote:
>> It is not a theoretically issue, it is a real case that the mapping failed issue happens in 3.14.y kernel but not happens in previous 3.10.y kernel.
>> So I need your confirmation on it.
> 
> With which driver does this happen? On which architecture?
> 
> Regards,
> 
> 	Hans
> 
>>
>> Thanks.
>>
>> Best regards,
>> Fancy Fang
>>
>> -----Original Message-----
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> Sent: Wednesday, September 10, 2014 3:01 PM
>> To: Fang Chen-B47543; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
>> Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; 
>> linux-kernel@vger.kernel.org; Marek Szyprowski
>> Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
>>
>> On 09/10/14 07:28, Fancy Fang wrote:
>>> When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core 
>>> will assign the corresponding offset to the 'boff' field of the 
>>> videobuf_buffer for each requested buffer sequentially. Later, user 
>>> may call mmap() to map one or all of the buffers with the 'offset'
>>> parameter which is equal to its 'boff' value. Obviously, the 'offset'
>>> value is only used to find the matched buffer instead of to be the 
>>> real offset from the buffer's physical start address as used by 
>>> vm_iomap_memory(). So, in some case that if the offset is not zero,
>>> vm_iomap_memory() will fail.
>>
>> Is this just a fix for something that can fail theoretically, or do you actually have a case where this happens? I am very reluctant to make any changes to videobuf. Drivers should all migrate to vb2.
>>
>> I have CC-ed Marek as well since he knows a lot more about this stuff than I do.
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
>>> ---
>>>  drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> index bf80f0f..8bd9889 100644
>>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> @@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>>>  	/* Try to remap memory */
>>>  	size = vma->vm_end - vma->vm_start;
>>>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>>> -	retval = vm_iomap_memory(vma, mem->dma_handle, size);
>>> +	retval = remap_pfn_range(vma, vma->vm_start,
>>> +				 mem->dma_handle >> PAGE_SHIFT,
>>> +				 size, vma->vm_page_prot);
>>>  	if (retval) {
>>>  		dev_err(q->dev, "mmap: remap failed with error %d. ",
>>>  			retval);
>>>
>>
> 

