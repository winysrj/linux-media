Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:41268 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3DAIvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 04:51:17 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so1813208oag.18
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 01:51:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1364805830-6129-1-git-send-email-vikas.sajjan@linaro.org>
References: <1364805830-6129-1-git-send-email-vikas.sajjan@linaro.org>
Date: Mon, 1 Apr 2013 14:21:16 +0530
Message-ID: <CAKohpo=az=FS6-jfjN0WR=eKSAZ=MSo90Qc91kK-PEWOH3tzsQ@mail.gmail.com>
Subject: Re: [PATCH v3] drm/exynos: enable FIMD clocks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	jy0922.shim@samsung.com, inki.dae@samsung.com,
	kgene.kim@samsung.com, linaro-kernel@lists.linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1 April 2013 14:13, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> While migrating to common clock framework (CCF), found that the FIMD clocks

s/found/we found/

> were pulled down by the CCF.
> If CCF finds any clock(s) which has NOT been claimed by any of the
> drivers, then such clock(s) are PULLed low by CCF.
>
> By calling clk_prepare_enable() for FIMD clocks fixes the issue.

s/By calling/Calling/

and

s/the/this

> this patch also replaces clk_disable() with clk_disable_unprepare()

s/this/This

> during exit.

Sorry but your log doesn't say what you are doing. You are just adding
relevant calls to clk_prepare/unprepare() before calling clk_enable/disable.

> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
> Changes since v2:
>         - moved clk_prepare_enable() and clk_disable_unprepare() from
>         fimd_probe() to fimd_clock() as suggested by Inki Dae <inki.dae@samsung.com>
> Changes since v1:
>         - added error checking for clk_prepare_enable() and also replaced
>         clk_disable() with clk_disable_unprepare() during exit.
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 9537761..f2400c8 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -799,18 +799,18 @@ static int fimd_clock(struct fimd_context *ctx, bool enable)
>         if (enable) {
>                 int ret;
>
> -               ret = clk_enable(ctx->bus_clk);
> +               ret = clk_prepare_enable(ctx->bus_clk);
>                 if (ret < 0)
>                         return ret;
>
> -               ret = clk_enable(ctx->lcd_clk);
> +               ret = clk_prepare_enable(ctx->lcd_clk);
>                 if  (ret < 0) {
> -                       clk_disable(ctx->bus_clk);
> +                       clk_disable_unprepare(ctx->bus_clk);
>                         return ret;
>                 }
>         } else {
> -               clk_disable(ctx->lcd_clk);
> -               clk_disable(ctx->bus_clk);
> +               clk_disable_unprepare(ctx->lcd_clk);
> +               clk_disable_unprepare(ctx->bus_clk);
>         }
>
>         return 0;
> @@ -981,8 +981,8 @@ static int fimd_remove(struct platform_device *pdev)
>         if (ctx->suspended)
>                 goto out;
>
> -       clk_disable(ctx->lcd_clk);
> -       clk_disable(ctx->bus_clk);
> +       clk_disable_unprepare(ctx->lcd_clk);
> +       clk_disable_unprepare(ctx->bus_clk);

You are doing things at the right place but i have a suggestion. Are you doing
anything in your clk_prepare() atleast for this device? Probably not.

If not, then its better to call clk_prepare/unprepare only once at probe/remove
and keep clk_enable/disable calls as is.

--
viresh
