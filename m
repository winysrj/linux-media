Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35225 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753233AbdGJPFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:05:41 -0400
Date: Mon, 10 Jul 2017 10:05:38 -0500
From: Rob Herring <robh@kernel.org>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/6] [media] dt-bindings: gpio-ir-tx: add support for
 GPIO IR Transmitter
Message-ID: <20170710150538.ql26gswdf2obch6o@rob-hp-laptop>
References: <cover.1499419624.git.sean@mess.org>
 <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 07, 2017 at 10:52:03AM +0100, Sean Young wrote:
> Document the device tree bindings for the GPIO Bit Banging IR
> Transmitter.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> 
> diff --git a/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> new file mode 100644
> index 0000000..bc08d89
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> @@ -0,0 +1,11 @@
> +Device tree bindings for IR LED connected through gpio pin which is used as
> +remote controller transmitter.
> +
> +Required properties:
> +	- compatible: should be "gpio-ir-tx".

As I mentioned in the prior version, missing the "gpios" property.

> +
> +Example:
> +	irled@0 {
> +		compatible = "gpio-ir-tx";
> +		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
> +	};
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
