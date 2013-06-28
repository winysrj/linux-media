Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41711 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3F1GJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 02:09:50 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: 'Hui Wang' <jason77.wang@gmail.com>
Cc: 'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-arm-kernel@lists.infradead.org,
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
References: <001601ce73bf$9f2e9120$dd8bb360$@samsung.com>
 <51CD2214.10506@ti.com> <001b01ce73c4$88f45020$9adcf060$@samsung.com>
 <51CD27FF.1060706@gmail.com>
In-reply-to: <51CD27FF.1060706@gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: Add DP PHY node to exynos5250.dtsi
Date: Fri, 28 Jun 2013 15:09:43 +0900
Message-id: <001d01ce73c6$155eb450$401c1cf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, June 28, 2013 3:07 PM, Hui Wang wrote:
> On 06/28/2013 01:58 PM, Jingoo Han wrote:
> > On Friday, June 28, 2013 2:42 PM, Kishon Vijay Abraham I wrote:
> >> Hi,
> >>
> >> On Friday 28 June 2013 10:53 AM, Jingoo Han wrote:
> >>> Add PHY provider node for the DP PHY.
> >>>
> >>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >>> ---
> >>>    arch/arm/boot/dts/exynos5250.dtsi |   13 ++++++++-----
> >>>    1 file changed, 8 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> >>> index 41cd625..d1d6e14 100644
> >>> --- a/arch/arm/boot/dts/exynos5250.dtsi
> >>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> >>> @@ -614,6 +614,12 @@
> >>>    		interrupts = <0 94 0>;
> >>>    	};
> >>>
> >>> +	dp_phy: video-phy@10040720 {
> >>> +		compatible = "samsung,exynos5250-dp-video-phy";
> >>> +		reg = <0x10040720 4>;
> >>> +		#phy-cells = <1>;
> >> phy-cells can be '0' here since this phy_provider implements only one PHY.
> > Oh, thank you.
> > I will fix it.
> Don't forget to fix the corresponding description in the
> samsung,exynos5250-dp-video-phy.txt as well. :-)

Hi 

OK, I already fixed it. :)
Thank you for reminding me.

Best regards,
Jignoo Han

> > Best regards,
> > Jingoo Han
> >
> >> Thanks
> >> Kishon
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >

