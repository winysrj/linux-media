Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:43345 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaHVByW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 21:54:22 -0400
Date: Fri, 22 Aug 2014 10:54:18 +0900
From: Simon Horman <horms@verge.net.au>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: m.chehab@samsung.com, magnus.damm@gmail.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	laurent.pinchart@ideasonboard.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [3/6] ARM: shmobile: r8a7790: Add JPU device node.
Message-ID: <20140822015418.GD9099@verge.net.au>
References: <1408452653-14067-4-git-send-email-mikhail.ulyanov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408452653-14067-4-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 19, 2014 at 04:50:50PM +0400, Mikhail Ulyanov wrote:
> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>

Please add a changelog.

Please repost this once the binding used below has been
accepted by the maintainer.

Please CC both Magnus Damm and I when you resubmit this or
post and likewise for any other sshmobile patches.

Thanks

> 
> ---
> arch/arm/boot/dts/r8a7790.dtsi | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> index 61fd193..c8bc048 100644
> --- a/arch/arm/boot/dts/r8a7790.dtsi
> +++ b/arch/arm/boot/dts/r8a7790.dtsi
> @@ -600,6 +600,13 @@
>  		status = "disabled";
>  	};
>  
> +	jpu: jpeg-codec@fe980000 {
> +		compatible = "renesas,jpu-r8a7790";
> +		reg = <0 0xfe980000 0 0x10300>;
> +		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
> +	};
> +
>  	clocks {
>  		#address-cells = <2>;
>  		#size-cells = <2>;
