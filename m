Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:52529 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaCKHMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:12:49 -0400
Received: by mail-vc0-f169.google.com with SMTP id ik5so170424vcb.14
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:12:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-25-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-25-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:42:28 +0530
Message-ID: <CA+V-a8uZJv0BXN0=C2T=4M097u6atDvs+aud5J+c5RMP-Dux9A@mail.gmail.com>
Subject: Re: [PATCH v2 24/48] tvp7002: Remove deprecated video-level DV
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
>  drivers/media/i2c/tvp7002.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 9f56fd5..fa901a9 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -926,7 +926,6 @@ static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
>  static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
>         .g_dv_timings = tvp7002_g_dv_timings,
>         .s_dv_timings = tvp7002_s_dv_timings,
> -       .enum_dv_timings = tvp7002_enum_dv_timings,
>         .query_dv_timings = tvp7002_query_dv_timings,
>         .s_stream = tvp7002_s_stream,
>         .g_mbus_fmt = tvp7002_mbus_fmt,
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
