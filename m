Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:39279 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbaCaNWw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 09:22:52 -0400
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC   scancodes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Mar 2014 15:22:47 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
In-Reply-To: <533949F5.3080001@imgtec.com>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu>
 <533949F5.3080001@imgtec.com>
Message-ID: <37fcf3abf63e258ee29b23dc3b0f3f12@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-03-31 12:56, James Hogan wrote:
> On 31/03/14 11:19, David Härdeman wrote:
>> On 2014-03-31 11:44, James Hogan wrote:
>>> On 29/03/14 16:11, David Härdeman wrote:
>>>> +    /* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
>>>> +    *scancode = swab32((u32)raw);
>>> 
>>> What's the point of the byte swapping?
>>> 
>>> Surely the most natural NEC encoding would just treat it as a single
>>> 32-bit (LSBit first) field rather than 4 8-bit fields that needs
>>> swapping.
>> 
>> Thanks for having a look at the patches, I agree with your comments on
>> the other patches (and I have to respin some of them because I missed
>> two drivers), but the comments to this patch confuses me a bit.
>> 
>> That the NEC data is transmitted as 32 bits encoded with LSB bit order
>> within each byte is AFAIK just about the only thing that all
>> sources/documentation of the protocal can agree on (so bitrev:ing the
>> bits within each byte makes sense, unless the hardware has done it
>> already).
> 
> Agreed (in the case of img-ir there's a bit orientation setting which
> ensures that the u64 raw has the correct bit order, in the case of NEC
> the first bit received goes in the lowest order bit of the raw data).
> 
>> As for the byte order, AAaaDDdd corresponds to the transmission order
>> and seems to be what most drivers expect/use for their RX data.
> 
> AAaaDDdd is big endian rendering, no? (like "%08x")

Yeah, you could call it that.

> If it should be interpreted as LSBit first, then the first bits 
> received
> should go in the low bits of the scancode, and by extension the first
> bytes received in the low bytes of the scancode, i.e. at the end of the
> inherently big-endian hexadecimal rendering of the scancode.

I'm not saying the whole scancode should be interpreted as one 32 bit 
LSBit integer, just that the endianness within each byte should be 
respected.

>> Are you suggesting that rc-core should standardize on ddDDaaAA order?
> 
> Yes (where ddDDaaAA means something like scancode
> "0x(~cmd)(cmd)(~addr)(addr)")

Yes, that's what I meant.

> This would mean that if the data is put in the right bit order (first
> bit received in BIT(0), last bit received in BIT(31)), then the 
> scancode
> = raw, and if the data is received in the reverse bit order (like the
> raw decoder, shifting the data left and inserting the last bit in
> BIT(0)) then the scancode = bitrev32(raw).
> 
> Have I missed something?

I just think we have to agree to disagree :)

For me, storing/presenting the scancode as 0xAAaaDDdd is "obviously" the 
clearest and least confusing interpretation. But I might have spent too 
long time using that notation in code and mentally to be able to find 
anything else intuitive :)

0xAAaaDDdd means that you read/parse/print it left to right, just as you 
would if you drew a pulse-space chart showing the received IR pulse 
(time normally progresses to the right...modulo the per-byte bitrev).

It kind of matches the other protocol scancodes as well (the "address" 
bits high, cmd bits low, the high bits tend to remain constant for one 
given remote, the low bits change, although it's not a hard rule) and it 
matches most software I've ever seen (AFAIK, LIRC represents NEC32 
scancodes this way, as does e.g. the Pronto software and protocol).

That said...I think we at least agree that we need *a* representation 
and that it should be used consistently in all drivers, right?

//David
