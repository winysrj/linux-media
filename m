Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:39756 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaCKHPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:15:53 -0400
Received: by mail-ve0-f176.google.com with SMTP id cz12so8126122veb.35
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:15:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-16-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-16-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:45:32 +0530
Message-ID: <CA+V-a8vG-_7hzWKS=zGn2S3nNi=S6c+Xc-raC7d1MYUpavxOaw@mail.gmail.com>
Subject: Re: [PATCH v2 15/48] media: davinci: vpif: Switch to pad-level DV operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The video-level enum_dv_timings and dv_timings_cap operations are
> deprecated in favor of the pad-level versions. All subdev drivers
> implement the pad-level versions, switch to them.
>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  drivers/media/platform/davinci/vpif_capture.c | 4 +++-
>  drivers/media/platform/davinci/vpif_display.c | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index cd6da8b..16a1958 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1723,7 +1723,9 @@ vpif_enum_dv_timings(struct file *file, void *priv,
>         struct channel_obj *ch = fh->channel;
>         int ret;
>
> -       ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
> +       timings->pad = 0;
> +
> +       ret = v4l2_subdev_call(ch->sd, pad, enum_dv_timings, timings);
>         if (ret == -ENOIOCTLCMD || ret == -ENODEV)
>                 return -EINVAL;
>         return ret;
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index fd68236..e1edefe 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1380,7 +1380,9 @@ vpif_enum_dv_timings(struct file *file, void *priv,
>         struct channel_obj *ch = fh->channel;
>         int ret;
>
> -       ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
> +       timings->pad = 0;
> +
> +       ret = v4l2_subdev_call(ch->sd, pad, enum_dv_timings, timings);
>         if (ret == -ENOIOCTLCMD || ret == -ENODEV)
>                 return -EINVAL;
>         return ret;
> --
> 1.8.3.2
>
