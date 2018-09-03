Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41645 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbeICTPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 15:15:01 -0400
Message-ID: <1535986469.6568.6.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] ARM: dts: imx6ull: add pxp support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Shawn Guo <shawnguo@kernel.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Date: Mon, 03 Sep 2018 16:54:29 +0200
In-Reply-To: <20180827065927.GE3850@dragon>
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
         <20180810151822.18650-3-p.zabel@pengutronix.de>
         <20180827065927.GE3850@dragon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-08-27 at 14:59 +0800, Shawn Guo wrote:
> On Fri, Aug 10, 2018 at 05:18:21PM +0200, Philipp Zabel wrote:
> > Add the device node for the i.MX6ULL Pixel Pipeline (PXP).
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  arch/arm/boot/dts/imx6ul.dtsi  | 8 ++++++++
> >  arch/arm/boot/dts/imx6ull.dtsi | 6 ++++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
> > index 47a3453a4211..e80a660c14f2 100644
> > --- a/arch/arm/boot/dts/imx6ul.dtsi
> > +++ b/arch/arm/boot/dts/imx6ul.dtsi
> > @@ -928,6 +928,14 @@
> >  				};
> >  			};
> >  
> > +			pxp: pxp@21cc000 {
> > +				compatible = "fsl,imx6ul-pxp";
> > +				reg = <0x021cc000 0x4000>;
> > +				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
> > +				clock-names = "axi";
> > +				clocks = <&clks IMX6UL_CLK_PXP>;
> > +			};
> > +
> >  			lcdif: lcdif@21c8000 {
> 
> In order of unit-address, pxp@21cc000 should go after lcdif@21c8000.

Thank you, I'll fix this in v2.

regards
Philipp
