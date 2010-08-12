Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:61486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0HLGs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 02:48:27 -0400
Date: 12 Aug 2010 08:46:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jarod@wilsonet.com
Cc: awalls@md.metrocast.net
Cc: jarod@redhat.com
Cc: jonsmirl@gmail.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Message-ID: <BUhP+pZ3jFB@christoph>
In-Reply-To: <AANLkTimz2eLSEy+U1NdMVsQ=af7v67omPntwMQs+8jno@mail.gmail.com>
Subject: Re: Remote that breaks current system
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Jarod,

on 11 Aug 10 at 10:38, Jarod Wilson wrote:
> On Mon, Aug 2, 2010 at 4:42 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>> On Mon, Aug 2, 2010 at 2:09 PM, Jarod Wilson <jarod@redhat.com> wrote:
>>> On Mon, Aug 02, 2010 at 01:13:22PM -0400, Jon Smirl wrote:
>>>> On Mon, Aug 2, 2010 at 12:42 PM, Christoph Bartelmus <lirc@bartelmus.de>
>>>> wrote:
> ....
>>>>> It has nothing to do with start bits.
>>>>> The Streamzap remote just sends 14 (sic!) bits instead of 13.
>>>>> The decoder expects 13 bits.
>>>>> Yes, the Streamzap remote does _not_ use standard RC-5.
>>>>> Did I mention this already? Yes. ;-)
>>>>
>>>> If the remote is sending a weird protocol then there are several choices:
>>>>   1) implement raw mode
>>>>   2) make a Stream-Zap protocol engine (it would be a 14b version of
>>>> RC-5). Standard RC5 engine will still reject the messages.
>>>>   3) throw away your Stream-Zap remotes
>>>>
>>>> I'd vote for #3, but #2 will probably make people happier.
>>>
>>> Hm. Yeah, I know a few people who are quite attached to their Streamzap
>>> remotes. I'm not a particularly big fan of it, I only got the thing off
>>> ebay to have the hardware so I could work on the driver. :) So yeah, #3 is
>>> probably not the best route. But I don't know that I'm a huge fan of #2
>>> either. Another decoder engine just for one quirky remote seems excessive,
>>> and there's an option #4:
>>>
>>> 4) just keep passing data out to lirc by default.
>>
>> That's a decent idea. Implement the mainstream, standard protocols in
>> the kernel and kick the weird stuff out to LIRC. We can avoid the
>> whole world of raw mode, config files, etc. Let LIRC deal with all
>> that. If the weird stuff gets enough users bring it in-kernel.  Maybe
>> StreamZap will suddenly sell a million units, you never know.
>>
>> It is easy to implement a StreamZap engine. Just copy the RC5 one.
>> Rename everything and adjust it to require one more bit. You'll have
>> to modify the RC5 to wait for a bit interval (timeout) before sending
>> the data up. If you want to get fancy use a weak symbol in the
>> StrreamZap engine to tell the RC5 engine if Stream Zap is loaded. Then
>> you can decide to wait the extra bit interval or not.

> The other thought I had was to not load the engine by default, and
> only auto-load it from the streamzap driver itself.

>>> Let lircd handle the default remote in this case. If you want to use
>>> another remote that actually uses a standard protocol, and want to use
>>> in-kernel decoding for that, its just an ir-keytable call away.
>>>
>>> For giggles, I may tinker with implementing another decoder engine though,
>>> if only to force myself to actually pay more attention to protocol
>>> specifics. For the moment, I'm inclined to go ahead with the streamzap
>>> port as it is right now, and include either an empty or not-empty, but
>>> not-functional key table.

> So I spent a while beating on things the past few nights for giggles
> (and for a sanity break from "vacation" with too many kids...). I
> ended up doing a rather large amount of somewhat invasive work to the
> streamzap driver itself, but the end result is functional in-kernel
> decoding, and lirc userspace decode continues to behave correctly. RFC
> patch here:
>
> http://wilsonet.com/jarod/ir-core/IR-streamzap-in-kernel-decode.patch
>
> Core changes to streamzap.c itself:
>
> - had to enable reporting of a long space at the conclusion of each
> signal (which is what the lirc driver would do w/timeout_enabled set),
> otherwise I kept having issues with key bounce and/or old data being
> buffered (i.e., press up, cursor moves up. push down, cursor moves up
> then down, press left, it moves down, then left, etc.). Still not
> quite sure what the real problem is there, the lirc userspace decoder
> has no problems with it either way.
>
> - removed streamzap's internal delay buffer, as the ir-core kfifo
> seems to provide the necessary signal buffering just fine by itself.
> Can't see any significant difference in decode performance either
> in-kernel or via lirc with it removed, anyway. (Christoph, can you
> perhaps expand a bit on why the delay buffer was originally needed/how
> to reproduce the problem it was intended to solve? Maybe I'm just not
> triggering it yet.)

Should be fine. Current lircd with timeout support shouldn't have a  
problem with that anymore. I was already thinking of suggesting to remove  
the delay buffer.

>
> Other fun stuff to note:
>
> - currently, loading up an rc5-sz decoder unconditionally, have
> considered only auto-loading it from the streamzap driver itself. Its
> a copy of the rc5 decoder with relatively minor tweaks to deal with
> the extra bit and resulting slightly different bit layout. Might
> actually be possible to merge back into the rc5 decoder itself,
> haven't really looked into that yet (should be entirely doable if
> there's an easy way to figure out early on if we need to grab 14
> bits).

There is no way until you see the 14th bit.

> - not sure the decoder is 100% correct, but it does get to the same
> scancodes as the lirc userspace now (with both a streamzap and mceusb
> receiver).

Christoph
