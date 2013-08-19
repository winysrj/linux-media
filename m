Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42462 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab3HSNjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 09:39:20 -0400
Date: Mon, 19 Aug 2013 14:39:07 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH RFC v5] s5k5baf: add camera sensor driver
Message-ID: <20130819133907.GN3719@e106331-lin.cambridge.arm.com>
References: <1376918307-21490-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376918307-21490-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 19, 2013 at 02:18:27PM +0100, Andrzej Hajda wrote:
> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> with embedded SoC ISP.
> The driver exposes the sensor as two V4L2 subdevices:
> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>   no controls.
> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>   pre/post ISP cropping, downscaling via selection API, controls.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v5
> - removed non-standard samsung hflip/vflip device tree bindings
> 
> v4
> - GPL changed to GPLv2,
> - bitfields replaced by u8,
> - cosmetic changes,
> - corrected s_stream flow,
> - gpio pins are no longer exported,
> - added I2C addresses to subdev names,
> - CIS subdev registration postponed after
>   succesfull HW initialization,
> - added enums for pads,
> - selections are initialized only during probe,
> - default resolution changed to 1600x1200,
> - state->error pattern removed from few other functions,
> - entity link creation moved to registered callback.
> 
> v3:
> - narrowed state->error usage to i2c and power errors,
> - private gain controls replaced by red/blue balance user controls,
> - added checks to devicetree gpio node parsing
> 
> v2:
> - lower-cased driver name,
> - removed underscore from regulator names,
> - removed platform data code,
> - v4l controls grouped in anonymous structs,
> - added s5k5baf_clear_error function,
> - private controls definitions moved to uapi header file,
> - added v4l2-controls.h reservation for private controls,
> - corrected subdev registered/unregistered code,
> - .log_status sudbev op set to v4l2 helper,
> - moved entity link creation to probe routines,
> - added cleanup on error to probe function.
> ---
>  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   51 +
>  MAINTAINERS                                        |    7 +
>  drivers/media/i2c/Kconfig                          |    7 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/s5k5baf.c                        | 1980 ++++++++++++++++++++
>  5 files changed, 2046 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>  create mode 100644 drivers/media/i2c/s5k5baf.c
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> new file mode 100644
> index 0000000..b1f2fde
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> @@ -0,0 +1,51 @@
> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> +-------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible     : "samsung,s5k5baf";
> +- reg            : I2C slave address of the sensor;
> +- vdda-supply    : analog power supply 2.8V (2.6V to 3.0V);
> +- vddreg-supply          : regulator input power supply 1.8V (1.7V to 1.9V)
> +                    or 2.8V (2.6V to 3.0);
> +- vddio-supply   : I/O power supply 1.8V (1.65V to 1.95V)
> +                    or 2.8V (2.5V to 3.1V);
> +- gpios                  : GPIOs connected to STDBYN and RSTN pins,
> +                    in order: STBYN, RSTN;
> +- clock-frequency : master clock frequency in Hz;

Why is this necessary? Could you not just require having a clocks
property? You could then get equivalent functionality to the
clock-frequency property by having a fixed-clock node if you don't ahve
a real clock specifier to wire up.

> +
> +Optional properties:
> +
> +- clocks         : contains the sensor's master clock specifier;
> +- clock-names    : contains "mclk" entry;
> +
> +The device node should contain one 'port' child node with one child 'endpoint'
> +node, according to the bindings defined in Documentation/devicetree/bindings/
> +media/video-interfaces.txt. The following are properties specific to those nodes.
> +
> +endpoint node
> +-------------
> +
> +- data-lanes     : (optional) an array specifying active physical MIPI-CSI2
> +                   data output lanes and their mapping to logical lanes; the
> +                   array's content is unused, only its length is meaningful;

Is that a property of the driver, or does the design of the hardware
mean that this can never encode useful information?

What does the length of the property imply?

> +
> +Example:
> +
> +s5k5bafx@2d {
> +       compatible = "samsung,s5k5baf";
> +       reg = <0x2d>;
> +       vdda-supply = <&cam_io_en_reg>;
> +       vddreg-supply = <&vt_core_15v_reg>;
> +       vddio-supply = <&vtcam_reg>;
> +       gpios = <&gpl2 0 1>,
> +               <&gpl2 1 1>;
> +       clock-frequency = <24000000>;
> +
> +       port {
> +               s5k5bafx_ep: endpoint {
> +                       remote-endpoint = <&csis1_ep>;
> +                       data-lanes = <1>;
> +               };
> +       };
> +};

Thanks,
Mark.
