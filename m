Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37738 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752095AbdHJIDl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 04:03:41 -0400
Subject: Re: [PATCH 1/3] dt-bindings: document the CEC GPIO bindings
To: linux-media@vger.kernel.org
References: <20170802084242.14947-1-hverkuil@xs4all.nl>
 <20170802084242.14947-2-hverkuil@xs4all.nl>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <64803004-6bea-44db-a651-cc21806250b5@xs4all.nl>
Date: Thu, 10 Aug 2017 10:03:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170802084242.14947-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/17 10:42, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the bindings for the cec-gpio module for hardware where the
> CEC pin is connected to a GPIO pin.

ping?

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/devicetree/bindings/media/cec-gpio.txt | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
> new file mode 100644
> index 000000000000..58fa56080cda
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
> @@ -0,0 +1,18 @@
> +* HDMI CEC GPIO driver
> +
> +The HDMI CEC GPIO module supports CEC implementations where the CEC pin
> +is hooked up to a pull-up GPIO pin.
> +
> +The CEC GPIO
> +
> +Required properties:
> +  - compatible: value must be "cec-gpio"
> +  - gpio: gpio that the CEC line is connected to
> +
> +Example for the Raspberry Pi 3 where the CEC line is connected to
> +pin 7 aka BCM4 aka GPCLK0 on the GPIO pin header:
> +
> +cec-gpio {
> +       compatible = "cec-gpio";
> +       gpio = <&gpio 4 GPIO_ACTIVE_HIGH>;
> +};
> 
