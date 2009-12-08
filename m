Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:43519 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbZLHQTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 11:19:39 -0500
MIME-Version: 1.0
In-Reply-To: <4B1E656F.3020507@redhat.com>
References: <BDRae8rZjFB@christoph>
	 <1260240142.3086.14.camel@palomino.walls.org>
	 <20091208042210.GA11147@core.coreip.homeip.net>
	 <1260275743.3094.6.camel@palomino.walls.org>
	 <9e4733910912080452p42efa794mb7fd608fa4fbad7c@mail.gmail.com>
	 <4B1E5746.7010305@redhat.com>
	 <9e4733910912080601s1a814720qd909e47ac09f91fc@mail.gmail.com>
	 <4B1E5FAF.40201@redhat.com>
	 <9e4733910912080631r6fd306c5tdfd56482583b9bf5@mail.gmail.com>
	 <4B1E656F.3020507@redhat.com>
Date: Tue, 8 Dec 2009 11:19:45 -0500
Message-ID: <9e4733910912080819l2ffc88fes894d02dc8b834ef@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 8, 2009 at 9:40 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Jon Smirl wrote:
>> On Tue, Dec 8, 2009 at 9:16 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Jon Smirl wrote:
>>>> On Tue, Dec 8, 2009 at 8:40 AM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>> Jon Smirl wrote:
>>>>>> On Tue, Dec 8, 2009 at 7:35 AM, Andy Walls <awalls@radix.net> wrote:
>>>>>>> On Mon, 2009-12-07 at 20:22 -0800, Dmitry Torokhov wrote:
>>>>>>>> On Mon, Dec 07, 2009 at 09:42:22PM -0500, Andy Walls wrote:
>>>>>>>>> So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
>>>>>>>>> end of the month.
>>>>>>>>>
>>>>>>>>> I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
>>>>>>>>> a common set of parameters, so I may be able to set up the decoders to
>>>>>>>>> handle decoding from two different remote types at once.  The HVR boards
>>>>>>>>> can ship with either type of remote AFAIK.
>>>>>>>>>
>>>>>>>>> I wonder if I can flip the keytables on the fly or if I have to create
>>>>>>>>> two different input devices?
>>>>>>>>>
>>>>>>>> Can you distinguish between the 2 remotes (not receivers)?
>>>>>>> Yes.  RC-6 and RC-5 are different enough to distinguish between the two.
>>>>>>> (Honestly I could pile on more protocols that have similar pulse time
>>>>>>> periods, but that's complexity for no good reason and I don't know of a
>>>>>>> vendor that bundles 3 types of remotes per TV card.)
>>>>>>>
>>>>>>>
>>>>>>>>  Like I said,
>>>>>>>> I think the preferred way is to represent every remote that can be
>>>>>>>> distinguished from each other as a separate input device.
>>>>>>> OK.  With RC-5, NEC, and RC-6 at least there is also an address or
>>>>>>> system byte or word to distingish different remotes.  However creating
>>>>>>> multiple input devices on the fly for detected remotes would be madness
>>>>>>> - especially with a decoding error in the address bits.
>>>>>> I agree that creating devices on the fly has problems. Another
>>>>>> solution is to create one device for each map that is loaded. There
>>>>>> would be a couple built-in maps for bundled remotes - each would
>>>>>> create a device. Then the user could load more maps with each map
>>>>>> creating a device.
>>>>> No, please. We currently have already 89 different keymaps in-kernel. Creating
>>>>> 89 different interfaces per IR receiver is not useful at all.
>>>>>
>>>>> IMO, the interfaces should be created as the keymaps are associated
>>>>> to an specific IR receiver.
>>>> Each IR receiver device driver would have a built-in keymap for the
>>>> remote bundled with it. When you load the driver it will poke the
>>>> input system and install the map. Any additional keymaps would get
>>>> loaded from user space. You would load one keymap per input device.
>>>>
>>>> You might have 89 maps in the kernel with each map being built into
>>>> the device driver for those 89 IR receivers. But you'll only own one
>>>> or two of those devices so only one or two of the 89 maps will load.
>>>> Building the map for the bundled receiver into the device driver is an
>>>> important part of achieving "just works".
>>>>
>>>> I suspect we'll have a 1,000 maps defined after ten years, most of
>>>> these maps will be loaded from user space. But you'll only have two or
>>>> three loaded at any one time into your kernel. You need one map per
>>>> input device created. These maps are tiny, less than 1KB.
>>>>
>>>> Having all of these maps is the price of allowing everyone to use any
>>>> more that they please. If you force the use of universal remotes most
>>>> of the maps can be eliminated.
>>> Makes sense. Yet, I would add an option at Kbuild to create a module or not
>>> with the bundled IR keymaps.
>>>
>>> So, it should be possible to have all of them completely on userspace or
>>> having them at kernelspace.
>>
>> Removing the maps for the bundled remotes from the receiver device
>> drivers will break "just works".
>
> No. This can be provided by an udev application that will load the keytable
> when the device is connected.

Why do you want to pull the 1KB default mapping table out of the
device driver __init section and more it to a udev script? Now we will
have to maintain a parallel udev script for ever receiver's device
driver.

The purpose of putting this table into __init is to get rid of all
these udev scripts in the default case.

>
> Of course before adding it into a module, we'll need to write such app.
>
> This will only affects the need of IR during boot time.
>
>> The map will be in an __init section
>> of the IR device driver. When it is fed into the input system a RAM
>> based structure will be created.
>
> We can't use __init, since another device needing the keymap may be hot-plugged.

You can handle that with __devinit


>> If you really want the 1KB memory
>> back, use sysfs to remove the default map.  An embedded system will
>> have a bundled remote so it is going to want the map.
>
> Yes, but it needs just one map, not all of them. The maps shouldn't be linked
> into the drivers, as the same map is used by several different devices on

Link them or #include them, it doesn't make any difference.

> different drivers. So, the option is to allow customizing the available keymaps,
> if CONFIG_EMBEDDED.
>
> Cheers,
> Mauro.
>



-- 
Jon Smirl
jonsmirl@gmail.com
