Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36674 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbeFDMX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:23:28 -0400
Received: by mail-lf0-f67.google.com with SMTP id u4-v6so24886865lff.3
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:23:27 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:23:25 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 8/8] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180604122325.GH19674@bigcity.dyn.berto.se>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-9-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527606359-19261-9-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-29 17:05:59 +0200, Jacopo Mondi wrote:
> The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> driver and only confuse users. Remove them in all Gen2 SoC that use
> them.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

The more I think about this the more I lean towards that this patch 
should be dropped. The properties accurately describes the hardware and 
I think there is value in that. That the driver currently don't parse or 
make use of them don't in my view reduce there value. Maybe you should 
break out this patch to a separate series?

> ---
> v3:
> - remove bus-width from dt-bindings example
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 -
>  arch/arm/boot/dts/r8a7790-lager.dts                  | 3 ---
>  arch/arm/boot/dts/r8a7791-koelsch.dts                | 3 ---
>  arch/arm/boot/dts/r8a7791-porter.dts                 | 1 -
>  arch/arm/boot/dts/r8a7793-gose.dts                   | 3 ---
>  arch/arm/boot/dts/r8a7794-alt.dts                    | 1 -
>  arch/arm/boot/dts/r8a7794-silk.dts                   | 1 -
>  7 files changed, 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 024c109..c6d7f60 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -128,7 +128,6 @@ Board setup example for Gen2 platforms (vin1 composite video input)
> 
>                  vin1ep0: endpoint {
>                          remote-endpoint = <&adv7180>;
> -                        bus-width = <8>;
>                  };
>          };
>  };
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

-- 
Regards,
Niklas Söderlund
