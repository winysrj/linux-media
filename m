Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46858 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3CEMRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 07:17:10 -0500
Received: by mail-wg0-f50.google.com with SMTP id es5so5663017wgb.5
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2013 04:17:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362484334-18804-1-git-send-email-sachin.kamat@linaro.org>
References: <1362484334-18804-1-git-send-email-sachin.kamat@linaro.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 5 Mar 2013 17:46:46 +0530
Message-ID: <CA+V-a8vwiXk+0AcRgRRdOP-qbKrsDKFNQ4DKm+fTGgTSiiwn7g@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] davinci_vpfe: Use module_platform_driver macro
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	prabhakar.lad@ti.com, manjunath.hadli@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch!

On Tue, Mar 5, 2013 at 5:22 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> module_platform_driver() eliminates the boilerplate and simplifies
> the code.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar Lad

> ---
>  .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   20 +-------------------
>  1 files changed, 1 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> index 7b35171..c7ae7d7 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> @@ -719,22 +719,4 @@ static struct platform_driver vpfe_driver = {
>         .remove = vpfe_remove,
>  };
>
> -/**
> - * vpfe_init : This function registers device driver
> - */
> -static __init int vpfe_init(void)
> -{
> -       /* Register driver to the kernel */
> -       return platform_driver_register(&vpfe_driver);
> -}
> -
> -/**
> - * vpfe_cleanup : This function un-registers device driver
> - */
> -static void vpfe_cleanup(void)
> -{
> -       platform_driver_unregister(&vpfe_driver);
> -}
> -
> -module_init(vpfe_init);
> -module_exit(vpfe_cleanup);
> +module_platform_driver(vpfe_driver);
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
