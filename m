Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46863 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2KTGmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 01:42:49 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5636411obb.19
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 22:42:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-QVvRuOFHz0nLKgShmJ383sNs4HD6vxMi4ym75c-q-Zg@mail.gmail.com>
References: <CAPgLHd-QVvRuOFHz0nLKgShmJ383sNs4HD6vxMi4ym75c-q-Zg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 20 Nov 2012 12:12:28 +0530
Message-ID: <CA+V-a8ubmO86-F5iOgw7q4+_irJqN+JhCAE4VazGPa_dajQtxw@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_capture: fix condition logic in vpif_capture.c
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, prabhakar.lad@ti.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Tue, Oct 30, 2012 at 7:15 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The pattern E == C1 && E == C2 is always false. This patch
> fix this according to the assumption that && should be ||.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
Applied to my tree with following commit message,
davinci: vpif_capture: fix return type check for v4l2_subdev_call()

The v4l2_subdev_call() call returns -ENODEV when subdev is
null and -ENOIOCTLCMD wnen no icotl is present.
This patch fixes the return type check for v4l2_subdev_call().

The pattern E == C1 && E == C2 is always false. This patch
fix this according to the assumption that && should be ||.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Regards,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index fcabc02..2d28a96 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1715,7 +1715,7 @@ vpif_enum_dv_timings(struct file *file, void *priv,
>         int ret;
>
>         ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
> -       if (ret == -ENOIOCTLCMD && ret == -ENODEV)
> +       if (ret == -ENOIOCTLCMD || ret == -ENODEV)
>                 return -EINVAL;
>         return ret;
>  }
> @@ -1735,7 +1735,7 @@ vpif_query_dv_timings(struct file *file, void *priv,
>         int ret;
>
>         ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
> -       if (ret == -ENOIOCTLCMD && ret == -ENODEV)
> +       if (ret == -ENOIOCTLCMD || ret == -ENODEV)
>                 return -ENODATA;
>         return ret;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
