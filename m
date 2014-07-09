Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43068 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaGIER7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 00:17:59 -0400
Received: by mail-ve0-f176.google.com with SMTP id us18so2018357veb.7
        for <linux-media@vger.kernel.org>; Tue, 08 Jul 2014 21:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404824605-5872-1-git-send-email-j.anaszewski@samsung.com>
References: <1404824605-5872-1-git-send-email-j.anaszewski@samsung.com>
Date: Wed, 9 Jul 2014 09:47:58 +0530
Message-ID: <CALt3h7-Hqc=+_4H_3=V+x66E3YPggbX1OfGctv8o8RAPghLMdQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] s5p-mfc: Fix selective sclk_mfc init
From: Arun Kumar K <arun.kk@samsung.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Jul 8, 2014 at 6:33 PM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> fc906b6d "Remove special clock usage in driver" removed
> initialization of MFC special clock, arguing that there's
> no need to do it explicitly, since it's one of MFC gate clock's
> dependencies and gets enabled along with it. However, there's
> no promise of keeping this hierarchy across Exynos SoC
> releases, therefore this approach fails to provide a stable,
> portable solution.
>
> Out of all MFC versions, only v6 doesn't use special clock at all.
>
> Signed-off-by: Mateusz Zalega <m.zalega@samsung.com>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> index 11d5f1d..cc562fc 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> @@ -21,6 +21,8 @@
>  #include "s5p_mfc_pm.h"
>
>  #define MFC_GATE_CLK_NAME      "mfc"
> +#define MFC_CLK_NAME           "sclk-mfc"
> +#define MFC_CLK_RATE           (200 * 1000000)
>
>  #define CLK_DEBUG
>
> @@ -50,6 +52,23 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
>                 goto err_p_ip_clk;
>         }
>
> +       if (dev->variant->version != MFC_VERSION_V6) {
> +               pm->clock = clk_get(&dev->plat_dev->dev, MFC_CLK_NAME);
> +               if (IS_ERR(pm->clock)) {
> +                       mfc_err("Failed to get gating clock control\n");
> +                       ret = PTR_ERR(pm->clock);
> +                       goto err_s_clk;
> +               }
> +

Agree to your point above that some SoCs may have different hierarchy
which needs
to enable this clock explicitly. But other SoCs using v5, v7 and v8
still works fine
without this special clock and those DT nodes doesnt provide this clock now.
So I would suggest not to error return if the clock is not provided
and keep it as
an optional parameter to maintain backward compatibility. With this
current patch
all the working SoCs like 5420, 5800 etc will fail in probe.

Regards
Arun


> +               clk_set_rate(pm->clock, MFC_CLK_RATE);
> +               ret = clk_prepare_enable(pm->clock);
> +               if (ret) {
> +                       mfc_err("Failed to enable MFC core operating clock\n");
> +                       ret = PTR_ERR(pm->clock);
> +                       goto err_s_clk;
> +               }
> +       }
> +
>         atomic_set(&pm->power, 0);
>  #ifdef CONFIG_PM_RUNTIME
>         pm->device = &dev->plat_dev->dev;
> @@ -59,6 +78,9 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
>         atomic_set(&clk_ref, 0);
>  #endif
>         return 0;
> +
> +err_s_clk:
> +       clk_put(pm->clock);
>  err_p_ip_clk:
>         clk_put(pm->clock_gate);
>  err_g_ip_clk:
> @@ -67,6 +89,10 @@ err_g_ip_clk:
>
>  void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
>  {
> +       if (dev->variant->version != MFC_VERSION_V6) {
> +               clk_disable_unprepare(pm->clock);
> +               clk_put(pm->clock);
> +       }
>         clk_unprepare(pm->clock_gate);
>         clk_put(pm->clock_gate);
>  #ifdef CONFIG_PM_RUNTIME
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
