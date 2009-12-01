Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbZLAVG0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 16:06:26 -0500
Message-ID: <4B15852D.4050505@redhat.com>
Date: Tue, 01 Dec 2009 19:05:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com> <1259682428.18599.10.camel@maxim-laptop> <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com> <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <4B155288.1060509@redhat.com> <20091201175400.GA19259@core.coreip.homeip.net> <4B1567D8.7080007@redhat.com> <20091201201158.GA20335@core.coreip.homeip.net>
In-Reply-To: <20091201201158.GA20335@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Tue, Dec 01, 2009 at 05:00:40PM -0200, Mauro Carvalho Chehab wrote:
>> Dmitry Torokhov wrote:
>>> On Tue, Dec 01, 2009 at 03:29:44PM -0200, Mauro Carvalho Chehab wrote:
>>>> For sure we need to add an EVIOSETPROTO ioctl to allow the driver 
>>>> to change the protocol in runtime.
>>>>
>>> Mauro,
>>>
>>> I think this kind of confuguration belongs to lirc device space,
>>> not input/evdev. This is the same as protocol selection for psmouse
>>> module: while it is normally auto-detected we have sysfs attribute to
>>> force one or another and it is tied to serio device, not input
>>> device.
>> Dmitry,
>>
>> This has nothing to do with the raw interface nor with lirc. This problem 
>> happens with the evdev interface and already affects the in-kernel drivers.
>>
>> In this case, psmouse is not a good example. With a mouse, when a movement
>> occurs, you'll receive some data from its port. So, a software can autodetect
>> the protocol. The same principle can be used also with a raw pulse/space
>> interface, where software can autodetect the protocol.
> 
> Or, in certain cases, it can not.
> 
> [... skipped rationale for adding a way to control protocol (with which
> I agree) ...]
> 
>> To solve this, we really need to extend evdev API to do 3 things: enumberate the
>> supported protocols, get the current protocol(s), and select the protocol(s) that
>> will be used by a newer table.
>>
> 
> And here we start disagreeing. My preference would be for adding this
> API on lirc device level (i.e. /syc/class/lirc/lircX/blah namespace),
> since it only applicable to IR, not to input devices in general.
> 
> Once you selected proper protocol(s) and maybe instantiated several
> input devices then udev (by examining input device capabilities and
> optionally looking up at the parent device properties) would use
> input evdev API to load proper keymap. Because translation of
> driver-specific codes into standard key definitions is in the input
> realm. Reading these driver-specific codes from hardware is outside of
> input layer domain.
> 
> Just as psmouse ability to specify protocol is not shoved into evdev;
> just as atkbd quirks (force release key list and other driver-specific
> options) are not in evdev either; we should not overload evdev interface
> with IR-specific items.

I'm not against mapping those features as sysfs atributes, but they don't belong
to lirc, as far as I understand. From all we've discussed, we'll create a lirc
interface to allow the direct usage of raw IO. However, IR protocol is a property
that is not related to raw IO mode but, instead, to evdev mode.

We might add a /sys/class/IR and add IR specific stuff there, but it seems
overkill to me and will hide the fact that those parameters are part of the evdev
interface.

So, I would just add the IR sysfs parameters at the /sys/class/input, if
the device is an IR (or create it is /sys/class/input/IR).

I agree that the code to implement the IR specific sysfs parameter should be kept
oustide input core, as they're specific to IR implementations.

Would this work for you?

Cheers,
Mauro.

