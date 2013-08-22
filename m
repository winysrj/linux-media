Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33948 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HVWjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 18:39:52 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
Date: Fri, 23 Aug 2013 00:39:44 +0200
Message-ID: <9243520.EzMBhpL3jX@flatron>
In-Reply-To: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Please see some minor comments inline.

On Wednesday 21 of August 2013 16:41:31 Andrzej Hajda wrote:
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
> Hi,
> 
> This patch incorporates Stephen's suggestions, thanks.
> 
> Regards
> Andrzej
> 
> v7
> - changed description of 'clock-frequency' DT property
> 
> v6
> - endpoint node presence is now optional,
> - added asynchronous subdev registration support and clock
>   handling,
> - use named gpios in DT bindings
> 
> v5
> - removed hflip/vflip device tree properties
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
>  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   59 +
>  MAINTAINERS                                        |    7 +
>  drivers/media/i2c/Kconfig                          |    7 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/s5k5baf.c                        | 2045
> ++++++++++++++++++++ 5 files changed, 2119 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/media/samsung-s5k5baf.txt create mode
> 100644 drivers/media/i2c/s5k5baf.c
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt new file
> mode 100644
> index 0000000..d680d99
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> @@ -0,0 +1,59 @@
> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> +--------------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible	  : "samsung,s5k5baf";
> +- reg		  : I2C slave address of the sensor;

Can this sensor have an aribitrary slave address or only a set of well 
known possible addresses (e.g. listed in documentation)?

> +- vdda-supply	  : analog power supply 2.8V (2.6V to 3.0V);
> +- vddreg-supply	  : regulator input power supply 1.8V (1.7V to 
1.9V)
> +		    or 2.8V (2.6V to 3.0);
> +- vddio-supply	  : I/O power supply 1.8V (1.65V to 1.95V)
> +		    or 2.8V (2.5V to 3.1V);
> +- stbyn-gpios	  : GPIO connected to STDBYN pin;
> +- rstn-gpios	  : GPIO connected to RSTN pin;

Both GPIOs above have names suggesting that they are active low. I wonder 
how the GPIO flags cell is interpreted here, namely the polarity bit.

Otherwise the binding looks good.

Best regards,
Tomasz

