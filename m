Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44109 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2GXIzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 04:55:54 -0400
Received: by yhmm54 with SMTP id m54so6392672yhm.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 01:55:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207231444.11469.hverkuil@xs4all.nl>
References: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com>
	<201207201105.45303.hverkuil@xs4all.nl>
	<CAGzWAsg2fhmxDshtruGm90YAiVbHis7hEuE_BZRFBV_PPa-h7g@mail.gmail.com>
	<201207231444.11469.hverkuil@xs4all.nl>
Date: Tue, 24 Jul 2012 14:25:53 +0530
Message-ID: <CAGzWAsh+tA89gRB70KNAcp0AmMwaZavU0z=byMC+ttN5=R7CSA@mail.gmail.com>
Subject: Re: Supporting 3D formats in V4L2
From: Soby Mathew <soby.linuxtv@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans
Thanks for your comments.

Best Regards
Soby Mathew

On Mon, Jul 23, 2012 at 6:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon July 23 2012 14:35:14 Soby Mathew wrote:
>> Hi Hans,
>>  Thanks for the reply and I was going through the HDMI1.4 spec again.
>> The 'active space' is part of the Vactive and Vactive is sum of active
>> video and active space.
>>
>> > No, as I understand it active_space is just part of the active video. So the
>> > timings struct is fine, it's just that the height parameter for e.g. 720p in
>> > frame pack format is 2*720 + vfrontporch + vsync + vbackporch. That's the height
>> > of the frame that will have to be DMAed from/to the receiver/transmitter.
>>
>> In this case (assuming frame packed) the total height should be 2*720
>> + 30 +  vfrontporch + vsync + vbackporch.
>>
>> Sorry, but if I am understanding you correct, in case of 3D frame
>> packed format, the height field can be 'active video + active space'.
>
> Right.
>
>> So the application need to treat the buffers appropriately according
>> to the 3D format detected. Would this be a good solution?
>
> Right. So the application will need to obtain the timings somehow (either from
> v4l2-dv-timings.h, or from VIDIOC_G/QUERY_DV_TIMINGS) so it knows how to
> interpret the captured data and how large the buffer size has to be in the first
> place.
>
> I think it will all work out, but you would have to actually implement it to be
> sure I haven't forgotten anything.
>
> Frankly, I'd say that the frame_packed format is something you want to avoid :-)
> It's pretty weird.
>
> Regards,
>
>         Hans
>
>>
>>
>> > I think the only thing that needs to be done is that the appropriate timings are
>> > added to linux/v4l2-dv-timings.h.
>>
>> Yes , the standard 3 D timings need to be added to this file which can
>> be taken up.
>>
>> > Regards,
>> >
>> >         Hans
>> >
>>
>>
>> Best Regards
>> Soby Mathew
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
//vger.kernel.org/majordomo-info.html
