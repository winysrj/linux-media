Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46899 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbcCCME0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 07:04:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Thu, 03 Mar 2016 14:04:24 +0200
Message-ID: <2685433.VkSs8SGs8F@avalon>
In-Reply-To: <CAMuHMdWai64fZg6b2ZSWKwRQg325ZKNS2mfm5oAY-B4YXtvUgg@mail.gmail.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <3162705.iiHBb2SECU@avalon> <CAMuHMdWai64fZg6b2ZSWKwRQg325ZKNS2mfm5oAY-B4YXtvUgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Thursday 03 March 2016 12:56:29 Geert Uytterhoeven wrote:
> On Thu, Mar 3, 2016 at 11:49 AM, Laurent Pinchart wrote:
> > On Thursday 03 March 2016 08:37:02 Kuninori Morimoto wrote:
> >>>>>>  - s2d2 (for 200MHz)
> >>>>>>  - s2d1 (for 400MHz)
> >>>>> 
> >>>>> Thank you for the information. Do you mean that different FCP 
> >>>>> instances use different clocks ? If so, could you tell us which clock
> >>>>> is used by each instance in th H3 ES1 ?
> >>>> 
> >>>> Sorry for my confusable mail.
> >>>> All FCP on H3 ES1 is using above,
> >>>> but, M3 or E3 will use different clock.
> >>>> 
> >>>> Is this more clear ?
> >>> 
> >>> Does it mean that every FCP instance uses both the S2D2 and the S2D1
> >>> clocks as functional clocks on H3 ES1 ?
> >>  
> >>  - s2d2 (200MHz) is for APB-IF,
> >>  - s2d1 (400MHz) is for AXI-IF, and internal
> >> 
> >> Is this clear answer ?
> > 
> > It is, thank you very much for putting up with my slow mind ;-)
> > 
> > Geert, deciding what clock to use as a parent for the MSTP clock becomes
> > interesting, As S2D2 clocks the control interface I propose picking it.
> > This shows the limits of the MSTP clock model though, MSTP is really a
> > module stop bit, not a clock.
> 
> Quoting R-Car Gen3 rev. 0.5E:
> "Under software control, the CPG is capable of turning the supply of clock
> signals to individual modules on or off and of resetting individual
> modules."
> 
> So it is a clock signal, or better (or worse): clock signals (plural).

I certainly believe that the module clock(s) is (are) gated when the module is 
stopped through its MSTP bit. My point was that MSTP in itself is not a clock, 
it's a module stop feature that uses clock and possibly other means to stop 
modules and lower power consumption.

> Hence MSTP gates one or more clocks. Sigh...

The question is whether we really need to model that, and the answer can be 
given in a case-by-case basis. In this case, given that S2D1 and S2D2 are both 
children of the S2 clock and are not individually gate-able (the S2 clock 
itself isn't either as far as I can tell) then it doesn't matter too much from 
a functional point of view. The FCP MSTP clock doesn't have to be modeled in 
the CPG driver as having multiple parents.

-- 
Regards,

Laurent Pinchart

