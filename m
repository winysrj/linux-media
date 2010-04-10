Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59890 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab0DJVTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 17:19:37 -0400
Subject: Re: [PATCH 4/4] Add RC6 support to ir-core
From: Andy Walls <awalls@radix.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@redhat.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <20100410195207.GA3676@hardeman.nu>
References: <20100408230246.14453.97377.stgit@localhost.localdomain>
	 <20100408230440.14453.36936.stgit@localhost.localdomain>
	 <1270861928.3038.153.camel@palomino.walls.org>
	 <20100410195207.GA3676@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 17:19:51 -0400
Message-Id: <1270934391.3100.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-10 at 21:52 +0200, David Härdeman wrote:
> On Fri, Apr 09, 2010 at 09:12:08PM -0400, Andy Walls wrote:
> > On Fri, 2010-04-09 at 01:04 +0200, David Härdeman wrote:
> > > diff --git a/drivers/media/IR/ir-rc6-decoder.c 
> > > b/drivers/media/IR/ir-rc6-decoder.c
> > > new file mode 100644
> > > index 0000000..ccc5be2
> > > --- /dev/null
> > > +++ b/drivers/media/IR/ir-rc6-decoder.c
> > > @@ -0,0 +1,412 @@
> > > +/* ir-rc6-decoder.c - A decoder for the RC6 IR protocol
> > > + *
> > > + * Copyright (C) 2010 by David Härdeman <david@hardeman.nu>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation version 2 of the License.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#include "ir-core-priv.h"
> > > +
> > > +/*
> > > + * This decoder currently supports:
> > > + * RC6-0-16	(standard toggle bit in header)
> > > + * RC6-6A-24	(no toggle bit)
> > > + * RC6-6A-32	(MCE version with toggle bit in body)
> > > + */
> > 
> > Just for reference for review:
> > 
> > http://slycontrol.ru/scr/kb/rc6.htm
> > http://www.picbasic.nl/info_rc6_uk.htm
> > 
> > 
> > RC6 Mode 0:
> > 
> > prefix mark:  111111
> > prefix space: 00
> > start bit:    10           (biphase encoding of '1')
> > mode bits:    010101       (biphase encoding of '000')
> > toggle bits:  0011 or 1100 (double duration biphase coding of '0' or '1')
> > system byte:  xxxxxxxxxxxxxxxx (biphase encoding of 8 bits)
> > command byte: yyyyyyyyyyyyyyyy (biphase encoding of 8 bits)
> > 
> > RC6 Mode 6A:
> > 
> > prefix mark:   111111
> > prefix space:  00
> > start bit:     10           (biphase encoding of '1')
> > mode bits:     101001       (biphase encoding of '110' for '6') 
> > trailer bits:  0011         (double duration biphase encoding of '0' for 'A')
> > customer len:  01 or 10     (biphase encoding of '0' for 7 bits or '1' for 15 bits)
> > customer bits: xxxxxxxxxxxxxx (biphase encoding of 7 bits for a short customer code)
> > 		or
> >                xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (biphase encoding of 15 bits for a long customer code)
> > system byte:   yyyyyyyyyyyyyyyy (biphase encoding of 8 bits)
> > command byte:  zzzzzzzzzzzzzzzz (biphase encoding of 8 bits)
> > 
> > 
> > > +#define RC6_UNIT		444444	/* us */
> > > +#define RC6_HEADER_NBITS	4	/* not including toggle bit */
> > > +#define RC6_0_NBITS		16
> > > +#define RC6_6A_SMALL_NBITS	24
> > > +#define RC6_6A_LARGE_NBITS	32
> > 
> > According to the slycontrol.ru website, the data length is, in theory
> > OEM dependent for Mode 6A, limited to a max of 24 bits (3 bytes) after a
> > short customer code and 128 bits (16 bytes) after a long customer code.
> > 
> > I don't know what the reality is for existing remotes.
> > 
> > Would it be better to look for the signal free time of 6 RC6_UNITs to
> > declare the end of reception, instead of a bit count?
> 
> Yes, it might be better from a correctness point of view, and I think it 
> might be a worthwhile change if we want to support a few more odd 
> remotes (although the only one I'm aware of - even after trawling 
> through lots of lirc configs, decodeir.dll configs and remotecentral 
> configs - is the "Sky" remote which seems to use a short customer code 
> and a 12 bit body).
>
> The thing is though, that with the different 32 bit scancodes, we can't 
> anyway represent anything beyond a 32 bit message body (including the 
> customer code, which should be included in the scancode).

