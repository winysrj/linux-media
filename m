Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47312 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3CDJZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:25:22 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so3859022wgb.13
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 01:25:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <02cb33521404120c6c8262187514fd9b3ec3eab3.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
 <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl> <02cb33521404120c6c8262187514fd9b3ec3eab3.1362387265.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 4 Mar 2013 14:54:59 +0530
Message-ID: <CA+V-a8vn1BOF_Nd74d1_BrvSophAihyTiznOb3TWU+3cPbFqgQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 08/11] davinci/vpbe_display: remove deprecated current_norm.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch!

On Mon, Mar 4, 2013 at 2:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Since vpbe_display already provides a g_std op setting current_norm
> didn't do anything. Remove that code.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/platform/davinci/vpbe_display.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 1f59955..a9e90b0 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1176,10 +1176,6 @@ vpbe_display_s_dv_timings(struct file *file, void *priv,
>                         "Failed to set the dv timings info\n");
>                 return -EINVAL;
>         }
> -       /* set the current norm to zero to be consistent. If STD is used
> -        * v4l2 layer will set the norm properly on successful s_std call
> -        */
> -       layer->video_dev.current_norm = 0;
>
>         return 0;
>  }
> @@ -1693,12 +1689,8 @@ static int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
>         vbd->vfl_dir    = VFL_DIR_TX;
>
>         if (disp_dev->vpbe_dev->current_timings.timings_type &
> -                       VPBE_ENC_STD) {
> +                       VPBE_ENC_STD)
>                 vbd->tvnorms = (V4L2_STD_525_60 | V4L2_STD_625_50);
> -               vbd->current_norm =
> -                       disp_dev->vpbe_dev->current_timings.std_id;
> -       } else
> -               vbd->current_norm = 0;
>
>         snprintf(vbd->name, sizeof(vbd->name),
>                         "DaVinci_VPBE Display_DRIVER_V%d.%d.%d",
> --
> 1.7.10.4
>
