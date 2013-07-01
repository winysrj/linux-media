Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:29321 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3GABIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 21:08:16 -0400
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
References: <001f01ce73cf$46d8c940$d48a5bc0$@samsung.com>
 <51CEA219.8030001@ti.com>
In-reply-to: <51CEA219.8030001@ti.com>
Subject: Re: [PATCH V2 1/3] phy: Add driver for Exynos DP PHY
Date: Mon, 01 Jul 2013 10:08:14 +0900
Message-id: <001501ce75f7$767034c0$63509e40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, June 29, 2013 6:00 PM, Kishon Vijay Abraham I wrote:
> 
> Hi,
> 
> On Friday 28 June 2013 12:45 PM, Jingoo Han wrote:
> > Add a PHY provider driver for the Samsung Exynos SoC DP PHY.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >   .../phy/samsung,exynos5250-dp-video-phy.txt        |    7 ++
> >   drivers/phy/Kconfig                                |    8 ++
> >   drivers/phy/Makefile                               |    3 +-
> >   drivers/phy/phy-exynos-dp-video.c                  |  122 ++++++++++++++++++++
> >   4 files changed, 139 insertions(+), 1 deletion(-)
> >   create mode 100644 Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> >   create mode 100644 drivers/phy/phy-exynos-dp-video.c
> >
> > diff --git a/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> > b/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> > new file mode 100644
> > index 0000000..d1771ef
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
> > @@ -0,0 +1,7 @@
> > +Samsung EXYNOS SoC series DP PHY
> > +-------------------------------------------------
> > +
> > +Required properties:
> > +- compatible : should be "samsung,exynos5250-dp-video-phy";
> > +- reg : offset and length of the DP PHY register set;
> > +- #phy-cells : from the generic phy bindings, must be 0;
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index 5f85909..6d10e3b 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -11,3 +11,11 @@ menuconfig GENERIC_PHY
> >   	  devices present in the kernel. This layer will have the generic
> >   	  API by which phy drivers can create PHY using the phy framework and
> >   	  phy users can obtain reference to the PHY.
> > +
> > +if GENERIC_PHY
> > +
> > +config PHY_EXYNOS_DP_VIDEO
> > +	tristate "EXYNOS SoC series DP PHY driver"
> > +	help
> > +	  Support for DP PHY found on Samsung EXYNOS SoCs.
> > +endif
> > diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> > index 9e9560f..d8d861c 100644
> > --- a/drivers/phy/Makefile
> > +++ b/drivers/phy/Makefile
> > @@ -2,4 +2,5 @@
> >   # Makefile for the phy drivers.
> >   #
> >
> > -obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
> > +obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> > +obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
> > diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
> > new file mode 100644
> > index 0000000..9a3d6f1
> > --- /dev/null
> > +++ b/drivers/phy/phy-exynos-dp-video.c
> > @@ -0,0 +1,122 @@
> > +/*
> > + * Samsung EXYNOS SoC series DP PHY driver
> > + *
> > + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > + * Author: Jingoo Han <jg1.han@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/spinlock.h>
> > +
> > +/* DPTX_PHY_CONTROL register */
> > +#define EXYNOS_DPTX_PHY_ENABLE		(1 << 0)
> > +
> > +struct exynos_dp_video_phy {
> > +	spinlock_t slock;
> 
> I think spinlock is not needed at all since the PHY ops is already protected
> by a mutex.

Yes, you're right.
Only one PHY object access the control register; thus,
there is no need to add spinlock.
I will remove it.


> > +	struct phy *phys;
> 
> _phys_ no longer need to part of this structure.

OK, I see.
'struct phy' is only used at exynos_dp_video_phy_probe().
So, I will remove 'struct phy *phys' from 'struct exynos_dp_video_phy'.

Thank you for your comment.

Best regards,
Jingoo Han

> > +	void __iomem *regs;
> > +};
> 
> Thanks
> Kishon

