Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:20091 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3GHCEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 22:04:10 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: 'Tomasz Figa' <tomasz.figa@gmail.com>
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
	linux-fbdev@vger.kernel.org, 'Hui Wang' <jason77.wang@gmail.com>,
	Jingoo Han <jg1.han@samsung.com>
References: <000d01ce7700$222a35a0$667ea0e0$@samsung.com>
 <1441230.DzaqAQ9HHT@flatron>
In-reply-to: <1441230.DzaqAQ9HHT@flatron>
Subject: Re: [PATCH V4 4/4] video: exynos_dp: Use the generic PHY driver
Date: Mon, 08 Jul 2013 11:04:06 +0900
Message-id: <001a01ce7b7f$6d7bdc60$48739520$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, July 06, 2013 8:04 AM, Tomasz Figa wrote:
> 
> Hi Jingoo,
> 
> On Tuesday 02 of July 2013 17:42:49 Jingoo Han wrote:
> > Use the generic PHY API instead of the platform callback to control
> > the DP PHY.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  .../devicetree/bindings/video/exynos_dp.txt        |   23
> > +++++--------------- drivers/video/exynos/exynos_dp_core.c
> > |   16 ++++++++++---- drivers/video/exynos/exynos_dp_core.h
> >  |    2 ++
> >  3 files changed, 20 insertions(+), 21 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt
> > b/Documentation/devicetree/bindings/video/exynos_dp.txt index
> > 84f10c1..022f4b6 100644
> > --- a/Documentation/devicetree/bindings/video/exynos_dp.txt
> > +++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
> > @@ -1,17 +1,6 @@
> >  The Exynos display port interface should be configured based on
> >  the type of panel connected to it.
> >
> > -We use two nodes:
> > -	-dp-controller node
> > -	-dptx-phy node(defined inside dp-controller node)
> > -
> > -For the DP-PHY initialization, we use the dptx-phy node.
> > -Required properties for dptx-phy:
> > -	-reg:
> > -		Base address of DP PHY register.
> > -	-samsung,enable-mask:
> > -		The bit-mask used to enable/disable DP PHY.
> > -
> 
> I wonder if this part shouldn't stay here, just marked as deprecated,
> because compatibility with old dtbs must be preserved (and rest of the
> patch looks like it is).

I would like to remove these properties from Documentation.
But, I will mark it as deprecated as you suggested..


Best regards,
Jingoo Han


