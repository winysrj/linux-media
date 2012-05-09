Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20958 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2EIJ67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 05:58:59 -0400
Date: Wed, 09 May 2012 11:58:53 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
In-reply-to: <4FAA12C7.8020307@gmail.com>
To: Subash Patel <subashrp@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Message-id: <4FAA3FDD.1040400@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
 <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com>
 <4FA7DE61.7000705@gmail.com> <4675433.ieio0xx0Y0@avalon>
 <4FA9005F.6020901@gmail.com> <4FAA12C7.8020307@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Subash,
Could you post the code of vb2_dc_pages_to_sgt with all printk in it.
It will help us avoid guessing where and what is debugged in the log.

Moreover, I found a line 'size=4294836224' in the log.
It means that size is equal to -131072 (!?!) or there are some invalid
conversions in printk.

Are you suze that you do not pass size = 0 as the function argument?

Notice that earlier versions of dmabuf-for-vb2 patches has offset2
argument instead of size. It was the offset at the end of the buffer.
In (I guess) 95% of cases this offset was 0.

Could you provide only function arguments that causes the failure?
I mean pages array + size (I assume that offset is zero for your test).

Having the arguments we could reproduce that bug.

Regards,
Tomasz Stanislawski





On 05/09/2012 08:46 AM, Subash Patel wrote:
> Hello Tomasz, Laurent,
> 
> I have printed some logs during the dmabuf export and attach for the SGT issue below. Please find it in the attachment. I hope
> it will be useful.
> 
> Regards,
> Subash
> 
> On 05/08/2012 04:45 PM, Subash Patel wrote:
>> Hi Laurent,
>>
>> On 05/08/2012 02:44 PM, Laurent Pinchart wrote:
>>> Hi Subash,
>>>
>>> On Monday 07 May 2012 20:08:25 Subash Patel wrote:
>>>> Hello Thomasz, Laurent,
>>>>
>>>> I found an issue in the function vb2_dc_pages_to_sgt() below. I saw that
>>>> during the attach, the size of the SGT and size requested mis-matched
>>>> (by atleast 8k bytes). Hence I made a small correction to the code as
>>>> below. I could then attach the importer properly.
>>>
>>> Thank you for the report.
>>>
>>> Could you print the content of the sglist (number of chunks and size
>>> of each
>>> chunk) before and after your modifications, as well as the values of
>>> n_pages,
>>> offset and size ?
>> I will put back all the printk's and generate this. As of now, my setup
>> has changed and will do this when I get sometime.
>>>
>>>> On 04/20/2012 08:15 PM, Tomasz Stanislawski wrote:
>>>
>>> [snip]
>>>
>>>>> +static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
>>>>> + unsigned int n_pages, unsigned long offset, unsigned long size)
>>>>> +{
>>>>> + struct sg_table *sgt;
>>>>> + unsigned int chunks;
>>>>> + unsigned int i;
>>>>> + unsigned int cur_page;
>>>>> + int ret;
>>>>> + struct scatterlist *s;
>>>>> +
>>>>> + sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
>>>>> + if (!sgt)
>>>>> + return ERR_PTR(-ENOMEM);
>>>>> +
>>>>> + /* compute number of chunks */
>>>>> + chunks = 1;
>>>>> + for (i = 1; i< n_pages; ++i)
>>>>> + if (pages[i] != pages[i - 1] + 1)
>>>>> + ++chunks;
>>>>> +
>>>>> + ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
>>>>> + if (ret) {
>>>>> + kfree(sgt);
>>>>> + return ERR_PTR(-ENOMEM);
>>>>> + }
>>>>> +
>>>>> + /* merging chunks and putting them into the scatterlist */
>>>>> + cur_page = 0;
>>>>> + for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
>>>>> + unsigned long chunk_size;
>>>>> + unsigned int j;
>>>>
>>>> size = PAGE_SIZE;
>>>>
>>>>> +
>>>>> + for (j = cur_page + 1; j< n_pages; ++j)
>>>>
>>>> for (j = cur_page + 1; j< n_pages; ++j) {
>>>>
>>>>> + if (pages[j] != pages[j - 1] + 1)
>>>>> + break;
>>>>
>>>> size += PAGE
>>>> }
>>>>
>>>>> +
>>>>> + chunk_size = ((j - cur_page)<< PAGE_SHIFT) - offset;
>>>>> + sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
>>>>
>>>> [DELETE] size -= chunk_size;
>>>>
>>>>> + offset = 0;
>>>>> + cur_page = j;
>>>>> + }
>>>>> +
>>>>> + return sgt;
>>>>> +}
>>>
>> Regards,
>> Subash

