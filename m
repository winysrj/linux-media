Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60159 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZLHMvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 07:51:55 -0500
MIME-Version: 1.0
In-Reply-To: <1260275743.3094.6.camel@palomino.walls.org>
References: <BDRae8rZjFB@christoph>
	 <1259024037.3871.36.camel@palomino.walls.org>
	 <m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com>
	 <1259264614.1781.47.camel@localhost>
	 <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>
	 <1260240142.3086.14.camel@palomino.walls.org>
	 <20091208042210.GA11147@core.coreip.homeip.net>
	 <1260275743.3094.6.camel@palomino.walls.org>
Date: Tue, 8 Dec 2009 07:52:02 -0500
Message-ID: <9e4733910912080452p42efa794mb7fd608fa4fbad7c@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Jon Smirl <jonsmirl@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 8, 2009 at 7:35 AM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2009-12-07 at 20:22 -0800, Dmitry Torokhov wrote:
>> On Mon, Dec 07, 2009 at 09:42:22PM -0500, Andy Walls wrote:
>
>> > So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
>> > end of the month.
>> >
>> > I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
>> > a common set of parameters, so I may be able to set up the decoders to
>> > handle decoding from two different remote types at once.  The HVR boards
>> > can ship with either type of remote AFAIK.
>> >
>> > I wonder if I can flip the keytables on the fly or if I have to create
>> > two different input devices?
>> >
>>
>> Can you distinguish between the 2 remotes (not receivers)?
>
> Yes.  RC-6 and RC-5 are different enough to distinguish between the two.
> (Honestly I could pile on more protocols that have similar pulse time
> periods, but that's complexity for no good reason and I don't know of a
> vendor that bundles 3 types of remotes per TV card.)
>
>
>>  Like I said,
>> I think the preferred way is to represent every remote that can be
>> distinguished from each other as a separate input device.
>
> OK.  With RC-5, NEC, and RC-6 at least there is also an address or
> system byte or word to distingish different remotes.  However creating
> multiple input devices on the fly for detected remotes would be madness
> - especially with a decoding error in the address bits.

I agree that creating devices on the fly has problems. Another
solution is to create one device for each map that is loaded. There
would be a couple built-in maps for bundled remotes - each would
create a device. Then the user could load more maps with each map
creating a device.

Incoming scancodes are matched against all of the loaded maps and a
keycode event is generated if a match occurs.

This illustrates why there should an EV_IR event which communicates
scancodes, without this event you can't see the scancodes that don't
match a map entry. A scancode would be first matched against the map,
then if there as no match an EV_IR event would be reported.


>
> Any one vendor usually picks one address for their bundled remote.
> Hauppaugue uses address 0x1e for it's RC-5 remotes AFAICT.
>
>
>
>>  Applications
>> expect to query device capabilities and expect them to stay somewhat
>> stable (we do support keymap change but I don't think anyone expectes
>> flip-flopping).
>
> OK.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
