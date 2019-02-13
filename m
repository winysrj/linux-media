Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91F6C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82712222C0
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbfBMJ5Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 04:57:16 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:38909 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388173AbfBMJ5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 04:57:16 -0500
Received: from [IPv6:2001:420:44c1:2579:f0ed:1bc9:c490:1f30] ([IPv6:2001:420:44c1:2579:f0ed:1bc9:c490:1f30])
        by smtp-cloud8.xs4all.net with ESMTPA
        id trHyg3kAU4HFntrI1glIak; Wed, 13 Feb 2019 10:57:14 +0100
Subject: Re: [PATCH v3] media: docs-rst: Document m2m stateless video decoder
 interface
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
References: <20190213055317.192029-1-acourbot@chromium.org>
 <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
 <b24e3e67-9fb3-3602-8a90-826f8c51eadf@xs4all.nl>
 <3de0825971b91ea0b8fd349f4ecf8164de14254a.camel@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7caf9381-e920-f5fc-e8f9-a54ac2733add@xs4all.nl>
Date:   Wed, 13 Feb 2019 10:57:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3de0825971b91ea0b8fd349f4ecf8164de14254a.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfO3biIt8qgfnvoluV0du4HnzOcTgDpt0cH6IxU8pGH1mVBKuSmJ/B3UUd2JyK6s2CsvL/YaDN2yZOY5Vv8Et5nSk6dTNHvwtWrYVMkOboxFY6DErdBQM
 t3i4S1Ybrut1lD9O60dd6ce76oSfT8GhTU50MedaYRYorq9FAcaS9HbUaLqy24RhlEabDcxeSFqREA0U2nTUoJio+t7mio8hWsbTy3UeGWz+AnvPIZLlUUH7
 WKpWdka/lNh60jLlxF54nOav+vLqlmyue0ae/BBvV+nECF/ipkhOdBA+bfpm7YOal+tgPPSmqBcLs8b5For3TxDEg6k/ip4sC82Ts2Fm1u4WT6eB1IrlWdfG
 28J2/6QtT1wjtjM2CtYxg14UKABFntsr/mLOVScCCEMA+xHCBhQDZ4y5su0+/XnedS1GBF6TCMbsRip/V7ede+1Nk3d2xib2vLjx+jQW76TUiv9w9XEpU074
 92GN4qj6eVLR/Lmb475eeFb62TemHNH057ZB9Nl2qOMsd8Zwyg70Ftlh5U8dx1cDaXLP+HrHeFxqJvX9
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/13/19 10:20 AM, Paul Kocialkowski wrote:
> Hi,
> 
> On Wed, 2019-02-13 at 09:59 +0100, Hans Verkuil wrote:
>> On 2/13/19 6:58 AM, Alexandre Courbot wrote:
>>> On Wed, Feb 13, 2019 at 2:53 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>>>> [snip]
>>>> +Buffers used as reference frames can be queued back to the ``CAPTURE`` queue as
>>>> +soon as all the frames they are affecting have been queued to the ``OUTPUT``
>>>> +queue. The driver will refrain from using the reference buffer as a decoding
>>>> +target until all the frames depending on it are decoded.
>>>
>>> Just want to highlight this part in order to make sure that this is
>>> indeed what we agreed on. The recent changes to vb2_find_timestamp()
>>> suggest this, but maybe I misunderstood the intent. It makes the
>>> kernel responsible for tracking referenced buffers and not using them
>>> until all the dependent frames are decoded, something the client could
>>> also do.
>>
>> I don't think this is quite right. Once this patch https://patchwork.linuxtv.org/patch/54275/
>> is in the vb2 core will track when a buffer can no longer be used as a
>> reference buffer because the underlying memory might have disappeared.
>>
>> The core does not check if it makes sense to use a buffer as a reference
>> frame, just that it is valid memory.
>>
>> So the driver has to check that the timestamp refers to an existing
>> buffer, but userspace has to check that it queues everything in the
>> right order and that the reference buffer won't be overwritten
>> before the last output buffer using that reference buffer has been
>> decoded.
>>
>> So I would say that the second sentence in your paragraph is wrong.
>>
>> The first sentence isn't quite right either, but I am not really sure how
>> to phrase it. It is possible to queue a reference buffer even if
>> not all output buffers referring to it have been decoded, provided
>> that by the time the driver starts to use this buffer this actually
>> has happened.
> 
> Is there a way we can guarantee this? Looking at the rest of the spec,
> it says that capture buffers "are returned in decode order" but that
> doesn't imply that they are picked up in the order they are queued.
> 
> It seems quite troublesome for the core to check whether each queued
> capture buffer is used as a reference for one of the queued requests to
> decide whether to pick it up or not.

The core only checks that the timestamp points to a valid buffer.

It is not up to the core or the driver to do anything else. If userspace
gives a reference to a wrong buffer or one that is already overwritten,
then you just get bad decoded video, but nothing crashes.

> 
>> But this is an optimization and theoretically it can depend on the
>> driver behavior. It is always safe to only queue a reference frame
>> when all frames depending on it have been decoded. So I am leaning
>> towards not complicating matters and keeping your first sentence
>> as-is.
> 
> Yes, I believe it would be much simpler to require userspace to only
> queue capture buffers once they are no longer needed as references.

I think that's what we should document, but in cases where you know
the hardware (i.e. an embedded system) it should be allowed to optimize
and have the application queue a capture buffer containing a reference
frame even if it is still in use by already queued output buffers.

That way you can achieve optimal speed and memory usage.

I think this is a desirable feature.

> This also means that the dmabuf fd can't be changed so we are
> guaranteed that memory will still be there.

This is easy enough to check for, so I rather have some checks in
the core for this than prohibiting optimizing the decoder memory
usage.

Regards,

	Hans

> 
> Cheers,
> 
> Paul
> 

