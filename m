Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:26333 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaCaMOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 08:14:39 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3A0038TVCDNJ50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Mar 2014 08:14:37 -0400 (EDT)
Date: Mon, 31 Mar 2014 09:14:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC scancodes
Message-id: <20140331091433.0f232179@samsung.com>
In-reply-to: <4af025b742df648556360db390351166@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Mon, 31 Mar 2014 12:19:10 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On 2014-03-31 11:44, James Hogan wrote:
> > On 29/03/14 16:11, David Härdeman wrote:
> >> Using the full 32 bits for all kinds of NEC scancodes simplifies 
> >> rc-core
> >> and the nec decoder without any loss of functionality.
> >> 
> >> In order to maintain backwards compatibility, some heuristics are 
> >> added
> >> in rc-main.c to convert scancodes to NEC32 as necessary.
> >> 
> >> I plan to introduce a different ioctl later which makes the protocol
> >> explicit (and which expects all NEC scancodes to be 32 bit, thereby
> >> removing the need for guesswork).
> >> 
> >> Signed-off-by: David Härdeman <david@hardeman.nu>
> >> ---
> >> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c 
> >> b/drivers/media/rc/img-ir/img-ir-nec.c
> >> index 40ee844..133ea45 100644
> >> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> >> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> >> @@ -5,42 +5,20 @@
> >>   */
> >> 
> >>  #include "img-ir-hw.h"
> >> -#include <linux/bitrev.h>
> >> 
> >>  /* Convert NEC data to a scancode */
> >>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type 
> >> *protocol,
> >>  			       u32 *scancode, u64 enabled_protocols)
> >>  {
> >> -	unsigned int addr, addr_inv, data, data_inv;
> >>  	/* a repeat code has no data */
> >>  	if (!len)
> >>  		return IMG_IR_REPEATCODE;
> >> +
> >>  	if (len != 32)
> >>  		return -EINVAL;
> >> -	/* raw encoding: ddDDaaAA */
> >> -	addr     = (raw >>  0) & 0xff;
> >> -	addr_inv = (raw >>  8) & 0xff;
> >> -	data     = (raw >> 16) & 0xff;
> >> -	data_inv = (raw >> 24) & 0xff;
> >> -	if ((data_inv ^ data) != 0xff) {
> >> -		/* 32-bit NEC (used by Apple and TiVo remotes) */
> >> -		/* scan encoding: AAaaDDdd (LSBit first) */
> >> -		*scancode = bitrev8(addr)     << 24 |
> >> -			    bitrev8(addr_inv) << 16 |
> >> -			    bitrev8(data)     <<  8 |
> >> -			    bitrev8(data_inv);
> >> -	} else if ((addr_inv ^ addr) != 0xff) {
> >> -		/* Extended NEC */
> >> -		/* scan encoding: AAaaDD */
> >> -		*scancode = addr     << 16 |
> >> -			    addr_inv <<  8 |
> >> -			    data;
> >> -	} else {
> >> -		/* Normal NEC */
> >> -		/* scan encoding: AADD */
> >> -		*scancode = addr << 8 |
> >> -			    data;
> >> -	}
> >> +
> >> +	/* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
> >> +	*scancode = swab32((u32)raw);
> > 
> > What's the point of the byte swapping?
> > 
> > Surely the most natural NEC encoding would just treat it as a single
> > 32-bit (LSBit first) field rather than 4 8-bit fields that needs 
> > swapping.
> 
> Thanks for having a look at the patches, I agree with your comments on 
> the other patches (and I have to respin some of them because I missed 
> two drivers), but the comments to this patch confuses me a bit.
> 
> That the NEC data is transmitted as 32 bits encoded with LSB bit order 
> within each byte is AFAIK just about the only thing that all 
> sources/documentation of the protocal can agree on (so bitrev:ing the 
> bits within each byte makes sense, unless the hardware has done it 
> already).
> 
> As for the byte order, AAaaDDdd corresponds to the transmission order 
> and seems to be what most drivers expect/use for their RX data.
> 
> Are you suggesting that rc-core should standardize on ddDDaaAA order?


Let's better name this, as AAaaDDdd implies that:
	aa = ~AA
	dd = ~DD
As described at the NEC protocol.

The 24 or 32 bits variation is actually a violation of the NEC protocol.

What some IRs actually provide is:
	xxyyADDdd (24 bits NEC)
	where:
		Address = yyxx
		Data = DD

As described as "Extended NEC protocol" at:
	http://www.sbprojects.com/knowledge/ir/nec.php

or:
	xxyyADDzz (32 bits NEC)
	where:
		Address = zzxxyy
		Data = DD

Also, currently, there's just one IR table with 32 bits nec:
rc-tivo.c, used by the mceusb driver.

Well, changing the NEC decoders to always send a 32 bits code has
several issues:

1) It makes the normal NEC protocol as an exception, and not as a
   rule;
2) It breaks all in-kernel tables for 16 bits and 24 bits NEC.
   As already said, currently, there's just one driver using 32
   bits NEC, and just for one IR type (RC_MAP_TIVO);
3) It causes regressions to userspace, as userspace tables won't
   work anymore;
4) Your to_nec32() macro will break support for 24-bits IRs
   shipped with devices that can only provide 16 bits.

In order to explain (4), let's see what happens when a 24-bits
NEC code is received by a in-hardware decoder.

There are a wide range of Chinese IR devices shipped with widely
used media hardware that produce a 24-bit NEC code. One of the
most popular of such manufacturers use the address = 0x866b
(btw, the get_key_beholdm6xx() function at saa7134 driver seems
to be wrong, as the keytables for behold device has the address of
this vendor mapped as 0x6b86).

The way those codes are handled inside each in-hardware NEC
decoder are different. I've seen all those alternatives:

a) the full 24-bits code is received by the driver;
b) some hardware will simply discard the MSB of the address;
c) a few hardware will discard the entire keycode, as the
   checksum bytes won't match.

The devices from the 0x866b manufacturer is used by a wide range
of devices that can do either (a) or (b).

Well, as the to_nec32() doesn't know the original keycode, it
would map an address like 0x866b as 0x946b, with is wrong, and
won't match the corresponding NEC table.

Due to (3) (it causes userspace regressions), we can't apply
such changes.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Regards,
Mauro
