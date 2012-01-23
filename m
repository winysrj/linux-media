Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9998 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2AWOcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:32:12 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY900AZT9PMUL@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 14:32:10 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LY900HY99PL7F@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 14:32:10 +0000 (GMT)
Date: Mon, 23 Jan 2012 15:32:08 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
In-reply-to: <4F1D6D3E.7020203@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <4F1D6F68.5040202@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com>
 <4F1D6D3E.7020203@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 01/23/2012 03:22 PM, Mauro Carvalho Chehab wrote:
> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> Please better describe this patch. What is it supposing to fix?

Usually compilation error or bugs discovered in previous vb2-dma-contig 
patches adding support for dma-buf.

>
>> ---
>>   drivers/media/video/videobuf2-core.c |   21 +++++++++------------
>>   include/media/videobuf2-core.h       |    6 +++---
>>   2 files changed, 12 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
>> index cb85874..59bb1bc 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
>> @@ -119,7 +119,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
>>   		void *mem_priv = vb->planes[plane].mem_priv;
>>
>>   		if (mem_priv) {
>> -			call_memop(q, plane, detach_dmabuf, mem_priv);
>> +			call_memop(q, detach_dmabuf, mem_priv);
>
> Huh? You're not removing the "plane" parameter on this patch, but, instead,
> on a previous patch.
>
> No patch is allowed to break compilation, as it breaks git bisect.

I agree that patches should not break compilation if patches are 
accepted to the mainline. There is a big compilation failure at patch 07 
where videobuf2-dma-contig.c disappears.

Note that these are proof-of-concept patches for support of dma-buf 
exporting/importing dma-buf in V4L2. It would be a waste of time 
polished the patches if they are going to be rejected due to design flaws.

Regards,
Tomasz Stanislawski
