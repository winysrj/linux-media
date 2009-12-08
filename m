Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63877 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZLHNri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 08:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <4B1E54FF.8060404@redhat.com>
References: <BDRae8rZjFB@christoph>
	 <1259024037.3871.36.camel@palomino.walls.org>
	 <m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com>
	 <1259264614.1781.47.camel@localhost>
	 <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>
	 <1260240142.3086.14.camel@palomino.walls.org>
	 <20091208042210.GA11147@core.coreip.homeip.net>
	 <1260275743.3094.6.camel@palomino.walls.org>
	 <4B1E54FF.8060404@redhat.com>
Date: Tue, 8 Dec 2009 08:47:45 -0500
Message-ID: <9e4733910912080547j75c2c885o29664470ff5e2c6a@mail.gmail.com>
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

On Tue, Dec 8, 2009 at 8:30 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Andy Walls wrote:
>> On Mon, 2009-12-07 at 20:22 -0800, Dmitry Torokhov wrote:
>>> On Mon, Dec 07, 2009 at 09:42:22PM -0500, Andy Walls wrote:
>>
>>>> So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
>>>> end of the month.
>>>>
>>>> I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
>>>> a common set of parameters, so I may be able to set up the decoders to
>>>> handle decoding from two different remote types at once.  The HVR boards
>>>> can ship with either type of remote AFAIK.
>>>>
>>>> I wonder if I can flip the keytables on the fly or if I have to create
>>>> two different input devices?
>>>>
>>> Can you distinguish between the 2 remotes (not receivers)?
>>
>> Yes.  RC-6 and RC-5 are different enough to distinguish between the two.
>> (Honestly I could pile on more protocols that have similar pulse time
>> periods, but that's complexity for no good reason and I don't know of a
>> vendor that bundles 3 types of remotes per TV card.)
>
> You'll be distinguishing the protocol, not the remote. If I understood
> Dmitry's question, he is asking if you can distinguish between two different
> remotes that may, for example, be using both RC-5 or both RC-6 or one RC-5
> and another RC-6.

RC-5 and RC-6 both contain an address field.  My opinion is that
different addresses represent different devices and in general they
should appear on an input devices per address.

However, I prefer a different scheme for splitting the signals apart.
Load separate maps containing scancodes for each address. When the IR
signals come in they are matched against the maps and a keycode is
generated when a match is found. Now there is no need to distinguish
between the remotes. It doesn't matter which remote generated the
signal.

scancode RC5/12/1 - protocol, address, command tuplet. Map this to
KP_1 on interface 1.
scancode RC5/7/1 - protocol, address, command tuplet. Map this to KP_1
on interface 2.

Using the maps to split the commands out also fixes the problem with
Sony remotes which use multiple protocols to control a single device.
scancode Sony12/12/1 - protocol, address, command tuplet. Map this to
power_on on interface 1.
scancode Sony15/12/1 - protocol, address, command tuplet. Map this to
KP_1 on interface 1.


>
>>>  Like I said,
>>> I think the preferred way is to represent every remote that can be
>>> distinguished from each other as a separate input device.
>>
>> OK.  With RC-5, NEC, and RC-6 at least there is also an address or
>> system byte or word to distingish different remotes.  However creating
>> multiple input devices on the fly for detected remotes would be madness
>> - especially with a decoding error in the address bits.
>>
>> Any one vendor usually picks one address for their bundled remote.
>> Hauppaugue uses address 0x1e for it's RC-5 remotes AFAICT.
>
> The address field on RC-5 protocol is not meant to distinguish different
> vendors, but different "applications". It identifies that a code should
> be sent to a TV or a VCR, or a DVD or a SAT.
>
> In the case of bundled IR's, some vendors like Hauppauge opted to use a
> reserved address to avoid conflicts with other equipments. It happens that
> vendor's "reserved address" can be different between two different vendors,
> but is just an educated guess to say that an address equal to 0x1e is Hauppauge.
>
> Cheers,
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
