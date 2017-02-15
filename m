Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33224 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBOWIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 17:08:25 -0500
Date: Wed, 15 Feb 2017 16:08:22 -0600
From: Rob Herring <robh@kernel.org>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 03/10] media: dt-bindings: vpif: extend the example with
 an output port
Message-ID: <20170215220822.nsws6kzrd6ihvmqt@rob-hp-laptop>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
 <1486485683-11427-4-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486485683-11427-4-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 07, 2017 at 05:41:16PM +0100, Bartosz Golaszewski wrote:
> This makes the example more or less correspond with the da850-evm
> hardware setup.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  .../devicetree/bindings/media/ti,da850-vpif.txt    | 35 ++++++++++++++++++----
>  1 file changed, 29 insertions(+), 6 deletions(-)

Spoke too soon...

> 
> diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
> index 9c7510b..543f6f3 100644
> --- a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
> +++ b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
> @@ -28,19 +28,27 @@ I2C-connected TVP5147 decoder:
>  		reg = <0x217000 0x1000>;
>  		interrupts = <92>;
>  
> -		port {
> -			vpif_ch0: endpoint@0 {
> +		port@0 {
> +			vpif_input_ch0: endpoint@0 {
>  				reg = <0>;
>  				bus-width = <8>;
> -				remote-endpoint = <&composite>;
> +				remote-endpoint = <&composite_in>;
>  			};
>  
> -			vpif_ch1: endpoint@1 {
> +			vpif_input_ch1: endpoint@1 {
>  				reg = <1>;
>  				bus-width = <8>;
>  				data-shift = <8>;
>  			};
>  		};
> +
> +		port@1 {

The binding doc says nothing about supporting a 2nd port. 


> +			vpif_output_ch0: endpoint@0 {
> +				reg = <0>;

Don't need reg here.

> +				bus-width = <8>;
> +				remote-endpoint = <&composite_out>;
> +			};
> +		};
>  	};
