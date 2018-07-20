Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:51224 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733128AbeGTSy4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 14:54:56 -0400
Date: Fri, 20 Jul 2018 12:05:30 -0600
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/5] cec-gpio.txt: add v5-gpios for testing the 5V line
Message-ID: <20180720180530.GA21569@rob-hp-laptop>
References: <20180717132909.92158-1-hverkuil@xs4all.nl>
 <20180717132909.92158-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717132909.92158-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 17, 2018 at 03:29:05PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> In order to debug the HDMI 5V line we need to add a new v5-gpios
> property.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/cec-gpio.txt      | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
> index 12fcd55ed153..1d53ce89da74 100644
> --- a/Documentation/devicetree/bindings/media/cec-gpio.txt
> +++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
> @@ -4,8 +4,8 @@ The HDMI CEC GPIO module supports CEC implementations where the CEC line
>  is hooked up to a pull-up GPIO line and - optionally - the HPD line is
>  hooked up to another GPIO line.
>  
> -Please note: the maximum voltage for the CEC line is 3.63V, for the HPD
> -line it is 5.3V. So you may need some sort of level conversion circuitry
> +Please note: the maximum voltage for the CEC line is 3.63V, for the HPD and
> +5V lines it is 5.3V. So you may need some sort of level conversion circuitry
>  when connecting them to a GPIO line.
>  
>  Required properties:
> @@ -22,15 +22,18 @@ If the CEC line is not associated with an HDMI receiver/transmitter, then
>  the following property is optional:
>  
>    - hpd-gpios: gpio that the HPD line is connected to.
> +  - v5-gpios: gpio that the 5V line is connected to.

This is a bit strange without the context of debugging. So can you 
mention that here.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

>  
>  Example for the Raspberry Pi 3 where the CEC line is connected to
> -pin 26 aka BCM7 aka CE1 on the GPIO pin header and the HPD line is
> -connected to pin 11 aka BCM17 (some level shifter is needed for this!):
> +pin 26 aka BCM7 aka CE1 on the GPIO pin header, the HPD line is
> +connected to pin 11 aka BCM17 and the 5V line is connected to pin
> +15 aka BCM22 (some level shifter is needed for the HPD and 5V lines!):
>  
>  #include <dt-bindings/gpio/gpio.h>
>  
>  cec-gpio {
> -       compatible = "cec-gpio";
> -       cec-gpios = <&gpio 7 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
> -       hpd-gpios = <&gpio 17 GPIO_ACTIVE_HIGH>;
> +	compatible = "cec-gpio";
> +	cec-gpios = <&gpio 7 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
> +	hpd-gpios = <&gpio 17 GPIO_ACTIVE_HIGH>;
> +	v5-gpios = <&gpio 22 GPIO_ACTIVE_HIGH>;
>  };
> -- 
> 2.18.0
> 
