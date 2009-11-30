Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZK3MN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 07:13:57 -0500
Message-ID: <4B13B6FA.40005@redhat.com>
Date: Mon, 30 Nov 2009 10:13:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Christoph Bartelmus <christoph@bartelmus.de>, jarod@wilsonet.com,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
In-Reply-To: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Fri, Nov 27, 2009 at 2:45 AM, Christoph Bartelmus
> <christoph@bartelmus.de> wrote:
>> Hi Mauro,
>>
>> on 26 Nov 09 at 14:25, Mauro Carvalho Chehab wrote:
>>> Christoph Bartelmus wrote:
>> [...]
>>>> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's just
>>>> because I'm not familiar at all with input layer toolset.
>> [...]
>>> I hope it helps for you to better understand how this works.
>> So the plan is to have two ways of using IR in the future which are
>> incompatible to each other, the feature-set of one being a subset of the
>> other?
> 
> Take advantage of the fact that we don't have a twenty year old legacy
> API already in the kernel. Design an IR API that uses current kernel
> systems. Christoph, ignore the code I wrote and make a design proposal
> that addresses these goals...
> 
> 1) Unified input in Linux using evdev. IR is on equal footing with
> mouse and keyboard.

This makes sense to me. Yet, I think that, on some specific cases, we'll
need a raw interface.

> 2) plug and play for basic systems - you only need an external app for scripting

Yes.

> 3) No special tools - use mkdir, echo, cat, shell scripts to build maps

I don't think this is relevant. As we already have ioctls for building maps, and
while all in-kernel drivers can handle scancodes with up to 32 bits, I don't see
any reason to use anything different than what's currently available.

> 4) Use of modern Linux features like sysfs, configfs and udev.

sysfs/udev is a need for hot-plugging. I wouldn't use configfs for it. There aren't
many places using it and afaik some distros are not compiling their kernels with
configfs enabled. Also, as we have already ioctl's for keycode maps, I think
we shouldn't be migrating to controlfs.

> 5) Direct multi-app support - no daemon

For multi-app support usage like your example (e. g. different IR keys mapped into
the same evdev keycode and sent to different applications), I think we should need
a daemon for handling it.

> 6) Hide timing data from user as much as possible.

I agree. Porting the IRQ/gpio pollings to userspace on a system with a high workload
may mean that the keycode will be badly interpreted.

Cheers,
Mauro.
