Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:36696 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727153AbeHWNPL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 09:15:11 -0400
Subject: Re: [RFC] Request API questions
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
Message-ID: <d0d9988e-fb5c-104f-ba5c-16aaf36b2d81@xs4all.nl>
Date: Thu, 23 Aug 2018 11:46:13 +0200
MIME-Version: 1.0
In-Reply-To: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Based on the discussion on the mailinglist I came to the following conclusions
which I will be implementing on top of the reqv18 patches:

On 08/16/18 12:25, Hans Verkuil wrote:
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
> 
>    If there really is a good reason why you can't mix this for a specific
>    control, then the driver can check this and return -EBUSY.

We allow this. The warning in the spec is sufficient and there are legitimate
use-cases where you want to be able to do this.

> 
> 2) If request_fd in QBUF or the control ioctls is not a request fd, then we
>    now return ENOENT. Laurent suggests using EBADR ('Invalid request descriptor')
>    instead. This seems like a good idea to me. Should I change this?

Mauro wasn't too keen on it and EBADR appears to be arch dependent (different
values for different architectures).

I think using EBADR is a bit too risky.

However, I do agree with Laurent that ENOENT isn't the best error code. We have a
similar situation with vb2 and dmabuf if the fd for a dmabuf is invalid. In that
case vb2 returns -EINVAL, but it also issues a dprintk in that case so it is a
bit easier to discover the reason for EINVAL. I'll do the same.

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

The consensus is to prohibit this, at least for now. So attempts to get controls
from a request that is not in completed state will return -EACCES.

> 
> 4) When queueing a buffer to a request with VIDIOC_QBUF you set V4L2_BUF_FLAG_REQUEST_FD
>    to indicate a valid request_fd. For other queue ioctls that take a struct v4l2_buffer
>    this flag and the request_fd field are just ignored. Should we return EINVAL
>    instead if the flag is set for those ioctls?
> 
>    The argument for just ignoring it is that older kernels that do not know about
>    this flag will ignore it as well. There is no check against unknown flags.

We'll just leave this as-is. I'll add a note to the spec that userspace should clear this
flag for ioctls other than QBUF.

Regards,

	Hans
