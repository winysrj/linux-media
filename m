Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GPJmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 05:42:19 -0400
Date: Mon, 16 Jul 2012 11:42:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree
 based instantiation
In-Reply-To: <1337975573-27117-9-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1207161122390.12302@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
 <1337975573-27117-9-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 May 2012, Sylwester Nawrocki wrote:

> The driver initializes all board related properties except the s_power()
> callback to board code. The platforms that require this callback are not
> supported by this driver yet for CONFIG_OF=y.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../bindings/camera/samsung-s5k6aafx.txt           |   57 +++++++++
>  drivers/media/video/s5k6aa.c                       |  129 ++++++++++++++------
>  2 files changed, 146 insertions(+), 40 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> 
> diff --git a/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> new file mode 100644
> index 0000000..6685a9c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> @@ -0,0 +1,57 @@
> +Samsung S5K6AAFX camera sensor
> +------------------------------
> +
> +Required properties:
> +
> +- compatible : "samsung,s5k6aafx";
> +- reg : base address of the device on I2C bus;

You said you ended up putting your sensors outside of I2C busses, is this 
one of changes, that are present in your git-tree but not in this series?

> +- video-itu-601-bus : parallel bus with HSYNC and VSYNC - ITU-R BT.601;

If this is a boolean property, it cannot be required? Otherwise, as 
discussed in a different patch comment, this property might not be 
required, and if it is, I would use the same definition for both the 
camera interface and for sensors.

> +- vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
> +- vdda-supply : analog power voltage supply 2.8V (2.6V to 3.0V);
> +- vdd_reg-supply : regulator input power voltage supply 1.8V (1.7V to 1.9V)
> +		   or 2.8V (2.6V to 3.0);

I think, underscores in property names are generally frowned upon.

> +- vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
> +		 or 2.8V (2.5V to 3.1V);
> +
> +Optional properties:
> +
> +- clock-frequency : the IP's main (system bus) clock frequency in Hz, the default
> +		    value when this property is not specified is 24 MHz;
> +- data-lanes : number of physical lanes used (default 2 if not specified);

bus-width?

> +- gpio-stby : specifies the S5K6AA_STBY GPIO
> +- gpio-rst : specifies the S5K6AA_RST GPIO

>From Documentation/devicetree/bindings/gpio/gpio.txt:

<quote>
GPIO properties should be named "[<name>-]gpios".
</quote>

> +- samsung,s5k6aa-inv-stby : set inverted S5K6AA_STBY GPIO level;
> +- samsung,s5k6aa-inv-rst : set inverted S5K6AA_RST GPIO level;

Isn't this provided by GPIO flags as described in include/linux/of_gpio.h 
by using the OF_GPIO_ACTIVE_LOW bit?

> +- samsung,s5k6aa-hflip : set the default horizontal image flipping;
> +- samsung,s5k6aa-vflip : set the default vertical image flipping;

This is a board property, specifying how the sensor is wired and mounted 
on the casing, right? IIRC, libv4l has a database of these for USB 
cameras. So, maybe it belongs to the user-space for embedded systems too? 
Or at least this shouldn't be Samsung-specific?

> +
> +
> +Example:
> +
> +	gpl2: gpio-controller@0 {
> +	};
> +
> +	reg0: regulator@0 {
> +	};
> +
> +	reg1: regulator@1 {
> +	};
> +
> +	reg2: regulator@2 {
> +	};
> +
> +	reg3: regulator@3 {
> +	};
> +
> +	s5k6aafx@3c {
> +		compatible = "samsung,s5k6aafx";
> +		reg = <0x3c>;
> +		clock-frequency = <24000000>;
> +		gpio-rst = <&gpl2 0 2 0 3>;
> +		gpio-stby = <&gpl2 1 2 0 3>;
> +		video-itu-601-bus;
> +		vdd_core-supply = <&reg0>;
> +		vdda-supply = <&reg1>;
> +		vdd_reg-supply = <&reg2>;
> +		vddio-supply = <&reg3>;
> +	};

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
