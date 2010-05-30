Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0E3OCu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 10:02:50 -0400
Message-ID: <4C02700A.9040807@redhat.com>
Date: Sun, 30 May 2010 11:02:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: Re: ir-core multi-protocol decode and mceusb
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>	<1275136793.2260.18.camel@localhost>	<AANLkTil0U5s1UQiwiRRvvJOpEYbZwHpFG7NAkm7JJIEi@mail.gmail.com>	<1275163295.17477.143.camel@localhost> <AANLkTilsB6zTMwJjBdRwwZChQdH5KdiOeb5jFcWvyHSu@mail.gmail.com>
In-Reply-To: <AANLkTilsB6zTMwJjBdRwwZChQdH5KdiOeb5jFcWvyHSu@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-05-2010 23:24, Jarod Wilson escreveu:
> On Sat, May 29, 2010 at 4:01 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Sat, 2010-05-29 at 12:58 -0400, Jarod Wilson wrote:
>>> On Sat, May 29, 2010 at 8:39 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>>>> On Fri, 2010-05-28 at 00:47 -0400, Jarod Wilson wrote:
>>>>> So I'm inching closer to a viable mceusb driver submission -- both a
>>>>> first-gen and a third-gen transceiver are now working perfectly with
>>>>> multiple different mce remotes. However, that's only when I make sure
>>>>> the mceusb driver is loaded w/only the rc6 decoder loaded. When
>>>>> ir-core comes up, it requests all decoders to load, starting with the
>>>>> nec decoder, followed by the rc5 decoder, then the rc6 decoder and so
>>>>> on (init_decoders() in ir-raw-event.c). When I call
>>>>> ir_raw_event_handle, all decoders get run on the ir data buffer,
>>>>> starting with nec. Well, the nec decoder doesn't like the rc6 data, so
>>>>> it pukes. The RUN_DECODER macro break's out of the routine when that
>>>>> happens, and the rc6 decoder never gets a chance to run. (Similarly,
>>>>> if only ir-nec-decoder has been removed, the rc5 decoder pukes on the
>>>>> rc6 data, same problem).
>>>>
>>>> Yes, if the system kernel is going to attempt to discriminate between
>>>> various input singals, it needs to let all its "correlators" run and
>>>> produce a "confidence" number from each.
>>>>
>>>> Then ideally one would take the result with the highest confidence.
>>>>
>>>> Right now it looks like all the confidence determinations are boolean (0
>>>> or -EINVAL) and there is no chance to deal with the case that two
>>>> different decoders validly decode something.  The first decoder that
>>>> declares a match "wins" and sends an event.
>>>
>>> Yeah, it does look that way. I wonder how likely it is that e.g. a
>>> valid RC6 signal would be decoded to something by say the NEC decoder,
>>
>> NEC is a pulse position code and RC-6 is manchester encoded, so that
>> particular case would be unlikely.
>>
>> I would think one would have a better chance of false positiive
>> detections between similar encoding types: pulse position, pulse width,
>> or manchester.
>>
>> Looking at slide 11 of this:
>>
>>        http://www.audiodevelopers.com/temp/Remote_Controls.ppt
>>
>> It looks like the pulse position protocols with a header space of 8T
>> (where 8T is about 4ms) would be the only ones that could get confused.
>>
>> Since these are streaming decoders, it looks like JVC would come up with
>> false detections first, since it has the shortest payload of the pulse
>> position protocols.  I think JVC will always claim to decode an NEC
>> pulse train.  (I'll try to test that sometime.)
>>
>>
>>> with a resulting value that matched an entry in the (RC6) keymap
>>> loaded for the remote... Certainly seems like something that *could*
>>> happen somehow, but probably unlikely? I dunno...
>>
>> I don't know either.  There appears to be a chance for the first 16 bits
>> of a transmitted NEC (Addr:Addr') or Extended NEC (AddrHi:AddrLo)
>> sequence, to be interpreted as JVC (Addr:Cmd), and the JVC decoder
>> matching a scancode in the keytable for the NEC remote.
>>
>>
>>
>>
>>>  We do have the
>>> option to disable all but the relevant protocol handler on a
>>> per-device basis though, if that's a problem. Hrm, the key tables also
>>> have a protocol tied to them, not sure if that's taken into account
>>> when doing matching... Still getting to know the code. :)
>>
>> It does not look like
>>
>>        ir_keydown()
>>                ir_g_keycode_from_table()
>>                        ir_getkeycode()
>>
>> bother to check the ir_type (e.g. IR_TYPE_NEC) of the keymap against the
>> decoders type.  Neither do the decoders themselves.
>>
>>
>> If a decoder decodes something and thinks its valid, it tries to send a
>> key event with ir_keydown().  ir_keydown() won't send a key event if the
>> lookup comes back KEY_RESERVED, but it doesn't tell the decoder about
>> the failure to find a key mapping.  A decoder can come back saying it
>> did it's job, without knowing whether or not the decoding corresponded
>> to a valid key in the loaded keymap. :(
>>
>>
>>>> You will have to deal with the case that two or more decoders may match
>>>> and each sends an IR event.  (Unless the ir-core already deals with this
>>>> somehow...)
>>>
>>> Well, its gotta decode correctly to a value, and then match a value in
>>> the loaded key table for an input event to get sent through. At least
>>> for the RC6 MCE remotes, I haven't seen any of the other decoders take
>>> the signal and interpret it as valid -- which ought to be by design,
>>> if you consider that people use several different remotes with varying
>>> ir signals with different devices all receiving them all the time
>>> without problems (usually). And if we're not already, we could likely
>>> add some logic to give higher precedence to values arrived at using
>>> the protocol decoder that matches the key table we've got loaded for a
>>> given device.
>>
>> After looking at things, the only potential problem I can see right now
>> is with the JVC decoder and NEC remotes.
>>
>> I think that problem is most easily eliminated either by
>>
>> a. having ir_keydown() (or the functions it calls) check to see that the
>> decoder matches the loaded keymap, or
>>
>> b. only calling the decoder that matches the loaded keymap's protocol
>>
>> Of the above, b. saves processor cycles and frees up the global
>> ir_raw_handler spin lock sooner.  That spin lock is serializing pulse
>> decoding for all the IR receivers in the system  (pulse decoding can
>> still be interleaved, just only one IR receiver's pulses are be
>> processed at any time).  What's the point of running decoders that
>> should never match the loaded keymap?
> 
> For the daily use case where a known-good keymap is in place, I'm
> coming to the conclusion that there's no point, we're only wasting
> resources. For initial "figure out what this remote is" type of stuff,
> running all decoders makes sense. One thought I had was that perhaps
> we start by running through the decoder that is listed in the keymap.
> If it decodes to a scancode and we find a valid key in the key table
> (i.e., not KEY_RESERVED), we're done. If decoding fails or we don't
> find a valid key, then try the other decoders. However, this is
> possibly also wasteful -- most people with any somewhat involved htpc
> setup are going to be constantly sending IR signals intended for other
> devices that we pick up and try to decode.
> 
> So I'd say we go with your option b, and only call the decoder that
> matches the loaded keymap. One could either pass in a modparam or
> twiddle a sysfs attr or use ir-keytable to put the receiver into a
> mode that called all decoders -- i.e., set protocol to
> IR_TYPE_UNKNOWN, with the intention being to figure it out based on
> running all decoders, and create a new keymap where IR_TYPE_FOO is
> known.

There's no need to extra parameters. Decoders can be disabled by userspace,
per each rc sysfs node. Btw, the current version of ir-keytable already sets
the enabled protocols based on the protocol reported by the rc keymap.

What it makes sense is to add a patch at RC core that will properly enable/disable
the protocols based on IR_TYPE, when the rc-map is stored in-kernel.

Cheers,
Mauro.
