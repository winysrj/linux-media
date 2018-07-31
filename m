Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:36329 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbeGaOOg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 10:14:36 -0400
Date: Tue, 31 Jul 2018 14:34:23 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v6 2/4] ARM: dts: sun8i: a83t: Add support for the cir
 interface
Message-ID: <20180731123423.vfcc2ubmtikk7ycy@flea>
References: <20180731092258.2279-1-embed3d@gmail.com>
 <20180731092258.2279-3-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180731092258.2279-3-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2018 at 11:22:56AM +0200, Philipp Rossak wrote:
> The cir interface is like on the H3 located at 0x01f02000 and is exactly
> the same. This patch adds support for the ir interface on the A83T.
> 
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
> index afed6c0dea6f..31222a05a8f1 100644
> --- a/arch/arm/boot/dts/sun8i-a83t.dtsi
> +++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
> @@ -992,6 +992,18 @@
>  			reg = <0x1f01c00 0x400>;
>  		};
>  
> +		r_cir: ir@1f02000 {
> +			compatible = "allwinner,sun5i-a13-ir";

You should have an a83t compatile in addition here.

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
