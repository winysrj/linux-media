Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48561 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2LCGCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 01:02:15 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so2308520oag.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 22:02:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-9LAbh_VvKsGZOy5tTtoHd1--TREKV=E9KUnc=DLkxng@mail.gmail.com>
References: <CAPgLHd-9LAbh_VvKsGZOy5tTtoHd1--TREKV=E9KUnc=DLkxng@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 3 Dec 2012 11:31:54 +0530
Message-ID: <CA+V-a8v7Gv9M3grc73OkjpW5F_Ohigqctwn=-MR=6PaVMeArpg@mail.gmail.com>
Subject: Re: [PATCH -next] [media] media: davinci: vpbe: return error code on
 error in vpbe_display_g_crop()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: manjunath.hadli@ti.com, prabhakar.lad@ti.com, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wei,

On Mon, Dec 3, 2012 at 8:20 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> We have assigned error code to 'ret' if crop->type is not
> V4L2_BUF_TYPE_VIDEO_OUTPUT, but never use it.
> We'd better return the error code on this error.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> ---
>  drivers/media/platform/davinci/vpbe_display.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 2bfde79..119a100 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -791,7 +791,6 @@ static int vpbe_display_g_crop(struct file *file, void *priv,
>         struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
>         struct osd_state *osd_device = fh->disp_dev->osd_device;
>         struct v4l2_rect *rect = &crop->c;
> -       int ret;
>
>         v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
>                         "VIDIOC_G_CROP, layer id = %d\n",
> @@ -799,7 +798,7 @@ static int vpbe_display_g_crop(struct file *file, void *priv,
>
>         if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
>                 v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buf type\n");
> -               ret = -EINVAL;
> +               return -EINVAL;
>         }
>         osd_device->ops.get_layer_config(osd_device,
>                                 layer->layer_info.id, cfg);
>
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
