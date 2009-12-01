Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZLARDo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:03:44 -0500
Message-ID: <4B154C54.5090906@redhat.com>
Date: Tue, 01 Dec 2009 15:03:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>	 <1259682428.18599.10.camel@maxim-laptop> <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>
In-Reply-To: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

Jon Smirl wrote:
> On Tue, Dec 1, 2009 at 10:47 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> On Tue, 2009-12-01 at 10:08 -0500, Jon Smirl wrote:
>>> While reading all of these IR threads another way of handling IR
>>> occurred to me that pretty much eliminates the need for LIRC and
>>> configuration files in default cases. The best way to make everything
>>> "just work" is to eliminate it.
>>>
>>> The first observation is that the IR profile of various devices are
>>> well known. Most devices profiles are in the published One-for-All
>>> database. These device profiles consist of vendor/device/command
>>> triplets. There is one triplet for each command like play, pause, 1,
>>> 2, 3, power, etc.
>>>
>>> The second observation is that universal remotes know how to generate
>>> commands for all of the common devices.
>>>
>>> Let's define evdev messages for IR than contain vendor/device/command
>>> triplets. I already posted code for doing that in my original patch
>>> set. These messages are generated from in-kernel code.
>>>
>>> Now add a small amount of code to MythTV, etc to act on these evdev
>>> messages. Default MythTV, etc to respond to the IR commands for a
>>> common DVR device. Program your universal remote to send the commands
>>> for this device. You're done. Everything will "just work" - no LIRC,
>>> no irrecord, no config files, no command mapping, etc.
>> You are making one  big wrong assumption that everyone that has a remote
>> uses mythtv, and only it.
>>
>> Many users including me, use the remote just like a keyboard, or even
>> like a mouse.
> 
> So let's try and figure out a "just works" scheme for doing this. What
> I'm trying to do is to get everyone to step back and think about this
> problem instead of rushing head long into merging LIRC as is. irrecord
> is not something a non-technical user can easily handle.
> 
> A basic scheme that can be used to eliminate configuration is to take
> well known IR device profiles and emulate them in Linux.  So pick
> another well known device to emulate (call it A) and map it to
> mouse/keyboard events.  Mapping vendor/device/command codes for a
> couple devices to mouse/keyboard events is a tiny amount of data and
> can be done in-kernel.
> 
> This case could also be made to "just work". Set your universal remote
> to device A. Commands from for device A will arrive and be mapped into
> generic keyboard/mouse commands.
> 
> There are probably other solutions to making IR work without needing
> irrecord and configuration. What would be some other possibilities?
> 
> Also consider the long term strategy of defining standard device
> profiles and getting them into the IR database. Make an IR profile for
> mouse/keyboard. After this gets into the database a universal remote
> can be set to this profile which will be a better match than emulating
> another device.

This is basically the way the current in-kernel IR drivers work. The
driver converts scancodes (device address/command sequence) into
an evdev standard code.

Just taking an example from the dibcom0700 driver (as the same driver 
supports several different RC5 and NEC codes at the same time), 
the kernel table has several keycodes added there, all working
at the same time. Providing that the scancodes won't overlap, you can
map two different scancodes (from different IR's) to return the same
keycode (table is not complete - I just got a few common keycodes):

# SCAN Key_code
#
0xeb13 KEY_RIGHT
0x1e17 KEY_RIGHT
0x1d17 KEY_RIGHT
0x860f KEY_RIGHT

0xeb11 KEY_LEFT
0x1e16 KEY_LEFT
0x1d16 KEY_LEFT
0x860e KEY_LEFT

0x0703 KEY_VOLUMEUP
0xeb1c KEY_VOLUMEUP
0x1e10 KEY_VOLUMEUP
0x037d KEY_VOLUMEUP
0x1d10 KEY_VOLUMEUP
0x8610 KEY_VOLUMEUP
0x7a12 KEY_VOLUMEUP

0x0709 KEY_VOLUMEDOWN
0xeb1e KEY_VOLUMEDOWN
0x1e11 KEY_VOLUMEDOWN
0x017d KEY_VOLUMEDOWN
0x1d11 KEY_VOLUMEDOWN
0x860c KEY_VOLUMEDOWN
0x7a13 KEY_VOLUMEDOWN

0x0706 KEY_CHANNELUP
0xeb1b KEY_CHANNELUP
0x1e20 KEY_CHANNELUP
0x0242 KEY_CHANNELUP
0x1d20 KEY_CHANNELUP
0x860d KEY_CHANNELUP
0x7a10 KEY_CHANNELUP

0x070c KEY_CHANNELDOWN
0xeb1f KEY_CHANNELDOWN
0x1e21 KEY_CHANNELDOWN
0x007d KEY_CHANNELDOWN
0x1d21 KEY_CHANNELDOWN
0x8619 KEY_CHANNELDOWN
0x7a11 KEY_CHANNELDOWN

It should be noticed, however, that some devices may be provided with a shipped
IR with a different keytable where the keycodes may overlap with this table.

So, what we can do is to have a "default" keycode table mapping several
different IR's there to be used by drivers that are shipped with an IR
that can be fully mapped by the default table. However, for devices
with scancodes that overlaps with the default table, we'll need a separate
table.

Cheers,
Mauro.
