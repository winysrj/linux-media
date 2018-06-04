Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:51014 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbeFDJx2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 05:53:28 -0400
Date: Mon, 4 Jun 2018 11:53:09 +0200
From: Simon Horman <horms@verge.net.au>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180604095308.pnlmd4aalxceuozq@verge.net.au>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526923663-8179-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526923663-8179-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2018 at 07:27:43PM +0200, Jacopo Mondi wrote:

> The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> driver and only confuse users. Remove them in all Gen2 SoC that use
> them.

I think that the rational for removing properties (or not) is their
presence in the bindings as DT should describe the hardware and not the
current state of the driver implementation.

I see that 'bus-width' may be removed from the binding, as per discussion
in a different sub-thread. I'd like that discussion to reach a conclusion
before considering that part of this patch any further.

And I'd appreciate Niklas's feedback on the 'pclk-sample' portion.

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  arch/arm/boot/dts/r8a7790-lager.dts   | 3 ---
>  arch/arm/boot/dts/r8a7791-koelsch.dts | 3 ---
>  arch/arm/boot/dts/r8a7791-porter.dts  | 1 -
>  arch/arm/boot/dts/r8a7793-gose.dts    | 3 ---
>  arch/arm/boot/dts/r8a7794-alt.dts     | 1 -
>  arch/arm/boot/dts/r8a7794-silk.dts    | 1 -
>  6 files changed, 12 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> index 092610e..9cdabfcf 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -885,10 +885,8 @@
>  	port {
>  		vin0ep2: endpoint {
>  			remote-endpoint = <&adv7612_out>;
> -			bus-width = <24>;
>  			hsync-active = <0>;
>  			vsync-active = <0>;
> -			pclk-sample = <1>;
>  			data-active = <1>;
>  		};
>  	};
> @@ -904,7 +902,6 @@
>  	port {
>  		vin1ep0: endpoint {
>  			remote-endpoint = <&adv7180>;
> -			bus-width = <8>;
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
> index 8ab793d..033c9e3 100644
> --- a/arch/arm/boot/dts/r8a7791-koelsch.dts
> +++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
> @@ -857,10 +857,8 @@
>  	port {
>  		vin0ep2: endpoint {
>  			remote-endpoint = <&adv7612_out>;
> -			bus-width = <24>;
>  			hsync-active = <0>;
>  			vsync-active = <0>;
> -			pclk-sample = <1>;
>  			data-active = <1>;
>  		};
>  	};
> @@ -875,7 +873,6 @@
>  	port {
>  		vin1ep: endpoint {
>  			remote-endpoint = <&adv7180>;
> -			bus-width = <8>;
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
> index a01101b..c16e870 100644
> --- a/arch/arm/boot/dts/r8a7791-porter.dts
> +++ b/arch/arm/boot/dts/r8a7791-porter.dts
> @@ -388,7 +388,6 @@
>  	port {
>  		vin0ep: endpoint {
>  			remote-endpoint = <&adv7180>;
> -			bus-width = <8>;
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
> index aa209f6..60aaddb 100644
> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> @@ -765,10 +765,8 @@
>  	port {
>  		vin0ep2: endpoint {
>  			remote-endpoint = <&adv7612_out>;
> -			bus-width = <24>;
>  			hsync-active = <0>;
>  			vsync-active = <0>;
> -			pclk-sample = <1>;
>  			data-active = <1>;
>  		};
>  	};
> @@ -784,7 +782,6 @@
>  	port {
>  		vin1ep: endpoint {
>  			remote-endpoint = <&adv7180_out>;
> -			bus-width = <8>;
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7794-alt.dts
> index e170275..8ed7a71 100644
> --- a/arch/arm/boot/dts/r8a7794-alt.dts
> +++ b/arch/arm/boot/dts/r8a7794-alt.dts
> @@ -388,7 +388,6 @@
>  	port {
>  		vin0ep: endpoint {
>  			remote-endpoint = <&adv7180>;
> -			bus-width = <8>;
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a7794-silk.dts
> index 7808aae..6adfcd6 100644
> --- a/arch/arm/boot/dts/r8a7794-silk.dts
> +++ b/arch/arm/boot/dts/r8a7794-silk.dts
> @@ -477,7 +477,6 @@
>  	port {
>  		vin0ep: endpoint {
>  			remote-endpoint = <&adv7180>;
> -			bus-width = <8>;
>  		};
>  	};
>  };
> -- 
> 2.7.4
> 
