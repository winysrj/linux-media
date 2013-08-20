Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:38939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3HTUss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 16:48:48 -0400
Message-ID: <5213D62C.6020205@wwwdotorg.org>
Date: Tue, 20 Aug 2013 14:48:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6] s5k5baf: add camera sensor driver
References: <1377014619-5349-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1377014619-5349-1-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/2013 10:03 AM, Andrzej Hajda wrote:
> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> with embedded SoC ISP.
> The driver exposes the sensor as two V4L2 subdevices:
> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>   no controls.
> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>   pre/post ISP cropping, downscaling via selection API, controls.

> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt

> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> +--------------------------------------------------------------------
> +
> +Required properties:
> +
> +- compatible	  : "samsung,s5k5baf";
> +- reg		  : I2C slave address of the sensor;
> +- vdda-supply	  : analog power supply 2.8V (2.6V to 3.0V);
> +- vddreg-supply	  : regulator input power supply 1.8V (1.7V to 1.9V)
> +		    or 2.8V (2.6V to 3.0);
> +- vddio-supply	  : I/O power supply 1.8V (1.65V to 1.95V)
> +		    or 2.8V (2.5V to 3.1V);
> +- stbyn-gpios	  : GPIO connected to STDBYN pin;
> +- rstn-gpios	  : GPIO connected to RSTN pin;
> +- clocks	  : the sensor's master clock specifier (from the common
> +		    clock bindings);
> +- clock-names	  : must be "mclk";

That all looks sane.

> +Optional properties:
> +
> +- clock-frequency : master clock frequency in Hz; if this property is
> +		    not specified default 24 MHz value will be used.

I /think/ the explanation you gave Mark on this property makes sense.
However, it's not clear from the description what this does; in many
other cases a clock-frequency describes a fixed/actual input clock rate
to a device, rather than a frequency which the device believes it should
operate at, and hence the driver should request. Perhaps the following
would describe this:

- clock-frequency : The frequency at which the "mclk" clock should be
		configured to operate, in Hz. If this property is not
		specified default 24 MHz value will be used.

To me, this more strongly implies that the user of the node should
configure the clock, rather than the property reporting the rate at
which the clock is already configured to operate.

I think the rest of the binding doc (below this point) seems reasonable too.
