Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZK0RbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 12:31:17 -0500
Date: 27 Nov 2009 18:29:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: awalls@radix.net
Cc: christoph@bartelmus.de
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDgcsm11qgB@lirc>
In-Reply-To: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

on 27 Nov 09 at 10:57, Jon Smirl wrote:
[...]
>>>> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's
>>>> just because I'm not familiar at all with input layer toolset.
>> [...]
>>> I hope it helps for you to better understand how this works.
>>
>> So the plan is to have two ways of using IR in the future which are
>> incompatible to each other, the feature-set of one being a subset of the
>> other?

> Take advantage of the fact that we don't have a twenty year old legacy
> API already in the kernel. Design an IR API that uses current kernel
> systems. Christoph, ignore the code I wrote and make a design proposal
> that addresses these goals...
>
> 1) Unified input in Linux using evdev. IR is on equal footing with
> mouse and keyboard.

Full support given with LIRC by using uinput.

> 2) plug and play for basic systems - you only need an external app for
> scripting

LIRC is lacking in plug and play support. But it wouldn't be very  
difficult to add some that works for all basic systems.
As I'm favouring a solution outside of the kernel, of course I can't offer  
you a solution which works without userspace tools.

> 3) No special tools - use mkdir, echo, cat, shell scripts to build
> maps

A user friendly GUI tool to configure the mapping of the remote buttons is  
essential for good user experience. I hope noone here considers that users  
learn command line or bash to configure their remotes.

> 4) Use of modern Linux features like sysfs, configfs and udev.

LIRC uses sysfs where appropriate. I have no problem using modern  
interfaces where it makes sense. But I won't change working and well  
tested interfaces just because it's possible to implement the same thing a  
different way. The interface is efficient and small. I don't see how it  
could gain much by the mentioned featues.
Tell me what exactly you don't like about the LIRC interface and we can  
work on it.

> 5) Direct multi-app support - no daemon

lircd is multi-app. I want to be in userspace, so I need a daemon.

> 6) Hide timing data from user as much as possible.

Nobody is manually writing lircd.conf files. Of course you don't want the  
user to know anything about the technical details unless you really want  
to get your hands dirty.

> What are other goals for this subsystem?
>
> Maybe we decide to take the existing LIRC system as is and not
> integrate it into the input subsystem. But I think there is a window
> here to update the LIRC design to use the latest kernel features.

If it ain't broke, don't fix it.

I'm also not against using the input layer where it makes sense.

For devices that do the decoding in hardware, the only thing that I don't  
like about the current kernel implementation is the fact that there are  
mapping tables in the kernel source. I'm not aware of any tools that let  
you change them without writing some keymaps manually.

I'm also not against in-kernel decoding in general. We already agreed last  
year that we can include an interface in lirc_dev that feeds the signal  
data to an in-kernel decoder if noone from userspace reads it. That's  
close to an one line change in lirc_dev. You won't have to change a single  
device driver for this. I think there also was common understanding that  
there will be cases where in-kernel decoding will not be possible for  
esoteric protocols and that there needs to be an interface to deliver the  
raw data to userspace.

My point just is that it took LIRC a very long time until the most common  
protocols have been fully supported, with all the toggle bits, toggle  
masks, repeat codes, sequences, headers, differing gap values, etc. Or  
take a look at crappy hardware like the Igor Cesko's USB IR Receiver. This  
device cripples the incoming signal except RC-5 because it has a limited  
buffer size. LIRC happily accepts the data because it does not make any  
assumptions on the protocol or bit length. With the approach that you  
suggested for the in-kernel decoder, this device simply will not work for  
anything but RC-5. The devil is in all the details. If we decide to do the  
decoding in-kernel, how long do you think this solution will need to  
become really stable and mainline? Currently I don't even see any  
consensus on the interface yet. But maybe you will prove me wrong and it's  
just that easy to get it all working.
I also understand that people want to avoid dependency on external  
userspace tools. All I can tell you is that the lirc tools already do  
support everything you need for IR control. And as it includes a lot of  
drivers that are implemented in userspace already, LIRC will just continue  
to do it's work even when there is an alternative in-kernel.
If LIRC is being rejected I don't have a real problem with this either,  
but we finally need a decision because for me this is definitely the last  
attempt to get this into the kernel.

Christoph
