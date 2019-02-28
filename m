Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D206CC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A160221850
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 10:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbfB1KOU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:14:20 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38484 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732285AbfB1KOS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 05:14:18 -0500
Received: from [IPv6:2001:983:e9a7:1:7dc8:359d:c6e9:ced2] ([IPv6:2001:983:e9a7:1:7dc8:359d:c6e9:ced2])
        by smtp-cloud8.xs4all.net with ESMTPA
        id zIhjggrxO4HFnzIhkgTUm2; Thu, 28 Feb 2019 11:14:16 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3] media: docs-rst: Document m2m stateless video decoder
 interface
To:     Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190213055317.192029-1-acourbot@chromium.org>
 <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
 <b24e3e67-9fb3-3602-8a90-826f8c51eadf@xs4all.nl>
 <3de0825971b91ea0b8fd349f4ecf8164de14254a.camel@bootlin.com>
 <7caf9381-e920-f5fc-e8f9-a54ac2733add@xs4all.nl>
 <e19f0821a831c45829c2921ab091b7c6ed80c8f5.camel@bootlin.com>
 <CAPBb6MW24uJ9dgw3_ME=8shh1NSOy7s2mCmq+vFxm=jM2iH9MQ@mail.gmail.com>
Message-ID: <2f1585e7-df8c-8d2f-1ab7-331f7dfc36ee@xs4all.nl>
Date:   Thu, 28 Feb 2019 11:14:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MW24uJ9dgw3_ME=8shh1NSOy7s2mCmq+vFxm=jM2iH9MQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNNH281Q9fmmC6MWC7Vv8+Ogk5Tg+5/lt3PJLUM0mZCuBCQ6I0826X6zXuP2JQ0ax9CqlQdAVsBTKaH98URZWKFzB3rTK1SovN0wBU6ibE2EWRzMSr/a
 6UttbL6aQJojAzC10ISzXD6LPMtOaI5zH+KBoNVW8Qc1aBRmQ76zTFZ2yAuo1uFhubxyt0ApwC/Fsi8sCl1RmcxI8WgLTuqJ1RxQLSh1rm6anq1qJo1Mjbgt
 QasvujEz7q3a8TBMB6rvdnk8UMTQU2LanynXo+b/yh0f0ajckkP7JshMgZXpAVKVAmJvBBnds/hV0fwUOMDzMImk/kpoDIlsbWzjka7Aq0WkZfoy4CyCSUiv
 utjpOhj9aVCgCBRWIkRSxb8tX8c+UV+cCoKHJ+5t1nm/dzuDCY4qYeXK3o0b1ccIVaVqD2efxTCVyyvsgHrVEXdixfVnoijIUuthyfa6adN6wJ7NEX/FI8/t
 10dgGlcEEOnOdhlAgIAI72GD5yIJNsWdGJIgTCAqGgHPulB4NDVti/LMLF4=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/26/19 4:33 AM, Alexandre Courbot wrote:
