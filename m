Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1398 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZG2HcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 03:32:00 -0400
Message-ID: <10799.62.70.2.252.1248852719.squirrel@webmail.xs4all.nl>
Date: Wed, 29 Jul 2009 09:31:59 +0200 (CEST)
Subject: Re: How to save number of times using memcpy?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"Dongsoo Kim" <dongsoo45.kim@samsung.com>,
	=?iso-8859-1?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?=
	<kyungmin.park@samsung.com>, jm105.lee@samsung.com,
	=?iso-8859-1?Q?=EC=9D=B4=EC=84=B8=EB=AC=B8?=
	<semun.lee@samsung.com>,
	=?iso-8859-1?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
	=?iso-8859-1?Q?=EA=B9=80=ED=98=95=EC=A4=80?=
	<riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wednesday 29 July 2009 05:55:51 Mauro Carvalho Chehab wrote:
>> Em Wed, 29 Jul 2009 12:30:19 +0900
>>
>> "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> escreveu:
>> > Sorry my bad. I missed something very important to explain my issue
>> > clear. The thing is, I want to reserve specific amount of continuous
>> > physical memory on machine initializing time. Therefor some multimedia
>> > peripherals can be using this memory area exclusively.
>> > That's what I was afraid of could not being adopted in main line
>> kernel.
>>
>> In the past, some drivers used to do that, but this is also a source
>> of problems, especially with general-purpose machines, where you're
>> loosing
>> memory that could otherwise be used by something else. I never tried to
>> get
>> the details, but I think the strategy were to pass a parameter during
>> kernel boot, for it to reserve some amount of memory that would later be
>> claimed by the V4L device.
>
> It's actually a pretty common strategy for embedded hardware (the
> "general-
> purpose machine" case doesn't - for now - make much sense on an OMAP
> processor
> for instance). A memory chunk would be reserved at boot time at the end of
> the
> physical memory by passing the mem= parameter to the kernel. Video
> applications would then mmap() /dev/mem to access that memory (I'd have to
> check the details on that one, that's from my memory), and pass the
> pointer
> the the v4l2 driver using userptr I/O. This requires root privileges, and
> people usually don't care about that when the final application is a
> camera
> (usually embedded in some device like a media player, an IP camera, ...).

True. However, my experience is that this approach isn't needed in most
cases as long as the v4l driver is compiled into the kernel. In that case
it is called early enough in the boot sequence that there is still enough
unfragmented memory available. This should definitely be the default case
for drivers merged into v4l-dvb.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

