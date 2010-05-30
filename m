Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34654 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0E3T5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 15:57:37 -0400
Received: by vws11 with SMTP id 11so1331834vws.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 12:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C02700A.9040807@redhat.com>
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
	<1275136793.2260.18.camel@localhost>
	<AANLkTil0U5s1UQiwiRRvvJOpEYbZwHpFG7NAkm7JJIEi@mail.gmail.com>
	<1275163295.17477.143.camel@localhost>
	<AANLkTilsB6zTMwJjBdRwwZChQdH5KdiOeb5jFcWvyHSu@mail.gmail.com>
	<4C02700A.9040807@redhat.com>
Date: Sun, 30 May 2010 15:57:35 -0400
Message-ID: <AANLkTimYjc0reLHV6RtGFIMFz1bbjyZiTYGj1TcacVzT@mail.gmail.com>
Subject: Re: ir-core multi-protocol decode and mceusb
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 30, 2010 at 10:02 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 29-05-2010 23:24, Jarod Wilson escreveu:
>> On Sat, May 29, 2010 at 4:01 PM, Andy Walls <awalls@md.metrocast.net> wrote:
...
>>>>  We do have the
>>>> option to disable all but the relevant protocol handler on a
>>>> per-device basis though, if that's a problem. Hrm, the key tables also
>>>> have a protocol tied to them, not sure if that's taken into account
>>>> when doing matching... Still getting to know the code. :)
>>>
>>> It does not look like
>>>
>>>        ir_keydown()
>>>                ir_g_keycode_from_table()
>>>                        ir_getkeycode()
>>>
>>> bother to check the ir_type (e.g. IR_TYPE_NEC) of the keymap against the
>>> decoders type.  Neither do the decoders themselves.
>>>
>>>
>>> If a decoder decodes something and thinks its valid, it tries to send a
>>> key event with ir_keydown().  ir_keydown() won't send a key event if the
>>> lookup comes back KEY_RESERVED, but it doesn't tell the decoder about
>>> the failure to find a key mapping.  A decoder can come back saying it
>>> did it's job, without knowing whether or not the decoding corresponded
>>> to a valid key in the loaded keymap. :(
>>>
>>>
>>>>> You will have to deal with the case that two or more decoders may match
>>>>> and each sends an IR event.  (Unless the ir-core already deals with this
>>>>> somehow...)
>>>>
>>>> Well, its gotta decode correctly to a value, and then match a value in
>>>> the loaded key table for an input event to get sent through. At least
>>>> for the RC6 MCE remotes, I haven't seen any of the other decoders take
>>>> the signal and interpret it as valid -- which ought to be by design,
>>>> if you consider that people use several different remotes with varying
>>>> ir signals with different devices all receiving them all the time
>>>> without problems (usually). And if we're not already, we could likely
>>>> add some logic to give higher precedence to values arrived at using
>>>> the protocol decoder that matches the key table we've got loaded for a
>>>> given device.
>>>
>>> After looking at things, the only potential problem I can see right now
>>> is with the JVC decoder and NEC remotes.
>>>
>>> I think that problem is most easily eliminated either by
>>>
>>> a. having ir_keydown() (or the functions it calls) check to see that the
>>> decoder matches the loaded keymap, or
>>>
>>> b. only calling the decoder that matches the loaded keymap's protocol
>>>
>>> Of the above, b. saves processor cycles and frees up the global
>>> ir_raw_handler spin lock sooner.  That spin lock is serializing pulse
>>> decoding for all the IR receivers in the system  (pulse decoding can
>>> still be interleaved, just only one IR receiver's pulses are be
>>> processed at any time).  What's the point of running decoders that
>>> should never match the loaded keymap?
>>
>> For the daily use case where a known-good keymap is in place, I'm
>> coming to the conclusion that there's no point, we're only wasting
>> resources. For initial "figure out what this remote is" type of stuff,
>> running all decoders makes sense. One thought I had was that perhaps
>> we start by running through the decoder that is listed in the keymap.
>> If it decodes to a scancode and we find a valid key in the key table
>> (i.e., not KEY_RESERVED), we're done. If decoding fails or we don't
>> find a valid key, then try the other decoders. However, this is
>> possibly also wasteful -- most people with any somewhat involved htpc
>> setup are going to be constantly sending IR signals intended for other
>> devices that we pick up and try to decode.
>>
>> So I'd say we go with your option b, and only call the decoder that
>> matches the loaded keymap. One could either pass in a modparam or
>> twiddle a sysfs attr or use ir-keytable to put the receiver into a
>> mode that called all decoders -- i.e., set protocol to
>> IR_TYPE_UNKNOWN, with the intention being to figure it out based on
>> running all decoders, and create a new keymap where IR_TYPE_FOO is
>> known.
>
> There's no need to extra parameters. Decoders can be disabled by userspace,
> per each rc sysfs node. Btw, the current version of ir-keytable already sets
> the enabled protocols based on the protocol reported by the rc keymap.
>
> What it makes sense is to add a patch at RC core that will properly enable/disable
> the protocols based on IR_TYPE, when the rc-map is stored in-kernel.

Ah, yeah, that does make sense. And if we add that, ir-keytable
doesn't actually have to worry about doing similar itself any longer.
If you're not already working on it, I can try to whip something up,
though I'm knee-deep in an ir-lirc-codec bridge right now...

-- 
Jarod Wilson
jarod@wilsonet.com
