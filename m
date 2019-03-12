Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FD9C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEFD52087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:10:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Bg1rud5q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfCLOK4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:10:56 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:57564 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfCLOK4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 10:10:56 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9D54133C;
        Tue, 12 Mar 2019 15:10:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552399853;
        bh=DAM7W5EnohSzsoZ6QjLijMWu6BB89jJTRqRa0Bs0z58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bg1rud5qQ+LB8nQuSuKUgZl54VuzFDAG0FAtSp4t/VSpl3Kb5O4Z6ymDs06Pnjrs7
         jvs5U1ISB04rZq/9lePSd0BF/d7p/8hlsLh7OMBzG58e3yqpjUwFcFLN8VWOWcSkWr
         Cinu858UkuTvyYvN2aMRsFG+R6EdoZzWjXrhXJm4=
Date:   Tue, 12 Mar 2019 16:10:46 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Rui Miguel Silva <rui.silva@linaro.org>
Cc:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v14 08/13] ARM: dts: imx7: Add video mux, csi and
 mipi_csi and connections
Message-ID: <20190312141046.GB4845@pendragon.ideasonboard.com>
References: <20190206151328.21629-1-rui.silva@linaro.org>
 <20190206151328.21629-9-rui.silva@linaro.org>
 <20190310214102.GA7578@pendragon.ideasonboard.com>
 <m3y35kdw7v.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3y35kdw7v.fsf@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rui,

On Tue, Mar 12, 2019 at 02:05:24PM +0000, Rui Miguel Silva wrote:
> On Sun 10 Mar 2019 at 21:41, Laurent Pinchart wrote:
> > Hi Rui,
> >
> > Thank you for the patch.
> 
> Where have you been for the latest 14 versions? :)

Elsewhere I suppose :-)

> This is already merged, but... follow up patches can address your
> issues bellow.

I saw the driver and DT bindings patches merged in the media tree for
v5.2, where have the DT patches been merged ?

