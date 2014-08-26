Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:43489 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbaHZJBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 05:01:30 -0400
Date: Tue, 26 Aug 2014 18:01:26 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Grant Likely <grant.likely@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] devicetree: bindings: Document Renesas JPEG
 Processing Unit.
Message-ID: <20140826090126.GC29667@verge.net.au>
References: <1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <1408970132-6690-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <CAMuHMdXQAFVJ8Ezd30JNkT6hWoFYKUWk5e0cq88jYUSBTPOzRA@mail.gmail.com>
 <20140825235720.GB7217@verge.net.au>
 <CAMuHMdW0r-xGJZtc4AFvxMnTu1rdEROf2DvywScC-XhSELFMtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW0r-xGJZtc4AFvxMnTu1rdEROf2DvywScC-XhSELFMtQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 26, 2014 at 10:03:34AM +0200, Geert Uytterhoeven wrote:
> On Tue, Aug 26, 2014 at 1:57 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Mon, Aug 25, 2014 at 02:59:46PM +0200, Geert Uytterhoeven wrote:
> >> Hi Mikhail,
> >>
> >> On Mon, Aug 25, 2014 at 2:35 PM, Mikhail Ulyanov
> >> <mikhail.ulyanov@cogentembedded.com> wrote:
> >> > +  - compatible: should containg one of the following:
> >> > +                       - "renesas,jpu-r8a7790" for R-Car H2
> >> > +                       - "renesas,jpu-r8a7791" for R-Car M2
> >> > +                       - "renesas,jpu-gen2" for R-Car second generation
> >>
> >> Isn't "renesas,jpu-gen2" meant as a fallback?
> >>
> >> I.e. the DTS should have one of '7790 and '7791, AND the gen2 fallback,
> >> so we can make the driver match against '7790 and '7791 is we find
> >> out about an incompatibility.
> >
> > Is there a document that clearly states that there is such a thing
> > as jpu-gen2 in hardware? If not I would prefer not to add a binding for it.
> 
> We do have a document that describes the "JPEG Processing Unit (JPU)",
> as found in the following members of the "Second Generation R-Car Series
> Products": "R-Car H2", "R-Car M2-W", "R-Car M2-N", and "R-Car V2H".

Oh, that is nice :)

>From my point of view that ticks a lot of boxes.
But I wonder if we can come up with a better name than jpu,-gen2.

> As for other SoCs, M1, H1, and A1 also seem to contain a JPU, but just
> like Mikhail, I don't have enough information to say anything about those.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