Yup.

> I have a 
> proposal on changing the scancodes used in ir-code, but I haven't 
> written up the details yet.
> 
> It's also interesting to note that the ProntoEdit NG program, which is 
> written by Philips, only allows a 24/32 bit body (including the customer 
> bits).

So maybe forget my suggesting of coding to the theoretical limits, if
we'll never really encounter one in practice.


> > > +#define RC6_PREFIX_PULSE	PULSE(6)
> > > +#define RC6_PREFIX_SPACE	SPACE(2)
> > > +#define RC6_MODE_MASK		0x07	/* for the header bits */
> > > +#define RC6_STARTBIT_MASK	0x08	/* for the header bits */
> > > +#define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */
> > 
> > That's an OEM specific toggle bit.
> 
> Umm, yes I know? That's why the define includes the "_MCE_" part and 
> also what the comment in the beginning of the decoder says:
> 
> 	* RC6-6A-32	(MCE version with toggle bit in body)
> 
> >  It is likely more properly named
> > RC6_6A_MS_TOGGLE_MASK.  See slide 6 of:
> > 
> > http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWEN05007_WinHEC05.ppt
> > 
> > (Although in reality, every remote that wants to work with stock MS
> > drivers will use it.)
> 
> I'm not sure what your point is...it's already called 
> RC6_6A_MCE_TOGGLE_MASK, as in "RC6 6A Windows Media Center Edition 
> Toggle Mask".

My point was that that toggle is OEM defined, since the OEM customer
defines their RC-6 Mode 6A payload.

(BTW I have an HP OEM'ed MCE USB receiver in front of me, which is
probably why I don't implcitly associate "MCE" with Microsoft.)

If Microsoft's OEM payload is the only OEM payload we ever think will
make an RC-6 Mode 6A remote that outputs a long customer code, then OK.
Microsoft is Customer ID 0x800f.  Who are 0x8000 through 0x800e?



> > > +again:
> > > +	IR_dprintk(2, "RC6 decode started at state %i (%i units, %ius)\n",
> > > +		   data->state, u, TO_US(duration));
> > > +
> > > +	if (DURATION(u) == 0 && data->state != STATE_FINISHED)
> > > +		return 0;
> > 
> > Isn't there a better way to structure the logic to break up two adjacent
> > pulse units than with goto's out of the switch back up to here?
> > 
> > A do {} while() loop would have been much clearer.
> > 



> > > +		case RC6_MODE_6A:
> > > +			if (data->wanted_bits == RC6_6A_LARGE_NBITS) {
> > > +				toggle = data->body & RC6_6A_MCE_TOGGLE_MASK ? 1 : 0;
> > > +				scancode = data->body & ~RC6_6A_MCE_TOGGLE_MASK;
> > 
> > Technically this depends on the OEM.  
> 
> I know, again it's mentioned in one of the first comments of the code.
> 
> > In reality, every RC6 Mode 6A
> > remote that wants to work with Microsoft stock drivers will likely use
> > this bit as a toggle.
> 
> We might want to check if the (long) customer code matches 0x800F (if I 
> remember correctly) and apply the MCE behaviour only then, but it might 
> also come back to bite us in the ass if, for example, different 
> customers have implemented the same definition of the body.
> 
> Then again, as far as I can remeber, the Philips Pronto raw code for MCE 
> commands doesn't include the customer code, which would indicate that 
> it's fixed.
> 
> Another question is: if the customer code doesn't match, what do we do?  
> The body could be defined as any random gibberish by vendor XYZ, 
> including toggles and checksums which means that the scancode would 
> change for each keypress if we blindly report the entire body as a 32 
> bit scancode.

This is a standards problem that Phillips and the OEMs have left us with
(since OEM encodings will likely be confidential/proprietary).

Maybe this code should check for long customer id 0x800f, and if the ID
doesn't match, log a warning, but keep on processing as if it were.
Users will report the warning to get it removed for their remote.

Or is that too user-unfriendly?

Regards,
Andy

