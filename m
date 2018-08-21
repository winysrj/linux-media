Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42264 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbeHUNVh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 09:21:37 -0400
Received: by mail-yw1-f68.google.com with SMTP id n207-v6so2825987ywn.9
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 03:02:06 -0700 (PDT)
Received: from mail-yb0-f169.google.com (mail-yb0-f169.google.com. [209.85.213.169])
        by smtp.gmail.com with ESMTPSA id n34-v6sm967743ywh.42.2018.08.21.03.02.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Aug 2018 03:02:04 -0700 (PDT)
Received: by mail-yb0-f169.google.com with SMTP id l16-v6so5736460ybk.11
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 03:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
 <20180816081522.76f71891@coco.lan> <CAAFQd5C9y2oZJ7HpRqCVqNhsMgUbnoxcafumX1fU9oXMnjiuww@mail.gmail.com>
 <3b59475f-b06e-4d9a-868c-04f608677cca@xs4all.nl> <20180821100001.rsjzodb7b7ikvz3c@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180821100001.rsjzodb7b7ikvz3c@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 21 Aug 2018 19:01:52 +0900
Message-ID: <CAAFQd5A7AjLYish6cQA3p5VFMQgx9g-W3uf6s1BZFnHtF9oJ9Q@mail.gmail.com>
Subject: Re: [RFC] Request API questions
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, nicolas@ndufresne.ca
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 21, 2018 at 7:00 PM Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> On Fri, Aug 17, 2018 at 12:09:40PM +0200, Hans Verkuil wrote:
> > On 17/08/18 12:02, Tomasz Figa wrote:
> > > On Thu, Aug 16, 2018 at 8:15 PM Mauro Carvalho Chehab
> > > <mchehab+samsung@kernel.org> wrote:
> > >>
> > >> Em Thu, 16 Aug 2018 12:25:25 +0200
> > >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > >>
> > >>> Laurent raised a few API issues/questions in his review of the documentation.
> > >>>
> > >>> I've consolidated those in this RFC. I would like to know what others think
> > >>> and if I should make changes.
> > >
> > > Thanks Hans for a nice summary and Mauro for initial input. :)
> > >
> > >>>
> > >>> 1) Should you be allowed to set controls directly if they are also used in
> > >>>    requests? Right now this is allowed, although we warn in the spec that
> > >>>    this can lead to undefined behavior.
> > >>>
> > >>>    In my experience being able to do this is very useful while testing,
> > >>>    and restricting this is not all that easy to implement. I also think it is
> > >>>    not our job. It is not as if something will break when you do this.
> > >>>
> > >>>    If there really is a good reason why you can't mix this for a specific
> > >>>    control, then the driver can check this and return -EBUSY.
> > >>
> > >> IMHO, there's not much sense on preventing it. Just having a warning
> > >> at the spec is enough.
> > >>
> > >
> > > I tend to agree with Mauro on this.
> > >
> > > Besides testing, there are some legit use cases where a carefully
> > > programmed user space may want to choose between setting controls
> > > directly and via a request, depending on circumstances. For example,
> > > one may want to set focus position alone (potentially a big step,
> > > taking time), before even attempting to capture any frames and then,
> > > when the capture starts, move the position gradually (in small steps,
> > > not taking too much time) with subsequent requests, to obtain a set of
> > > frames with different focus position.
> > >
> > >> +.. caution::
> > >> +
> > >> +   Setting the same control through a request and also directly can lead to
> > >> +   undefined behavior!
> > >>
> > >> It is already warned with a caution. Anyone that decides to ignore a
> > >> warning like that will deserve his faith if things stop work.
> > >>
> > >>>
> > >>> 2) If request_fd in QBUF or the control ioctls is not a request fd, then we
> > >>>    now return ENOENT. Laurent suggests using EBADR ('Invalid request descriptor')
> > >>>    instead. This seems like a good idea to me. Should I change this?
> > >>
> > >> I don't have a strong opinion, but EBADR value seems to be arch-dependent:
> > >>
> > >> arch/alpha/include/uapi/asm/errno.h:#define     EBADR           98      /* Invalid request descriptor */
> > >> arch/mips/include/uapi/asm/errno.h:#define EBADR                51      /* Invalid request descriptor */
> > >> arch/parisc/include/uapi/asm/errno.h:#define    EBADR           161     /* Invalid request descriptor */
> > >> arch/sparc/include/uapi/asm/errno.h:#define     EBADR           103     /* Invalid request descriptor */
> > >> include/uapi/asm-generic/errno.h:#define        EBADR           53      /* Invalid request descriptor */
> > >>
> > >> Also, just because its name says "invalid request", it doesn't mean that it
> > >> is the right error code. In this specific case, we're talking about a file
> > >> descriptor. Invalid file descriptors is something that the FS subsystem
> > >> has already a defined set of return codes. We should stick with whatever
> > >> FS uses when a file descriptor is invalid.
> > >>
> > >> Where the VFS code returns EBADR? Does it make sense for our use cases?
> > >>
> > >
> > > DMA-buf framework seems to return -EINVAL if a non-DMA-buf FD is
> > > passed to dma_buf_get():
> > > https://elixir.bootlin.com/linux/v4.18.1/source/drivers/dma-buf/dma-buf.c#L497
> > >
> > >>>
> > >>> 3) Calling VIDIOC_G_EXT_CTRLS for a request that has not been queued yet will
> > >>>    return either the value of the control you set earlier in the request, or
> > >>>    the current HW control value if it was never set in the request.
> > >>>
> > >>>    I believe it makes sense to return what was set in the request previously
> > >>>    (if you set it, you should be able to get it), but it is an idea to return
> > >>>    ENOENT when calling this for controls that are NOT in the request.
> > >>>
> > >>>    I'm inclined to implement that. Opinions?
> > >>
> > >> Return the request "cached" value, IMO, doesn't make sense. If the
> > >> application needs such cache, it can implement itself.
> > >
> > > Can we think about any specific use cases for a user space that first
> > > sets a control value to a request and then needs to ask the kernel to
> > > get the value back? After all, it was the user space which set the
> > > value, so I'm not sure if there is any need for the kernel to be an
> > > intermediary here.
> > >
> > >>
> > >> Return an error code if the request has not yet completed makes
> > >> sense. Not sure what would be the best error code here... if the
> > >> request is queued already (but not processed), EBUSY seems to be the
> > >> better choice, but, if it was not queued yet, I'm not sure. I guess
> > >> ENOENT would work.
> > >
> > > IMHO, as far as we assign unique error codes for different conditions
> > > and document them well, we should be okay with any not absurdly
> > > mismatched code. After all, most of those codes are defined for file
> > > system operations and don't really map directly to anything else.
> > >
> > > FYI, VIDIOC_G_(EXT_)CTRL returns EINVAL if an unsupported control is
> > > queried, so if we decided to keep the "cache" functionality after all,
> > > perhaps we should stay consistent with it?
> > > Reference: https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-ext-ctrls.html#return-value
> > >
> > > My suggestion would be:
> > >  - EINVAL: the control was not in the request, (if we keep the cache
> > > functionality)
> > >  - EPERM: the value is not ready, (we selected this code for Decoder
> > > Interface to mean that CAPTURE format is not ready, which is similar;
> > > perhaps that could be consistent?)
> > >
> > > Note that EINVAL would only apply to writable controls, while EPERM
> > > only to volatile controls, since the latter can only change due to
> > > request completion (non-volatile controls can only change as an effect
> > > of user space action).
> > >
> >
> > I'm inclined to just always return EPERM when calling G_EXT_CTRLS for
> > a request. We can always relax this in the future.
> >
> > So when a request is not yet queued G_EXT_CTRLS returns EPERM, when
> > queued but not completed it returns EBUSY and once completed it will
> > work as it does today.
>
> It may not be trivial to figure out the state of the request when a control
> is being accessed. Besides, it could conceivably change during the IOCTL call.
>
> How about just using EPERM (or EBUSY) in all cases?

+1 for the other reasons I mentioned in my another reply too.

Best regards,
Tomasz
