Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751929AbeECCk2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 22:40:28 -0400
Date: Thu, 3 May 2018 10:40:12 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v2 07/15] ARM: dts: increase default cma size to 40MB
Message-ID: <20180503024011.GP3443@dragon>
References: <20180423134750.30403-1-rui.silva@linaro.org>
 <20180423134750.30403-8-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423134750.30403-8-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 02:47:42PM +0100, Rui Miguel Silva wrote:
> To support camera in i.MX7 the cma heap is used to allocate frame buffers. The
> default size of CMA is 16MB which is not enough for higher resolutions (ex:
> 1600x1200).
> 
> So, increase the default CMA size to 40MB.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>

CMA size can be adjusted by kernel cmdline.  I'm not sure it's necessary
to make it fixed in DT.

Shawn

> ---
>  arch/arm/boot/dts/imx7s.dtsi | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 4d42335c0dee..142ea709d296 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -182,6 +182,20 @@
>  			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
>  	};
>  
> +	reserved-memory {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		/* global autoconfigured region for contiguous allocations */
> +		linux,cma {
> +			compatible = "shared-dma-pool";
> +			reusable;
> +			size = <0x2800000>;
> +			linux,cma-default;
> +		};
> +	};
> +
>  	soc {
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> -- 
> 2.17.0
> 
