Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51432 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTLP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 07:15:59 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Lucas Stach' <l.stach@pengutronix.de>
Cc: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	'Inki Dae' <daeinki@gmail.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
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
In-reply-to: <1371723063.4114.12.camel@weser.hi.pengutronix.de>
Subject: RE: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
 framework
Date: Thu, 20 Jun 2013 20:15:57 +0900
Message-id: <010801ce6da7$896affe0$9c40ffa0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Lucas Stach [mailto:l.stach@pengutronix.de]
> Sent: Thursday, June 20, 2013 7:11 PM
> To: Inki Dae
> Cc: 'Russell King - ARM Linux'; 'Inki Dae'; 'linux-fbdev'; 'YoungJun Cho';
> 'Kyungmin Park'; 'myungjoo.ham'; 'DRI mailing list'; linux-arm-
> kernel@lists.infradead.org; linux-media@vger.kernel.org
> Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
> framework
> 
> Am Donnerstag, den 20.06.2013, 17:24 +0900 schrieb Inki Dae:
> [...]
> > > > In addition, please see the below more detail examples.
> > > >
> > > > The conventional way (without dmabuf-sync) is:
> > > > Task A
> > > > ----------------------------
> > > >  1. CPU accesses buf
> > > >  2. Send the buf to Task B
> > > >  3. Wait for the buf from Task B
> > > >  4. go to 1
> > > >
> > > > Task B
> > > > ---------------------------
> > > > 1. Wait for the buf from Task A
> > > > 2. qbuf the buf
> > > >     2.1 insert the buf to incoming queue
> > > > 3. stream on
> > > >     3.1 dma_map_sg if ready, and move the buf to ready queue
> > > >     3.2 get the buf from ready queue, and dma start.
> > > > 4. dqbuf
> > > >     4.1 dma_unmap_sg after dma operation completion
> > > >     4.2 move the buf to outgoing queue
> > > > 5. back the buf to Task A
> > > > 6. go to 1
> > > >
> > > > In case that two tasks share buffers, and data flow goes from Task A
> to
> > > Task
> > > > B, we would need IPC operation to send and receive buffers properly
> > > between
> > > > those two tasks every time CPU or DMA access to buffers is started
> or
> > > > completed.
> > > >
> > > >
> > > > With dmabuf-sync:
> > > >
> > > > Task A
> > > > ----------------------------
> > > >  1. dma_buf_sync_lock <- synpoint (call by user side)
> > > >  2. CPU accesses buf
> > > >  3. dma_buf_sync_unlock <- syncpoint (call by user side)
> > > >  4. Send the buf to Task B (just one time)
> > > >  5. go to 1
> > > >
> > > >
> > > > Task B
> > > > ---------------------------
> > > > 1. Wait for the buf from Task A (just one time)
> > > > 2. qbuf the buf
> > > >     1.1 insert the buf to incoming queue
> > > > 3. stream on
> > > >     3.1 dma_buf_sync_lock <- syncpoint (call by kernel side)
> > > >     3.2 dma_map_sg if ready, and move the buf to ready queue
> > > >     3.3 get the buf from ready queue, and dma start.
> > > > 4. dqbuf
> > > >     4.1 dma_buf_sync_unlock <- syncpoint (call by kernel side)
> > > >     4.2 dma_unmap_sg after dma operation completion
> > > >     4.3 move the buf to outgoing queue
> > > > 5. go to 1
> > > >
> > > > On the other hand, in case of using dmabuf-sync, as you can see the
> > > above
> > > > example, we would need IPC operation just one time. That way, I
> think we
> > > > could not only reduce performance overhead but also make user
> > > application
> > > > simplified. Of course, this approach can be used for all DMA device
> > > drivers
> > > > such as DRM. I'm not a specialist in v4l2 world so there may be
> missing
> > > > point.
> > > >
> > >
> > > You already need some kind of IPC between the two tasks, as I suspect
> > > even in your example it wouldn't make much sense to queue the buffer
> > > over and over again in task B without task A writing anything to it.
> So
> > > task A has to signal task B there is new data in the buffer to be
> > > processed.
> > >
> > > There is no need to share the buffer over and over again just to get
> the
> > > two processes to work together on the same thing. Just share the fd
> > > between both and then do out-of-band completion signaling, as you need
> > > this anyway. Without this you'll end up with unpredictable behavior.
> > > Just because sync allows you to access the buffer doesn't mean it's
> > > valid for your use-case. Without completion signaling you could easily
> > > end up overwriting your data from task A multiple times before task B
> > > even tries to lock the buffer for processing.
> > >
> > > So the valid flow is (and this already works with the current APIs):
> > > Task A                                    Task B
> > > ------                                    ------
> > > CPU access buffer
> > >          ----------completion signal--------->
> > >                                           qbuf (dragging buffer into
> > >                                           device domain, flush caches,
> > >                                           reserve buffer etc.)
> > >                                                     |
> > >                                           wait for device operation to
> > >                                           complete
> > >                                                     |
> > >                                           dqbuf (dragging buffer back
> > >                                           into CPU domain, invalidate
> > >                                           caches, unreserve)
> > >         <---------completion signal------------
> > > CPU access buffer
> > >
> >
> > Correct. In case that data flow goes from A to B, it needs some kind
> > of IPC between the two tasks every time as you said. Then, without
> > dmabuf-sync, how do think about the case that two tasks share the same
> > buffer but these tasks access the buffer(buf1) as write, and data of
> > the buffer(buf1) isn't needed to be shared?
> >
> Sorry, I don't see the point you are trying to solve here. If you share
> a buffer and want its content to be clearly defined at every point in
> time you have to synchronize the tasks working with the buffer, not just
> the buffer accesses itself.
> 
> Easiest way to do so is doing sync through userspace with out-of-band
> IPC, like in the example above.

