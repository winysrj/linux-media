Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52148 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751444AbdHPHUn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 03:20:43 -0400
Subject: Re: [PATCHv2 1/3] dt-bindings: document the CEC GPIO bindings
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170810083359.36800-1-hverkuil@xs4all.nl>
 <20170810083359.36800-2-hverkuil@xs4all.nl>
Message-ID: <c24529d5-fd9e-444a-2bc7-71d54ca950f8@xs4all.nl>
Date: Wed, 16 Aug 2017 09:20:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170810083359.36800-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2017 10:33 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document the bindings for the cec-gpio module for hardware where the
> CEC pin is connected to a GPIO pin.

No need to review this, there will be a v3 that will add a second optional
HPD gpio.

Regards,

	Hans

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/devicetree/bindings/media/cec-gpio.txt | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/cec-gpio.txt b/Documentation/devicetree/bindings/media/cec-gpio.txt
> new file mode 100644
> index 000000000000..e34a175468e2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/cec-gpio.txt
> @@ -0,0 +1,16 @@
> +* HDMI CEC GPIO-based hardware
> +
> +Use these bindings for HDMI CEC hardware where the CEC pin is hooked up
> +to a pull-up GPIO pin.
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