> Hi, sorry for the delayed reply!
> 
> On Wed, Feb 13, 2019 at 8:04 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
>>
>> Hi,
>>
>> On Wed, 2019-02-13 at 10:57 +0100, Hans Verkuil wrote:
>>> On 2/13/19 10:20 AM, Paul Kocialkowski wrote:
>>>> Hi,
>>>>
>>>> On Wed, 2019-02-13 at 09:59 +0100, Hans Verkuil wrote:
>>>>> On 2/13/19 6:58 AM, Alexandre Courbot wrote:
>>>>>> On Wed, Feb 13, 2019 at 2:53 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>>>>>>> [snip]
>>>>>>> +Buffers used as reference frames can be queued back to the ``CAPTURE`` queue as
>>>>>>> +soon as all the frames they are affecting have been queued to the ``OUTPUT``
>>>>>>> +queue. The driver will refrain from using the reference buffer as a decoding
>>>>>>> +target until all the frames depending on it are decoded.
>>>>>>
>>>>>> Just want to highlight this part in order to make sure that this is
>>>>>> indeed what we agreed on. The recent changes to vb2_find_timestamp()
>>>>>> suggest this, but maybe I misunderstood the intent. It makes the
>>>>>> kernel responsible for tracking referenced buffers and not using them
>>>>>> until all the dependent frames are decoded, something the client could
>>>>>> also do.
>>>>>
>>>>> I don't think this is quite right. Once this patch https://patchwork.linuxtv.org/patch/54275/
>>>>> is in the vb2 core will track when a buffer can no longer be used as a
>>>>> reference buffer because the underlying memory might have disappeared.
>>>>>
>>>>> The core does not check if it makes sense to use a buffer as a reference
>>>>> frame, just that it is valid memory.
>>>>>
>>>>> So the driver has to check that the timestamp refers to an existing
>>>>> buffer, but userspace has to check that it queues everything in the
>>>>> right order and that the reference buffer won't be overwritten
>>>>> before the last output buffer using that reference buffer has been
>>>>> decoded.
>>>>>
>>>>> So I would say that the second sentence in your paragraph is wrong.
>>>>>
>>>>> The first sentence isn't quite right either, but I am not really sure how
>>>>> to phrase it. It is possible to queue a reference buffer even if
>>>>> not all output buffers referring to it have been decoded, provided
>>>>> that by the time the driver starts to use this buffer this actually
>>>>> has happened.
>>>>
>>>> Is there a way we can guarantee this? Looking at the rest of the spec,
>>>> it says that capture buffers "are returned in decode order" but that
>>>> doesn't imply that they are picked up in the order they are queued.
>>>>
>>>> It seems quite troublesome for the core to check whether each queued
>>>> capture buffer is used as a reference for one of the queued requests to
>>>> decide whether to pick it up or not.
>>>
>>> The core only checks that the timestamp points to a valid buffer.
>>>
>>> It is not up to the core or the driver to do anything else. If userspace
>>> gives a reference to a wrong buffer or one that is already overwritten,
>>> then you just get bad decoded video, but nothing crashes.
>>
>> Yes, that makes sense. My concern was mainly about cases where the
>> capture buffers could be consumed by the driver in a different order
>> than they are queued by userspace (which could lead to the reference
>> buffer being reused too early). But thinking about it twice, I don't
>> see a reason why this could happen.
> 
> Do we have a guarantee that it won't happen though? AFAICT the
> behavior that CAPTURE buffers must be processed in queue order is not
> documented anywhere, and not guaranteed by VB2 (even though
> implementation-wise it may currently be the case). So with the current
> state of the specification, the only safe wording I can use is "do not
> queue a reference buffer back until all the frames depending on it
> have been dequeued".
> 
> However, as Hans mentioned it would be nice to be able to assume that
> the capture queue is FIFO and let user-space rely in that fact to
> queue buffers containing reference frames earlier.

I would not be opposed to adding a capability that explicitly states that
the given vb2 queue is always ordered. It would always be true for drivers
using the v4l2-mem2mem framework (and can be set there).

Unordered queues make no sense for m2m devices, at least I cannot think
of any use-case for it.

> 
>>
>>>>> But this is an optimization and theoretically it can depend on the
>>>>> driver behavior. It is always safe to only queue a reference frame
>>>>> when all frames depending on it have been decoded. So I am leaning
>>>>> towards not complicating matters and keeping your first sentence
>>>>> as-is.
>>>>
>>>> Yes, I believe it would be much simpler to require userspace to only
>>>> queue capture buffers once they are no longer needed as references.
>>>
>>> I think that's what we should document, but in cases where you know
>>> the hardware (i.e. an embedded system) it should be allowed to optimize
>>> and have the application queue a capture buffer containing a reference
>>> frame even if it is still in use by already queued output buffers.
>>>
>>> That way you can achieve optimal speed and memory usage.
>>>
>>> I think this is a desirable feature.
>>
>> Yes, definitely.
> 
> I guess the question comes down to "how can user-space know that the
> hardware supports this"? Do we have a flag that we can return to
> signal this behavior? Or can we just define the CAPTURE queue as being
> FIFO for stateless codecs? The latter would make sense IMHO.

As far as I know all m2m devices are ordered today. As are all video
output devices. For video capture devices I know of one driver that is unordered:
cobalt. As far as I know all other video capture devices that use vb2 or the
old videobuf are all ordered. A few very old drivers that do not use these frameworks
would have to be reviewed to see if they do anything weird.

I think the cobalt driver can be modified so that it is ordered as well.

There are three options: add a V4L2_BUF_CAP_IS_ORDERED flag, add a
V4L2_BUF_CAP_IS_UNORDERED flag, or just document and require that all v4l2 devices
are ordered (nobody cares about the cobalt driver, it's Cisco internal hardware).

I'm honestly not certain which of these options is the best, keeping in mind that
we have no idea if reordering might be needed in the future.

Regards,

	Hans
