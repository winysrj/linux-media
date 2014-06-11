Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52841 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaFKLVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:21:54 -0400
Message-ID: <1402485712.4107.108.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 02/43] ARM: dts: imx6qdl: Add ipu aliases
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:21:52 +0200
In-Reply-To: <1402178205-22697-3-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-3-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Add ipu0 (and ipu1 for quad) aliases to ipu1/ipu2 nodes respectively.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  arch/arm/boot/dts/imx6q.dtsi   |    1 +
>  arch/arm/boot/dts/imx6qdl.dtsi |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index addd3f8..c7544f0 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -15,6 +15,7 @@
>  / {
>  	aliases {
>  		spi4 = &ecspi5;
> +		ipu1 = &ipu2;
>  	};
>  
>  	cpus {
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index eca0971..04c978c 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -43,6 +43,7 @@
>  		spi3 = &ecspi4;
>  		usbphy0 = &usbphy1;
>  		usbphy1 = &usbphy2;
> +		ipu0 = &ipu1;
>  	};
>  
>  	intc: interrupt-controller@00a01000 {

That could be useful, although I think those aliases are supposed to be
in alphabetic order.

regards
Philipp

