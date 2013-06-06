Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37521 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3FFGYe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 02:24:34 -0400
Received: by mail-ob0-f174.google.com with SMTP id wd20so4060676obb.19
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 23:24:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370005408-10853-5-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-5-git-send-email-arun.kk@samsung.com>
Date: Thu, 6 Jun 2013 11:54:33 +0530
Message-ID: <CAK9yfHxRtY=s42TpiPrWeb-+gbtoY9tp30x-u3TvdwXwyQu31g@mail.gmail.com>
Subject: Re: [RFC v2 04/10] exynos5-fimc-is: Adds the register definition and
 context header
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
> This patch adds the register definition file for the fimc-is driver
> and also the header file containing the main context for the driver.
>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> ---
>  drivers/media/platform/exynos5-is/fimc-is-regs.h |  107 +++++++++++++++
>  drivers/media/platform/exynos5-is/fimc-is.h      |  151 ++++++++++++++++++++++
>  2 files changed, 258 insertions(+)
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-regs.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-regs.h b/drivers/media/platform/exynos5-is/fimc-is-regs.h
> new file mode 100644
> index 0000000..d00df7b
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-regs.h
> @@ -0,0 +1,107 @@
> +/*
> + * Samsung Exynos5 SoC series FIMC-IS driver
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
> + * Arun Kumar K <arun.kk@samsung.com>
> + * Kil-yeon Lim <kilyeon.im@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_REGS_H
> +#define FIMC_IS_REGS_H
> +
> +#include <mach/map.h>

Why do you need this?


-- 
With warm regards,
Sachin
