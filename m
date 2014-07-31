Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44209 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaGaP2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 11:28:08 -0400
Message-ID: <1406820486.16697.60.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 01/28] ARM: dts: imx6qdl: Add ipu aliases
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Shawn Guo <shawn.guo@freescale.com>
Date: Thu, 31 Jul 2014 17:28:06 +0200
In-Reply-To: <1403744755-24944-2-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
	 <1403744755-24944-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 25.06.2014, 18:05 -0700 schrieb Steve Longerbeam:
> Add ipu0 (and ipu1 for quad) aliases to ipu1/ipu2 nodes respectively.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  arch/arm/boot/dts/imx6q.dtsi   |    1 +
>  arch/arm/boot/dts/imx6qdl.dtsi |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index addd3f8..fcfbac2 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -14,6 +14,7 @@
>  
>  / {
>  	aliases {
> +		ipu1 = &ipu2;
>  		spi4 = &ecspi5;
>  	};
>  
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index ce05991..3b3d8fe 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -29,6 +29,7 @@
>  		i2c0 = &i2c1;
>  		i2c1 = &i2c2;
>  		i2c2 = &i2c3;
> +		ipu0 = &ipu1;
>  		mmc0 = &usdhc1;
>  		mmc1 = &usdhc2;
>  		mmc2 = &usdhc3;

I think Shawn (added to Cc:) should take this patch separately, please
consider sending it to him.

regards
Philipp


