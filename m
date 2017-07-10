Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34015 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754455AbdGJT1T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:27:19 -0400
Received: by mail-qt0-f196.google.com with SMTP id m54so13920411qtb.1
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 12:27:18 -0700 (PDT)
Date: Mon, 10 Jul 2017 16:27:14 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
Message-ID: <20170710192714.GG10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
 <396bc2f8-eea6-82d5-c3b5-b8c2514af853@xs4all.nl>
 <20170707015346.GD10284@jade>
 <71e2f26a-37c8-de40-67e6-b9971e9fae37@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71e2f26a-37c8-de40-67e6-b9971e9fae37@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-07 Hans Verkuil <hverkuil@xs4all.nl>:

> On 07/07/2017 03:53 AM, Gustavo Padovan wrote:
> > > 
> > > >   	help
> > > >   	  If you want to use Webcams, Video grabber devices and/or TV devices
> > > >   	  enable this option and other options below.
> > > > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > > > index ea83126..29aa9d4 100644
> > 
> > > > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > > > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > > > @@ -1279,6 +1279,22 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> > > >   	return 0;
> > > >   }
> > > > +static int __get_num_ready_buffers(struct vb2_queue *q)
> > > > +{
> > > > +	struct vb2_buffer *vb;
> > > > +	int ready_count = 0;
> > > > +
> > > > +	/* count num of buffers ready in front of the queued_list */
> > > > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > > > +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > > > +			break;
> > > 
> > > Obviously the break is wrong as Mauro mentioned.
> > 
> > I replied this in the other email to Mauro, if a fence is not signaled
> > it is not ready te be queued by the driver nor is all buffers following
> > it. Hence the break. They need all to be in order and in front of the
> > queue.
> > 
> > In any case I'll check this again as now there is two people saying I'm
> > wrong! :)
> 
> I think this comes back to the 'ordered' requirement and what that means
> exactly. In this particular case if I have buffers queued up in vb2 without
> a fence (or the fence was signaled), why shouldn't it possible to queue them
> up to the driver right away?
> 
> Of course, if all buffers are waiting for a fence, then __get_num_ready_buffers
> returns 0 and nothing happens.
> 
> My understanding is that the ordered requirement is for the hardware,
> i.e. queueing buffers A, B, C to ordered hardware requires that they come
> out in the same order.

That is correct. I thought I had to queue to the hardware in the order we
receive from userspace. So that makes that loop indeed wrong, as we
should queue the buffers right away.

The ordered requirement is for the OUT_FENCE side because after we queue
the buffer to the hardware and send the BUF_QUEUED event out userspace
might just go ahead and issue an DRM Atomic Request containing that
buffer and the out-fence fd received. DRM then needs to wait on that
fence before any scanout, but it may wait after the scanout is not
allowed to fail anymore.

Thus if a buffer requeuing happens at buffer_done() the fence won't
signal and DRM/KMS won't have a buffer to display. That is reason behind
it.

Alternatively we can ignore this and live with the fact that sometimes a
requeuing may affect the scanout pipeline.

	Gustavo
