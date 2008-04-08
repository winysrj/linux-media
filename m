Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38HB8va017952
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 13:11:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38HAtG3029678
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 13:10:55 -0400
Date: Tue, 8 Apr 2008 14:10:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aidan Thornton" <makosoft@googlemail.com>
Message-ID: <20080408141038.647e7ec0@gaivota>
In-Reply-To: <c8b4dbe10804080947g1923f6b8yac90e63ef0a18d4a@mail.gmail.com>
References: <20080408145826.GA17398@plankton.public.utexas.edu>
	<c8b4dbe10804080947g1923f6b8yac90e63ef0a18d4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: changeset: 7516:e59033a1b38f summary: videobuf-vmalloc: fix
 STREAMOFF/STREAMON
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

On Tue, 8 Apr 2008 17:47:53 +0100
"Aidan Thornton" <makosoft@googlemail.com> wrote:

> Hi,
> 
> On Tue, Apr 8, 2008 at 3:58 PM, Brandon Philips <brandon@ifup.org> wrote:
> > From: http://linuxtv.org/hg/~mchehab/em28xx-vb
> >
> >  > diff --git a/linux/drivers/media/video/videobuf-vmalloc.c b/linux/drivers/media/video/videobuf-vmalloc.c
> >  > --- a/linux/drivers/media/video/videobuf-vmalloc.c
> >  > +++ b/linux/drivers/media/video/videobuf-vmalloc.c
> >  > @@ -78,6 +79,18 @@ videobuf_vm_close(struct vm_area_struct
> >  >
> >  >                       if (q->bufs[i]->map != map)
> >  >                               continue;
> >  > +
> >  > +                     mem = q->bufs[i]->priv;
> >  > +                     if (mem) {
> >  > +                             /* This callback is called only if kernel has
> >  > +                                allocated memory and this memory is mmapped.
> >  > +                                In this case, memory should be freed,
> >  > +                                in order to do memory unmap.
> >  > +                              */
> >  > +                             MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
> >  > +                             vfree(mem->vmalloc);
> >  > +                             mem->vmalloc = NULL;
> >  > +                     }
> >
> >  Will this work?  The code only holds the vb_lock but the drivers protect
> >  the vmalloc area with a spinlock.  I don't think we can free this
> >  without the spinlock too or the driver will be copying to a free'd area.
> 
> Yeah, it does seem like that. Of couse, holding the spinlock probably
> won't be enough, since I think there'll still be buffers queued
> without any actual memory associated, and that'll trigger the BUG_ON
> in videobuf_to_vmalloc.

Good point. maybe a spinlock_irq_save would solve this, since the videobuf
handling occurs at IRQ time.

It should be noticed, however that the videobuf_vm_close() is called
automagically by the kernel memory handlers, when vm usage count is 0. There's
no explicit call to it. 

I suspect that this will only happen at the close() callback. If so, the bug
will happen only if you don't stop streaming before closing the file handler.
However, don't stopping streaming after close will probably rise other bugs.

This code is not called if you simply do a streamoff(). While streamoff
releases all buffers, mmapped memory count is still equal to 1.

So, I don't believe that we might have an oops here.

> >  It seems we need a reference count on the buffers to do this right.

There is a reference count for the mapping. The code is called only after
having usage equal to 0.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
