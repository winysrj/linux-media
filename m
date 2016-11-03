Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13567 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754031AbcKCIdB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 04:33:01 -0400
Subject: Re: [PATCH v3 5/6] Documentation: bindings: add documentation for
 ir-spi device driver
To: Andi Shyti <andi.shyti@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <70f4426b-e2e6-1fb7-187a-65ed4bce0668@samsung.com>
Date: Thu, 03 Nov 2016 09:32:54 +0100
MIME-version: 1.0
In-reply-to: <20161102104010.26959-6-andi.shyti@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <20161102104010.26959-1-andi.shyti@samsung.com>
 <CGME20161102104149epcas5p4da68197e232df7ad922f2f9cb0714a43@epcas5p4.samsung.com>
 <20161102104010.26959-6-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andi,

Only DT bindings of LED class drivers should be placed in
Documentation/devicetree/bindings/leds. Please move it to the
media bindings.

Thanks,
Jacek Anaszewski

On 11/02/2016 11:40 AM, Andi Shyti wrote:
> Document the ir-spi driver's binding which is a IR led driven
> through the SPI line.
>
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  .../devicetree/bindings/leds/spi-ir-led.txt        | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/spi-ir-led.txt
>
> diff --git a/Documentation/devicetree/bindings/leds/spi-ir-led.txt b/Documentation/devicetree/bindings/leds/spi-ir-led.txt
> new file mode 100644
> index 0000000..896b699
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/spi-ir-led.txt
> @@ -0,0 +1,29 @@
> +Device tree bindings for IR LED connected through SPI bus which is used as
> +remote controller.
> +
> +The IR LED switch is connected to the MOSI line of the SPI device and the data
> +are delivered thourgh that.
> +
> +Required properties:
> +	- compatible: should be "ir-spi-led".
> +
> +Optional properties:
> +	- duty-cycle: 8 bit balue that represents the percentage of one period
> +	  in which the signal is active.  It can be 50, 60, 70, 75, 80 or 90.
> +	- led-active-low: boolean value that specifies whether the output is
> +	  negated with a NOT gate.
> +	- power-supply: specifies the power source. It can either be a regulator
> +	  or a gpio which enables a regulator, i.e. a regulator-fixed as
> +	  described in
> +	  Documentation/devicetree/bindings/regulator/fixed-regulator.txt
> +
> +Example:
> +
> +	irled@0 {
> +		compatible = "ir-spi-led";
> +		reg = <0x0>;
> +		spi-max-frequency = <5000000>;
> +		power-supply = <&vdd_led>;
> +		led-active-low;
> +		duty-cycle = /bits/ 8 <60>;
> +	};
>

