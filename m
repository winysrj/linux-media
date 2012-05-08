Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64382 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2EHLPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 07:15:52 -0400
Message-ID: <4FA9005F.6020901@gmail.com>
Date: Tue, 08 May 2012 16:45:43 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com> <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com> <4FA7DE61.7000705@gmail.com> <4675433.ieio0xx0Y0@avalon>
In-Reply-To: <4675433.ieio0xx0Y0@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 05/08/2012 02:44 PM, Laurent Pinchart wrote:
> Hi Subash,
>
> On Monday 07 May 2012 20:08:25 Subash Patel wrote:
>> Hello Thomasz, Laurent,
>>
>> I found an issue in the function vb2_dc_pages_to_sgt() below. I saw that
>> during the attach, the size of the SGT and size requested mis-matched
>> (by atleast 8k bytes). Hence I made a small correction to the code as
>> below. I could then attach the importer properly.
>
> Thank you for the report.
>
> Could you print the content of the sglist (number of chunks and size of each
> chunk) before and after your modifications, as well as the values of n_pages,
> offset and size ?
I will put back all the printk's and generate this. As of now, my setup 
has changed and will do this when I get sometime.
>
>> On 04/20/2012 08:15 PM, Tomasz Stanislawski wrote:
>
> [snip]
>
>>> +static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
>>> +	unsigned int n_pages, unsigned long offset, unsigned long size)
>>> +{
>>> +	struct sg_table *sgt;
>>> +	unsigned int chunks;
>>> +	unsigned int i;
>>> +	unsigned int cur_page;
>>> +	int ret;
>>> +	struct scatterlist *s;
>>> +
>>> +	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
>>> +	if (!sgt)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	/* compute number of chunks */
>>> +	chunks = 1;
>>> +	for (i = 1; i<   n_pages; ++i)
>>> +		if (pages[i] != pages[i - 1] + 1)
>>> +			++chunks;
>>> +
>>> +	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
>>> +	if (ret) {
>>> +		kfree(sgt);
>>> +		return ERR_PTR(-ENOMEM);
>>> +	}
>>> +
>>> +	/* merging chunks and putting them into the scatterlist */
>>> +	cur_page = 0;
>>> +	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
>>> +		unsigned long chunk_size;
>>> +		unsigned int j;
>>
>> 		size = PAGE_SIZE;
>>
>>> +
>>> +		for (j = cur_page + 1; j<   n_pages; ++j)
>>
>> 		for (j = cur_page + 1; j<  n_pages; ++j) {
>>
>>> +			if (pages[j] != pages[j - 1] + 1)
>>> +				break;
>>
>> 			size += PAGE
>> 		}
>>
>>> +
>>> +		chunk_size = ((j - cur_page)<<   PAGE_SHIFT) - offset;
>>> +		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
>>
>> 		[DELETE] size -= chunk_size;
>>
>>> +		offset = 0;
>>> +		cur_page = j;
>>> +	}
>>> +
>>> +	return sgt;
>>> +}
>
Regards,
Subash
