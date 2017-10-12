Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10860 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbdJLIts (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 04:49:48 -0400
Subject: Re: [PATCH v3 2/2] ARM: dts: tegra20: Add video decoder node
To: Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-media@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1507752381.git.digetx@gmail.com>
 <f58be69f6004393711c9ff3cb4b52aed33e2611a.1507752381.git.digetx@gmail.com>
From: Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f18b6a72-e255-9aa4-6ebd-852ce1a27a4e@nvidia.com>
Date: Thu, 12 Oct 2017 09:49:04 +0100
MIME-Version: 1.0
In-Reply-To: <f58be69f6004393711c9ff3cb4b52aed33e2611a.1507752381.git.digetx@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 11/10/17 21:08, Dmitry Osipenko wrote:
> Add a device node for the video decoder engine found on Tegra20.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  arch/arm/boot/dts/tegra20.dtsi | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 7c85f97f72ea..1b5d54b6c0cb 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -249,6 +249,23 @@
>  		*/
>  	};
>  
> +	vde@6001a000 {
> +		compatible = "nvidia,tegra20-vde";
> +		reg = <0x6001a000 0x3D00    /* VDE registers */
> +		       0x40000400 0x3FC00>; /* IRAM region */
> +		reg-names = "regs", "iram";
> +		interrupts = <GIC_SPI  8 IRQ_TYPE_LEVEL_HIGH>, /* UCQ error interrupt */
> +			     <GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>, /* Sync token interrupt */
> +			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
> +			     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>, /* BSE-A interrupt */
> +			     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
> +		interrupt-names = "ucq-error", "sync-token", "bsev", "bsea", "sxe";
> +		clocks = <&tegra_car TEGRA20_CLK_VDE>;
> +		clock-names = "vde";
> +		resets = <&tegra_car 61>;
> +		reset-names = "vde";
> +	};
> +

I don't see any binding documentation for this node. We need to make
sure we add this.

Jon

-- 
nvpublic
