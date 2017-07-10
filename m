Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35625 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdGJUTy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 16:19:54 -0400
Received: by mail-qk0-f194.google.com with SMTP id 16so14313509qkg.2
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 13:19:54 -0700 (PDT)
Date: Mon, 10 Jul 2017 17:19:49 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 12/12] [media] vb2: add out-fence support to QBUF
Message-ID: <20170710201949.GL10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-13-gustavo@padovan.org>
 <aee01ccd-530b-4c93-6510-6b6acca7e7c0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aee01ccd-530b-4c93-6510-6b6acca7e7c0@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-06 Hans Verkuil <hverkuil@xs4all.nl>:

> On 06/16/17 09:39, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
> > an out_fence for the buffer and return it to userspace on the fence_fd
> > field. It only works with ordered queues.
> > 
> > The fence is signaled on buffer_done(), when the job on the buffer is
> > finished.
> > 
> > v2: check if the queue is ordered.
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-core.c |  6 ++++++
> >  drivers/media/v4l2-core/videobuf2-v4l2.c | 22 +++++++++++++++++++++-
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> > 
> 
> <snip>
> 
> > diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> > index e6ad77f..e2733dd 100644
> > --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> > +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> > @@ -204,9 +204,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> >  	b->timestamp = ns_to_timeval(vb->timestamp);
> >  	b->timecode = vbuf->timecode;
> >  	b->sequence = vbuf->sequence;
> > -	b->fence_fd = -1;
> > +	b->fence_fd = vb->out_fence_fd;
> 
> I forgot to ask: can a buffer have both an in and an out fence? If so, then we
> have a problem here since we can report only one fence fd.
> 
> If it is not allowed, then we need a check for that somewhere.

It is perfect fine to have both, I just wasn't expecting to get them out
from the kernel at the same time. In-fence is set by userspace in the
fence_fd field and then sent to the kernel, the field is then reused to
send the out-fence created in the kernel to userspace. That is how GPU
drivers do it.

	Gustavo
