Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:54600 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbdGOIMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 04:12:37 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        Yakir Yang <ykk@rock-chips.com>
Subject: Re: [PATCH v2 3/6] ARM: dts: rockchip: add RGA device node for RK3288
Date: Sat, 15 Jul 2017 10:12:02 +0200
Message-ID: <1951692.C191PNKQbQ@phil>
In-Reply-To: <1500101920-24039-4-git-send-email-jacob-chen@iotwrt.com>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com> <1500101920-24039-4-git-send-email-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

Am Samstag, 15. Juli 2017, 14:58:37 CEST schrieb Jacob Chen:
> This patch add the RGA dt config of rk3288 SoC.
> 
> Signed-off-by: Yakir Yang <ykk@rock-chips.com>
> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>

from the Signed-off it looks like Yakir was te original author of the
patch. So please fix the authorship or drop the top Signed-off by.

Same for other patches like this.


Thanks
Heiko

> ---
>  arch/arm/boot/dts/rk3288.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 1efc2f2..83d025d 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -945,6 +945,19 @@
>  		status = "okay";
>  	};
>  
> +	rga: rga@ff920000 {
> +		compatible = "rockchip,rk3288-rga";
> +		reg = <0xff920000 0x180>;
> +		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "rga";
> +		clocks = <&cru ACLK_RGA>, <&cru HCLK_RGA>, <&cru SCLK_RGA>;
> +		clock-names = "aclk", "hclk", "sclk";
> +		power-domains = <&power RK3288_PD_VIO>;
> +		resets = <&cru SRST_RGA_CORE>, <&cru SRST_RGA_AXI>, <&cru SRST_RGA_AHB>;
> +		reset-names = "core", "axi", "ahb";
> +		status = "disabled";
> +	};
> +
>  	vopb: vop@ff930000 {
>  		compatible = "rockchip,rk3288-vop";
>  		reg = <0xff930000 0x19c>;
> 
