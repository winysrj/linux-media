Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38935 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3FSMga (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 08:36:30 -0400
Message-ID: <1371645247.4230.41.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
 framework
From: Lucas Stach <l.stach@pengutronix.de>
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Wed, 19 Jun 2013 14:34:07 +0200
In-Reply-To: <00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
	 <1371467722-665-1-git-send-email-inki.dae@samsung.com>
	 <51BEF458.4090606@canonical.com>
	 <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
	 <20130617133109.GG2718@n2100.arm.linux.org.uk>
	 <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com>
	 <20130617154237.GJ2718@n2100.arm.linux.org.uk>
	 <CAAQKjZOokFKN85pygVnm7ShSa+O0ZzwxvQ0rFssgNLp+RO5pGg@mail.gmail.com>
	 <20130617182127.GM2718@n2100.arm.linux.org.uk>
	 <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
	 <20130618084308.GU2718@n2100.arm.linux.org.uk>
	 <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
	 <1371548849.4276.6.camel@weser.hi.pengutronix.de>
	 <008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com>
	 <1371637326.4230.24.camel@weser.hi.pengutronix.de>
	 <00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 19.06.2013, 19:44 +0900 schrieb Inki Dae:
> 
> > -----Original Message-----
> > From: Lucas Stach [mailto:l.stach@pengutronix.de]
> > Sent: Wednesday, June 19, 2013 7:22 PM
> > To: Inki Dae
> > Cc: 'Russell King - ARM Linux'; 'linux-fbdev'; 'Kyungmin Park'; 'DRI
> > mailing list'; 'myungjoo.ham'; 'YoungJun Cho'; linux-arm-
> > kernel@lists.infradead.org; linux-media@vger.kernel.org
> > Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
> > framework
> > 
> > Am Mittwoch, den 19.06.2013, 14:45 +0900 schrieb Inki Dae:
> > >
> > > > -----Original Message-----
> > > > From: Lucas Stach [mailto:l.stach@pengutronix.de]
> > > > Sent: Tuesday, June 18, 2013 6:47 PM
> > > > To: Inki Dae
> > > > Cc: 'Russell King - ARM Linux'; 'linux-fbdev'; 'Kyungmin Park'; 'DRI
> > > > mailing list'; 'myungjoo.ham'; 'YoungJun Cho'; linux-arm-
> > > > kernel@lists.infradead.org; linux-media@vger.kernel.org
> > > > Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer
> > synchronization
> > > > framework
> > > >
> > > > Am Dienstag, den 18.06.2013, 18:04 +0900 schrieb Inki Dae:
> > > > [...]
> > > > >
> > > > > > a display device driver.  It shouldn't be used within a single
> > driver
> > > > > > as a means of passing buffers between userspace and kernel space.
> > > > >
> > > > > What I try to do is not really such ugly thing. What I try to do is
> > to
> > > > > notify that, when CPU tries to access a buffer , to kernel side
> > through
> > > > > dmabuf interface. So it's not really to send the buffer to kernel.
> > > > >
> > > > > Thanks,
> > > > > Inki Dae
> > > > >
> > > > The most basic question about why you are trying to implement this
> > sort
> > > > of thing in the dma_buf framework still stands.
> > > >
> > > > Once you imported a dma_buf into your DRM driver it's a GEM object and
> > > > you can and should use the native DRM ioctls to prepare/end a CPU
> > access
> > > > to this BO. Then internally to your driver you can use the dma_buf
> > > > reservation/fence stuff to provide the necessary cross-device sync.
> > > >
> > >
> > > I don't really want that is used only for DRM drivers. We really need
> > > it for all other DMA devices; i.e., v4l2 based drivers. That is what I
> > > try to do. And my approach uses reservation to use dma-buf resources
> > > but not dma fence stuff anymore. However, I'm looking into Radeon DRM
> > > driver for why we need dma fence stuff, and how we can use it if
> > > needed.
> > >
> > 
> > Still I don't see the point why you need syncpoints above dma-buf. In
> > both the DRM and the V4L2 world we have defined points in the API where
> > a buffer is allowed to change domain from device to CPU and vice versa.
> > 
> > In DRM if you want to access a buffer with the CPU you do a cpu_prepare.
> > The buffer changes back to GPU domain once you do the execbuf
> > validation, queue a pageflip to the buffer or similar things.
> > 
> > In V4L2 the syncpoints for cache operations are the queue/dequeue API
> > entry points. Those are also the exact points to synchronize with other
> > hardware thus using dma-buf reserve/fence.
> 
> 
> If so, what if we want to access a buffer with the CPU _in V4L2_? We
> should open a drm device node, and then do a cpu_prepare? 
> 
Not at all. As I said the syncpoints are the queue/dequeue operations.
When dequeueing a buffer you are explicitly dragging the buffer domain
back from device into userspace and thus CPU domain.

If you are operating on an mmap of a V4L2 processed buffer it's either
before or after it got processed by the hardware and therefore all DMA
operations on the buffer are bracketed by the V4L2 qbug/dqbuf ioctls.
That is where cache operations and synchronization should happen. The
V4L2 driver shouldn't allow you to dequeue a buffer and thus dragging it
back into CPU domain while there is still DMA ongoing. Equally the queue
ioctrl should make sure caches are properly written back to memory. The
results of reading/writing to the mmap of a V4L2 buffer while it is
enqueued to the hardware is simply undefined and there is nothing
suggesting that this is a valid usecase.

Regards,
Lucas

-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

