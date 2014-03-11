Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:44493 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaCKHOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:14:20 -0400
Received: by mail-vc0-f182.google.com with SMTP id ks9so2184802vcb.13
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:14:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-24-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-24-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:43:59 +0530
Message-ID: <CA+V-a8tLXAioZoGu5qUoJ6vTkuDhLgXLxejS+vP-1+MsA9T8Tg@mail.gmail.com>
Subject: Re: [PATCH v2 23/48] ths8200: Remove deprecated video-level DV
 timings operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The video enum_dv_timings and dv_timings_cap operations are deprecated
> and unused. Remove them.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  drivers/media/i2c/ths8200.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
> index c4ec8b2..656d889 100644
> --- a/drivers/media/i2c/ths8200.c
> +++ b/drivers/media/i2c/ths8200.c
> @@ -432,8 +432,6 @@ static const struct v4l2_subdev_video_ops ths8200_video_ops = {
>         .s_stream = ths8200_s_stream,
>         .s_dv_timings = ths8200_s_dv_timings,
>         .g_dv_timings = ths8200_g_dv_timings,
> -       .enum_dv_timings = ths8200_enum_dv_timings,
> -       .dv_timings_cap = ths8200_dv_timings_cap,
>  };
>
>  static const struct v4l2_subdev_pad_ops ths8200_pad_ops = {
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
