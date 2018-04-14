Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42710 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbeDNKfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 06:35:54 -0400
Subject: Re: [PATCH] gpio: Add a reference to CEC on GPIO
To: Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Cc: linux-media@vger.kernel.org
References: <20180414094458.5700-1-linus.walleij@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cec332d3-847d-63e7-ace2-7c6525f9dfcf@xs4all.nl>
Date: Sat, 14 Apr 2018 03:35:47 -0700
MIME-Version: 1.0
In-Reply-To: <20180414094458.5700-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/14/2018 02:44 AM, Linus Walleij wrote:
> This adds a pointer to the CEC GPIO driver from the GPIO list of
> examples of drivers on top of GPIO.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  Documentation/driver-api/gpio/drivers-on-gpio.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/driver-api/gpio/drivers-on-gpio.rst b/Documentation/driver-api/gpio/drivers-on-gpio.rst
> index 7da0c1dd1f7a..f3a189320e11 100644
> --- a/Documentation/driver-api/gpio/drivers-on-gpio.rst
> +++ b/Documentation/driver-api/gpio/drivers-on-gpio.rst
> @@ -85,6 +85,10 @@ hardware descriptions such as device tree or ACPI:
>    any other serio bus to the system and makes it possible to connect drivers
>    for e.g. keyboards and other PS/2 protocol based devices.
>  
> +- cec-gpio: drivers/media/platform/cec-gpio/ is used to interact with a CEC
> +  Consumer Electronics Control bus using only GPIO. It is used to communicate
> +  with devices on the HDMI bus.
> +
>  Apart from this there are special GPIO drivers in subsystems like MMC/SD to
>  read card detect and write protect GPIO lines, and in the TTY serial subsystem
>  to emulate MCTRL (modem control) signals CTS/RTS by using two GPIO lines. The
> 
