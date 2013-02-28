Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52057 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3B1W0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 17:26:46 -0500
Date: Thu, 28 Feb 2013 22:26:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, jy0922.shim@samsung.com,
	patches@linaro.org, l.krishna@samsung.com, joshi@samsung.com,
	dri-devel@lists.freedesktop.org, inki.dae@samsung.com,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v9 2/2] video: drm: exynos: Add pinctrl support to fimd
Message-ID: <20130228222612.GE17833@n2100.arm.linux.org.uk>
References: <1362024762-28406-1-git-send-email-vikas.sajjan@linaro.org> <1362024762-28406-3-git-send-email-vikas.sajjan@linaro.org> <512FD44D.1070408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512FD44D.1070408@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 28, 2013 at 11:03:57PM +0100, Sylwester Nawrocki wrote:
> Please just use IS_ERR(), let's stop this IS_ERR_OR_NULL() insanity.

Yes, indeed.

On that topic (and off-topic for this thread, sorry) I've committed
a set of patches to remove most users of IS_ERR_OR_NULL() from arch/arm.
These are the last remaining ones there - and I don't want to see any
more appearing:

arch/arm/plat-samsung/clock.c:	if (IS_ERR_OR_NULL(clk))
arch/arm/plat-samsung/clock.c:	if (!IS_ERR_OR_NULL(clk) && clk->ops && clk->ops->round_rate)
arch/arm/plat-samsung/clock.c:	if (IS_ERR_OR_NULL(clk))
arch/arm/plat-samsung/clock.c:	if (IS_ERR_OR_NULL(clk) || IS_ERR_OR_NULL(parent))
arch/arm/mach-imx/devices/platform-ipu-core.c:	if (IS_ERR_OR_NULL(imx_ipu_coredev))
arch/arm/mach-imx/devices/platform-ipu-core.c:	if (IS_ERR_OR_NULL(imx_ipu_coredev))
arch/arm/kernel/smp_twd.c:		 * We use IS_ERR_OR_NULL() here, because if the clock stubs
arch/arm/kernel/smp_twd.c:		if (!IS_ERR_OR_NULL(twd_clk))

They currently all legal uses of it - though I'm sure that the samsung
clock uses can be reduced to just IS_ERR().  The IMX use looks "valid"
in that imx_ipu_coredev really can be an error pointer (on failure) or
NULL if the platform device hasn't yet been created.  The TWD one is
explained in the comments in the code (if people had to write explanations
for using IS_ERR_OR_NULL(), we'd probably have it used correctly!)
