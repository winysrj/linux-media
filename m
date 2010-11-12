Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:63089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0KLQ2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 11:28:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/10] MCDE: Add frame buffer device
Date: Fri, 12 Nov 2010 17:29:28 +0100
Cc: Jimmy Rubin <jimmy.rubin@stericsson.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-8-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-9-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-9-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121729.28354.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 10 November 2010, Jimmy Rubin wrote:
> +
> +static struct platform_device mcde_fb_device = {
> +	.name = "mcde_fb",
> +	.id = -1,
> +};

Do not introduce new static devices. We are trying to remove them and
they will stop working. Why do you even need a device here if there is
only one of them?

> +struct fb_info *mcde_fb_create(struct mcde_display_device *ddev,
> +	u16 w, u16 h, u16 vw, u16 vh, enum mcde_ovly_pix_fmt pix_fmt,
> +	u32 rotate)
> +{

Here you have another device, which you could just use!

> +/* Overlay fbs' platform device */
> +static int mcde_fb_probe(struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +
> +static int mcde_fb_remove(struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +
> +static struct platform_driver mcde_fb_driver = {
> +	.probe  = mcde_fb_probe,
> +	.remove = mcde_fb_remove,
> +	.driver = {
> +		.name  = "mcde_fb",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +/* MCDE fb init */
> +
> +int __init mcde_fb_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_driver_register(&mcde_fb_driver);
> +	if (ret)
> +		goto fb_driver_failed;
> +	ret = platform_device_register(&mcde_fb_device);
> +	if (ret)
> +		goto fb_device_failed;
> +
> +	goto out;
> +fb_device_failed:
> +	platform_driver_unregister(&mcde_fb_driver);
> +fb_driver_failed:
> +out:
> +	return ret;
> +}
> +
> +void mcde_fb_exit(void)
> +{
> +	platform_device_unregister(&mcde_fb_device);
> +	platform_driver_unregister(&mcde_fb_driver);
> +}

This appears to be an entirely useless registration for something that
does not exist and that you are not using anywhere ...

> +
> +#include <linux/fb.h>
> +#include <linux/ioctl.h>
> +#if !defined(__KERNEL__) && !defined(_KERNEL)
> +#include <stdint.h>
> +#else
> +#include <linux/types.h>
> +#endif
> +
> +#ifdef __KERNEL__
> +#include "mcde_dss.h"
> +#endif
> +
> +#ifdef __KERNEL__
> +#define to_mcde_fb(x) ((struct mcde_fb *)(x)->par)

Everything in this file is enclosed in #ifdef __KERNEL__, and the file
is not even exported. You can remove the #ifdef and the #else path
everywhere AFAICT.

	Arnd
