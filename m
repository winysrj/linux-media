Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52768 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3FRDje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 23:39:34 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so4354107oag.6
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 20:39:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371487371-31143-1-git-send-email-s.nawrocki@samsung.com>
References: <1371487371-31143-1-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 18 Jun 2013 09:09:33 +0530
Message-ID: <CAK9yfHxsNED-6Q8Kv=sO+D27q7LAfpfOn1y9Nutn9k-3YhUL-A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update S5P/Exynos FIMC driver entry
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Just a couple of nits inline.

On 17 June 2013 22:12, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> This change is mainly to update the driver's path changed from
> drivers/media/platform/s5p-fimc to drivers/media/platform/exynos4-is/.
> While at it, remove non-existent files rule, move the whole entry to
> the Samsung drivers section and add the patch tracking system URL.

How about adding git URL too (of your repo)?

>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  MAINTAINERS |   17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d7782b..d2c5618 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1153,15 +1153,6 @@ L:       linux-media@vger.kernel.org
>  S:     Maintained
>  F:     drivers/media/platform/s5p-g2d/
>
> -ARM/SAMSUNG S5P SERIES FIMC SUPPORT
> -M:     Kyungmin Park <kyungmin.park@samsung.com>
> -M:     Sylwester Nawrocki <s.nawrocki@samsung.com>
> -L:     linux-arm-kernel@lists.infradead.org
> -L:     linux-media@vger.kernel.org
> -S:     Maintained
> -F:     arch/arm/plat-samsung/include/plat/*fimc*
> -F:     drivers/media/platform/s5p-fimc/
> -
>  ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT

Probably ARM could be removed from here too and may be other places if
they exist just like below entry.

>  M:     Kyungmin Park <kyungmin.park@samsung.com>
>  M:     Kamil Debski <k.debski@samsung.com>
> @@ -6930,6 +6921,14 @@ F:       drivers/regulator/s5m*.c
>  F:     drivers/rtc/rtc-sec.c
>  F:     include/linux/mfd/samsung/
>
> +SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
> +M:     Kyungmin Park <kyungmin.park@samsung.com>
> +M:     Sylwester Nawrocki <s.nawrocki@samsung.com>
> +L:     linux-media@vger.kernel.org
> +Q:     https://patchwork.linuxtv.org/project/linux-media/list/
> +S:     Supported
> +F:     drivers/media/platform/exynos4-is/
> +

Considering alphabetical order (now that ARM is removed), this block
should come after
SAMSUNG S3C24XX/S3C64XX...

>  SAMSUNG S3C24XX/S3C64XX SOC SERIES CAMIF DRIVER
>  M:     Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>  L:     linux-media@vger.kernel.org
> --


-- 
With warm regards,
Sachin
