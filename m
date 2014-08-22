Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:56239 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaHVB45 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 21:56:57 -0400
Date: Fri, 22 Aug 2014 10:56:54 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	m.chehab@samsung.com, magnus.damm@gmail.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/6] ARM: shmobile: r8a7791: Add JPU clock dt and CPG
 define.
Message-ID: <20140822015653.GE9099@verge.net.au>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <1408452653-14067-5-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <1671726.SQHuEtA4A1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671726.SQHuEtA4A1@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 21, 2014 at 01:07:25AM +0200, Laurent Pinchart wrote:
> Hi Mikhail,
> 
> Thank you for the patch.
> 
> On Tuesday 19 August 2014 16:50:51 Mikhail Ulyanov wrote:
> 
> A commit message would be nice.
> 
> > Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, I have queued this up.

> 
> > ---
> >  arch/arm/boot/dts/r8a7791.dtsi            | 6 +++---
> >  include/dt-bindings/clock/r8a7791-clock.h | 1 +
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
> > index 152c75c..c2d0c6e 100644
> > --- a/arch/arm/boot/dts/r8a7791.dtsi
> > +++ b/arch/arm/boot/dts/r8a7791.dtsi
> > @@ -889,16 +889,16 @@
> >  		mstp1_clks: mstp1_clks@e6150134 {
> >  			compatible = "renesas,r8a7791-mstp-clocks", "renesas,cpg-mstp-
> clocks";
> >  			reg = <0 0xe6150134 0 4>, <0 0xe6150038 0 4>;
> > -			clocks = <&p_clk>, <&p_clk>, <&p_clk>, <&rclk_clk>,
> > +			clocks = <&m2_clk>, <&p_clk>, <&p_clk>, <&p_clk>, <&rclk_clk>,
> >  				 <&cp_clk>, <&zs_clk>, <&zs_clk>, <&zs_clk>;
> >  			#clock-cells = <1>;
> >  			renesas,clock-indices = <
> > -				R8A7791_CLK_TMU1 R8A7791_CLK_TMU3 R8A7791_CLK_TMU2
> > +				R8A7791_CLK_JPU R8A7791_CLK_TMU1 R8A7791_CLK_TMU3 
> R8A7791_CLK_TMU2
> >  				R8A7791_CLK_CMT0 R8A7791_CLK_TMU0 R8A7791_CLK_VSP1_DU1
> >  				R8A7791_CLK_VSP1_DU0 R8A7791_CLK_VSP1_S
> > 
> >  			>;
> > 
> >  			clock-output-names =
> > -				"tmu1", "tmu3", "tmu2", "cmt0", "tmu0", "vsp1-du1",
> > +				"jpu", "tmu1", "tmu3", "tmu2", "cmt0", "tmu0", "vsp1-du1",
> >  				"vsp1-du0", "vsp1-sy";
> >  		};
> >  		mstp2_clks: mstp2_clks@e6150138 {
> > diff --git a/include/dt-bindings/clock/r8a7791-clock.h
> > b/include/dt-bindings/clock/r8a7791-clock.h index f0d4d10..58c3f49 100644
> > --- a/include/dt-bindings/clock/r8a7791-clock.h
> > +++ b/include/dt-bindings/clock/r8a7791-clock.h
> > @@ -25,6 +25,7 @@
> >  #define R8A7791_CLK_MSIOF0		0
> > 
> >  /* MSTP1 */
> > +#define R8A7791_CLK_JPU		6
> >  #define R8A7791_CLK_TMU1		11
> >  #define R8A7791_CLK_TMU3		21
> >  #define R8A7791_CLK_TMU2		22
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
