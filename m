Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45439 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbaDBXOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 19:14:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2 4/6] v4l: vsp1: Add DT support
Date: Thu, 03 Apr 2014 01:16:52 +0200
Message-ID: <1484365.AL7arRdPNh@avalon>
In-Reply-To: <533C832C.3080608@gmail.com>
References: <1396461690-2334-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <533C832C.3080608@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 02 April 2014 23:37:48 Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> I've got just couple minor comments...

Thank you for your comments.

> On 04/02/2014 08:01 PM, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/media/renesas,vsp1.txt     | 43 +++++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_drv.c             | 52 +++++++++++++----
> >  2 files changed, 87 insertions(+), 8 deletions(-)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/renesas,vsp1.txt
> > 
> > Hi,
> > 
> > This is the last call for DT bindings review, with a small change to the
> > bindings compared to v1. If I don't get any reply I'll assume that those
> > (pretty simple) bindings are perfect :-)
> > 
> > Changes since v1:
> > 
> > - Drop the clock-names property, as the VSP1 uses a single clock
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> > b/Documentation/devicetree/bindings/media/renesas,vsp1.txt new file mode
> > 100644
> > index 0000000..45c1d3c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> > @@ -0,0 +1,43 @@
> > +* Renesas VSP1 Video Processing Engine
> > +
> > +The VSP1 is a video processing engine that supports up-/down-scaling,
> > alpha
> > +blending, color space conversion and various other image processing
> > features.
> > +It can be found in the Renesas R-Car second generation SoCs.
> > +
> > +Required properties:
> > +
> > +  - compatible: Must contain "renesas,vsp1"
> > +
> > +  - reg: Base address and length of the registers block for the VSP1.
> > +  - interrupt-parent, interrupts: Specifier for the VSP1 interrupt.
> 
> I don't think 'interrupt-parent' needs to be documented in this device's
> binding, I'd say it belongs more to the interrupt controller binding.
> In any case, I would separate interrupt-parent and interrupt properties,
> as the former contains a phandle to the parent interrupt controller and
> the latter contains the vsp1 interrupt specifier.
> 
> I'd humbly suggest to rephrase it to something along the lines of:
> 
>       - interrupts: should contain the VSP1 interrupt specifier.

Sure, that sounds good to me. I'll remove the interrupt-parent property.

We should really come up with a standard working for interrupt specifiers and 
use it through all the DT bindings...

> > +  - clocks: A phandle + clock-specifier pair for the VSP1 functional
> > clock.
> > +
> > +  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the
> > VSP1.
> > +  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the> VSP1.
> > +  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the
> > VSP1.
> > +
> > +
> > +Optional properties:
> > +
> > +  - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF)
> > module is +    available.
> > +  - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT)
> > module is +    available.
> > +  - renesas,has-sru: Boolean, indicates that the Super Resolution Unit
> > (SRU) +    module is available.
> > +
> > +
> > +Example: R8A7790 (R-Car H2) VSP1-S node
> > +
> > +	vsp1@fe928000 {
> > +		compatible = "renesas,vsp1";
> > +		reg = <0 0xfe928000 0 0x8000>;
> 
> These register ranges look suspicious, shouldn't this be just
> <0xfe928000 0x8000> ? What is the #address-cells and #size-cells
> values for this node ?

Both #address-cells and #size-cells are equal to 2, the R8A7790 support LPAE.

> > +		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&mstp1_clks R8A7790_CLK_VSP1_S>;
> > +
> > +		renesas,has-lut;
> > +		renesas,has-sru;
> > +		renesas,#rpf = <5>;
> > +		renesas,#uds = <3>;
> > +		renesas,#wpf = <4>;
> > +	};
> > diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> > b/drivers/media/platform/vsp1/vsp1_drv.c index 28e1de3..644650f 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drv.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drv.c

[snip]

> > @@ -527,6 +557,11 @@ static int vsp1_remove(struct platform_device *pdev)
> >   	return 0;
> >   }
> > 
> > +static const struct of_device_id vsp1_of_match[] = {
> > +	{ .compatible = "renesas,vsp1" },
> > +	{ },
> > +};
> > +
> >   static struct platform_driver vsp1_platform_driver = {
> >   	.probe		= vsp1_probe,
> >   	.remove		= vsp1_remove,
> > @@ -534,6 +569,7 @@ static struct platform_driver vsp1_platform_driver = {
> >   		.owner	= THIS_MODULE,
> >   		.name	= "vsp1",
> >   		.pm	= &vsp1_pm_ops,
> > +		.of_match_table = of_match_ptr(vsp1_of_match),
> 
> Is of_match_ptr() really useful here, when vsp1_of_match[] array is always
> compiled in ?

Would it be better to compile the vsp1_of_match[] array conditionally ? On the 
other hand the driver is only useful (at least at the moment) on ARM Renesas 
SoCs, which are transitioning to DT anyway.

> >   	},
> >   };
> 
> Otherwise this binding indeed looks perfect to me. ;)

Thank you :-)

-- 
Regards,

Laurent Pinchart

