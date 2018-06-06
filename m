Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36365 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932253AbeFFJFs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 05:05:48 -0400
Message-ID: <1528275940.3438.1.camel@pengutronix.de>
Subject: Re: [PATCH v2 04/10] media: imx: interweave only for sequential
 input/interlaced output fields
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Wed, 06 Jun 2018 11:05:40 +0200
In-Reply-To: <98b3cd1e-32ff-e7bb-b2ba-7b622aa983b6@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
         <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
         <1527860010.5913.8.camel@pengutronix.de> <m3k1rfnmfr.fsf@t19.piap.pl>
         <1528100849.5808.2.camel@pengutronix.de>
         <c9fcc11a-9f0f-0764-cb8e-66fc9c09d7f4@mentor.com>
         <1528186075.4074.1.camel@pengutronix.de>
         <98b3cd1e-32ff-e7bb-b2ba-7b622aa983b6@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Tue, 2018-06-05 at 12:00 -0700, Steve Longerbeam wrote:
> > I'm probably misunderstanding you, so at the risk of overexplaining:
> > There is no way we can ever produce a correct interlaced-tb frame in
> > memory from a seq-bt frame output by the CSI, as the interweaving step
> > only has access to a single frame.
> 
> I don't follow you, yes the interweaving step only has access to
> a single frame, but why would interweave need access to another
> frame to carry out seq-bt -> interlaced-tb ? See below...

A seq-bt frame has a bottom field (first in memory) with an older
timestamp than the top field (second in memory). Without access to a
second input frame we can only ever produce an interlaced frame where
the bottom lines are older than the top lines, which is interlaced-bt.

interlaced-tb requires the top lines to have the older timestamp, and
the bottom lines to be newer.

> > A seq-tb PAL frame has the older top field in lines 0-287 and the newer
> > bottom field in lines 288-576. From that interlaced-tb can be written
> > via 0-287 -> 0,2,4,...,286 and 288-575 -> 1,3,5,...,287 [1]. This is
> > what interweaving does if the interlace offset is set to positive line
> > stride.
> 
> Right, that was my understanding as well. And how interweave
> actually works in the IDMAC to achieve the above is :
> 
> By turning on SO bit in cpmem, the IDMAC will write the first one-half
> lines of the frame received by the IDMAC channel to memory, starting
> at the EBA address, with a line stride equal to cpmem SLY. When it
> completes writing out the first half lines of the frame, the IDMAC begins
> to write the lines from the second half of frame to memory, but starts
> again at EBA address, and with an offset equal to cpmem ILO.
> 
> So by setting SO=1, SLY=2*linestride, and ILO=linestride, we achieve
> interweave where:
> 
> lines from first half of frame are written to lines 0,2,4,...,HEIGHT-2 
> in memory, and
> lines from the second half of the frame are written to lines 
> 1,3,...,HEIGHT-1 in memory.
> 
> So this setting achieves seq-bt -> interlaced-bt

This is incorrect. Since the bottom field comes first in memory, with
this setting the bottom lines are written to where the top lines should
be and the top lines end up where the bottom lines should be.

Since odd and even lines are switched, this will not produce a correct
frame.

>  or seq-tb -> interlaced-tb,

This is correct.

>  e.g.
> interweave *does not change field order*, bottom lines 1,3,,, are written to
> 0,2,4,,, in memory if IDMAC receives seq-bt, or top lines 0,2,4,,, are 
> written to
> 0,2,4,,, in memory if IDMAC receives seq-tb.

Of course we can't change field order, we are arguing the same point
here. I think our misunderstanding comes from the definition of
interlaced-bt [1]:

  "Images contain both fields, interleaved line by line, top field
   first. The bottom field is transmitted first."

[1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/field-order.html?highlight=field#enum-v4l2-field

The BT or TB part of the v4l2_field enums refer to the order in time,
not to the order in memory.

> And by setting SO=1, SLY=2*linestride, ILO=-linestride, and adding one
> linestride to EBA:
> 
> lines from first half of the frame are written to lines 1,3,...,HEIGHT-1 
> in memory, and
> lines from the second half of the frame are written to lines 
> 0,2,...,HEIGHT-2 in memory.
> 
> So this achieves  seq-bt -> interlaced-tb

No this is seq-bt -> interlaced-bt

>  or seq-tb -> interlaced-bt, 

and this again produces an incorrect frame.

> e.g. field order has been swapped in memory.
> 
> 
> > A seq-bt NTSC frame has the older bottom field in lines 0-239 and the
> > newer top field in lines 240-439. We can create an interlaced-bt frame
> > from that by writing 0-239 -> 1,3,5,...,239 and 240-439 -> 0,2,4,...,238
> > [2]. This can be achieved by offsetting EBA by +stride and setting ILO
> > to -stride.
> 
> Agreed except that this is seq-bt -> interlaced-tb, not
> seq-bt -> interlaced-bt:

No, see above.

> Bottom lines = 1,3,5,...,H-1
> Top lines = 0,2,4,...,H-2

Yes, but the bottom lines are older, so this is interlaced-bt.

> So seq-bt is written as interlaced-tb to memory:
> 
> Bottom lines = 1,3,5,...,H-1 go to memory lines 1,3,5,...H-1
> Top lines = 0,2,4,...,H-2 go to memory lines 0,2,4,...,H-2.
> 
> So this is TB order in memory.

All V4L2 interlaced variants are stored in TB order, which allows to
just display them as a progressive frame. The V4L2_FIELD_INTERLACED
description is not clear on that, but the V4L2_FIELD_INTERLACED_TB/BT
descriptions explicitly state TB order in memory.

So that is seq-bt or alternate on the CSI sink pad, seq-tb on the CSI

> Well sure, we could use the negative ILO idea to swap field order
> (for a second time) at the CSI src pad to capture interface, e.g.
> seq-bt at CSI sink -> seq-tb at CSI src -> interlaced-bt at capture
> interface.

Yes, we swap field order (in memory), as that's how we get a correct
frame. Bot none of this can switch field order in time, BT is always
bottom first, top later, and TB is always top first, bottom later.

> But I don't see the need for doing that. If the user wishes to swap
> field order, it can do that at the CSI source pad. Why swap field
> order for a second time? But sure we could provide that ability.

But that swaps field order in time (in the sense that first we have
bottom-top order in time and then we capture fields from to consecutive
frames such that we get top-bottom order in time), which is different.

> > > PAL seq-tb -> interlaced-tb produces good interweave images as expected
> > > PAL seq-tb -> interlaced-bt produces interweave images with a "mauve"
> > > artifact as expected
> > 
> > Same as above, with negative ILO we should be able to do field switching
> > in the CSI, setting the sink pad to alternate or seq-tb, the src pad to
> > seq-bt, and create proper interlaced-bt from that in the IDMAC.
> 
> seq-bt at src pad to interlaced-bt in memory doesn't require negative
> ILO as I explained above.

This is not correct. Writing seq-bt with SO=1, ILO=stride, SLY=2*stride
causes an incorrect frame with switched odd and even lines.

regards
Philipp
