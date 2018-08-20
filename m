Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbeHTMZ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 08:25:27 -0400
Date: Mon, 20 Aug 2018 12:10:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: [RFC] Request API questions
Message-ID: <20180820091036.emfl4yfec4jj5xpm@valkosipuli.retiisi.org.uk>
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Aug 16, 2018 at 12:25:25PM +0200, Hans Verkuil wrote:
> Laurent raised a few API issues/questions in his review of the documentation.
> 
> I've consolidated those in this RFC. I would like to know what others think
> and if I should make changes.
> 
> 1) Should you be allowed to set controls directly if they are also used in
>    requests? Right now this is allowed, although we warn in the spec that
>    this can lead to undefined behavior.
> 
>    In my experience being able to do this is very useful while testing,
>    and restricting this is not all that easy to implement. I also think it is
>    not our job. It is not as if something will break when you do this.

It should be easy for drivers to disable controls that need to go through
requests whenever there are requests queued. There will be lots of corner
cases when you poking requests that are already validated with stuff that
was not considered when the request was validated.

Controls such as exposure time for cameras would be generally fine whereas
those such as rotation would be not.

That said, I'd guess we don't run into these issues with stateless codecs.

We still should be careful with this: allowing setting controls (or other
bits) that can also be a part of a request can prove troublesome for some
individual controls such as rotation. If we do allow setting them now and
disallow that later, that may break applications however dangerous setting
those controls may be.

> 
>    If there really is a good reason why you can't mix this for a specific
>    control, then the driver can check this and return -EBUSY.
> 
> 2) If request_fd in QBUF or the control ioctls is not a request fd, then we
>    now return ENOENT. Laurent suggests using EBADR ('Invalid request descriptor')
>    instead. This seems like a good idea to me. Should I change this?

I agree, this sounds like a good idea. The next question is though: should
this apply to requests in general, independently of the IOCTL? It would be
logical.

> 
> 3) Calling VIDIOC_G_EXT_CTRLS for a request that has not been queued yet will
>    return either the value of the control you set earlier in the request, or
>    the current HW control value if it was never set in the request.
> 
>    I believe it makes sense to return what was set in the request previously
>    (if you set it, you should be able to get it), but it is an idea to return
>    ENOENT when calling this for controls that are NOT in the request.
> 
>    I'm inclined to implement that. Opinions?

Is there any particular reason for that kind of a change? In general, the
device state is changed by the requests and what is not part of a request
should remain intact.

What would be the behaviour if the requests would result in changing a
value of the control that the user would read back?

> 
> 4) When queueing a buffer to a request with VIDIOC_QBUF you set V4L2_BUF_FLAG_REQUEST_FD
>    to indicate a valid request_fd. For other queue ioctls that take a struct v4l2_buffer
>    this flag and the request_fd field are just ignored. Should we return EINVAL
>    instead if the flag is set for those ioctls?

Good question. If there is no need to use the flag for other IOCTLs now,
will there be such a need in the future? Can we guarantee there will not
be? I think it'd be safer to return an error if there's no need to use
these IOCTLs with requests now.

> 
>    The argument for just ignoring it is that older kernels that do not know about
>    this flag will ignore it as well. There is no check against unknown flags.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
