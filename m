Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46757 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0E2Q7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 12:59:03 -0400
Received: by vws11 with SMTP id 11so311626vws.19
        for <linux-media@vger.kernel.org>; Sat, 29 May 2010 09:58:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275136793.2260.18.camel@localhost>
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
	<1275136793.2260.18.camel@localhost>
Date: Sat, 29 May 2010 12:58:55 -0400
Message-ID: <AANLkTil0U5s1UQiwiRRvvJOpEYbZwHpFG7NAkm7JJIEi@mail.gmail.com>
Subject: Re: ir-core multi-protocol decode and mceusb
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 29, 2010 at 8:39 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Fri, 2010-05-28 at 00:47 -0400, Jarod Wilson wrote:
>> So I'm inching closer to a viable mceusb driver submission -- both a
>> first-gen and a third-gen transceiver are now working perfectly with
>> multiple different mce remotes. However, that's only when I make sure
>> the mceusb driver is loaded w/only the rc6 decoder loaded. When
>> ir-core comes up, it requests all decoders to load, starting with the
>> nec decoder, followed by the rc5 decoder, then the rc6 decoder and so
>> on (init_decoders() in ir-raw-event.c). When I call
>> ir_raw_event_handle, all decoders get run on the ir data buffer,
>> starting with nec. Well, the nec decoder doesn't like the rc6 data, so
>> it pukes. The RUN_DECODER macro break's out of the routine when that
>> happens, and the rc6 decoder never gets a chance to run. (Similarly,
>> if only ir-nec-decoder has been removed, the rc5 decoder pukes on the
>> rc6 data, same problem).
>
> Yes, if the system kernel is going to attempt to discriminate between
> various input singals, it needs to let all its "correlators" run and
> produce a "confidence" number from each.
>
> Then ideally one would take the result with the highest confidence.
>
> Right now it looks like all the confidence determinations are boolean (0
> or -EINVAL) and there is no chance to deal with the case that two
> different decoders validly decode something.  The first decoder that
> declares a match "wins" and sends an event.

Yeah, it does look that way. I wonder how likely it is that e.g. a
valid RC6 signal would be decoded to something by say the NEC decoder,
with a resulting value that matched an entry in the (RC6) keymap
loaded for the remote... Certainly seems like something that *could*
happen somehow, but probably unlikely? I dunno... We do have the
option to disable all but the relevant protocol handler on a
per-device basis though, if that's a problem. Hrm, the key tables also
have a protocol tied to them, not sure if that's taken into account
when doing matching... Still getting to know the code. :)

>>  If I'm thinking clearly, rather than breaking
>> out of the loop in RUN_DECODER, we really ought to be issuing a
>> continue to go on to the next decoder, and possibly be accumulating
>> failures, though I don't know that _sumrc actually matters other than
>> "greater than zero" (i.e., at least one decoder was successfully able
>> to decode the signal). If I'm not thinking clearly, a pointer to what
>> I'm missing would be appreciated. :)
>
> You will have to deal with the case that two or more decoders may match
> and each sends an IR event.  (Unless the ir-core already deals with this
> somehow...)

Well, its gotta decode correctly to a value, and then match a value in
the loaded key table for an input event to get sent through. At least
for the RC6 MCE remotes, I haven't seen any of the other decoders take
the signal and interpret it as valid -- which ought to be by design,
if you consider that people use several different remotes with varying
ir signals with different devices all receiving them all the time
without problems (usually). And if we're not already, we could likely
add some logic to give higher precedence to values arrived at using
the protocol decoder that matches the key table we've got loaded for a
given device.

In looking closer at what we're doing now with RUN_DECODER(), it seems
only __ir_input_register() actually cares about the retval, and
unfortunately, it seems to be checking for a ret < 0 to indicate
failure, which isn't possible -- its _sumrc that gets returned, and
its initialized to 0, then only ever adjusted if _rc >= 0, so we'll
never see it as a failure in __ir_input_register().

Given that bit of data, I'd say the patch I submitted yesterday isn't
quite correct. I think RUN_DECODER should actually be adding _rc to
_sumrc in all cases -- instead of an if/else on _rc < 0, just always
do the _sumrc += _rc and return _sumrc, which will either be 0 or some
negative value. I don't think we need to worry at all about the retval
we get from the decode functions though -- either we get one or more
decoded values to match against our key table or we don't...

-- 
Jarod Wilson
jarod@wilsonet.com
