Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:32943 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGN7a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 09:59:30 -0400
Date: Fri, 7 Jul 2017 08:59:28 -0500
From: Rob Herring <robh@kernel.org>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [PATCH 4/4] [media] rc: pwm-ir-tx: add new driver
Message-ID: <20170707135928.6cs6vx7z6lj3birp@rob-hp-laptop>
References: <cover.1498992850.git.sean@mess.org>
 <88fa0219db3388fad7bcc7b20cf30dd41e763aee.1498992850.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88fa0219db3388fad7bcc7b20cf30dd41e763aee.1498992850.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 02, 2017 at 12:06:13PM +0100, Sean Young wrote:
> This is new driver which uses pwm, so it is more power-efficient
> than the bit banging gpio-ir-tx driver.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  .../devicetree/bindings/leds/irled/pwm-ir-tx.txt   |  13 ++

Please make this a separate patch.

>  drivers/media/rc/Kconfig                           |  12 ++
>  drivers/media/rc/Makefile                          |   1 +
>  drivers/media/rc/pwm-ir-tx.c                       | 165 +++++++++++++++++++++
>  4 files changed, 191 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
>  create mode 100644 drivers/media/rc/pwm-ir-tx.c
> 
> diff --git a/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
> new file mode 100644
> index 0000000..6887a71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
> @@ -0,0 +1,13 @@
> +Device tree bindings for IR LED connected through pwm pin which is used as
> +IR transmitter.
> +
> +Required properties:
> +- compatible: should be "pwm-ir-tx".
> +- pwms : PWM property to point to the PWM device (phandle)/port (id) and to
> +  specify the period time to be used: <&phandle id period_ns>;
> +
> +Example:
> +	irled {
> +		compatible = "pwm-ir-tx";
> +		pwms = <&pwm0 0 10000000>;
> +	};
