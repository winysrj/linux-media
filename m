Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:64607 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaCaNPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 09:15:13 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3A000KEY5C0Y60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Mar 2014 09:15:12 -0400 (EDT)
Date: Mon, 31 Mar 2014 10:15:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC scancodes
Message-id: <20140331101507.4f34c0ee@samsung.com>
In-reply-to: <6b18c58fc8eef47b081583ab316bb000@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu>
 <20140331091433.0f232179@samsung.com>
 <6b18c58fc8eef47b081583ab316bb000@hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Mar 2014 14:58:10 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On 2014-03-31 14:14, Mauro Carvalho Chehab wrote:
> > Em Mon, 31 Mar 2014 12:19:10 +0200
> > David Härdeman <david@hardeman.nu> escreveu:
> >> On 2014-03-31 11:44, James Hogan wrote:
> >> > On 29/03/14 16:11, David Härdeman wrote:
> >> >> Using the full 32 bits for all kinds of NEC scancodes simplifies
> >> >> rc-core
> >> >> and the nec decoder without any loss of functionality.
> >> >>
> >> >> In order to maintain backwards compatibility, some heuristics are
> >> >> added
> >> >> in rc-main.c to convert scancodes to NEC32 as necessary.
> >> >>
> >> >> I plan to introduce a different ioctl later which makes the protocol
> >> >> explicit (and which expects all NEC scancodes to be 32 bit, thereby
> >> >> removing the need for guesswork).
> >> >>
> >> >> Signed-off-by: David Härdeman <david@hardeman.nu>
> >> >> ---
> >> >> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c
> >> >> b/drivers/media/rc/img-ir/img-ir-nec.c
> >> >> index 40ee844..133ea45 100644
> >> >> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> >> >> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> >> >> @@ -5,42 +5,20 @@
> >> >>   */
> >> >>
> >> >>  #include "img-ir-hw.h"
> >> >> -#include <linux/bitrev.h>
> >> >>
> >> >>  /* Convert NEC data to a scancode */
> >> >>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type
> >> >> *protocol,
> >> >>  			       u32 *scancode, u64 enabled_protocols)
> >> >>  {
> >> >> -	unsigned int addr, addr_inv, data, data_inv;
> >> >>  	/* a repeat code has no data */
> >> >>  	if (!len)
> >> >>  		return IMG_IR_REPEATCODE;
> >> >> +
> >> >>  	if (len != 32)
> >> >>  		return -EINVAL;
> >> >> -	/* raw encoding: ddDDaaAA */
> >> >> -	addr     = (raw >>  0) & 0xff;
> >> >> -	addr_inv = (raw >>  8) & 0xff;
> >> >> -	data     = (raw >> 16) & 0xff;
> >> >> -	data_inv = (raw >> 24) & 0xff;
> >> >> -	if ((data_inv ^ data) != 0xff) {
> >> >> -		/* 32-bit NEC (used by Apple and TiVo remotes) */
> >> >> -		/* scan encoding: AAaaDDdd (LSBit first) */
> >> >> -		*scancode = bitrev8(addr)     << 24 |
> >> >> -			    bitrev8(addr_inv) << 16 |
> >> >> -			    bitrev8(data)     <<  8 |
> >> >> -			    bitrev8(data_inv);
> >> >> -	} else if ((addr_inv ^ addr) != 0xff) {
> >> >> -		/* Extended NEC */
> >> >> -		/* scan encoding: AAaaDD */
> >> >> -		*scancode = addr     << 16 |
> >> >> -			    addr_inv <<  8 |
> >> >> -			    data;
> >> >> -	} else {
> >> >> -		/* Normal NEC */
> >> >> -		/* scan encoding: AADD */
> >> >> -		*scancode = addr << 8 |
> >> >> -			    data;
> >> >> -	}
> >> >> +
> >> >> +	/* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
> >> >> +	*scancode = swab32((u32)raw);
> >> >
> >> > What's the point of the byte swapping?
> >> >
> >> > Surely the most natural NEC encoding would just treat it as a single
> >> > 32-bit (LSBit first) field rather than 4 8-bit fields that needs
> >> > swapping.
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
> >> 
> >> As for the byte order, AAaaDDdd corresponds to the transmission order
> >> and seems to be what most drivers expect/use for their RX data.
> >> 
> >> Are you suggesting that rc-core should standardize on ddDDaaAA order?
> > 
> > 
> > Let's better name this, as AAaaDDdd implies that:
> > 	aa = ~AA
> > 	dd = ~DD
> > As described at the NEC protocol.
> 
> I really don't think James and I had any trouble understanding each 
> other :)

Ok, but others on reading this thread may misunderstand the meanings.

> 
> > The 24 or 32 bits variation is actually a violation of the NEC 
> > protocol.
> 
> Violation is a misnomer. NEC created the 24 bit version, it's an 
> extension. Many companies (such as your employer :)) have created 
> further variations.

I'm fine if you call it as an extension, but the original NEC _is_
16 bits, and most drivers are compliant with it.

We should not break what's working.

> > What some IRs actually provide is:
> > 	xxyyADDdd (24 bits NEC)
> > 	where:
> > 		Address = yyxx
> > 		Data = DD
> > 
> > As described as "Extended NEC protocol" at:
> > 	http://www.sbprojects.com/knowledge/ir/nec.php
> > 
> > or:
> > 	xxyyADDzz (32 bits NEC)
> > 	where:
> > 		Address = zzxxyy
> > 		Data = DD
> 
> No need to explain the protocol to me.
> 
> > Also, currently, there's just one IR table with 32 bits nec:
> > rc-tivo.c, used by the mceusb driver.
> 
> Yes, I know.
> 
> > Well, changing the NEC decoders to always send a 32 bits code has
> > several issues:
> > 
> > 1) It makes the normal NEC protocol as an exception, and not as a
> >    rule;
> 
> It's not an exception. I just makes all 32 bits explicit.

Well, if all drivers but one only have 16 or 24 bits tables, this is
an exception.

> And the lack of that explicit information currently makes the scancode 
> ambiguous. Right now if I give you a NEC scancode of 0xff00 (like we 
> give to userspace with the EV_SCAN event), you can't tell what it 
> means...it could, for example, be a 32 bit code of 0x0000ff00...
> 
> > 2) It breaks all in-kernel tables for 16 bits and 24 bits NEC.
> >    As already said, currently, there's just one driver using 32
> >    bits NEC, and just for one IR type (RC_MAP_TIVO);
> 
> No, the proposed patch doesn't break all in-kernel tables. The in-kernel 
> tables are converted on the fly to NEC32 when loaded.

That's messy. We should either change everything in Kernelspace to
32 bits or keep as is.

If such emulation is needed, it should be only for userspace tables.

> > 3) It causes regressions to userspace, as userspace tables won't
> >    work anymore;
> 
> I know it may cause troubles for userspace, however:
> 
> a) You've already accepted patches that change the scancode format of 
> the NEC decoder within the last few weeks so you've already set the 
> stage for the same kind of trouble (even if I agree with James on parts 
> of that patch)

If I let this pass, we should revert it before it reaches upstream.

What patch caused regressions?

> b) The current code is broken as well...using the same remote will 
> generate different scancodes depending on the driver (even if the old 
> and new hardware *can* receive the full scancode), meaning that your 
> keytable will suddenly stop working if you change HW. That's bad.

On the devices I have here, it is not broken. Let's fix it where this
is broken, and not use it as an excuse to break even more things.

> > 4) Your to_nec32() macro will break support for 24-bits IRs
> >    shipped with devices that can only provide 16 bits.
> > 
> > In order to explain (4), let's see what happens when a 24-bits
> > NEC code is received by a in-hardware decoder.
> > 
> > There are a wide range of Chinese IR devices shipped with widely
> > used media hardware that produce a 24-bit NEC code. One of the
> > most popular of such manufacturers use the address = 0x866b
> > (btw, the get_key_beholdm6xx() function at saa7134 driver seems
> > to be wrong, as the keytables for behold device has the address of
> > this vendor mapped as 0x6b86).
> 
> I know, I've already identified and fixed that problem in a separate 
> patch that's posted to the list. And it will also break out-of-kernel 
> user-defined keymaps. Any inconsistency is a no-win situation. And we 
> *do* have inconsistencies right now.

Yes. That's one of the reasons why this was not fixed yet (and the other
one is that I don't have any of such device in hands, in order to be
sure that this is not another vendor that, by coincidence, has address
0x6b86).

> > The way those codes are handled inside each in-hardware NEC
> > decoder are different. I've seen all those alternatives:
> > 
> > a) the full 24-bits code is received by the driver;
> > b) some hardware will simply discard the MSB of the address;
> > c) a few hardware will discard the entire keycode, as the
> >    checksum bytes won't match.
> 
> I know there's a lot of variety, another example is drivers that discard 
> (possibly after matching address) everything but the "command" part of 
> the scancode. That should not be used as an excuse not to try to make 
> the behavior as consistent as possible. After all...that's the point of 
> a common API.

It should be consistent, and it should be able to support the existing
hardware.

> > The devices from the 0x866b manufacturer is used by a wide range
> > of devices that can do either (a) or (b).
> > 
> > Well, as the to_nec32() doesn't know the original keycode, it
> > would map an address like 0x866b as 0x946b, with is wrong, and
> > won't match the corresponding NEC table.
> 
> Yes, if the hardware throws away information, rc-core will sometime 
> generate a scancode which does not match the real one.
> 
> As you say:
> 
> if the actual remote control transmits: 0x866b01fe
> and the hardware truncates it to:       0x..6b01fe
> then rc-core would convert back to:     0x946b01fe
> 
> And that could be fixed with a scanmask for that driver (0xffffff)?

I think you're meaning 0x0000ffff, right?

> (We could also expose the scanmask to userspace so it knows which part 
> of the scancode it can trust...)

Yes, we could do it, but the current userspace should keep working.
Eventually, that means to add some backward compat code there, in order
to preserve the behavior with current tables.

> > Due to (3) (it causes userspace regressions), we can't apply
> > such changes.
> 
> I know Linus' policy with regard to userspace regressions, but see 
> above.
> 
> Regards,
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Regards,
Mauro
