Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46145 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935125Ab3FTI2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 04:28:34 -0400
Message-ID: <1371716771.4114.5.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
 framework
From: Lucas Stach <l.stach@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Inki Dae <inki.dae@samsung.com>, 'Inki Dae' <daeinki@gmail.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Thu, 20 Jun 2013 10:26:11 +0200
In-Reply-To: <20130620081733.GN2718@n2100.arm.linux.org.uk>
References: <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
	 <1371548849.4276.6.camel@weser.hi.pengutronix.de>
	 <008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com>
	 <1371637326.4230.24.camel@weser.hi.pengutronix.de>
	 <00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
	 <1371645247.4230.41.camel@weser.hi.pengutronix.de>
	 <CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
	 <20130619182925.GL2718@n2100.arm.linux.org.uk>
	 <00da01ce6d81$76eb3d60$64c1b820$%dae@samsung.com>
	 <1371714427.4230.64.camel@weser.hi.pengutronix.de>
	 <20130620081733.GN2718@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 20.06.2013, 09:17 +0100 schrieb Russell King - ARM
Linux:
> On Thu, Jun 20, 2013 at 09:47:07AM +0200, Lucas Stach wrote:
> > Am Donnerstag, den 20.06.2013, 15:43 +0900 schrieb Inki Dae:
> > > 
> > > > -----Original Message-----
> > > > From: dri-devel-bounces+inki.dae=samsung.com@lists.freedesktop.org
> > > > [mailto:dri-devel-bounces+inki.dae=samsung.com@lists.freedesktop.org] On
> > > > Behalf Of Russell King - ARM Linux
> > > > Sent: Thursday, June 20, 2013 3:29 AM
> > > > To: Inki Dae
> > > > Cc: linux-fbdev; DRI mailing list; Kyungmin Park; myungjoo.ham; YoungJun
> > > > Cho; linux-media@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> > > > Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
> > > > framework
> > > > 
> > > > On Thu, Jun 20, 2013 at 12:10:04AM +0900, Inki Dae wrote:
> > > > > On the other hand, the below shows how we could enhance the conventional
> > > > > way with my approach (just example):
> > > > >
> > > > > CPU -> DMA,
> > > > >         ioctl(qbuf command)              ioctl(streamon)
> > > > >               |                                               |
> > > > >               |                                               |
> > > > >         qbuf  <- dma_buf_sync_get   start streaming <- syncpoint
> > > > >
> > > > > dma_buf_sync_get just registers a sync buffer(dmabuf) to sync object.
> > > > And
> > > > > the syncpoint is performed by calling dma_buf_sync_lock(), and then DMA
> > > > > accesses the sync buffer.
> > > > >
> > > > > And DMA -> CPU,
> > > > >         ioctl(dqbuf command)
> > > > >               |
> > > > >               |
> > > > >         dqbuf <- nothing to do
> > > > >
> > > > > Actual syncpoint is when DMA operation is completed (in interrupt
> > > > handler):
> > > > > the syncpoint is performed by calling dma_buf_sync_unlock().
> > > > > Hence,  my approach is to move the syncpoints into just before dma
> > > > access
> > > > > as long as possible.
> > > > 
> > > > What you've just described does *not* work on architectures such as
> > > > ARMv7 which do speculative cache fetches from memory at any time that
> > > > that memory is mapped with a cacheable status, and will lead to data
> > > > corruption.
> > > 
> > > I didn't explain that enough. Sorry about that. 'nothing to do' means that a
> > > dmabuf sync interface isn't called but existing functions are called. So
> > > this may be explained again:
> > >         ioctl(dqbuf command)
> > >             |
> > >             |
> > >         dqbuf <- 1. dma_unmap_sg
> > >                     2. dma_buf_sync_unlock (syncpoint)
> > > 
> > > The syncpoint I mentioned means lock mechanism; not doing cache operation.
> > > 
> > > In addition, please see the below more detail examples.
> > > 
> > > The conventional way (without dmabuf-sync) is:
> > > Task A                             
> > > ----------------------------
> > >  1. CPU accesses buf          
> > >  2. Send the buf to Task B  
> > >  3. Wait for the buf from Task B
> > >  4. go to 1
> > > 
> > > Task B
> > > ---------------------------
> > > 1. Wait for the buf from Task A
> > > 2. qbuf the buf                 
> > >     2.1 insert the buf to incoming queue
> > > 3. stream on
> > >     3.1 dma_map_sg if ready, and move the buf to ready queue
> > >     3.2 get the buf from ready queue, and dma start.
> > > 4. dqbuf
> > >     4.1 dma_unmap_sg after dma operation completion
> > >     4.2 move the buf to outgoing queue
> > > 5. back the buf to Task A
> > > 6. go to 1
> > > 
> > > In case that two tasks share buffers, and data flow goes from Task A to Task
> > > B, we would need IPC operation to send and receive buffers properly between
> > > those two tasks every time CPU or DMA access to buffers is started or
> > > completed.
> > > 
> > > 
> > > With dmabuf-sync:
> > > 
> > > Task A                             
> > > ----------------------------
> > >  1. dma_buf_sync_lock <- synpoint (call by user side)
> > >  2. CPU accesses buf          
> > >  3. dma_buf_sync_unlock <- syncpoint (call by user side)
> > >  4. Send the buf to Task B (just one time)
> > >  5. go to 1
> > > 
> > > 
> > > Task B
> > > ---------------------------
> > > 1. Wait for the buf from Task A (just one time)
> > > 2. qbuf the buf                 
> > >     1.1 insert the buf to incoming queue
> > > 3. stream on
> > >     3.1 dma_buf_sync_lock <- syncpoint (call by kernel side)
> > >     3.2 dma_map_sg if ready, and move the buf to ready queue
> > >     3.3 get the buf from ready queue, and dma start.
> > > 4. dqbuf
> > >     4.1 dma_buf_sync_unlock <- syncpoint (call by kernel side)
> > >     4.2 dma_unmap_sg after dma operation completion
> > >     4.3 move the buf to outgoing queue
> > > 5. go to 1
> > > 
> > > On the other hand, in case of using dmabuf-sync, as you can see the above
> > > example, we would need IPC operation just one time. That way, I think we
> > > could not only reduce performance overhead but also make user application
> > > simplified. Of course, this approach can be used for all DMA device drivers
> > > such as DRM. I'm not a specialist in v4l2 world so there may be missing
> > > point.
> > > 
> > 
> > You already need some kind of IPC between the two tasks, as I suspect
> > even in your example it wouldn't make much sense to queue the buffer
> > over and over again in task B without task A writing anything to it. So
> > task A has to signal task B there is new data in the buffer to be
> > processed.
> 
> Hang on.  Since when did dma_buf become another inter-process IPC
> mechanism?  That's *not* it's design goal, and there's other much
> better mechanisms already provided.
> 
That's why I said out-of-band completion signaling, particularly not
bound to the dma-buf itself.

My thinking was more along the lines of the wayland protocol, where one
process tells the compositor to use a buf as the pixel data for the next
frame and promises not to access it while the compositor uses it. When
the compositor finishes it tells the client that it's now free to reuse
the buffer. None of this is bound to the dma-buf.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

