Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53621 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbaLSU7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 15:59:04 -0500
Date: Fri, 19 Dec 2014 21:59:02 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/7] ARM: at91: dts: sama5d3: add isi clock
Message-ID: <20141219205902.GY4885@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-2-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418892667-27428-2-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/12/2014 at 16:51:01 +0800, Josh Wu wrote :
> Add ISI peripheral clock in sama5d3.dtsi.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  arch/arm/boot/dts/sama5d3.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 5f4144d..61746ef 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -214,6 +214,8 @@
>  				compatible = "atmel,at91sam9g45-isi";
>  				reg = <0xf0034000 0x4000>;
>  				interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> +				clocks = <&isi_clk>;
> +				clock-names = "isi_clk";
>  				status = "disabled";
>  			};
>  
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
