Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZKZOqE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 09:46:04 -0500
Message-ID: <4B0E9493.1090200@redhat.com>
Date: Thu, 26 Nov 2009 12:45:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>	 <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com> <4B0DA885.7010601@redhat.com>
In-Reply-To: <4B0DA885.7010601@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann wrote:
> On 11/25/09 19:20, Devin Heitmueller wrote:
>> On Wed, Nov 25, 2009 at 1:07 PM, Jarod Wilson<jarod@wilsonet.com>
>> wrote:
>>> Took me a minute to figure out exactly what you were talking
>>> about. You're referring to the current in-kernel decoding done on
>>> an ad-hoc basis for assorted remotes bundled with capture devices,
>>> correct?
>>>
>>> Admittedly, unifying those and the lirc driven devices hasn't
>>> really been on my radar.
> 
> I think at the end of the day we'll want to have all IR drivers use the
> same interface.  The way the current in-kernel input layer drivers work
> obviously isn't perfect too, so we *must* consider both worlds to get a
> good solution for long-term ...
> 
>> This is one of the key use cases I would be very concerned with. For
>> many users who have bought tuner products, the bundled remotes work
>> "out-of-the-box", regardless of whether lircd is installed.
> 
> I bet this simply isn't going to change.
> 
>> I have no objection so much as to saying "well, you have to install
>> the lircd service now", but there needs to be a way for the driver to
>>  automatically tell lirc what the default remote control should be,
>> to avoid a regression in functionality.
> 
> *Requiring* lircd for the current in-kernel drivers doesn't make sense
> at all.  Allowing lircd being used so it can do some more advanced stuff
> makes sense though.
> 
>> This is why I think we really should put together a list of use
>> cases, so that we can see how any given proposal addresses those use
>> cases. I offered to do such, but nobody seemed really interested in
>> this.
> 
> Lets have a look at the problems the current input layer bits have
> compared to lirc:
> 
> 
> (1) ir code (say rc5) -> keycode conversion looses information.
> 
> I think this can easily be addressed by adding a IR event type to the
> input layer, which could look like this:
> 
>   input_event->type  = EV_IR
>   input_event->code  = IR_RC5
>   input_event->value = <rc5 value>

Agreed. We're doing this already with some drivers (dvb-usb ones). I've
started working on a patchset to extend this to the remaining drivers.
I'm not sure whare were already merged from this tree, but my intention
is to extend this to all drivers.

> In case the 32bit value is too small we might want send two events
> instead, with ->code being set to IR_<code>_1 and IR_<code>_2

Well, RC6 mode 6 uses 32 bits. I don't know if is there any case for
more than 32 bits. However, on some I2C IR chips, we see some cases
where the IR scancode key is encapsulated into some protocol with more
bytes. It seems that those extra bytes are used to handle key repetition
sort of events. I'm not sure if it would make sense to pass the raw 
data to userspace. Probably not.

> Advantages:
>   * Applications (including lircd) can get access to the unmodified
>     rc5/rc6/... codes.
>   * All the ir-code -> keycode mapping magic can be handled by the
>     core input layer then.  All the driver needs to do is to pass on
>     the information which keymap should be loaded by default (for the
>     bundled remote if any).  The configuration can happen in userspace
>     (sysfs attribute + udev + small utility in tools/ir/).

I like the idea of such small utility to load the keymap table.

>   * lirc drivers which get ir codes from the hardware can be converted
>     to pure input layer drivers without regressions.  lircd is not
>     required any more.
> 
> 
> (2) input layer doesn't give access to the raw samples.
> 
> Not sure how to deal with that best.  Passing them through the input
> layer would certainly be possible to hack up.  But what would be the
> point?  The input layer wouldn't do any processing on them.  It wouldn't
> buy us much.  So we might want to simply stick with todays lirc
> interface for the raw samples.

If we need such interface, the better is to keep using the lirc interface.
Yet, I'm not sure if we should really keep outputing raw samples, since
several devices won't support it.

> Drivers which support both ir codes (be it by hardware or by in-kernel
> decoding) and raw samples would register two devices then, one input
> device and one lirc device.  It would probably a good idea to stop
> sending events to the input layer as soon as someone (most likely lircd)
> opens the lirc device to avoid keystrokes showing up twice.
> 
> By default the in-kernel bits will be at work, but optionally you can
> have lircd grab the raw samples and do fancy advanced decoding.
> 
> 
> (3) input layer doesn't allow transmitting IR codes.
> 
> If we keep the lirc interface for raw samples anyway, then we can keep
> it for sending too, problem solved ;)  How does sending hardware work
> btw?  Do they all accept just raw samples?  Or does some hardware also
> accept ir-codes?

I would do it in a way that it will accept scancodes and raw samples, 
since, even if we currently have only devices that accept raw samples, 
it would be more future-proof to allow sending scancodes also.

Cheers,
Mauro
