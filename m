Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43601 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSSdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 14:33:21 -0400
Date: Wed, 19 Jun 2013 19:29:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Inki Dae <daeinki@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	YoungJun Cho <yj44.cho@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130619182925.GL2718@n2100.arm.linux.org.uk>
References: <20130617182127.GM2718@n2100.arm.linux.org.uk> <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com> <20130618084308.GU2718@n2100.arm.linux.org.uk> <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com> <1371548849.4276.6.camel@weser.hi.pengutronix.de> <008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com> <1371637326.4230.24.camel@weser.hi.pengutronix.de> <00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com> <1371645247.4230.41.camel@weser.hi.pengutronix.de> <CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 20, 2013 at 12:10:04AM +0900, Inki Dae wrote:
> On the other hand, the below shows how we could enhance the conventional
> way with my approach (just example):
> 
> CPU -> DMA,
>         ioctl(qbuf command)              ioctl(streamon)
>               |                                               |
>               |                                               |
>         qbuf  <- dma_buf_sync_get   start streaming <- syncpoint
> 
> dma_buf_sync_get just registers a sync buffer(dmabuf) to sync object. And
> the syncpoint is performed by calling dma_buf_sync_lock(), and then DMA
> accesses the sync buffer.
> 
> And DMA -> CPU,
>         ioctl(dqbuf command)
>               |
>               |
>         dqbuf <- nothing to do
> 
> Actual syncpoint is when DMA operation is completed (in interrupt handler):
> the syncpoint is performed by calling dma_buf_sync_unlock().
> Hence,  my approach is to move the syncpoints into just before dma access
> as long as possible.

What you've just described does *not* work on architectures such as
ARMv7 which do speculative cache fetches from memory at any time that
that memory is mapped with a cacheable status, and will lead to data
corruption.
