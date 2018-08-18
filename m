Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42083 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeHRPxT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 11:53:19 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 14/14] ARM: tegra: Enable SMMU for VDE on Tegra124
Date: Sat, 18 Aug 2018 15:45:41 +0300
Message-ID: <13580502.EC82852oeo@dimapc>
In-Reply-To: <20180813145027.16346-15-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com> <20180813145027.16346-15-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, 13 August 2018 17:50:27 MSK Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The video decode engine can use the SMMU to use buffers that are not
> physically contiguous in memory. This allows better memory usage for
> video decoding, since fragmentation may cause contiguous allocations
> to fail.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra124.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/tegra124.dtsi
> b/arch/arm/boot/dts/tegra124.dtsi index 8fdca4723205..0713e0ed5fef 100644
> --- a/arch/arm/boot/dts/tegra124.dtsi
> +++ b/arch/arm/boot/dts/tegra124.dtsi
> @@ -321,6 +321,8 @@
>  		resets = <&tegra_car 61>,
>  			 <&tegra_car 63>;
>  		reset-names = "vde", "bsev";
> +
> +		iommus = <&mc TEGRA_SWGROUP_VDE>;
>  	};
> 
>  	apbdma: dma@60020000 {

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>

The same should be applied to Tegra30.
