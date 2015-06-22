Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34317 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbFVOyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 10:54:52 -0400
Received: by lbnk3 with SMTP id k3so4306091lbn.1
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2015 07:54:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5695336.CA8eQ67zhi@avalon>
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<5004544.CpPfGJfHMn@avalon>
	<20150506010310.24f82a42@bones>
	<5695336.CA8eQ67zhi@avalon>
Date: Mon, 22 Jun 2015 15:54:49 +0100
Message-ID: <CAP3TMiFoKSYdsFrQfzx5gLqhJQv6J6HqPpPU0CrrhMyrzjvq3w@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
From: Kamil Debski <kamil@wypas.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, horms@verge.net.au,
	magnus.damm@gmail.com, sergei.shtylyov@cogentembedded.com,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	j.anaszewski@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am adding Jacek Anaszewski to CC loop. He was working with the
s5p-jpeg driver some time ago.
I've spoken with him about questions in this email recently. Jacek,
thank you for your comments :)

On 18 June 2015 at 20:48, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Mikhail,
>
> (CC'ing Kamil Debski)
>
> On Wednesday 06 May 2015 01:03:10 Mikhail Ulianov wrote:
>> On Mon, 04 May 2015 02:32:05 +0300 Laurent Pinchart wrote:

[snip]

>> [snip]
>>
>> >> +/*
>> >> + * ====================================================================
>> >> + * Queue operations
>> >> + * ====================================================================
>> >> + */
>> >> +static int jpu_queue_setup(struct vb2_queue *vq,
>> >> +                     const struct v4l2_format *fmt,
>> >> +                     unsigned int *nbuffers, unsigned int
>> >> *nplanes,
>> >> +                     unsigned int sizes[], void
>> >> *alloc_ctxs[])
>> >> +{
>> >> +  struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
>> >> +  struct jpu_q_data *q_data;
>> >> +  unsigned int count = *nbuffers;
>> >> +  unsigned int i;
>> >> +
>> >> +  q_data = jpu_get_q_data(ctx, vq->type);
>> >> +
>> >> +  *nplanes = q_data->format.num_planes;
>> >> +
>> >> +  /*
>> >> +   * Header is parsed during decoding and parsed information
>> >> stored
>> >> +   * in the context so we do not allow another buffer to
>> >> overwrite it.
>> >> +   * For now it works this way, but planned for alternation.
>> >
>> > It shouldn't be difficult to create a jpu_buffer structure that
>> > inherits from vb2_buffer and store the information there instead of
>> > in the context.
>>
>> You are absolutely right. But for this version i want to keep it
>> simple and also at this moment not everything clear for me with this
>> format "autodetection" feature we want to have e.g. for decoder if user
>> requested 2 output buffers and then queue first with some valid JPEG
>> with format -1-(so we setup queues format here), after that
>> another one with format -2-... should we discard second one or just
>> change format of queues? what about same situation if user already
>> requested capture buffers. I mean relations with buf_prepare and
>> queue_setup. AFAIU format should remain the same for all requested
>> buffers. I see only one "solid" solution here - get rid of
>> "autodetection" feature and rely only on format setted by user, so in
>> this case we can just discard queued buffers with inappropriate
>> format(kind of format validation in kernel). This solution will also
>> work well with NV61, NV21, and semiplanar formats we want to add in next
>> version. *But* with this solution header parsing must be done twice(in
>> user and kernel spaces).
>> I'm a little bit frustrated here :)
>
> Yes, it's a bit frustrating indeed. I'm not sure what to advise, I'm not too
> familiar with the m2m API for JPEG.
>
> Kamil, do you have a comment on that ?

I am not sure whether it is good to get rid of header parsing by the
driver/hardware option. I agree that the buffers should have a
consistent format and size. Maybe the way to go would be to allow
header parsing by the hardware, but to stop processing when the format
has changed? Other solution would be to use the
V4L2_EVENT_SOURCE_CHANGE event to inform user space about the change.
User space then could check whether the buffers are sufficient or
reallocate them. Similar to what happens in MFC when format changes.

For me implementing resolution change in JPEG seems like an overkill,
but maybe you have a use case that would benefit from this. Initially
the JPEG decoder was designed and written as a one shot device. Could
you give an example of such use case?

The possible use case I can imagine is having an M-JPEG stream where
all JPEGs have the same dimensions and format. There I can see some
benefits from having more than one buffer on the queues. Then there
would be no change in the buffer parameters, so this should work.

>> [snip]

[snip]

Best wishes,
Kamil Debski
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
