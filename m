Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45669 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3GEXE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 19:04:29 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	'Tomi Valkeinen' <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, 'Hui Wang' <jason77.wang@gmail.com>
Subject: Re: [PATCH V4 4/4] video: exynos_dp: Use the generic PHY driver
Date: Sat, 06 Jul 2013 01:04:23 +0200
Message-ID: <1441230.DzaqAQ9HHT@flatron>
In-Reply-To: <000d01ce7700$222a35a0$667ea0e0$@samsung.com>
References: <000d01ce7700$222a35a0$667ea0e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jingoo,

On Tuesday 02 of July 2013 17:42:49 Jingoo Han wrote:
> Use the generic PHY API instead of the platform callback to control
> the DP PHY.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  .../devicetree/bindings/video/exynos_dp.txt        |   23
> +++++--------------- drivers/video/exynos/exynos_dp_core.c             
> |   16 ++++++++++---- drivers/video/exynos/exynos_dp_core.h            
>  |    2 ++
>  3 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt
> b/Documentation/devicetree/bindings/video/exynos_dp.txt index
> 84f10c1..022f4b6 100644
> --- a/Documentation/devicetree/bindings/video/exynos_dp.txt
> +++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
> @@ -1,17 +1,6 @@
>  The Exynos display port interface should be configured based on
>  the type of panel connected to it.
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

I wonder if this part shouldn't stay here, just marked as deprecated, 
because compatibility with old dtbs must be preserved (and rest of the 
patch looks like it is).

>  For the Panel initialization, we read data from dp-controller node.
>  Required properties for dp-controller:
>  	-compatible:
> @@ -25,6 +14,10 @@ Required properties for dp-controller:
>  		from common clock binding: handle to dp clock.
>  	-clock-names:
>  		from common clock binding: Shall be "dp".
> +	-phys:
> +		from general PHY binding: the phandle for the PHY device.
> +	-phy-names:
> +		from general PHY binding: Should be "dp".
>  	-interrupt-parent:
>  		phandle to Interrupt combiner node.
>  	-samsung,color-space:
> @@ -67,12 +60,8 @@ SOC specific portion:
>  		interrupt-parent = <&combiner>;
>  		clocks = <&clock 342>;
>  		clock-names = "dp";
> -
> -		dptx-phy {
> -			reg = <0x10040720>;
> -			samsung,enable-mask = <1>;
> -		};
> -
> +		phys = <&dp_phy>;
> +		phy-names = "dp";
>  	};
> 
>  Board Specific portion:
> diff --git a/drivers/video/exynos/exynos_dp_core.c
> b/drivers/video/exynos/exynos_dp_core.c index 05fed7d..5e1a715 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -19,6 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
>  #include <linux/of.h>
> +#include <linux/phy/phy.h>
> 
>  #include "exynos_dp_core.h"
> 
> @@ -960,8 +961,11 @@ static int exynos_dp_dt_parse_phydata(struct
> exynos_dp_device *dp)
> 
>  	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
>  	if (!dp_phy_node) {
> -		dev_err(dp->dev, "could not find dptx-phy node\n");
> -		return -ENODEV;
> +		dp->phy = devm_phy_get(dp->dev, "dp");
> +		if (IS_ERR(dp->phy))
> +			return PTR_ERR(dp->phy);
> +		else
> +			return 0;
>  	}
> 
>  	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
> @@ -992,7 +996,9 @@ err:
> 
>  static void exynos_dp_phy_init(struct exynos_dp_device *dp)
>  {
> -	if (dp->phy_addr) {
> +	if (dp->phy) {
> +		phy_power_on(dp->phy);
> +	} else if (dp->phy_addr) {
>  		u32 reg;
> 
>  		reg = __raw_readl(dp->phy_addr);
> @@ -1003,7 +1009,9 @@ static void exynos_dp_phy_init(struct
> exynos_dp_device *dp)
> 
>  static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
>  {
> -	if (dp->phy_addr) {
> +	if (dp->phy) {
> +		phy_power_off(dp->phy);
> +	} else if (dp->phy_addr) {
>  		u32 reg;
> 
>  		reg = __raw_readl(dp->phy_addr);
> diff --git a/drivers/video/exynos/exynos_dp_core.h
> b/drivers/video/exynos/exynos_dp_core.h index 56cfec8..87804b6 100644
> --- a/drivers/video/exynos/exynos_dp_core.h
> +++ b/drivers/video/exynos/exynos_dp_core.h
> @@ -151,6 +151,8 @@ struct exynos_dp_device {
>  	struct video_info	*video_info;
>  	struct link_train	link_train;
>  	struct work_struct	hotplug_work;
> +

nit: unnecessary blank line

> +	struct phy		*phy;
>  };
> 
>  /* exynos_dp_reg.c */

Otherwise looks good.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

