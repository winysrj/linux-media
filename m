Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45863 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZG2TEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 15:04:39 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: How to save number of times using memcpy?
Date: Wed, 29 Jul 2009 21:06:11 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?euc-kr?q?=C0=CC=BC=BC=B9=AE?= <semun.lee@samsung.com>,
	=?euc-kr?q?=B4=EB=C0=CE=B1=E2?= <inki.dae@samsung.com>,
	=?euc-kr?q?=B1=E8=C7=FC=C1=D8?= <riverful.kim@samsung.com>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com> <200907290926.41488.laurent.pinchart@skynet.be> <A69FA2915331DC488A831521EAE36FE401450FADF1@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401450FADF1@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907292106.11862.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 29 July 2009 20:36:25 Karicheri, Muralidharan wrote:
> <Snip>
>
> > > the details, but I think the strategy were to pass a parameter during
> > > kernel boot, for it to reserve some amount of memory that would later be
> > > claimed by the V4L device.
> >
> > It's actually a pretty common strategy for embedded hardware (the
> > "general- purpose machine" case doesn't - for now - make much sense on an
> > OMAP processor for instance). A memory chunk would be reserved at boot
> > time at the end of the physical memory by passing the mem= parameter to
> > the kernel. Video applications would then mmap() /dev/mem to access that
> > memory (I'd have to check the details on that one, that's from my memory),
> > and pass the pointer the the v4l2 driver using userptr I/O. This requires
> > root privileges, and people usually don't care about that when the final
> > application is a camera (usually embedded in some device like a media
> > player, an IP camera, ...).
>
> Yes. This is exactly what we are doing in the case of davinci processors.
> We have a kernel module that uses memory from the end of SDRAM space and
> mmap it to application through a set of APIs. They allocate contiguous
> memory pools and return the same to application through IOCTLs. I have
> tested vpfe capture using this approach (but yet to push the same to v4l2
> community for review). The same approach may be used across other platforms
> as well. So doesn't it make sense to add this kernel module to the kernel
> tree so that everyone can use it?

What's wrong with mmap()'ing /dev/mem ? Why do you need a special driver ?

Regards,

Laurent Pinchart

