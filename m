Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53278 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbZLHOBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 09:01:41 -0500
MIME-Version: 1.0
In-Reply-To: <4B1E5746.7010305@redhat.com>
References: <BDRae8rZjFB@christoph> <m3k4xe7dtz.fsf@intrepid.localdomain>
	 <4B0E8B32.3020509@redhat.com> <1259264614.1781.47.camel@localhost>
	 <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>
	 <1260240142.3086.14.camel@palomino.walls.org>
	 <20091208042210.GA11147@core.coreip.homeip.net>
	 <1260275743.3094.6.camel@palomino.walls.org>
	 <9e4733910912080452p42efa794mb7fd608fa4fbad7c@mail.gmail.com>
	 <4B1E5746.7010305@redhat.com>
Date: Tue, 8 Dec 2009 09:01:48 -0500
Message-ID: <9e4733910912080601s1a814720qd909e47ac09f91fc@mail.gmail.com>
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

On Tue, Dec 8, 2009 at 8:40 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Jon Smirl wrote:
>> On Tue, Dec 8, 2009 at 7:35 AM, Andy Walls <awalls@radix.net> wrote:
>>> On Mon, 2009-12-07 at 20:22 -0800, Dmitry Torokhov wrote:
>>>> On Mon, Dec 07, 2009 at 09:42:22PM -0500, Andy Walls wrote:
>>>>> So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
>>>>> end of the month.
>>>>>
>>>>> I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
>>>>> a common set of parameters, so I may be able to set up the decoders to
>>>>> handle decoding from two different remote types at once.  The HVR boards
>>>>> can ship with either type of remote AFAIK.
>>>>>
>>>>> I wonder if I can flip the keytables on the fly or if I have to create
>>>>> two different input devices?
>>>>>
>>>> Can you distinguish between the 2 remotes (not receivers)?
>>> Yes.  RC-6 and RC-5 are different enough to distinguish between the two.
>>> (Honestly I could pile on more protocols that have similar pulse time
>>> periods, but that's complexity for no good reason and I don't know of a
>>> vendor that bundles 3 types of remotes per TV card.)
>>>
>>>
>>>>  Like I said,
>>>> I think the preferred way is to represent every remote that can be
>>>> distinguished from each other as a separate input device.
>>> OK.  With RC-5, NEC, and RC-6 at least there is also an address or
>>> system byte or word to distingish different remotes.  However creating
>>> multiple input devices on the fly for detected remotes would be madness
>>> - especially with a decoding error in the address bits.
>>
>> I agree that creating devices on the fly has problems. Another
>> solution is to create one device for each map that is loaded. There
>> would be a couple built-in maps for bundled remotes - each would
>> create a device. Then the user could load more maps with each map
>> creating a device.
>
> No, please. We currently have already 89 different keymaps in-kernel. Creating
> 89 different interfaces per IR receiver is not useful at all.
>
> IMO, the interfaces should be created as the keymaps are associated
> to an specific IR receiver.

Each IR receiver device driver would have a built-in keymap for the
remote bundled with it. When you load the driver it will poke the
input system and install the map. Any additional keymaps would get
loaded from user space. You would load one keymap per input device.

You might have 89 maps in the kernel with each map being built into
the device driver for those 89 IR receivers. But you'll only own one
or two of those devices so only one or two of the 89 maps will load.
Building the map for the bundled receiver into the device driver is an
important part of achieving "just works".

I suspect we'll have a 1,000 maps defined after ten years, most of
these maps will be loaded from user space. But you'll only have two or
three loaded at any one time into your kernel. You need one map per
input device created. These maps are tiny, less than 1KB.

Having all of these maps is the price of allowing everyone to use any
more that they please. If you force the use of universal remotes most
of the maps can be eliminated.



>
>> Incoming scancodes are matched against all of the loaded maps and a
>> keycode event is generated if a match occurs.
>
> s/all of the loaded maps/all of the loaded maps per device/
>
> You may have more than one IR receiver on a given machine.
>
> IMO, we may have a mask filter matching also, associated with each keycode
> table, to minimize the keycode seek time. Something like:
>
>        if (scancode & scancode_mask)
>                check_scancode()
>
>> This illustrates why there should an EV_IR event which communicates
>> scancodes, without this event you can't see the scancodes that don't
>> match a map entry. A scancode would be first matched against the map,
>> then if there as no match an EV_IR event would be reported.
>
> There's nothing wrong on receiving a scancode that won't map. This can
> simply be an event that you don't want to handle (for example, an IR
> code sent to user's TV set).
>
> IMO, the better is to provide this scancode at KERN_DEBUG (if debug is
> enabled), and via an "observer" program.
>
> Cheers,
> Mauro.
>



-- 
Jon Smirl
jonsmirl@gmail.com
