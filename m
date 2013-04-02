Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35666 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab3DBFR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 01:17:58 -0400
Received: by mail-wg0-f42.google.com with SMTP id k13so2736361wgh.1
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 22:17:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363171939-9672-1-git-send-email-vikas.sajjan@linaro.org>
References: <1363171939-9672-1-git-send-email-vikas.sajjan@linaro.org>
Date: Tue, 2 Apr 2013 10:47:57 +0530
Message-ID: <CAGm_ybjbui9YEPpjg8qFz0pGxYiHAdubAC7nbgH_Fr8JnUmoNw@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: change the method for getting the interrupt
 resource of FIMD
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: inki.dae@samsung.com
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, joshi@samsung.com, jy0922.shim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr. Inki Dae,

Can you please review this patch.?

On Wed, Mar 13, 2013 at 4:22 PM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> Replaces the "platform_get_resource() for IORESOURCE_IRQ" with
> platform_get_resource_byname().
> Both in exynos4 and exynos5, FIMD IP has 3 interrupts in the order: "fifo",
> "vsync", and "lcd_sys".
> But The FIMD driver expects the "vsync" interrupt to be mentioned as the
> 1st parameter in the FIMD DT node. So to meet this expectation of the
> driver, the FIMD DT node was forced to be made by keeping "vsync" as the
> 1st paramter.
> For example in exynos4, the FIMD DT node has interrupt numbers
> mentioned as <11, 1> <11, 0> <11, 2> keeping "vsync" as the 1st paramter.
>
> This patch fixes the above mentioned "hack" of re-ordering of the
> FIMD interrupt numbers by getting interrupt resource of FIMD by using
> platform_get_resource_byname().
>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 1ea173a..cd79d38 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -945,7 +945,7 @@ static int fimd_probe(struct platform_device *pdev)
>                 return -ENXIO;
>         }
>
> -       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +       res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "vsync");
>         if (!res) {
>                 dev_err(dev, "irq request failed.\n");
>                 return -ENXIO;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
