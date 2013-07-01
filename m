Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59691 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3GAG20 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 02:28:26 -0400
Message-ID: <51D12164.6030507@ti.com>
Date: Mon, 1 Jul 2013 11:57:48 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
	"'Felipe Balbi'" <balbi@ti.com>,
	"'Tomasz Figa'" <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>,
	"'Inki Dae'" <inki.dae@samsung.com>,
	"'Donghwa Lee'" <dh09.lee@samsung.com>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>,
	"'Hui Wang'" <jason77.wang@gmail.com>
Subject: Re: [PATCH V3 3/3] video: exynos_dp: Use the generic PHY driver
References: <005401ce761b$504d7090$f0e851b0$@samsung.com>
In-Reply-To: <005401ce761b$504d7090$f0e851b0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 01 July 2013 10:54 AM, Jingoo Han wrote:
> Use the generic PHY API instead of the platform callback to control
> the DP PHY. The 'phy_label' field is added to the platform data
> structure to allow PHY lookup on non-dt platforms.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>   .../devicetree/bindings/video/exynos_dp.txt        |   23 +---
>   drivers/video/exynos/exynos_dp_core.c              |  118 ++------------------
>   drivers/video/exynos/exynos_dp_core.h              |    2 +
>   include/video/exynos_dp.h                          |    6 +-
>   4 files changed, 21 insertions(+), 128 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Documentation/devicetree/bindings/video/exynos_dp.txt
> index 84f10c1..71645dc 100644
> --- a/Documentation/devicetree/bindings/video/exynos_dp.txt
> +++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
> @@ -1,17 +1,6 @@
>   The Exynos display port interface should be configured based on
>   the type of panel connected to it.
>
> -We use two nodes:
> -	-dp-controller node
> -	-dptx-phy node(defined inside dp-controller node)
> -
> -For the DP-PHY initialization, we use the dptx-phy node.
> -Required properties for dptx-phy:
> -	-reg:
> -		Base address of DP PHY register.
> -	-samsung,enable-mask:
> -		The bit-mask used to enable/disable DP PHY.
> -
>   For the Panel initialization, we read data from dp-controller node.
>   Required properties for dp-controller:
>   	-compatible:
> @@ -25,6 +14,10 @@ Required properties for dp-controller:
>   		from common clock binding: handle to dp clock.
>   	-clock-names:
>   		from common clock binding: Shall be "dp".
> +	-phys:
> +		from general phy binding: the phandle for the PHY device.
> +	-phy-names:
> +		from general phy binding: Should be "dp".
>   	-interrupt-parent:
>   		phandle to Interrupt combiner node.
>   	-samsung,color-space:
> @@ -67,12 +60,8 @@ SOC specific portion:
>   		interrupt-parent = <&combiner>;
>   		clocks = <&clock 342>;
>   		clock-names = "dp";
> -
> -		dptx-phy {
> -			reg = <0x10040720>;
> -			samsung,enable-mask = <1>;
> -		};
> -
> +		phys = <&dp_phy>;
> +		phy-names = "dp";
>   	};
>
>   Board Specific portion:
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index 12bbede..bac515b 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -19,6 +19,7 @@
>   #include <linux/interrupt.h>
>   #include <linux/delay.h>
>   #include <linux/of.h>
> +#include <linux/phy/phy.h>
>
>   #include <video/exynos_dp.h>
>
> @@ -960,84 +961,15 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
>   		return ERR_PTR(-EINVAL);
>   	}
>
> -	return pd;
> -}
> -
> -static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
> -{
> -	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
> -	u32 phy_base;
> -	int ret = 0;
> -
> -	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
> -	if (!dp_phy_node) {
> -		dev_err(dp->dev, "could not find dptx-phy node\n");
> -		return -ENODEV;
> -	}
> -
> -	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
> -		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
> -		ret = -EINVAL;
> -		goto err;
> -	}
> -
> -	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
> -				&dp->enable_mask)) {
> -		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
> -		ret = -EINVAL;
> -		goto err;
> -	}
> -
> -	dp->phy_addr = ioremap(phy_base, SZ_4);
> -	if (!dp->phy_addr) {
> -		dev_err(dp->dev, "failed to ioremap dp-phy\n");
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> -
> -err:
> -	of_node_put(dp_phy_node);
> -
> -	return ret;
> -}
> -
> -static void exynos_dp_phy_init(struct exynos_dp_device *dp)
> -{
> -	u32 reg;
> -
> -	reg = __raw_readl(dp->phy_addr);
> -	reg |= dp->enable_mask;
> -	__raw_writel(reg, dp->phy_addr);
> -}
> -
> -static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
> -{
> -	u32 reg;
> +	pd->phy_label = "dp";

Felipe had a comment to change the label to *display-port* no?

Thanks
Kishon
