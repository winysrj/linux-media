Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:22217 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3GAAfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 20:35:18 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: 'Kishon Vijay Abraham I' <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <001701ce73bf$bebf9f20$3c3edd60$@samsung.com>
 <51CD25F2.5010206@ti.com> <001c01ce73c5$552e1cc0$ff8a5640$@samsung.com>
 <51CD56FE.4020302@ti.com>
In-reply-to: <51CD56FE.4020302@ti.com>
Subject: Re: [PATCH 3/3] video: exynos_dp: Use the generic PHY driver
Date: Mon, 01 Jul 2013 09:35:15 +0900
Message-id: <000001ce75f2$db156170$91402450$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, June 28, 2013 6:27 PM, Kishon Vijay Abraham I wrote:
> 
> Hi,
> 
> On Friday 28 June 2013 11:34 AM, Jingoo Han wrote:
> > On Friday, June 28, 2013 2:58 PM, Kishon Vijay Abraham I wrote:
> >>
> >> Hi,
> >>
> >> On Friday 28 June 2013 10:54 AM, Jingoo Han wrote:
> >>> Use the generic PHY API instead of the platform callback to control
> >>> the DP PHY. The 'phy_label' field is added to the platform data
> >>> structure to allow PHY lookup on non-dt platforms.
> >>>
> >>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >>> ---
> >>>    .../devicetree/bindings/video/exynos_dp.txt        |   17 ---
> >>>    drivers/video/exynos/exynos_dp_core.c              |  118 ++------------------
> >>>    drivers/video/exynos/exynos_dp_core.h              |    2 +
> >>>    include/video/exynos_dp.h                          |    6 +-
> >>>    4 files changed, 15 insertions(+), 128 deletions(-)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt
> >> b/Documentation/devicetree/bindings/video/exynos_dp.txt
> >>> index 84f10c1..a8320e3 100644
> >>> --- a/Documentation/devicetree/bindings/video/exynos_dp.txt
> >>> +++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
> >>> @@ -1,17 +1,6 @@
> >>>    The Exynos display port interface should be configured based on
> >>>    the type of panel connected to it.
> >>>
> >>> -We use two nodes:
> >>> -	-dp-controller node
> >>> -	-dptx-phy node(defined inside dp-controller node)
> >>> -
> >>> -For the DP-PHY initialization, we use the dptx-phy node.
> >>> -Required properties for dptx-phy:
> >>> -	-reg:
> >>> -		Base address of DP PHY register.
> >>> -	-samsung,enable-mask:
> >>> -		The bit-mask used to enable/disable DP PHY.
> >>> -
> >>>    For the Panel initialization, we read data from dp-controller node.
> >>>    Required properties for dp-controller:
> >>>    	-compatible:
> >>> @@ -67,12 +56,6 @@ SOC specific portion:
> >>>    		interrupt-parent = <&combiner>;
> >>>    		clocks = <&clock 342>;
> >>>    		clock-names = "dp";
> >>> -
> >>> -		dptx-phy {
> >>> -			reg = <0x10040720>;
> >>> -			samsung,enable-mask = <1>;
> >>> -		};
> >>> -
> >>>    	};
> >>>
> >>>    Board Specific portion:
> >>> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> >>> index 12bbede..bac515b 100644
> >>> --- a/drivers/video/exynos/exynos_dp_core.c
> >>> +++ b/drivers/video/exynos/exynos_dp_core.c
> >>> @@ -19,6 +19,7 @@
> >>>    #include <linux/interrupt.h>
> >>>    #include <linux/delay.h>
> >>>    #include <linux/of.h>
> >>> +#include <linux/phy/phy.h>
> >>>
> >>>    #include <video/exynos_dp.h>
> >>>
> >>> @@ -960,84 +961,15 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device
> *dev)
> >>>    		return ERR_PTR(-EINVAL);
> >>>    	}
> >>>
> >>> -	return pd;
> >>> -}
> >>> -
> >>> -static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
> >>> -{
> >>> -	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
> >>> -	u32 phy_base;
> >>> -	int ret = 0;
> >>> -
> >>> -	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
> >>> -	if (!dp_phy_node) {
> >>> -		dev_err(dp->dev, "could not find dptx-phy node\n");
> >>> -		return -ENODEV;
> >>> -	}
> >>> -
> >>> -	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
> >>> -		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
> >>> -		ret = -EINVAL;
> >>> -		goto err;
> >>> -	}
> >>> -
> >>> -	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
> >>> -				&dp->enable_mask)) {
> >>> -		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
> >>> -		ret = -EINVAL;
> >>> -		goto err;
> >>> -	}
> >>> -
> >>> -	dp->phy_addr = ioremap(phy_base, SZ_4);
> >>> -	if (!dp->phy_addr) {
> >>> -		dev_err(dp->dev, "failed to ioremap dp-phy\n");
> >>> -		ret = -ENOMEM;
> >>> -		goto err;
> >>> -	}
> >>> -
> >>> -err:
> >>> -	of_node_put(dp_phy_node);
> >>> -
> >>> -	return ret;
> >>> -}
> >>> -
> >>> -static void exynos_dp_phy_init(struct exynos_dp_device *dp)
> >>> -{
> >>> -	u32 reg;
> >>> -
> >>> -	reg = __raw_readl(dp->phy_addr);
> >>> -	reg |= dp->enable_mask;
> >>> -	__raw_writel(reg, dp->phy_addr);
> >>> -}
> >>> -
> >>> -static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
> >>> -{
> >>> -	u32 reg;
> >>> +	pd->phy_label = "dp";
> >>
> >> In the case of non-dt boot, this phy_label should have ideally come from
> >> platform code.
> >
> > No, this is NOT the case of non-dt.
> >
> > 'pd->phy_label = "dp";' is included in exynos_dp_dt_parse_pdata(),
> > not exynos_dp_phy_exit().
> > Also, exynos_dp_dt_parse_pdata() is called in the case of dt.
> 
> ah.. right. Do you support non-dt boot. I dont see any modifications in
> the platform code?

Platform code for non-DT has not been added; thus, there is no modification
in the platform code.


Best regards,
Jingoo Han

> 
> Thanks
> Kishon

