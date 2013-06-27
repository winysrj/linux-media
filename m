Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:21562 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3F0JpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 05:45:23 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: kishon@ti.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, dh09.lee@samsung.com,
	jg1.han@samsung.com, inki.dae@samsung.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com>
 <1372258946-15607-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372258946-15607-6-git-send-email-s.nawrocki@samsung.com>
Subject: RE: [PATCH v3 5/5] ARM: Samsung: Remove the MIPI PHY setup code
Date: Thu, 27 Jun 2013 18:34:09 +0900
Message-id: <085701ce7319$79b191a0$6d14b4e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester Nawrocki wrote:
> 
> Generic PHY drivers are used to handle the MIPI CSIS and MIPI DSIM
> DPHYs so we can remove now unused code at arch/arm/plat-samsung.
> In case there is any board file for S5PV210 platforms using MIPI
> CSIS/DSIM (not any upstream currently) it should use the generic
> PHY API to bind the PHYs to respective PHY consumer drivers and
> a platform device for the PHY provider should be defined.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/mach-exynos/include/mach/regs-pmu.h    |    5 --
>  arch/arm/mach-s5pv210/include/mach/regs-clock.h |    4 --
>  arch/arm/plat-samsung/Kconfig                   |    5 --
>  arch/arm/plat-samsung/Makefile                  |    1 -
>  arch/arm/plat-samsung/setup-mipiphy.c           |   60
---------------------
> --
>  5 files changed, 75 deletions(-)
>  delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
> 
Looks good, please feel free to add my ack on this,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
- Kukjin

