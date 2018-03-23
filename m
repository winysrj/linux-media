Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:44074 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbeCWPWY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 11:22:24 -0400
Received: by mail-ua0-f180.google.com with SMTP id s92so7986007uas.11
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 08:22:23 -0700 (PDT)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com. [209.85.213.44])
        by smtp.gmail.com with ESMTPSA id r77sm4877599vke.15.2018.03.23.08.22.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Mar 2018 08:22:21 -0700 (PDT)
Received: by mail-vk0-f44.google.com with SMTP id y127so7523414vky.9
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 08:22:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323093335.kiu3nqkf2uj2qczs@valkosipuli.retiisi.org.uk>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
 <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
 <015c0c34-c628-5381-480c-878b1d50b4e2@xs4all.nl> <CAAFQd5Co_9cxoSL_brVZiTYR5sQL8igBds-vDxbrYysQ8xWFqA@mail.gmail.com>
 <4694ea20-4ece-f9d4-c2ae-df3f1c10f717@xs4all.nl> <20180323093335.kiu3nqkf2uj2qczs@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 24 Mar 2018 00:22:00 +0900
Message-ID: <CAAFQd5CgxwSuWzLP+VO87-DJ5s38iD_aq70F169_qY1Emcs9CQ@mail.gmail.com>
Subject: Re: [RFC] Request API
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 6:33 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> >>> An alternative, maybe a bit crazy, idea would be to allow adding
>> >>> MEDIA_REQUEST_IOC_QUEUE ioctl to the request itself. This would be
>> >>> similar to the idea of indirect command buffers in the graphics (GPU)
>> >>> land. It could for example look like this:
>> >>>
>> >>> // One time initialization
>> >>> bulk_fd = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
>> >>> for (i = 0; i < N; ++i) {
>> >>>     fd[i] = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
>> >>>     // Add some state
>> >>>     ioctl(fd[i], MEDIA_IOC_REQUEST_QUEUE, { .request = bulk_fd });
>> >>> }
>> >>>
>> >>> // Do some work
>> >>>
>> >>> ioctl(bulk_fd, MEDIA_IOC_REQUEST_QUEUE); // Queues all the requests at once
>> >>
>> >> That doesn't reduce the number of ioctl calls :-)
>> >
>> > Depends on what cases we are talking about. If we have cases of
>> > queuing the same (big) sets of requests multiple time, then only for
>> > the first time all the ioctls would be needed. Next time, one only
>> > needs to queue the bulk_fd.
>> >
>> > Personally, I don't have any good use case that would involve queuing
>> > many requests instantly and would be affected by the number of ioctls,
>> > though.
>>
>> Sakari gave the example of 10 cameras running at 60 fps, thus generating
>> a very large amount of request ioctls.
>>
>> But this doesn't apply to stateless codecs, so for now this is something
>> for the future.
>
> I think get real benefit from being able to queue multiple requests at a
> time only when you don't need a ton of IOCTLs to construct those requests
> first. I.e. that means moving constructing the requests to Media device as
> well. That's something for the future indeed, and I don't think it's
> realistic to think we'd be there any time soon.

That wouldn't be even Media. Constructing the requests would have to
be moved to userspace, with requests being more like command buffers,
arrays of state objects.

Best regards,
Tomasz
