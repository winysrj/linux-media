Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51305 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751107AbeAPJuK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 04:50:10 -0500
Subject: Re: [PATCH v5 4/9] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-5-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f8f597b6-c58f-3457-c524-2f02715d6473@xs4all.nl>
Date: Tue, 16 Jan 2018 10:50:05 +0100
MIME-Version: 1.0
In-Reply-To: <1515765849-10345-5-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> Add Capture Engine Unit (CEU) node to device tree.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

        Hans

> ---
>  arch/arm/boot/dts/r7s72100.dtsi | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
> index ab9645a..5fe62f9 100644
> --- a/arch/arm/boot/dts/r7s72100.dtsi
> +++ b/arch/arm/boot/dts/r7s72100.dtsi
> @@ -135,9 +135,9 @@
>  			#clock-cells = <1>;
>  			compatible = "renesas,r7s72100-mstp-clocks", "renesas,cpg-mstp-clocks";
>  			reg = <0xfcfe042c 4>;
> -			clocks = <&p0_clk>;
> -			clock-indices = <R7S72100_CLK_RTC>;
> -			clock-output-names = "rtc";
> +			clocks = <&b_clk>, <&p0_clk>;
> +			clock-indices = <R7S72100_CLK_CEU R7S72100_CLK_RTC>;
> +			clock-output-names = "ceu", "rtc";
>  		};
>  
>  		mstp7_clks: mstp7_clks@fcfe0430 {
> @@ -667,4 +667,13 @@
>  		power-domains = <&cpg_clocks>;
>  		status = "disabled";
>  	};
> +
> +	ceu: ceu@e8210000 {
> +		reg = <0xe8210000 0x3000>;
> +		compatible = "renesas,r7s72100-ceu";
> +		interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp6_clks R7S72100_CLK_CEU>;
> +		power-domains = <&cpg_clocks>;
> +		status = "disabled";
> +	};
>  };
> 
