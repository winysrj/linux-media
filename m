Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35109 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0HBUm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 16:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100802180940.GF2296@redhat.com>
References: <AANLkTi=F4CQ2_pCDno1SNGS6w=7wERk1FwjezkwC=nS5@mail.gmail.com>
	<BU4OxfMZjFB@christoph>
	<AANLkTimXULCDLw6=kcFC2Kddbm4kuO4nqtXL6ozftMQj@mail.gmail.com>
	<20100802180940.GF2296@redhat.com>
Date: Mon, 2 Aug 2010 16:42:25 -0400
Message-ID: <AANLkTin9+s_AbKst+ZsY6CfzeRYCh=V7kjseut5sbO23@mail.gmail.com>
Subject: Re: Remote that breaks current system
From: Jon Smirl <jonsmirl@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>,
	Jarod Wilson <jarod@wilsonet.com>, awalls@md.metrocast.net,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 2, 2010 at 2:09 PM, Jarod Wilson <jarod@redhat.com> wrote:
> On Mon, Aug 02, 2010 at 01:13:22PM -0400, Jon Smirl wrote:
>> On Mon, Aug 2, 2010 at 12:42 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>> > Hi!
>> >
>> > Jon Smirl "jonsmirl@gmail.com" wrote:
>> > [...]
>> >>> Got one. The Streamzap PC Remote. Its 14-bit RC5. Can't get it to properly
>> >>> decode in-kernel for the life of me. I got lirc_streamzap 99% of the way
>> >>> ported over the weekend, but this remote just won't decode correctly w/the
>> >>> in-kernel RC5 decoder.
>> >
>> >> Manchester encoding may need a decoder that waits to get 2-3 edge
>> >> changes before deciding what the first bit. As you decode the output
>> >> is always a couple bits behind the current input data.
>> >>
>> >> You can build of a table of states
>> >> L0 S1 S0 L1  - emit a 1, move forward an edge
>> >> S0 S1 L0 L1 - emit a 0, move forward an edge
>> >>
>> >> By doing it that way you don't have to initially figure out the bit clock.
>> >>
>> >> The current decoder code may not be properly tracking the leading
>> >> zero. In Manchester encoding it is illegal for a bit to be 11 or 00.
>> >> They have to be 01 or 10. If you get a 11 or 00 bit, your decoding is
>> >> off by 1/2 a bit cycle.
>> >>
>> >> Did you note the comment that Extended RC-5 has only a single start
>> >> bit instead of two?
>> >
>> > It has nothing to do with start bits.
>> > The Streamzap remote just sends 14 (sic!) bits instead of 13.
>> > The decoder expects 13 bits.
>> > Yes, the Streamzap remote does _not_ use standard RC-5.
>> > Did I mention this already? Yes. ;-)
>>
>> If the remote is sending a weird protocol then there are several choices:
>>   1) implement raw mode
>>   2) make a Stream-Zap protocol engine (it would be a 14b version of
>> RC-5). Standard RC5 engine will still reject the messages.
>>   3) throw away your Stream-Zap remotes
>>
>> I'd vote for #3, but #2 will probably make people happier.
>
> Hm. Yeah, I know a few people who are quite attached to their Streamzap
> remotes. I'm not a particularly big fan of it, I only got the thing off
> ebay to have the hardware so I could work on the driver. :) So yeah, #3 is
> probably not the best route. But I don't know that I'm a huge fan of #2
> either. Another decoder engine just for one quirky remote seems excessive,
> and there's an option #4:
>
> 4) just keep passing data out to lirc by default.

That's a decent idea. Implement the mainstream, standard protocols in
the kernel and kick the weird stuff out to LIRC. We can avoid the
whole world of raw mode, config files, etc. Let LIRC deal with all
that. If the weird stuff gets enough users bring it in-kernel.  Maybe
StreamZap will suddenly sell a million units, you never know.

It is easy to implement a StreamZap engine. Just copy the RC5 one.
Rename everything and adjust it to require one more bit. You'll have
to modify the RC5 to wait for a bit interval (timeout) before sending
the data up. If you want to get fancy use a weak symbol in the
StrreamZap engine to tell the RC5 engine if Stream Zap is loaded. Then
you can decide to wait the extra bit interval or not.

> Let lircd handle the default remote in this case. If you want to use
> another remote that actually uses a standard protocol, and want to use
> in-kernel decoding for that, its just an ir-keytable call away.
>
> For giggles, I may tinker with implementing another decoder engine though,
> if only to force myself to actually pay more attention to protocol
> specifics. For the moment, I'm inclined to go ahead with the streamzap
> port as it is right now, and include either an empty or not-empty, but
> not-functional key table.
>
> --
> Jarod Wilson
> jarod@redhat.com
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
