Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51273 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaH0GFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 02:05:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Grant Likely <grant.likely@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] devicetree: bindings: Document Renesas JPEG Processing Unit.
Date: Wed, 27 Aug 2014 08:06:10 +0200
Message-ID: <1636392.ZpHdXzEmup@avalon>
In-Reply-To: <20140827051501.GB1343@verge.net.au>
References: <1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com> <CAMuHMdWaO27XhfdwhMHS2+gndoysZbQsT0YLp7KhR_cWujxvTQ@mail.gmail.com> <20140827051501.GB1343@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 27 August 2014 14:15:01 Simon Horman wrote:
> On Tue, Aug 26, 2014 at 11:27:43AM +0200, Geert Uytterhoeven wrote:
> > On Tue, Aug 26, 2014 at 11:01 AM, Simon Horman <horms@verge.net.au> wrote:
> >> On Tue, Aug 26, 2014 at 10:03:34AM +0200, Geert Uytterhoeven wrote:
> >>> On Tue, Aug 26, 2014 at 1:57 AM, Simon Horman wrote:
> >>>> On Mon, Aug 25, 2014 at 02:59:46PM +0200, Geert Uytterhoeven wrote:
> >>>>> On Mon, Aug 25, 2014 at 2:35 PM, Mikhail Ulyanov wrote:
> >>>>>> +  - compatible: should containg one of the following:
> >>>>>> +                       - "renesas,jpu-r8a7790" for R-Car H2
> >>>>>> +                       - "renesas,jpu-r8a7791" for R-Car M2
> >>>>>> +                       - "renesas,jpu-gen2" for R-Car second
> >>>>>> generation
> >>>>> 
> >>>>> Isn't "renesas,jpu-gen2" meant as a fallback?
> >>>>> 
> >>>>> I.e. the DTS should have one of '7790 and '7791, AND the gen2
> >>>>> fallback, so we can make the driver match against '7790 and '7791 is
> >>>>> we find out about an incompatibility.
> >>>> 
> >>>> Is there a document that clearly states that there is such a thing
> >>>> as jpu-gen2 in hardware? If not I would prefer not to add a binding
> >>>> for it.
> >>> 
> >>> We do have a document that describes the "JPEG Processing Unit (JPU)",
> >>> as found in the following members of the "Second Generation R-Car
> >>> Series Products": "R-Car H2", "R-Car M2-W", "R-Car M2-N", and "R-Car
> >>> V2H".
> >> 
> >> Oh, that is nice :)
> >> 
> >> From my point of view that ticks a lot of boxes.
> >> But I wonder if we can come up with a better name than jpu,-gen2.
> > 
> > "jpu-rcar-gen2"?
> 
> I guess that is a slight improvement.
> 
> But suppose some gen2 SoC exists or comes to exists that
> has different IP. Suppose there is more than one that same
> the same IP that is different to the SoCs covered by the
> existing compat string?

That's exactly the information we need to request from the hardware team :-)

-- 
Regards,

Laurent Pinchart

