Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34163 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZPV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 11:21:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree based instantiation
Date: Thu, 26 Jul 2012 17:21:36 +0200
Message-ID: <1393020.I6XBuRyBXi@avalon>
In-Reply-To: <1337975573-27117-9-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-9-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 25 May 2012 21:52:48 Sylwester Nawrocki wrote:
> The driver initializes all board related properties except the s_power()
> callback to board code. The platforms that require this callback are not
> supported by this driver yet for CONFIG_OF=y.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../bindings/camera/samsung-s5k6aafx.txt           |   57 +++++++++
>  drivers/media/video/s5k6aa.c                       |  129 ++++++++++++-----
>  2 files changed, 146 insertions(+), 40 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> 
> diff --git a/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
> b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt new file
> mode 100644
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
> +- video-itu-601-bus : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
> +- vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
> +- vdda-supply : analog power voltage supply 2.8V (2.6V to 3.0V);
> +- vdd_reg-supply : regulator input power voltage supply 1.8V (1.7V to 1.9V)
> +		   or 2.8V (2.6V to 3.0);
> +- vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
> +		 or 2.8V (2.5V to 3.1V);
> +
> +Optional properties:
> +
> +- clock-frequency : the IP's main (system bus) clock frequency in Hz, the
> default 

Is that the input clock frequency ? Can't it vary ? Instead of accessing the 
sensor clock frequency from the FIMC driver you should reference a clock in 
the sensor DT node. That obviously requires generic clock support, which might 
not be available for your platform yet (that's one of the reasons the OMAP3 
ISP driver doesn't support DT yet).

> +		    value when this property is not specified is 24 MHz;
> +- data-lanes : number of physical lanes used (default 2 if not specified);
> +- gpio-stby : specifies the S5K6AA_STBY GPIO
> +- gpio-rst : specifies the S5K6AA_RST GPIO
> +- samsung,s5k6aa-inv-stby : set inverted S5K6AA_STBY GPIO level;
> +- samsung,s5k6aa-inv-rst : set inverted S5K6AA_RST GPIO level;
> +- samsung,s5k6aa-hflip : set the default horizontal image flipping;
> +- samsung,s5k6aa-vflip : set the default vertical image flipping;
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

-- 
Regards,

Laurent Pinchart

