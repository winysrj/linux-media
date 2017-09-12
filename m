Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35877 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdILOnK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 10:43:10 -0400
Date: Tue, 12 Sep 2017 09:43:08 -0500
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 3/5] dt-bindings: document the CEC GPIO bindings
Message-ID: <20170912144308.j53eclicbhay5dsz@rob-hp-laptop>
References: <20170831110156.11018-1-hverkuil@xs4all.nl>
 <20170831110156.11018-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831110156.11018-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 31, 2017 at 01:01:54PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the bindings for the cec-gpio module for hardware where the
> CEC line and optionally the HPD line are connected to GPIO lines.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/cec-gpio.txt         | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
> new file mode 100644
> index 000000000000..db20a7452dbd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
> @@ -0,0 +1,22 @@
> +* HDMI CEC GPIO driver
> +
> +The HDMI CEC GPIO module supports CEC implementations where the CEC line
> +is hooked up to a pull-up GPIO line and - optionally - the HPD line is
> +hooked up to another GPIO line.
> +
> +Required properties:
> +  - compatible: value must be "cec-gpio"
> +  - cec-gpio: gpio that the CEC line is connected to

cec-gpios

> +
> +Optional property:
> +  - hpd-gpio: gpio that the HPD line is connected to

hpd-gpios

However, HPD is already part of the HDMI connector binding. Having it in 
2 places would be wrong.

I think we should have either:

hdmi-connector {
	compatible = 'hdmi-connector-a";
	hpd-gpios = <...>;
	cec-gpios = <...>;
	ports {
		// port to HDMI controller
	...
	};
};

Or:

hdmi-connector {
        compatible = 'hdmi-connector-a";
        hpd-gpios = <...>;
        cec = <&cec>;
        ... 
};

cec: cec-gpio {
	compatible = "cec-gpio";
	cec-gpios = <...>;
};

My preference is probably the former. The latter just helps create a 
device to bind to a driver, but DT is not the only way to create 
devices. Then again, if you have a phandle to real CEC controllers in 
the HDMI connector node, it may make sense to do the same thing with 
cec-gpio. 

> +
> +Example for the Raspberry Pi 3 where the CEC line is connected to
> +pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
> +connected to pin 11 aka BCM17:
> +
> +cec-gpio@7 {

unit address is not valid. Build your dts's with W=2.

> +       compatible = "cec-gpio";
> +       cec-gpio = <&gpio 7 GPIO_OPEN_DRAIN>;
> +       hpd-gpio = <&gpio 17 GPIO_ACTIVE_HIGH>;
> +};
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
