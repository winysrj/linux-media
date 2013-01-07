Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36527 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3AGFzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 00:55:44 -0500
Received: by mail-wg0-f48.google.com with SMTP id dt10so9323519wgb.27
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 21:55:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-f6x_m-yi-Ki0hNV=7NsOG1rarmRcwDe8Kp+yEFJw4TQ@mail.gmail.com>
References: <CAPgLHd-f6x_m-yi-Ki0hNV=7NsOG1rarmRcwDe8Kp+yEFJw4TQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 7 Jan 2013 11:19:46 +0530
Message-ID: <CA+V-a8tii=RCFbaWWGYP3jdz9X=4mfedPGKo8A3nwP_os53wng@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci: vpbe: fix missing unlock on error in vpbe_initialize()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Thanks for the patch.

On Mon, Oct 22, 2012 at 11:06 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing unlock on the error handling path in function
> vpbe_initialize().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

> ---
> no test
> ---
>  drivers/media/platform/davinci/vpbe.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 69d7a58..875e63d 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -632,8 +632,10 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>
>         err = bus_for_each_dev(&platform_bus_type, NULL, vpbe_dev,
>                                platform_device_get);
> -       if (err < 0)
> -               return err;
> +       if (err < 0) {
> +               ret = err;
> +               goto fail_dev_unregister;
> +       }
>
>         vpbe_dev->venc = venc_sub_dev_init(&vpbe_dev->v4l2_dev,
>                                            vpbe_dev->cfg->venc.module_name);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
