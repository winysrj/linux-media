Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51740 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZG2XFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 19:05:40 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: How to save number of times using memcpy?
Date: Thu, 30 Jul 2009 01:07:12 +0200
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=C3=AB=C2=B0=E2=80=A2=C3=AA=C2=B2=C2=BD=C3=AB=C2=AF=C2=BC?=
	<kyungmin.park@samsung.com>,
	"jm105.lee@samsung.com" <jm105.lee@samsung.com>,
	=?utf-8?q?=C3=AC=EF=BF=BD=C2=B4=C3=AC=E2=80=9E=C2=B8=C3=AB=C2=AC=C2=B8?=
	<semun.lee@samsung.com>,
	=?utf-8?q?=C3=AB=C5=92=E2=82=AC=C3=AC=EF=BF=BD=C2=B8=C3=AA=C2=B8=C2=B0?=
	<inki.dae@samsung.com>,
	=?utf-8?q?=C3=AA=C2=B9=E2=82=AC=C3=AD=CB=9C=E2=80=A2=C3=AC=C2=A4?=
	 =?utf-8?q?=E2=82=AC?= <riverful.kim@samsung.com>
References: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl> <A69FA2915331DC488A831521EAE36FE401450FAE31@dlee06.ent.ti.com> <200907292352.00179.hverkuil@xs4all.nl>
In-Reply-To: <200907292352.00179.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907300107.13036.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 29 July 2009 23:52:00 Hans Verkuil wrote:
> On Wednesday 29 July 2009 21:06:17 Karicheri, Muralidharan wrote:
> > Hans,
> >
> > >True. However, my experience is that this approach isn't needed in most
> > >cases as long as the v4l driver is compiled into the kernel. In that
> > > case it is called early enough in the boot sequence that there is still
> > > enough unfragmented memory available. This should definitely be the
> > > default case for drivers merged into v4l-dvb.
> >
> > In my understanding, the buffer is allocated in the video buffer layer
> > when driver makes the videobuf_reqbufs() call.
>
> That depends completely on the driver implementation. In the case of the
> davinci driver it will allocate memory for X buffers when the driver is
> first initialized and it will use those when the application calls reqbufs.
> If the app wants more than X buffers the driver will attempt to dynamically
> allocate additional buffers, but those are usually hard to obtain.
>
> In my experience there is no problem for the driver to allocate the
> required memory if it is done during driver initialization and if the
> driver is compiled into the kernel.
>
> > Since this happens after
> > the kernel is up, this is indeed a serious issue when we require HD
> > resolution buffers. When I have tested vpfe capture from MT9T031 with
> > 2048x1536 resolution buffer, the video buffer layer gives an oops due to
> > failure to allocate buffer( I think video buffer layer is not handling
> > error case when there are not enough buffers to allocate). Since buffer
> > allocation happens very late (not at initialization), it is unlikely to
> > succeed due to fragmentation issue.
>
> That is really a driver problem: omap should use the same allocation scheme
> as davinci does. That works pretty reliably. Of course, if someone tries to
> squeeze the last drop out of their system, then they still may have to use
> nasty tricks to get it to work (like using the mem= kernel option). But
> such tricks are a last resort in my opinion.
>
> > So I have added support for USERPTR
> > IO in vpfe capture to handle high resolution capture. This requires a
> > kernel module to allocate contiguous buffer and the same is returned to
> > application using an IOCTL. The physical/logical address can then be
> > given to driver through USERPTR IO.
>
> What exactly is the point of doing this? I gather it is used to pass the
> same physical memory from e.g. a capture device to e.g. a resizer device,
> right? Otherwise I see no benefit to doing this as opposed to regular mmap
> I/O.

This could be used in conjunction with reserved memory to allocate bug buffers 
in userspace when not enough contiguous pages can be allocated from 
kernelspace.

Assume a device with 128MB (0x08000000) of SDRAM, mapped in physical memory at 
address 0x80000000. If you pass mem=80M to the kernel, a userspace process 
could (with appropriate permissions, and assuming it actually works :-)) do

size_t length = 48 << 20;
off_t address = 0x80000000 + (128 << 20) - (48 << 20);

fd = open("/dev/mem", O_RDWR);
mem = mmap(NULL, length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, address);

to get a pointer to 48MB area of reserved physical memory, and allocate big 
USERPTR buffers from that.

Regards,

Laurent Pinchart

