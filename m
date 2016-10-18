Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59717 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932870AbcJRPWS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:22:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        geert@linux-m68k.org, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 1/3] ARM: dts: r8a7793: Enable VIN0-VIN2
Date: Tue, 18 Oct 2016 18:22:14 +0300
Message-ID: <11129344.scr8PYudqX@avalon>
In-Reply-To: <1476802943-5189-2-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1476802943-5189-2-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Tuesday 18 Oct 2016 17:02:21 Ulrich Hecht wrote:
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/boot/dts/r8a7793.dtsi | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7793.dtsi b/arch/arm/boot/dts/r8a7793.dtsi
> index a7d11b9..629d3d6 100644
> --- a/arch/arm/boot/dts/r8a7793.dtsi
> +++ b/arch/arm/boot/dts/r8a7793.dtsi
> @@ -852,6 +852,33 @@
>  		status = "disabled";
>  	};
> 
> +	vin0: video@e6ef0000 {
> +		compatible = "renesas,vin-r8a7793", "renesas,rcar-gen2-vin";
> +		reg = <0 0xe6ef0000 0 0x1000>;
> +		interrupts = <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp8_clks R8A7793_CLK_VIN0>;
> +		power-domains = <&sysc R8A7793_PD_ALWAYS_ON>;
> +		status = "disabled";
> +	};
> +
> +	vin1: video@e6ef1000 {
> +		compatible = "renesas,vin-r8a7793", "renesas,rcar-gen2-vin";
> +		reg = <0 0xe6ef1000 0 0x1000>;
> +		interrupts = <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp8_clks R8A7793_CLK_VIN1>;
> +		power-domains = <&sysc R8A7793_PD_ALWAYS_ON>;
> +		status = "disabled";
> +	};
> +
> +	vin2: video@e6ef2000 {
> +		compatible = "renesas,vin-r8a7793", "renesas,rcar-gen2-vin";
> +		reg = <0 0xe6ef2000 0 0x1000>;
> +		interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp8_clks R8A7793_CLK_VIN2>;
> +		power-domains = <&sysc R8A7793_PD_ALWAYS_ON>;
> +		status = "disabled";
> +	};
> +
>  	qspi: spi@e6b10000 {
>  		compatible = "renesas,qspi-r8a7793", "renesas,qspi";
>  		reg = <0 0xe6b10000 0 0x2c>;

-- 
Regards,

Laurent Pinchart

