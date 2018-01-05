Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45726 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbeAERza (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 12:55:30 -0500
Date: Fri, 5 Jan 2018 18:55:09 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] dt-bindings: media: Add Renesas CEU bindings
Message-ID: <20180105175509.GK9493@w540>
References: <1515081797-17174-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515081797-17174-2-git-send-email-jacopo+renesas@jmondi.org>
 <14433032.8RBNSVMmkm@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14433032.8RBNSVMmkm@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Jan 05, 2018 at 12:28:03AM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> On Thursday, 4 January 2018 18:03:09 EET Jacopo Mondi wrote:
> > Add bindings documentation for Renesas Capture Engine Unit (CEU).
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  .../devicetree/bindings/media/renesas,ceu.txt      | 85 +++++++++++++++++++
> >  1 file changed, 85 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt
> > b/Documentation/devicetree/bindings/media/renesas,ceu.txt new file mode
> > 100644
> > index 0000000..a4f3c05
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> > @@ -0,0 +1,85 @@
> > +Renesas Capture Engine Unit (CEU)
> > +----------------------------------------------
> > +
> > +The Capture Engine Unit is the image capture interface found in the Renesas
> > +SH Mobile and RZ SoCs.
> > +
> > +The interface supports a single parallel input with data bus width of 8 or
> > 16
> > +bits.
> > +
> > +Required properties:
> > +- compatible: Must be one of the following.
> > +	- "renesas,r7s72100-ceu" for CEU units found in R7S72100 (RZ/A1) SoCs.
> > +	- "renesas,ceu" as a generic fallback.
>
> As asked in my review of patch 3/9, what's your policy for compatible strings
> ? As far as I understand there's no generic CEU, as the SH4 and RZ versions
> are not compatible. Should the "renesas,ceu" compatible string then be
> replaced by "renesas,rz-ceu" ?

No, there's actually no generic CEU, as it differs from RZ and SH4 and
it differs even more between RZ/A1-[H|M] and, say, RZ/A1-L (not sure about
RZ/G and other variants mentioned by Geert's reply to your comment
though). In facts, between the RZ/A1-H and SH4 one I (you actually)
have found a single register difference, while between A1-H and A1-L
there are differences in the supported capture modes (RZ/A1-L supports
'data enable fetch mode' while A1-H does not).

Can we drop the generic fallback completely, and do as we've done for
the RZ pin controller, where we use the part number for all compatible
string?

So that:
r7s72100-ceu would be RZ/A1-[H|M]
r7s72102-ceu would be RZ/A1-L
r7s72103-ceu would be RZ/A1-LU

>
> > +       SH Mobile CPUs do not currently support OF, and they configure their
> > +	CEU interfaces using platform data. The "compatible" list will be
> > +	expanded once SH Mobile will be made OF-capable.
>
> The first sentence is out of scope, or at least its second half. I'd drop this
> completely, or possibly capture it in the commit message.
>

I was under the impression you asked for this, I'll drop it

> > +- reg: Registers address base and size.
> > +- interrupts: The interrupt specifier.
> > +
> > +The CEU supports a single parallel input and should contain a single 'port'
> > +subnode with a single 'endpoint'. Connection to input devices are modeled
> > +according to the video interfaces OF bindings specified in:
> > +Documentation/devicetree/bindings/media/video-interfaces.txt
> > +
> > +Optional endpoint properties applicable to parallel input bus described in
> > +the above mentioned "video-interfaces.txt" file are supported by this
> > driver:
>
> I know it's hard to get rid of that habit, but drivers are out of scope for DT
> bindings so they should not be mentioned. You should of course document the
> properties, and explain whether they are mandatory and optional.
>

That's out of scope from this series, but what's the rationale behind
this? I mean, the CEU hw can do -a lot- of things this driver does not
support, what I'm describing here is what the driver controlling this
hw supports...

Anyway, I'll 's/by this driver//'

> > +
> > +- hsync-active: Active state of the HSYNC signal, 0/1 for LOW/HIGH
> > respectively.
> > +- vsync-active: Active state of the VSYNC signal, 0/1 for LOW/HIGH
> > respectively.
> > +
> > +Example:
> > +
> > +The example describes the connection between the Capture Engine Unit and an
> > +OV7670 image sensor connected to i2c1 interface.
> > +
> > +ceu: ceu@e8210000 {
> > +	reg = <0xe8210000 0x209c>;
> > +	compatible = "renesas,ceu";
>
> Don't forget to update this example when you'll address my comment about
> compatible strings.

Right, I'll use the r7s72100 string.

Thanks
   j
>
> > +	interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> > +
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&vio_pins>;
> > +
> > +	status = "okay";
> > +
> > +	port {
> > +		ceu_in: endpoint {
> > +			remote-endpoint = <&ov7670_out>;
> > +
> > +			hsync-active = <1>;
> > +			vsync-active = <0>;
> > +		};
> > +	};
> > +};
> > +
> > +i2c1: i2c@fcfee400 {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&i2c1_pins>;
> > +
> > +	status = "okay";
> > +
> > +	clock-frequency = <100000>;
> > +
> > +	ov7670: camera@21 {
> > +		compatible = "ovti,ov7670";
> > +		reg = <0x21>;
> > +
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&vio_pins>;
> > +
> > +		reset-gpios = <&port3 11 GPIO_ACTIVE_LOW>;
> > +		powerdown-gpios = <&port3 12 GPIO_ACTIVE_HIGH>;
> > +
> > +		port {
> > +			ov7670_out: endpoint {
> > +				remote-endpoint = <&ceu_in>;
> > +
> > +				hsync-active = <1>;
> > +				vsync-active = <0>;
> > +			};
> > +		};
> > +	};
> > +};
>
> --
> Regards,
>
> Laurent Pinchart
>
