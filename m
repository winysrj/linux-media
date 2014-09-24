Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38206 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaIXNiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 09:38:17 -0400
Received: by mail-lb0-f170.google.com with SMTP id z11so5367254lbi.29
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 06:38:16 -0700 (PDT)
Date: Wed, 24 Sep 2014 17:38:14 +0400
From: Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>
To: Simon Horman <horms@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
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
Subject: Re: [PATCH v2 6/6] devicetree: bindings: Document Renesas JPEG
 Processing Unit.
Message-ID: <20140924173814.7e9b7be2@bones>
In-Reply-To: <20140826024257.GB17906@verge.net.au>
References: <1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<CAMuHMdXQAFVJ8Ezd30JNkT6hWoFYKUWk5e0cq88jYUSBTPOzRA@mail.gmail.com>
	<20140825235720.GB7217@verge.net.au>
	<2193337.axohMI28rU@avalon>
	<20140826024257.GB17906@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Aug 2014 11:42:57 +0900
Simon Horman <horms@verge.net.au> wrote:

> On Tue, Aug 26, 2014 at 02:02:00AM +0200, Laurent Pinchart wrote:
> > Hi Simon,
> > 
> > On Tuesday 26 August 2014 08:57:20 Simon Horman wrote:
> > > On Mon, Aug 25, 2014 at 02:59:46PM +0200, Geert Uytterhoeven
> > > wrote:
> > > > On Mon, Aug 25, 2014 at 2:35 PM, Mikhail Ulyanov wrote:
> > > > >
> > > > > +  - compatible: should containg one of the following:
> > > > > +                       - "renesas,jpu-r8a7790" for R-Car H2
> > > > > +                       - "renesas,jpu-r8a7791" for R-Car M2
> > > > > +                       - "renesas,jpu-gen2" for R-Car second
> > > > > generation
> > > > 
> > > > Isn't "renesas,jpu-gen2" meant as a fallback?
> > > > 
> > > > I.e. the DTS should have one of '7790 and '7791, AND the gen2
> > > > fallback, so we can make the driver match against '7790 and
> > > > '7791 is we find out about an incompatibility.
> > > 
> > > Is there a document that clearly states that there is such a thing
> > > as jpu-gen2 in hardware? If not I would prefer not to add a
> > > binding for it.
> > 
> > How about going the other way around and requesting that document ?
> 
> Good idea, I will make a request.

Hi Simon,

Is there any update on this topic from HW team? 
If no, should i left it as is?
