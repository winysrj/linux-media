Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:56248 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaHVB5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 21:57:07 -0400
Date: Fri, 22 Aug 2014 10:57:03 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	m.chehab@samsung.com, magnus.damm@gmail.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/6] ARM: shmobile: r8a7790: Add JPU clock dt and CPG
 define.
Message-ID: <20140822015702.GF9099@verge.net.au>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <1408452653-14067-3-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <2193234.fL02BJsSMl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2193234.fL02BJsSMl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 21, 2014 at 01:07:23AM +0200, Laurent Pinchart wrote:
> Hi Mikhail,
> 
> Thank you for the patch.
> 
> On Tuesday 19 August 2014 16:50:49 Mikhail Ulyanov wrote:
> 
> A commit message would be nice.
> 
> > Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, I have queued this up.

> > ---
> >  arch/arm/boot/dts/r8a7790.dtsi            | 6 +++---
> >  include/dt-bindings/clock/r8a7790-clock.h | 1 +
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> > index e2e40e5..61fd193 100644
> > --- a/arch/arm/boot/dts/r8a7790.dtsi
> > +++ b/arch/arm/boot/dts/r8a7790.dtsi
> > @@ -868,17 +868,17 @@
> >  		mstp1_clks: mstp1_clks@e6150134 {
> >  			compatible = "renesas,r8a7790-mstp-clocks", "renesas,cpg-mstp-
> clocks";
> >  			reg = <0 0xe6150134 0 4>, <0 0xe6150038 0 4>;
> > -			clocks = <&p_clk>, <&p_clk>, <&p_clk>, <&rclk_clk>,
> > +			clocks = <&m2_clk>, <&p_clk>, <&p_clk>, <&p_clk>, <&rclk_clk>,
> >  				 <&cp_clk>, <&zs_clk>, <&zs_clk>, <&zs_clk>,
> >  				 <&zs_clk>;
> >  			#clock-cells = <1>;
> >  			renesas,clock-indices = <
> > -				R8A7790_CLK_TMU1 R8A7790_CLK_TMU3 R8A7790_CLK_TMU2
> > +				R8A7790_CLK_JPU R8A7790_CLK_TMU1 R8A7790_CLK_TMU3 
> R8A7790_CLK_TMU2
> >  				R8A7790_CLK_CMT0 R8A7790_CLK_TMU0 R8A7790_CLK_VSP1_DU1
> >  				R8A7790_CLK_VSP1_DU0 R8A7790_CLK_VSP1_R R8A7790_CLK_VSP1_S
> > 
> >  			>;
> > 
> >  			clock-output-names =
> > -				"tmu1", "tmu3", "tmu2", "cmt0", "tmu0", "vsp1-du1",
> > +				"jpu", "tmu1", "tmu3", "tmu2", "cmt0", "tmu0", "vsp1-du1",
> >  				"vsp1-du0", "vsp1-rt", "vsp1-sy";
> >  		};
> >  		mstp2_clks: mstp2_clks@e6150138 {
> > diff --git a/include/dt-bindings/clock/r8a7790-clock.h
> > b/include/dt-bindings/clock/r8a7790-clock.h index f929a79e..8ea7ab0 100644
> > --- a/include/dt-bindings/clock/r8a7790-clock.h
> > +++ b/include/dt-bindings/clock/r8a7790-clock.h
> > @@ -26,6 +26,7 @@
> >  #define R8A7790_CLK_MSIOF0		0
> > 
> >  /* MSTP1 */
> > +#define R8A7790_CLK_JPU		6
> >  #define R8A7790_CLK_TMU1		11
> >  #define R8A7790_CLK_TMU3		21
> >  #define R8A7790_CLK_TMU2		22
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
