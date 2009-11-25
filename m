Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758914AbZKYXWd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 18:22:33 -0500
Message-ID: <4B0DBC2D.1010603@redhat.com>
Date: Thu, 26 Nov 2009 00:22:21 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: awalls@radix.net, dheitmueller@kernellabs.com,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZbPXRZjFB@christoph>
In-Reply-To: <BDZbPXRZjFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> (1) ir code (say rc5) ->  keycode conversion looses information.
>>
>> I think this can easily be addressed by adding a IR event type to the
>> input layer, which could look like this:
>>
>>     input_event->type  = EV_IR
>>     input_event->code  = IR_RC5
>>     input_event->value =<rc5 value>
>>
>> In case the 32bit value is too small we might want send two events
>> instead, with ->code being set to IR_<code>_1 and IR_<code>_2
>>
>> Advantages:
>>     * Applications (including lircd) can get access to the unmodified
>>       rc5/rc6/... codes.
>
> Unfortunately with most hardware decoders the code that you get is only
> remotely related to the actual code sent. Most RC-5 decoders strip off
> start bits.

I would include only the actual data bits in the payload anyway.

> Toggle-bits are thrown away. NEC decoders usually don't pass
> through the address part.

Too bad.  But information which isn't provided by the hardware can't be 
passed up anyway, no matter what kernel/userspace interface is used. 
Gone is gone.

> There is no common standard which bit is sent first, LSB or MSB.

Input layer would have to define a bit order.  And drivers which get it 
the other way from the hardware have to convert.  Or maybe signal the 
order and the input core then will convert if needed.

> Checksums are thrown away.

Don't include them.

> To sum it up: I don't think this information will be useful at all for
> lircd or anyone else.

Why not?  With RC5 remotes applications can get the device address bits 
for example, which right now are simply get lost in the ir code -> 
keycode conversion step.

> Actually lircd does not even know anything about
> actual protocols. We only distinguish between certain protocol types, like
> Manchester encoded, space encoded, pulse encoded etc. Everything else like
> the actual timing is fully configurable.

I know that lircd does matching instead of decoding, which allows to 
handle unknown encodings.  Thats why I think there will always be cases 
which only lircd will be able to handle (using raw samples).

That doesn't make attempts to actually decode the IR samples a useless 
exercise though ;)

cheers,
   Gerd

