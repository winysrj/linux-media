Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB83C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FFB222BA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbfBMJjf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 04:39:35 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51074 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728873AbfBMJjf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 04:39:35 -0500
Received: from [IPv6:2001:420:44c1:2579:f0ed:1bc9:c490:1f30] ([IPv6:2001:420:44c1:2579:f0ed:1bc9:c490:1f30])
        by smtp-cloud8.xs4all.net with ESMTPA
        id tr0pg3cVO4HFntr0tglE4S; Wed, 13 Feb 2019 10:39:32 +0100
Subject: Re: [PATCHv2 3/3] vb2: add 'match' arg to vb2_find_buffer()
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>
References: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
 <20190204101134.56283-4-hverkuil-cisco@xs4all.nl>
 <CAPBb6MUn87+Pu2HNv7MF7vHaqQw-3mQQfDaeu1GtbD=hnDfo1A@mail.gmail.com>
 <33c85a26-0133-8c0a-46f7-458c1cbe61fb@xs4all.nl>
 <c2ec7876bd59d6b81fbb1435f8f7a6e4c2d83fb7.camel@bootlin.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <d8a46701-5333-ee41-a53b-0cad2a079330@xs4all.nl>
Date:   Wed, 13 Feb 2019 10:39:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c2ec7876bd59d6b81fbb1435f8f7a6e4c2d83fb7.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNJS6AHOHoqrw6PyemmwKG9jFbLgDe3OMDi06U5TqrM6LKNuIr+kI8Ig5eqE6yxbCwc2siOO30+ayNnUKx8ghX4e2KkAggKcX2EBfsni6wMSmSuroawY
 poRMsHEk27pWymL2Tr0pnZxD2auKhpE08hFED4OaY4lzKl1MO41AcDXLocsNau3uGLf3tFT5oxHDraD9qcWBEUMIgy76fHZBu5fuiJZXqfXo4m0DunSgcBUY
 YXlEppqGG52xazRWMPlRw2F+9P8zlQz6Adm+Q8ZyfDDI/kxuikASKvyfFgnkIp5UaKvIj7WU6WB78M6KClbxbe0kJZUlgtEEyjnIzQ5mh0eyPRJLZw+DoNiN
 vr70WfOMoQpCBhiWCMbpmcvUwIj5hSvVkNBtw0KqYf87V7yFVH1UdOFHGCOhfE1vsKfiaPult73DrI8yqdwP9bdSoXJXbw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/13/19 10:08 AM, Paul Kocialkowski wrote:
> Hi,
> 
> On Wed, 2019-02-13 at 09:20 +0100, Hans Verkuil wrote:
>> On 2/13/19 9:01 AM, Alexandre Courbot wrote:
>>> On Mon, Feb 4, 2019 at 7:11 PM <hverkuil-cisco@xs4all.nl> wrote:
>>>> properties of the found buffer (i.e. number of planes and plane sizes)
>>>> match the properties of the 'match' buffer.
>>>
>>> What cases does this extra check protect us against? Is this in case
>>> user-space requeues a buffer with a different number of planes/dmabufs
>>> than what it had when its timestamp has been copied? If so, shouldn't
>>> such cases be covered by the reference count increase on the buffer
>>> resource that you mention in 0/3?
>>
>> It checks that the buffer containing the reference image is a match for the
>> to-be-filled new capture buffer.
>>
>> But I think I'll drop this patch for now because it shouldn't check against
>> match->planes[p].length but instead against match->planes[p].bytesused.
>>
>> The basic idea is that in the future you might have a mix of smaller and
>> larger buffers, and you don't want to e.g. decode a 1080p frame using a
>> reference frame whose buffer was sized for 720p.
> 
> If that's the case in the future, I think it's only fair to let
> userspace deal with associating the right references with the
> associated buffers so that there is no mismatch. Having an extra check
> in the kernel doesn't hurt, but it feels optional IMO.

Never trust anything userspace gives you! You may get garbage, either by
accident or by design.

> 
>> This can't happen today with the cedrus driver AFAIK. Or can it?
> 
> As far as I understand from [0], the capture and output formats can't
> be changed once we have allocated buffers so I don't really see how we
> could end up with mixed resolutions.

Actually, looking at the cedrus code it is missing the check for this:
both cedrus_s_fmt_vid_cap and cedrus_s_fmt_vid_out should call vb2_is_busy()
and return EBUSY if that returns true.

