Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38Lc2Wp015332
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 17:38:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38Lbpdf022090
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 17:37:51 -0400
Date: Tue, 8 Apr 2008 18:37:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <bphilips@suse.de>
Message-ID: <20080408183740.143c3dee@gaivota>
In-Reply-To: <20080408204514.GA6844@plankton.public.utexas.edu>
References: <patchbomb.1206699511@localhost>
	<ab74ebf10c01d6a8a54a.1206699517@localhost>
	<20080405131236.7c083554@gaivota>
	<20080406080011.GA3596@plankton.ifup.org>
	<20080407183226.703217fc@gaivota>
	<20080408152238.GA8438@plankton.public.utexas.edu>
	<20080408154046.36766131@gaivota>
	<20080408204514.GA6844@plankton.public.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
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

On Tue, 8 Apr 2008 13:45:14 -0700
Brandon Philips <bphilips@suse.de> wrote:

> > Sorry, but I think I missed your point.
> 
> Wow, that got jumbled.  What I meant to say was:
> 
> This patch allocates the vmalloc area when mmap() is called.  6/9
> allocates vmalloc during reqbuf.

Ah, ok. I don't see any technical issue of postponing vmalloc to be done on
iolock (but see bellow). The code will just become a little bit more complex.
On the other hand, I don't see any advantage, since vmalloc_user() doesn't
really alloc memory, AFAIK.

> I read the spec in such a way that once reqbuf is made the application
> can qbuf immediately without mmap'ing.  I may be mistaken though.

If you don't call REQBUF, vb->memory and baddr will be 0, as if you were doing a read().
The end result is that QBUF won't work. The same behaviour will also occur with your patch.

I've already tested this, by accident. No OOPS. it just returns -EINVAL.

> > > > +	case V4L2_MEMORY_USERPTR:
> > > > +	{
> > > 
> > > Why are you adding braces here?
> > > 
> > > > +		int pages = PAGE_ALIGN(vb->size);
> > 
> > To declare pages var on above code. without braces, a warning is generated.
> 
> I think that declarations should just go at the top of the function to
> avoid that.

Ok, I'll change it on a next patch.

> > Probably, in this case, we may have some troubles, due to vfree() if we get an
> > interrupt between:
> > 	vfree(mem->vmalloc)
> > 		and
> > 	mem->vmalloc=NULL.
> > 
> > A fix could be to disable IRQ during that interval of time, and/or protecting
> > with a spinlock.
> 
> Yes, protecting with a spinlock is required to release these buffers.
> 
> > I can't see any other issues. Btw, the same kind of code is also used on
> > videobuf-dma-sg, cafe-ccic, and several other USB drivers.
> 
> cafe-ccic does not free it's vmalloc area in the vm_close method.

True. The lock is needed. 

I'm not quite sure on how to properly protect videobuf-vmalloc and
videobuf-dma-sg against this kind of threat. Any suggestions? 

A lock for vmalloc would be easy, but the worse case seems to be dma, since a
transfer may be in course, while unmap is happening. I couldn't find any place
where this is handled on videobuf-dma-sg. I think that some drivers try to
handle it, by calling videobuf_dma_sync(). Yet, this seems to be a feature that
should be inside videobuf, not externally handled.

> 
> > > Really, I think the allocation should happen in REQBUF as I did.
> > 
> > By looking on your code, it didn't work previously, due to a bug on this line:
> > 
> > 	retval=remap_vmalloc_range(vma, mem->vmalloc,0);
> 
> What is wrong with this?

Before my patch, mem->vmalloc were equal to NULL.

That's why this were failing with em28xx: it needs FIRST to alloc something,
THEN remap it. 

If we move vmalloc to iolock, we'll need to move also remap_vmalloc_range to there. 

Moving remap_vmalloc_range() to iolock will also work properly, but it doesn't
seem to be right to use mmap() callback just to store some things to be handled
inside iolock. That's the reason why I've opted to move just the vmalloc to
__videobuf_mmap_mapper().

What were happening before my and your patches is that the above line (remap)
were always failing for real devices. So, there was another
remap_vmalloc_range() inside iolock. The last one were the one who were really
working for tm6000 and em28xx.

I dunno why, but, for vivi, it seems that the first vmalloc were actually
working.

> > Also, all userspace clients already do something like this, on buffer_prepare:
> > 
> >         if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
> >                 rc = videobuf_iolock(vq, &buf->vb, NULL);
> >                 if (rc < 0)
> >                         goto fail;
> >         }
> 
> Huh?  How do userspace apps use videobuf_iolock?!
 
I was meaning to say "videobuf clients".

What I tried to say is that you've added a similar code to this inside patch
6/9. It would be interesting if we could remove the above code from videobuf
clients to be handled internally, and simplifying the logic inside the drivers,
but this seems to be complicated, since buffer should be filled inside
buffer_prepare.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
