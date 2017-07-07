Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33789 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdGGN6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 09:58:20 -0400
Date: Fri, 7 Jul 2017 08:58:16 -0500
From: Rob Herring <robh@kernel.org>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/4] [media] rc: gpio-ir-tx: add new driver
Message-ID: <20170707135816.5z6jzseqzqfwf3kn@rob-hp-laptop>
References: <cover.1498992850.git.sean@mess.org>
 <616e336df6badc96ced14d14956ed7c080b39781.1498992850.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616e336df6badc96ced14d14956ed7c080b39781.1498992850.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 02, 2017 at 12:06:11PM +0100, Sean Young wrote:
> This is a simple bit-banging GPIO IR TX driver.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  .../devicetree/bindings/leds/irled/gpio-ir-tx.txt  |  11 ++

Please make this a separate patch.

>  drivers/media/rc/Kconfig                           |  11 ++
>  drivers/media/rc/Makefile                          |   1 +
>  drivers/media/rc/gpio-ir-tx.c                      | 189 +++++++++++++++++++++
>  4 files changed, 212 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
>  create mode 100644 drivers/media/rc/gpio-ir-tx.c
> 
> diff --git a/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> new file mode 100644
> index 0000000..bf4d4fb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> @@ -0,0 +1,11 @@
> +Device tree bindings for IR LED connected through gpio pin which is used as
> +IR transmitter.
> +
> +Required properties:
> +	- compatible: should be "gpio-ir-tx".

gpios property?

> +
> +Example:
> +	irled@0 {
> +		compatible = "gpio-ir-tx";
> +		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
> +	};