In my opinion, that's not definitely easiest way. What I try to do is to avoid using *the out-of-band IPC*. As I mentioned in document file, the conventional mechanism not only makes user application complicated-user process needs to understand how the device driver is worked-but also may incur performance overhead by using the out-of-band IPC. The above my example may not be enough to you but there would be other cases able to use my approach efficiently.

> A more advanced way to achieve this
> would be using cross-device fences to avoid going through userspace for
> every syncpoint.
> 

Ok, maybe there is something I missed. So question. What is the cross-device fences? dma fence?. And how we can achieve the synchronization mechanism without going through user space for every syncpoint; CPU and DMA share a same buffer?. And could you explain it in detail as long as possible like I did?

> >
> > With dmabuf-sync is:
> >
> >  Task A
> >  ----------------------------
> >  1. dma_buf_sync_lock <- synpoint (call by user side)
> >  2. CPU writes something to buf1
> >  3. dma_buf_sync_unlock <- syncpoint (call by user side)
> >  4. copy buf1 to buf2
> Random contents here? What's in the buffer, content from the CPU write,
> or from V4L2 device write?
> 

Please presume that buf1 is physically non contiguous memory, and buf2 is physically contiguous memory; device A without IOMMU is seeing buf2. We would need to copy buf1 to buf2 to send the contents of the buf1 to device A because DMA of the device A cannot access the buf1 directly. And CPU and V4L2 device don't share the contents of the buf1 but share the buf1 as storage.

Thanks,
Inki Dae

> >  5. go to 1
> >
> >
> >  Task B
> >  ---------------------------
> >  1. dma_buf_sync_lock
> >  2. CPU writes something to buf3
> >  3. dma_buf_sync_unlock
> >  4. qbuf the buf3(src) and buf1(dst)
> >      4.1 insert buf3,1 to incoming queue
> >      4.2 dma_buf_sync_lock <- syncpoint (call by kernel side)
> >  5. stream on
> >      5.1 dma_map_sg if ready, and move the buf to ready queue
> >      5.2 get the buf from ready queue, and dma start.
> >  6. dqbuf
> >      6.1 dma_buf_sync_unlock <- syncpoint (call by kernel side)
> >      6.2 dma_unmap_sg after dma operation completion
> >      6.3 move the buf3,1 to outgoing queue
> > 7. go to 1
> >
> 
> Regards,
> Lucas
> --
> Pengutronix e.K.                           | Lucas Stach                 |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

