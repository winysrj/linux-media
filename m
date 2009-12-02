Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:64592 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZLBT57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 14:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <9e4733910912021150k33446d3aybf0634fa0007ca1d@mail.gmail.com>
References: <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>
	 <20091201175400.GA19259@core.coreip.homeip.net>
	 <4B1567D8.7080007@redhat.com>
	 <20091201201158.GA20335@core.coreip.homeip.net>
	 <4B15852D.4050505@redhat.com>
	 <20091202093803.GA8656@core.coreip.homeip.net>
	 <4B16614A.3000208@redhat.com>
	 <20091202171059.GC17839@core.coreip.homeip.net>
	 <4B16C10E.6040907@redhat.com>
	 <9e4733910912021150k33446d3aybf0634fa0007ca1d@mail.gmail.com>
Date: Wed, 2 Dec 2009 14:58:04 -0500
Message-ID: <9e4733910912021158x5a7cc995j5db16b94d7184b92@mail.gmail.com>
Subject: Re: [RFC v2] Another approach to IR
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 2, 2009 at 2:50 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Wed, Dec 2, 2009 at 2:33 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Dmitry Torokhov wrote:
>>>> The raw interface applies only to the devices that doesn't have a hardware decoder
>>>> (something between 40%-60% of the currently supported devices).
>>>
>>> 50% is quite a number I think. But if driver does not allow access to
>>> the raw stream - it will refuse binding to lirc_dev interface.
>>
>> Ok.
>>
>>> We need to cater to the future cases as well. I don't want to redesign
>>> it in 2 years. But for devices that have only hardware decoders I
>>> suppose we can short-curcuit "interfaces" and have a library-like module
>>> creating input devices directly.
>>
>> We really need only one interface for those devices. However, protocol selection
>> is needed, as it is associated with the scantable on those devices.
>> a sysfs entry would solve this issue.
>>
>> Also, we need a better schema to cleanup the keycode table. Currently, the only way
>> I'm aware is to run a loop from 0 to 65535 associating a scancode to KEY_UNKNOWN or
>> to KEY_RESERVED.
>>
>>>> In the case of the cheap devices with just raw interfaces, running in-kernel
>>>> decoders, while it will work if you create one interface per protocol
>>>> per IR receiver, this also seems overkill. Why to do that? It sounds that it will
>>>> just create additional complexity at the kernelspace and at the userspace, since
>>>> now userspace programs will need to open more than one device to receive the
>>>> keycodes.
>>>
>>> _Yes_!!! You open as many event devices as there are devices you are
>>> interested in receiving data from. Multiplexing devices are bad, bad,
>>> bad. Witness /dev/input/mouse and all the attempts at working around the
>>> fact that if you have a special driver for one of your devices you
>>> receive events from the same device through 2 interfaces and all kind of
>>> "grab", "super-grab", "smart-grab" schemes are born.
>>
>> The only device that the driver can actually see is the IR receiver. There's no way to
>> know if there is only one physical IR sending signals to it or several different models,
>> especially if we consider that programmable IR's can be able even to generate more than one
>> protocol at the same time, and can emulate other IR types.
>
> IR devices transmit vendor/device/command triplets. They are easy to
> tell apart and create an evdev device corresponding to each
> vendor/device pair or something else along those lines.

I forgot about fixed function receivers - ones that only receive codes
from a specific vendor/device pair and decode them in hardware. Those
devices would just create a fixed entry in the configfs which would
then allow a keycode mapping to be loaded. Or a parallel scheme for
setkeys IOCTL. These device can only receive from a single remote.

>
> If I tell a programmable remote to send out the same commands as my
> Sony remote that's the same thing as owning two identical Sony
> remotes. I'd expect them to be indistinguishable. If you want to be
> able to tell your remotes apart, don't program them to emulate each
> other.
>
> I've published code that can split these devices apart, it's not
> impossible to do.
>
> 802.11 receivers have the same problem, there is one receiver and many
> transmitters. The networking code doesn't have problems with sorting
> this out and separating the streams.
>
>> You might create some artificial schema to try to deal with different IR's being received
>> at the same IR receiver, but, IMHO, this will just add a complex abstraction layer.
>>
>> Also, this won't give any real gain, as either both IR's will generate the same scancodes (and you can't distinguish what IR generated that code), or the scancode is different, and you
>> can handle it differently.
>
> Reusing the keycode is fine if they on different evdev devices. A key
> feature is creating one evdev device for each remote.
>
>>
>>>>> (for each remote/substream that they can recognize).
>>>> I'm assuming that, by remote, you're referring to a remote receiver (and not to
>>>> the remote itself), right?
>>>
>>> If we could separate by remote transmitter that would be the best I
>>> think, but I understand that it is rarely possible?
>>
>> IMHO, the better is to use a separate interface for the IR transmitters,
>> on the devices that support this feature. There are only a few devices
>> I'm aware of that are able to transmit IR codes.
>>
>> Cheers,
>> Mauro.
>>
>>
>
>
>
> --
> Jon Smirl
> jonsmirl@gmail.com
>



-- 
Jon Smirl
jonsmirl@gmail.com
