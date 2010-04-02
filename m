Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab0DBVQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 17:16:12 -0400
Message-ID: <4BB65E67.9050605@redhat.com>
Date: Fri, 02 Apr 2010 18:15:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC] Serialization flag example
References: <201004011937.39331.hverkuil@xs4all.nl>	 <4BB4E4CC.3020100@redhat.com>	 <y2v1a297b361004021043wa43821d2hfb5b573b110dd5e0@mail.gmail.com> <x2v829197381004021053nf77e2d42q4f1614eced7f999d@mail.gmail.com>
In-Reply-To: <x2v829197381004021053nf77e2d42q4f1614eced7f999d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Apr 2, 2010 at 1:43 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> IMO, A framework shouldn't lock.

Current DVB framework is locked with BKL. I agree that an unconditional 
lock like this is very bad. We need to get rid of it as soon as possible.

> Hello Manu,
> 
> The argument I am trying to make is that there are numerous cases
> where you should not be able to use both a particular DVB and V4L
> device at the same time.  The implementation of such locking should be
> handled by the v4l-dvb core, but the definition of the relationships
> dictating which devices cannot be used in parallel is still the
> responsibility of the driver.
> 
> This way, a bridge driver can say "this DVB device cannot be used at
> the same time as this V4L device" but the actual enforcement of the
> locking is done in the core.  For cases where the devices can be used
> in parallel, the bridge driver doesn't have to do anything.

Although both are some sort of locks, the BKL replacement lock is
basically a memory barrier to serialize data, avoiding that the driver's
internal structs to be corrupted or to return a wrong value. Only the
driver really knows what should be protected.

In the case of V4L/DVB devices, the struct to be protected is the struct *_dev
(struct core, on cx88, struct em28xx on em28xx, struct saa7134_dev, and so on).

Of course, if everything got serialized by the core, and assuming that the 
driver doesn't have IRQ's and/or other threads accessing the same data, the 
problem disappears, at the expense of a performance reduction that may or 
may not be relevant.

That's said, except for the most simple drivers, like radio ones, there's always
some sort of IRQ and/or threads evolved, touching on struct *_dev. 

For example, both cx88 and saa7134 have (depending on the hardware):
	- IRQ to announce that a data buffer was filled for video, vbi, alsa;
	- IRQ for IR;
	- IR polling;
	- video audio standard detection thread;

A lock to protect the internal data structs should protect all the above. Even
the most pedantic core-only lock won't solve it.

Yet, a lock, on core, for ioctl/poll/open/close may be part of a protection, if
the same lock is used also to protect the other usages of struct *_dev.

So, I'm OK on having an optional mutex parameter to be passed to V4L core, to provide
the BKL removal.

In the case of a V4L x DVB type of lock, this is not to protect some memory, but,
instead, to limit the usage of a hardware that is not capable of simultaneously
provide V4L and DVB streams. This is a common case on almost all devices, but, as
Hermann pointed, there are a few devices that are capable of doing both analog
and digital streams at the same time, but saa7134 driver currently doesn't support.

Some drivers, like cx88 has a sort of lock meant to protect such things. It is
implemented on res_get/res_check/res_locked/res_free. Currently, the lock is only
protecting simultaneous usage of the analog part of the driver. It works by not
allowing to start two simultaneous video streams of the same memory access type, 
for example, while allowing multiple device opens, for example to call V4L controls, 
while another application is streaming. It also allows having a mmapped or overlay
stream and a separate read() stream (used on applications like xawtv and xdtv to
record a video on PCI devices that has enough bandwidth to provide two simultaneous 
streams).

Maybe this kind of lock can be abstracted, and we can add a class of resource protectors
inside the core, for the drivers to use it when needed.

-- 

Cheers,
Mauro
