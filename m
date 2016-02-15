Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55884 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbcBOMuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 07:50:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 6/9] ARM64: renesas: r8a7795: Add FCPV nodes
Date: Mon, 15 Feb 2016 14:50:29 +0200
Message-ID: <1555014.Ze7EhO0YPL@avalon>
In-Reply-To: <CAMuHMdWXdY0DS--sfOy83jixKyBzu5gFPAY2BQs5PBCDh0Fxdw@mail.gmail.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1455242450-24493-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdWXdY0DS--sfOy83jixKyBzu5gFPAY2BQs5PBCDh0Fxdw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the review.

On Monday 15 February 2016 10:45:39 Geert Uytterhoeven wrote:
> On Fri, Feb 12, 2016 at 3:00 AM, Laurent Pinchart wrote:
> > The FCPs handle the interface between various IP cores and memory. Add
> > the instances related to the VSP2s.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  arch/arm64/boot/dts/renesas/r8a7795.dtsi | 63 ++++++++++++++++++++++++++
> >  1 file changed, 63 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> > b/arch/arm64/boot/dts/renesas/r8a7795.dtsi index
> > b5e46e4ff72a..f62d6fa28acc 100644
> > --- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> > +++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
> > @@ -960,5 +960,68 @@
> >                         #dma-cells = <1>;
> >                         dma-channels = <2>;
> >                 };
> > 
> > +
> > +               fcpvb1: fcp@fe92f000 {
> > +                       compatible = "renesas,fcpv";
> > +                       reg = <0 0xfe92f000 0 0x200>;
> > +                       clocks = <&cpg CPG_MOD 606>;
> > +                       power-domains = <&cpg>;
> > +               };
> 
> The FCP_V modules are located in the A3VP Power Area. But adding this
> information to DT depends on the SYSC PM Domain driver.
> 
> I'll try to post my WIP PM Domain patchset for R-Car ASAP...

As soon as you add the A3VP power domain to DT I'll make sure to make use of 
it :-)

-- 
Regards,

Laurent Pinchart

