Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58513 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab0HPUmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 16:42:01 -0400
Subject: Re: Remote that breaks current system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, awalls@md.metrocast.net,
	jarod@redhat.com, jonsmirl@gmail.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com
In-Reply-To: <AANLkTik7pPs6Bs6Pgq_MG00ONcZWEKFnfUqrTZtgwQRa@mail.gmail.com>
References: <AANLkTimz2eLSEy+U1NdMVsQ=af7v67omPntwMQs+8jno@mail.gmail.com>
	 <BUhP+pZ3jFB@christoph>
	 <AANLkTik7pPs6Bs6Pgq_MG00ONcZWEKFnfUqrTZtgwQRa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 23:41:52 +0300
Message-ID: <1281991312.3661.2.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, 2010-08-16 at 00:04 -0400, Jarod Wilson wrote: 
> On Thu, Aug 12, 2010 at 2:46 AM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> ...
> >> So I spent a while beating on things the past few nights for giggles
> >> (and for a sanity break from "vacation" with too many kids...). I
> >> ended up doing a rather large amount of somewhat invasive work to the
> >> streamzap driver itself, but the end result is functional in-kernel
> >> decoding, and lirc userspace decode continues to behave correctly. RFC
> >> patch here:
> >>
> >> http://wilsonet.com/jarod/ir-core/IR-streamzap-in-kernel-decode.patch
> >>
> >> Core changes to streamzap.c itself:
> >>
> >> - had to enable reporting of a long space at the conclusion of each
> >> signal (which is what the lirc driver would do w/timeout_enabled set),
> >> otherwise I kept having issues with key bounce and/or old data being
> >> buffered (i.e., press up, cursor moves up. push down, cursor moves up
> >> then down, press left, it moves down, then left, etc.). Still not
> >> quite sure what the real problem is there, the lirc userspace decoder
> >> has no problems with it either way.
> >>
> >> - removed streamzap's internal delay buffer, as the ir-core kfifo
> >> seems to provide the necessary signal buffering just fine by itself.
> >> Can't see any significant difference in decode performance either
> >> in-kernel or via lirc with it removed, anyway. (Christoph, can you
> >> perhaps expand a bit on why the delay buffer was originally needed/how
> >> to reproduce the problem it was intended to solve? Maybe I'm just not
> >> triggering it yet.)
> >
> > Should be fine. Current lircd with timeout support shouldn't have a
> > problem with that anymore. I was already thinking of suggesting to remove
> > the delay buffer.
> 
> Cool, sounds like a plan then, I'll go ahead with it.
> 
> >> Other fun stuff to note:
> >>
> >> - currently, loading up an rc5-sz decoder unconditionally, have
> >> considered only auto-loading it from the streamzap driver itself. Its
> >> a copy of the rc5 decoder with relatively minor tweaks to deal with
> >> the extra bit and resulting slightly different bit layout. Might
> >> actually be possible to merge back into the rc5 decoder itself,
> >> haven't really looked into that yet (should be entirely doable if
> >> there's an easy way to figure out early on if we need to grab 14
> >> bits).
> >
> > There is no way until you see the 14th bit.
> 
> Hm. Was afraid of that. I gave it a shot to see if I could make that
> work, pretty shaky results. About 2/3 of the keys get decoded as
> 15-bit streamzap, the other 1/3 get decoded as 14-bit RC5, and don't
> match anything in the keytable (and often duplicate one another). So
> it looks like at least for the time being, a separate parallel decoder
> is the way to go. I'm thinking that I like the approach of only
> explicitly loading it from the streamzap driver though.

Just one minor nitpick.
You could 'use' the original RC5 decoder, but add a knob to it to make
it accept 15 bits instead of 14.
However, this will require some interface changes.


Best regards,
Maxim Levitsky

