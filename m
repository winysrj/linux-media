Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZG2Dz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 23:55:58 -0400
Date: Wed, 29 Jul 2009 00:55:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Cc: v4l2_linux <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
	jm105.lee@samsung.com,
	=?UTF-8?B?7J207IS4?= =?UTF-8?B?66y4?= <semun.lee@samsung.com>,
	=?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>
Subject: Re: How to save number of times using memcpy?
Message-ID: <20090729005551.79430fe5@pedra.chehab.org>
In-Reply-To: <5e9665e10907282030i7d25c6e4se1d52eff321da8e3@mail.gmail.com>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com>
	<20090728003548.1a99224a@pedra.chehab.org>
	<5e9665e10907282030i7d25c6e4se1d52eff321da8e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Jul 2009 12:30:19 +0900
"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> escreveu:

> Sorry my bad. I missed something very important to explain my issue clear.
> The thing is, I want to reserve specific amount of continuous physical
> memory on machine initializing time. Therefor some multimedia
> peripherals can be using this memory area exclusively.
> That's what I was afraid of could not being adopted in main line kernel.

In the past, some drivers used to do that, but this is also a source
of problems, especially with general-purpose machines, where you're loosing
memory that could otherwise be used by something else. I never tried to get the
details, but I think the strategy were to pass a parameter during kernel boot,
for it to reserve some amount of memory that would later be claimed by the V4L
device.

> And if I use reserved memory on purpose, I might have problem using
> videobuf because it uses dma_alloc_coherent() anyway.

It is a matter of testing and adjusting it, if needed. Feel free to propose
improvements on it as needed.

> > There's also an special type of transfer called overlay mode. On the overlay
> > mode, the DMA transfers are mapped directly into the output device.
> >
> > In general, the drivers that implement overlay mode also mmap(), but this is
> > done, on those drivers, via a separate DMA transfer.
> >
> > The applications that benefit with overlay mode, uses overlay for display and
> > mmap for record, and may have different resolutions on each mode.
> >
> 
> Yes I think if I'm getting right, I have similar feature which is
> transferring data from camera interface to frame buffer with FIFO
> pipeline.
> And I consider this as an overlay feature.

It seems so. By using overlay, you'll avoid memcpy the data.

> I hope I could participate in cutting edge Linux technology with my works.
> As far as I know, there are plenty of areas need to be improved for
> camera devices in Linux kernel.

Welcome to the team! For sure there are lots of work, especially when looking
at embedded hardware needs. For a long time, most of V4L work were focused only
on PC running at i386 architecture. Over the last years, some work is done to
make it more generic and to enhance V4L to better support other architectures.



Cheers,
Mauro
