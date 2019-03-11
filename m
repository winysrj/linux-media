Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DACAC43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B5A20657
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfCKPaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:30:10 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51736 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbfCKPaK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 11:30:10 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3MsOhSh7T4HFn3MsShFLa8; Mon, 11 Mar 2019 16:30:08 +0100
Subject: Re: [PATCHv2] media: videobuf2: Return error after allocation failure
To:     Souptick Joarder <jrdr.linux@gmail.com>, pawel@osciak.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190204150142.GA3900@jordon-HP-15-Notebook-PC>
 <CAFqt6zbWPn4H6ArYEecou0Ri79a6hQcYcBo8ZrjPfkxFJUV-UQ@mail.gmail.com>
 <CAFqt6zZ=9-xtHg_vuCQ2E+S91G6jD8CcK=Wr-OjYONO4+SnEmg@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <52354072-81c5-4aaa-b3ea-885437e043b0@xs4all.nl>
Date:   Mon, 11 Mar 2019 16:30:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFqt6zZ=9-xtHg_vuCQ2E+S91G6jD8CcK=Wr-OjYONO4+SnEmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGLeZguZ64odaxVEpPch/aqvhe+xCcl3r3ThkmH7WUtHafMk/cSMbyLeOu3TAgK3qDGMZBtoon5u5D3XK2Cza/o+3TQymjY9nWE5pVUxr1OHNPOvp+8S
 RAznPS8eQN8UWMTI4q3cGWIm+LQQEahfceRjxl6CAfuzaNai8pSxzVoTf5ys+lPgoARU31JVsEQxIY54mRGQO2gmi9vc47ODy9gCkh8NQ+x87EJdyIGihDPr
 +xLcABRQ7KDXTd9q7MHA8JC8YGQHUUqP3GMHrvGFBLvSpjy1Yc7rVQKSdbjyuDgo8M+Hh25sm0io0CFvNsMP0IxoxIutDHfivjJUYoKryGfHkPjlc8wz9aFm
 kSLjj2nGBWy4mVeI5bNqGAzdnx1pyrq0RCqTx3rLsacpLHnWGEPqZL/9G/GLtJCvkuPN6tWj
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/1/19 4:04 AM, Souptick Joarder wrote:
> On Mon, Feb 11, 2019 at 7:42 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>>
>> On Mon, Feb 4, 2019 at 8:27 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>>>
>>> There is no point to continuing assignment after memory allocation
>>> failed, rather throw error immediately.
>>>
>>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>>
>> Any comment on this patch ?
> 
> If no further comment, can we get this patch in queue for 5.1 ?

5.1 was too late, but it will certainly go into 5.2.

Regards,

	Hans

>>
>>> ---
>>> v1 -> v2:
>>>         Corrected typo in change log.
>>>
>>>  drivers/media/common/videobuf2/videobuf2-vmalloc.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
>>> index 6dfbd5b..d3f71e2 100644
>>> --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
>>> +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
>>> @@ -46,16 +46,16 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
>>>
>>>         buf->size = size;
>>>         buf->vaddr = vmalloc_user(buf->size);
>>> -       buf->dma_dir = dma_dir;
>>> -       buf->handler.refcount = &buf->refcount;
>>> -       buf->handler.put = vb2_vmalloc_put;
>>> -       buf->handler.arg = buf;
>>>
>>>         if (!buf->vaddr) {
>>>                 pr_debug("vmalloc of size %ld failed\n", buf->size);
>>>                 kfree(buf);
>>>                 return ERR_PTR(-ENOMEM);
>>>         }
>>> +       buf->dma_dir = dma_dir;
>>> +       buf->handler.refcount = &buf->refcount;
>>> +       buf->handler.put = vb2_vmalloc_put;
>>> +       buf->handler.arg = buf;
>>>
>>>         refcount_set(&buf->refcount, 1);
>>>         return buf;
>>> --
>>> 1.9.1
>>>

