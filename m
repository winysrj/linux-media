Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36252 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3FUI4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 04:56:33 -0400
Message-ID: <1371804843.4114.49.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
 framework
From: Lucas Stach <l.stach@pengutronix.de>
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	'Inki Dae' <daeinki@gmail.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Fri, 21 Jun 2013 10:54:03 +0200
In-Reply-To: <010801ce6da7$896affe0$9c40ffa0$%dae@samsung.com>
References: <20130617182127.GM2718@n2100.arm.linux.org.uk>
	 <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
	 <20130618084308.GU2718@n2100.arm.linux.org.uk>
	 <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
	 <1371548849.4276.6.camel@weser.hi.pengutronix.de>
	 <008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com>
	 <1371637326.4230.24.camel@weser.hi.pengutronix.de>
	 <00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
	 <1371645247.4230.41.camel@weser.hi.pengutronix.de>
	 <CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
	 <20130619182925.GL2718@n2100.arm.linux.org.uk>
	 <00da01ce6d81$76eb3d60$64c1b820$%dae@samsung.com>
	 <1371714427.4230.64.camel@weser.hi.pengutronix.de>
	 <00db01ce6d8f$a3c23dd0$eb46b970$%dae@samsung.com>
	 <1371723063.4114.12.camel@weser.hi.pengutronix.de>
	 <010801ce6da7$896affe0$9c40ffa0$%dae@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 20.06.2013, 20:15 +0900 schrieb Inki Dae:
[...]
> > > > You already need some kind of IPC between the two tasks, as I suspect
> > > > even in your example it wouldn't make much sense to queue the buffer
> > > > over and over again in task B without task A writing anything to it.
> > So
> > > > task A has to signal task B there is new data in the buffer to be
> > > > processed.
> > > >
> > > > There is no need to share the buffer over and over again just to get
> > the
> > > > two processes to work together on the same thing. Just share the fd
> > > > between both and then do out-of-band completion signaling, as you need
> > > > this anyway. Without this you'll end up with unpredictable behavior.
> > > > Just because sync allows you to access the buffer doesn't mean it's
> > > > valid for your use-case. Without completion signaling you could easily
> > > > end up overwriting your data from task A multiple times before task B
> > > > even tries to lock the buffer for processing.
> > > >
> > > > So the valid flow is (and this already works with the current APIs):
> > > > Task A                                    Task B
> > > > ------                                    ------
> > > > CPU access buffer
> > > >          ----------completion signal--------->
> > > >                                           qbuf (dragging buffer into
> > > >                                           device domain, flush caches,
> > > >                                           reserve buffer etc.)
> > > >                                                     |
> > > >                                           wait for device operation to
> > > >                                           complete
> > > >                                                     |
> > > >                                           dqbuf (dragging buffer back
> > > >                                           into CPU domain, invalidate
> > > >                                           caches, unreserve)
> > > >         <---------completion signal------------
> > > > CPU access buffer
> > > >
> > >
> > > Correct. In case that data flow goes from A to B, it needs some kind
> > > of IPC between the two tasks every time as you said. Then, without
> > > dmabuf-sync, how do think about the case that two tasks share the same
> > > buffer but these tasks access the buffer(buf1) as write, and data of
> > > the buffer(buf1) isn't needed to be shared?
> > >
> > Sorry, I don't see the point you are trying to solve here. If you share
> > a buffer and want its content to be clearly defined at every point in
> > time you have to synchronize the tasks working with the buffer, not just
> > the buffer accesses itself.
> > 
> > Easiest way to do so is doing sync through userspace with out-of-band
> > IPC, like in the example above.
> 
> In my opinion, that's not definitely easiest way. What I try to do is
> to avoid using *the out-of-band IPC*. As I mentioned in document file,
> the conventional mechanism not only makes user application
> complicated-user process needs to understand how the device driver is
> worked-but also may incur performance overhead by using the
> out-of-band IPC. The above my example may not be enough to you but
> there would be other cases able to use my approach efficiently.
> 

Yeah, you'll some knowledge and understanding about the API you are
working with to get things right. But I think it's not an unreasonable
thing to expect the programmer working directly with kernel interfaces
to read up on how things work.

Second thing: I'll rather have *one* consistent API for every subsystem,
even if they differ from each other than having to implement this
syncpoint thing in every subsystem. Remember: a single execbuf in DRM
might reference both GEM objects backed by dma-buf as well native SHM or
CMA backed objects. The dma-buf-mgr proposal already allows you to
handle dma-bufs much the same way during validation than native GEM
objects.

And to get back to my original point: if you have more than one task
operating together on a buffer you absolutely need some kind of real IPC
to sync them up and do something useful. Both you syncpoints and the
proposed dma-fences only protect the buffer accesses to make sure
different task don't stomp on each other. There is nothing in there to
make sure that the output of your pipeline is valid. You have to take
care of that yourself in userspace. I'll reuse your example to make it
clear what I mean:

Task A                                         Task B
------                                         -------
dma_buf_sync_lock(buf1)
CPU write buf1
dma_buf_sync_unlock(buf1)
          ---------schedule Task A again-------
dma_buf_sync_lock(buf1)
CPU write buf1
dma_buf_sync_unlock(buf1)
            ---------schedule Task B---------
                                               qbuf(buf1)
                                                  dma_buf_sync_lock(buf1)
                                               ....

This is what can happen if you don't take care of proper syncing. Task A
writes something to the buffer in expectation that Task B will take care
of it, but before Task B even gets scheduled Task A overwrites the
buffer again. Not what you wanted, isn't it?

So to make sure the output of a pipeline of some kind is what you expect
you have to do syncing with IPC. And once you do CPU access it is a
synchronous thing in the stream of events. I see that you might want to
have some kind of bracketed CPU access even for the fallback mmap case
for things like V4L2 that don't provide explicit sync by their own, but
in no way I can see why we would need a user/kernel shared syncpoint for
this.

> > A more advanced way to achieve this
> > would be using cross-device fences to avoid going through userspace for
> > every syncpoint.
> > 
> 
> Ok, maybe there is something I missed. So question. What is the
> cross-device fences? dma fence?. And how we can achieve the
> synchronization mechanism without going through user space for every
> syncpoint; CPU and DMA share a same buffer?. And could you explain it
> in detail as long as possible like I did?
> 
Yeah I'm talking about the proposed dma-fences. They would allow you to
just queue things into the kernel without waiting for a device operation
to finish. But you still have to make sure that your commands have the
right order and don't go wild. So for example you could do something
like this:

Userspace                                   Kernel
---------                                   ------
1. build DRM command stream
rendering into buf1
2. queue command stream with execbuf
                                            1. validate command stream
                                             1.1 reference buf1 for writing
                                                 through dma-buf-mgr
                                            2. kick off GPU processing
3. qbuf buf1 into V4L2
                                            3. reference buf1 for reading
                                             3.1 wait for fence from GPU to
                                                 signal
                                            4. kick off V4L2 processing

So you don't need to wait in userspace and potentially avoid some
context switches, but you still have to make sure that GPU commands are
queued before you queue the V4L2 operation to make sure things get
operated on in the right order.

Regards,
Lucas

-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

