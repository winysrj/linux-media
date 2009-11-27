Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:34831 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZK0RtX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 12:49:23 -0500
MIME-Version: 1.0
In-Reply-To: <BDgcsm11qgB@lirc>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <BDgcsm11qgB@lirc>
Date: Fri, 27 Nov 2009 12:49:28 -0500
Message-ID: <9e4733910911270949s3e8b5ba9qfe5025d490ad0cfa@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: awalls@radix.net, christoph@bartelmus.de,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 27, 2009 at 12:29 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>> Maybe we decide to take the existing LIRC system as is and not
>> integrate it into the input subsystem. But I think there is a window
>> here to update the LIRC design to use the latest kernel features.
>
> If it ain't broke, don't fix it.
>
> I'm also not against using the input layer where it makes sense.
>
> For devices that do the decoding in hardware, the only thing that I don't
> like about the current kernel implementation is the fact that there are
> mapping tables in the kernel source. I'm not aware of any tools that let
> you change them without writing some keymaps manually.
>
> I'm also not against in-kernel decoding in general. We already agreed last
> year that we can include an interface in lirc_dev that feeds the signal
> data to an in-kernel decoder if noone from userspace reads it. That's
> close to an one line change in lirc_dev. You won't have to change a single
> device driver for this. I think there also was common understanding that
> there will be cases where in-kernel decoding will not be possible for
> esoteric protocols and that there needs to be an interface to deliver the
> raw data to userspace.
>
> My point just is that it took LIRC a very long time until the most common
> protocols have been fully supported, with all the toggle bits, toggle
> masks, repeat codes, sequences, headers, differing gap values, etc. Or
> take a look at crappy hardware like the Igor Cesko's USB IR Receiver. This
> device cripples the incoming signal except RC-5 because it has a limited
> buffer size. LIRC happily accepts the data because it does not make any
> assumptions on the protocol or bit length. With the approach that you
> suggested for the in-kernel decoder, this device simply will not work for
> anything but RC-5. The devil is in all the details. If we decide to do the
> decoding in-kernel, how long do you think this solution will need to
> become really stable and mainline? Currently I don't even see any
> consensus on the interface yet. But maybe you will prove me wrong and it's
> just that easy to get it all working.
> I also understand that people want to avoid dependency on external
> userspace tools. All I can tell you is that the lirc tools already do
> support everything you need for IR control. And as it includes a lot of
> drivers that are implemented in userspace already, LIRC will just continue
> to do it's work even when there is an alternative in-kernel.
> If LIRC is being rejected I don't have a real problem with this either,
> but we finally need a decision because for me this is definitely the last
> attempt to get this into the kernel.

Christoph, take what you know from all of the years of working on LIRC
and design the perfect in-kernel system. This is the big chance to
redesign IR support and get rid of any past mistakes. Incorporate any
useful chunks of code and knowledge from the existing LIRC into the
new design. Drop legacy APIs, get rid of daemons, etc. You can do this
redesign in parallel with existing LIRC. Everyone can continue using
the existing code while the new scheme is being built. Think of it as
LIRC 2.0. You can lead this design effort, you're the most experience
developer in the IR area.  Take advantage of this window to make a
design that is fully integrated with Linux - put IR on equal footing
with the keyboard and mouse as it should be.

-- 
Jon Smirl
jonsmirl@gmail.com
