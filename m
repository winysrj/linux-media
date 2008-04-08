Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38Kp7Ra014517
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 16:51:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38KorI5018559
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 16:50:53 -0400
Date: Tue, 8 Apr 2008 17:50:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aidan Thornton" <makosoft@googlemail.com>
Message-ID: <20080408175038.2966691d@gaivota>
In-Reply-To: <c8b4dbe10804081306xb1e8f91q64d1e6d18d3d2531@mail.gmail.com>
References: <patchbomb.1206699511@localhost>
	<ab74ebf10c01d6a8a54a.1206699517@localhost>
	<20080405131236.7c083554@gaivota>
	<20080406080011.GA3596@plankton.ifup.org>
	<20080407183226.703217fc@gaivota>
	<20080408152238.GA8438@plankton.public.utexas.edu>
	<20080408154046.36766131@gaivota>
	<c8b4dbe10804081306xb1e8f91q64d1e6d18d3d2531@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>, Brandon Philips <bphilips@suse.de>
Subject: Re: [PATCH 6 of 9] videobuf-vmalloc.c: Fix hack of postponing mmap
 on remap failure
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

> >  With 6/9 or with this patch, the allocation will happen when you try to use an
> >  mmap command. This can happen on streamon, reqbufs, dqbuf, qbuf or reqbuf.
> >
> >  Sorry, but I think I missed your point.
> 
> I think I agree with Brandon. Allocating the buffers in reqbufs is
> what the existing em28xx driver does. It saves a bit of complexity in
> that you just have to allocate the buffers from one place and it seems
> to be what the v4l2 API expects. (Apps have to call reqbufs first, but
> the API doesn't put any real restrictions on what order they
> mmap/munmap or queue/dequeue the buffers afterwards, and the API also
> forbids apps from calling reqbufs with the existing buffers mapped or
> streaming turned on which makes life easier). It's what I was going to
> suggest, actually.

I'm still missed. I don't see what's the difference on what patch 6/9 were
expecting to do and the proposed patch, in terms of adding a restriction of not
accepting other mmap commands, without getting a REQBUFS.

The current way that videobuf works is the one that userspace apps expect. If
we change videobuf behavior, for a given userspace API command, we risk to
break some userspace app.

> >  A fix could be to disable IRQ during that interval of time, and/or protecting
> >  with a spinlock.
> 
> What you're doing in the attached patch won't trigger the issue, since
> you're calling VIDIOC_STREAMOFF before munmap and that dequeues all
> buffers. Try removing the calls to stop_capturing and start_capturing
> around uninit_device / init_device. I haven't tried it, but you should
> be prepared to get a kernel panic.

The tests I did covers the issue of unmapping/remapping. As we've already
discussed, something else should be added to allow unmapping without streamoff.

The same kind of issue seems to apply also to videobuf-dma-sg. In fact, it is
even worse with dma: since buffers will be filled without CPU, just disabling
IRQ, or running a spinlock doesn't solve. You'll need to stop DMA before unmapping.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
