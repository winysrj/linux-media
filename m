Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40608 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750718AbeARWX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 17:23:57 -0500
Date: Fri, 19 Jan 2018 00:23:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: corbet@lwn.net, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] media: dt-bindings: Add OF properties to ov7670
Message-ID: <20180118222354.wk74rl4x4ay4gnzc@valkosipuli.retiisi.org.uk>
References: <1515779808-21420-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515779808-21420-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515779808-21420-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 12, 2018 at 06:56:47PM +0100, Jacopo Mondi wrote:
> Describe newly introduced OF properties for ov7670 image sensor.
> The driver supports two standard properties to configure synchronism
> signals polarities and one custom property already supported as
> platform data options by the driver to suppress pixel clock during
> horizontal blanking.
> 
> Re-phrase child nodes description while at there.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov7670.txt | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> index 826b656..7c89ea5 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> @@ -9,14 +9,23 @@ Required Properties:
>  - clocks: reference to the xclk input clock.
>  - clock-names: should be "xclk".
>  
> +Required Endpoint Properties:
> +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> +  Default is active high.
> +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> +  Default is active high.

If the properties are required, you'll have no default value for them.

Other than that, looks good to me.

> +
>  Optional Properties:
>  - reset-gpios: reference to the GPIO connected to the resetb pin, if any.
>    Active is low.
>  - powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
>    Active is high.
> +- ov7670,pclk-hb-disable: a boolean property to suppress pixel clock output
> +  signal during horizontal blankings.
>  
> -The device node must contain one 'port' child node for its digital output
> -video port, in accordance with the video interface bindings defined in
> +The device node must contain one 'port' child node with one 'endpoint' child
> +sub-node for its digital output video port, in accordance with the video
> +interface bindings defined in:
>  Documentation/devicetree/bindings/media/video-interfaces.txt.
>  
>  Example:
> @@ -34,8 +43,13 @@ Example:
>  			assigned-clocks = <&pck0>;
>  			assigned-clock-rates = <25000000>;
>  
> +			ov7670,pclk-hb-disable;
> +
>  			port {
>  				ov7670_0: endpoint {
> +					hsync-active = <0>;
> +					vsync-active = <0>;
> +
>  					remote-endpoint = <&isi_0>;
>  				};
>  			};
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
