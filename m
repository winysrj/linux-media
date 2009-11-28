Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZK1LVg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 06:21:36 -0500
Message-ID: <4B1107B3.3000009@redhat.com>
Date: Sat, 28 Nov 2009 09:21:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: jonsmirl@gmail.com, awalls@radix.net, christoph@bartelmus.de,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDgcsm11qgB@lirc>
In-Reply-To: <BDgcsm11qgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

Christoph Bartelmus wrote:

>> Maybe we decide to take the existing LIRC system as is and not
>> integrate it into the input subsystem. But I think there is a window
>> here to update the LIRC design to use the latest kernel features.
> 
> If it ain't broke, don't fix it.

I don't know what's up on lirc development, but in the case of the media drivers,
the situation we have currently is different than what we had five years ago. In
the past, all drivers were developed by a someone without any official help from
the hardware developer. On several cases, it were developed _despite_ vendors
efforts to hide technical info. Basically, vendors weren't interested
on officially support Linux.

Now, the situation has changed. We have several vendors providing patches
and drivers to the community and we have incoming vendors joining the efforts
almost every month. They are not only providing basic streaming capabilities
but also providing us patches for the shipped IR's.

If the developers community is changed, it is natural that the development
model needs improvements to better handle the new model, as they're bringing
new demands and asking for API improvements.

One of the effects is that we're actively working very hard to improve the core
of the subsystem, in order to provide more flexibility on the subsystem and
to make easier to receive patch contributions.

So, even not being broken, the subsystem internal media API's changed
a lot during the last years, and there are still several new changes
on our TODO list.

So, I'd say that if we can do it better, then let's do it.

> I'm also not against using the input layer where it makes sense.
> 
> For devices that do the decoding in hardware, the only thing that I don't  
> like about the current kernel implementation is the fact that there are  
> mapping tables in the kernel source. I'm not aware of any tools that let  
> you change them without writing some keymaps manually.

When the keymap tool I pointed is built, The Makefile automatically parses all
kernel source files with IR keymaps and produce a directory with all those
keymaps (currently, it is producing 89 keymap tables).

After we have some sort of tool that automatically loads the keymaps when
a new device is added by udev, we can deprecate the in-kernel keymaps and use
those files as a basis for such tool.

Still, I prefer first to migrate all drivers to use the full scancode and
re-generate the keymaps before such step.
 
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
> masks, repeat codes, sequences, headers, differing gap values, etc.

It also took a very long time to add support at the existing in-kernel drivers
to allow them to support the shipped IR and the hardware IR decoding 
capabilities, in order to provide consistent interfaces that work out-of-the-box. 

Any API decision we take, it should be applied to all IR drivers: the 
current in-kernel drivers and the new lirc drivers should both be
compliant with the API's. So, we are all at the same boat.

As you probably know, on almost all multimedia drivers, the same driver needs
to support more than one way to receive IR. There are even some cases where
the same driver has different methods to talk with the same IR, due to
different design decisions that were taken from the same manufacturer on
different boards or board revisions. 

For example, there are several cases where the same IR is shipped with cards
that only provides raw pulse/space interfaces and with devices with 
hardware decoding. Also the same IR is sometimes used by different vendors.
It happens that the same driver needs different ways to talk with the same IR.
So, while a raw interface can be provided for those devices that have
raw IR reception to work with lirc, it doesn't make sense of removing
the existing event interface for the devices that requires to use the already
existing in-kernel decoders. We shouldn't impose a penalty to the users just
because the vendor decided to save a few cents and not adding a hardware decoder.

Yet, I understand that having a raw interface for those devices that don't
have hardware IR decoding capabilities is interesting for lirc, as it can
use different algorithms to support unusual devices.

> Or take a look at crappy hardware like the Igor Cesko's USB IR Receiver. This  
> device cripples the incoming signal except RC-5 because it has a limited  
> buffer size. LIRC happily accepts the data because it does not make any  
> assumptions on the protocol or bit length.

For sure there will be cases where only with lirc you'll be able to get
an event. I'm not saying that we need to move the entire lirc drivers into
the kernel. However, in the cases where adding a new kernel driver is 
the better approach, the kernel driver should directly offer an evdev interface,
to allow a wider usage of the IR. An IR should behave, by default, just like
a keyboard or a mouse: once the hardware is plugged, it should produce keystrokes.

Also, the solution of a kernel driver that sends a raw event to userspace, 
proccess there and return back to the kernel shouldn't be the default, since
it will add more delay than directly doing whatever is needed in kernel and
directly output the keystroke.

> With the approach that you  
> suggested for the in-kernel decoder, this device simply will not work for  
> anything but RC-5. The devil is in all the details.

I haven't seen such limitations on his proposal. We currently have in-kernel
decoders for NEC, pulse-distance, RC4 protocols, and some variants. If non-RC5
decoders are missing, we need for sure to add them.

> If we decide to do the  
> decoding in-kernel, how long do you think this solution will need to  
> become really stable and mainline? Currently I don't even see any  
> consensus on the interface yet. But maybe you will prove me wrong and it's  
> just that easy to get it all working.

The timeframe to go to mainline will basically depend on taking a decision about the
API and on people having time to work on it. 

Providing that we agree on what we'll do, I don't see why not
adding it on staging for 2.6.33 and targeting to have 
everything done for 2.6.34 or 2.6.35.

> I also understand that people want to avoid dependency on external  
> userspace tools. All I can tell you is that the lirc tools already do  
> support everything you need for IR control. And as it includes a lot of  
> drivers that are implemented in userspace already, LIRC will just continue  
> to do it's work even when there is an alternative in-kernel.

The point is that for simple usage, like an user plugging his new USB stick
he just bought, he should be able to use the shipped IR without needing to
configure anything or manually calling any daemon. This currently works
with the existing drivers and it is a feature that needs to be kept.

Of course lirc has a number of features that improves a lot the users experience.
Also, as you reminded, there are some cases where the user wants to do something
that requires a setup, like using a non-standard IR, or wants to use some user-made
hardware to receive IR.

> If LIRC is being rejected I don't have a real problem with this either,  
> but we finally need a decision because for me this is definitely the last  
> attempt to get this into the kernel.

Nobody is rejecting it, but we need to carefully discuss the API's that
will be available for IR's.

At the kernel development model, API's need to be stable for a very long time. So,
it is better to take some time discussing it than to suffer for a long time
trying to solve a bad decision.

Just as an example, V4L1 API went on kernel in 1999, and the first V4L2 API drafts
are back from 2002. The new API corrects several serious design problems on the
original V4L1 API. Still today, we're converting drivers to the new API
and loosing our time fixing bugs and porting applications to use the new model.

Maybe if people had better understanding about the needs
and could had V4L2 API done before adding the first drivers, we would
had saved a huge amount of efforts trying to fix it.

The same history also happened with /dev/mouse, with OSS/ALSA, ...
As we now have a good understanding about the IR input needs, let's
focus on producing an API that will last there for a long time, please.

Cheers,
Mauro.
