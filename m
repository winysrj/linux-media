Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:13487 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaCaP1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 11:27:03 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3B000BC490WG90@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Mar 2014 11:27:01 -0400 (EDT)
Date: Mon, 31 Mar 2014 12:26:56 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC scancodes
Message-id: <20140331122656.13266f88@samsung.com>
In-reply-to: <37fcf3abf63e258ee29b23dc3b0f3f12@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu>
 <533949F5.3080001@imgtec.com> <37fcf3abf63e258ee29b23dc3b0f3f12@hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Mar 2014 15:22:47 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On 2014-03-31 12:56, James Hogan wrote:
> > On 31/03/14 11:19, David Härdeman wrote:
> >> On 2014-03-31 11:44, James Hogan wrote:
> >>> On 29/03/14 16:11, David Härdeman wrote:
> >>>> +    /* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
> >>>> +    *scancode = swab32((u32)raw);
> >>> 
> >>> What's the point of the byte swapping?
> >>> 
> >>> Surely the most natural NEC encoding would just treat it as a single
> >>> 32-bit (LSBit first) field rather than 4 8-bit fields that needs
> >>> swapping.
> >> 
> >> Thanks for having a look at the patches, I agree with your comments on
> >> the other patches (and I have to respin some of them because I missed
> >> two drivers), but the comments to this patch confuses me a bit.
> >> 
> >> That the NEC data is transmitted as 32 bits encoded with LSB bit order
> >> within each byte is AFAIK just about the only thing that all
> >> sources/documentation of the protocal can agree on (so bitrev:ing the
> >> bits within each byte makes sense, unless the hardware has done it
> >> already).
> > 
> > Agreed (in the case of img-ir there's a bit orientation setting which
> > ensures that the u64 raw has the correct bit order, in the case of NEC
> > the first bit received goes in the lowest order bit of the raw data).
> > 
> >> As for the byte order, AAaaDDdd corresponds to the transmission order
> >> and seems to be what most drivers expect/use for their RX data.
> > 
> > AAaaDDdd is big endian rendering, no? (like "%08x")
> 
> Yeah, you could call it that.
> 
> > If it should be interpreted as LSBit first, then the first bits 
> > received
> > should go in the low bits of the scancode, and by extension the first
> > bytes received in the low bytes of the scancode, i.e. at the end of the
> > inherently big-endian hexadecimal rendering of the scancode.
> 
> I'm not saying the whole scancode should be interpreted as one 32 bit 
> LSBit integer, just that the endianness within each byte should be 
> respected.
> 
> >> Are you suggesting that rc-core should standardize on ddDDaaAA order?
> > 
> > Yes (where ddDDaaAA means something like scancode
> > "0x(~cmd)(cmd)(~addr)(addr)")
> 
> Yes, that's what I meant.
> 
> > This would mean that if the data is put in the right bit order (first
> > bit received in BIT(0), last bit received in BIT(31)), then the 
> > scancode
> > = raw, and if the data is received in the reverse bit order (like the
> > raw decoder, shifting the data left and inserting the last bit in
> > BIT(0)) then the scancode = bitrev32(raw).
> > 
> > Have I missed something?
> 
> I just think we have to agree to disagree :)
> 
> For me, storing/presenting the scancode as 0xAAaaDDdd is "obviously" the 
> clearest and least confusing interpretation. But I might have spent too 
> long time using that notation in code and mentally to be able to find 
> anything else intuitive :)

Inside the RC core, for all other protocols, the order always
ADDRESS + COMMAND.

Up to NEC-24 bits, this is preserved, as the command is always 0xDD
and the address is either 0xaaAA or 0xAA.

The 32-bits NEC is a little ackward, if we consider the command as
also being 8 bits, and the address having 24 bits.

The Tivo keytable is weird:

	{ 0x3085f009, KEY_MEDIA },	/* TiVo Button */
	{ 0x3085e010, KEY_POWER2 },	/* TV Power */
	{ 0x3085e011, KEY_TV },		/* Live TV/Swap */
	{ 0x3085c034, KEY_VIDEO_NEXT },	/* TV Input */
	{ 0x3085e013, KEY_INFO },
	{ 0x3085a05f, KEY_CYCLEWINDOWS }, /* Window */
	{ 0x0085305f, KEY_CYCLEWINDOWS },
	{ 0x3085c036, KEY_EPG },	/* Guide */
	...

There, the only part of the scancode that doesn't change is 0x85.
It seems that they're using 8 bits for address (0xaa) and 24
bits for command (0xAADDdd).

So, it seems that they're actually sending address/command as:

	[command >> 24><Address][(command >>8) & 0xff][command & 0xff]

With seems too awkward.

IMHO, it would make more sense to store those data as:
	<address><command>

So, KEY_MEDIA, for example, would be:
+	{ 0x8530f009, KEY_MEDIA },	/* TiVo Button */

However, I'm not sure how other 32 bits NEC scancodes might be.

So, I think we should keep the internal representation as-is,
for now, while we're not sure about how other vendors handle
it, as, for now, there's just one IR table with 32 bits nec.

That's said, I don't mind much how this is internally stored at
the Kernel level, as we can always change it, but we should provide
backward compatibility for userspace, when userspace sends
to Kernel a 16 bit or a 24 bit keytable.

So, I think we should first focus on how to properly get/set the
bitsize at the API in a way that this is backward compatible.

Ok, the API actually sends the bit size of each keycode, as the
size length is variable, but I'm not sure if this is reliable enough,
as I think that the current userspace just sets it to 32 bits, even
when passing a 16 bits key.

In any case, it doesn't make any sense to require userspace to
convert a 16 bits normal NEC table (or a 24 bits "extended" NEC
table) into a 32 bits data+checksum bitpack on userspace.

Regards,
Mauro
