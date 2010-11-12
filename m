Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:49376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KLQDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 11:03:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/10] ux500: MCDE: Add platform specific data
Date: Fri, 12 Nov 2010 17:03:52 +0100
Cc: Jimmy Rubin <jimmy.rubin@stericsson.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-10-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-11-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-11-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121703.52422.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 10 November 2010, Jimmy Rubin wrote:
> +
> +	if (ddev->id == PRIMARY_DISPLAY_ID && rotate_main) {
> +		swap(width, height);
> +#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY_ROTATE_180_DEGREES
> +		rotate = FB_ROTATE_CCW;
> +#else
> +		rotate = FB_ROTATE_CW;
> +#endif
> +	}
> +
> +	virtual_width = width;
> +	virtual_height = height * 2;
> +#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY_AUTO_SYNC
> +	if (ddev->id == PRIMARY_DISPLAY_ID)
> +		virtual_height = height;
> +#endif
> +

The contents of the hardware description should really not
be configuration dependent, because that breaks booting the same
kernel on machines that have different requirements.

This is something that should be passed down from the boot loader.

> +static void mcde_epod_enable(void)
> +{
> +	/* Power on DSS mem */
> +	writel(PRCMU_ENABLE_DSS_MEM, PRCM_EPOD_C_SET);
> +	mdelay(PRCMU_MCDE_DELAY);
> +	/* Power on DSS logic */
> +	writel(PRCMU_ENABLE_DSS_LOGIC, PRCM_EPOD_C_SET);
> +	mdelay(PRCMU_MCDE_DELAY);
> +}

In general, try to avoid using mdelay. Keeping the CPU busy for miliseconds
or even microseconds for no reason is just wrong.

Reasonable hardware will not require this and do the right thing anyway.
multiple writel calls are by design strictly ordered on the bus. If that is
not the case on your hardware, you should find a proper way to ensure
ordering and create a small wrapper for it with a comment that explains
the breakage. Better get the hardware designers to fix their crap before
releasing a product ;-)

If there is not even a way to reorder I/O by accessing other registers,
use msleep() to let the CPU do something useful in the meantime and complain
even more to the HW people.

	Arnd