> > On Wed, Feb 06, 2019 at 03:13:23PM +0000, Rui Miguel Silva 
> > wrote:
> >> This patch adds the device tree nodes for csi, video 
> >> multiplexer and mipi-csi besides the graph connecting the necessary
> >> endpoints to make the media capture entities to work in imx7 Warp
> >> board.
> >> 
> >> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> >> ---
> >>  arch/arm/boot/dts/imx7s-warp.dts | 51 ++++++++++++++++++++++++++++++++
> >>  arch/arm/boot/dts/imx7s.dtsi     | 27 +++++++++++++++++
> >
> > I would have split this in two patches to make backporting 
> > easier, but it's not a big deal.
> >
> > Please see below for a few additional comments.
> >
> >>  2 files changed, 78 insertions(+)
> >> 
> >> diff --git a/arch/arm/boot/dts/imx7s-warp.dts 
> >> b/arch/arm/boot/dts/imx7s-warp.dts
> >> index 23431faecaf4..358bcae7ebaf 100644
> >> --- a/arch/arm/boot/dts/imx7s-warp.dts
> >> +++ b/arch/arm/boot/dts/imx7s-warp.dts
> >> @@ -277,6 +277,57 @@
> >>  	status = "okay";
> >>  };
> >>  
> >> +&gpr {
> >> +	csi_mux {
> >> +		compatible = "video-mux";
> >> +		mux-controls = <&mux 0>;
> >> +		#address-cells = <1>;
> >> +		#size-cells = <0>;
> >> +
> >> +		port@1 {
> >> +			reg = <1>;
> >> +
> >> +			csi_mux_from_mipi_vc0: endpoint {
> >> +				remote-endpoint = 
> >> <&mipi_vc0_to_csi_mux>;
> >> +			};
> >> +		};
> >> +
> >> +		port@2 {
> >> +			reg = <2>;
> >> +
> >> +			csi_mux_to_csi: endpoint {
> >> +				remote-endpoint = 
> >> <&csi_from_csi_mux>;
> >> +			};
> >> +		};
> >> +	};
> >> +};
> >> +
> >> +&csi {
> >> +	status = "okay";
> >> +
> >> +	port {
> >> +		csi_from_csi_mux: endpoint {
> >> +			remote-endpoint = <&csi_mux_to_csi>;
> >> +		};
> >> +	};
> >> +};
> >
> > Shouldn't these two nodes, as well as port@1 of the mipi_csi 
> > node, be moved to imx7d.dtsi ?
> 
> Yeah, I guess you are right here.
> 
> >
> >> +
> >> +&mipi_csi {
> >> +	clock-frequency = <166000000>;
> >> +	status = "okay";
> >> +	#address-cells = <1>;
> >> +	#size-cells = <0>;
> >> +	fsl,csis-hs-settle = <3>;
> >
> > Shouldn't this be an endpoint property ? Different sensors connected
> > through different endpoints could have different timing
> > requirements.
> 
> Hum... I see you point, even tho the phy hs-settle is a common
> control. 

I suppose we don't need to care about DT backward compatibility if we
make changes in the bindings for v5.2 ? Would you fix this, or do you
want a patch ?

> >> +
> >> +	port@1 {
> >> +		reg = <1>;
> >> +
> >> +		mipi_vc0_to_csi_mux: endpoint {
> >> +			remote-endpoint = <&csi_mux_from_mipi_vc0>;
> >> +		};
> >> +	};
> >> +};
> >> +
> >>  &wdog1 {
> >>  	pinctrl-names = "default";
> >>  	pinctrl-0 = <&pinctrl_wdog>;
> >> diff --git a/arch/arm/boot/dts/imx7s.dtsi 
> >> b/arch/arm/boot/dts/imx7s.dtsi
> >> index 792efcd2caa1..01962f85cab6 100644
> >> --- a/arch/arm/boot/dts/imx7s.dtsi
> >> +++ b/arch/arm/boot/dts/imx7s.dtsi
> >> @@ -8,6 +8,7 @@
> >>  #include <dt-bindings/gpio/gpio.h>
> >>  #include <dt-bindings/input/input.h>
> >>  #include <dt-bindings/interrupt-controller/arm-gic.h>
> >> +#include <dt-bindings/reset/imx7-reset.h>
> >>  #include "imx7d-pinfunc.h"
> >>  
> >>  / {
> >> @@ -709,6 +710,17 @@
> >>  				status = "disabled";
> >>  			};
> >>  
> >> +			csi: csi@30710000 {
> >> +				compatible = "fsl,imx7-csi";
> >> +				reg = <0x30710000 0x10000>;
> >> +				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> >> +				clocks = <&clks IMX7D_CLK_DUMMY>,
> >> +						<&clks IMX7D_CSI_MCLK_ROOT_CLK>,
> >> +						<&clks IMX7D_CLK_DUMMY>;
> >> +				clock-names = "axi", "mclk", "dcic";
> >> +				status = "disabled";
> >> +			};
> >> +
> >>  			lcdif: lcdif@30730000 {
> >>  				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
> >>  				reg = <0x30730000 0x10000>;
> >> @@ -718,6 +730,21 @@
> >>  				clock-names = "pix", "axi";
> >>  				status = "disabled";
> >>  			};
> >> +
> >> +			mipi_csi: mipi-csi@30750000 {
> >> +				compatible = "fsl,imx7-mipi-csi2";
> >> +				reg = <0x30750000 0x10000>;
> >> +				interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
> >> +				clocks = <&clks IMX7D_IPG_ROOT_CLK>,
> >> +					<&clks IMX7D_MIPI_CSI_ROOT_CLK>,
> >> +					<&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
> >> +				clock-names = "pclk", "wrap", "phy";
> >> +				power-domains = <&pgc_mipi_phy>;
> >> +				phy-supply = <&reg_1p0d>;
> >> +				resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
> >> +				reset-names = "mrst";
> >> +				status = "disabled";
> >
> > How about already declaring port@0 here too (but obviously 
> > without any endoint) ?
> 
> empty port, do not know if they make much sense.

The port describes the ability to connect. There's always a port@0 for
the CSI-2 receiver, so I would define it in imx7s.dtsi. If a system
doesn't connect any CSI-2 sensor then no endpoint will exist (and this
node will stay disabled anyway).

-- 
Regards,

Laurent Pinchart
