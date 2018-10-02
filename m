Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49052 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeJCCph (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 22:45:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        jacopo@jmondi.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/2] [media] imx214: device tree binding
Date: Tue, 02 Oct 2018 23:00:49 +0300
Message-ID: <3623223.AF5hu8FH6T@avalon>
In-Reply-To: <20181002135738.ox3jlujqzvyc4m2b@paasikivi.fi.intel.com>
References: <20181002133058.12942-1-ricardo.ribalda@gmail.com> <3927913.3GBmOnKHNx@avalon> <20181002135738.ox3jlujqzvyc4m2b@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 2 October 2018 16:57:38 EEST Sakari Ailus wrote:
> On Tue, Oct 02, 2018 at 04:47:55PM +0300, Laurent Pinchart wrote:
> > On Tuesday, 2 October 2018 16:30:57 EEST Ricardo Ribalda Delgado wrote:
> ...
> 
> > > +- clock-frequency = Frequency of the xclk clock. (Currently the
> > > +	driver only supports <24000000>).
> > 
> > Please don't mention drivers in DT bindings. I would drop the reference to
> > the 24 MHz limitation.
> > 
> > I would actually drop the property completely :-) I don't see why you need
> > it, and you don't make use of it in the driver.
> 
> Would you rely on assigned-clock-rates or what? There's no guarantee it'll
> actually be the desired frequency. That said, few (or no) drivers checks
> what they get when they set the frequency.

No necessarily. I would either really on assigned-clock-rates + clock rate 
check in the driver, or on no DT property and a clock rate set in the driver. 
Patch 2/2 sets the clock rate in the driver to 24 MHz regardless of the clock-
frequency property in DT.

> > > +Optional Properties:
> > > +- flash-leds: See ../video-interfaces.txt
> > > +- lens-focus: See ../video-interfaces.txt
> > > +
> > > +The imx274 device node should contain one 'port' child node with
> 
> s/should/shall/?
> 
> If there's a need to support no port nodes, then say "one or none" or such.
> Usually that's useful on the receiver side only though.
> 
> > > +Example:
> > > +
> > > +	camera_rear@1a {
> > > +		compatible = "sony,imx214";
> > > +		reg = <0x1a>;
> > > +		vdddo-supply = <&pm8994_lvs1>;
> > > +		vddd-supply = <&camera_vddd_1v12>;
> > > +		vdda-supply = <&pm8994_l17>;
> > > +		lens-focus = <&ad5820>;
> > > +		enable-gpios = <&msmgpio 25 GPIO_ACTIVE_HIGH>;
> > > +		clocks = <&mmcc CAMSS_MCLK0_CLK>;
> > > +		clock-names = "xclk";
> > > +		clock-frequency = <24000000>;
> > > +		port {
> > > +			imx214_ep: endpoint {
> > > +				clock-lanes = <0>;
> 
> I'd only put clock-lanes if the lane ordering is configurable.
> 
> > > +				data-lanes = <1 2 3 4>;
> > > +				link-frequencies = /bits/ 64 <480000000>;
> > > +				remote-endpoint = <&csiphy0_ep>;
> > > +			};
> > > +		};
> > > +	};

-- 
Regards,

Laurent Pinchart
