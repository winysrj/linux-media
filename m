Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63992 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2KTGkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 01:40:07 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5635027obb.19
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 22:40:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-p6=0ay8ZKJ=sNzyS5C6x0dJTH=EO1SqwiYciO2gTUJg@mail.gmail.com>
References: <CAPgLHd-p6=0ay8ZKJ=sNzyS5C6x0dJTH=EO1SqwiYciO2gTUJg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 20 Nov 2012 12:09:44 +0530
Message-ID: <CA+V-a8sCnBpOfiwQ719xdri6qdQdEab+dRSoHJ_h2kM3F2cdsQ@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_display: fix condition logic in vpif_enum_dv_timings()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, prabhakar.lad@ti.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Tue, Oct 30, 2012 at 7:19 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
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
>  drivers/media/platform/davinci/vpif_display.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
Applied to my tree with following commit message,

davinci: vpif_display: fix return type check for v4l2_subdev_call()

The v4l2_subdev_call() call returns -ENODEV when subdev is
null and -ENOIOCTLCMD wnen no icotl is present.
This patch fixes the return type check for v4l2_subdev_call().

The pattern E == C1 && E == C2 is always false. This patch
fix this according to the assumption that && should be ||.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Regards,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index b716fbd..977ee43 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1380,7 +1380,7 @@ vpif_enum_dv_timings(struct file *file, void *priv,
>         int ret;
>
>         ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
> -       if (ret == -ENOIOCTLCMD && ret == -ENODEV)
> +       if (ret == -ENOIOCTLCMD || ret == -ENODEV)
>                 return -EINVAL;
>         return ret;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
