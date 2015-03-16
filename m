Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43617 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbCPAMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:12:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] arm: dts: omap3: Add DT entries for OMAP 3
Date: Mon, 16 Mar 2015 02:12:29 +0200
Message-ID: <2419948.9iuzk7Opkd@avalon>
In-Reply-To: <1426464080-29119-4-git-send-email-sakari.ailus@iki.fi>
References: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi> <1426464080-29119-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 16 March 2015 02:01:19 Sakari Ailus wrote:
> The resources the ISP needs are slightly different on 3[45]xx and 3[67]xx.
> Especially the phy-type property is different.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/boot/dts/omap34xx.dtsi |   17 +++++++++++++++++
>  arch/arm/boot/dts/omap36xx.dtsi |   17 +++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap34xx.dtsi
> b/arch/arm/boot/dts/omap34xx.dtsi index 3819c1e..7bc8c0f 100644
> --- a/arch/arm/boot/dts/omap34xx.dtsi
> +++ b/arch/arm/boot/dts/omap34xx.dtsi
> @@ -8,6 +8,8 @@
>   * kind, whether express or implied.
>   */
> 
> +#include <dt-bindings/media/omap3-isp.h>
> +
>  #include "omap3.dtsi"
> 
>  / {
> @@ -37,6 +39,21 @@
>  			pinctrl-single,register-width = <16>;
>  			pinctrl-single,function-mask = <0xff1f>;
>  		};
> +
> +		isp: isp@480bc000 {
> +			compatible = "ti,omap3-isp";
> +			reg = <0x480bc000 0x12fc
> +			       0x480bd800 0x017c>;
> +			interrupts = <24>;
> +			iommus = <&mmu_isp>;
> +			syscon = <&omap3_scm_general 0xdc>;
> +			ti,phy-type = <OMAP3ISP_PHY_TYPE_COMPLEX_IO>;
> +			#clock-cells = <1>;
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +			};
> +		};
>  	};
>  };
> 
> diff --git a/arch/arm/boot/dts/omap36xx.dtsi
> b/arch/arm/boot/dts/omap36xx.dtsi index 541704a..3502fe0 100644
> --- a/arch/arm/boot/dts/omap36xx.dtsi
> +++ b/arch/arm/boot/dts/omap36xx.dtsi
> @@ -8,6 +8,8 @@
>   * kind, whether express or implied.
>   */
> 
> +#include <dt-bindings/media/omap3-isp.h>
> +
>  #include "omap3.dtsi"
> 
>  / {
> @@ -69,6 +71,21 @@
>  			pinctrl-single,register-width = <16>;
>  			pinctrl-single,function-mask = <0xff1f>;
>  		};
> +
> +		isp: isp@480bc000 {
> +			compatible = "ti,omap3-isp";
> +			reg = <0x480bc000 0x12fc
> +			       0x480bd800 0x0600>;
> +			interrupts = <24>;
> +			iommus = <&mmu_isp>;
> +			syscon = <&omap3_scm_general 0x2f0>;
> +			ti,phy-type = <OMAP3ISP_PHY_TYPE_CSIPHY>;
> +			#clock-cells = <1>;
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +			};
> +		};
>  	};
>  };

-- 
Regards,

Laurent Pinchart

