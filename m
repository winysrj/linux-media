Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37068 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752412AbeAaIHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 03:07:47 -0500
Received: by mail-lf0-f68.google.com with SMTP id 63so19297429lfv.4
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 00:07:46 -0800 (PST)
Subject: Re: [PATCH v8 04/11] ARM: dts: r7s72100: Add Capture Engine Unit
 (CEU)
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1517306302-27957-1-git-send-email-jacopo+renesas@jmondi.org>
 <1517306302-27957-5-git-send-email-jacopo+renesas@jmondi.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <567f779c-591c-4798-a8d0-504d25c439de@cogentembedded.com>
Date: Wed, 31 Jan 2018 11:07:44 +0300
MIME-Version: 1.0
In-Reply-To: <1517306302-27957-5-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 1/30/2018 12:58 PM, Jacopo Mondi wrote:

> Add Capture Engine Unit (CEU) node to device tree.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   arch/arm/boot/dts/r7s72100.dtsi | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
> index ab9645a..5fe62f9 100644
> --- a/arch/arm/boot/dts/r7s72100.dtsi
> +++ b/arch/arm/boot/dts/r7s72100.dtsi
[...]
> @@ -667,4 +667,13 @@
>   		power-domains = <&cpg_clocks>;
>   		status = "disabled";
>   	};
> +
> +	ceu: ceu@e8210000 {

    The DT spec dictates the generic node names should be used. For the R-Car 
VIN we use "video@...", hence I suggest that use the same here.

> +		reg = <0xe8210000 0x3000>;
> +		compatible = "renesas,r7s72100-ceu";
> +		interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp6_clks R7S72100_CLK_CEU>;
> +		power-domains = <&cpg_clocks>;
> +		status = "disabled";
> +	};
>   };

MBR, Sergei
