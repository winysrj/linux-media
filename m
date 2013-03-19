Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55260 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3CSL5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 07:57:15 -0400
Received: by mail-oa0-f51.google.com with SMTP id h2so334909oag.24
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 04:57:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363687193-30893-1-git-send-email-vikas.sajjan@linaro.org>
References: <1363687193-30893-1-git-send-email-vikas.sajjan@linaro.org>
Date: Tue, 19 Mar 2013 17:27:15 +0530
Message-ID: <CAK9yfHws6SMuYJN6Vw9MLWf_USK13GHRdtW+e1H8XH4oDDJd=A@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: enable FIMD clocks
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, joshi@samsung.com, inki.dae@samsung.com,
	linaro-kernel@lists.linaro.org, jy0922.shim@samsung.com,
	linux-samsung-soc@vger.kernel.org, thomas.abraham@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 March 2013 15:29, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> While migrating to common clock framework (CCF), found that the FIMD clocks
> were pulled down by the CCF.
> If CCF finds any clock(s) which has NOT been claimed by any of the
> drivers, then such clock(s) are PULLed low by CCF.
>
> By calling clk_prepare_enable() for FIMD clocks fixes the issue.
>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 9537761..d93dd8a 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -934,6 +934,9 @@ static int fimd_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> +       clk_prepare_enable(ctx->lcd_clk);
> +       clk_prepare_enable(ctx->bus_clk);
> +

You also need to do clk_disable_unprepare during exit.
