Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeHPONT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 10:13:19 -0400
Date: Thu, 16 Aug 2018 08:15:22 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: [RFC] Request API questions
Message-ID: <20180816081522.76f71891@coco.lan>
In-Reply-To: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 16 Aug 2018 12:25:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

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

IMHO, there's not much sense on preventing it. Just having a warning
at the spec is enough.

+.. caution::
+
+   Setting the same control through a request and also directly can lead to
+   undefined behavior!

It is already warned with a caution. Anyone that decides to ignore a
warning like that will deserve his faith if things stop work.

> 
> 2) If request_fd in QBUF or the control ioctls is not a request fd, then we
>    now return ENOENT. Laurent suggests using EBADR ('Invalid request descriptor')
>    instead. This seems like a good idea to me. Should I change this?

I don't have a strong opinion, but EBADR value seems to be arch-dependent:

arch/alpha/include/uapi/asm/errno.h:#define	EBADR		98	/* Invalid request descriptor */
arch/mips/include/uapi/asm/errno.h:#define EBADR		51	/* Invalid request descriptor */
arch/parisc/include/uapi/asm/errno.h:#define	EBADR		161	/* Invalid request descriptor */
arch/sparc/include/uapi/asm/errno.h:#define	EBADR		103	/* Invalid request descriptor */
include/uapi/asm-generic/errno.h:#define	EBADR		53	/* Invalid request descriptor */

Also, just because its name says "invalid request", it doesn't mean that it
is the right error code. In this specific case, we're talking about a file
descriptor. Invalid file descriptors is something that the FS subsystem
has already a defined set of return codes. We should stick with whatever
FS uses when a file descriptor is invalid.

Where the VFS code returns EBADR? Does it make sense for our use cases?

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

Return the request "cached" value, IMO, doesn't make sense. If the
application needs such cache, it can implement itself.

Return an error code if the request has not yet completed makes
sense. Not sure what would be the best error code here... if the
request is queued already (but not processed), EBUSY seems to be the
better choice, but, if it was not queued yet, I'm not sure. I guess
ENOENT would work.

> 
> 4) When queueing a buffer to a request with VIDIOC_QBUF you set V4L2_BUF_FLAG_REQUEST_FD
>    to indicate a valid request_fd. For other queue ioctls that take a struct v4l2_buffer
>    this flag and the request_fd field are just ignored. Should we return EINVAL
>    instead if the flag is set for those ioctls?
> 
>    The argument for just ignoring it is that older kernels that do not know about
>    this flag will ignore it as well. There is no check against unknown flags.

As I answered before, I don't see any need to add extra code for checking invalid
flags.

It might make sense to ask users to clean the flag if not QBUF, just at the
eventual remote case we might want to use it on other ioctls.

Thanks,
Mauro
