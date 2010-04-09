Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37433 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab0DIUnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 16:43:47 -0400
Subject: Found NEC IR specification in NEC uPD6122 datasheet (Re: [RFC3]
 Teach drivers/media/IR/ir-raw-event.c to use durations)
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <4BBF3309.6020909@infradead.org>
References: <20100408113910.GA17104@hardeman.nu>
	 <1270812351.3764.66.camel@palomino.walls.org>
	 <s2o9e4733911004090531we8ff39b4r570e32fdafa04204@mail.gmail.com>
	 <4BBF3309.6020909@infradead.org>
Content-Type: text/plain
Date: Fri, 09 Apr 2010 16:44:10 -0400
Message-Id: <1270845850.3038.30.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-09 at 11:00 -0300, Mauro Carvalho Chehab wrote:
> Jon Smirl wrote:

> >>>  #define NEC_NBITS            32
> >>> -#define NEC_UNIT             559979 /* ns */
> >>> -#define NEC_HEADER_MARK              (16 * NEC_UNIT)
> >>> -#define NEC_HEADER_SPACE     (8 * NEC_UNIT)
> >>> -#define NEC_REPEAT_SPACE     (4 * NEC_UNIT)
> >>> -#define NEC_MARK             (NEC_UNIT)
> >>> -#define NEC_0_SPACE          (NEC_UNIT)
> >>> -#define NEC_1_SPACE          (3 * NEC_UNIT)
> >>> +#define NEC_UNIT             562500  /* ns */
> >> Have you got a spec on the NEC protocol that justifies 562.5 usec?
> >>
> >> >From the best I can tell from the sources I have read and some deductive
> >> reasoning, 560 usec is the actual number.  Here's one:
> >>
> >>        http://www.audiodevelopers.com/temp/Remote_Controls.ppt
> >>
> >> Note:
> >>        560 usec * 38 kHz ~= 4192/197
> > 
> > In the PPT you reference there are three numbers...
> > http://www.sbprojects.com/knowledge/ir/nec.htm
> > 
> > 560us
> > 1.12ms
> > 2.25ms
> > 
> > I think those are rounding errors.
> > 
> > 562.5 * 2 = 1.125ms * 2 = 2.25ms
> > 
> > Most IR protocols are related in a power of two pattern for their
> > timings to make them easy to decode.
> > 
> > The protocol doesn't appear to be based on an even number of 38Khz cycles.
> > These are easy things to change as we get better data on the protocols.

I just found authoritative data.  It is in the datasheet for the uPD6122
authored by NEC Corporation:

	http://www.datasheetcatalog.org/datasheet/nec/UPD6122G-002.pdf

Looking at page 11, especially line (5), it appears that all the timings
are derived in terms of 1/3 of a carrier period and powers of 2.

So....

Resonator frequency: fr = 455 kHz   (AM IF parts are cheap apparently)
Carrier frequency:   fc = fr / 12 = 37.91667 kHz
Duty cycle: 1/3

unit pulse:         64/3 / fc = 562.637 us (Jon was closer than me)
header pulse:  16 * 64/3 / fc =   9.002 ms
header space:   8 * 64/3 / fc =   4.501 ms
repeat space:   4 * 64/3 / fc =   2.250 ms
'1' symbol:     4 * 64/3 / fc =   2.250 ms
'0' symbol:     2 * 64/3 / fc =   1.125 ms
repeat time:  192 * 64/3 / fc = 108.026 ms

Page 15 also shows that the older chips had a silence gap that could
result in signals coming closer than 108 ms.


Whew!  I'm glad I've worked through my fit of Obsessive Compulsive
Disorder for now. :)


Regards,
Andy

