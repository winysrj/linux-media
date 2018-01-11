Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35514 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932474AbeAKLWW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 06:22:22 -0500
Date: Thu, 11 Jan 2018 13:22:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: corbet@lwn.net, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: dt-bindings: Add OF properties to ov7670
Message-ID: <20180111112219.eem3behgpxjl53kr@valkosipuli.retiisi.org.uk>
References: <1515059553-10219-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515059553-10219-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515059553-10219-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Jan 04, 2018 at 10:52:33AM +0100, Jacopo Mondi wrote:
> Describe newly introduced OF properties for ov7670 image sensor.
> The driver supports two standard properties to configure synchronism
> signals polarities and two custom properties already supported as
> platform data options by the driver.
> ---
>  Documentation/devicetree/bindings/media/i2c/ov7670.txt | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> index 826b656..57ded18 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> @@ -9,11 +9,22 @@ Required Properties:
>  - clocks: reference to the xclk input clock.
>  - clock-names: should be "xclk".
>  
> +The following properties, as defined by video interfaces OF bindings
> +"Documentation/devicetree/bindings/media/video-interfaces.txt" are supported:
> +
> +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.

Shouldn't these be mandatory?

If you make them optional, the V4L2 fwnode functions will give you Bt.656
as nothing tells that the signals are there --- which is probably not what
you want. The sensor also supports that, though, if you wish to add support
for it later on.

> +
> +Default is high active state for both vsync and hsync signals.
> +
>  Optional Properties:
>  - reset-gpios: reference to the GPIO connected to the resetb pin, if any.
>    Active is low.
>  - powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
>    Active is high.
> +- ov7670,pll-bypass: set to 1 to bypass PLL for pixel clock generation.
> +- ov7670,pclk-hb-disable: set to 1 to suppress pixel clock output signal during
> +  horizontal blankings.
>  
>  The device node must contain one 'port' child node for its digital output
>  video port, in accordance with the video interface bindings defined in
> @@ -34,6 +45,9 @@ Example:
>  			assigned-clocks = <&pck0>;
>  			assigned-clock-rates = <25000000>;
>  
> +			vsync-active = <0>;
> +			ov7670,pclk-hb-disable = <1>;
> +
>  			port {
>  				ov7670_0: endpoint {
>  					remote-endpoint = <&isi_0>;
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
