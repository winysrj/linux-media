Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50815 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab0HQDkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 23:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <4C6A026B.3030808@redhat.com>
References: <AANLkTimz2eLSEy+U1NdMVsQ=af7v67omPntwMQs+8jno@mail.gmail.com>
	<BUhP+pZ3jFB@christoph>
	<AANLkTik7pPs6Bs6Pgq_MG00ONcZWEKFnfUqrTZtgwQRa@mail.gmail.com>
	<1281991312.3661.2.camel@maxim-laptop>
	<AANLkTimJtCWv-QyKy8HQXWm8BTv8SerO9Qo_0EDY1+LP@mail.gmail.com>
	<4C6A026B.3030808@redhat.com>
Date: Mon, 16 Aug 2010 23:40:12 -0400
Message-ID: <AANLkTikwHLutYQVUhzY1GWrWM0gt46uR-TeJAdUYr2XC@mail.gmail.com>
Subject: Re: Remote that breaks current system
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	awalls@md.metrocast.net, jarod@redhat.com, jonsmirl@gmail.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Aug 16, 2010 at 11:30 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 16-08-2010 21:14, Jarod Wilson escreveu:
>
>>> Just one minor nitpick.
>>> You could 'use' the original RC5 decoder, but add a knob to it to make
>>> it accept 15 bits instead of 14.
>>> However, this will require some interface changes.
>>
>> Well, I think that still falls down if someone, for some reason, wants
>> to use both an old RC5 remote and the Streamzap remote at the same
>> time. I think a parallel decoder is probably the best situation for
>> the moment, as both 14-bit RC5 and Streamzap RC5 can be decoded
>> simultaneously.
>
> One option could be to change rc5 decoder to work with 3 different modes,
> controlled by a sysfs node:
> 1) just 14 bits code;
> 2) just 15 bits code;
> 3) both 14 and 15 bits code.
>
> For (3), it will need a timeout logic for a short period (like 2T), for the
> 15th bit. If nothing happens, it will assume it is 14 bits, producing a code
> and resetting the finite-state machine.
>
> By default, it would be working on 14-bits mode for normal RC decoders, and
> on 15-bits mode for Streamzap.
>
> Yet, IMHO, the better is to commit what you have currently. Just my 2 cents.

Yeah, I don't doubt that we *could* come up with some way to make them
coexist in the same decoder, but I think its probably not worth the
effort or added complexity over simply having a separate parallel
decoder (which is only loaded by default if the receiver bundled with
the funky remote is plugged in).

-- 
Jarod Wilson
jarod@wilsonet.com
