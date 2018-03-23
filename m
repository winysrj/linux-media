Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34602 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752105AbeCWJdi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 05:33:38 -0400
Date: Fri, 23 Mar 2018 11:33:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [RFC] Request API
Message-ID: <20180323093335.kiu3nqkf2uj2qczs@valkosipuli.retiisi.org.uk>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
 <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
 <015c0c34-c628-5381-480c-878b1d50b4e2@xs4all.nl>
 <CAAFQd5Co_9cxoSL_brVZiTYR5sQL8igBds-vDxbrYysQ8xWFqA@mail.gmail.com>
 <4694ea20-4ece-f9d4-c2ae-df3f1c10f717@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4694ea20-4ece-f9d4-c2ae-df3f1c10f717@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Tomasz,

On Fri, Mar 23, 2018 at 08:38:54AM +0100, Hans Verkuil wrote:
...
> >>>
> >>> Perhaps we need to consider few separate cases here:
> >>>
> >>>  1) Query control value within a request. Would return the value that
> >>> was earlier set to that particular request (and maybe -EBUSY if it
> >>> wasn't set?). Perhaps done with v4l2_ext_controls::which set to
> >>> V4L2_CTRL_WHICH_REQUEST and v4l2_ext_controls::reserved[2] to FD of
> >>> the request in question.
> >>
> >> I see no reason to use 'WHICH_REQUEST'. If request_fd is non-zero,
> >> then it automatically refers to that request.
> > 
> > Agreed, with one minor detail. Note that zero is a perfectly valid FD.
> 
> That's annoying and will actually require WHICH_REQUEST to indicate that
> the request_fd should be used. So WHICH_CUR_VAL will ignore the request_fd
> field. I'll update this in a new RFC.
> 
> For the same reason we'll need a flag for v4l2_buffers to indicate that
> request_fd should be used. This will be similar to what the fence patch
> series does.

It's valid, indeed. Normally it'd be stdin, but if you close it and then
allocate a request, you indeed could get zero.

...

> >>> An alternative, maybe a bit crazy, idea would be to allow adding
> >>> MEDIA_REQUEST_IOC_QUEUE ioctl to the request itself. This would be
> >>> similar to the idea of indirect command buffers in the graphics (GPU)
> >>> land. It could for example look like this:
> >>>
> >>> // One time initialization
> >>> bulk_fd = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
> >>> for (i = 0; i < N; ++i) {
> >>>     fd[i] = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
> >>>     // Add some state
> >>>     ioctl(fd[i], MEDIA_IOC_REQUEST_QUEUE, { .request = bulk_fd });
> >>> }
> >>>
> >>> // Do some work
> >>>
> >>> ioctl(bulk_fd, MEDIA_IOC_REQUEST_QUEUE); // Queues all the requests at once
> >>
> >> That doesn't reduce the number of ioctl calls :-)
> > 
> > Depends on what cases we are talking about. If we have cases of
> > queuing the same (big) sets of requests multiple time, then only for
> > the first time all the ioctls would be needed. Next time, one only
> > needs to queue the bulk_fd.
> > 
> > Personally, I don't have any good use case that would involve queuing
> > many requests instantly and would be affected by the number of ioctls,
> > though.
> 
> Sakari gave the example of 10 cameras running at 60 fps, thus generating
> a very large amount of request ioctls.
> 
> But this doesn't apply to stateless codecs, so for now this is something
> for the future.

I think get real benefit from being able to queue multiple requests at a
time only when you don't need a ton of IOCTLs to construct those requests
first. I.e. that means moving constructing the requests to Media device as
well. That's something for the future indeed, and I don't think it's
realistic to think we'd be there any time soon.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
