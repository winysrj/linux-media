Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53466 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250AbaCSK0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 06:26:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	m.chehab@samsung.com, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org, grant.likely@linaro.org,
	galak@codeaurora.org, rob@landley.net, mark.rutland@arm.com,
	robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
	pawel.moll@arm.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] atmel-isi: add primary DT support
Date: Wed, 19 Mar 2014 11:28:29 +0100
Message-ID: <7584711.K3Gu54mB6b@avalon>
In-Reply-To: <53296016.5030002@atmel.com>
References: <1395141238-5948-1-git-send-email-josh.wu@atmel.com> <2118978.g8dAYX7V8K@avalon> <53296016.5030002@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Wednesday 19 March 2014 17:15:02 Josh Wu wrote:
> On 3/18/2014 9:36 PM, Laurent Pinchart wrote:
> > On Tuesday 18 March 2014 19:19:54 Josh Wu wrote:
> >> This patch add the DT support for Atmel ISI driver.
> >> It use the same v4l2 DT interface that defined in video-interfaces.txt.
> >> 
> >> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> >> Cc: devicetree@vger.kernel.org
> >> ---
> >> 
> >>  .../devicetree/bindings/media/atmel-isi.txt        |   51 ++++++++++++++
> >>  drivers/media/platform/soc_camera/atmel-isi.c      |   33 ++++++++++++-
> >>  2 files changed, 82 insertions(+), 2 deletions(-)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/media/atmel-isi.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt
> >> b/Documentation/devicetree/bindings/media/atmel-isi.txt new file mode
> >> 100644
> >> index 0000000..07f00eb
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
> >> @@ -0,0 +1,51 @@
> >> +Atmel Image Sensor Interface (ISI) SoC Camera Subsystem
> >> +----------------------------------------------
> >> +
> >> +Required properties:
> >> +- compatible: must be "atmel,at91sam9g45-isi"
> >> +- reg: physical base address and length of the registers set for the
> >> device;
> >> +- interrupts: should contain IRQ line for the ISI;
> >> +- clocks: list of clock specifiers, corresponding to entries in
> >> +          the clock-names property;
> >> +- clock-names: must contain "isi_clk", which is the isi peripherial
> >> clock.
> >> +               "isi_mck" is optinal, it is the master clock output to
> >> sensor.
> > 
> > The mck clock should be handled by the sensor driver instead. I know we
> > have a legacy mode in the atmel-isi driver to manage that clock
> > internally, but let's not propagate that to DT.
> 
> I agree with you.
> 
> I put the isi_mck as optional here because current the sensor driver
> code only managed the v4l2 clock not the common clock.
> There should add additional code to manager mck clock.
> So if you want to ISI work for now, you should put the isi_mck in
> atmel-isi DT node.
> 
> But for sure I can remove the isi_mck in atmel-isi DT document. In the
> future it will be add in sensor's DT document.

I think that's the way to go, yes. I know we have existing platforms that 
require sensor clock management in the ISI driver. That should be fixed, and a 
move to DT is a perfect opportunity to do so :-)

> > I would also drop the "isi_" prefix from the isi_clk name.
> 
> hmm,  I think "isi_clk" indicates it is a ISI peripheral clock. And
> which is consistent with other peripheral clock name in sama5.

I believe the "isi_" prefix is redundant, given that the clock-names property 
is inside the ISI DT node. However, if this style matches the rest of the 
platform there's no need to change it.

> > You should also describe the port node. You can just mention the related
> > bindings document, and state that the ISI has a single port.
> 
> OK. will add in the v2.
> 
> >> +Optional properties:
> >> +- atmel,isi-disable-preview: a boolean property to disable the preview
> >> channel;
> > 
> > That doesn't really sound like a hardware property to me. Isn't it full
> > mode related to software configuration instead, which should be performed
> > at runtime by userspace ?
> 
> yes, this configuration can be disable/enable by driver according to
> user select format.
> I will remove it in v2. Thanks.
> 
> Best Regards,
> Josh Wu
> 
> >> +
> >> +Example:
> >> +	isi: isi@f0034000 {
> >> +		compatible = "atmel,at91sam9g45-isi";
> >> +		reg = <0xf0034000 0x4000>;
> >> +		interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> >> +
> >> +		clocks = <&isi_clk>, <&pck1>;
> >> +		clock-names = "isi_clk", "isi_mck";
> >> +
> >> +		pinctrl-names = "default";
> >> +		pinctrl-0 = <&pinctrl_isi &pinctrl_pck1_as_isi_mck>;
> >> +
> >> +		port {
> >> +			#address-cells = <1>;
> >> +			#size-cells = <0>;
> >> +
> >> +			isi_0: endpoint {
> >> +				remote-endpoint = <&ov2640_0>;
> >> +			};
> >> +		};
> >> +	};
> >> +
> >> +	i2c1: i2c@f0018000 {
> >> +		ov2640: camera@0x30 {
> >> +			compatible = "omnivision,ov2640";
> >> +			reg = <0x30>;
> >> +
> >> +			port {
> >> +				ov2640_0: endpoint {
> >> +					remote-endpoint = <&isi_0>;
> >> +					bus-width = <8>;
> >> +				};
> >> +			};
> >> +		};
> >> +	};

-- 
Regards,

Laurent Pinchart

