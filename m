Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:34059 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbdBMS2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 13:28:03 -0500
Received: by mail-ot0-f182.google.com with SMTP id f9so74920060otd.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 10:28:03 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/10] ARM: dts: da850-evm: fix whitespace errors
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-3-git-send-email-bgolaszewski@baylibre.com>
Date: Mon, 13 Feb 2017 10:28:00 -0800
In-Reply-To: <1486485683-11427-3-git-send-email-bgolaszewski@baylibre.com>
        (Bartosz Golaszewski's message of "Tue, 7 Feb 2017 17:41:15 +0100")
Message-ID: <m24lzyeyj3.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Acked-by: Kevin Hilman <khilman@baylibre.com>

> ---
>  arch/arm/boot/dts/da850-evm.dts | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index c970b6e..94938a3 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -301,14 +301,14 @@
>  	/* VPIF capture port */
>  	port {
>  		vpif_ch0: endpoint@0 {
> -			  reg = <0>;
> -			  bus-width = <8>;
> +			reg = <0>;
> +			bus-width = <8>;
>  		};
>  
>  		vpif_ch1: endpoint@1 {
> -			  reg = <1>;
> -			  bus-width = <8>;
> -			  data-shift = <8>;
> +			reg = <1>;
> +			bus-width = <8>;
> +			data-shift = <8>;
>  		};
>  	};
>  };

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> Extend the vpif node with an output port with a single channel.
>
> NOTE: this is still just hardware description - the actual driver
> is registered using pdata-quirks.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  arch/arm/boot/dts/da850-evm.dts | 14 +++++++++++---
>  arch/arm/boot/dts/da850.dtsi    |  8 +++++++-
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 94938a3..3d6dd66 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -299,16 +299,24 @@
>  	status = "okay";
>  
>  	/* VPIF capture port */
> -	port {
> -		vpif_ch0: endpoint@0 {
> +	port@0 {
> +		vpif_input_ch0: endpoint@0 {
>  			reg = <0>;
>  			bus-width = <8>;
>  		};
>  
> -		vpif_ch1: endpoint@1 {
> +		vpif_input_ch1: endpoint@1 {
>  			reg = <1>;
>  			bus-width = <8>;
>  			data-shift = <8>;
>  		};
>  	};
> +
> +	/* VPIF display port */
> +	port@1 {
> +		vpif_output_ch0: endpoint@0 {
> +			reg = <0>;
> +			bus-width = <8>;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 69ec5e7..768a58c 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -494,7 +494,13 @@
>  			status = "disabled";
>  
>  			/* VPIF capture port */
> -			port {
> +			port@0 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +			};
> +
> +			/* VPIF display port */
> +			port@1 {
>  				#address-cells = <1>;
>  				#size-cells = <0>;
>  			};

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> There's a stray tab in da850_vpif_legacy_init(). Remove it.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  arch/arm/mach-davinci/pdata-quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
> index a186513..94948c1 100644
> --- a/arch/arm/mach-davinci/pdata-quirks.c
> +++ b/arch/arm/mach-davinci/pdata-quirks.c
> @@ -111,7 +111,7 @@ static struct vpif_capture_config da850_vpif_capture_config = {
>  static void __init da850_vpif_legacy_init(void)
>  {
>  	int ret;
> -	
> +
>  	/* LCDK doesn't have the 2nd TVP514x on CH1 */
>  	if (of_machine_is_compatible("ti,da850-lcdk"))
>  		da850_vpif_capture_config.subdev_count = 1;
