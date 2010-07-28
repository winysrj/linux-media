Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47499 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0G1Ol3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 10:41:29 -0400
MIME-Version: 1.0
In-Reply-To: <1280327080.9175.58.camel@maxim-laptop>
References: <1280269990.21278.15.camel@maxim-laptop>
	<1280273550.32216.4.camel@maxim-laptop>
	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	<AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
	<1280298606.6736.15.camel@maxim-laptop>
	<AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
	<4C502CE6.80106@redhat.com>
	<1280327080.9175.58.camel@maxim-laptop>
Date: Wed, 28 Jul 2010 10:41:27 -0400
Message-ID: <AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Jon Smirl <jonsmirl@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 10:24 AM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> On Wed, 2010-07-28 at 10:13 -0300, Mauro Carvalho Chehab wrote:
>> Em 28-07-2010 07:40, Jon Smirl escreveu:
>> > On Wed, Jul 28, 2010 at 2:30 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> >> On Tue, 2010-07-27 at 22:33 -0400, Jarod Wilson wrote:
>> >>> On Tue, Jul 27, 2010 at 9:29 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>>
>> >> No its not, its just extended NEC.
>> >
>> > http://www.sbprojects.com/knowledge/ir/nec.htm
>> > Says the last two bytes should be the complement of each other.
>> >
>> > So for extended NEC it would need to be:
>> > 1100 0010 1010 0101 instead of 1100 0010 1010 0100
>> > The last bit is wrong.
>> >
>> > From the debug output it is decoding as NEC, but then it fails a
>> > consistency check. Maybe we need to add a new protocol that lets NEC
>> > commands through even if they fail the error checks.
>>
>> Assuming that Maxim's IR receiver is not causing some bad decode at the
>> NEC code, it seems simpler to add a parameter at sysfs to relax the NEC
>> detection. We should add some way, at the userspace table for those RC's
>> that uses a NEC-like code.
>>
>> There's another alternative: currently, the NEC decoder produces a 16 bits
>> code for NEC and a 24 bits for NEC-extended code. The decoder may return a
>> 32 bits code when none of the checksum's match the NEC or NEC-extended standard.
>>
>> Such 32 bits code won't match a keycode on a 16-bits or 24-bits table, so
>> there's no risk of generating a wrong keycode, if the wrong consistent check
>> is due to a reception error.
>>
>> Btw, we still need to port rc core to use the new tables ioctl's, as cleaning
>> all keycodes on a 32 bits table would take forever with the current input
>> events ioctls.
>>
>> > It may also be
>> > that the NEC machine rejected it because the timing was so far off
>> > that it concluded that it couldn't be a NEC messages. The log didn't
>> > include the exact reason it got rejected. Add some printks at the end
>> > of the NEC machine to determine the exact reason for rejection.
>>
>> The better is to discard the possibility of a timing issue before changing
>> the decoder to accept NEC-like codes without consistency checks.
>>
>> > The current state machines enforce protocol compliance so there are
>> > probably a lot of older remotes that won't decode right. We can use
>> > some help in adjusting the state machines to let out of spec codes
>> > through.
>>
>> Yes, but we should take some care to avoid having another protocol decoder to
>> interpret badly a different protocol. So, I think that the decoders may have
>> some sysfs nodes to tweak the decoders to accept those older remotes.
>>
>> We'll need a consistent way to add some logic at the remotes keycodes used by
>> ir-keycode, in order to allow it to tweak the decoder when a keycode table for
>> such remote is loaded into the driver.
>>
>> > User space lirc is much older. Bugs like this have been worked out of
>> > it. It will take some time to get the kernel implementation up to the
>> > same level.
>>
>> True.
>
>
> I more or less got to the bottom of this.
>
>
> It turns out that ENE reciever has a non linear measurement error.
> That is the longer sample is, the larger error it contains.
> Substracting around 4% from the samples makes the output look much more
> standard compliant.

Most of the protocols are arranged using power of two timings.

For example 562.5, 1125, 2250, 4500, 9000 -- NEC
525, 1050, 2100, 4200, 8400 - JVC

The decoders are designed to be much more sensitive to the power of
two relationship than the exact timing. Your non-linear error messed
up the relationship.

>
> You are right that my remote has  JVC protocol. (at least I am sure now
> it hasn't NEC, because repeat looks differently).
>
> My remote now actually partially works with JVC decoder, it decodes
> every other keypress.
>
> Still, no repeat is supported.

It probably isn't implemented yet. Jarod has been focusing more on
getting the basic decoders to work.

> However, all recievers (and transmitters) aren't perfect.
> Thats why I prefer lirc, because it makes no assumptions about protocol,
> so it can be 'trained' to work with any remote, and under very large
> range of error tolerances.

It's possible to build a Linux IR decoder engine that can be loaded
with the old LIRC config files.  But before doing this we should work
on getting all of the errors out of the standard decoders.

>
> Best regards,
> Maxim Levitsky
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
