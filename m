Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40167 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3F1IRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 04:17:36 -0400
Message-ID: <51CD4698.3070409@gmail.com>
Date: Fri, 28 Jun 2013 16:17:28 +0800
From: Hui Wang <jason77.wang@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kishon@ti.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, inki.dae@samsung.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com> <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2013 11:02 PM, Sylwester Nawrocki wrote:
> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
> receiver and MIPI DSI transmitter DPHYs.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v2:
>   - adapted to the generic PHY API v9: use phy_set/get_drvdata(),
>   - fixed of_xlate callback to return ERR_PTR() instead of NULL,
>   - namespace cleanup, put "GPL v2" as MODULE_LICENSE, removed pr_debug,
>   - removed phy id check in __set_phy_state().
> ---
[...]
> +
> +	if (IS_EXYNOS_MIPI_DSIM_PHY_ID(id))
> +		reset = EXYNOS_MIPI_PHY_MRESETN;
> +	else
> +		reset = EXYNOS_MIPI_PHY_SRESETN;
> +
> +	spin_lock_irqsave(&state->slock, flags);
Sorry for one stupid question here, why do you use spin_lock_irqsave() 
rather than spin_lock(),
I don't see the irq handler will use this spinlock anywhere in this c file.


Regards,
Hui.
> +	reg = readl(addr);
> +	if (on)
> +		reg |= reset;
> +	else
> +		reg &= ~reset;
> +	writel(reg, addr);
> +
> +	/* Clear ENABLE bit only if MRESETN, SRESETN bits are not set. */
> +	if (on)
> +		reg |= EXYNOS_MIPI_PHY_ENABLE;
> +	else if (!(reg & EXYNOS_MIPI_PHY_RESET_MASK))
> +		reg &= ~EXYNOS_MIPI_PHY_ENABLE;
> +
> +	writel(reg, addr);
> +	spin_unlock_irqrestore(&state->slock, flags);
> +	return 0;
> +}
>

