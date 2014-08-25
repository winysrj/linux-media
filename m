Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49524 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaHYJsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 05:48:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>
Cc: m.chehab@samsung.com, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 6/6] devicetree: bindings: Document Renesas JPEG Processing Unit.
Date: Mon, 25 Aug 2014 11:49:11 +0200
Message-ID: <1792321.pxB6gXzI03@avalon>
In-Reply-To: <20140822182053.62667c32@bones>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <3694359.xqEjcGBlOG@avalon> <20140822182053.62667c32@bones>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

On Friday 22 August 2014 18:20:53 Mikhail Ulianov wrote:
> On Thu, 21 Aug 2014 01:01:43 +0200 Laurent Pinchart wrote:
> > On Tuesday 19 August 2014 16:50:53 Mikhail Ulyanov wrote:
> > > Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> > > ---
> > > 
> > >  .../devicetree/bindings/media/renesas,jpu.txt      | 23 +++++++++++++++
> > >  1 file changed, 23 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/media/renesas,jpu.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/renesas,jpu.txt
> > > b/Documentation/devicetree/bindings/media/renesas,jpu.txt new file
> > > mode 100644
> > > index 0000000..44b07df
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/renesas,jpu.txt
> > > @@ -0,0 +1,23 @@
> > > +* Renesas VSP1 Video Processing Engine
> > 
> > Copy & paste ? :-)
> 
> Yeah. Will fix it.
> 
> > > +
> > > +The JPEG processing unit (JPU) incorporates the JPEG codec with an
> > > encoding +and decoding function conforming to the JPEG baseline
> > > process, so that the JPU
> > > +can encode image data and decode JPEG data quickly.
> > > +It can be found in the Renesas R-Car first and second generation
> > > SoCs.
> > 
> > Is there a difference between the first and second generation JPUs ?
> 
> There should be no difference because in practice maximum supported
> resolution for Gen2 is 4096x4096 (not 8000x8000 as in overview section
> of documentation). And in Gen1 documentation(overview section) maximum
> supported resolution is also 4096x4096.
> 
> > > +
> > > +Required properties:
> > > +  - compatible: should containg one of the following:
> > > +			- "renesas,jpu-r8a7790" for R-Car H2
> > > +			- "renesas,jpu-r8a7791" for R-Car M2
> > 
> > How about adding a "renesas,jpu" generic compatible, and listing both
> > the SoC- specific and the generic values (in that order) in the
> > compatible property ?
> 
> Could be a good idea, but there is no JPU in some R-Car Gen1 SoCs
> e.g. E1. Plus we don't have full documentation on JPU in Gen1 SoCs.
> So for now Gen1 is not supported. Or this doesn't matter in that case?

The lack of JPU in some chips isn't an issue, but the lack of documentation 
for Gen1 is a problem. Let's not add a too generic compatible string in that 
case.

I would still like to add a "renesas,jpu-gen2" compatible in addition to the 
SoC-specific values, but that might be frowned upon.

> > > +  - reg: Base address and length of the registers block for the
> > > JPU.
> > > +  - interrupts: JPU interrupt specifier.
> > > +  - clocks: A phandle + clock-specifier pair for the JPU
> > > functional clock. +
> > > +Example: R8A7790 (R-Car H2) JPU node
> > > +	jpeg-codec@fe980000 {
> > > +		compatible = "renesas,jpu-r8a7790";
> > > +		reg = <0 0xfe980000 0 0x10300>;
> > > +		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
> > > +		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
> > > +	};

-- 
Regards,

Laurent Pinchart

