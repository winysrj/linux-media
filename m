Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57240 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdLKOYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 09:24:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/10] dt-bindings: media: Add Renesas CEU bindings
Date: Mon, 11 Dec 2017 16:24:14 +0200
Message-ID: <2289037.uBIDySjJLr@avalon>
In-Reply-To: <20171115123312.7fyhlpjsb3mp3ypc@valkosipuli.retiisi.org.uk>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-2-git-send-email-jacopo+renesas@jmondi.org> <20171115123312.7fyhlpjsb3mp3ypc@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, 15 November 2017 14:33:12 EET Sakari Ailus wrote:
> On Wed, Nov 15, 2017 at 11:55:54AM +0100, Jacopo Mondi wrote:
> > Add bindings documentation for Renesas Capture Engine Unit (CEU).
> > 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> > 
> >  .../devicetree/bindings/media/renesas,ceu.txt      | 87 +++++++++++++++++
> >  1 file changed, 87 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/renesas,ceu.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt
> > b/Documentation/devicetree/bindings/media/renesas,ceu.txt new file mode
> > 100644
> > index 0000000..a88e9cb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> > @@ -0,0 +1,87 @@
> > +Renesas Capture Engine Unit (CEU)
> > +----------------------------------------------
> > +
> > +The Capture Engine Unit is the image capture interface found on Renesas
> > +RZ chip series and on SH Mobile ones.
> > +
> > +The interface supports a single parallel input with up 8/16bits data bus
> > width.
> > +
> > +Required properties:
> > +- compatible
> > +	Must be "renesas,renesas-ceu".
> > +- reg
> > +	Physical address base and size.
> > +- interrupts
> > +	The interrupt line number.
> > +- pinctrl-names, pinctrl-0
> > +	phandle of pin controller sub-node configuring pins for CEU operations.
> > +
> > +CEU supports a single parallel input and should contain a single 'port'
> > subnode
> > +with a single 'endpoint'. Optional endpoint properties applicable to
> > parallel
> > +input bus are described in "video-interfaces.txt".
> 
> Could you list which ones they are? For someone not familiar with the
> parallel bus this might not be obvious; also not all hardware can make use
> of every one of these properties.

Agreed, you should list the properties here and reference video-interfaces.txt 
for the detailed description.

> > +
> > +Example:
> > +
> > +The example describes the connection between the Capture Engine Unit and
> > a
> > +OV7670 image sensor sitting on bus i2c1 with an on-board 24Mhz clock.
> > +
> > +ceu: ceu@e8210000 {
> > +	reg = <0xe8210000 0x209c>;
> > +	compatible = "renesas,renesas-ceu";
> > +	interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&vio_pins>;
> > +
> > +	status = "okay";
> > +
> > +	port {
> > +		ceu_in: endpoint {
> > +			remote-endpoint = <&ov7670_out>;
> > +
> > +			bus-width = <8>;
> > +			hsync-active = <1>;
> > +			vsync-active = <1>;
> > +			pclk-sample = <1>;
> > +			data-active = <1>;
> > +		};
> > +	};
> > +};
> > +
> > +i2c1: i2c@fcfee400 {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&i2c1_pins>;
> > +
> > +	status = "okay";
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
> > +		clocks = <&xclk>;
> > +		clock-names = "xclk";
> > +
> > +		xclk: fixed_clk {
> > +			compatible = "fixed-clock";
> > +			#clock-cells = <0>;
> > +			clock-frequency = <24000000>;
> > +		};
> 
> What's the purpose of the fixed_clk node here?

The sensor is clocked by a 24MHz oscillator. The clock isn't provided by the 
sensor, so it should be located at the root of the device tree, not as a child 
of the sensor DT node.

> > +
> > +		port {
> > +			ov7670_out: endpoint {
> > +				remote-endpoint = <&ceu_in>;
> > +
> > +				bus-width = <8>;
> > +				hsync-active = <1>;
> > +				vsync-active = <1>;
> > +				pclk-sample = <1>;
> > +				data-active = <1>;
> > +			};
> > +		};
> > +	};

-- 
Regards,

Laurent Pinchart