Right now it is perfectly fine for userspace to call S_FMT while buffers
are allocated.

This is a cedrus bug that should be fixed.

Note that v4l2-compliance doesn't check for this, but it probably should.
Or at least warn about it. It is not necessarily wrong to call S_FMT while
buffers are allocated, but the driver has to be able to handle this and
do the necessary checks. But I don't think there are any drivers today that
can handle this.

Regards,

	Hans

> 
> [0]: https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/open.html#multiple-opens
> 
> Cheers,
> 
> Paul
> 
>> The refcount increase is unrelated to this. That would protect against
>> a potential race condition, not against a size mismatch.
>>
>> In the meantime, can you review/test patches 1 and 2? I'd like to get
>> those in first.
>>
>> Thanks!
>>
>> 	Hans
>>
>>>
>>>
>>>> Update the cedrus driver accordingly.
>>>>
>>>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>>> ---
>>>>  drivers/media/common/videobuf2/videobuf2-v4l2.c   | 15 ++++++++++++---
>>>>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c |  8 ++++----
>>>>  include/media/videobuf2-v4l2.h                    |  3 ++-
>>>>  3 files changed, 18 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>>>> index 55277370c313..0207493c8877 100644
>>>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>>>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>>>> @@ -599,14 +599,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
>>>>  };
>>>>
>>>>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>>>> -                      unsigned int start_idx)
>>>> +                      const struct vb2_buffer *match, unsigned int start_idx)
>>>>  {
>>>>         unsigned int i;
>>>>
>>>>         for (i = start_idx; i < q->num_buffers; i++)
>>>>                 if (q->bufs[i]->copied_timestamp &&
>>>> -                   q->bufs[i]->timestamp == timestamp)
>>>> -                       return i;
>>>> +                   q->bufs[i]->timestamp == timestamp &&
>>>> +                   q->bufs[i]->num_planes == match->num_planes) {
>>>> +                       unsigned int p;
>>>> +
>>>> +                       for (p = 0; p < match->num_planes; p++)
>>>> +                               if (q->bufs[i]->planes[p].length <
>>>> +                                   match->planes[p].length)
>>>> +                                       break;
>>>> +                       if (p == match->num_planes)
>>>> +                               return i;
>>>> +               }
>>>>         return -1;
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(vb2_find_timestamp);
>>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>>>> index cb45fda9aaeb..16bc82f1cb2c 100644
>>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>>>> @@ -159,8 +159,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>>>>         cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
>>>>
>>>>         /* Forward and backward prediction reference buffers. */
>>>> -       forward_idx = vb2_find_timestamp(cap_q,
>>>> -                                        slice_params->forward_ref_ts, 0);
>>>> +       forward_idx = vb2_find_timestamp(cap_q, slice_params->forward_ref_ts,
>>>> +                                        &run->dst->vb2_buf, 0);
>>>>
>>>>         fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
>>>>         fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
>>>> @@ -168,8 +168,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>>>>         cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
>>>>         cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
>>>>
>>>> -       backward_idx = vb2_find_timestamp(cap_q,
>>>> -                                         slice_params->backward_ref_ts, 0);
>>>> +       backward_idx = vb2_find_timestamp(cap_q, slice_params->backward_ref_ts,
>>>> +                                         &run->dst->vb2_buf, 0);
>>>>         bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
>>>>         bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
>>>>
>>>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>>>> index 8a10889dc2fd..b123d12424ba 100644
>>>> --- a/include/media/videobuf2-v4l2.h
>>>> +++ b/include/media/videobuf2-v4l2.h
>>>> @@ -60,6 +60,7 @@ struct vb2_v4l2_buffer {
>>>>   *
>>>>   * @q:         pointer to &struct vb2_queue with videobuf2 queue.
>>>>   * @timestamp: the timestamp to find.
>>>> + * @match:     the properties of the buffer to find must match this buffer.
>>>>   * @start_idx: the start index (usually 0) in the buffer array to start
>>>>   *             searching from. Note that there may be multiple buffers
>>>>   *             with the same timestamp value, so you can restart the search
>>>> @@ -69,7 +70,7 @@ struct vb2_v4l2_buffer {
>>>>   * -1 if no buffer with @timestamp was found.
>>>>   */
>>>>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>>>> -                      unsigned int start_idx);
>>>> +                      const struct vb2_buffer *match, unsigned int start_idx);
>>>>
>>>>  int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
>>>>
>>>> --
>>>> 2.20.1
>>>>

