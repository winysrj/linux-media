Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10140 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbBKJAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 04:00:48 -0500
Message-id: <54DB1A3C.3050207@samsung.com>
Date: Wed, 11 Feb 2015 10:00:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] media/videobuf2-dma-sg: Fix handling of sg_table
 structure
References: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
 <54DB0D84.7020600@samsung.com>
 <CAPybu_37FJhAKYYKuyMqTexYgFspwhnBs8bMxHGpG7XiVejaJw@mail.gmail.com>
In-reply-to: <CAPybu_37FJhAKYYKuyMqTexYgFspwhnBs8bMxHGpG7XiVejaJw@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-02-11 09:37, Ricardo Ribalda Delgado wrote:
> Hello Marek
> On Wed, Feb 11, 2015 at 9:06 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>>> Unfortunately nent differs in sign to the output of dma_map_sg, so an
>>> intermediate value must be used.
>>
>> I don't get this part. dma_map_sg() returns the number of scatter list
>> entries mapped
>> to the hardware or zero if anything fails. What is the problem of assigning
>> it directly
>> to nents?
> Are you sure about that?
>
> The prototype of the function is (from dma-mapping-common.h)
> static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
>    int nents, enum dma_data_direction dir,
>    struct dma_attrs *attrs)
>
> which calls map_sg at the struct dma_map_ops (dma-mapping.h)
>
> int (*map_sg)(struct device *dev, struct scatterlist *sg,
>       int nents, enum dma_data_direction dir,
>       struct dma_attrs *attrs);
>
> Both return int instead of unsigned int....

Well, this int return value seems to be misleading, but according to
Documentation/DMA-API.txt, the only error value is zero:

"As with the other mapping interfaces, dma_map_sg() can fail. When it
does, 0 is returned and a driver must take appropriate action. It is
critical that the driver do something, in the case of a block driver
aborting the request or even oopsing is better than doing nothing and
corrupting the filesystem."

I've also checked various dma-mapping implementation for different
architectures and they follow this convention.

Maybe one should add some comments to include/linux/dma_mapping.h to
clarify this and avoid further confusion.


>
>> dma_map_sg_attrs() return 0 in case of error, so the check can be
>> simplified,
>> there is no need for temporary variable.
> Check last comment
>
>>>                  vm_unmap_ram(buf->vaddr, buf->num_pages);
>>>          sg_free_table(buf->dma_sgt);
>>> @@ -463,7 +470,7 @@ static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf
>>> *dbuf, struct device *dev
>>>          rd = buf->dma_sgt->sgl;
>>>          wr = sgt->sgl;
>>> -       for (i = 0; i < sgt->orig_nents; ++i) {
>>> +       for (i = 0; i < sgt->nents; ++i) {
>>
>> Here the code iterates over every memory page in the scatter list (to create
>> a copy of it), not the device mapped chunks, so it must use orig_nents
>> like it was already there.
> At that point both have the same value, but you are right, it is more
> clear to use orig_nents
>
>
>
> I will resend a version using orig_nents in dmabug_ops attach, but
> please take a look the map_sg, I think it can return <0
>
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

