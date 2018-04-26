Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36624 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeDZGMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:12:53 -0400
Date: Thu, 26 Apr 2018 08:11:30 +0200
From: Simon Horman <horms@verge.net.au>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: geert@linux-m68k.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: r8a7740: Enable CEU0
Message-ID: <20180426061124.hvgl3ijf6ulrdkmn@verge.net.au>
References: <1524654920-18749-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654920-18749-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524654920-18749-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Jacopo,

I'm very pleased to see this series.

On Wed, Apr 25, 2018 at 01:15:20PM +0200, Jacopo Mondi wrote:
> Enable CEU0 peripheral for Renesas R-Mobile A1 R8A7740.

Given 'status = "disabled"' below I think you
are describing but not enabling CEU0. Also in the subject.

Should we also describe CEU1?

> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  arch/arm/boot/dts/r8a7740.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> index afd3bc5..05ec41e 100644
> --- a/arch/arm/boot/dts/r8a7740.dtsi
> +++ b/arch/arm/boot/dts/r8a7740.dtsi
> @@ -67,6 +67,16 @@
>  		power-domains = <&pd_d4>;
>  	};
>  
> +	ceu0: ceu@fe910000 {
> +		reg = <0xfe910000 0x100>;

Should the size of the range be 0x3000 ?
That would seem to match my reading of table 32.3
and also be consistent with r7s72100.dtsi.

> +		compatible = "renesas,r8a7740-ceu";
> +		interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp1_clks R8A7740_CLK_CEU20>;
> +		clock-names = "ceu20";
> +		power-domains = <&pd_a4mp>;

My reading of table 1.7 is that the power domain should be A4R (&pd_a4r).

> +		status = "disabled";
> +	};
> +
>  	cmt1: timer@e6138000 {
>  		compatible = "renesas,cmt-48-r8a7740", "renesas,cmt-48";
>  		reg = <0xe6138000 0x170>;
> -- 
> 2.7.4
> 
