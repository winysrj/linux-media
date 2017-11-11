Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:53718 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbdKKOSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 09:18:03 -0500
Subject: Re: [PATCH v4 1/5] ARM: tegra: Add device tree node to describe IRAM
To: Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <cover.1508448293.git.digetx@gmail.com>
 <8ce696bc2b4b1808f6c7f7a967a3dacd954d2a4e.1508448293.git.digetx@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <ffa5f1d0-f156-0bc3-6adb-bb55a0a855c4@mleia.com>
Date: Sat, 11 Nov 2017 16:18:00 +0200
MIME-Version: 1.0
In-Reply-To: <8ce696bc2b4b1808f6c7f7a967a3dacd954d2a4e.1508448293.git.digetx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

On 10/20/2017 12:34 AM, Dmitry Osipenko wrote:
> From: Vladimir Zapolskiy <vz@mleia.com>
> 
> All Tegra SoCs contain 256KiB IRAM, which is used to store CPU resume code
> and by hardware engines like a video decoder.
> 
> Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>

Please add also your own closing "Signed-off-by" tag, please reference
to "Developer's Certificate of Origin 1.1", point (c), it is found in
Documentation/process/submitting-patches.rst

> ---
>  arch/arm/boot/dts/tegra114.dtsi | 8 ++++++++
>  arch/arm/boot/dts/tegra124.dtsi | 8 ++++++++
>  arch/arm/boot/dts/tegra20.dtsi  | 8 ++++++++
>  arch/arm/boot/dts/tegra30.dtsi  | 8 ++++++++

My assumption is that Thierry would prefer to get 4 separate patches,
one for each platform, please split the patch.

Also thanks for your time and your efforts applied to push my occasional
change, please feel free to take your own authorship for 3 out of 4 patches.

>  4 files changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
> index 8932ea3afd5f..13f6087790c8 100644
> --- a/arch/arm/boot/dts/tegra114.dtsi
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -10,6 +10,14 @@
>  	compatible = "nvidia,tegra114";
>  	interrupt-parent = <&lic>;
>  
> +	iram@40000000 {
> +		compatible = "mmio-sram";

Unfortunately Thierry hasn't yet replied, but my assumption is that
the list of compatibles should be extended with one more SoC specific
value like

	compatible = "nvidia,tegra114-sysram", "mmio-sram";

I'm not sure, if Tegra maintainers want to see a new compatible
described in Documentation/devicetree/bindings.

> +		reg = <0x40000000 0x40000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x40000000 0x40000>;
> +	};
> +
>  	host1x@50000000 {
>  		compatible = "nvidia,tegra114-host1x", "simple-bus";
>  		reg = <0x50000000 0x00028000>;
> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
> index 8baf00b89efb..a3585ed82646 100644
> --- a/arch/arm/boot/dts/tegra124.dtsi
> +++ b/arch/arm/boot/dts/tegra124.dtsi

The considerations from above are applicable to the rest of
the touched platforms.

--
With best wishes,
Vladimir
