Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:43339 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760050AbdJQUN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 16:13:56 -0400
Date: Tue, 17 Oct 2017 15:13:54 -0500
From: Rob Herring <robh@kernel.org>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] staging: Introduce NVIDIA Tegra20 video decoder
 driver
Message-ID: <20171017201354.efgjrwvakkseyvr7@rob-hp-laptop>
References: <cover.1507752381.git.digetx@gmail.com>
 <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 11:08:11PM +0300, Dmitry Osipenko wrote:
> Video decoder, found on NVIDIA Tegra20 SoC, supports a standard set of
> video formats like H.264 / MPEG-4 / WMV / VC1. Currently driver supports
> decoding of CAVLC H.264 only.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  .../bindings/arm/tegra/nvidia,tegra20-vde.txt      |   44 +

It's preferred to split bindings to a separate patch. Also, this doesn't 
belong under bindings/arm/, but rather bindings/media/.

>  drivers/staging/Kconfig                            |    2 +
>  drivers/staging/Makefile                           |    1 +
>  drivers/staging/tegra-vde/Kconfig                  |    6 +
>  drivers/staging/tegra-vde/Makefile                 |    1 +
>  drivers/staging/tegra-vde/TODO                     |    5 +
>  drivers/staging/tegra-vde/uapi.h                   |  101 ++
>  drivers/staging/tegra-vde/vde.c                    | 1109 ++++++++++++++++++++
>  8 files changed, 1269 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt
>  create mode 100644 drivers/staging/tegra-vde/Kconfig
>  create mode 100644 drivers/staging/tegra-vde/Makefile
>  create mode 100644 drivers/staging/tegra-vde/TODO
>  create mode 100644 drivers/staging/tegra-vde/uapi.h
>  create mode 100644 drivers/staging/tegra-vde/vde.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt
> new file mode 100644
> index 000000000000..c3f847db8167
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt
> @@ -0,0 +1,44 @@
> +NVIDIA Tegra Video Decoder Engine
> +
> +Required properties:
> +- compatible : "nvidia,tegra20-vde"
> +- reg : Must contain 2 register ranges: registers and IRAM region that
> +        VDE uses for its internal needs and for passing some of decoding
> +        parameters.

Is the IRAM shared with other things. If so, use mmio-sram binding and 
define the codec's region.

> +- reg-names : Must include the following entries:
> +  - regs
> +  - iram
> +- interrupts : Must contain an entry for each entry in interrupt-names.
> +- interrupt-names : Must include the following entries:
> +  - ucq-error
> +  - sync-token
> +  - bsev
> +  - bsea
> +  - sxe
> +- clocks : Must contain an entry for each entry in clock-names.
> +  See ../clocks/clock-bindings.txt for details.
> +- clock-names : Must include the following entries:
> +  - vde
> +- resets : Must contain an entry for each entry in reset-names.
> +  See ../reset/reset.txt for details.
> +- reset-names : Must include the following entries:
> +  - vde

-names is pointless when there is only one.

> +
> +Example:
> +
> +vde@6001a000 {

video-codec@...

> +	compatible = "nvidia,tegra20-vde";
> +	reg = <0x6001a000 0x3D00    /* VDE registers */
> +		0x40000400 0x3FC00>; /* IRAM region */

Lower case hex please.

> +	reg-names = "regs", "iram";
> +	interrupts = <GIC_SPI  8 IRQ_TYPE_LEVEL_HIGH>, /* UCQ error interrupt */
> +			<GIC_SPI  9 IRQ_TYPE_LEVEL_HIGH>, /* Sync token interrupt */
> +			<GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>, /* BSE-V interrupt */
> +			<GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>, /* BSE-A interrupt */
> +			<GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>; /* SXE interrupt */
> +	interrupt-names = "ucq-error", "sync-token", "bsev", "bsea", "sxe";
> +	clocks = <&tegra_car TEGRA20_CLK_VDE>;
> +	clock-names = "vde";
> +	resets = <&tegra_car 61>;
> +	reset-names = "vde";
> +};
