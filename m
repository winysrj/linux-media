Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58575 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZG2HZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 03:25:16 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: How to save number of times using memcpy?
Date: Wed, 29 Jul 2009 09:26:40 +0200
Cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
	jm105.lee@samsung.com,
	=?utf-8?q?=EC=9D=B4=EC=84=B8=EB=AC=B8?= <semun.lee@samsung.com>,
	=?utf-8?q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10907271756l114f6e6ekeefa04d976b95c66@mail.gmail.com> <5e9665e10907282030i7d25c6e4se1d52eff321da8e3@mail.gmail.com> <20090729005551.79430fe5@pedra.chehab.org>
In-Reply-To: <20090729005551.79430fe5@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907290926.41488.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 29 July 2009 05:55:51 Mauro Carvalho Chehab wrote:
> Em Wed, 29 Jul 2009 12:30:19 +0900
>
> "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> escreveu:
> > Sorry my bad. I missed something very important to explain my issue
> > clear. The thing is, I want to reserve specific amount of continuous
> > physical memory on machine initializing time. Therefor some multimedia
> > peripherals can be using this memory area exclusively.
> > That's what I was afraid of could not being adopted in main line kernel.
>
> In the past, some drivers used to do that, but this is also a source
> of problems, especially with general-purpose machines, where you're loosing
> memory that could otherwise be used by something else. I never tried to get
> the details, but I think the strategy were to pass a parameter during
> kernel boot, for it to reserve some amount of memory that would later be
> claimed by the V4L device.

It's actually a pretty common strategy for embedded hardware (the "general-
purpose machine" case doesn't - for now - make much sense on an OMAP processor 
for instance). A memory chunk would be reserved at boot time at the end of the 
physical memory by passing the mem= parameter to the kernel. Video 
applications would then mmap() /dev/mem to access that memory (I'd have to 
check the details on that one, that's from my memory), and pass the pointer 
the the v4l2 driver using userptr I/O. This requires root privileges, and 
people usually don't care about that when the final application is a camera 
(usually embedded in some device like a media player, an IP camera, ...).

Regards,

Laurent Pinchart

